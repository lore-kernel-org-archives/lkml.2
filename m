Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0FGVnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:43:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925Ab0FGVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:43:46 -0400
Date: Mon, 7 Jun 2010 14:38:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Woodhouse <dwmw2@infradead.org>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
In-Reply-To: <20100607213310.GO31073@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006071436160.4506@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie> <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org> <20100607182640.GL31073@ZenIV.linux.org.uk> <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
 <1275939165.17903.5100.camel@macbook.infradead.org> <alpine.LFD.2.00.1006071409320.4506@i5.linux-foundation.org> <20100607213310.GO31073@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Al Viro wrote:

> On Mon, Jun 07, 2010 at 02:17:23PM -0700, Linus Torvalds wrote:
> > 	jffs2_clear_inode(inode);
> > 
> > into
> > 
> > 	make_bad_inode(inode);
> > 	iput(inode);
> > 
> > and that changelog doesn't really explain it either ("fix leak"? Ok, I can 
> > see the iput() fixing the leak - but you also did that jffs2_clear_inode() 
> > change, and that has no explanation what-so-ever.
> 
> The final iput() calls ->clear_inode() (jffs2_clear_inode in case of jffs2)
> and the inode has just been created, with no other in-core references
> existing.  Basically, that call was the only part of (required) iput() that
> _was_ done there ;-)
> 
> FWIW, what's happening around ->clear_inode()/->delete_inode()/->drop_inode()
> is a mess.  This leak got found when I'd been looking through that crap;
> results of sanitizing are in #evict_inode (vfs-2.6.git).  I'm going to shift
> that into for-next tomorrow, assuming it survives local beating.  For now
> I've just pulled jffs2-fixes in it...

Ok, a changelog like that would have been a good thing. Not that I usually 
care, but now that I'm in careful mode, I do end up looking at things like 
this, and a good changelog would have goen m uch further in convincing me 
that the "goto fail" changes really were just about fixing the leak, and 
that there wasn't some other change hidden in the same commit.

			Linus
