Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2JWIsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:48:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33694 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2JWIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:48:09 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/32 v4] MIPS: Loongson 1B: use ehci-platform instead of ehci-ls1x.
Date: Tue, 23 Oct 2012 10:46:50 +0200
Message-ID: <36521520.iGJ91Agxac@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAJhJPsV5mFmOgU38ZpnYqUTNuOPmvRXjsf31XdFUqNOzsd_Edg@mail.gmail.com>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org> <1349701906-16481-4-git-send-email-florian@openwrt.org> <CAJhJPsV5mFmOgU38ZpnYqUTNuOPmvRXjsf31XdFUqNOzsd_Edg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kelvin,

On Tuesday 23 October 2012 16:13:01 Kelvin Cheung wrote:
> Thank Florian.
> It looks great.
> However, you forget to remove corresponding section in
> drivers/usb/host/ehci-hcd.c
> ...
> #ifdef CONFIG_MACH_LOONGSON1
> #include "ehci-ls1x.c"
> #define PLATFORM_DRIVER         ehci_ls1x_driver
> #endif

Indeed, my bad I will follow up with some fixes for this patchset anyway.
Thank you!

> ...
> 
> 2012/10/8 Florian Fainelli <florian@openwrt.org>
> 
> > The Loongson 1B EHCI driver does nothing more than what the EHCI platform
> > driver already does, so use the generic implementation.
> >
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > ---
> > Changes in v4:
> > - rebased against greg's latest usb-next
> >
> > No changes since v1
> >
> >  arch/mips/configs/ls1b_defconfig      |    1 +
> >  arch/mips/loongson1/common/platform.c |    8 +++++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/configs/ls1b_defconfig
> > b/arch/mips/configs/ls1b_defconfig
> > index 80cff8b..7eb7554 100644
> > --- a/arch/mips/configs/ls1b_defconfig
> > +++ b/arch/mips/configs/ls1b_defconfig
> > @@ -76,6 +76,7 @@ CONFIG_HID_GENERIC=m
> >  CONFIG_USB=y
> >  CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> >  CONFIG_USB_EHCI_HCD=y
> > +CONFIG_USB_EHCI_HCD_PLATFORM=y
> >  # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> >  CONFIG_USB_STORAGE=m
> >  CONFIG_USB_SERIAL=m
> > diff --git a/arch/mips/loongson1/common/platform.c
> > b/arch/mips/loongson1/common/platform.c
> > index e92d59c..2874bf2 100644
> > --- a/arch/mips/loongson1/common/platform.c
> > +++ b/arch/mips/loongson1/common/platform.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/phy.h>
> >  #include <linux/serial_8250.h>
> >  #include <linux/stmmac.h>
> > +#include <linux/usb/ehci_pdriver.h>
> >  #include <asm-generic/sizes.h>
> >
> >  #include <loongson1.h>
> > @@ -107,13 +108,18 @@ static struct resource ls1x_ehci_resources[] = {
> >         },
> >  };
> >
> > +static struct usb_ehci_pdata ls1x_ehci_pdata = {
> > +       .port_power_off = 1,
> > +};
> > +
> >  struct platform_device ls1x_ehci_device = {
> > -       .name           = "ls1x-ehci",
> > +       .name           = "ehci-platform",
> >         .id             = -1,
> >         .num_resources  = ARRAY_SIZE(ls1x_ehci_resources),
> >         .resource       = ls1x_ehci_resources,
> >         .dev            = {
> >                 .dma_mask = &ls1x_ehci_dmamask,
> > +               .platform_data = &ls1x_ehci_pdata,
> >         },
> >  };
> >
> > --
> > 1.7.9.5
> >
> >
> 
> 
> -- 
> Best Regards!
> Kelvin Cheung
