Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2HDHSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:18:33 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:53447 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2HDHSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:18:31 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>,
        =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: =?UTF-8?q?=5BPATCH=205/5=5D=20staging/csr=3A=20fix=20coding=20style=20problems=20in=20handle=5Fbh=5Ferror?=
Date: Sat,  4 Aug 2012 13:03:23 +0545
Message-Id: <1344064703-12381-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following fixes:

* fix line over 80
* fix no space at start of line
* use tabs instead of spaces
* no need of opening & closing braces for single statement if block

Cc: Mikko Virkkilä <mikko.virkkila@bluegiga.com>
Cc: Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
Cc: Riku Mettälä <riku.mettala@bluegiga.com>
Cc: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/bh.c |   44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index 3193df2..addee05 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -160,39 +160,41 @@ uf_wait_for_thread_to_stop(unifi_priv_t *priv, struct uf_thread *thread)
  *      None.
  * ---------------------------------------------------------------------------
  */
-    static void
+static void
 handle_bh_error(unifi_priv_t *priv)
 {
-    u8 conf_param = CONFIG_IND_ERROR;
-    u8 interfaceTag;
+	netInterface_priv_t *interfacePriv;
+	u8 conf_param = CONFIG_IND_ERROR;
+	u8 interfaceTag;
 
 
-    /* Block unifi_run_bh() until the error has been handled. */
-    priv->bh_thread.block_thread = 1;
+	/* Block unifi_run_bh() until the error has been handled. */
+	priv->bh_thread.block_thread = 1;
 
-    /* Consider UniFi to be uninitialised */
-    priv->init_progress = UNIFI_INIT_NONE;
+	/* Consider UniFi to be uninitialised */
+	priv->init_progress = UNIFI_INIT_NONE;
 
-    /* Stop the network traffic */
-    for( interfaceTag =0; interfaceTag <CSR_WIFI_NUM_INTERFACES;interfaceTag ++) {
-        netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
-        if (interfacePriv->netdev_registered == 1) {
-            netif_carrier_off(priv->netdev[interfaceTag]);
-        }
-    }
+	/* Stop the network traffic */
+	for (interfaceTag = 0;
+	     interfaceTag < CSR_WIFI_NUM_INTERFACES; interfaceTag++) {
+		interfacePriv = priv->interfacePriv[interfaceTag];
+		if (interfacePriv->netdev_registered)
+			netif_carrier_off(priv->netdev[interfaceTag]);
+	}
 
 #ifdef CSR_NATIVE_LINUX
-    /* Force any client waiting on an mlme_wait_for_reply() to abort. */
-    uf_abort_mlme(priv);
+	/* Force any client waiting on an mlme_wait_for_reply() to abort. */
+	uf_abort_mlme(priv);
 
-    /* Cancel any pending workqueue tasks */
-    flush_workqueue(priv->unifi_workqueue);
+	/* Cancel any pending workqueue tasks */
+	flush_workqueue(priv->unifi_workqueue);
 
 #endif /* CSR_NATIVE_LINUX */
 
-    unifi_error(priv, "handle_bh_error: fatal error is reported to the SME.\n");
-    /* Notify the clients (SME or unifi_manager) for the error. */
-    ul_log_config_ind(priv, &conf_param, sizeof(u8));
+	unifi_error(priv,
+		"handle_bh_error: fatal error is reported to the SME.\n");
+	/* Notify the clients (SME or unifi_manager) for the error. */
+	ul_log_config_ind(priv, &conf_param, sizeof(u8));
 
 } /* handle_bh_error() */
 
-- 
1.7.9.5

