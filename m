Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1A1EFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:08 -0500
Received: from mail.perches.com ([173.55.12.10]:3436 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab1A1EEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:53 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] staging: ath6kl: Convert bypasswmi to bool
Date: Thu, 27 Jan 2011 20:04:23 -0800
Message-Id: <873b7965aad07cf2d0da0d462aa4819a3979e27c.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Types should match logical uses.
Remove unused extern, make static.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    8 ++++----
 drivers/staging/ath6kl/os/linux/ioctl.c      |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 9ed95e3..3ad3d57 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -123,7 +123,7 @@ int bmienable = BMIENABLE_DEFAULT;
 char ifname[IFNAMSIZ] = {0,};
 
 int wlaninitmode = WLAN_INIT_MODE_DEFAULT;
-unsigned int bypasswmi = 0;
+static bool bypasswmi;
 unsigned int debuglevel = 0;
 int tspecCompliance = ATHEROS_COMPLIANCE;
 unsigned int busspeedlow = 0;
@@ -165,7 +165,7 @@ unsigned int eppingtest=0;
 module_param_string(ifname, ifname, sizeof(ifname), 0644);
 module_param(wlaninitmode, int, 0644);
 module_param(bmienable, int, 0644);
-module_param(bypasswmi, uint, 0644);
+module_param(bypasswmi, bool, 0644);
 module_param(debuglevel, uint, 0644);
 module_param(tspecCompliance, int, 0644);
 module_param(onebitmode, uint, 0644);
@@ -1024,7 +1024,7 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, A_UINT32 address, A
             }
             
             if (eppingtest) {
-                bypasswmi = TRUE;    
+                bypasswmi = true;
                 if (ar->arVersion.target_ver == AR6003_REV1_VERSION) {
                     filename = AR6003_REV1_EPPING_FIRMWARE_FILE;
                 } else if (ar->arVersion.target_ver == AR6003_REV2_VERSION) {
@@ -3512,7 +3512,7 @@ ar6000_tx_complete(void *Context, HTC_PACKET_QUEUE *pPacketQueue)
         A_NETBUF_FREE(pktSkb);
     }
 
-    if ((ar->arConnected == TRUE) || (bypasswmi)) {
+    if ((ar->arConnected == TRUE) || bypasswmi) {
         if (!flushing) {
                 /* don't wake the queue if we are flushing, other wise it will just
                  * keep queueing packets, which will keep failing */
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index ea1f202..9a508c4 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -34,7 +34,6 @@ extern unsigned int wmitimeout;
 extern A_WAITQUEUE_HEAD arEvent;
 extern int tspecCompliance;
 extern int bmienable;
-extern int bypasswmi;
 extern int loghci;
 
 static int
-- 
1.7.4.rc3

