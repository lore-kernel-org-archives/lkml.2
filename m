Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2G0Qw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:52:57 -0400
Received: from mail.tpi.com ([70.99.223.143]:4161 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2G0Qwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:52:55 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH v2] ene_ub6250: Use macros for firmware names
Date: Fri, 27 Jul 2012 10:53:21 -0600
Message-Id: <1343408001-50174-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343167097.25735.79.camel@ejdallLaptop>
References: <1343167097.25735.79.camel@ejdallLaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Advertise firmware files using MODULE_FIRMWARE macros.

Fix a debug string: SD_RDWR_PATTERN --> SD_RW_PATTERN

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/usb/storage/ene_ub6250.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index b28f2ad..95edee5 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -29,9 +29,21 @@
 #include "protocol.h"
 #include "debug.h"
 
+#define SD_INIT1_FIRMWARE "ene-ub6250/sd_init1.bin"
+#define SD_INIT2_FIRMWARE "ene-ub6250/sd_init2.bin"
+#define SD_RW_FIRMWARE "ene-ub6250/sd_rdwr.bin"
+#define MS_INIT_FIRMWARE "ene-ub6250/ms_init.bin"
+#define MSP_RW_FIRMWARE "ene-ub6250/msp_rdwr.bin"
+#define MS_RW_FIRMWARE "ene-ub6250/ms_rdwr.bin"
+
 MODULE_DESCRIPTION("Driver for ENE UB6250 reader");
 MODULE_LICENSE("GPL");
-
+MODULE_FIRMWARE(SD_INIT1_FIRMWARE);
+MODULE_FIRMWARE(SD_INIT2_FIRMWARE);
+MODULE_FIRMWARE(SD_RW_FIRMWARE);
+MODULE_FIRMWARE(MS_INIT_FIRMWARE);
+MODULE_FIRMWARE(MSP_RW_FIRMWARE);
+MODULE_FIRMWARE(MS_RW_FIRMWARE);
 
 /*
  * The table of devices
@@ -1883,28 +1895,28 @@ static int ene_load_bincode(struct us_data *us, unsigned char flag)
 	/* For SD */
 	case SD_INIT1_PATTERN:
 		US_DEBUGP("SD_INIT1_PATTERN\n");
-		fw_name = "ene-ub6250/sd_init1.bin";
+		fw_name = SD_INIT1_FIRMWARE;
 		break;
 	case SD_INIT2_PATTERN:
 		US_DEBUGP("SD_INIT2_PATTERN\n");
-		fw_name = "ene-ub6250/sd_init2.bin";
+		fw_name = SD_INIT2_FIRMWARE;
 		break;
 	case SD_RW_PATTERN:
-		US_DEBUGP("SD_RDWR_PATTERN\n");
-		fw_name = "ene-ub6250/sd_rdwr.bin";
+		US_DEBUGP("SD_RW_PATTERN\n");
+		fw_name = SD_RW_FIRMWARE;
 		break;
 	/* For MS */
 	case MS_INIT_PATTERN:
 		US_DEBUGP("MS_INIT_PATTERN\n");
-		fw_name = "ene-ub6250/ms_init.bin";
+		fw_name = MS_INIT_FIRMWARE;
 		break;
 	case MSP_RW_PATTERN:
 		US_DEBUGP("MSP_RW_PATTERN\n");
-		fw_name = "ene-ub6250/msp_rdwr.bin";
+		fw_name = MSP_RW_FIRMWARE;
 		break;
 	case MS_RW_PATTERN:
 		US_DEBUGP("MS_RW_PATTERN\n");
-		fw_name = "ene-ub6250/ms_rdwr.bin";
+		fw_name = MS_RW_FIRMWARE;
 		break;
 	default:
 		US_DEBUGP("----------- Unknown PATTERN ----------\n");
-- 
1.7.9.5

