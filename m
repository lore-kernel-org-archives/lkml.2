Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1GBIjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 04:39:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1GBIjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 04:39:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc5
Date: Sat, 2 Jul 2011 10:38:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg> <201107020005.02075.arnd@arndb.de> <CAMjpGUcrZpqDwi8r+BmyDV29-FcU9miJLv-dHGjUYY_GLYLU8A@mail.gmail.com>
In-Reply-To: <CAMjpGUcrZpqDwi8r+BmyDV29-FcU9miJLv-dHGjUYY_GLYLU8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021038.33066.arnd@arndb.de>
X-Provags-ID: V02:K0:0xu4DqOcfE20NnUuGpSZk7Y2pqiBHfIPx6yOLk9nXti
 F0Q8W21mRHj2Is/RwNIy9uBJTQ6aSAK7iCc3LwnRalnHlQm1Bx
 Hg7dWvPhQTnTKLzqRm6P/FstsHOM6hkx/MhhuZrWzhyUAVEiiC
 Ugtc/kP0FoXQdcOpor4l5DU8ZV21nRqUVvPPJBREMW7nM3p7Vi
 Vam0HFPoDBOoW3O/yQmLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 01:15:16 Mike Frysinger wrote:
> 
> On Fri, Jul 1, 2011 at 18:05, Arnd Bergmann wrote:
> > --- a/kernel/resource.c
> > +++ b/kernel/resource.c
> > @@ -21,7 +21,7 @@
> >  #include <linux/pfn.h>
> >  #include <asm/io.h>
> >
> > -
> > +#ifdef IO_SPACE_LIMIT
> >  struct resource ioport_resource = {
> >        .name   = "PCI IO",
> >        .start  = 0,
> > @@ -29,6 +29,7 @@ struct resource ioport_resource = {
> >        .flags  = IORESOURCE_IO,
> >  };
> >  EXPORT_SYMBOL(ioport_resource);
> > +#endif
> 
> hmm, asm-generic/io.h unconditionally sets this to 0xffff.  should
> that depend on CONFIG_HAS_IOPORT ?

Yes, that's probably another small change we should do. Right now,
building without HAS_IOPORT is broken in little ways all over the
place, so I expect there will be more of these once we look in all
the places. Regarding asm-generic/io.h, we probably want to
conditionally disable large parts of it.

Thanks,

	Arnd
