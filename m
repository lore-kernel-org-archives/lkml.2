Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1BWEeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1BWEeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:21 -0500
Subject: [RFC PATCH 08/15] dt/spi: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:16 -0700
Message-ID: <20110223043416.20795.65181.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of users of of_platform_driver in drivers/spi.  The
of_platform_{,un}register_driver functions are going away, so the
users need to be converted to using the platform_bus_type directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/mpc512x_psc_spi.c |    9 ++++-----
 drivers/spi/mpc52xx_psc_spi.c |    9 ++++-----
 drivers/spi/mpc52xx_spi.c     |    9 ++++-----
 drivers/spi/spi_fsl_espi.c    |   11 +++++------
 drivers/spi/spi_fsl_lib.c     |    3 +--
 drivers/spi/spi_fsl_lib.h     |    3 +--
 drivers/spi/spi_fsl_spi.c     |   11 +++++------
 drivers/spi/spi_ppc4xx.c      |    9 ++++-----
 8 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/spi/mpc512x_psc_spi.c b/drivers/spi/mpc512x_psc_spi.c
index 77d9e7e..6a5b423 100644
--- a/drivers/spi/mpc512x_psc_spi.c
+++ b/drivers/spi/mpc512x_psc_spi.c
@@ -507,8 +507,7 @@ static int __devexit mpc512x_psc_spi_do_remove(struct device *dev)
 	return 0;
 }
 
-static int __devinit mpc512x_psc_spi_of_probe(struct platform_device *op,
-					      const struct of_device_id *match)
+static int __devinit mpc512x_psc_spi_of_probe(struct platform_device *op)
 {
 	const u32 *regaddr_p;
 	u64 regaddr64, size64;
@@ -551,7 +550,7 @@ static struct of_device_id mpc512x_psc_spi_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, mpc512x_psc_spi_of_match);
 
-static struct of_platform_driver mpc512x_psc_spi_of_driver = {
+static struct platform_driver mpc512x_psc_spi_of_driver = {
 	.probe = mpc512x_psc_spi_of_probe,
 	.remove = __devexit_p(mpc512x_psc_spi_of_remove),
 	.driver = {
@@ -563,13 +562,13 @@ static struct of_platform_driver mpc512x_psc_spi_of_driver = {
 
 static int __init mpc512x_psc_spi_init(void)
 {
-	return of_register_platform_driver(&mpc512x_psc_spi_of_driver);
+	return platform_driver_register(&mpc512x_psc_spi_of_driver);
 }
 module_init(mpc512x_psc_spi_init);
 
 static void __exit mpc512x_psc_spi_exit(void)
 {
-	of_unregister_platform_driver(&mpc512x_psc_spi_of_driver);
+	platform_driver_unregister(&mpc512x_psc_spi_of_driver);
 }
 module_exit(mpc512x_psc_spi_exit);
 
diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index 8a904c1..e30baf0 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -450,8 +450,7 @@ free_master:
 	return ret;
 }
 
-static int __devinit mpc52xx_psc_spi_of_probe(struct platform_device *op,
-	const struct of_device_id *match)
+static int __devinit mpc52xx_psc_spi_of_probe(struct platform_device *op)
 {
 	const u32 *regaddr_p;
 	u64 regaddr64, size64;
@@ -503,7 +502,7 @@ static const struct of_device_id mpc52xx_psc_spi_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, mpc52xx_psc_spi_of_match);
 
-static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
+static struct platform_driver mpc52xx_psc_spi_of_driver = {
 	.probe = mpc52xx_psc_spi_of_probe,
 	.remove = __devexit_p(mpc52xx_psc_spi_of_remove),
 	.driver = {
@@ -515,13 +514,13 @@ static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
 
 static int __init mpc52xx_psc_spi_init(void)
 {
-	return of_register_platform_driver(&mpc52xx_psc_spi_of_driver);
+	return platform_driver_register(&mpc52xx_psc_spi_of_driver);
 }
 module_init(mpc52xx_psc_spi_init);
 
 static void __exit mpc52xx_psc_spi_exit(void)
 {
-	of_unregister_platform_driver(&mpc52xx_psc_spi_of_driver);
+	platform_driver_unregister(&mpc52xx_psc_spi_of_driver);
 }
 module_exit(mpc52xx_psc_spi_exit);
 
diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index 84439f6..015a974 100644
--- a/drivers/spi/mpc52xx_spi.c
+++ b/drivers/spi/mpc52xx_spi.c
@@ -390,8 +390,7 @@ static int mpc52xx_spi_transfer(struct spi_device *spi, struct spi_message *m)
 /*
  * OF Platform Bus Binding
  */
-static int __devinit mpc52xx_spi_probe(struct platform_device *op,
-				       const struct of_device_id *match)
+static int __devinit mpc52xx_spi_probe(struct platform_device *op)
 {
 	struct spi_master *master;
 	struct mpc52xx_spi *ms;
@@ -556,7 +555,7 @@ static const struct of_device_id mpc52xx_spi_match[] __devinitconst = {
 };
 MODULE_DEVICE_TABLE(of, mpc52xx_spi_match);
 
-static struct of_platform_driver mpc52xx_spi_of_driver = {
+static struct platform_driver mpc52xx_spi_of_driver = {
 	.driver = {
 		.name = "mpc52xx-spi",
 		.owner = THIS_MODULE,
@@ -568,13 +567,13 @@ static struct of_platform_driver mpc52xx_spi_of_driver = {
 
 static int __init mpc52xx_spi_init(void)
 {
-	return of_register_platform_driver(&mpc52xx_spi_of_driver);
+	return platform_driver_register(&mpc52xx_spi_of_driver);
 }
 module_init(mpc52xx_spi_init);
 
 static void __exit mpc52xx_spi_exit(void)
 {
-	of_unregister_platform_driver(&mpc52xx_spi_of_driver);
+	platform_driver_unregister(&mpc52xx_spi_of_driver);
 }
 module_exit(mpc52xx_spi_exit);
 
diff --git a/drivers/spi/spi_fsl_espi.c b/drivers/spi/spi_fsl_espi.c
index a99e233..900e921 100644
--- a/drivers/spi/spi_fsl_espi.c
+++ b/drivers/spi/spi_fsl_espi.c
@@ -685,8 +685,7 @@ static int of_fsl_espi_get_chipselects(struct device *dev)
 	return 0;
 }
 
-static int __devinit of_fsl_espi_probe(struct platform_device *ofdev,
-					const struct of_device_id *ofid)
+static int __devinit of_fsl_espi_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -695,7 +694,7 @@ static int __devinit of_fsl_espi_probe(struct platform_device *ofdev,
 	struct resource irq;
 	int ret = -ENOMEM;
 
-	ret = of_mpc8xxx_spi_probe(ofdev, ofid);
+	ret = of_mpc8xxx_spi_probe(ofdev);
 	if (ret)
 		return ret;
 
@@ -736,7 +735,7 @@ static const struct of_device_id of_fsl_espi_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_fsl_espi_match);
 
-static struct of_platform_driver fsl_espi_driver = {
+static struct platform_driver fsl_espi_driver = {
 	.driver = {
 		.name = "fsl_espi",
 		.owner = THIS_MODULE,
@@ -748,13 +747,13 @@ static struct of_platform_driver fsl_espi_driver = {
 
 static int __init fsl_espi_init(void)
 {
-	return of_register_platform_driver(&fsl_espi_driver);
+	return platform_driver_register(&fsl_espi_driver);
 }
 module_init(fsl_espi_init);
 
 static void __exit fsl_espi_exit(void)
 {
-	of_unregister_platform_driver(&fsl_espi_driver);
+	platform_driver_unregister(&fsl_espi_driver);
 }
 module_exit(fsl_espi_exit);
 
diff --git a/drivers/spi/spi_fsl_lib.c b/drivers/spi/spi_fsl_lib.c
index 5cd741f..ff59f42 100644
--- a/drivers/spi/spi_fsl_lib.c
+++ b/drivers/spi/spi_fsl_lib.c
@@ -189,8 +189,7 @@ int __devexit mpc8xxx_spi_remove(struct device *dev)
 	return 0;
 }
 
-int __devinit of_mpc8xxx_spi_probe(struct platform_device *ofdev,
-					const struct of_device_id *ofid)
+int __devinit of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
diff --git a/drivers/spi/spi_fsl_lib.h b/drivers/spi/spi_fsl_lib.h
index 281e060..57f28db 100644
--- a/drivers/spi/spi_fsl_lib.h
+++ b/drivers/spi/spi_fsl_lib.h
@@ -118,7 +118,6 @@ extern const char *mpc8xxx_spi_strmode(unsigned int flags);
 extern int mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
 		unsigned int irq);
 extern int mpc8xxx_spi_remove(struct device *dev);
-extern int of_mpc8xxx_spi_probe(struct platform_device *ofdev,
-				const struct of_device_id *ofid);
+extern int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 
 #endif /* __SPI_FSL_LIB_H__ */
diff --git a/drivers/spi/spi_fsl_spi.c b/drivers/spi/spi_fsl_spi.c
index 7ca52d3..ad317c3 100644
--- a/drivers/spi/spi_fsl_spi.c
+++ b/drivers/spi/spi_fsl_spi.c
@@ -1042,8 +1042,7 @@ static int of_fsl_spi_free_chipselects(struct device *dev)
 	return 0;
 }
 
-static int __devinit of_fsl_spi_probe(struct platform_device *ofdev,
-					const struct of_device_id *ofid)
+static int __devinit of_fsl_spi_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -1052,7 +1051,7 @@ static int __devinit of_fsl_spi_probe(struct platform_device *ofdev,
 	struct resource irq;
 	int ret = -ENOMEM;
 
-	ret = of_mpc8xxx_spi_probe(ofdev, ofid);
+	ret = of_mpc8xxx_spi_probe(ofdev)
 	if (ret)
 		return ret;
 
@@ -1100,7 +1099,7 @@ static const struct of_device_id of_fsl_spi_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_fsl_spi_match);
 
-static struct of_platform_driver of_fsl_spi_driver = {
+static struct platform_driver of_fsl_spi_driver = {
 	.driver = {
 		.name = "fsl_spi",
 		.owner = THIS_MODULE,
@@ -1177,13 +1176,13 @@ static void __exit legacy_driver_unregister(void) {}
 static int __init fsl_spi_init(void)
 {
 	legacy_driver_register();
-	return of_register_platform_driver(&of_fsl_spi_driver);
+	return platform_driver_register(&of_fsl_spi_driver);
 }
 module_init(fsl_spi_init);
 
 static void __exit fsl_spi_exit(void)
 {
-	of_unregister_platform_driver(&of_fsl_spi_driver);
+	platform_driver_unregister(&of_fsl_spi_driver);
 	legacy_driver_unregister();
 }
 module_exit(fsl_spi_exit);
diff --git a/drivers/spi/spi_ppc4xx.c b/drivers/spi/spi_ppc4xx.c
index 80e172d..2a298c0 100644
--- a/drivers/spi/spi_ppc4xx.c
+++ b/drivers/spi/spi_ppc4xx.c
@@ -390,8 +390,7 @@ static void free_gpios(struct ppc4xx_spi *hw)
 /*
  * platform_device layer stuff...
  */
-static int __init spi_ppc4xx_of_probe(struct platform_device *op,
-				      const struct of_device_id *match)
+static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 {
 	struct ppc4xx_spi *hw;
 	struct spi_master *master;
@@ -586,7 +585,7 @@ static const struct of_device_id spi_ppc4xx_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, spi_ppc4xx_of_match);
 
-static struct of_platform_driver spi_ppc4xx_of_driver = {
+static struct platform_driver spi_ppc4xx_of_driver = {
 	.probe = spi_ppc4xx_of_probe,
 	.remove = __exit_p(spi_ppc4xx_of_remove),
 	.driver = {
@@ -598,13 +597,13 @@ static struct of_platform_driver spi_ppc4xx_of_driver = {
 
 static int __init spi_ppc4xx_init(void)
 {
-	return of_register_platform_driver(&spi_ppc4xx_of_driver);
+	return platform_driver_register(&spi_ppc4xx_of_driver);
 }
 module_init(spi_ppc4xx_init);
 
 static void __exit spi_ppc4xx_exit(void)
 {
-	of_unregister_platform_driver(&spi_ppc4xx_of_driver);
+	platform_driver_unregister(&spi_ppc4xx_of_driver);
 }
 module_exit(spi_ppc4xx_exit);
 

