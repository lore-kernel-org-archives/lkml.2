Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2AHXxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:53:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43033 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2AHXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:53:40 -0500
Date: Sun, 8 Jan 2012 23:53:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120108235338.GR23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120108235039.GQ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120108235039.GQ23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 11:50:40PM +0000, Al Viro wrote:

> WTF is ext4_symlink() doing in case of long symlinks?  Look:
>                 drop_nlink(inode);
>                 err = ext4_orphan_add(handle, inode);
>                 ext4_journal_stop(handle);
> [write symlink body]
>                 inc_nlink(inode);
>                 err = ext4_orphan_del(handle, inode);
> oh, I see...  The comment above that re deadlocks and inability to do that
> in a single transaction ;-/
> 
> OK, try this; that's equivalent to what they are doing and will not WARN_ON();
> I hadn't checked other filesystems for similar tricks yet, so this has a good
> chance of being incomplete.

... and sure enough, ext3 has the same piece of fun.
