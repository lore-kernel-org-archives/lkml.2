Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab2GJCse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:48:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38632 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2GJCrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:47:41 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lauri.hintsala@bluegiga.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 5/5] staging: csr: Remove unused macros
Date: Mon,  9 Jul 2012 23:43:13 -0300
Message-Id: <1341888193-12182-6-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros are not used, so remove it.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/csr/csr_wifi_hip_card_sdio.c |    3 ---
 drivers/staging/csr/drv.c                    |    1 -
 drivers/staging/csr/firmware.c               |    1 -
 drivers/staging/csr/mlme.c                   |    5 -----
 drivers/staging/csr/monitor.c                |    2 --
 drivers/staging/csr/sme_sys.c                |    1 -
 6 files changed, 13 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_hip_card_sdio.c b/drivers/staging/csr/csr_wifi_hip_card_sdio.c
index 91976b8..5a86ff9 100644
--- a/drivers/staging/csr/csr_wifi_hip_card_sdio.c
+++ b/drivers/staging/csr/csr_wifi_hip_card_sdio.c
@@ -36,9 +36,6 @@
 #define MAILBOX2_TIMEOUT                5   /* in millisecs */
 #define MAILBOX2_ATTEMPTS               10  /* 50ms */
 
-#define MAILBOX2_RESET_ATTEMPTS         10
-#define MAILBOX2_RESET_TIMEOUT          5   /* in millisecs */
-
 #define RESET_SETTLE_DELAY              25  /* in millisecs */
 
 static CsrResult card_init_slots(card_t *card);
diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
index fbe8630..4be6d95 100644
--- a/drivers/staging/csr/drv.c
+++ b/drivers/staging/csr/drv.c
@@ -63,7 +63,6 @@ int coredump_max = CSR_WIFI_HIP_NUM_COREDUMP_BUFFERS;
 int run_bh_once = -1;          /* Set for scheduled interrupt mode, -1 = default */
 int bh_priority = -1;
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-#define UNIFI_LOG_HIP_SIGNALS_FILTER_SIGNAL     (1 << 0)
 #define UNIFI_LOG_HIP_SIGNALS_FILTER_BULKDATA   (1 << 1)
 #define UNIFI_LOG_HIP_SIGNALS_FILTER_TIMESTAMP  (1 << 2)
 int log_hip_signals = 0;
diff --git a/drivers/staging/csr/firmware.c b/drivers/staging/csr/firmware.c
index 03da0d5..98e27d6 100644
--- a/drivers/staging/csr/firmware.c
+++ b/drivers/staging/csr/firmware.c
@@ -220,7 +220,6 @@ unifi_fw_read(void *ospriv, void *arg, CsrUint32 offset, void *buf, CsrUint32 le
 
 
 
-#define UNIFIHELPER_INIT_MODE_SMEEMB    0
 #define UNIFIHELPER_INIT_MODE_SMEUSER   2
 #define UNIFIHELPER_INIT_MODE_NATIVE    1
 
diff --git a/drivers/staging/csr/mlme.c b/drivers/staging/csr/mlme.c
index 790d5d7..ed767ec 100644
--- a/drivers/staging/csr/mlme.c
+++ b/drivers/staging/csr/mlme.c
@@ -15,11 +15,6 @@
 #include "csr_wifi_hip_unifi.h"
 #include "unifi_priv.h"
 
-
-/* The additional time taken by the UniFi to do a scan per channel */
-#define SCAN_STARTUP_TIME       300 /* in millisecs */
-
-
 /*
  * ---------------------------------------------------------------------------
  * unifi_mlme_wait_for_reply
diff --git a/drivers/staging/csr/monitor.c b/drivers/staging/csr/monitor.c
index 8c35b7e..628782a 100644
--- a/drivers/staging/csr/monitor.c
+++ b/drivers/staging/csr/monitor.c
@@ -242,9 +242,7 @@ netrx_prism(unifi_priv_t *priv,
     unsigned char *ptr;
     unsigned char *base;
     int ind_data_len = skb_orig->len - 2 - ETH_HLEN;
-#define WLANCAP_MAGIC_COOKIE_BASE 0x80211000
 #define WLANCAP_MAGIC_COOKIE_V1 0x80211001
-#define WLANCAP_MAGIC_COOKIE_V2 0x80211002
     struct avs_header_v1 {
         uint32  version;
         uint32  length;
diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index 9c3aa74..5f38f9d 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -1572,7 +1572,6 @@ void CsrWifiRouterMaPacketReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
     r = _sys_packet_req(priv, &signal, mareq->subscriptionHandle,
             mareq->frameLength, mareq->frame, snap_protocol);
 
-#define MAX_RETRY 2
     if (r && mareq->cfmRequested)
     {
         CsrWifiRouterMaPacketCfmSend(msg->source,interfaceTag,
-- 
1.7.10.4

