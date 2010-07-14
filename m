Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0GNLcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:32:09 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40357 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539Ab0GNLcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:32:06 -0400
Date: Wed, 14 Jul 2010 13:32:03 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/3] usb/{gadget,host}: Remove dead CONFIG_CPU_PXA27x
Message-ID: <e75b6cb0826c24f3c0583fb409473c494aff0f63.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_CPU_PXA27x doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/usb/gadget/pxa27x_udc.c |   16 ----------------
 drivers/usb/host/ohci-pxa27x.c  |    8 --------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 85b0d89..73783f5 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -2561,12 +2561,6 @@ static void pxa_udc_shutdown(struct platform_device *_dev)
 		udc_disable(udc);
 }
 
-#ifdef CONFIG_CPU_PXA27x
-extern void pxa27x_clear_otgph(void);
-#else
-#define pxa27x_clear_otgph()   do {} while (0)
-#endif
-
 #ifdef CONFIG_PM
 /**
  * pxa_udc_suspend - Suspend udc device
@@ -2625,16 +2619,6 @@ static int pxa_udc_resume(struct platform_device *_dev)
 	dplus_pullup(udc, udc->pullup_resume);
 	if (should_enable_udc(udc))
 		udc_enable(udc);
-	/*
-	 * We do not handle OTG yet.
-	 *
-	 * OTGPH bit is set when sleep mode is entered.
-	 * it indicates that OTG pad is retaining its state.
-	 * Upon exit from sleep mode and before clearing OTGPH,
-	 * Software must configure the USB OTG pad, UDC, and UHC
-	 * to the state they were in before entering sleep mode.
-	 */
-	pxa27x_clear_otgph();
 
 	return 0;
 }
diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index a18debd..227bdf0 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -203,12 +203,6 @@ static inline void pxa27x_reset_hc(struct pxa27x_ohci *ohci)
 	__raw_writel(uhchr & ~UHCHR_FHR, ohci->mmio_base + UHCHR);
 }
 
-#ifdef CONFIG_CPU_PXA27x
-extern void pxa27x_clear_otgph(void);
-#else
-#define pxa27x_clear_otgph()	do {} while (0)
-#endif
-
 static int pxa27x_start_hc(struct pxa27x_ohci *ohci, struct device *dev)
 {
 	int retval = 0;
@@ -239,8 +233,6 @@ static int pxa27x_start_hc(struct pxa27x_ohci *ohci, struct device *dev)
 	__raw_writel(uhchr, ohci->mmio_base + UHCHR);
 	__raw_writel(UHCHIE_UPRIE | UHCHIE_RWIE, ohci->mmio_base + UHCHIE);
 
-	/* Clear any OTG Pin Hold */
-	pxa27x_clear_otgph();
 	return 0;
 }
 
-- 
1.7.0.4

