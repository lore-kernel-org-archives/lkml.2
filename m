Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab0JSIUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:20:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35661 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab0JSIU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:20:29 -0400
Date: Tue, 19 Oct 2010 11:20:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH 1/3] usb: fix Kconfig warning
Message-ID: <20101019082013.GJ12470@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
 <1287475466-8927-2-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1287475466-8927-2-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:04:24AM -0500, Felipe Contreras wrote:
>warning: (USB_MUSB_HDRC_HCD && USB_SUPPORT && USB_MUSB_HDRC &&
>(USB_MUSB_HOST || USB_MUSB_OTG) && USB_GADGET_MUSB_HDRC || USB_MUSB_OTG
>&& <choice> && USB && USB_GADGET && PM && EXPERIMENTAL) selects USB_OTG
>which has unmet direct dependencies (USB_GADGET_OMAP && ARCH_OMAP_OTG &&
>USB_OHCI_HCD)
>
>This doesn't seem to happen on 2.6.36-rc8, but still doesn't make sense
>to keep this useless config.
>
>Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>---
> drivers/usb/gadget/Kconfig |   11 -----------
> 1 files changed, 0 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
>index cd27f9b..19a6eb6 100644
>--- a/drivers/usb/gadget/Kconfig
>+++ b/drivers/usb/gadget/Kconfig
>@@ -209,17 +209,6 @@ config USB_OMAP
> 	default USB_GADGET
> 	select USB_GADGET_SELECTED
>
>-config USB_OTG
>-	boolean "OTG Support"
>-	depends on USB_GADGET_OMAP && ARCH_OMAP_OTG && USB_OHCI_HCD
>-	help
>-	   The most notable feature of USB OTG is support for a
>-	   "Dual-Role" device, which can act as either a device
>-	   or a host.  The initial role choice can be changed
>-	   later, when two dual-role devices talk to each other.
>-
>-	   Select this only if your OMAP board has a Mini-AB connector.
>-

ok since this is replicated on drivers/usb/core/Kconfig but it's not
reflected on changelog. Could you add some extra comment ?

-- 
balbi
