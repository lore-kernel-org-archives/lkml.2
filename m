Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2JORYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:24:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47993 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JORYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:24:46 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 02/14] staging: csr: Fixed exceeding 80 chars per line problems on io.c
Date: Tue, 16 Oct 2012 02:24:21 +0900
Message-Id: <1350321868-2613-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally there were a lot of coding style problems including exceeding
80 lines per line.  So I fixed them, but still there is a 'long string'
printing routines which will be modified on the next patch.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |  176 +++++++++++++++++++++++++++-------------------
 1 file changed, 105 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index 14adc38..b8556c4 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -10,7 +10,8 @@
  *	  recognise a UniFi being added to the system. This is because sdioemb
  *	  does not register itself as a device_driver, it uses it's own code
  *	  to handle insert and remove.
- *	  To have Ubuntu recognise UniFi, edit /etc/udev/rules.d/85-ifupdown.rules
+ *	  To have Ubuntu recognise UniFi, edit 
+ *	  /etc/udev/rules.d/85-ifupdown.rules
  *	  to change this line:
  *		  SUBSYSTEM=="net", DRIVERS=="?*", GOTO="net_start"
  *	  to these:
@@ -54,7 +55,8 @@ static unifi_priv_t *Unifi_instances[MAX_UNIFI_DEVS];
  * are now many per instance. This is used to determine which netdev events
  * are for UniFi as opposed to other net interfaces.
  */
-static netInterface_priv_t *Unifi_netdev_instances[MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES];
+static netInterface_priv_t
+	*Unifi_netdev_instances[MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES];
 
 /*
  * Array to hold the status of each unifi device in each slot.
@@ -63,8 +65,8 @@ static netInterface_priv_t *Unifi_netdev_instances[MAX_UNIFI_DEVS * CSR_WIFI_NUM
  * we are in the middle of a cleanup (the action on unplug).
  */
 #define UNIFI_DEV_NOT_IN_USE	0
-#define UNIFI_DEV_IN_USE		1
-#define UNIFI_DEV_CLEANUP	   2
+#define UNIFI_DEV_IN_USE	1
+#define UNIFI_DEV_CLEANUP	2
 static int In_use[MAX_UNIFI_DEVS];
 /*
  * Mutex to prevent UDI clients to open the character device before the priv
@@ -94,21 +96,22 @@ static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
 	/* Allocating Memory for Signal primitive pointer */
 	for(i=0; i<size; i++)
 	{
-		 priv->rxSignalBuffer.rx_buff[i].sig_len=0;
-		 priv->rxSignalBuffer.rx_buff[i].bufptr = kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
-		 if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL)
-		 {
-			 int j;
-			 unifi_error(priv,"signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
-			 for(j=0;j<i;j++)
-			 {
-				 priv->rxSignalBuffer.rx_buff[j].sig_len=0;
-				 kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
-				 priv->rxSignalBuffer.rx_buff[j].bufptr = NULL;
-			 }
-			 func_exit();
-			 return -1;
-		 }
+		priv->rxSignalBuffer.rx_buff[i].sig_len=0;
+		priv->rxSignalBuffer.rx_buff[i].bufptr =
+		kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
+		if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL)
+		{
+			int j;
+			unifi_error(priv,"signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
+			for(j=0;j<i;j++)
+			{
+				priv->rxSignalBuffer.rx_buff[j].sig_len=0;
+				kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
+				priv->rxSignalBuffer.rx_buff[j].bufptr = NULL;
+			}
+			func_exit();
+			return -1;
+		}
 	}
 	func_exit();
 	return 0;
@@ -175,7 +178,8 @@ uf_register_netdev(unifi_priv_t *priv, int interfaceTag)
 
 #ifdef CSR_SUPPORT_SME
 	/*
-	 * Register the inet handler; it notifies us for changes in the IP address.
+	 * Register the inet handler; 
+	 * it notifies us for changes in the IP address.
 	 */
 	uf_register_inet_notifier();
 #endif /* CSR_SUPPORT_SME */
@@ -215,8 +219,8 @@ uf_unregister_netdev(unifi_priv_t *priv)
 		netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
 		if (interfacePriv->netdev_registered) {
 			unifi_trace(priv, UDBG5,
-					"uf_unregister_netdev: netdev %d - 0x%p\n",
-					i, priv->netdev[i]);
+				"uf_unregister_netdev: netdev %d - 0x%p\n",
+				i, priv->netdev[i]);
 
 			/* ... and the netdev */
 			unregister_netdev(priv->netdev[i]);
@@ -240,19 +244,18 @@ uf_unregister_netdev(unifi_priv_t *priv)
  * ---------------------------------------------------------------------------
  *  register_unifi_sdio
  *
- *	  This function is called from the Probe (or equivalent) method of
- *	  the SDIO driver when a UniFi card is detected.
- *	  We allocate the Linux net_device struct, initialise the HIP core
- *	  lib, create the char device nodes and start the userspace helper
- *	  to initialise the device.
+ *	This function is called from the Probe (or equivalent) method of
+ *	the SDIO driver when a UniFi card is detected.
+ *	We allocate the Linux net_device struct, initialise the HIP core
+ *	lib, create the char device nodes and start the userspace helper
+ *	to initialise the device.
  *
  *  Arguments:
- *	  sdio_dev		Pointer to SDIO context handle to use for all
- *					  SDIO ops.
- *	  bus_id		  A small number indicating the SDIO card position on the
- *					  bus. Typically this is the slot number, e.g. 0, 1 etc.
- *					  Valid values are 0 to MAX_UNIFI_DEVS-1.
- *	  dev			 Pointer to kernel device manager struct.
+ *	sdio_dev	Pointer to SDIO context handle to use for all SDIO ops.
+ *	bus_id		A small number indicating the SDIO card position on the
+ *			bus. Typically this is the slot number, e.g. 0, 1 etc.
+ *			Valid values are 0 to MAX_UNIFI_DEVS-1.
+ *	dev		Pointer to kernel device manager struct.
  *
  *  Returns:
  *	  Pointer to the unifi instance, or NULL on error.
@@ -276,8 +279,9 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	down(&Unifi_instance_mutex);
 
 	if (In_use[bus_id] != UNIFI_DEV_NOT_IN_USE) {
-		unifi_error(priv, "register_unifi_sdio: device %d is already in use\n",
-				bus_id);
+		unifi_error(priv,
+			"register_unifi_sdio: device %d is already in use\n",
+			bus_id);
 		goto failed0;
 	}
 
@@ -299,19 +303,23 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	/* Allocate driver context. */
 	priv->card = unifi_alloc_card(priv->sdio, priv);
 	if (priv->card == NULL) {
-		unifi_error(priv, "Failed to allocate UniFi driver card struct.\n");
+		unifi_error(priv,
+			"Failed to allocate UniFi driver card struct.\n");
 		goto failed1;
 	}
 
 	if (Unifi_instances[bus_id]) {
-		unifi_error(priv, "Internal error: instance for slot %d is already taken\n",
-				bus_id);
+		unifi_error(priv,
+		"Internal error: instance for slot %d is already taken\n",
+		bus_id);
 	}
 	Unifi_instances[bus_id] = priv;
 	In_use[bus_id] = UNIFI_DEV_IN_USE;
 
-	/* Save the netdev_priv for use by the netdev event callback mechanism */
-	Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES] = netdev_priv(priv->netdev[0]);
+	/* Save the netdev_priv for use by 
+	 * the netdev event callback mechanism */
+	Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES] =
+		netdev_priv(priv->netdev[0]);
 
 	/* Initialise the mini-coredump capture buffers */
 	csrResult = unifi_coredump_init(priv->card, (u16)coredump_max);
@@ -330,11 +338,12 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	 */
 	scnprintf(priv->proc_entry_name, 64, "driver/unifi%d", priv->instance);
 	/*
-	 * The following complex casting is in place in order to eliminate 64-bit compilation warning
+	 * The following complex casting is in place in order to eliminate
+	 * 64-bit compilation warning
 	 * "cast to/from pointer from/to integer of different size"
 	 */
 	if (!create_proc_read_entry(priv->proc_entry_name, 0, 0,
-				uf_read_proc, (void *)(long)priv->instance))
+		uf_read_proc, (void *)(long)priv->instance))
 	{
 		unifi_error(priv, "unifi: can't create /proc/driver/unifi\n");
 	}
@@ -348,9 +357,13 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 		{
 			if( !uf_alloc_netdevice_for_other_interfaces(priv,i) )
 			{
-				/* error occured while allocating the net_device for interface[i]. The net_device are
-				 * allocated for the interfaces with id<i. Dont worry, all the allocated net_device will
-				 * be releasing chen the control goes to the label failed0.
+				/* error occured while allocating the
+				 * net_device for interface[i].
+				 * The net_device are allocated for the
+				 * interfaces with id<i. Dont worry,
+				 * all the allocated net_device will
+				 * be releasing chen the control goes to
+				 * the label failed0.
 				 */
 				unifi_error(priv, "Failed to allocate driver private for interface[%d]\n",i);
 				goto failed0;
@@ -362,14 +375,18 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 				/* We are not ready to send data yet. */
 				netif_carrier_off(priv->netdev[i]);
 
-				/* Save the netdev_priv for use by the netdev event callback mechanism */
-				Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES + i] = netdev_priv(priv->netdev[i]);
+				/* Save the netdev_priv for use by
+				 * the netdev event callback mechanism */
+				Unifi_netdev_instances[bus_id *
+					CSR_WIFI_NUM_INTERFACES + i] =
+					netdev_priv(priv->netdev[i]);
 			}
 		}
 
 		for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
 		{
-			netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
+			netInterface_priv_t *interfacePriv =
+				priv->interfacePriv[i];
 			interfacePriv->netdev_registered=0;
 		}
 	}
@@ -377,7 +394,8 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 #ifdef CSR_WIFI_RX_PATH_SPLIT
 	if (signal_buffer_init(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE))
 	{
-		unifi_error(priv,"Failed to allocate shared memory for T-H signals\n");
+		unifi_error(priv,
+			"Failed to allocate shared memory for T-H signals\n");
 		goto failed2;
 	}
 	priv->rx_workqueue = create_singlethread_workqueue("rx_workq");
@@ -483,7 +501,8 @@ ask_unifi_sdio_cleanup(unifi_priv_t *priv)
 	 */
 	In_use[priv->instance] = UNIFI_DEV_CLEANUP;
 
-	unifi_trace(NULL, UDBG5, "ask_unifi_sdio_cleanup: wake up cleanup workqueue.\n");
+	unifi_trace(NULL, UDBG5,
+		"ask_unifi_sdio_cleanup: wake up cleanup workqueue.\n");
 	wake_up(&Unifi_cleanup_wq);
 
 	func_exit();
@@ -509,14 +528,16 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 {
 	int priv_instance;
 	int i;
-	static const CsrWifiMacAddress broadcast_address = {{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
+	static const CsrWifiMacAddress broadcast_address =
+		{{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
 
 	func_enter();
 
 	/* Remove the device nodes */
 	uf_destroy_device_nodes(priv);
 
-	/* Mark this device as gone away by NULLing the entry in Unifi_instances */
+	/* Mark this device as gone away by NULLing the entry in
+	 * Unifi_instances */
 	Unifi_instances[priv->instance] = NULL;
 
 	unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: remove_proc_entry\n");
@@ -529,8 +550,10 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 
 	/* Unregister netdev as a client. */
 	if (priv->netdev_client) {
-		unifi_trace(priv, UDBG2, "Netdev client (id:%d s:0x%X) is unregistered\n",
-				priv->netdev_client->client_id, priv->netdev_client->sender_id);
+		unifi_trace(priv, UDBG2,
+			"Netdev client (id:%d s:0x%X) is unregistered\n",
+			priv->netdev_client->client_id,
+			priv->netdev_client->sender_id);
 		ul_deregister_client(priv->netdev_client);
 	}
 
@@ -551,11 +574,14 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 	/* Free any packets left in the Rx queues */
 	for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
 	{
-		uf_free_pending_rx_packets(priv, UF_UNCONTROLLED_PORT_Q, broadcast_address,i);
-		uf_free_pending_rx_packets(priv, UF_CONTROLLED_PORT_Q, broadcast_address,i);
+		uf_free_pending_rx_packets(priv, UF_UNCONTROLLED_PORT_Q,
+			broadcast_address,i);
+		uf_free_pending_rx_packets(priv, UF_CONTROLLED_PORT_Q,
+			broadcast_address,i);
 	}
 	/*
-	 * We need to free the resources held by the core, which include tx skbs,
+	 * We need to free the resources held by the core,
+	 * which include tx skbs,
 	 * otherwise we can not call unregister_netdev().
 	 */
 	if (priv->card) {
@@ -575,7 +601,8 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 
 	/* Clear the table of registered netdev_priv's */
 	for (i = 0; i < CSR_WIFI_NUM_INTERFACES; i++) {
-		Unifi_netdev_instances[priv->instance * CSR_WIFI_NUM_INTERFACES + i] = NULL;
+		Unifi_netdev_instances[priv->instance *
+			CSR_WIFI_NUM_INTERFACES + i] = NULL;
 	}
 
 	unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: uf_free_netdevice\n");
@@ -630,23 +657,26 @@ unregister_unifi_sdio(int bus_id)
 	u8 reason = CONFIG_IND_EXIT;
 
 	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
-		unifi_error(NULL, "unregister_unifi_sdio: invalid device %d\n",
-				bus_id);
+		unifi_error(NULL,
+			"unregister_unifi_sdio: invalid device %d\n", bus_id);
 		return;
 	}
 
 	priv = Unifi_instances[bus_id];
 	if (priv == NULL) {
-		unifi_error(priv, "unregister_unifi_sdio: device %d is not registered\n",
-				bus_id);
+		unifi_error(priv,
+			"unregister_unifi_sdio: device %d is not registered\n",
+			bus_id);
 		func_exit();
 		return;
 	}
 
 	/* Stop the network traffic before freeing the core. */
-	for(interfaceTag=0;interfaceTag<priv->totalInterfaceCount;interfaceTag++)
+	for(interfaceTag=0;interfaceTag<priv->totalInterfaceCount;
+		interfaceTag++)
 	{
-		netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
+		netInterface_priv_t *interfacePriv =
+			priv->interfacePriv[interfaceTag];
 		if(interfacePriv->netdev_registered)
 		{
 			netif_carrier_off(priv->netdev[interfaceTag]);
@@ -665,7 +695,7 @@ unregister_unifi_sdio(int bus_id)
 	/* Unregister the interrupt handler */
 	if (csr_sdio_linux_remove_irq(priv->sdio)) {
 		unifi_notice(priv,
-				"csr_sdio_linux_remove_irq failed to talk to card.\n");
+			"csr_sdio_linux_remove_irq failed to talk to card.\n");
 	}
 
 	/* Ensure no MLME functions are waiting on a the mlme_event semaphore. */
@@ -873,7 +903,8 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 	int i;
 
 	/*
-	* The following complex casting is in place in order to eliminate 64-bit compilation warning
+	* The following complex casting is in place in order to eliminate
+	* 64-bit compilation warning
 	* "cast to/from pointer from/to integer of different size"
 	*/
 	priv = uf_find_instance((int)(long)data);
@@ -1018,10 +1049,12 @@ uf_sdio_inserted(CsrSdioFunction *sdio_ctx)
 {
 	unifi_priv_t *priv;
 
-	unifi_trace(NULL, UDBG5, "uf_sdio_inserted(0x%p), slot_id=%d, dev=%p\n",
-			sdio_ctx, active_slot, os_devices[active_slot]);
+	unifi_trace(NULL, UDBG5,
+		"uf_sdio_inserted(0x%p), slot_id=%d, dev=%p\n",
+		sdio_ctx, active_slot, os_devices[active_slot]);
 
-	priv = register_unifi_sdio(sdio_ctx, active_slot, os_devices[active_slot]);
+	priv = register_unifi_sdio(sdio_ctx,
+		active_slot, os_devices[active_slot]);
 	if (priv == NULL) {
 		CsrSdioInsertedAcknowledge(sdio_ctx, CSR_RESULT_FAILURE);
 		return;
@@ -1130,7 +1163,9 @@ uf_sdio_load(void)
 
 	csrResult = CsrSdioFunctionDriverRegister(&unifi_sdioFunction_drv);
 	if (csrResult != CSR_RESULT_SUCCESS) {
-		unifi_error(NULL, "Failed to register UniFi SDIO driver: csrResult=%d\n", csrResult);
+		unifi_error(NULL,
+			"Failed to register UniFi SDIO driver: csrResult=%d\n",
+			csrResult);
 		return -EIO;
 	}
 
@@ -1144,4 +1179,3 @@ uf_sdio_unload(void)
 {
 	CsrSdioFunctionDriverUnregister(&unifi_sdioFunction_drv);
 } /* uf_sdio_unload() */
-
-- 
1.7.9.5

