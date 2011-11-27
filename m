Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1K0ExQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 23:53:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52951 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1K0ExO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 23:53:14 -0500
Message-ID: <1322369586.2522.3.camel@phoenix>
Subject: [PATCH] pcmcia: convert drivers/pcmcia/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Olof Johansson <olof@lixom.net>,
        Marc Zyngier <maz@misterjones.org>, Ralf Baechle <ralf@linux-mips.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pcmcia@lists.infradead.org
Date: Sun, 27 Nov 2011 12:53:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/pcmcia/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Manuel Lauss <manuel.lauss@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Marc Zyngier <maz@misterjones.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pcmcia/bfin_cf_pcmcia.c |   13 +------------
 drivers/pcmcia/db1xxx_ss.c      |   13 +------------
 drivers/pcmcia/electra_cf.c     |   12 +-----------
 drivers/pcmcia/m8xx_pcmcia.c    |   13 +------------
 drivers/pcmcia/pxa2xx_viper.c   |   13 +------------
 drivers/pcmcia/xxs1500_ss.c     |   13 +------------
 6 files changed, 6 insertions(+), 71 deletions(-)

diff --git a/drivers/pcmcia/bfin_cf_pcmcia.c b/drivers/pcmcia/bfin_cf_pcmcia.c
index 4922139..ac1a223 100644
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -310,18 +310,7 @@ static struct platform_driver bfin_cf_driver = {
 	.remove = __devexit_p(bfin_cf_remove),
 };
 
-static int __init bfin_cf_init(void)
-{
-	return platform_driver_register(&bfin_cf_driver);
-}
-
-static void __exit bfin_cf_exit(void)
-{
-	platform_driver_unregister(&bfin_cf_driver);
-}
-
-module_init(bfin_cf_init);
-module_exit(bfin_cf_exit);
+module_platform_driver(bfin_cf_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("BFIN CF/PCMCIA Driver");
diff --git a/drivers/pcmcia/db1xxx_ss.c b/drivers/pcmcia/db1xxx_ss.c
index 5b7c227..ba299a2 100644
--- a/drivers/pcmcia/db1xxx_ss.c
+++ b/drivers/pcmcia/db1xxx_ss.c
@@ -580,18 +580,7 @@ static struct platform_driver db1x_pcmcia_socket_driver = {
 	.remove		= __devexit_p(db1x_pcmcia_socket_remove),
 };
 
-int __init db1x_pcmcia_socket_load(void)
-{
-	return platform_driver_register(&db1x_pcmcia_socket_driver);
-}
-
-void  __exit db1x_pcmcia_socket_unload(void)
-{
-	platform_driver_unregister(&db1x_pcmcia_socket_driver);
-}
-
-module_init(db1x_pcmcia_socket_load);
-module_exit(db1x_pcmcia_socket_unload);
+module_platform_driver(db1x_pcmcia_socket_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCMCIA Socket Services for Alchemy Db/Pb1x00 boards");
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 06ad3e5..7647d23 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -365,17 +365,7 @@ static struct platform_driver electra_cf_driver = {
 	.remove   = electra_cf_remove,
 };
 
-static int __init electra_cf_init(void)
-{
-	return platform_driver_register(&electra_cf_driver);
-}
-module_init(electra_cf_init);
-
-static void __exit electra_cf_exit(void)
-{
-	platform_driver_unregister(&electra_cf_driver);
-}
-module_exit(electra_cf_exit);
+module_platform_driver(electra_cf_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR ("Olof Johansson <olof@lixom.net>");
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 271a590..b120928 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -1304,15 +1304,4 @@ static struct platform_driver m8xx_pcmcia_driver = {
 	.remove = m8xx_remove,
 };
 
-static int __init m8xx_init(void)
-{
-	return platform_driver_register(&m8xx_pcmcia_driver);
-}
-
-static void __exit m8xx_exit(void)
-{
-	platform_driver_unregister(&m8xx_pcmcia_driver);
-}
-
-module_init(m8xx_init);
-module_exit(m8xx_exit);
+module_platform_driver(m8xx_pcmcia_driver);
diff --git a/drivers/pcmcia/pxa2xx_viper.c b/drivers/pcmcia/pxa2xx_viper.c
index 1064b1c..44f5c7f 100644
--- a/drivers/pcmcia/pxa2xx_viper.c
+++ b/drivers/pcmcia/pxa2xx_viper.c
@@ -204,18 +204,7 @@ static struct platform_driver viper_pcmcia_driver = {
 	.id_table	= viper_pcmcia_id_table,
 };
 
-static int __init viper_pcmcia_init(void)
-{
-	return platform_driver_register(&viper_pcmcia_driver);
-}
-
-static void __exit viper_pcmcia_exit(void)
-{
-	return platform_driver_unregister(&viper_pcmcia_driver);
-}
-
-module_init(viper_pcmcia_init);
-module_exit(viper_pcmcia_exit);
+module_platform_driver(viper_pcmcia_driver);
 
 MODULE_DEVICE_TABLE(platform, viper_pcmcia_id_table);
 MODULE_LICENSE("GPL");
diff --git a/drivers/pcmcia/xxs1500_ss.c b/drivers/pcmcia/xxs1500_ss.c
index 379f421..1ceff69 100644
--- a/drivers/pcmcia/xxs1500_ss.c
+++ b/drivers/pcmcia/xxs1500_ss.c
@@ -321,18 +321,7 @@ static struct platform_driver xxs1500_pcmcia_socket_driver = {
 	.remove		= __devexit_p(xxs1500_pcmcia_remove),
 };
 
-int __init xxs1500_pcmcia_socket_load(void)
-{
-	return platform_driver_register(&xxs1500_pcmcia_socket_driver);
-}
-
-void  __exit xxs1500_pcmcia_socket_unload(void)
-{
-	platform_driver_unregister(&xxs1500_pcmcia_socket_driver);
-}
-
-module_init(xxs1500_pcmcia_socket_load);
-module_exit(xxs1500_pcmcia_socket_unload);
+module_platform_driver(xxs1500_pcmcia_socket_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCMCIA Socket Services for MyCable XXS1500 systems");
-- 
1.7.5.4



