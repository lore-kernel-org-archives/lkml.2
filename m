Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0FGVXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:23:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab0FGVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:23:29 -0400
Date: Mon, 7 Jun 2010 14:17:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
In-Reply-To: <1275939165.17903.5100.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>  <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>  <20100607182640.GL31073@ZenIV.linux.org.uk>  <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
 <1275939165.17903.5100.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, David Woodhouse wrote:
> 
> The fix is fairly trivial. There's a "big" patch to fs/jffs2/dir.c which
> accounts for the bulk of my pull request, but if you look harder you'll
> see it's mostly just a bunch of removing 'return ret;' and adding 
> 'goto fail;' so the error cleanup happens properly.

So that's the part I'm worried about.

I'm going to be hardnosed, but I'm _not_ going to so hardnosed as to worry 
about some oneliner DocBook patch. It's not about being anal to quite that 
degree, that would be silly. But the dir.c change is what I end up 
worrying about.

It's not at all clear why it's good to change

	jffs2_clear_inode(inode);

into

	make_bad_inode(inode);
	iput(inode);

and that changelog doesn't really explain it either ("fix leak"? Ok, I can 
see the iput() fixing the leak - but you also did that jffs2_clear_inode() 
change, and that has no explanation what-so-ever.

So is this a safe thing that definitely fixes a serious bug? I am left 
with no good way to judge.

			Linus
