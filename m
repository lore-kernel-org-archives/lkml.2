Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1AYO0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:26:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1AYOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:25:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Jt4SYUWmbOde+1KesPfOiqGWnTT0S/0+5ekhwSZM+tlRX/IFg7yEF9aJeVLIVCAfv0
         ybpNYzgmExGypJ7K9HmwZwkS8ZeLLJ10dsk1elIlM1cn09ZR+aA7yd8eM8A5tcc1b/SM
         4EhAz1kMz+fC2SJeGOI1mPZVtOop68viBIROY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: ft1000: Fix coding style issues in ft1000_proc.c file.
Date: Tue, 25 Jan 2011 15:26:27 +0100
Message-Id: <1295965587-23754-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |   58 ++++++++++++----------
 1 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index b87542a..a012bdd 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -30,28 +30,34 @@
 #define FT1000_PROC_DIR "ft1000"
 
 
-#define PUTM_TO_PAGE(len,page,args...) \
-	len += snprintf(page+len, PAGE_SIZE - len, args)
-
-#define PUTX_TO_PAGE(len,page,message,size,var) \
-	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for (i = 0; i < (size - 1); i++) {\
-		len += snprintf(page+len, PAGE_SIZE - len, "%02x:", var[i]); \
-	} \
-	len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i])
-
-#define PUTD_TO_PAGE(len,page,message,size,var) \
-	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for (i = 0; i < (size - 1); i++) {\
-		len += snprintf(page+len, PAGE_SIZE - len, "%d.", var[i]); \
-	} \
-	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
+#define PUTM_TO_PAGE(len, page, args...) \
+	(len += snprintf(page+len, PAGE_SIZE - len, args))
+
+#define PUTX_TO_PAGE(len, page, message, size, var) \
+	do { \
+		len += snprintf(page+len, PAGE_SIZE - len, message); \
+		for (i = 0; i < (size - 1); i++) {\
+			len += snprintf(page+len, PAGE_SIZE - len, "%02x:", \
+					var[i]); \
+		} \
+		len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i]); \
+	} while (0)
+
+#define PUTD_TO_PAGE(len, page, message, size, var) \
+	do { \
+		len += snprintf(page+len, PAGE_SIZE - len, message); \
+		for (i = 0; i < (size - 1); i++) {\
+			len += snprintf(page+len, PAGE_SIZE - len, "%d.", \
+					var[i]); \
+		} \
+		len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i]); \
+	} while (0)
 
 
 #define FTNET_PROC init_net.proc_net
 
 
-u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
+u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx,
 			 u8 *buffer, u8 highlow);
 
 
@@ -67,8 +73,8 @@ ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
 
 	struct ft1000_info *info;
 
-	char *status[] = { 
-		"Idle (Disconnect)", 
+	char *status[] = {
+		"Idle (Disconnect)",
 		"Searching",
 		"Active (Connected)",
 		"Waiting for L2",
@@ -146,24 +152,24 @@ ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
 
 	len = 0;
 	PUTM_TO_PAGE(len, page, "Connection Time: %02ld:%02ld:%02ld\n",
-      		((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
+		((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
 	PUTM_TO_PAGE(len, page, "Connection Time[s]: %ld\n", delta);
 	PUTM_TO_PAGE(len, page, "Asic ID: %s\n",
-      	(info->AsicID) ==
-      	ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
+	(info->AsicID) ==
+	ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
 	PUTX_TO_PAGE(len, page, "SKU: ", SKUSZ, info->Sku);
 	PUTX_TO_PAGE(len, page, "EUI64: ", EUISZ, info->eui64);
 	PUTD_TO_PAGE(len, page, "DSP version number: ", DSPVERSZ, info->DspVer);
 	PUTX_TO_PAGE(len, page, "Hardware Serial Number: ", HWSERNUMSZ,
-      		info->HwSerNum);
+		info->HwSerNum);
 	PUTX_TO_PAGE(len, page, "Caliberation Version: ", CALVERSZ,
-      		info->RfCalVer);
+		info->RfCalVer);
 	PUTD_TO_PAGE(len, page, "Caliberation Date: ", CALDATESZ,
 		info->RfCalDate);
 	PUTM_TO_PAGE(len, page, "Media State: %s\n",
-      		(info->mediastate) ? "link" : "no link");
+		(info->mediastate) ? "link" : "no link");
 	PUTM_TO_PAGE(len, page, "Connection Status: %s\n",
-      		status[((info->ConStat) & 0x7)]);
+		status[((info->ConStat) & 0x7)]);
 	PUTM_TO_PAGE(len, page, "RX packets: %ld\n", info->stats.rx_packets);
 	PUTM_TO_PAGE(len, page, "TX packets: %ld\n", info->stats.tx_packets);
 	PUTM_TO_PAGE(len, page, "RX bytes: %ld\n", info->stats.rx_bytes);
-- 
1.7.1

