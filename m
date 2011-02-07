Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1BGT5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:57:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:39062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab1BGT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:57:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600292958"
From: Russ Gorby <russ.gorby@intel.com>
To: Russ Gorby <russ.gorby@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 6/6] serial: ifx6x60: minor cleanup
Date: Mon,  7 Feb 2011 12:02:32 -0800
Message-Id: <1297108952-27371-7-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
References: <[PATCH 0/6] IFX6X60 patchset : 02/07/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renamed spi_driver variable to not be h/w specific
set driver name to use DRVNAME define
removed commented-out define

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/serial/ifx6x60.c |    8 ++++----
 drivers/tty/serial/ifx6x60.h |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 59e9cb8..b68b96f 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -1333,9 +1333,9 @@ static const struct spi_device_id ifx_id_table[] = {
 MODULE_DEVICE_TABLE(spi, ifx_id_table);
 
 /* spi operations */
-static const struct spi_driver ifx_spi_driver_6160 = {
+static const struct spi_driver ifx_spi_driver = {
 	.driver = {
-		.name = "ifx6160",
+		.name = DRVNAME,
 		.bus = &spi_bus_type,
 		.pm = &ifx_spi_pm,
 		.owner = THIS_MODULE},
@@ -1357,7 +1357,7 @@ static void __exit ifx_spi_exit(void)
 {
 	/* unregister */
 	tty_unregister_driver(tty_drv);
-	spi_unregister_driver((void *)&ifx_spi_driver_6160);
+	spi_unregister_driver((void *)&ifx_spi_driver);
 }
 
 /**
@@ -1399,7 +1399,7 @@ static int __init ifx_spi_init(void)
 		return result;
 	}
 
-	result = spi_register_driver((void *)&ifx_spi_driver_6160);
+	result = spi_register_driver((void *)&ifx_spi_driver);
 	if (result) {
 		pr_err("%s: spi_register_driver failed(%d)",
 			DRVNAME, result);
diff --git a/drivers/tty/serial/ifx6x60.h b/drivers/tty/serial/ifx6x60.h
index 0ec39b5..e8464ba 100644
--- a/drivers/tty/serial/ifx6x60.h
+++ b/drivers/tty/serial/ifx6x60.h
@@ -29,8 +29,6 @@
 #define DRVNAME				"ifx6x60"
 #define TTYNAME				"ttyIFX"
 
-/* #define IFX_THROTTLE_CODE */
-
 #define IFX_SPI_MAX_MINORS		1
 #define IFX_SPI_TRANSFER_SIZE		2048
 #define IFX_SPI_FIFO_SIZE		4096
-- 
1.7.3.4

