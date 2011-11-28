Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1K1ANn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:13:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44458 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1K1ANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:13:41 -0500
Message-ID: <1322439206.2709.2.camel@phoenix>
Subject: [PATCH v2] i2c: convert drivers/i2c/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Date: Mon, 28 Nov 2011 08:13:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/i2c/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jochen Friedrich <jochen@scram.de>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Jochen Friedrich<jochen@scram.de>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/i2c/busses/i2c-at91.c         |   17 ++---------------
 drivers/i2c/busses/i2c-au1550.c       |   13 +------------
 drivers/i2c/busses/i2c-cpm.c          |   13 +------------
 drivers/i2c/busses/i2c-highlander.c   |   13 +------------
 drivers/i2c/busses/i2c-ibm_iic.c      |   13 +------------
 drivers/i2c/busses/i2c-iop3xx.c       |   16 +---------------
 drivers/i2c/busses/i2c-isch.c         |   13 +------------
 drivers/i2c/busses/i2c-ixp2000.c      |   13 +------------
 drivers/i2c/busses/i2c-mpc.c          |   13 +------------
 drivers/i2c/busses/i2c-mv64xxx.c      |   15 +--------------
 drivers/i2c/busses/i2c-ocores.c       |   17 ++---------------
 drivers/i2c/busses/i2c-octeon.c       |   16 +---------------
 drivers/i2c/busses/i2c-pca-platform.c |   14 +-------------
 drivers/i2c/busses/i2c-pmcmsp.c       |   17 ++---------------
 drivers/i2c/busses/i2c-powermac.c     |   19 ++-----------------
 drivers/i2c/busses/i2c-puv3.c         |   16 ++--------------
 drivers/i2c/busses/i2c-sh7760.c       |   13 +------------
 drivers/i2c/busses/i2c-simtec.c       |   18 ++----------------
 drivers/i2c/busses/i2c-xiic.c         |   18 ++----------------
 19 files changed, 26 insertions(+), 261 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 305c075..1679dee 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -295,9 +295,6 @@ static int at91_i2c_resume(struct platform_device *pdev)
 #define at91_i2c_resume		NULL
 #endif
 
-/* work with "modprobe at91_i2c" from hotplugging or coldplugging */
-MODULE_ALIAS("platform:at91_i2c");
-
 static struct platform_driver at91_i2c_driver = {
 	.probe		= at91_i2c_probe,
 	.remove		= __devexit_p(at91_i2c_remove),
@@ -309,19 +306,9 @@ static struct platform_driver at91_i2c_driver = {
 	},
 };
 
-static int __init at91_i2c_init(void)
-{
-	return platform_driver_register(&at91_i2c_driver);
-}
-
-static void __exit at91_i2c_exit(void)
-{
-	platform_driver_unregister(&at91_i2c_driver);
-}
-
-module_init(at91_i2c_init);
-module_exit(at91_i2c_exit);
+module_platform_driver(at91_i2c_driver);
 
 MODULE_AUTHOR("Rick Bronson");
 MODULE_DESCRIPTION("I2C (TWI) driver for Atmel AT91");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:at91_i2c");
diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index f314d7f..582d616 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -426,20 +426,9 @@ static struct platform_driver au1xpsc_smbus_driver = {
 	.remove		= __devexit_p(i2c_au1550_remove),
 };
 
-static int __init i2c_au1550_init(void)
-{
-	return platform_driver_register(&au1xpsc_smbus_driver);
-}
-
-static void __exit i2c_au1550_exit(void)
-{
-	platform_driver_unregister(&au1xpsc_smbus_driver);
-}
+module_platform_driver(au1xpsc_smbus_driver);
 
 MODULE_AUTHOR("Dan Malek, Embedded Edge, LLC.");
 MODULE_DESCRIPTION("SMBus adapter Alchemy pb1550");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:au1xpsc_smbus");
-
-module_init (i2c_au1550_init);
-module_exit (i2c_au1550_exit);
diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index b1d9cd2..c1e1096 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -724,18 +724,7 @@ static struct platform_driver cpm_i2c_driver = {
 	},
 };
 
-static int __init cpm_i2c_init(void)
-{
-	return platform_driver_register(&cpm_i2c_driver);
-}
-
-static void __exit cpm_i2c_exit(void)
-{
-	platform_driver_unregister(&cpm_i2c_driver);
-}
-
-module_init(cpm_i2c_init);
-module_exit(cpm_i2c_exit);
+module_platform_driver(cpm_i2c_driver);
 
 MODULE_AUTHOR("Jochen Friedrich <jochen@scram.de>");
 MODULE_DESCRIPTION("I2C-Bus adapter routines for CPM boards");
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 63bb1cc..2294dea 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -468,18 +468,7 @@ static struct platform_driver highlander_i2c_driver = {
 	.remove		= __devexit_p(highlander_i2c_remove),
 };
 
-static int __init highlander_i2c_init(void)
-{
-	return platform_driver_register(&highlander_i2c_driver);
-}
-
-static void __exit highlander_i2c_exit(void)
-{
-	platform_driver_unregister(&highlander_i2c_driver);
-}
-
-module_init(highlander_i2c_init);
-module_exit(highlander_i2c_exit);
+module_platform_driver(highlander_i2c_driver);
 
 MODULE_AUTHOR("Paul Mundt");
 MODULE_DESCRIPTION("Renesas Highlander FPGA I2C/SMBus adapter");
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 3c110fb..dacc545 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -815,15 +815,4 @@ static struct platform_driver ibm_iic_driver = {
 	.remove	= __devexit_p(iic_remove),
 };
 
-static int __init iic_init(void)
-{
-	return platform_driver_register(&ibm_iic_driver);
-}
-
-static void __exit iic_exit(void)
-{
-	platform_driver_unregister(&ibm_iic_driver);
-}
-
-module_init(iic_init);
-module_exit(iic_exit);
+module_platform_driver(ibm_iic_driver);
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index f09c931..93f147a 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -523,21 +523,7 @@ static struct platform_driver iop3xx_i2c_driver = {
 	},
 };
 
-static int __init 
-i2c_iop3xx_init (void)
-{
-	return platform_driver_register(&iop3xx_i2c_driver);
-}
-
-static void __exit 
-i2c_iop3xx_exit (void)
-{
-	platform_driver_unregister(&iop3xx_i2c_driver);
-	return;
-}
-
-module_init (i2c_iop3xx_init);
-module_exit (i2c_iop3xx_exit);
+module_platform_driver(iop3xx_i2c_driver);
 
 MODULE_AUTHOR("D-TACQ Solutions Ltd <www.d-tacq.com>");
 MODULE_DESCRIPTION("IOP3xx iic algorithm and driver");
diff --git a/drivers/i2c/busses/i2c-isch.c b/drivers/i2c/busses/i2c-isch.c
index 0682f8f..6561d27 100644
--- a/drivers/i2c/busses/i2c-isch.c
+++ b/drivers/i2c/busses/i2c-isch.c
@@ -306,20 +306,9 @@ static struct platform_driver smbus_sch_driver = {
 	.remove		= __devexit_p(smbus_sch_remove),
 };
 
-static int __init i2c_sch_init(void)
-{
-	return platform_driver_register(&smbus_sch_driver);
-}
-
-static void __exit i2c_sch_exit(void)
-{
-	platform_driver_unregister(&smbus_sch_driver);
-}
+module_platform_driver(smbus_sch_driver);
 
 MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@intel.com>");
 MODULE_DESCRIPTION("Intel SCH SMBus driver");
 MODULE_LICENSE("GPL");
-
-module_init(i2c_sch_init);
-module_exit(i2c_sch_exit);
 MODULE_ALIAS("platform:isch_smbus");
diff --git a/drivers/i2c/busses/i2c-ixp2000.c b/drivers/i2c/busses/i2c-ixp2000.c
index c01e951..5d263f90 100644
--- a/drivers/i2c/busses/i2c-ixp2000.c
+++ b/drivers/i2c/busses/i2c-ixp2000.c
@@ -148,18 +148,7 @@ static struct platform_driver ixp2000_i2c_driver = {
 	},
 };
 
-static int __init ixp2000_i2c_init(void)
-{
-	return platform_driver_register(&ixp2000_i2c_driver);
-}
-
-static void __exit ixp2000_i2c_exit(void)
-{
-	platform_driver_unregister(&ixp2000_i2c_driver);
-}
-
-module_init(ixp2000_i2c_init);
-module_exit(ixp2000_i2c_exit);
+module_platform_driver(ixp2000_i2c_driver);
 
 MODULE_AUTHOR ("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_DESCRIPTION("IXP2000 GPIO-based I2C bus driver");
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 107397a..a8ebb84 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -715,18 +715,7 @@ static struct platform_driver mpc_i2c_driver = {
 	},
 };
 
-static int __init fsl_i2c_init(void)
-{
-	return platform_driver_register(&mpc_i2c_driver);
-}
-
-static void __exit fsl_i2c_exit(void)
-{
-	platform_driver_unregister(&mpc_i2c_driver);
-}
-
-module_init(fsl_i2c_init);
-module_exit(fsl_i2c_exit);
+module_platform_driver(mpc_i2c_driver);
 
 MODULE_AUTHOR("Adrian Cox <adrian@humboldt.co.uk>");
 MODULE_DESCRIPTION("I2C-Bus adapter for MPC107 bridge and "
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index a9941c6..4f44a33 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -611,20 +611,7 @@ static struct platform_driver mv64xxx_i2c_driver = {
 	},
 };
 
-static int __init
-mv64xxx_i2c_init(void)
-{
-	return platform_driver_register(&mv64xxx_i2c_driver);
-}
-
-static void __exit
-mv64xxx_i2c_exit(void)
-{
-	platform_driver_unregister(&mv64xxx_i2c_driver);
-}
-
-module_init(mv64xxx_i2c_init);
-module_exit(mv64xxx_i2c_exit);
+module_platform_driver(mv64xxx_i2c_driver);
 
 MODULE_AUTHOR("Mark A. Greer <mgreer@mvista.com>");
 MODULE_DESCRIPTION("Marvell mv64xxx host bridge i2c ctlr driver");
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 1b46a9d..18068de 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -394,9 +394,6 @@ static struct of_device_id ocores_i2c_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ocores_i2c_match);
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:ocores-i2c");
-
 static struct platform_driver ocores_i2c_driver = {
 	.probe   = ocores_i2c_probe,
 	.remove  = __devexit_p(ocores_i2c_remove),
@@ -409,19 +406,9 @@ static struct platform_driver ocores_i2c_driver = {
 	},
 };
 
-static int __init ocores_i2c_init(void)
-{
-	return platform_driver_register(&ocores_i2c_driver);
-}
-
-static void __exit ocores_i2c_exit(void)
-{
-	platform_driver_unregister(&ocores_i2c_driver);
-}
-
-module_init(ocores_i2c_init);
-module_exit(ocores_i2c_exit);
+module_platform_driver(ocores_i2c_driver);
 
 MODULE_AUTHOR("Peter Korsgaard <jacmet@sunsite.dk>");
 MODULE_DESCRIPTION("OpenCores I2C bus driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ocores-i2c");
diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 56dbe54..ee139a5 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -629,24 +629,10 @@ static struct platform_driver octeon_i2c_driver = {
 	},
 };
 
-static int __init octeon_i2c_init(void)
-{
-	int rv;
-
-	rv = platform_driver_register(&octeon_i2c_driver);
-	return rv;
-}
-
-static void __exit octeon_i2c_exit(void)
-{
-	platform_driver_unregister(&octeon_i2c_driver);
-}
+module_platform_driver(octeon_i2c_driver);
 
 MODULE_AUTHOR("Michael Lawnick <michael.lawnick.ext@nsn.com>");
 MODULE_DESCRIPTION("I2C-Bus adapter for Cavium OCTEON processors");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_NAME);
-
-module_init(octeon_i2c_init);
-module_exit(octeon_i2c_exit);
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index ace6799..2adbf1a 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -286,20 +286,8 @@ static struct platform_driver i2c_pca_pf_driver = {
 	},
 };
 
-static int __init i2c_pca_pf_init(void)
-{
-	return platform_driver_register(&i2c_pca_pf_driver);
-}
-
-static void __exit i2c_pca_pf_exit(void)
-{
-	platform_driver_unregister(&i2c_pca_pf_driver);
-}
+module_platform_driver(i2c_pca_pf_driver);
 
 MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
 MODULE_DESCRIPTION("I2C-PCA9564/PCA9665 platform driver");
 MODULE_LICENSE("GPL");
-
-module_init(i2c_pca_pf_init);
-module_exit(i2c_pca_pf_exit);
-
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 127051b..07b7447 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -627,9 +627,6 @@ static struct i2c_adapter pmcmsptwi_adapter = {
 	.name		= DRV_NAME,
 };
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:" DRV_NAME);
-
 static struct platform_driver pmcmsptwi_driver = {
 	.probe  = pmcmsptwi_probe,
 	.remove	= __devexit_p(pmcmsptwi_remove),
@@ -639,18 +636,8 @@ static struct platform_driver pmcmsptwi_driver = {
 	},
 };
 
-static int __init pmcmsptwi_init(void)
-{
-	return platform_driver_register(&pmcmsptwi_driver);
-}
-
-static void __exit pmcmsptwi_exit(void)
-{
-	platform_driver_unregister(&pmcmsptwi_driver);
-}
+module_platform_driver(pmcmsptwi_driver);
 
 MODULE_DESCRIPTION("PMC MSP TWI/SMBus/I2C driver");
 MODULE_LICENSE("GPL");
-
-module_init(pmcmsptwi_init);
-module_exit(pmcmsptwi_exit);
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index b289ec9..7b397c6 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -312,10 +312,6 @@ static int __devinit i2c_powermac_probe(struct platform_device *dev)
 	return rc;
 }
 
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:i2c-powermac");
-
 static struct platform_driver i2c_powermac_driver = {
 	.probe = i2c_powermac_probe,
 	.remove = __devexit_p(i2c_powermac_remove),
@@ -325,17 +321,6 @@ static struct platform_driver i2c_powermac_driver = {
 	},
 };
 
-static int __init i2c_powermac_init(void)
-{
-	platform_driver_register(&i2c_powermac_driver);
-	return 0;
-}
+module_platform_driver(i2c_powermac_driver);
 
-
-static void __exit i2c_powermac_cleanup(void)
-{
-	platform_driver_unregister(&i2c_powermac_driver);
-}
-
-module_init(i2c_powermac_init);
-module_exit(i2c_powermac_cleanup);
+MODULE_ALIAS("platform:i2c-powermac");
diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
index fac6739..93709fb 100644
--- a/drivers/i2c/busses/i2c-puv3.c
+++ b/drivers/i2c/busses/i2c-puv3.c
@@ -276,8 +276,6 @@ static int puv3_i2c_resume(struct platform_device *dev)
 #define puv3_i2c_resume NULL
 #endif
 
-MODULE_ALIAS("platform:puv3_i2c");
-
 static struct platform_driver puv3_i2c_driver = {
 	.probe		= puv3_i2c_probe,
 	.remove		= __devexit_p(puv3_i2c_remove),
@@ -289,18 +287,8 @@ static struct platform_driver puv3_i2c_driver = {
 	}
 };
 
-static int __init puv3_i2c_init(void)
-{
-	return platform_driver_register(&puv3_i2c_driver);
-}
-
-static void __exit puv3_i2c_exit(void)
-{
-	platform_driver_unregister(&puv3_i2c_driver);
-}
-
-module_init(puv3_i2c_init);
-module_exit(puv3_i2c_exit);
+module_platform_driver(puv3_i2c_driver);
 
 MODULE_DESCRIPTION("PKUnity v3 I2C driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:puv3_i2c");
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index a67132b..c0c9dff 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -560,18 +560,7 @@ static struct platform_driver sh7760_i2c_drv = {
 	.remove		= __devexit_p(sh7760_i2c_remove),
 };
 
-static int __init sh7760_i2c_init(void)
-{
-	return platform_driver_register(&sh7760_i2c_drv);
-}
-
-static void __exit sh7760_i2c_exit(void)
-{
-	platform_driver_unregister(&sh7760_i2c_drv);
-}
-
-module_init(sh7760_i2c_init);
-module_exit(sh7760_i2c_exit);
+module_platform_driver(sh7760_i2c_drv);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SH7760 I2C bus driver");
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 2fc08fb..4fc87e7 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -156,12 +156,8 @@ static int simtec_i2c_remove(struct platform_device *dev)
 	return 0;
 }
 
-
 /* device driver */
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:simtec-i2c");
-
 static struct platform_driver simtec_i2c_driver = {
 	.driver		= {
 		.name		= "simtec-i2c",
@@ -171,19 +167,9 @@ static struct platform_driver simtec_i2c_driver = {
 	.remove		= simtec_i2c_remove,
 };
 
-static int __init i2c_adap_simtec_init(void)
-{
-	return platform_driver_register(&simtec_i2c_driver);
-}
-
-static void __exit i2c_adap_simtec_exit(void)
-{
-	platform_driver_unregister(&simtec_i2c_driver);
-}
-
-module_init(i2c_adap_simtec_init);
-module_exit(i2c_adap_simtec_exit);
+module_platform_driver(simtec_i2c_driver);
 
 MODULE_DESCRIPTION("Simtec Generic I2C Bus driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:simtec-i2c");
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 4bb68f3..a5e267f 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -795,10 +795,6 @@ static int __devexit xiic_i2c_remove(struct platform_device* pdev)
 	return 0;
 }
 
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:"DRIVER_NAME);
-
 static struct platform_driver xiic_i2c_driver = {
 	.probe   = xiic_i2c_probe,
 	.remove  = __devexit_p(xiic_i2c_remove),
@@ -808,19 +804,9 @@ static struct platform_driver xiic_i2c_driver = {
 	},
 };
 
-static int __init xiic_i2c_init(void)
-{
-	return platform_driver_register(&xiic_i2c_driver);
-}
-
-static void __exit xiic_i2c_exit(void)
-{
-	platform_driver_unregister(&xiic_i2c_driver);
-}
-
-module_init(xiic_i2c_init);
-module_exit(xiic_i2c_exit);
+module_platform_driver(xiic_i2c_driver);
 
 MODULE_AUTHOR("info@mocean-labs.com");
 MODULE_DESCRIPTION("Xilinx I2C bus driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:"DRIVER_NAME);
-- 
1.7.5.4



