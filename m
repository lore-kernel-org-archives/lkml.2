Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab2ECWXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:23:14 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63406 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2ECWXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:23:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1336083788!10493187!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: use module_comedi_driver
Date: Thu, 3 May 2012 15:09:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205031509.41407.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the refactored comedi drivers to use the module_comedi_driver()
macro which makes the code smaller and a bit simpler.

In the process, rename the driver variables from driver_* to *_driver,
as is more typical with other subsystems, and make sure they are all
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

This only converts the drivers that have already been refactored or
were already clean.

 drivers/staging/comedi/drivers/8255.c        |   15 +-----------
 drivers/staging/comedi/drivers/acl7225b.c    |   15 +-----------
 drivers/staging/comedi/drivers/adq12b.c      |   15 +-----------
 drivers/staging/comedi/drivers/aio_aio12_8.c |   30 +++++++------------------
 drivers/staging/comedi/drivers/aio_iiro_16.c |   15 +-----------
 drivers/staging/comedi/drivers/c6xdigio.c    |   15 +-----------
 drivers/staging/comedi/drivers/dt2815.c      |   15 +-----------
 drivers/staging/comedi/drivers/dt2817.c      |   15 +-----------
 drivers/staging/comedi/drivers/fl512.c       |   15 +-----------
 drivers/staging/comedi/drivers/pcl711.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl724.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl725.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl726.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl730.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl812.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl816.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcl818.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcm3724.c     |   15 +-----------
 drivers/staging/comedi/drivers/pcm3730.c     |   15 +-----------
 drivers/staging/comedi/drivers/pcmad.c       |   15 +-----------
 drivers/staging/comedi/drivers/pcmda12.c     |   15 +-----------
 drivers/staging/comedi/drivers/pcmmio.c      |   15 +-----------
 drivers/staging/comedi/drivers/pcmuio.c      |   15 +-----------
 drivers/staging/comedi/drivers/poc.c         |   15 +-----------
 drivers/staging/comedi/drivers/rti800.c      |   15 +-----------
 drivers/staging/comedi/drivers/rti802.c      |   15 +-----------
 drivers/staging/comedi/drivers/s526.c        |   15 +-----------
 drivers/staging/comedi/drivers/serial2002.c  |   15 +-----------
 28 files changed, 63 insertions(+), 372 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index ed80397..f709107 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -437,24 +437,13 @@ static int dev_8255_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_8255 = {
+static struct comedi_driver dev_8255_driver = {
 	.driver_name	= "8255",
 	.module		= THIS_MODULE,
 	.attach		= dev_8255_attach,
 	.detach		= dev_8255_detach,
 };
-
-static int __init driver_8255_init_module(void)
-{
-	return comedi_driver_register(&driver_8255);
-}
-module_init(driver_8255_init_module);
-
-static void __exit driver_8255_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_8255);
-}
-module_exit(driver_8255_cleanup_module);
+module_comedi_driver(dev_8255_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index ef685fc..e5f8729 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -134,7 +134,7 @@ static const struct boardtype boardtypes[] = {
 	{ "p16r16dio", P16R16DIO_SIZE, },
 };
 
-static struct comedi_driver driver_acl7225b = {
+static struct comedi_driver acl7225b_driver = {
 	.driver_name	= "acl7225b",
 	.module		= THIS_MODULE,
 	.attach		= acl7225b_attach,
@@ -143,18 +143,7 @@ static struct comedi_driver driver_acl7225b = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct boardtype),
 };
-
-static int __init driver_acl7225b_init_module(void)
-{
-	return comedi_driver_register(&driver_acl7225b);
-}
-module_init(driver_acl7225b_init_module);
-
-static void __exit driver_acl7225b_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_acl7225b);
-}
-module_exit(driver_acl7225b_cleanup_module);
+module_comedi_driver(acl7225b_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 275cb77..6a68d53 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -347,7 +347,7 @@ static const struct adq12b_board adq12b_boards[] = {
 	},
 };
 
-static struct comedi_driver driver_adq12b = {
+static struct comedi_driver adq12b_driver = {
 	.driver_name	= "adq12b",
 	.module		= THIS_MODULE,
 	.attach		= adq12b_attach,
@@ -356,18 +356,7 @@ static struct comedi_driver driver_adq12b = {
 	.offset		= sizeof(struct adq12b_board),
 	.num_names	= ARRAY_SIZE(adq12b_boards),
 };
-
-static int __init driver_adq12b_init_module(void)
-{
-	return comedi_driver_register(&driver_adq12b);
-}
-module_init(driver_adq12b_init_module);
-
-static void __exit driver_adq12b_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_adq12b);
-}
-module_exit(driver_adq12b_cleanup_module);
+module_comedi_driver(adq12b_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index b0f98e5..1a28e67 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -217,28 +217,16 @@ static int aio_aio12_8_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_aio_aio12_8 = {
-	.driver_name = "aio_aio12_8",
-	.module = THIS_MODULE,
-	.attach = aio_aio12_8_attach,
-	.detach = aio_aio12_8_detach,
-	.board_name = &board_types[0].name,
-	.num_names = 1,
-	.offset = sizeof(struct aio12_8_boardtype),
+static struct comedi_driver aio_aio12_8_driver = {
+	.driver_name	= "aio_aio12_8",
+	.module		= THIS_MODULE,
+	.attach		= aio_aio12_8_attach,
+	.detach		= aio_aio12_8_detach,
+	.board_name	= &board_types[0].name,
+	.num_names	= ARRAY_SIZE(board_types),
+	.offset		= sizeof(struct aio12_8_boardtype),
 };
-
-static int __init driver_aio_aio12_8_init_module(void)
-{
-	return comedi_driver_register(&driver_aio_aio12_8);
-}
-
-static void __exit driver_aio_aio12_8_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_aio_aio12_8);
-}
-
-module_init(driver_aio_aio12_8_init_module);
-module_exit(driver_aio_aio12_8_cleanup_module);
+module_comedi_driver(aio_aio12_8_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 763461a..242255c 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -159,7 +159,7 @@ static int aio_iiro_16_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_aio_iiro_16 = {
+static struct comedi_driver aio_iiro_16_driver = {
 	.driver_name	= "aio_iiro_16",
 	.module		= THIS_MODULE,
 	.attach		= aio_iiro_16_attach,
@@ -168,18 +168,7 @@ static struct comedi_driver driver_aio_iiro_16 = {
 	.offset		= sizeof(struct aio_iiro_16_board),
 	.num_names	= ARRAY_SIZE(aio_iiro_16_boards),
 };
-
-static int __init driver_aio_iiro_16_init_module(void)
-{
-	return comedi_driver_register(&driver_aio_iiro_16);
-}
-module_init(driver_aio_iiro_16_init_module);
-
-static void __exit driver_aio_iiro_16_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_aio_iiro_16);
-}
-module_exit(driver_aio_iiro_16_cleanup_module);
+module_comedi_driver(aio_iiro_16_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index 5f75351..56dd33a 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -508,24 +508,13 @@ static int c6xdigio_detach(struct comedi_device *dev)
 	return 0;
 }
 
-struct comedi_driver driver_c6xdigio = {
+static struct comedi_driver c6xdigio_driver = {
 	.driver_name	= "c6xdigio",
 	.module		= THIS_MODULE,
 	.attach		= c6xdigio_attach,
 	.detach		= c6xdigio_detach,
 };
-
-static int __init driver_c6xdigio_init_module(void)
-{
-	return comedi_driver_register(&driver_c6xdigio);
-}
-module_init(driver_c6xdigio_init_module);
-
-static void __exit driver_c6xdigio_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_c6xdigio);
-}
-module_exit(driver_c6xdigio_cleanup_module);
+module_comedi_driver(c6xdigio_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index f5a0dc5..152959c 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -242,24 +242,13 @@ static int dt2815_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_dt2815 = {
+static struct comedi_driver dt2815_driver = {
 	.driver_name	= "dt2815",
 	.module		= THIS_MODULE,
 	.attach		= dt2815_attach,
 	.detach		= dt2815_detach,
 };
-
-static int __init driver_dt2815_init_module(void)
-{
-	return comedi_driver_register(&driver_dt2815);
-}
-module_init(driver_dt2815_init_module);
-
-static void __exit driver_dt2815_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt2815);
-}
-module_exit(driver_dt2815_cleanup_module);
+module_comedi_driver(dt2815_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index 45d9a82..d8149f4 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -169,24 +169,13 @@ static int dt2817_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_dt2817 = {
+static struct comedi_driver dt2817_driver = {
 	.driver_name	= "dt2817",
 	.module		= THIS_MODULE,
 	.attach		= dt2817_attach,
 	.detach		= dt2817_detach,
 };
-
-static int __init driver_dt2817_init_module(void)
-{
-	return comedi_driver_register(&driver_dt2817);
-}
-module_init(driver_dt2817_init_module);
-
-static void __exit driver_dt2817_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt2817);
-}
-module_exit(driver_dt2817_cleanup_module);
+module_comedi_driver(dt2817_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index 88c18ea..25fed75 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -182,24 +182,13 @@ static int fl512_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_fl512 = {
+static struct comedi_driver fl512_driver = {
 	.driver_name	= "fl512",
 	.module		= THIS_MODULE,
 	.attach		= fl512_attach,
 	.detach		= fl512_detach,
 };
-
-static int __init driver_fl512_init_module(void)
-{
-	return comedi_driver_register(&driver_fl512);
-}
-module_init(driver_fl512_init_module);
-
-static void __exit driver_fl512_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_fl512);
-}
-module_exit(driver_fl512_cleanup_module);
+module_comedi_driver(fl512_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index fcb7cea..6a12dca 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -611,7 +611,7 @@ static const struct pcl711_board boardtypes[] = {
 	{ "acl8112dg", 0, 1, 1, 9, 16, 2, 15, &range_acl8112dg_ai },
 };
 
-static struct comedi_driver driver_pcl711 = {
+static struct comedi_driver pcl711_driver = {
 	.driver_name	= "pcl711",
 	.module		= THIS_MODULE,
 	.attach		= pcl711_attach,
@@ -620,18 +620,7 @@ static struct comedi_driver driver_pcl711 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl711_board),
 };
-
-static int __init driver_pcl711_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl711);
-}
-module_init(driver_pcl711_init_module);
-
-static void __exit driver_pcl711_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl711);
-}
-module_exit(driver_pcl711_cleanup_module);
+module_comedi_driver(pcl711_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index 7d0a306..7562858 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -205,7 +205,7 @@ static const struct pcl724_board boardtypes[] = {
 	{ "pet48dio", 48, 2, 0x9eb8, PET48_SIZE, 0, 1, },
 };
 
-static struct comedi_driver driver_pcl724 = {
+static struct comedi_driver pcl724_driver = {
 	.driver_name	= "pcl724",
 	.module		= THIS_MODULE,
 	.attach		= pcl724_attach,
@@ -214,18 +214,7 @@ static struct comedi_driver driver_pcl724 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl724_board),
 };
-
-static int __init driver_pcl724_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl724);
-}
-module_init(driver_pcl724_init_module);
-
-static void __exit driver_pcl724_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl724);
-}
-module_exit(driver_pcl724_cleanup_module);
+module_comedi_driver(pcl724_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index 4b761a6..eeac943 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -99,24 +99,13 @@ static int pcl725_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_pcl725 = {
+static struct comedi_driver pcl725_driver = {
 	.driver_name	= "pcl725",
 	.module		= THIS_MODULE,
 	.attach		= pcl725_attach,
 	.detach		= pcl725_detach,
 };
-
-static int __init driver_pcl725_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl725);
-}
-module_init(driver_pcl725_init_module);
-
-static void __exit driver_pcl725_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl725);
-}
-module_exit(driver_pcl725_cleanup_module);
+module_comedi_driver(pcl725_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index c63e91c..8e2fb36 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -365,7 +365,7 @@ static int pcl726_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_pcl726 = {
+static struct comedi_driver pcl726_driver = {
 	.driver_name	= "pcl726",
 	.module		= THIS_MODULE,
 	.attach		= pcl726_attach,
@@ -374,18 +374,7 @@ static struct comedi_driver driver_pcl726 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl726_board),
 };
-
-static int __init driver_pcl726_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl726);
-}
-module_init(driver_pcl726_init_module);
-
-static void __exit driver_pcl726_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl726);
-}
-module_exit(driver_pcl726_cleanup_module);
+module_comedi_driver(pcl726_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index f6fa8ae..73b4394 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -150,7 +150,7 @@ static const struct pcl730_board boardtypes[] = {
 	{ "acl7130", ACL7130_SIZE, },
 };
 
-static struct comedi_driver driver_pcl730 = {
+static struct comedi_driver pcl730_driver = {
 	.driver_name	= "pcl730",
 	.module		= THIS_MODULE,
 	.attach		= pcl730_attach,
@@ -159,18 +159,7 @@ static struct comedi_driver driver_pcl730 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl730_board),
 };
-
-static int __init driver_pcl730_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl730);
-}
-module_init(driver_pcl730_init_module);
-
-static void __exit driver_pcl730_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl730);
-}
-module_exit(driver_pcl730_cleanup_module);
+module_comedi_driver(pcl730_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 85463e2..613b397 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -1681,7 +1681,7 @@ static const struct pcl812_board boardtypes[] = {
 	 0xdcfc, 0x0a, PCLx1x_IORANGE, 0},
 };
 
-static struct comedi_driver driver_pcl812 = {
+static struct comedi_driver pcl812_driver = {
 	.driver_name	= "pcl812",
 	.module		= THIS_MODULE,
 	.attach		= pcl812_attach,
@@ -1690,18 +1690,7 @@ static struct comedi_driver driver_pcl812 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl812_board),
 };
-
-static int __init driver_pcl812_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl812);
-}
-module_init(driver_pcl812_init_module);
-
-static void __exit driver_pcl812_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl812);
-}
-module_exit(driver_pcl812_cleanup_module);
+module_comedi_driver(pcl812_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index bccbb23..1559c05 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -1317,7 +1317,7 @@ static const struct pcl816_board boardtypes[] = {
 	 100},
 };
 
-static struct comedi_driver driver_pcl816 = {
+static struct comedi_driver pcl816_driver = {
 	.driver_name	= "pcl816",
 	.module		= THIS_MODULE,
 	.attach		= pcl816_attach,
@@ -1326,18 +1326,7 @@ static struct comedi_driver driver_pcl816 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl816_board),
 };
-
-static int __init driver_pcl816_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl816);
-}
-module_init(driver_pcl816_init_module);
-
-static void __exit driver_pcl816_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl816);
-}
-module_exit(driver_pcl816_cleanup_module);
+module_comedi_driver(pcl816_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 8dbefc5..9b8a1ff 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1992,7 +1992,7 @@ static const struct pcl818_board boardtypes[] = {
 	 0x0a, 0xfff, 0xfff, 0, 1 /* XXX ? */ },
 };
 
-static struct comedi_driver driver_pcl818 = {
+static struct comedi_driver pcl818_driver = {
 	.driver_name	= "pcl818",
 	.module		= THIS_MODULE,
 	.attach		= pcl818_attach,
@@ -2001,18 +2001,7 @@ static struct comedi_driver driver_pcl818 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcl818_board),
 };
-
-static int __init driver_pcl818_init_module(void)
-{
-	return comedi_driver_register(&driver_pcl818);
-}
-module_init(driver_pcl818_init_module);
-
-static void __exit driver_pcl818_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcl818);
-}
-module_exit(driver_pcl818_cleanup_module);
+module_comedi_driver(pcl818_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index 88a354b..36c0459 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -291,7 +291,7 @@ static const struct pcm3724_board boardtypes[] = {
 	{ "pcm3724", 48, 2, 0x00fc, PCM3724_SIZE, },
 };
 
-static struct comedi_driver driver_pcm3724 = {
+static struct comedi_driver pcm3724_driver = {
 	.driver_name	= "pcm3724",
 	.module		= THIS_MODULE,
 	.attach		= pcm3724_attach,
@@ -300,18 +300,7 @@ static struct comedi_driver driver_pcm3724 = {
 	.num_names	= ARRAY_SIZE(boardtypes),
 	.offset		= sizeof(struct pcm3724_board),
 };
-
-static int __init driver_pcm3724_init_module(void)
-{
-	return comedi_driver_register(&driver_pcm3724);
-}
-module_init(driver_pcm3724_init_module);
-
-static void __exit driver_pcm3724_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcm3724);
-}
-module_exit(driver_pcm3724_cleanup_module);
+module_comedi_driver(pcm3724_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index 3428993..1571b83 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -143,24 +143,13 @@ static int pcm3730_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_pcm3730 = {
+static struct comedi_driver pcm3730_driver = {
 	.driver_name	= "pcm3730",
 	.module		= THIS_MODULE,
 	.attach		= pcm3730_attach,
 	.detach		= pcm3730_detach,
 };
-
-static int __init driver_pcm3730_init_module(void)
-{
-	return comedi_driver_register(&driver_pcm3730);
-}
-module_init(driver_pcm3730_init_module);
-
-static void __exit driver_pcm3730_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcm3730);
-}
-module_exit(driver_pcm3730_cleanup_module);
+module_comedi_driver(pcm3730_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index fe8ef66..05a2363 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -161,7 +161,7 @@ static const struct pcmad_board_struct pcmad_boards[] = {
 		.n_ai_bits	= 16,
 	},
 };
-static struct comedi_driver driver_pcmad = {
+static struct comedi_driver pcmad_driver = {
 	.driver_name	= "pcmad",
 	.module		= THIS_MODULE,
 	.attach		= pcmad_attach,
@@ -170,18 +170,7 @@ static struct comedi_driver driver_pcmad = {
 	.num_names	= ARRAY_SIZE(pcmad_boards),
 	.offset		= sizeof(pcmad_boards[0]),
 };
-
-static int __init driver_pcmad_init_module(void)
-{
-	return comedi_driver_register(&driver_pcmad);
-}
-module_init(driver_pcmad_init_module);
-
-static void __exit driver_pcmad_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcmad);
-}
-module_exit(driver_pcmad_cleanup_module);
+module_comedi_driver(pcmad_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index a82b343..aaea0e6 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -242,7 +242,7 @@ static const struct pcmda12_board pcmda12_boards[] = {
 	},
 };
 
-static struct comedi_driver driver = {
+static struct comedi_driver pcmda12_driver = {
 	.driver_name	= "pcmda12",
 	.module		= THIS_MODULE,
 	.attach		= pcmda12_attach,
@@ -251,18 +251,7 @@ static struct comedi_driver driver = {
 	.offset		= sizeof(struct pcmda12_board),
 	.num_names	= ARRAY_SIZE(pcmda12_boards),
 };
-
-static int __init driver_init_module(void)
-{
-	return comedi_driver_register(&driver);
-}
-module_init(driver_init_module);
-
-static void __exit driver_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver);
-}
-module_exit(driver_cleanup_module);
+module_comedi_driver(pcmda12_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 9ee1da5..a977acb 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1261,7 +1261,7 @@ static const struct pcmmio_board pcmmio_boards[] = {
 	},
 };
 
-static struct comedi_driver driver = {
+static struct comedi_driver pcmmio_driver = {
 	.driver_name	= "pcmmio",
 	.module		= THIS_MODULE,
 	.attach		= pcmmio_attach,
@@ -1270,18 +1270,7 @@ static struct comedi_driver driver = {
 	.offset		= sizeof(struct pcmmio_board),
 	.num_names	= ARRAY_SIZE(pcmmio_boards),
 };
-
-static int __init driver_init_module(void)
-{
-	return comedi_driver_register(&driver);
-}
-module_init(driver_init_module);
-
-static void __exit driver_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver);
-}
-module_exit(driver_cleanup_module);
+module_comedi_driver(pcmmio_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 47a3ee6..b18912a 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -940,7 +940,7 @@ static const struct pcmuio_board pcmuio_boards[] = {
 	},
 };
 
-static struct comedi_driver driver = {
+static struct comedi_driver pcmuio_driver = {
 	.driver_name	= "pcmuio",
 	.module		= THIS_MODULE,
 	.attach		= pcmuio_attach,
@@ -949,18 +949,7 @@ static struct comedi_driver driver = {
 	.offset		= sizeof(struct pcmuio_board),
 	.num_names	= ARRAY_SIZE(pcmuio_boards),
 };
-
-static int __init driver_init_module(void)
-{
-	return comedi_driver_register(&driver);
-}
-module_init(driver_init_module);
-
-static void __exit driver_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver);
-}
-module_exit(driver_cleanup_module);
+module_comedi_driver(pcmuio_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index e3690bb..2e50c7f 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -222,7 +222,7 @@ static const struct boarddef_struct boards[] = {
 	},
 };
 
-static struct comedi_driver driver_poc = {
+static struct comedi_driver poc_driver = {
 	.driver_name	= "poc",
 	.module		= THIS_MODULE,
 	.attach		= poc_attach,
@@ -231,18 +231,7 @@ static struct comedi_driver driver_poc = {
 	.num_names	= ARRAY_SIZE(boards),
 	.offset		= sizeof(boards[0]),
 };
-
-static int __init driver_poc_init_module(void)
-{
-	return comedi_driver_register(&driver_poc);
-}
-module_init(driver_poc_init_module);
-
-static void __exit driver_poc_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_poc);
-}
-module_exit(driver_poc_cleanup_module);
+module_comedi_driver(poc_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 9e082b3..c073bf4 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -461,7 +461,7 @@ static const struct rti800_board boardtypes[] = {
 	{ "rti815", 1 },
 };
 
-static struct comedi_driver driver_rti800 = {
+static struct comedi_driver rti800_driver = {
 	.driver_name	= "rti800",
 	.module		= THIS_MODULE,
 	.attach		= rti800_attach,
@@ -470,18 +470,7 @@ static struct comedi_driver driver_rti800 = {
 	.board_name	= &boardtypes[0].name,
 	.offset		= sizeof(struct rti800_board),
 };
-
-static int __init driver_rti800_init_module(void)
-{
-	return comedi_driver_register(&driver_rti800);
-}
-module_init(driver_rti800_init_module);
-
-static void __exit driver_rti800_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_rti800);
-}
-module_exit(driver_rti800_cleanup_module);
+module_comedi_driver(rti800_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index 21baf1a..b4980b4 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -139,24 +139,13 @@ static int rti802_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_rti802 = {
+static struct comedi_driver rti802_driver = {
 	.driver_name	= "rti802",
 	.module		= THIS_MODULE,
 	.attach		= rti802_attach,
 	.detach		= rti802_detach,
 };
-
-static int __init driver_rti802_init_module(void)
-{
-	return comedi_driver_register(&driver_rti802);
-}
-module_init(driver_rti802_init_module);
-
-static void __exit driver_rti802_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_rti802);
-}
-module_exit(driver_rti802_cleanup_module);
+module_comedi_driver(rti802_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index ffe4362..3f86ed7 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -948,7 +948,7 @@ static int s526_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static struct comedi_driver driver_s526 = {
+static struct comedi_driver s526_driver = {
 	.driver_name	= "s526",
 	.module		= THIS_MODULE,
 	.attach		= s526_attach,
@@ -957,18 +957,7 @@ static struct comedi_driver driver_s526 = {
 	.offset		= sizeof(struct s526_board),
 	.num_names	= ARRAY_SIZE(s526_boards),
 };
-
-static int __init driver_s526_init_module(void)
-{
-	return comedi_driver_register(&driver_s526);
-}
-module_init(driver_s526_init_module);
-
-static void __exit driver_s526_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_s526);
-}
-module_exit(driver_s526_cleanup_module);
+module_comedi_driver(s526_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index a034b10..0fbd9f9 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -868,7 +868,7 @@ static const struct serial2002_board serial2002_boards[] = {
 	},
 };
 
-struct comedi_driver driver_serial2002 = {
+static struct comedi_driver serial2002_driver = {
 	.driver_name	= "serial2002",
 	.module		= THIS_MODULE,
 	.attach		= serial2002_attach,
@@ -877,18 +877,7 @@ struct comedi_driver driver_serial2002 = {
 	.offset		= sizeof(struct serial2002_board),
 	.num_names	= ARRAY_SIZE(serial2002_boards),
 };
-
-static int __init driver_serial2002_init_module(void)
-{
-	return comedi_driver_register(&driver_serial2002);
-}
-module_init(driver_serial2002_init_module);
-
-static void __exit driver_serial2002_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_serial2002);
-}
-module_exit(driver_serial2002_cleanup_module);
+module_comedi_driver(serial2002_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
