Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab0JSITN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:19:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38140 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab0JSITL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:19:11 -0400
Date: Tue, 19 Oct 2010 11:18:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019081855.GI12470@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
 <1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 03:04:26AM -0500, Felipe Contreras wrote:
>diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>index db51ea1..523df52 100644
>--- a/drivers/mfd/Kconfig
>+++ b/drivers/mfd/Kconfig
>@@ -156,6 +156,8 @@ config MENELAUS
> config TWL4030_CORE
> 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
> 	depends on I2C=y && GENERIC_HARDIRQS
>+	depends on ARCH_OMAP3 || ARCH_OMAP4

It's just an i2c chip, not depending on OMAP will allow us for a much
needed compile test on linux-next with different architectures.

>@@ -169,7 +171,7 @@ config TWL4030_CORE
>
> config TWL4030_POWER
> 	bool "Support power resources on TWL4030 family chips"
>-	depends on TWL4030_CORE && ARM
>+	depends on TWL4030_CORE

ok.

>@@ -191,7 +190,6 @@ config USB_GADGET_OMAP
> 	boolean "OMAP USB Device Controller"
> 	depends on ARCH_OMAP
> 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
>-	select USB_OTG_UTILS if ARCH_OMAP

ok.

>@@ -842,7 +840,8 @@ config USB_CDC_COMPOSITE
>
> config USB_G_NOKIA
> 	tristate "Nokia composite gadget"
>-	depends on PHONET
>+	depends on PHONET && MACH_NOKIA_RX51

no. g_nokia only depends on PHONET, if someone else wants to use on
another board, it's fine by me. Otherwise we will have to keep on adding
more and more boards.

>+	depends on USB_GADGET_MUSB_HDRC

this gadget also works on controllers other than musb. As long as they
support enough endpoints and alternate settings, it should just work.

It was fine as it was before. NAK

>diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
>index 20895c4..5484258 100644
>--- a/drivers/usb/musb/Kconfig
>+++ b/drivers/usb/musb/Kconfig
>@@ -12,7 +12,7 @@ config USB_MUSB_HDRC
> 	depends on (USB || USB_GADGET)
> 	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
> 	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
>-	select TWL4030_USB if MACH_OMAP_3430SDP
>+	select TWL4030_USB if ARCH_OMAP3

we have omap3-based boards which don't use twl4030-usb, they use
nop-usb-xceiv. How do you want to handle that ?? NAK

-- 
balbi
