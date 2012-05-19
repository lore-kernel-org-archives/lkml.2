Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab2ESDSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 23:18:13 -0400
Received: from mail1.windriver.com ([147.11.146.13]:51177 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab2ESDSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 23:18:12 -0400
Date: Fri, 18 May 2012 23:18:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Chris Metcalf <cmetcalf@tilera.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config file
Message-ID: <20120519031806.GA24697@windriver.com>
References: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com>
 <4FB6F28F.3090404@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB6F28F.3090404@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config file] On 18/05/2012 (Fri 21:08) Chris Metcalf wrote:

> On 5/18/2012 6:46 PM, Paul Gortmaker wrote:
> > To fix this:
> >
> > ~/git/linux-head$ make defconfig
> > *** Default configuration is based on 'tile_defconfig'
> > ***
> > *** Can't find default configuration "arch/tile/configs/tile_defconfig"!
> > ***
> > make[1]: *** [defconfig] Error 1
> > make: *** [defconfig] Error 2
> >
> > There is no need to use $ARCH in the tile/Makefile, since if we are
> > in there, we know ARCH must be tile.  Use the GX as the defconfig,
> > as that is what is used in linux-next.
> 
> No, the odd thing about arch/tile is that you must build it either as
> ARCH=tilepro or ARCH=tilegx.  There is no ARCH=tile.  So the $ARCH piece is
> actually correct.

That is interesting, since this is what I've been doing on any of my
tile builds right from the beginning.

PATH=/home/paul/tc/tilegx-x86_64/bin:$PATH
export CROSS_COMPILE=tilegx-unknown-linux-gnu-
export ARCH=tile

...and it works.  Aside from the defconfig thing I just reported.
It is the same boilerplate type of env. settings I use for arm, mips
and whatever other random thing I'm building.  I'm pretty sure I'm
not the only one who would make this assumption.  Actually I *know*
I am not the only one.  Here is a snippet from linux-next build:

/scratch/kisskb/prod/kisskb/kisskb3/backend/makewrap.py ARCH=tile
O=/scratch/kisskb/prod/kisskb/kisskb3/backend/build/linux-next_tilegx_defconfig_tilegx
CROSS_COMPILE=/opt/cross/gcc-4.6.2-nolibc/tilegx-linux/bin/tilegx-linux-
tilegx_defconfig

So maybe some validation on the ARCH value is in order if you really
don't want people doing this?

Paul.
--

> 
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> >
> > diff --git a/arch/tile/Makefile b/arch/tile/Makefile
> > index 5015144..89f2310 100644
> > --- a/arch/tile/Makefile
> > +++ b/arch/tile/Makefile
> > @@ -34,7 +34,7 @@ LIBGCC_PATH     := \
> >    $(shell $(CC) $(KBUILD_CFLAGS) $(KCFLAGS) -print-libgcc-file-name)
> >  
> >  # Provide the path to use for "make defconfig".
> > -KBUILD_DEFCONFIG := $(ARCH)_defconfig
> > +KBUILD_DEFCONFIG := tilegx_defconfig
> >  
> >  # Used as a file extension when useful, e.g. head_$(BITS).o
> >  # Not needed for (e.g.) "$(CC) -m32" since the compiler automatically
> 
> -- 
> Chris Metcalf, Tilera Corp.
> http://www.tilera.com
> 
