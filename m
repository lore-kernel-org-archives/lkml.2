Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1BWEek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49687 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1BWEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:35 -0500
Subject: [RFC PATCH 11/15] dt/video: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:31 -0700
Message-ID: <20110223043431.20795.79475.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of users of of_platform_driver in drivers/video.  The
of_platform_{,un}register_driver functions are going away, so the
users need to be converted to using the platform_bus_type directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/video/bw2.c               |    8 ++++----
 drivers/video/cg14.c              |    8 ++++----
 drivers/video/cg3.c               |    9 ++++-----
 drivers/video/cg6.c               |    9 ++++-----
 drivers/video/ffb.c               |    9 ++++-----
 drivers/video/fsl-diu-fb.c        |    9 ++++-----
 drivers/video/leo.c               |    9 ++++-----
 drivers/video/mb862xx/mb862xxfb.c |    9 ++++-----
 drivers/video/p9100.c             |    8 ++++----
 drivers/video/platinumfb.c        |    9 ++++-----
 drivers/video/sunxvr1000.c        |    9 ++++-----
 drivers/video/tcx.c               |    9 ++++-----
 drivers/video/xilinxfb.c          |   11 ++++-------
 13 files changed, 52 insertions(+), 64 deletions(-)

diff --git a/drivers/video/bw2.c b/drivers/video/bw2.c
index 4dc1346..7ba74cd 100644
--- a/drivers/video/bw2.c
+++ b/drivers/video/bw2.c
@@ -273,7 +273,7 @@ static int __devinit bw2_do_default_mode(struct bw2_par *par,
 	return 0;
 }
 
-static int __devinit bw2_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit bw2_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -375,7 +375,7 @@ static const struct of_device_id bw2_match[] = {
 };
 MODULE_DEVICE_TABLE(of, bw2_match);
 
-static struct of_platform_driver bw2_driver = {
+static struct platform_driver bw2_driver = {
 	.driver = {
 		.name = "bw2",
 		.owner = THIS_MODULE,
@@ -390,12 +390,12 @@ static int __init bw2_init(void)
 	if (fb_get_options("bw2fb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&bw2_driver);
+	return platform_driver_register(&bw2_driver);
 }
 
 static void __exit bw2_exit(void)
 {
-	of_unregister_platform_driver(&bw2_driver);
+	platform_driver_unregister(&bw2_driver);
 }
 
 module_init(bw2_init);
diff --git a/drivers/video/cg14.c b/drivers/video/cg14.c
index 2424953..e2c85b0 100644
--- a/drivers/video/cg14.c
+++ b/drivers/video/cg14.c
@@ -463,7 +463,7 @@ static void cg14_unmap_regs(struct platform_device *op, struct fb_info *info,
 			   info->screen_base, info->fix.smem_len);
 }
 
-static int __devinit cg14_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit cg14_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -595,7 +595,7 @@ static const struct of_device_id cg14_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cg14_match);
 
-static struct of_platform_driver cg14_driver = {
+static struct platform_driver cg14_driver = {
 	.driver = {
 		.name = "cg14",
 		.owner = THIS_MODULE,
@@ -610,12 +610,12 @@ static int __init cg14_init(void)
 	if (fb_get_options("cg14fb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&cg14_driver);
+	return platform_driver_register(&cg14_driver);
 }
 
 static void __exit cg14_exit(void)
 {
-	of_unregister_platform_driver(&cg14_driver);
+	platform_driver_unregister(&cg14_driver);
 }
 
 module_init(cg14_init);
diff --git a/drivers/video/cg3.c b/drivers/video/cg3.c
index 09c0c3c..f927a7b 100644
--- a/drivers/video/cg3.c
+++ b/drivers/video/cg3.c
@@ -346,8 +346,7 @@ static int __devinit cg3_do_default_mode(struct cg3_par *par)
 	return 0;
 }
 
-static int __devinit cg3_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit cg3_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -462,7 +461,7 @@ static const struct of_device_id cg3_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cg3_match);
 
-static struct of_platform_driver cg3_driver = {
+static struct platform_driver cg3_driver = {
 	.driver = {
 		.name = "cg3",
 		.owner = THIS_MODULE,
@@ -477,12 +476,12 @@ static int __init cg3_init(void)
 	if (fb_get_options("cg3fb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&cg3_driver);
+	return platform_driver_register(&cg3_driver);
 }
 
 static void __exit cg3_exit(void)
 {
-	of_unregister_platform_driver(&cg3_driver);
+	platform_driver_unregister(&cg3_driver);
 }
 
 module_init(cg3_init);
diff --git a/drivers/video/cg6.c b/drivers/video/cg6.c
index 2b5a970..4ffad90 100644
--- a/drivers/video/cg6.c
+++ b/drivers/video/cg6.c
@@ -737,8 +737,7 @@ static void cg6_unmap_regs(struct platform_device *op, struct fb_info *info,
 			   info->fix.smem_len);
 }
 
-static int __devinit cg6_probe(struct platform_device *op,
-				const struct of_device_id *match)
+static int __devinit cg6_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -855,7 +854,7 @@ static const struct of_device_id cg6_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cg6_match);
 
-static struct of_platform_driver cg6_driver = {
+static struct platform_driver cg6_driver = {
 	.driver = {
 		.name = "cg6",
 		.owner = THIS_MODULE,
@@ -870,12 +869,12 @@ static int __init cg6_init(void)
 	if (fb_get_options("cg6fb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&cg6_driver);
+	return platform_driver_register(&cg6_driver);
 }
 
 static void __exit cg6_exit(void)
 {
-	of_unregister_platform_driver(&cg6_driver);
+	platform_driver_unregister(&cg6_driver);
 }
 
 module_init(cg6_init);
diff --git a/drivers/video/ffb.c b/drivers/video/ffb.c
index 6739b2a..910c5e6 100644
--- a/drivers/video/ffb.c
+++ b/drivers/video/ffb.c
@@ -893,8 +893,7 @@ static void ffb_init_fix(struct fb_info *info)
 	info->fix.accel = FB_ACCEL_SUN_CREATOR;
 }
 
-static int __devinit ffb_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit ffb_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct ffb_fbc __iomem *fbc;
@@ -1052,7 +1051,7 @@ static const struct of_device_id ffb_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ffb_match);
 
-static struct of_platform_driver ffb_driver = {
+static struct platform_driver ffb_driver = {
 	.driver = {
 		.name = "ffb",
 		.owner = THIS_MODULE,
@@ -1067,12 +1066,12 @@ static int __init ffb_init(void)
 	if (fb_get_options("ffb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&ffb_driver);
+	return platform_driver_register(&ffb_driver);
 }
 
 static void __exit ffb_exit(void)
 {
-	of_unregister_platform_driver(&ffb_driver);
+	platform_driver_unregister(&ffb_driver);
 }
 
 module_init(ffb_init);
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 8bbbf08..9048f87 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1487,8 +1487,7 @@ static ssize_t show_monitor(struct device *device,
 	return diu_ops.show_monitor_port(machine_data->monitor_port, buf);
 }
 
-static int __devinit fsl_diu_probe(struct platform_device *ofdev,
-	const struct of_device_id *match)
+static int __devinit fsl_diu_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct mfb_info *mfbi;
@@ -1735,7 +1734,7 @@ static struct of_device_id fsl_diu_match[] = {
 };
 MODULE_DEVICE_TABLE(of, fsl_diu_match);
 
-static struct of_platform_driver fsl_diu_driver = {
+static struct platform_driver fsl_diu_driver = {
 	.driver = {
 		.name = "fsl_diu",
 		.owner = THIS_MODULE,
@@ -1797,7 +1796,7 @@ static int __init fsl_diu_init(void)
 	if (!coherence_data)
 		return -ENOMEM;
 #endif
-	ret = of_register_platform_driver(&fsl_diu_driver);
+	ret = platform_driver_register(&fsl_diu_driver);
 	if (ret) {
 		printk(KERN_ERR
 			"fsl-diu: failed to register platform driver\n");
@@ -1811,7 +1810,7 @@ static int __init fsl_diu_init(void)
 
 static void __exit fsl_diu_exit(void)
 {
-	of_unregister_platform_driver(&fsl_diu_driver);
+	platform_driver_unregister(&fsl_diu_driver);
 #if defined(CONFIG_NOT_COHERENT_CACHE)
 	vfree(coherence_data);
 #endif
diff --git a/drivers/video/leo.c b/drivers/video/leo.c
index b599e5e..9e946e2 100644
--- a/drivers/video/leo.c
+++ b/drivers/video/leo.c
@@ -547,8 +547,7 @@ static void leo_unmap_regs(struct platform_device *op, struct fb_info *info,
 		of_iounmap(&op->resource[0], info->screen_base, 0x800000);
 }
 
-static int __devinit leo_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit leo_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -662,7 +661,7 @@ static const struct of_device_id leo_match[] = {
 };
 MODULE_DEVICE_TABLE(of, leo_match);
 
-static struct of_platform_driver leo_driver = {
+static struct platform_driver leo_driver = {
 	.driver = {
 		.name = "leo",
 		.owner = THIS_MODULE,
@@ -677,12 +676,12 @@ static int __init leo_init(void)
 	if (fb_get_options("leofb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&leo_driver);
+	return platform_driver_register(&leo_driver);
 }
 
 static void __exit leo_exit(void)
 {
-	of_unregister_platform_driver(&leo_driver);
+	platform_driver_unregister(&leo_driver);
 }
 
 module_init(leo_init);
diff --git a/drivers/video/mb862xx/mb862xxfb.c b/drivers/video/mb862xx/mb862xxfb.c
index b1c4374..c76e663 100644
--- a/drivers/video/mb862xx/mb862xxfb.c
+++ b/drivers/video/mb862xx/mb862xxfb.c
@@ -550,8 +550,7 @@ static int mb862xx_gdc_init(struct mb862xxfb_par *par)
 	return 0;
 }
 
-static int __devinit of_platform_mb862xx_probe(struct platform_device *ofdev,
-					       const struct of_device_id *id)
+static int __devinit of_platform_mb862xx_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct device *dev = &ofdev->dev;
@@ -717,7 +716,7 @@ static struct of_device_id __devinitdata of_platform_mb862xx_tbl[] = {
 	{ /* end */ }
 };
 
-static struct of_platform_driver of_platform_mb862xxfb_driver = {
+static struct platform_driver of_platform_mb862xxfb_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
@@ -1038,7 +1037,7 @@ static int __devinit mb862xxfb_init(void)
 	int ret = -ENODEV;
 
 #if defined(CONFIG_FB_MB862XX_LIME)
-	ret = of_register_platform_driver(&of_platform_mb862xxfb_driver);
+	ret = platform_driver_register(&of_platform_mb862xxfb_driver);
 #endif
 #if defined(CONFIG_FB_MB862XX_PCI_GDC)
 	ret = pci_register_driver(&mb862xxfb_pci_driver);
@@ -1049,7 +1048,7 @@ static int __devinit mb862xxfb_init(void)
 static void __exit mb862xxfb_exit(void)
 {
 #if defined(CONFIG_FB_MB862XX_LIME)
-	of_unregister_platform_driver(&of_platform_mb862xxfb_driver);
+	platform_driver_unregister(&of_platform_mb862xxfb_driver);
 #endif
 #if defined(CONFIG_FB_MB862XX_PCI_GDC)
 	pci_unregister_driver(&mb862xxfb_pci_driver);
diff --git a/drivers/video/p9100.c b/drivers/video/p9100.c
index b6c3fc2..d57cc58 100644
--- a/drivers/video/p9100.c
+++ b/drivers/video/p9100.c
@@ -249,7 +249,7 @@ static void p9100_init_fix(struct fb_info *info, int linebytes, struct device_no
 	info->fix.accel = FB_ACCEL_SUN_CGTHREE;
 }
 
-static int __devinit p9100_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit p9100_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -352,7 +352,7 @@ static const struct of_device_id p9100_match[] = {
 };
 MODULE_DEVICE_TABLE(of, p9100_match);
 
-static struct of_platform_driver p9100_driver = {
+static struct platform_driver p9100_driver = {
 	.driver = {
 		.name = "p9100",
 		.owner = THIS_MODULE,
@@ -367,12 +367,12 @@ static int __init p9100_init(void)
 	if (fb_get_options("p9100fb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&p9100_driver);
+	return platform_driver_register(&p9100_driver);
 }
 
 static void __exit p9100_exit(void)
 {
-	of_unregister_platform_driver(&p9100_driver);
+	platform_driver_unregister(&p9100_driver);
 }
 
 module_init(p9100_init);
diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index a50e197..ef532d9 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -533,8 +533,7 @@ static int __init platinumfb_setup(char *options)
 #define invalidate_cache(addr)
 #endif
 
-static int __devinit platinumfb_probe(struct platform_device* odev,
-				      const struct of_device_id *match)
+static int __devinit platinumfb_probe(struct platform_device* odev)
 {
 	struct device_node	*dp = odev->dev.of_node;
 	struct fb_info		*info;
@@ -677,7 +676,7 @@ static struct of_device_id platinumfb_match[] =
 	{},
 };
 
-static struct of_platform_driver platinum_driver = 
+static struct platform_driver platinum_driver = 
 {
 	.driver = {
 		.name = "platinumfb",
@@ -697,14 +696,14 @@ static int __init platinumfb_init(void)
 		return -ENODEV;
 	platinumfb_setup(option);
 #endif
-	of_register_platform_driver(&platinum_driver);
+	platform_driver_register(&platinum_driver);
 
 	return 0;
 }
 
 static void __exit platinumfb_exit(void)
 {
-	of_unregister_platform_driver(&platinum_driver);
+	platform_driver_unregister(&platinum_driver);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/sunxvr1000.c b/drivers/video/sunxvr1000.c
index 5dbe06a..b7f27ac 100644
--- a/drivers/video/sunxvr1000.c
+++ b/drivers/video/sunxvr1000.c
@@ -111,8 +111,7 @@ static int __devinit gfb_set_fbinfo(struct gfb_info *gp)
         return 0;
 }
 
-static int __devinit gfb_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit gfb_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -198,7 +197,7 @@ static const struct of_device_id gfb_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ffb_match);
 
-static struct of_platform_driver gfb_driver = {
+static struct platform_driver gfb_driver = {
 	.probe		= gfb_probe,
 	.remove		= __devexit_p(gfb_remove),
 	.driver = {
@@ -213,12 +212,12 @@ static int __init gfb_init(void)
 	if (fb_get_options("gfb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&gfb_driver);
+	return platform_driver_register(&gfb_driver);
 }
 
 static void __exit gfb_exit(void)
 {
-	of_unregister_platform_driver(&gfb_driver);
+	platform_driver_unregister(&gfb_driver);
 }
 
 module_init(gfb_init);
diff --git a/drivers/video/tcx.c b/drivers/video/tcx.c
index 77ad279..855b719 100644
--- a/drivers/video/tcx.c
+++ b/drivers/video/tcx.c
@@ -362,8 +362,7 @@ static void tcx_unmap_regs(struct platform_device *op, struct fb_info *info,
 			   info->screen_base, info->fix.smem_len);
 }
 
-static int __devinit tcx_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit tcx_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct fb_info *info;
@@ -511,7 +510,7 @@ static const struct of_device_id tcx_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tcx_match);
 
-static struct of_platform_driver tcx_driver = {
+static struct platform_driver tcx_driver = {
 	.driver = {
 		.name = "tcx",
 		.owner = THIS_MODULE,
@@ -526,12 +525,12 @@ static int __init tcx_init(void)
 	if (fb_get_options("tcxfb", NULL))
 		return -ENODEV;
 
-	return of_register_platform_driver(&tcx_driver);
+	return platform_driver_register(&tcx_driver);
 }
 
 static void __exit tcx_exit(void)
 {
-	of_unregister_platform_driver(&tcx_driver);
+	platform_driver_unregister(&tcx_driver);
 }
 
 module_init(tcx_init);
diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 68bd234..77dea01 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -404,8 +404,7 @@ static int xilinxfb_release(struct device *dev)
  * OF bus binding
  */
 
-static int __devinit
-xilinxfb_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit xilinxfb_of_probe(struct platform_device *op)
 {
 	const u32 *prop;
 	u32 *p;
@@ -418,8 +417,6 @@ xilinxfb_of_probe(struct platform_device *op, const struct of_device_id *match)
 	/* Copy with the default pdata (not a ptr reference!) */
 	pdata = xilinx_fb_default_pdata;
 
-	dev_dbg(&op->dev, "xilinxfb_of_probe(%p, %p)\n", op, match);
-
 	/* Allocate the driver data region */
 	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata) {
@@ -505,7 +502,7 @@ static struct of_device_id xilinxfb_of_match[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(of, xilinxfb_of_match);
 
-static struct of_platform_driver xilinxfb_of_driver = {
+static struct platform_driver xilinxfb_of_driver = {
 	.probe = xilinxfb_of_probe,
 	.remove = __devexit_p(xilinxfb_of_remove),
 	.driver = {
@@ -523,13 +520,13 @@ static struct of_platform_driver xilinxfb_of_driver = {
 static int __init
 xilinxfb_init(void)
 {
-	return of_register_platform_driver(&xilinxfb_of_driver);
+	return platform_driver_register(&xilinxfb_of_driver);
 }
 
 static void __exit
 xilinxfb_cleanup(void)
 {
-	of_unregister_platform_driver(&xilinxfb_of_driver);
+	platform_driver_unregister(&xilinxfb_of_driver);
 }
 
 module_init(xilinxfb_init);

