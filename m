Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1AFAEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:04:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:60668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab1AFAET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:04:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874833952"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg@vger.kernel.org, Kroah-Hartman@vger.kernel.org, <gregkh@suse.de>,
        Vasiliy@vger.kernel.org, Kulikov@vger.kernel.org,
        <segoon@openwall.com>, Alan@vger.kernel.org, Cox@vger.kernel.org,
        <alan@linux.intel.com>, Russ@vger.kernel.org, Gorby@vger.kernel.org,
        <richardx.r.gorby@intel.com>, linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com
Subject: [PATCH 7/7] serial: ifx6x60: minor cleanup
Date: Wed,  5 Jan 2011 16:05:13 -0800
Message-Id: <1294272313-15899-8-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renamed spi_driver variable to not be h/w specific
set driver name to use DRVNAME define
removed commented-out define

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/serial/ifx6x60.c |    8 ++++----
 drivers/serial/ifx6x60.h |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/ifx6x60.c b/drivers/serial/ifx6x60.c
index 5a0321a..e296f97 100644
--- a/drivers/serial/ifx6x60.c
+++ b/drivers/serial/ifx6x60.c
@@ -1342,9 +1342,9 @@ static const struct spi_device_id ifx_id_table[] = {
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
@@ -1366,7 +1366,7 @@ static void __exit ifx_spi_exit(void)
 {
 	/* unregister */
 	tty_unregister_driver(tty_drv);
-	spi_unregister_driver((void *)&ifx_spi_driver_6160);
+	spi_unregister_driver((void *)&ifx_spi_driver);
 }
 
 /**
@@ -1408,7 +1408,7 @@ static int __init ifx_spi_init(void)
 		return result;
 	}
 
-	result = spi_register_driver((void *)&ifx_spi_driver_6160);
+	result = spi_register_driver((void *)&ifx_spi_driver);
 	if (result) {
 		pr_err("%s: spi_register_driver failed(%d)",
 			DRVNAME, result);
diff --git a/drivers/serial/ifx6x60.h b/drivers/serial/ifx6x60.h
index deb7b8d..5952c40 100644
--- a/drivers/serial/ifx6x60.h
+++ b/drivers/serial/ifx6x60.h
@@ -29,8 +29,6 @@
 #define DRVNAME				"ifx6x60"
 #define TTYNAME				"ttyIFX"
 
-/* #define IFX_THROTTLE_CODE */
-
 #define IFX_SPI_MAX_MINORS		1
 #define IFX_SPI_TRANSFER_SIZE		2048
 #define IFX_SPI_FIFO_SIZE		4096
-- 
1.7.2.3

