Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1GGHyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:54:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab1GGHyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:54:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 1/6 v8] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Thu, 7 Jul 2011 09:54:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20110706123417.GA25400@n2100.arm.linux.org.uk> <CABjd4Yxc_jRi563CHg+G7ekTHT40sTxgRUoL68bSke7oh8JVpg@mail.gmail.com>
In-Reply-To: <CABjd4Yxc_jRi563CHg+G7ekTHT40sTxgRUoL68bSke7oh8JVpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107070954.00419.arnd@arndb.de>
X-Provags-ID: V02:K0:IlDUECvVS5OrB+ApyDJeJfK0vFMd9fYMVqBC1fhJXTW
 c7WTV8kldw3Q/a4IZt1vYJaN2GBMNKROzkMMizm9wrf+WQ8CFB
 E+H79S787SkdAytMnkjdwFkAfdIc2GsaezCbROqpCU0GITho6n
 GYk9EDqNS8k+VMgNpHuTypMSldwpygD2RpEg1JEs5H/FDmb/HD
 RlFOulMy7sC12lATTgC5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 July 2011 09:13:26 Alexey Charkov wrote:
> >> diff --git a/arch/arm/mach-vt8500/include/mach/io.h b/arch/arm/mach-vt8500/include/mach/io.h
> >> new file mode 100644
> >> index 0000000..8dd55c8
> >> --- /dev/null
> >> +++ b/arch/arm/mach-vt8500/include/mach/io.h
> >> +#ifndef __ASM_ARM_ARCH_IO_H
> >> +#define __ASM_ARM_ARCH_IO_H
> >> +
> >> +#define IO_SPACE_LIMIT 0xffff
> >> +
> >> +#define __io(a)              ((void __iomem *)((a) + 0xf0000000))
> >> +#define __mem_pci(a) (a)
> >
> > Can you explain why you seem to have PCI IO space, yet don't have CONFIG_PCI
> > selected?  Do you have any drivers which use this space without CONFIG_PCI=y?
> 
> We have not yet created support for the PCI bridge (or even verified
> its existence on the chip). These numbers are derived bit by bit from
> vendor-published kernel sources and rather intended as a reference in
> case somebody wishes to try and implement PCI support.
> 
> All the peripherals on these chips that I know of are statically
> mapped platform devices programmed via MMIO registers. There may be
> some boards which have support for external PCI devices, but I haven't
> seen them.

Actually, we did discuss this when I first reviewed your patches. FWIW,
WM8505, WM8510 and VT8500 don't seem to have PCI, but VT8430 has PCI,
according to the data sheet and the patch provided by VIA.

What made this a little hard to understand is the way that VIA provided
an emulated PCI bus even on those platforms that didn't have the hardware,
apparently because it didn't occur to them to add platform device
support to the network driver (via velocity, iirc). They just faked a
configuration space for the USB and network devices to make them work
with the regular PCI drivers.

	Arnd
