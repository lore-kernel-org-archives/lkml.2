Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1K0MQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:16:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56518 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1K0MQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:16:36 -0500
Message-ID: <1322396187.2799.3.camel@phoenix>
Subject: [PATCH] usb: convert drivers/usb/* to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Felipe Balbi <balbi@ti.com>, Li Yang <leoli@freescale.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Date: Sun, 27 Nov 2011 20:16:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/usb/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Peter Korsgaard <jacmet@sunsite.dk> 
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/c67x00/c67x00-drv.c    |   15 ++-------------
 drivers/usb/dwc3/dwc3-omap.c       |   14 ++------------
 drivers/usb/gadget/fsl_qe_udc.c    |   15 +--------------
 drivers/usb/gadget/mv_udc_core.c   |   19 +++----------------
 drivers/usb/gadget/s3c-hsotg.c     |   13 +------------
 drivers/usb/gadget/s3c-hsudc.c     |   15 ++-------------
 drivers/usb/host/fhci-hcd.c        |   12 +-----------
 drivers/usb/host/fsl-mph-dr-of.c   |   12 +-----------
 drivers/usb/host/imx21-hcd.c       |   13 +------------
 drivers/usb/host/oxu210hp-hcd.c    |   19 +------------------
 drivers/usb/otg/fsl_otg.c          |   13 +------------
 drivers/usb/renesas_usbhs/common.c |   13 +------------
 12 files changed, 17 insertions(+), 156 deletions(-)

diff --git a/drivers/usb/c67x00/c67x00-drv.c b/drivers/usb/c67x00/c67x00-drv.c
index 57ae44c..6f3b6e2 100644
--- a/drivers/usb/c67x00/c67x00-drv.c
+++ b/drivers/usb/c67x00/c67x00-drv.c
@@ -225,21 +225,10 @@ static struct platform_driver c67x00_driver = {
 		.name = "c67x00",
 	},
 };
-MODULE_ALIAS("platform:c67x00");
-
-static int __init c67x00_init(void)
-{
-	return platform_driver_register(&c67x00_driver);
-}
 
-static void __exit c67x00_exit(void)
-{
-	platform_driver_unregister(&c67x00_driver);
-}
-
-module_init(c67x00_init);
-module_exit(c67x00_exit);
+module_platform_driver(c67x00_driver);
 
 MODULE_AUTHOR("Peter Korsgaard, Jan Veldeman, Grant Likely");
 MODULE_DESCRIPTION("Cypress C67X00 USB Controller Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:c67x00");
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 062552b..4e27d5b 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -384,18 +384,8 @@ static struct platform_driver dwc3_omap_driver = {
 	},
 };
 
+module_platform_driver(dwc3_omap_driver);
+
 MODULE_AUTHOR("Felipe Balbi <balbi@ti.com>");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("DesignWare USB3 OMAP Glue Layer");
-
-static int __devinit dwc3_omap_init(void)
-{
-	return platform_driver_register(&dwc3_omap_driver);
-}
-module_init(dwc3_omap_init);
-
-static void __exit dwc3_omap_exit(void)
-{
-	platform_driver_unregister(&dwc3_omap_driver);
-}
-module_exit(dwc3_omap_exit);
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 2a03e4d..811ea76 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2815,20 +2815,7 @@ static struct platform_driver udc_driver = {
 #endif
 };
 
-static int __init qe_udc_init(void)
-{
-	printk(KERN_INFO "%s: %s, %s\n", driver_name, driver_desc,
-			DRIVER_VERSION);
-	return platform_driver_register(&udc_driver);
-}
-
-static void __exit qe_udc_exit(void)
-{
-	platform_driver_unregister(&udc_driver);
-}
-
-module_init(qe_udc_init);
-module_exit(qe_udc_exit);
+module_platform_driver(udc_driver);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 8924121..0114fd3 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -2463,24 +2463,11 @@ static struct platform_driver udc_driver = {
 #endif
 	},
 };
-MODULE_ALIAS("platform:pxa-u2o");
+
+module_platform_driver(udc_driver);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Chao Xie <chao.xie@marvell.com>");
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
-
-
-static int __init init(void)
-{
-	return platform_driver_register(&udc_driver);
-}
-module_init(init);
-
-
-static void __exit cleanup(void)
-{
-	platform_driver_unregister(&udc_driver);
-}
-module_exit(cleanup);
-
+MODULE_ALIAS("platform:pxa-u2o");
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index a552453..745a308 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3469,18 +3469,7 @@ static struct platform_driver s3c_hsotg_driver = {
 	.resume		= s3c_hsotg_resume,
 };
 
-static int __init s3c_hsotg_modinit(void)
-{
-	return platform_driver_register(&s3c_hsotg_driver);
-}
-
-static void __exit s3c_hsotg_modexit(void)
-{
-	platform_driver_unregister(&s3c_hsotg_driver);
-}
-
-module_init(s3c_hsotg_modinit);
-module_exit(s3c_hsotg_modexit);
+module_platform_driver(s3c_hsotg_driver);
 
 MODULE_DESCRIPTION("Samsung S3C USB High-speed/OtG device");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 8d54f89..baf506a 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1378,21 +1378,10 @@ static struct platform_driver s3c_hsudc_driver = {
 	},
 	.probe		= s3c_hsudc_probe,
 };
-MODULE_ALIAS("platform:s3c-hsudc");
-
-static int __init s3c_hsudc_modinit(void)
-{
-	return platform_driver_register(&s3c_hsudc_driver);
-}
 
-static void __exit s3c_hsudc_modexit(void)
-{
-	platform_driver_unregister(&s3c_hsudc_driver);
-}
-
-module_init(s3c_hsudc_modinit);
-module_exit(s3c_hsudc_modexit);
+module_platform_driver(s3c_hsudc_driver);
 
 MODULE_DESCRIPTION("Samsung S3C24XX USB high-speed controller driver");
 MODULE_AUTHOR("Thomas Abraham <thomas.ab@samsung.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c-hsudc");
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 4ed6d19..d262374 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -824,17 +824,7 @@ static struct platform_driver of_fhci_driver = {
 	.remove		= __devexit_p(of_fhci_remove),
 };
 
-static int __init fhci_module_init(void)
-{
-	return platform_driver_register(&of_fhci_driver);
-}
-module_init(fhci_module_init);
-
-static void __exit fhci_module_exit(void)
-{
-	platform_driver_unregister(&of_fhci_driver);
-}
-module_exit(fhci_module_exit);
+module_platform_driver(of_fhci_driver);
 
 MODULE_DESCRIPTION("USB Freescale Host Controller Interface Driver");
 MODULE_AUTHOR("Shlomi Gridish <gridish@freescale.com>, "
diff --git a/drivers/usb/host/fsl-mph-dr-of.c b/drivers/usb/host/fsl-mph-dr-of.c
index 9037035..7916e56 100644
--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -297,17 +297,7 @@ static struct platform_driver fsl_usb2_mph_dr_driver = {
 	.remove	= __devexit_p(fsl_usb2_mph_dr_of_remove),
 };
 
-static int __init fsl_usb2_mph_dr_init(void)
-{
-	return platform_driver_register(&fsl_usb2_mph_dr_driver);
-}
-module_init(fsl_usb2_mph_dr_init);
-
-static void __exit fsl_usb2_mph_dr_exit(void)
-{
-	platform_driver_unregister(&fsl_usb2_mph_dr_driver);
-}
-module_exit(fsl_usb2_mph_dr_exit);
+module_platform_driver(fsl_usb2_mph_dr_driver);
 
 MODULE_DESCRIPTION("FSL MPH DR OF devices driver");
 MODULE_AUTHOR("Anatolij Gustschin <agust@denx.de>");
diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index 2ee18cf..6923bcb 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -1924,18 +1924,7 @@ static struct platform_driver imx21_hcd_driver = {
 	.resume = NULL,
 };
 
-static int __init imx21_hcd_init(void)
-{
-	return platform_driver_register(&imx21_hcd_driver);
-}
-
-static void __exit imx21_hcd_cleanup(void)
-{
-	platform_driver_unregister(&imx21_hcd_driver);
-}
-
-module_init(imx21_hcd_init);
-module_exit(imx21_hcd_cleanup);
+module_platform_driver(imx21_hcd_driver);
 
 MODULE_DESCRIPTION("i.MX21 USB Host controller");
 MODULE_AUTHOR("Martin Fuzzey");
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index dcd8898..6f62de5 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3951,24 +3951,7 @@ static struct platform_driver oxu_driver = {
 	}
 };
 
-static int __init oxu_module_init(void)
-{
-	int retval = 0;
-
-	retval = platform_driver_register(&oxu_driver);
-	if (retval < 0)
-		return retval;
-
-	return retval;
-}
-
-static void __exit oxu_module_cleanup(void)
-{
-	platform_driver_unregister(&oxu_driver);
-}
-
-module_init(oxu_module_init);
-module_exit(oxu_module_cleanup);
+module_platform_driver(oxu_driver);
 
 MODULE_DESCRIPTION("Oxford OXU210HP HCD driver - ver. " DRIVER_VERSION);
 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 0f420b2..2a52ff1 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -1151,18 +1151,7 @@ struct platform_driver fsl_otg_driver = {
 	},
 };
 
-static int __init fsl_usb_otg_init(void)
-{
-	pr_info(DRIVER_INFO "\n");
-	return platform_driver_register(&fsl_otg_driver);
-}
-module_init(fsl_usb_otg_init);
-
-static void __exit fsl_usb_otg_exit(void)
-{
-	platform_driver_unregister(&fsl_otg_driver);
-}
-module_exit(fsl_usb_otg_exit);
+module_platform_driver(fsl_otg_driver);
 
 MODULE_DESCRIPTION(DRIVER_INFO);
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index 08c679c..aa94e33 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -637,18 +637,7 @@ static struct platform_driver renesas_usbhs_driver = {
 	.remove		= __devexit_p(usbhs_remove),
 };
 
-static int __init usbhs_init(void)
-{
-	return platform_driver_register(&renesas_usbhs_driver);
-}
-
-static void __exit usbhs_exit(void)
-{
-	platform_driver_unregister(&renesas_usbhs_driver);
-}
-
-module_init(usbhs_init);
-module_exit(usbhs_exit);
+module_platform_driver(renesas_usbhs_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Renesas USB driver");
-- 
1.7.5.4



