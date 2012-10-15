Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2JORZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:25:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab2JORY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:24:57 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 06/14] staging: csr: Added whitespaces around comma, =, >, <, ; (mostly for loops)
Date: Tue, 16 Oct 2012 02:24:25 +0900
Message-Id: <1350321868-2613-6-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were tons of whitespace warnings (not using whitespaces before and
after "=, >, <", after comma, and ";" on for loops, so that I fixed them
altogether.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |   52 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index ed34914..204d307 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -94,15 +94,15 @@ static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
 	priv->rxSignalBuffer.readPointer = 0;
 	priv->rxSignalBuffer.size = size;
 	/* Allocating Memory for Signal primitive pointer */
-	for(i=0; i<size; i++) {
-		priv->rxSignalBuffer.rx_buff[i].sig_len=0;
+	for (i = 0; i < size; i++) {
+		priv->rxSignalBuffer.rx_buff[i].sig_len = 0;
 		priv->rxSignalBuffer.rx_buff[i].bufptr =
 		kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
 		if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL) {
 			int j;
-			unifi_error(priv,"signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
-			for(j=0;j<i;j++) {
-				priv->rxSignalBuffer.rx_buff[j].sig_len=0;
+			unifi_error(priv, "signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
+			for (j = 0; j < i; j++) {
+				priv->rxSignalBuffer.rx_buff[j].sig_len = 0;
 				kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
 				priv->rxSignalBuffer.rx_buff[j].bufptr = NULL;
 			}
@@ -119,8 +119,8 @@ static void signal_buffer_free(unifi_priv_t * priv, int size)
 {
 	int i;
 
-	for(i=0; i<size; i++) {
-		 priv->rxSignalBuffer.rx_buff[i].sig_len=0;
+	for (i = 0; i < size; i++) {
+		 priv->rxSignalBuffer.rx_buff[i].sig_len = 0;
 		 kfree(priv->rxSignalBuffer.rx_buff[i].bufptr);
 		 priv->rxSignalBuffer.rx_buff[i].bufptr = NULL;
 	}
@@ -204,14 +204,14 @@ uf_register_netdev(unifi_priv_t *priv, int interfaceTag)
 void
 uf_unregister_netdev(unifi_priv_t *priv)
 {
-	int i=0;
+	int i = 0;
 
 #ifdef CSR_SUPPORT_SME
 	/* Unregister the inet handler... */
 	uf_unregister_inet_notifier();
 #endif /* CSR_SUPPORT_SME */
 
-	for (i=0; i<CSR_WIFI_NUM_INTERFACES; i++) {
+	for (i = 0; i < CSR_WIFI_NUM_INTERFACES; i++) {
 		netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
 		if (interfacePriv->netdev_registered) {
 			unifi_trace(priv, UDBG5,
@@ -346,10 +346,10 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	/* Allocate the net_device for interfaces other than 0. */
 	{
 		int i;
-		priv->totalInterfaceCount =0;
+		priv->totalInterfaceCount = 0;
 
-		for(i=1;i<CSR_WIFI_NUM_INTERFACES;i++) {
-			if(!uf_alloc_netdevice_for_other_interfaces(priv,i)) {
+		for (i = 1; i < CSR_WIFI_NUM_INTERFACES; i++) {
+			if (!uf_alloc_netdevice_for_other_interfaces(priv, i)) {
 				/* error occured while allocating the
 				 * net_device for interface[i].
 				 * The net_device are allocated for the
@@ -358,7 +358,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 				 * be releasing chen the control goes to
 				 * the label failed0.
 				 */
-				unifi_error(priv, "Failed to allocate driver private for interface[%d]\n",i);
+				unifi_error(priv, "Failed to allocate driver private for interface[%d]\n", i);
 				goto failed0;
 			} else {
 				SET_NETDEV_DEV(priv->netdev[i], dev);
@@ -374,10 +374,10 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 			}
 		}
 
-		for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++) {
+		for (i = 0; i < CSR_WIFI_NUM_INTERFACES; i++) {
 			netInterface_priv_t *interfacePriv =
 				priv->interfacePriv[i];
-			interfacePriv->netdev_registered=0;
+			interfacePriv->netdev_registered = 0;
 		}
 	}
 
@@ -389,7 +389,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	}
 	priv->rx_workqueue = create_singlethread_workqueue("rx_workq");
 	if (priv->rx_workqueue == NULL) {
-		unifi_error(priv,"create_singlethread_workqueue failed \n");
+		unifi_error(priv, "create_singlethread_workqueue failed \n");
 		goto failed3;
 	}
 	INIT_WORK(&priv->rx_work_struct, rx_wq_handler);
@@ -434,7 +434,7 @@ if (log_hip_signals) {
 	flush_workqueue(priv->rx_workqueue);
 	destroy_workqueue(priv->rx_workqueue);
 failed3:
-	signal_buffer_free(priv,CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
+	signal_buffer_free(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
 failed2:
 #endif
 	/* Remove the device nodes */
@@ -558,11 +558,11 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 #endif
 
 	/* Free any packets left in the Rx queues */
-	for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++) {
+	for (i = 0; i < CSR_WIFI_NUM_INTERFACES; i++) {
 		uf_free_pending_rx_packets(priv, UF_UNCONTROLLED_PORT_Q,
-			broadcast_address,i);
+			broadcast_address, i);
 		uf_free_pending_rx_packets(priv, UF_CONTROLLED_PORT_Q,
-			broadcast_address,i);
+			broadcast_address, i);
 	}
 	/*
 	 * We need to free the resources held by the core,
@@ -600,7 +600,7 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 #ifdef CSR_WIFI_RX_PATH_SPLIT
 	flush_workqueue(priv->rx_workqueue);
 	destroy_workqueue(priv->rx_workqueue);
-	signal_buffer_free(priv,CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
+	signal_buffer_free(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
 #endif
 
 	/* Priv is freed as part of the net_device */
@@ -638,7 +638,7 @@ static void
 unregister_unifi_sdio(int bus_id)
 {
 	unifi_priv_t *priv;
-	int interfaceTag=0;
+	int interfaceTag = 0;
 	u8 reason = CONFIG_IND_EXIT;
 
 	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
@@ -657,11 +657,11 @@ unregister_unifi_sdio(int bus_id)
 	}
 
 	/* Stop the network traffic before freeing the core. */
-	for(interfaceTag=0;interfaceTag<priv->totalInterfaceCount;
+	for (interfaceTag = 0 ; interfaceTag < priv->totalInterfaceCount;
 		interfaceTag++) {
 		netInterface_priv_t *interfacePriv =
 			priv->interfacePriv[interfaceTag];
-		if(interfacePriv->netdev_registered) {
+		if (interfacePriv->netdev_registered) {
 			netif_carrier_off(priv->netdev[interfaceTag]);
 			netif_tx_stop_all_queues(priv->netdev[interfaceTag]);
 		}
@@ -953,13 +953,13 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 
 	written = UNIFI_DEBUG_TXT_BUFFER - remain;
 
-	if(offset >= written) {
+	if (offset >= written) {
 		*eof = 1;
 		kfree(orig_p);
 		return(0);
 	}
 
-	if(offset + count > written) {
+	if (offset + count > written) {
 		actual_amount_to_copy = written - offset;
 		*eof = 1;
 	} else {
-- 
1.7.9.5

