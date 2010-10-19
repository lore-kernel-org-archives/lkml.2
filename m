Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab0JSKEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:04:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58982 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab0JSKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UeBc/WieyrVlE1cqly4wR6RZZ4wCxissij3+UlGZpViy1CfmA2XcyCphCUh11PcREW
         csAR7Us3GQO0c4CPWlqJMzoQUoFzRZrbxreoVUkLiHRiIfrUDb8R4tvVH7Ly0/KNgb1e
         LqF0fPeBU5fEwCvJ/cpR2HtQHxr9Kdw0tixp0=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 1/3] usb: fix Kconfig warning
Date: Tue, 19 Oct 2010 13:03:26 +0300
Message-Id: <1287482608-11320-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
In-Reply-To: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: (USB_MUSB_HDRC_HCD && USB_SUPPORT && USB_MUSB_HDRC &&
(USB_MUSB_HOST || USB_MUSB_OTG) && USB_GADGET_MUSB_HDRC || USB_MUSB_OTG
&& <choice> && USB && USB_GADGET && PM && EXPERIMENTAL) selects USB_OTG
which has unmet direct dependencies (USB_GADGET_OMAP && ARCH_OMAP_OTG &&
USB_OHCI_HCD)

This doesn't seem to happen on 2.6.36-rc8, but still doesn't make sense
to keep this duplicated config that is already defined in usb/core.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/gadget/Kconfig |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index cd27f9b..19a6eb6 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -209,17 +209,6 @@ config USB_OMAP
 	default USB_GADGET
 	select USB_GADGET_SELECTED
 
-config USB_OTG
-	boolean "OTG Support"
-	depends on USB_GADGET_OMAP && ARCH_OMAP_OTG && USB_OHCI_HCD
-	help
-	   The most notable feature of USB OTG is support for a
-	   "Dual-Role" device, which can act as either a device
-	   or a host.  The initial role choice can be changed
-	   later, when two dual-role devices talk to each other.
-
-	   Select this only if your OMAP board has a Mini-AB connector.
-
 config USB_GADGET_PXA25X
 	boolean "PXA 25x or IXP 4xx"
 	depends on (ARCH_PXA && PXA25x) || ARCH_IXP4XX
-- 
1.7.3.1.2.g7fe2b

