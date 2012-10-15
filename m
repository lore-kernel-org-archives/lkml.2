Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2JORYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:24:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JORYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:24:51 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 04/14] staging: csr: Fixed the positions of the opening braces { on io.c
Date: Tue, 16 Oct 2012 02:24:23 +0900
Message-Id: <1350321868-2613-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just fixed the positions of the opening braces { to the previous
lines.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |   76 ++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index b589408..6f89556 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -94,17 +94,14 @@ static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
 	priv->rxSignalBuffer.readPointer = 0;
 	priv->rxSignalBuffer.size = size;
 	/* Allocating Memory for Signal primitive pointer */
-	for(i=0; i<size; i++)
-	{
+	for(i=0; i<size; i++) {
 		priv->rxSignalBuffer.rx_buff[i].sig_len=0;
 		priv->rxSignalBuffer.rx_buff[i].bufptr =
 		kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
-		if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL)
-		{
+		if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL) {
 			int j;
 			unifi_error(priv,"signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
-			for(j=0;j<i;j++)
-			{
+			for(j=0;j<i;j++) {
 				priv->rxSignalBuffer.rx_buff[j].sig_len=0;
 				kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
 				priv->rxSignalBuffer.rx_buff[j].bufptr = NULL;
@@ -122,8 +119,7 @@ static void signal_buffer_free(unifi_priv_t * priv, int size)
 {
 	int i;
 
-	for(i=0; i<size; i++)
-	{
+	for(i=0; i<size; i++) {
 		 priv->rxSignalBuffer.rx_buff[i].sig_len=0;
 		 kfree(priv->rxSignalBuffer.rx_buff[i].bufptr);
 		 priv->rxSignalBuffer.rx_buff[i].bufptr = NULL;
@@ -343,8 +339,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	 * "cast to/from pointer from/to integer of different size"
 	 */
 	if (!create_proc_read_entry(priv->proc_entry_name, 0, 0,
-		uf_read_proc, (void *)(long)priv->instance))
-	{
+		uf_read_proc, (void *)(long)priv->instance)) {
 		unifi_error(priv, "unifi: can't create /proc/driver/unifi\n");
 	}
 
@@ -353,10 +348,8 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 		int i;
 		priv->totalInterfaceCount =0;
 
-		for(i=1;i<CSR_WIFI_NUM_INTERFACES;i++)
-		{
-			if( !uf_alloc_netdevice_for_other_interfaces(priv,i) )
-			{
+		for(i=1;i<CSR_WIFI_NUM_INTERFACES;i++) {
+			if( !uf_alloc_netdevice_for_other_interfaces(priv,i) ) {
 				/* error occured while allocating the
 				 * net_device for interface[i].
 				 * The net_device are allocated for the
@@ -367,9 +360,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 				 */
 				unifi_error(priv, "Failed to allocate driver private for interface[%d]\n",i);
 				goto failed0;
-			}
-			else
-			{
+			} else {
 				SET_NETDEV_DEV(priv->netdev[i], dev);
 
 				/* We are not ready to send data yet. */
@@ -383,8 +374,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 			}
 		}
 
-		for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
-		{
+		for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++) {
 			netInterface_priv_t *interfacePriv =
 				priv->interfacePriv[i];
 			interfacePriv->netdev_registered=0;
@@ -392,8 +382,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	}
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
-	if (signal_buffer_init(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE))
-	{
+	if (signal_buffer_init(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE)) {
 		unifi_error(priv,
 			"Failed to allocate shared memory for T-H signals\n");
 		goto failed2;
@@ -407,8 +396,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 #endif
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-	if (log_hip_signals)
-	{
+	if (log_hip_signals) {
 		uf_register_hip_offline_debug(priv);
 	}
 #endif
@@ -438,8 +426,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 
 failed4:
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-if (log_hip_signals)
-{
+if (log_hip_signals) {
 	uf_unregister_hip_offline_debug(priv);
 }
 #endif
@@ -528,8 +515,8 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 {
 	int priv_instance;
 	int i;
-	static const CsrWifiMacAddress broadcast_address =
-		{{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
+	static const CsrWifiMacAddress broadcast_address = {{0xFF,
+		0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
 
 	func_enter();
 
@@ -565,15 +552,13 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 #endif
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-	if (log_hip_signals)
-	{
+	if (log_hip_signals) {
 		uf_unregister_hip_offline_debug(priv);
 	}
 #endif
 
 	/* Free any packets left in the Rx queues */
-	for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
-	{
+	for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++) {
 		uf_free_pending_rx_packets(priv, UF_UNCONTROLLED_PORT_Q,
 			broadcast_address,i);
 		uf_free_pending_rx_packets(priv, UF_CONTROLLED_PORT_Q,
@@ -673,12 +658,10 @@ unregister_unifi_sdio(int bus_id)
 
 	/* Stop the network traffic before freeing the core. */
 	for(interfaceTag=0;interfaceTag<priv->totalInterfaceCount;
-		interfaceTag++)
-	{
+		interfaceTag++) {
 		netInterface_priv_t *interfacePriv =
 			priv->interfacePriv[interfaceTag];
-		if(interfacePriv->netdev_registered)
-		{
+		if(interfacePriv->netdev_registered) {
 			netif_carrier_off(priv->netdev[interfaceTag]);
 			netif_tx_stop_all_queues(priv->netdev[interfaceTag]);
 		}
@@ -798,7 +781,8 @@ uf_find_netdev_priv(netInterface_priv_t *priv)
 		return -1;
 	}
 
-	for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES; inst++) {
+	for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES; 
+		inst++) {
 		if (Unifi_netdev_instances[inst] == priv) {
 			return inst;
 		}
@@ -969,20 +953,16 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 
 	written = UNIFI_DEBUG_TXT_BUFFER - remain;
 
-	if( offset >= written )
-	{
+	if( offset >= written ) {
 		*eof = 1;
 		kfree( orig_p );
 		return(0);
 	}
 
-	if( offset + count > written )
-	{
+	if( offset + count > written ) {
 		actual_amount_to_copy = written - offset;
 		*eof = 1;
-	}
-	else
-	{
+	} else {
 		actual_amount_to_copy = count;
 	}
 
@@ -1023,7 +1003,7 @@ uf_add_os_device(int bus_id, struct device *os_device)
 {
 	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
 		unifi_error(NULL, "uf_add_os_device: invalid device %d\n",
-				bus_id);
+			bus_id);
 		return;
 	}
 
@@ -1036,7 +1016,7 @@ uf_remove_os_device(int bus_id)
 {
 	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
 		unifi_error(NULL, "uf_remove_os_device: invalid device %d\n",
-				bus_id);
+			bus_id);
 		return;
 	}
 
@@ -1107,8 +1087,7 @@ uf_sdio_int_handler(CsrSdioFunction *sdio_ctx)
 
 
 
-static CsrSdioFunctionId unifi_ids[] =
-{
+static CsrSdioFunctionId unifi_ids[] = {
 	{
 		.manfId = SDIO_MANF_ID_CSR,
 		.cardId = SDIO_CARD_ID_UNIFI_3,
@@ -1127,8 +1106,7 @@ static CsrSdioFunctionId unifi_ids[] =
 /*
  * Structure to register with the glue layer.
  */
-static CsrSdioFunctionDriver unifi_sdioFunction_drv =
-{
+static CsrSdioFunctionDriver unifi_sdioFunction_drv = {
 	.inserted = uf_sdio_inserted,
 	.removed = uf_sdio_removed,
 	.intr = uf_sdio_int_handler,
-- 
1.7.9.5

