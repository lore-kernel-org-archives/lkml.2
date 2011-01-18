Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1AREoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:44:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54210 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1AREoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:44:20 -0500
Date: Tue, 18 Jan 2011 04:44:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] vfs - fix dentry ref count in do_lookup()
Message-ID: <20110118044414.GK22723@ZenIV.linux.org.uk>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
 <20110118040610.23109.32868.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118040610.23109.32868.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 12:06:10PM +0800, Ian Kent wrote:
> There is a ref count problem in fs/namei.c:do_lookup().
> 
> When walking in ref-walk mode, if follow_managed() returns a fail the
> reference held by path.dentry isn't dropped.

If we get to follow_managed(), we *are* in ref-walk mode.  Unconditionally.
Besided, that's path_put_conditional(), not dput() - we might have both
grabbed vfsmount on mountpoint crossing *AND* changed dentry.

Applied with modifications...

The rest applied as-is.
