Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0FGS7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:59:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472Ab0FGS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:59:10 -0400
Date: Mon, 7 Jun 2010 11:53:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>
cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
In-Reply-To: <20100607182640.GL31073@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie> <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org> <20100607182640.GL31073@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Al Viro wrote:
> 
> Ho-hum...  Speaking of which, what about leak fixes?  There's a long-standing
> in-core inode leak in jffs2; basically, if you fail directory modification
> in symlink() et.al., you get a leaked inode and whinge at umount.  Found
> after -rc1, had been there since all the way back (similar bug in creat()
> had been fixed in 2003, mkdir()/mknod()/symlink() were not).  Fix sits in
> jffs2-fixes now...

I think a leak that is trivial easily falls under "security issue" as a 
potential DoS issue.

On the other hand, if it's not trivially fixed (say it needs big 
re-organizing of some locking or refcounting or whatever), and it's a 
really slow leak of a pretty small data structure, and is not triggered by 
normal users (say, you need to mount a filesystem or it needs some very 
specific timing), I think it falls under "we haven't seen in the previous 
five years, we might as well make sure the fix is tested in the next merge 
window".

So I think it's a judgement call.

> I can simply pull jffs2-fixes into vfs for-next (I need it in there for
> ->evict_inode() series), but I'd obviously prefer to just rebase it after
> it gets into mainline.

I seem to have a jffs2 pull request that I haven't yet processed, exactly 
because it wasn't clear. It's much bigger than I would have wished for, 
and it's not clear it's all regressions at all.

DavidW? It's

	 7 files changed, 107 insertions(+), 91 deletions(-)

and while that's in the size range that I didn't just reject it like the 
drm pull, I still do want to know if that's really just true major 
bugfixes and regressions. We already had a really bad -rc2 release due to 
a tiny and innocent-looking bugfix that turned out to be anything but. I 
do _not_ want to repeat that with -rc3, since I'll be gone.

			Linus
