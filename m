Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0FGS0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:26:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46656 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0FGS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:26:47 -0400
Date: Mon, 7 Jun 2010 19:26:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
Message-ID: <20100607182640.GL31073@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:00:51AM -0700, Linus Torvalds wrote:
> So please. Just make me a tree that has regression fixes _only_. I'm not 
> AT ALL interested in "it is useful to report the gpu temp". If it was so 
> useful, and if it was ready before the merge window, it should hav gone in 
> then. That clearly wasn't the case, so it's not going in now either.

Ho-hum...  Speaking of which, what about leak fixes?  There's a long-standing
in-core inode leak in jffs2; basically, if you fail directory modification
in symlink() et.al., you get a leaked inode and whinge at umount.  Found
after -rc1, had been there since all the way back (similar bug in creat()
had been fixed in 2003, mkdir()/mknod()/symlink() were not).  Fix sits in
jffs2-fixes now...

I can simply pull jffs2-fixes into vfs for-next (I need it in there for
->evict_inode() series), but I'd obviously prefer to just rebase it after
it gets into mainline.
