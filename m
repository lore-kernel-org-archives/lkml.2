Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab2AJHWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:22:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52411 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2AJHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:22:00 -0500
Message-ID: <1326180109.4956.5.camel@phoenix>
Subject: [PATCH RESEND] [media] convert drivers/media/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
        "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        Anatolij Gustschin <agust@denx.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>,
        linux-media@vger.kernel.org
Date: Tue, 10 Jan 2012 15:21:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/media/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Richard Röjfors" <richard.rojfors@pelagicore.com>
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/media/radio/radio-si4713.c         |   15 +----------
 drivers/media/radio/radio-timb.c           |   15 +----------
 drivers/media/radio/radio-wl1273.c         |   17 +-----------
 drivers/media/video/davinci/dm355_ccdc.c   |   13 +---------
 drivers/media/video/davinci/dm644x_ccdc.c  |   13 +---------
 drivers/media/video/davinci/isif.c         |   13 +---------
 drivers/media/video/davinci/vpbe.c         |   24 +-----------------
 drivers/media/video/davinci/vpbe_display.c |   38 +---------------------------
 drivers/media/video/davinci/vpbe_osd.c     |   18 +------------
 drivers/media/video/davinci/vpbe_venc.c    |   18 +------------
 drivers/media/video/davinci/vpfe_capture.c |   18 +------------
 drivers/media/video/fsl-viu.c              |   13 +---------
 drivers/media/video/mx3_camera.c           |   14 +---------
 drivers/media/video/omap1_camera.c         |   12 +--------
 drivers/media/video/omap24xxcam.c          |   19 +-------------
 drivers/media/video/omap3isp/isp.c         |   19 +-------------
 drivers/media/video/pxa_camera.c           |   14 +---------
 drivers/media/video/s5p-g2d/g2d.c          |   16 +-----------
 drivers/media/video/s5p-mfc/s5p_mfc.c      |   22 +---------------
 drivers/media/video/s5p-tv/hdmi_drv.c      |   26 +------------------
 drivers/media/video/s5p-tv/sdo_drv.c       |   22 +---------------
 drivers/media/video/sh_mobile_csi2.c       |   13 +---------
 drivers/media/video/soc_camera_platform.c  |   13 +---------
 drivers/media/video/timblogiw.c            |   15 +----------
 drivers/media/video/via-camera.c           |   12 +--------
 25 files changed, 26 insertions(+), 406 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index d1fab58..c54210c 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -355,17 +355,4 @@ static struct platform_driver radio_si4713_pdriver = {
 	.remove         = __exit_p(radio_si4713_pdriver_remove),
 };
 
-/* Module Interface */
-static int __init radio_si4713_module_init(void)
-{
-	return platform_driver_register(&radio_si4713_pdriver);
-}
-
-static void __exit radio_si4713_module_exit(void)
-{
-	platform_driver_unregister(&radio_si4713_pdriver);
-}
-
-module_init(radio_si4713_module_init);
-module_exit(radio_si4713_module_exit);
-
+module_platform_driver(radio_si4713_pdriver);
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 3e9209f..5d9a90a 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -226,20 +226,7 @@ static struct platform_driver timbradio_platform_driver = {
 	.remove		= timbradio_remove,
 };
 
-/*--------------------------------------------------------------------------*/
-
-static int __init timbradio_init(void)
-{
-	return platform_driver_register(&timbradio_platform_driver);
-}
-
-static void __exit timbradio_exit(void)
-{
-	platform_driver_unregister(&timbradio_platform_driver);
-}
-
-module_init(timbradio_init);
-module_exit(timbradio_exit);
+module_platform_driver(timbradio_platform_driver);
 
 MODULE_DESCRIPTION("Timberdale Radio driver");
 MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 8aa4968..f1b6070 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2148,8 +2148,6 @@ pdata_err:
 	return r;
 }
 
-MODULE_ALIAS("platform:wl1273_fm_radio");
-
 static struct platform_driver wl1273_fm_radio_driver = {
 	.probe		= wl1273_fm_radio_probe,
 	.remove		= __devexit_p(wl1273_fm_radio_remove),
@@ -2159,20 +2157,9 @@ static struct platform_driver wl1273_fm_radio_driver = {
 	},
 };
 
-static int __init wl1273_fm_module_init(void)
-{
-	pr_info("%s\n", __func__);
-	return platform_driver_register(&wl1273_fm_radio_driver);
-}
-module_init(wl1273_fm_module_init);
-
-static void __exit wl1273_fm_module_exit(void)
-{
-	platform_driver_unregister(&wl1273_fm_radio_driver);
-	pr_info(DRIVER_DESC ", Exiting.\n");
-}
-module_exit(wl1273_fm_module_exit);
+module_platform_driver(wl1273_fm_radio_driver);
 
 MODULE_AUTHOR("Matti Aaltonen <matti.j.aaltonen@nokia.com>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wl1273_fm_radio");
diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index bd443ee..f83baf3 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -1069,15 +1069,4 @@ static struct platform_driver dm355_ccdc_driver = {
 	.probe = dm355_ccdc_probe,
 };
 
-static int __init dm355_ccdc_init(void)
-{
-	return platform_driver_register(&dm355_ccdc_driver);
-}
-
-static void __exit dm355_ccdc_exit(void)
-{
-	platform_driver_unregister(&dm355_ccdc_driver);
-}
-
-module_init(dm355_ccdc_init);
-module_exit(dm355_ccdc_exit);
+module_platform_driver(dm355_ccdc_driver);
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 8051c29..9303fe5 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -1078,15 +1078,4 @@ static struct platform_driver dm644x_ccdc_driver = {
 	.probe = dm644x_ccdc_probe,
 };
 
-static int __init dm644x_ccdc_init(void)
-{
-	return platform_driver_register(&dm644x_ccdc_driver);
-}
-
-static void __exit dm644x_ccdc_exit(void)
-{
-	platform_driver_unregister(&dm644x_ccdc_driver);
-}
-
-module_init(dm644x_ccdc_init);
-module_exit(dm644x_ccdc_exit);
+module_platform_driver(dm644x_ccdc_driver);
diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
index 29c29c6..1e63852 100644
--- a/drivers/media/video/davinci/isif.c
+++ b/drivers/media/video/davinci/isif.c
@@ -1156,17 +1156,6 @@ static struct platform_driver isif_driver = {
 	.probe = isif_probe,
 };
 
-static int __init isif_init(void)
-{
-	return platform_driver_register(&isif_driver);
-}
-
-static void isif_exit(void)
-{
-	platform_driver_unregister(&isif_driver);
-}
-
-module_init(isif_init);
-module_exit(isif_exit);
+module_platform_driver(isif_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c
index d773d30..05f223b 100644
--- a/drivers/media/video/davinci/vpbe.c
+++ b/drivers/media/video/davinci/vpbe.c
@@ -839,26 +839,4 @@ static struct platform_driver vpbe_driver = {
 	.remove = vpbe_remove,
 };
 
-/**
- * vpbe_init: initialize the vpbe driver
- *
- * This function registers device and driver to the kernel
- */
-static __init int vpbe_init(void)
-{
-	return platform_driver_register(&vpbe_driver);
-}
-
-/**
- * vpbe_cleanup : cleanup function for vpbe driver
- *
- * This will un-registers the device and driver to the kernel
- */
-static void vpbe_cleanup(void)
-{
-	platform_driver_unregister(&vpbe_driver);
-}
-
-/* Function for module initialization and cleanup */
-module_init(vpbe_init);
-module_exit(vpbe_cleanup);
+module_platform_driver(vpbe_driver);
diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index d98da4b..1f3b1c7 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1817,43 +1817,7 @@ static struct platform_driver vpbe_display_driver = {
 	.remove = __devexit_p(vpbe_display_remove),
 };
 
-/*
- * vpbe_display_init()
- * This function registers device and driver to the kernel, requests irq
- * handler and allocates memory for layer objects
- */
-static __devinit int vpbe_display_init(void)
-{
-	int err;
-
-	printk(KERN_DEBUG "vpbe_display_init\n");
-
-	/* Register driver to the kernel */
-	err = platform_driver_register(&vpbe_display_driver);
-	if (0 != err)
-		return err;
-
-	printk(KERN_DEBUG "vpbe_display_init:"
-			"VPBE V4L2 Display Driver V1.0 loaded\n");
-	return 0;
-}
-
-/*
- * vpbe_display_cleanup()
- * This function un-registers device and driver to the kernel, frees requested
- * irq handler and de-allocates memory allocated for layer objects.
- */
-static void vpbe_display_cleanup(void)
-{
-	printk(KERN_DEBUG "vpbe_display_cleanup\n");
-
-	/* platform driver unregister */
-	platform_driver_unregister(&vpbe_display_driver);
-}
-
-/* Function for module initialization and cleanup */
-module_init(vpbe_display_init);
-module_exit(vpbe_display_cleanup);
+module_platform_driver(vpbe_display_driver);
 
 MODULE_DESCRIPTION("TI DM644x/DM355/DM365 VPBE Display controller");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/davinci/vpbe_osd.c b/drivers/media/video/davinci/vpbe_osd.c
index ceccf43..b1e10d9 100644
--- a/drivers/media/video/davinci/vpbe_osd.c
+++ b/drivers/media/video/davinci/vpbe_osd.c
@@ -1208,23 +1208,7 @@ static struct platform_driver osd_driver = {
 	},
 };
 
-static int osd_init(void)
-{
-	if (platform_driver_register(&osd_driver)) {
-		printk(KERN_ERR "Unable to register davinci osd driver\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void osd_exit(void)
-{
-	platform_driver_unregister(&osd_driver);
-}
-
-module_init(osd_init);
-module_exit(osd_exit);
+module_platform_driver(osd_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("DaVinci OSD Manager Driver");
diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
index 03a3e5c..ca30bed 100644
--- a/drivers/media/video/davinci/vpbe_venc.c
+++ b/drivers/media/video/davinci/vpbe_venc.c
@@ -543,23 +543,7 @@ static struct platform_driver venc_driver = {
 	},
 };
 
-static int venc_init(void)
-{
-	if (platform_driver_register(&venc_driver)) {
-		printk(KERN_ERR "Unable to register venc driver\n");
-		return -ENODEV;
-	}
-	return 0;
-}
-
-static void venc_exit(void)
-{
-	platform_driver_unregister(&venc_driver);
-	return;
-}
-
-module_init(venc_init);
-module_exit(venc_exit);
+module_platform_driver(venc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VPBE VENC Driver");
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 5b38fc9..20cf271 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -2076,20 +2076,4 @@ static struct platform_driver vpfe_driver = {
 	.remove = __devexit_p(vpfe_remove),
 };
 
-static __init int vpfe_init(void)
-{
-	printk(KERN_NOTICE "vpfe_init\n");
-	/* Register driver to the kernel */
-	return platform_driver_register(&vpfe_driver);
-}
-
-/*
- * vpfe_cleanup : This function un-registers device driver
- */
-static void vpfe_cleanup(void)
-{
-	platform_driver_unregister(&vpfe_driver);
-}
-
-module_init(vpfe_init);
-module_exit(vpfe_cleanup);
+module_platform_driver(vpfe_driver);
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 27cb197..27e3e0c 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -1661,18 +1661,7 @@ static struct platform_driver viu_of_platform_driver = {
 	},
 };
 
-static int __init viu_init(void)
-{
-	return platform_driver_register(&viu_of_platform_driver);
-}
-
-static void __exit viu_exit(void)
-{
-	platform_driver_unregister(&viu_of_platform_driver);
-}
-
-module_init(viu_init);
-module_exit(viu_exit);
+module_platform_driver(viu_of_platform_driver);
 
 MODULE_DESCRIPTION("Freescale Video-In(VIU)");
 MODULE_AUTHOR("Hongjun Chen");
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index dec2419..6fd2810 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1285,19 +1285,7 @@ static struct platform_driver mx3_camera_driver = {
 	.remove		= __devexit_p(mx3_camera_remove),
 };
 
-
-static int __init mx3_camera_init(void)
-{
-	return platform_driver_register(&mx3_camera_driver);
-}
-
-static void __exit mx3_camera_exit(void)
-{
-	platform_driver_unregister(&mx3_camera_driver);
-}
-
-module_init(mx3_camera_init);
-module_exit(mx3_camera_exit);
+module_platform_driver(mx3_camera_driver);
 
 MODULE_DESCRIPTION("i.MX3x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index e87ae2f..f13acf3 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1712,17 +1712,7 @@ static struct platform_driver omap1_cam_driver = {
 	.remove		= __exit_p(omap1_cam_remove),
 };
 
-static int __init omap1_cam_init(void)
-{
-	return platform_driver_register(&omap1_cam_driver);
-}
-module_init(omap1_cam_init);
-
-static void __exit omap1_cam_exit(void)
-{
-	platform_driver_unregister(&omap1_cam_driver);
-}
-module_exit(omap1_cam_exit);
+module_platform_driver(omap1_cam_driver);
 
 module_param(sg_mode, bool, 0644);
 MODULE_PARM_DESC(sg_mode, "videobuf mode, 0: dma-contig (default), 1: dma-sg");
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 45522e6..7d38641 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1868,21 +1868,7 @@ static struct platform_driver omap24xxcam_driver = {
 	},
 };
 
-/*
- *
- * Module initialisation and deinitialisation
- *
- */
-
-static int __init omap24xxcam_init(void)
-{
-	return platform_driver_register(&omap24xxcam_driver);
-}
-
-static void __exit omap24xxcam_cleanup(void)
-{
-	platform_driver_unregister(&omap24xxcam_driver);
-}
+module_platform_driver(omap24xxcam_driver);
 
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
 MODULE_DESCRIPTION("OMAP24xx Video for Linux camera driver");
@@ -1894,6 +1880,3 @@ MODULE_PARM_DESC(video_nr,
 module_param(capture_mem, int, 0);
 MODULE_PARM_DESC(capture_mem, "Maximum amount of memory for capture "
 		 "buffers (default 4800kiB)");
-
-module_init(omap24xxcam_init);
-module_exit(omap24xxcam_cleanup);
diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index b818cac..52773ff 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -2242,24 +2242,7 @@ static struct platform_driver omap3isp_driver = {
 	},
 };
 
-/*
- * isp_init - ISP module initialization.
- */
-static int __init isp_init(void)
-{
-	return platform_driver_register(&omap3isp_driver);
-}
-
-/*
- * isp_cleanup - ISP module cleanup.
- */
-static void __exit isp_cleanup(void)
-{
-	platform_driver_unregister(&omap3isp_driver);
-}
-
-module_init(isp_init);
-module_exit(isp_cleanup);
+module_platform_driver(omap3isp_driver);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("TI OMAP3 ISP driver");
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 79fb22c..b883aa4 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1851,19 +1851,7 @@ static struct platform_driver pxa_camera_driver = {
 	.remove		= __devexit_p(pxa_camera_remove),
 };
 
-
-static int __init pxa_camera_init(void)
-{
-	return platform_driver_register(&pxa_camera_driver);
-}
-
-static void __exit pxa_camera_exit(void)
-{
-	platform_driver_unregister(&pxa_camera_driver);
-}
-
-module_init(pxa_camera_init);
-module_exit(pxa_camera_exit);
+module_platform_driver(pxa_camera_driver);
 
 MODULE_DESCRIPTION("PXA27x SoC Camera Host driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 1f156c8..c40b0dd 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -803,21 +803,7 @@ static struct platform_driver g2d_pdrv = {
 	},
 };
 
-static void __exit g2d_exit(void)
-{
-	platform_driver_unregister(&g2d_pdrv);
-};
-
-static int  __init g2d_init(void)
-{
-	int ret = 0;
-
-	ret = platform_driver_register(&g2d_pdrv);
-	return ret;
-};
-
-module_init(g2d_init);
-module_exit(g2d_exit);
+module_platform_driver(g2d_pdrv);
 
 MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
 MODULE_DESCRIPTION("S5P G2D 2d graphics accelerator driver");
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 8be8b54..e43e128 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -1245,27 +1245,7 @@ static struct platform_driver s5p_mfc_driver = {
 	},
 };
 
-static char banner[] __initdata =
-			"S5P MFC V4L2 Driver, (C) 2011 Samsung Electronics\n";
-
-static int __init s5p_mfc_init(void)
-{
-	int ret;
-
-	pr_info("%s", banner);
-	ret = platform_driver_register(&s5p_mfc_driver);
-	if (ret)
-		pr_err("Platform device registration failed.\n");
-	return ret;
-}
-
-static void __exit s5p_mfc_exit(void)
-{
-	platform_driver_unregister(&s5p_mfc_driver);
-}
-
-module_init(s5p_mfc_init);
-module_exit(s5p_mfc_exit);
+module_platform_driver(s5p_mfc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 0279e6e..354b97a 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -1016,28 +1016,4 @@ static struct platform_driver hdmi_driver __refdata = {
 	}
 };
 
-/* D R I V E R   I N I T I A L I Z A T I O N */
-
-static int __init hdmi_init(void)
-{
-	int ret;
-	static const char banner[] __initdata = KERN_INFO \
-		"Samsung HDMI output driver, "
-		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
-	printk(banner);
-
-	ret = platform_driver_register(&hdmi_driver);
-	if (ret)
-		printk(KERN_ERR "HDMI platform driver register failed\n");
-
-	return ret;
-}
-module_init(hdmi_init);
-
-static void __exit hdmi_exit(void)
-{
-	platform_driver_unregister(&hdmi_driver);
-}
-module_exit(hdmi_exit);
-
-
+module_platform_driver(hdmi_driver);
diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
index 8cec67e..059e774 100644
--- a/drivers/media/video/s5p-tv/sdo_drv.c
+++ b/drivers/media/video/s5p-tv/sdo_drv.c
@@ -457,24 +457,4 @@ static struct platform_driver sdo_driver __refdata = {
 	}
 };
 
-static int __init sdo_init(void)
-{
-	int ret;
-	static const char banner[] __initdata = KERN_INFO \
-		"Samsung Standard Definition Output (SDO) driver, "
-		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
-	printk(banner);
-
-	ret = platform_driver_register(&sdo_driver);
-	if (ret)
-		printk(KERN_ERR "SDO platform driver register failed\n");
-
-	return ret;
-}
-module_init(sdo_init);
-
-static void __exit sdo_exit(void)
-{
-	platform_driver_unregister(&sdo_driver);
-}
-module_exit(sdo_exit);
+module_platform_driver(sdo_driver);
diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index ea4f047..e75034f 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -390,18 +390,7 @@ static struct platform_driver __refdata sh_csi2_pdrv = {
 	},
 };
 
-static int __init sh_csi2_init(void)
-{
-	return platform_driver_register(&sh_csi2_pdrv);
-}
-
-static void __exit sh_csi2_exit(void)
-{
-	platform_driver_unregister(&sh_csi2_pdrv);
-}
-
-module_init(sh_csi2_init);
-module_exit(sh_csi2_exit);
+module_platform_driver(sh_csi2_pdrv);
 
 MODULE_DESCRIPTION("SH-Mobile MIPI CSI-2 driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 4402a8a..f59ccad 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -189,18 +189,7 @@ static struct platform_driver soc_camera_platform_driver = {
 	.remove		= soc_camera_platform_remove,
 };
 
-static int __init soc_camera_platform_module_init(void)
-{
-	return platform_driver_register(&soc_camera_platform_driver);
-}
-
-static void __exit soc_camera_platform_module_exit(void)
-{
-	platform_driver_unregister(&soc_camera_platform_driver);
-}
-
-module_init(soc_camera_platform_module_init);
-module_exit(soc_camera_platform_module_exit);
+module_platform_driver(soc_camera_platform_driver);
 
 MODULE_DESCRIPTION("SoC Camera Platform driver");
 MODULE_AUTHOR("Magnus Damm");
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 6876f7e..4ed1c7c2 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -872,20 +872,7 @@ static struct platform_driver timblogiw_platform_driver = {
 	.remove		= __devexit_p(timblogiw_remove),
 };
 
-/* Module functions */
-
-static int __init timblogiw_init(void)
-{
-	return platform_driver_register(&timblogiw_platform_driver);
-}
-
-static void __exit timblogiw_exit(void)
-{
-	platform_driver_unregister(&timblogiw_platform_driver);
-}
-
-module_init(timblogiw_init);
-module_exit(timblogiw_exit);
+module_platform_driver(timblogiw_platform_driver);
 
 MODULE_DESCRIPTION(TIMBLOGIWIN_NAME);
 MODULE_AUTHOR("Pelagicore AB <info@pelagicore.com>");
diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 6a82875..7e2c34e 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -1500,14 +1500,4 @@ static struct platform_driver viacam_driver = {
 	.remove = viacam_remove,
 };
 
-static int viacam_init(void)
-{
-	return platform_driver_register(&viacam_driver);
-}
-module_init(viacam_init);
-
-static void viacam_exit(void)
-{
-	platform_driver_unregister(&viacam_driver);
-}
-module_exit(viacam_exit);
+module_platform_driver(viacam_driver);
-- 
1.7.5.4



