Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0FGTkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:40:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39017 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0FGTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:40:52 -0400
Date: Mon, 7 Jun 2010 20:40:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20100607194047.GN31073@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
 <20100607182640.GL31073@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
 <1275939165.17903.5100.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275939165.17903.5100.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 08:32:45PM +0100, David Woodhouse wrote:
> The fix is fairly trivial. There's a "big" patch to fs/jffs2/dir.c which
> accounts for the bulk of my pull request, but if you look harder you'll
> see it's mostly just a bunch of removing 'return ret;' and adding 
> 'goto fail;' so the error cleanup happens properly.
> 
> Al pointed out a second problem at the same time, fixed by commit
> e72e6497 in the tree I asked you to pull. That involved adding an
> unlock_new_inode() to the same error paths that the first patch used.
> 
> Between the two bugs, I figured it was worth pushing the fixes for
> 2.6.35.
> 
> The third jffs2 patch in that tree is a fix for ctime semantics which is
> a two-liner. Again not a regression but worth fixing, and -stable
> fodder.
> 
> Al also pointed out that I could use iget_failed(), but I figured that
> cleanup could wait for 2.6.36.

BTW, if you put jffs2 stuff into a separate queue, I can just pull it
(and add iget_failed() conversion on top of that).  Not a problem...
