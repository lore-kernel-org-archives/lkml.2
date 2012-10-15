Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2JOR1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:27:06 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44300 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2JOR07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:26:59 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 14/14] staging: csr: Removed braces {} on single line for, if statements
Date: Tue, 16 Oct 2012 02:25:36 +0900
Message-Id: <1350321936-2664-5-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321936-2664-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321936-2664-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed braces {} from single line for and if, and else statements.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |   54 ++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index 74c891a..d32a525 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -319,15 +319,13 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 
 	/* Initialise the mini-coredump capture buffers */
 	csrResult = unifi_coredump_init(priv->card, (u16)coredump_max);
-	if (csrResult != CSR_RESULT_SUCCESS) {
+	if (csrResult != CSR_RESULT_SUCCESS)
 		unifi_error(priv, "Couldn't allocate mini-coredump buffers\n");
-	}
 
 	/* Create the character device nodes */
 	r = uf_create_device_nodes(priv, bus_id);
-	if (r) {
+	if (r)
 		goto failed1;
-	}
 
 	/*
 	 * We use the slot number as unifi device index.
@@ -339,9 +337,8 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	 * "cast to/from pointer from/to integer of different size"
 	 */
 	if (!create_proc_read_entry(priv->proc_entry_name, 0, 0,
-		uf_read_proc, (void *)(long)priv->instance)) {
+		uf_read_proc, (void *)(long)priv->instance))
 		unifi_error(priv, "unifi: can't create /proc/driver/unifi\n");
-	}
 
 	/* Allocate the net_device for interfaces other than 0. */
 	{
@@ -396,9 +393,8 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 #endif
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-	if (log_hip_signals) {
+	if (log_hip_signals)
 		uf_register_hip_offline_debug(priv);
-	}
 #endif
 
 	/* Initialise the SME related threads and parameters */
@@ -414,10 +410,9 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	 */
 	unifi_trace(priv, UDBG1, "run UniFi helper app...\n");
 	r = uf_run_unifihelper(priv);
-	if (r) {
+	if (r)
 		unifi_notice(priv, "unable to run UniFi helper app\n");
 		/* Not a fatal error. */
-	}
 
 	up(&Unifi_instance_mutex);
 
@@ -426,9 +421,8 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 
 failed4:
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-if (log_hip_signals) {
+if (log_hip_signals)
 	uf_unregister_hip_offline_debug(priv);
-}
 #endif
 #ifdef CSR_WIFI_RX_PATH_SPLIT
 	flush_workqueue(priv->rx_workqueue);
@@ -448,9 +442,8 @@ failed0:
 		unifi_coredump_free(priv->card);
 		unifi_free_card(priv->card);
 	}
-	if (priv) {
+	if (priv)
 		uf_free_netdevice(priv);
-	}
 
 	up(&Unifi_instance_mutex);
 
@@ -552,9 +545,8 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 #endif
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-	if (log_hip_signals) {
+	if (log_hip_signals)
 		uf_unregister_hip_offline_debug(priv);
-	}
 #endif
 
 	/* Free any packets left in the Rx queues */
@@ -721,9 +713,8 @@ unregister_unifi_sdio(int bus_id)
 unifi_priv_t *
 uf_find_instance(int inst)
 {
-	if ((inst < 0) || (inst >= MAX_UNIFI_DEVS)) {
+	if ((inst < 0) || (inst >= MAX_UNIFI_DEVS))
 		return NULL;
-	}
 	return Unifi_instances[inst];
 } /* uf_find_instance() */
 
@@ -746,15 +737,12 @@ uf_find_priv(unifi_priv_t *priv)
 {
 	int inst;
 
-	if (!priv) {
+	if (!priv)
 		return -1;
-	}
 
-	for (inst = 0; inst < MAX_UNIFI_DEVS; inst++) {
-		if (Unifi_instances[inst] == priv) {
+	for (inst = 0; inst < MAX_UNIFI_DEVS; inst++)
+		if (Unifi_instances[inst] == priv)
 			return inst;
-		}
-	}
 
 	return -1;
 } /* uf_find_priv() */
@@ -777,16 +765,13 @@ uf_find_netdev_priv(netInterface_priv_t *priv)
 {
 	int inst;
 
-	if (!priv) {
+	if (!priv)
 		return -1;
-	}
 
 	for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES;
-		inst++) {
-		if (Unifi_netdev_instances[inst] == priv) {
+		inst++)
+		if (Unifi_netdev_instances[inst] == priv)
 			return inst;
-		}
-	}
 
 	return -1;
 } /* uf_find_netdev_priv() */
@@ -813,9 +798,8 @@ uf_get_instance(int inst)
 	down(&Unifi_instance_mutex);
 
 	priv = uf_find_instance(inst);
-	if (priv) {
+	if (priv)
 		priv->ref_count++;
-	}
 
 	up(&Unifi_instance_mutex);
 
@@ -846,9 +830,8 @@ uf_put_instance(int inst)
 	priv = uf_find_instance(inst);
 	if (priv) {
 		priv->ref_count--;
-		if (priv->ref_count == 0) {
+		if (priv->ref_count == 0)
 			ask_unifi_sdio_cleanup(priv);
-		}
 	}
 
 	up(&Unifi_instance_mutex);
@@ -892,9 +875,8 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 	* "cast to/from pointer from/to integer of different size"
 	*/
 	priv = uf_find_instance((int)(long)data);
-	if (!priv) {
+	if (!priv)
 		return 0;
-	}
 
 	p = kmalloc(UNIFI_DEBUG_TXT_BUFFER, GFP_KERNEL);
 
-- 
1.7.9.5

