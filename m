Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab2GYTIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:08:15 -0400
Received: from mail.tpi.com ([70.99.223.143]:1613 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2GYTIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:08:14 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Mike McCormack <mikem@ring3k.org>, wlanfae <wlanfae@realtek.com>,
        Sean MacLennan <seanm@seanm.ca>, devel@driverdev.osuosl.org
Subject: [PATCH] staging rtl8192e: Declare MODULE_FIRMWARE usage
Date: Wed, 25 Jul 2012 13:08:47 -0600
Message-Id: <1343243327-6153-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mike McCormack <mikem@ring3k.org>
Cc: wlanfae <wlanfae@realtek.com>
Cc: Sean MacLennan <seanm@seanm.ca>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |    9 +++++----
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.h    |    4 ++++
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |    3 +++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index b526fa4..dd2a96b 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -265,10 +265,11 @@ bool init_firmware(struct net_device *dev)
 			case FW_SOURCE_IMG_FILE:
 			{
 				if (pfirmware->firmware_buf_size[init_step] == 0) {
-					const char *fw_name[3] = { "RTL8192E/boot.img",
-							   "RTL8192E/main.img",
-							   "RTL8192E/data.img"
-							 };
+					const char *fw_name[3] = {
+							RTL8192E_BOOT_IMG_FW,
+							RTL8192E_MAIN_IMG_FW,
+							RTL8192E_DATA_IMG_FW
+					};
 					const struct firmware	*fw_entry;
 					int rc;
 					rc = request_firmware(&fw_entry,
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.h b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.h
index caa8788..06d6abc 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.h
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.h
@@ -23,6 +23,10 @@
 
 #define GET_COMMAND_PACKET_FRAG_THRESHOLD(v)	(4*(v/4) - 8)
 
+#define RTL8192E_BOOT_IMG_FW	"RTL8192E/boot.img"
+#define RTL8192E_MAIN_IMG_FW	"RTL8192E/main.img"
+#define RTL8192E_DATA_IMG_FW	"RTL8192E/data.img"
+
 enum firmware_init_step {
 	FW_INIT_STEP0_BOOT = 0,
 	FW_INIT_STEP1_MAIN = 1,
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 4f602b2..42e5c5c 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -3125,6 +3125,9 @@ MODULE_DESCRIPTION("Linux driver for Realtek RTL819x WiFi cards");
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(RTL8192E_BOOT_IMG_FW);
+MODULE_FIRMWARE(RTL8192E_MAIN_IMG_FW);
+MODULE_FIRMWARE(RTL8192E_DATA_IMG_FW);
 
 module_param(ifname, charp, S_IRUGO|S_IWUSR);
 module_param(hwwep, int, S_IRUGO|S_IWUSR);
-- 
1.7.9.5

