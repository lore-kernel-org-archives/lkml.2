Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0INEZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2007 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0INEYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH next 11/16] drivers/staging: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:57 -0700
Message-Id: <ac5ec5db5bf146c80b40494a6719d0eabaa7ae45.1284435710.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |   14 +++++++-------
 drivers/staging/bcm/Debug.c                  |    5 +++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index ff7976e..16c9999 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -5079,13 +5079,13 @@ ar6000_hbChallengeResp_event(AR_SOFTC_T *ar, A_UINT32 cookie, A_UINT32 source)
 void
 ar6000_reportError_event(AR_SOFTC_T *ar, WMI_TARGET_ERROR_VAL errorVal)
 {
-    char    *errString[] = {
-                [WMI_TARGET_PM_ERR_FAIL]    "WMI_TARGET_PM_ERR_FAIL",
-                [WMI_TARGET_KEY_NOT_FOUND]  "WMI_TARGET_KEY_NOT_FOUND",
-                [WMI_TARGET_DECRYPTION_ERR] "WMI_TARGET_DECRYPTION_ERR",
-                [WMI_TARGET_BMISS]          "WMI_TARGET_BMISS",
-                [WMI_PSDISABLE_NODE_JOIN]   "WMI_PSDISABLE_NODE_JOIN"
-                };
+	static const char * const errString[] = {
+		[WMI_TARGET_PM_ERR_FAIL]    "WMI_TARGET_PM_ERR_FAIL",
+		[WMI_TARGET_KEY_NOT_FOUND]  "WMI_TARGET_KEY_NOT_FOUND",
+		[WMI_TARGET_DECRYPTION_ERR] "WMI_TARGET_DECRYPTION_ERR",
+		[WMI_TARGET_BMISS]          "WMI_TARGET_BMISS",
+		[WMI_PSDISABLE_NODE_JOIN]   "WMI_PSDISABLE_NODE_JOIN"
+	};
 
     A_PRINTF("AR6000 Error on Target. Error = 0x%x\n", errorVal);
 
diff --git a/drivers/staging/bcm/Debug.c b/drivers/staging/bcm/Debug.c
index 213f4bc..d01eb12 100644
--- a/drivers/staging/bcm/Debug.c
+++ b/drivers/staging/bcm/Debug.c
@@ -1,12 +1,13 @@
 #include "headers.h"
 
-char *buff_dump_base[]={"DEC", "HEX",  "OCT", "BIN"	};
-
 static UINT current_debug_level=BCM_SCREAM;
 
 int bcm_print_buffer( UINT debug_level, const char *function_name,
 				  char *file_name, int line_number, unsigned char *buffer, int bufferlen, unsigned int base)
 {
+	static const char * const buff_dump_base[] = {
+		"DEC", "HEX", "OCT", "BIN"
+	};
 	if(debug_level>=current_debug_level)
 	{
 		int i=0;
-- 
1.7.3.rc1

