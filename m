Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2A0IDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:03:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54100 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2A0IDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:03:07 -0500
Message-ID: <1327651374.7772.1.camel@phoenix>
Subject: [PATCH] video: convert drivers/video/* to use module_spi_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@nokia.com>, Roger Quadros <roger.quadros@nokia.com>,
        Steve Sakoman <steve@sakoman.com>, Erik Gilling <konkers@android.com>,
        Gra Ignotas <notasas@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
Date: Fri, 27 Jan 2012 16:02:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/video/* to use the
module_spi_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Imre Deak <imre.deak@nokia.com>
Cc: Roger Quadros <roger.quadros@nokia.com>
Cc: Steve Sakoman <steve@sakoman.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Gražvydas Ignotas <notasas@gmail.com>
---
 drivers/video/omap/lcd_mipid.c                     |   14 +-------------
 drivers/video/omap2/displays/panel-acx565akm.c     |   13 +------------
 .../omap2/displays/panel-lgphilips-lb035q02.c      |   12 +-----------
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |   12 +-----------
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   13 +------------
 5 files changed, 5 insertions(+), 59 deletions(-)

diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/omap/lcd_mipid.c
index 8d546dd..e3880c4 100644
--- a/drivers/video/omap/lcd_mipid.c
+++ b/drivers/video/omap/lcd_mipid.c
@@ -609,19 +609,7 @@ static struct spi_driver mipid_spi_driver = {
 	.remove	= __devexit_p(mipid_spi_remove),
 };
 
-static int __init mipid_drv_init(void)
-{
-	spi_register_driver(&mipid_spi_driver);
-
-	return 0;
-}
-module_init(mipid_drv_init);
-
-static void __exit mipid_drv_cleanup(void)
-{
-	spi_unregister_driver(&mipid_spi_driver);
-}
-module_exit(mipid_drv_cleanup);
+module_spi_driver(mipid_spi_driver);
 
 MODULE_DESCRIPTION("MIPI display driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
index 51a87e1..d26f37a 100644
--- a/drivers/video/omap2/displays/panel-acx565akm.c
+++ b/drivers/video/omap2/displays/panel-acx565akm.c
@@ -809,18 +809,7 @@ static struct spi_driver acx565akm_spi_driver = {
 	.remove	= __devexit_p(acx565akm_spi_remove),
 };
 
-static int __init acx565akm_init(void)
-{
-	return spi_register_driver(&acx565akm_spi_driver);
-}
-
-static void __exit acx565akm_exit(void)
-{
-	spi_unregister_driver(&acx565akm_spi_driver);
-}
-
-module_init(acx565akm_init);
-module_exit(acx565akm_exit);
+module_spi_driver(acx565akm_spi_driver);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("acx565akm LCD Driver");
diff --git a/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c b/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
index e0eb35b..0841cc2 100644
--- a/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
+++ b/drivers/video/omap2/displays/panel-lgphilips-lb035q02.c
@@ -264,16 +264,6 @@ static struct spi_driver lb035q02_spi_driver = {
 	.remove		= __devexit_p(lb035q02_panel_spi_remove),
 };
 
-static int __init lb035q02_panel_drv_init(void)
-{
-	return spi_register_driver(&lb035q02_spi_driver);
-}
-
-static void __exit lb035q02_panel_drv_exit(void)
-{
-	spi_unregister_driver(&lb035q02_spi_driver);
-}
+module_spi_driver(lb035q02_spi_driver);
 
-module_init(lb035q02_panel_drv_init);
-module_exit(lb035q02_panel_drv_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
index 0eb31ca..8b38b39 100644
--- a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
+++ b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
@@ -350,18 +350,8 @@ static struct spi_driver nec_8048_spi_driver = {
 	},
 };
 
-static int __init nec_8048_lcd_init(void)
-{
-	return spi_register_driver(&nec_8048_spi_driver);
-}
-
-static void __exit nec_8048_lcd_exit(void)
-{
-	return spi_unregister_driver(&nec_8048_spi_driver);
-}
+module_spi_driver(nec_8048_spi_driver);
 
-module_init(nec_8048_lcd_init);
-module_exit(nec_8048_lcd_exit);
 MODULE_AUTHOR("Erik Gilling <konkers@android.com>");
 MODULE_DESCRIPTION("NEC-nl8048hl11-01b Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
index e6649aa..1d6b7fb 100644
--- a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
+++ b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
@@ -518,18 +518,7 @@ static struct spi_driver tpo_td043_spi_driver = {
 	.remove	= __devexit_p(tpo_td043_spi_remove),
 };
 
-static int __init tpo_td043_init(void)
-{
-	return spi_register_driver(&tpo_td043_spi_driver);
-}
-
-static void __exit tpo_td043_exit(void)
-{
-	spi_unregister_driver(&tpo_td043_spi_driver);
-}
-
-module_init(tpo_td043_init);
-module_exit(tpo_td043_exit);
+module_spi_driver(tpo_td043_spi_driver);
 
 MODULE_AUTHOR("Gražvydas Ignotas <notasas@gmail.com>");
 MODULE_DESCRIPTION("TPO TD043MTEA1 LCD Driver");
-- 
1.7.5.4



