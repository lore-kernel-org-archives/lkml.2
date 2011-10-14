Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1JNSH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:07:59 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38346 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1JNSH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:07:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 14:07:57 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, ccross@android.com, swarren@nvidia.com,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH] ARM: mutually exclude ZBOOT_ROM and AUTO_ZRELADDR
In-reply-to: <201110141829.48634.arnd@arndb.de>
Message-id: <alpine.LFD.2.02.1110141405520.17040@xanadu.home>
References: <20111014071500.GP21648@n2100.arm.linux.org.uk>
 <1318607945-6807-1-git-send-email-olof@lixom.net>
 <201110141829.48634.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Arnd Bergmann wrote:

> On Friday 14 October 2011, Olof Johansson wrote:
> > This way platforms that want it can select AUTO_ZRELADDR without issues caused by
> > someone manually also enabling ZBOOT_ROM.
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 82973b2..2ad58e8 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1814,6 +1814,7 @@ config ZBOOT_ROM_BSS
> >  config ZBOOT_ROM
> >  	bool "Compressed boot loader in ROM/flash"
> >  	depends on ZBOOT_ROM_TEXT != ZBOOT_ROM_BSS
> > +	depends on !AUTO_ZRELADDR
> >  	help
> >  	  Say Y here if you intend to execute your compressed kernel image
> >  	  (zImage) directly from ROM or flash.  If unsure, say N.
> 
> Unfortunately, you cannot have it both ways:
> 
> arnd@ocdc-kvm:~/linux-arm$ make O=obj-tmp CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm  -sj20  menuconfig
> arch/arm/Kconfig:1761:error: recursive dependency detected!
> arch/arm/Kconfig:1761:  symbol ZBOOT_ROM depends on AUTO_ZRELADDR

Ah, right.

OK, like I said I'm reworking the whole thing, so the cheapest fix for 
the time being  is "select AUTO_ZRELADDR if !ZBOOT_ROM".


Nicolas
