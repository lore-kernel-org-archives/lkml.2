Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0EYFCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:02:33 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:55133 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0EYFCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:02:31 -0400
Date: Tue, 25 May 2010 07:02:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Message-ID: <20100525050212.GA10218@merkur.ravnborg.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <20100524202204.GA9917@merkur.ravnborg.org> <4BFAF012.4060300@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFAF012.4060300@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is also several TILE specific options missing the TILE_ prefix.
> > Like:
> > config XGBE_MAIN
> > 	tristate "Tilera GBE/XGBE character device support"
> >
> > Drop this:
> > config XGBE_MAIN
> > 	tristate "Tilera GBE/XGBE character device support"
> >
> > It is better to test for the gcc version and disable the option
> > only in the cases where it is known to fail.
> >   
> 
> Is the "Drop this" comment a cut and paste bug?
Yep - sorry.

>  I'm guessing you were
> referring to CONFIG_WERROR, which enables -Werror support.  The problem
> is that whether or not you can use -Werror really depends on not just
> the kernel version and the gcc version, but very likely also what
> drivers you have enabled.  We always use it internally.  I could also
> just pull this out completely (and just force it into "make" externally
> within our external build process), or move it to a "generic" configure
> option.  In any case we can't just automate it, unfortunately.
As Arnd pointed out the drivers does not belong in the
arch/tile/* hirachy.
And we have some architectures that always uses -Werror unconditionally.
So for the arch part this way to deal with it should be safe.
And the more we can cover under -Werror the better.

I dunno how you best deal with the drivers.

> 
> > Do not mess with CC like this:
> > CC = $(CROSS_COMPILE)gcc
> >
> > I guess you had to do this to support:
> > LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`
> >
> > If you follow other archs you could do like this:
> > LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`
> >   
> 
> I'm guessing you meant like what h8300 does, "$(shell
> $(CROSS-COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)".  That
> seems reasonable.
Correct - you are good at guessing :-)

> > arch/tile/include/asm/spinlock.h
> > Please make this a one-liner when you uses the asm-generic version only.
> > Same goes for byteorder (which includes linux/byteorder/little_endian.h)
> >   
> 
> I'm not sure what you mean when you say to use the asm-generic version
> of spinlock.h, since it's not SMP-ready.  Also, I don't see an
> asm-generic/byteorder.h, so I'm puzzled there too.
What I wanted to say was that a header file that simply include
another header file then drop all the boilerplate stuff and
let the header file be a single line.
Both spinlock.h and byteorder.h matches this.

The other 15+ header files that simply include another
heder file you follow this style. So this is a small matter
of consistency.

> 
> > In your mail you did not say anything about the checkpatch status.
> > It is better that you make your code reasonable checkpatch clean _before_
> > merging. Then you will not be hit by a lot of janitorial patches doing so.
> >   
> 
> I ran checkpatch over everything I submitted.  There are many
> complaints, to be sure, but I did a first pass cleaning up everything
> that was plausible, so for example all the style issues were fixed, but
> things like some uses of volatile, some uses of init_MUTEX, etc., were
> not modified.  However, I think it's in decent shape from a checkpatch
> point of view.
Good. Please include this information in you next submission.

	Sam
