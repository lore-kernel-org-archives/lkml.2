Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2JORYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:24:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JORYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:24:42 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 01/14] staging: csr: fixed indentation from spaces to tabs on io.c
Date: Tue, 16 Oct 2012 02:24:20 +0900
Message-Id: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, '4 spaces' were used as an indentation method, so I
converted all 4 spaces chunks to tabs.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c | 1366 +++++++++++++++++++++++-----------------------
 1 file changed, 683 insertions(+), 683 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index caf48e3..14adc38 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -1,27 +1,27 @@
 /*
  * ---------------------------------------------------------------------------
- *  FILE:     io.c
+ *  FILE:	 io.c
  *
  *  PURPOSE:
- *      This file contains routines that the SDIO driver can call when a
- *      UniFi card is first inserted (or detected) and removed.
+ *	  This file contains routines that the SDIO driver can call when a
+ *	  UniFi card is first inserted (or detected) and removed.
  *
- *      When used with sdioemb, the udev scripts (at least on Ubuntu) don't
- *      recognise a UniFi being added to the system. This is because sdioemb
- *      does not register itself as a device_driver, it uses it's own code
- *      to handle insert and remove.
- *      To have Ubuntu recognise UniFi, edit /etc/udev/rules.d/85-ifupdown.rules
- *      to change this line:
- *          SUBSYSTEM=="net", DRIVERS=="?*", GOTO="net_start"
- *      to these:
- *          #SUBSYSTEM=="net", DRIVERS=="?*", GOTO="net_start"
- *          SUBSYSTEM=="net", GOTO="net_start"
+ *	  When used with sdioemb, the udev scripts (at least on Ubuntu) don't
+ *	  recognise a UniFi being added to the system. This is because sdioemb
+ *	  does not register itself as a device_driver, it uses it's own code
+ *	  to handle insert and remove.
+ *	  To have Ubuntu recognise UniFi, edit /etc/udev/rules.d/85-ifupdown.rules
+ *	  to change this line:
+ *		  SUBSYSTEM=="net", DRIVERS=="?*", GOTO="net_start"
+ *	  to these:
+ *		  #SUBSYSTEM=="net", DRIVERS=="?*", GOTO="net_start"
+ *		  SUBSYSTEM=="net", GOTO="net_start"
  *
- *      Then you can add a stanza to /etc/network/interfaces like this:
- *          auto eth1
- *          iface eth1 inet dhcp
- *          wpa-conf /etc/wpa_supplicant.conf
- *      This will then automatically associate when a car dis inserted.
+ *	  Then you can add a stanza to /etc/network/interfaces like this:
+ *		  auto eth1
+ *		  iface eth1 inet dhcp
+ *		  wpa-conf /etc/wpa_supplicant.conf
+ *	  This will then automatically associate when a car dis inserted.
  *
  * Copyright (C) 2006-2009 by Cambridge Silicon Radio Ltd.
  *
@@ -62,9 +62,9 @@ static netInterface_priv_t *Unifi_netdev_instances[MAX_UNIFI_DEVS * CSR_WIFI_NUM
  * UNIFI_DEV_NOT_IN_USE. Otherwise, it means that the slot is in use or
  * we are in the middle of a cleanup (the action on unplug).
  */
-#define UNIFI_DEV_NOT_IN_USE    0
-#define UNIFI_DEV_IN_USE        1
-#define UNIFI_DEV_CLEANUP       2
+#define UNIFI_DEV_NOT_IN_USE	0
+#define UNIFI_DEV_IN_USE		1
+#define UNIFI_DEV_CLEANUP	   2
 static int In_use[MAX_UNIFI_DEVS];
 /*
  * Mutex to prevent UDI clients to open the character device before the priv
@@ -79,111 +79,111 @@ DECLARE_WAIT_QUEUE_HEAD(Unifi_cleanup_wq);
 
 
 static int uf_read_proc(char *page, char **start, off_t offset, int count,
-                        int *eof, void *data);
+						int *eof, void *data);
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
 
 static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
 {
-    int i;
-    func_enter();
-
-    priv->rxSignalBuffer.writePointer =
-    priv->rxSignalBuffer.readPointer = 0;
-    priv->rxSignalBuffer.size = size;
-    /* Allocating Memory for Signal primitive pointer */
-    for(i=0; i<size; i++)
-    {
-         priv->rxSignalBuffer.rx_buff[i].sig_len=0;
-         priv->rxSignalBuffer.rx_buff[i].bufptr = kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
-         if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL)
-         {
-             int j;
-             unifi_error(priv,"signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
-             for(j=0;j<i;j++)
-             {
-                 priv->rxSignalBuffer.rx_buff[j].sig_len=0;
-                 kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
-                 priv->rxSignalBuffer.rx_buff[j].bufptr = NULL;
-             }
-             func_exit();
-             return -1;
-         }
-    }
-    func_exit();
-    return 0;
+	int i;
+	func_enter();
+
+	priv->rxSignalBuffer.writePointer =
+	priv->rxSignalBuffer.readPointer = 0;
+	priv->rxSignalBuffer.size = size;
+	/* Allocating Memory for Signal primitive pointer */
+	for(i=0; i<size; i++)
+	{
+		 priv->rxSignalBuffer.rx_buff[i].sig_len=0;
+		 priv->rxSignalBuffer.rx_buff[i].bufptr = kmalloc(UNIFI_PACKED_SIGBUF_SIZE, GFP_KERNEL);
+		 if (priv->rxSignalBuffer.rx_buff[i].bufptr == NULL)
+		 {
+			 int j;
+			 unifi_error(priv,"signal_buffer_init:Failed to Allocate shared memory for T-H signals \n");
+			 for(j=0;j<i;j++)
+			 {
+				 priv->rxSignalBuffer.rx_buff[j].sig_len=0;
+				 kfree(priv->rxSignalBuffer.rx_buff[j].bufptr);
+				 priv->rxSignalBuffer.rx_buff[j].bufptr = NULL;
+			 }
+			 func_exit();
+			 return -1;
+		 }
+	}
+	func_exit();
+	return 0;
 }
 
 
 static void signal_buffer_free(unifi_priv_t * priv, int size)
 {
-    int i;
-
-    for(i=0; i<size; i++)
-    {
-         priv->rxSignalBuffer.rx_buff[i].sig_len=0;
-         kfree(priv->rxSignalBuffer.rx_buff[i].bufptr);
-         priv->rxSignalBuffer.rx_buff[i].bufptr = NULL;
-    }
+	int i;
+
+	for(i=0; i<size; i++)
+	{
+		 priv->rxSignalBuffer.rx_buff[i].sig_len=0;
+		 kfree(priv->rxSignalBuffer.rx_buff[i].bufptr);
+		 priv->rxSignalBuffer.rx_buff[i].bufptr = NULL;
+	}
 }
 #endif
 /*
  * ---------------------------------------------------------------------------
  *  uf_register_netdev
  *
- *      Registers the network interface, installes the qdisc,
- *      and registers the inet handler.
- *      In the porting exercise, register the driver to the network
- *      stack if necessary.
+ *	  Registers the network interface, installes the qdisc,
+ *	  and registers the inet handler.
+ *	  In the porting exercise, register the driver to the network
+ *	  stack if necessary.
  *
  *  Arguments:
- *      priv          Pointer to driver context.
+ *	  priv		  Pointer to driver context.
  *
  *  Returns:
- *      O on success, non-zero otherwise.
+ *	  O on success, non-zero otherwise.
  *
  *  Notes:
- *      We will only unregister when the card is ejected, so we must
- *      only do it once.
+ *	  We will only unregister when the card is ejected, so we must
+ *	  only do it once.
  * ---------------------------------------------------------------------------
  */
 int
 uf_register_netdev(unifi_priv_t *priv, int interfaceTag)
 {
-    int r;
-    netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
-
-    if (interfaceTag >= CSR_WIFI_NUM_INTERFACES) {
-        unifi_error(priv, "uf_register_netdev bad interfaceTag\n");
-        return -EINVAL;
-    }
-
-    /*
-     * Allocates a device number and registers device with the network
-     * stack.
-     */
-    unifi_trace(priv, UDBG5, "uf_register_netdev: netdev %d - 0x%p\n",
-            interfaceTag, priv->netdev[interfaceTag]);
-    r = register_netdev(priv->netdev[interfaceTag]);
-    if (r) {
-        unifi_error(priv, "Failed to register net device\n");
-        return -EINVAL;
-    }
-
-    /* The device is registed */
-    interfacePriv->netdev_registered = 1;
+	int r;
+	netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
+
+	if (interfaceTag >= CSR_WIFI_NUM_INTERFACES) {
+		unifi_error(priv, "uf_register_netdev bad interfaceTag\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Allocates a device number and registers device with the network
+	 * stack.
+	 */
+	unifi_trace(priv, UDBG5, "uf_register_netdev: netdev %d - 0x%p\n",
+			interfaceTag, priv->netdev[interfaceTag]);
+	r = register_netdev(priv->netdev[interfaceTag]);
+	if (r) {
+		unifi_error(priv, "Failed to register net device\n");
+		return -EINVAL;
+	}
+
+	/* The device is registed */
+	interfacePriv->netdev_registered = 1;
 
 #ifdef CSR_SUPPORT_SME
-    /*
-     * Register the inet handler; it notifies us for changes in the IP address.
-     */
-    uf_register_inet_notifier();
+	/*
+	 * Register the inet handler; it notifies us for changes in the IP address.
+	 */
+	uf_register_inet_notifier();
 #endif /* CSR_SUPPORT_SME */
 
-    unifi_notice(priv, "unifi%d is %s\n",
-            priv->instance, priv->netdev[interfaceTag]->name);
+	unifi_notice(priv, "unifi%d is %s\n",
+			priv->instance, priv->netdev[interfaceTag]->name);
 
-    return 0;
+	return 0;
 } /* uf_register_netdev */
 
 
@@ -191,48 +191,48 @@ uf_register_netdev(unifi_priv_t *priv, int interfaceTag)
  * ---------------------------------------------------------------------------
  *  uf_unregister_netdev
  *
- *      Unregisters the network interface and the inet handler.
+ *	  Unregisters the network interface and the inet handler.
  *
  *  Arguments:
- *      priv          Pointer to driver context.
+ *	  priv		  Pointer to driver context.
  *
  *  Returns:
- *      None.
+ *	  None.
  *
  * ---------------------------------------------------------------------------
  */
 void
 uf_unregister_netdev(unifi_priv_t *priv)
 {
-    int i=0;
+	int i=0;
 
 #ifdef CSR_SUPPORT_SME
-    /* Unregister the inet handler... */
-    uf_unregister_inet_notifier();
+	/* Unregister the inet handler... */
+	uf_unregister_inet_notifier();
 #endif /* CSR_SUPPORT_SME */
 
-    for (i=0; i<CSR_WIFI_NUM_INTERFACES; i++) {
-        netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
-        if (interfacePriv->netdev_registered) {
-            unifi_trace(priv, UDBG5,
-                    "uf_unregister_netdev: netdev %d - 0x%p\n",
-                    i, priv->netdev[i]);
+	for (i=0; i<CSR_WIFI_NUM_INTERFACES; i++) {
+		netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
+		if (interfacePriv->netdev_registered) {
+			unifi_trace(priv, UDBG5,
+					"uf_unregister_netdev: netdev %d - 0x%p\n",
+					i, priv->netdev[i]);
 
-            /* ... and the netdev */
-            unregister_netdev(priv->netdev[i]);
-            interfacePriv->netdev_registered = 0;
-        }
+			/* ... and the netdev */
+			unregister_netdev(priv->netdev[i]);
+			interfacePriv->netdev_registered = 0;
+		}
 
-        interfacePriv->interfaceMode = 0;
+		interfacePriv->interfaceMode = 0;
 
-        /* Enable all queues by default */
-        interfacePriv->queueEnabled[0] = 1;
-        interfacePriv->queueEnabled[1] = 1;
-        interfacePriv->queueEnabled[2] = 1;
-        interfacePriv->queueEnabled[3] = 1;
-    }
+		/* Enable all queues by default */
+		interfacePriv->queueEnabled[0] = 1;
+		interfacePriv->queueEnabled[1] = 1;
+		interfacePriv->queueEnabled[2] = 1;
+		interfacePriv->queueEnabled[3] = 1;
+	}
 
-    priv->totalInterfaceCount = 0;
+	priv->totalInterfaceCount = 0;
 } /* uf_unregister_netdev() */
 
 
@@ -240,217 +240,217 @@ uf_unregister_netdev(unifi_priv_t *priv)
  * ---------------------------------------------------------------------------
  *  register_unifi_sdio
  *
- *      This function is called from the Probe (or equivalent) method of
- *      the SDIO driver when a UniFi card is detected.
- *      We allocate the Linux net_device struct, initialise the HIP core
- *      lib, create the char device nodes and start the userspace helper
- *      to initialise the device.
+ *	  This function is called from the Probe (or equivalent) method of
+ *	  the SDIO driver when a UniFi card is detected.
+ *	  We allocate the Linux net_device struct, initialise the HIP core
+ *	  lib, create the char device nodes and start the userspace helper
+ *	  to initialise the device.
  *
  *  Arguments:
- *      sdio_dev        Pointer to SDIO context handle to use for all
- *                      SDIO ops.
- *      bus_id          A small number indicating the SDIO card position on the
- *                      bus. Typically this is the slot number, e.g. 0, 1 etc.
- *                      Valid values are 0 to MAX_UNIFI_DEVS-1.
- *      dev             Pointer to kernel device manager struct.
+ *	  sdio_dev		Pointer to SDIO context handle to use for all
+ *					  SDIO ops.
+ *	  bus_id		  A small number indicating the SDIO card position on the
+ *					  bus. Typically this is the slot number, e.g. 0, 1 etc.
+ *					  Valid values are 0 to MAX_UNIFI_DEVS-1.
+ *	  dev			 Pointer to kernel device manager struct.
  *
  *  Returns:
- *      Pointer to the unifi instance, or NULL on error.
+ *	  Pointer to the unifi instance, or NULL on error.
  * ---------------------------------------------------------------------------
  */
 static unifi_priv_t *
 register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 {
-    unifi_priv_t *priv = NULL;
-    int r = -1;
-    CsrResult csrResult;
-
-    func_enter();
-
-    if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
-        unifi_error(priv, "register_unifi_sdio: invalid device %d\n",
-                bus_id);
-        return NULL;
-    }
-
-    down(&Unifi_instance_mutex);
-
-    if (In_use[bus_id] != UNIFI_DEV_NOT_IN_USE) {
-        unifi_error(priv, "register_unifi_sdio: device %d is already in use\n",
-                bus_id);
-        goto failed0;
-    }
-
-
-    /* Allocate device private and net_device structs */
-    priv = uf_alloc_netdevice(sdio_dev, bus_id);
-    if (priv == NULL) {
-        unifi_error(priv, "Failed to allocate driver private\n");
-        goto failed0;
-    }
-
-    priv->unifi_device = dev;
-
-    SET_NETDEV_DEV(priv->netdev[0], dev);
-
-    /* We are not ready to send data yet. */
-    netif_carrier_off(priv->netdev[0]);
-
-    /* Allocate driver context. */
-    priv->card = unifi_alloc_card(priv->sdio, priv);
-    if (priv->card == NULL) {
-        unifi_error(priv, "Failed to allocate UniFi driver card struct.\n");
-        goto failed1;
-    }
-
-    if (Unifi_instances[bus_id]) {
-        unifi_error(priv, "Internal error: instance for slot %d is already taken\n",
-                bus_id);
-    }
-    Unifi_instances[bus_id] = priv;
-    In_use[bus_id] = UNIFI_DEV_IN_USE;
-
-    /* Save the netdev_priv for use by the netdev event callback mechanism */
-    Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES] = netdev_priv(priv->netdev[0]);
-
-    /* Initialise the mini-coredump capture buffers */
-    csrResult = unifi_coredump_init(priv->card, (u16)coredump_max);
-    if (csrResult != CSR_RESULT_SUCCESS) {
-        unifi_error(priv, "Couldn't allocate mini-coredump buffers\n");
-    }
-
-    /* Create the character device nodes */
-    r = uf_create_device_nodes(priv, bus_id);
-    if (r) {
-        goto failed1;
-    }
-
-    /*
-     * We use the slot number as unifi device index.
-     */
-    scnprintf(priv->proc_entry_name, 64, "driver/unifi%d", priv->instance);
-    /*
-     * The following complex casting is in place in order to eliminate 64-bit compilation warning
-     * "cast to/from pointer from/to integer of different size"
-     */
-    if (!create_proc_read_entry(priv->proc_entry_name, 0, 0,
-                uf_read_proc, (void *)(long)priv->instance))
-    {
-        unifi_error(priv, "unifi: can't create /proc/driver/unifi\n");
-    }
-
-    /* Allocate the net_device for interfaces other than 0. */
-    {
-        int i;
-        priv->totalInterfaceCount =0;
-
-        for(i=1;i<CSR_WIFI_NUM_INTERFACES;i++)
-        {
-            if( !uf_alloc_netdevice_for_other_interfaces(priv,i) )
-            {
-                /* error occured while allocating the net_device for interface[i]. The net_device are
-                 * allocated for the interfaces with id<i. Dont worry, all the allocated net_device will
-                 * be releasing chen the control goes to the label failed0.
-                 */
-                unifi_error(priv, "Failed to allocate driver private for interface[%d]\n",i);
-                goto failed0;
-            }
-            else
-            {
-                SET_NETDEV_DEV(priv->netdev[i], dev);
-
-                /* We are not ready to send data yet. */
-                netif_carrier_off(priv->netdev[i]);
-
-                /* Save the netdev_priv for use by the netdev event callback mechanism */
-                Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES + i] = netdev_priv(priv->netdev[i]);
-            }
-        }
-
-        for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
-        {
-            netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
-            interfacePriv->netdev_registered=0;
-        }
-    }
+	unifi_priv_t *priv = NULL;
+	int r = -1;
+	CsrResult csrResult;
+
+	func_enter();
+
+	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
+		unifi_error(priv, "register_unifi_sdio: invalid device %d\n",
+				bus_id);
+		return NULL;
+	}
+
+	down(&Unifi_instance_mutex);
+
+	if (In_use[bus_id] != UNIFI_DEV_NOT_IN_USE) {
+		unifi_error(priv, "register_unifi_sdio: device %d is already in use\n",
+				bus_id);
+		goto failed0;
+	}
+
+
+	/* Allocate device private and net_device structs */
+	priv = uf_alloc_netdevice(sdio_dev, bus_id);
+	if (priv == NULL) {
+		unifi_error(priv, "Failed to allocate driver private\n");
+		goto failed0;
+	}
+
+	priv->unifi_device = dev;
+
+	SET_NETDEV_DEV(priv->netdev[0], dev);
+
+	/* We are not ready to send data yet. */
+	netif_carrier_off(priv->netdev[0]);
+
+	/* Allocate driver context. */
+	priv->card = unifi_alloc_card(priv->sdio, priv);
+	if (priv->card == NULL) {
+		unifi_error(priv, "Failed to allocate UniFi driver card struct.\n");
+		goto failed1;
+	}
+
+	if (Unifi_instances[bus_id]) {
+		unifi_error(priv, "Internal error: instance for slot %d is already taken\n",
+				bus_id);
+	}
+	Unifi_instances[bus_id] = priv;
+	In_use[bus_id] = UNIFI_DEV_IN_USE;
+
+	/* Save the netdev_priv for use by the netdev event callback mechanism */
+	Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES] = netdev_priv(priv->netdev[0]);
+
+	/* Initialise the mini-coredump capture buffers */
+	csrResult = unifi_coredump_init(priv->card, (u16)coredump_max);
+	if (csrResult != CSR_RESULT_SUCCESS) {
+		unifi_error(priv, "Couldn't allocate mini-coredump buffers\n");
+	}
+
+	/* Create the character device nodes */
+	r = uf_create_device_nodes(priv, bus_id);
+	if (r) {
+		goto failed1;
+	}
+
+	/*
+	 * We use the slot number as unifi device index.
+	 */
+	scnprintf(priv->proc_entry_name, 64, "driver/unifi%d", priv->instance);
+	/*
+	 * The following complex casting is in place in order to eliminate 64-bit compilation warning
+	 * "cast to/from pointer from/to integer of different size"
+	 */
+	if (!create_proc_read_entry(priv->proc_entry_name, 0, 0,
+				uf_read_proc, (void *)(long)priv->instance))
+	{
+		unifi_error(priv, "unifi: can't create /proc/driver/unifi\n");
+	}
+
+	/* Allocate the net_device for interfaces other than 0. */
+	{
+		int i;
+		priv->totalInterfaceCount =0;
+
+		for(i=1;i<CSR_WIFI_NUM_INTERFACES;i++)
+		{
+			if( !uf_alloc_netdevice_for_other_interfaces(priv,i) )
+			{
+				/* error occured while allocating the net_device for interface[i]. The net_device are
+				 * allocated for the interfaces with id<i. Dont worry, all the allocated net_device will
+				 * be releasing chen the control goes to the label failed0.
+				 */
+				unifi_error(priv, "Failed to allocate driver private for interface[%d]\n",i);
+				goto failed0;
+			}
+			else
+			{
+				SET_NETDEV_DEV(priv->netdev[i], dev);
+
+				/* We are not ready to send data yet. */
+				netif_carrier_off(priv->netdev[i]);
+
+				/* Save the netdev_priv for use by the netdev event callback mechanism */
+				Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES + i] = netdev_priv(priv->netdev[i]);
+			}
+		}
+
+		for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
+		{
+			netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
+			interfacePriv->netdev_registered=0;
+		}
+	}
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
-    if (signal_buffer_init(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE))
-    {
-        unifi_error(priv,"Failed to allocate shared memory for T-H signals\n");
-        goto failed2;
-    }
-    priv->rx_workqueue = create_singlethread_workqueue("rx_workq");
-    if (priv->rx_workqueue == NULL) {
-        unifi_error(priv,"create_singlethread_workqueue failed \n");
-        goto failed3;
-    }
-    INIT_WORK(&priv->rx_work_struct, rx_wq_handler);
+	if (signal_buffer_init(priv, CSR_WIFI_RX_SIGNAL_BUFFER_SIZE))
+	{
+		unifi_error(priv,"Failed to allocate shared memory for T-H signals\n");
+		goto failed2;
+	}
+	priv->rx_workqueue = create_singlethread_workqueue("rx_workq");
+	if (priv->rx_workqueue == NULL) {
+		unifi_error(priv,"create_singlethread_workqueue failed \n");
+		goto failed3;
+	}
+	INIT_WORK(&priv->rx_work_struct, rx_wq_handler);
 #endif
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-    if (log_hip_signals)
-    {
-        uf_register_hip_offline_debug(priv);
-    }
+	if (log_hip_signals)
+	{
+		uf_register_hip_offline_debug(priv);
+	}
 #endif
 
-    /* Initialise the SME related threads and parameters */
-    r = uf_sme_init(priv);
-    if (r) {
-        unifi_error(priv, "SME initialisation failed.\n");
-        goto failed4;
-    }
-
-    /*
-     * Run the userspace helper program (unififw) to perform
-     * the device initialisation.
-     */
-    unifi_trace(priv, UDBG1, "run UniFi helper app...\n");
-    r = uf_run_unifihelper(priv);
-    if (r) {
-        unifi_notice(priv, "unable to run UniFi helper app\n");
-        /* Not a fatal error. */
-    }
-
-    up(&Unifi_instance_mutex);
-
-    func_exit();
-    return priv;
+	/* Initialise the SME related threads and parameters */
+	r = uf_sme_init(priv);
+	if (r) {
+		unifi_error(priv, "SME initialisation failed.\n");
+		goto failed4;
+	}
+
+	/*
+	 * Run the userspace helper program (unififw) to perform
+	 * the device initialisation.
+	 */
+	unifi_trace(priv, UDBG1, "run UniFi helper app...\n");
+	r = uf_run_unifihelper(priv);
+	if (r) {
+		unifi_notice(priv, "unable to run UniFi helper app\n");
+		/* Not a fatal error. */
+	}
+
+	up(&Unifi_instance_mutex);
+
+	func_exit();
+	return priv;
 
 failed4:
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
 if (log_hip_signals)
 {
-    uf_unregister_hip_offline_debug(priv);
+	uf_unregister_hip_offline_debug(priv);
 }
 #endif
 #ifdef CSR_WIFI_RX_PATH_SPLIT
-    flush_workqueue(priv->rx_workqueue);
-    destroy_workqueue(priv->rx_workqueue);
+	flush_workqueue(priv->rx_workqueue);
+	destroy_workqueue(priv->rx_workqueue);
 failed3:
-    signal_buffer_free(priv,CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
+	signal_buffer_free(priv,CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
 failed2:
 #endif
-    /* Remove the device nodes */
-    uf_destroy_device_nodes(priv);
+	/* Remove the device nodes */
+	uf_destroy_device_nodes(priv);
 failed1:
-    /* Deregister priv->netdev_client */
-    ul_deregister_client(priv->netdev_client);
+	/* Deregister priv->netdev_client */
+	ul_deregister_client(priv->netdev_client);
 
 failed0:
-    if (priv && priv->card) {
-        unifi_coredump_free(priv->card);
-        unifi_free_card(priv->card);
-    }
-    if (priv) {
-        uf_free_netdevice(priv);
-    }
-
-    up(&Unifi_instance_mutex);
-
-    func_exit();
-    return NULL;
+	if (priv && priv->card) {
+		unifi_coredump_free(priv->card);
+		unifi_free_card(priv->card);
+	}
+	if (priv) {
+		uf_free_netdevice(priv);
+	}
+
+	up(&Unifi_instance_mutex);
+
+	func_exit();
+	return NULL;
 } /* register_unifi_sdio() */
 
 
@@ -458,35 +458,35 @@ failed0:
  * ---------------------------------------------------------------------------
  *  ask_unifi_sdio_cleanup
  *
- *      We can not free our private context, until all the char device
- *      clients have closed the file handles. unregister_unifi_sdio() which
- *      is called when a card is removed, waits on Unifi_cleanup_wq until
- *      the reference count becomes zero. It is time to wake it up now.
+ *	  We can not free our private context, until all the char device
+ *	  clients have closed the file handles. unregister_unifi_sdio() which
+ *	  is called when a card is removed, waits on Unifi_cleanup_wq until
+ *	  the reference count becomes zero. It is time to wake it up now.
  *
  *  Arguments:
- *      priv          Pointer to driver context.
+ *	  priv		  Pointer to driver context.
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 static void
 ask_unifi_sdio_cleanup(unifi_priv_t *priv)
 {
-    func_enter();
+	func_enter();
 
-    /*
-     * Now clear the flag that says the old instance is in use.
-     * This is used to prevent a new instance being started before old
-     * one has finshed closing down, for example if bounce makes the card
-     * appear to be ejected and re-inserted quickly.
-     */
-    In_use[priv->instance] = UNIFI_DEV_CLEANUP;
+	/*
+	 * Now clear the flag that says the old instance is in use.
+	 * This is used to prevent a new instance being started before old
+	 * one has finshed closing down, for example if bounce makes the card
+	 * appear to be ejected and re-inserted quickly.
+	 */
+	In_use[priv->instance] = UNIFI_DEV_CLEANUP;
 
-    unifi_trace(NULL, UDBG5, "ask_unifi_sdio_cleanup: wake up cleanup workqueue.\n");
-    wake_up(&Unifi_cleanup_wq);
+	unifi_trace(NULL, UDBG5, "ask_unifi_sdio_cleanup: wake up cleanup workqueue.\n");
+	wake_up(&Unifi_cleanup_wq);
 
-    func_exit();
+	func_exit();
 
 } /* ask_unifi_sdio_cleanup() */
 
@@ -495,116 +495,116 @@ ask_unifi_sdio_cleanup(unifi_priv_t *priv)
  * ---------------------------------------------------------------------------
  *  cleanup_unifi_sdio
  *
- *      Release any resources owned by a unifi instance.
+ *	  Release any resources owned by a unifi instance.
  *
  *  Arguments:
- *      priv          Pointer to the instance to free.
+ *	  priv		  Pointer to the instance to free.
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 static void
 cleanup_unifi_sdio(unifi_priv_t *priv)
 {
-    int priv_instance;
-    int i;
-    static const CsrWifiMacAddress broadcast_address = {{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
+	int priv_instance;
+	int i;
+	static const CsrWifiMacAddress broadcast_address = {{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
 
-    func_enter();
+	func_enter();
 
-    /* Remove the device nodes */
-    uf_destroy_device_nodes(priv);
+	/* Remove the device nodes */
+	uf_destroy_device_nodes(priv);
 
-    /* Mark this device as gone away by NULLing the entry in Unifi_instances */
-    Unifi_instances[priv->instance] = NULL;
+	/* Mark this device as gone away by NULLing the entry in Unifi_instances */
+	Unifi_instances[priv->instance] = NULL;
 
-    unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: remove_proc_entry\n");
-    /*
-     * Free the children of priv before unifi_free_netdevice() frees
-     * the priv struct
-     */
-    remove_proc_entry(priv->proc_entry_name, 0);
+	unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: remove_proc_entry\n");
+	/*
+	 * Free the children of priv before unifi_free_netdevice() frees
+	 * the priv struct
+	 */
+	remove_proc_entry(priv->proc_entry_name, 0);
 
 
-    /* Unregister netdev as a client. */
-    if (priv->netdev_client) {
-        unifi_trace(priv, UDBG2, "Netdev client (id:%d s:0x%X) is unregistered\n",
-                priv->netdev_client->client_id, priv->netdev_client->sender_id);
-        ul_deregister_client(priv->netdev_client);
-    }
+	/* Unregister netdev as a client. */
+	if (priv->netdev_client) {
+		unifi_trace(priv, UDBG2, "Netdev client (id:%d s:0x%X) is unregistered\n",
+				priv->netdev_client->client_id, priv->netdev_client->sender_id);
+		ul_deregister_client(priv->netdev_client);
+	}
 
-    /* Destroy the SME related threads and parameters */
-    uf_sme_deinit(priv);
+	/* Destroy the SME related threads and parameters */
+	uf_sme_deinit(priv);
 
 #ifdef CSR_SME_USERSPACE
-    priv->smepriv = NULL;
+	priv->smepriv = NULL;
 #endif
 
 #ifdef CSR_WIFI_HIP_DEBUG_OFFLINE
-    if (log_hip_signals)
-    {
-        uf_unregister_hip_offline_debug(priv);
-    }
+	if (log_hip_signals)
+	{
+		uf_unregister_hip_offline_debug(priv);
+	}
 #endif
 
-    /* Free any packets left in the Rx queues */
-    for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
-    {
-        uf_free_pending_rx_packets(priv, UF_UNCONTROLLED_PORT_Q, broadcast_address,i);
-        uf_free_pending_rx_packets(priv, UF_CONTROLLED_PORT_Q, broadcast_address,i);
-    }
-    /*
-     * We need to free the resources held by the core, which include tx skbs,
-     * otherwise we can not call unregister_netdev().
-     */
-    if (priv->card) {
-        unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: free card\n");
-        unifi_coredump_free(priv->card);
-        unifi_free_card(priv->card);
-        priv->card = NULL;
-    }
-
-    /*
-     * Unregister the network device.
-     * We can not unregister the netdev before we release
-     * all pending packets in the core.
-     */
-    uf_unregister_netdev(priv);
-    priv->totalInterfaceCount = 0;
-
-    /* Clear the table of registered netdev_priv's */
-    for (i = 0; i < CSR_WIFI_NUM_INTERFACES; i++) {
-        Unifi_netdev_instances[priv->instance * CSR_WIFI_NUM_INTERFACES + i] = NULL;
-    }
-
-    unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: uf_free_netdevice\n");
-    /*
-     * When uf_free_netdevice() returns, the priv is invalid
-     * so we need to remember the instance to clear the global flag later.
-     */
-    priv_instance = priv->instance;
+	/* Free any packets left in the Rx queues */
+	for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
+	{
+		uf_free_pending_rx_packets(priv, UF_UNCONTROLLED_PORT_Q, broadcast_address,i);
+		uf_free_pending_rx_packets(priv, UF_CONTROLLED_PORT_Q, broadcast_address,i);
+	}
+	/*
+	 * We need to free the resources held by the core, which include tx skbs,
+	 * otherwise we can not call unregister_netdev().
+	 */
+	if (priv->card) {
+		unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: free card\n");
+		unifi_coredump_free(priv->card);
+		unifi_free_card(priv->card);
+		priv->card = NULL;
+	}
+
+	/*
+	 * Unregister the network device.
+	 * We can not unregister the netdev before we release
+	 * all pending packets in the core.
+	 */
+	uf_unregister_netdev(priv);
+	priv->totalInterfaceCount = 0;
+
+	/* Clear the table of registered netdev_priv's */
+	for (i = 0; i < CSR_WIFI_NUM_INTERFACES; i++) {
+		Unifi_netdev_instances[priv->instance * CSR_WIFI_NUM_INTERFACES + i] = NULL;
+	}
+
+	unifi_trace(priv, UDBG5, "cleanup_unifi_sdio: uf_free_netdevice\n");
+	/*
+	 * When uf_free_netdevice() returns, the priv is invalid
+	 * so we need to remember the instance to clear the global flag later.
+	 */
+	priv_instance = priv->instance;
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
-    flush_workqueue(priv->rx_workqueue);
-    destroy_workqueue(priv->rx_workqueue);
-    signal_buffer_free(priv,CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
+	flush_workqueue(priv->rx_workqueue);
+	destroy_workqueue(priv->rx_workqueue);
+	signal_buffer_free(priv,CSR_WIFI_RX_SIGNAL_BUFFER_SIZE);
 #endif
 
-    /* Priv is freed as part of the net_device */
-    uf_free_netdevice(priv);
+	/* Priv is freed as part of the net_device */
+	uf_free_netdevice(priv);
 
-    /*
-     * Now clear the flag that says the old instance is in use.
-     * This is used to prevent a new instance being started before old
-     * one has finshed closing down, for example if bounce makes the card
-     * appear to be ejected and re-inserted quickly.
-     */
-    In_use[priv_instance] = UNIFI_DEV_NOT_IN_USE;
+	/*
+	 * Now clear the flag that says the old instance is in use.
+	 * This is used to prevent a new instance being started before old
+	 * one has finshed closing down, for example if bounce makes the card
+	 * appear to be ejected and re-inserted quickly.
+	 */
+	In_use[priv_instance] = UNIFI_DEV_NOT_IN_USE;
 
-    unifi_trace(NULL, UDBG5, "cleanup_unifi_sdio: DONE.\n");
+	unifi_trace(NULL, UDBG5, "cleanup_unifi_sdio: DONE.\n");
 
-    func_exit();
+	func_exit();
 
 } /* cleanup_unifi_sdio() */
 
@@ -613,81 +613,81 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
  * ---------------------------------------------------------------------------
  *  unregister_unifi_sdio
  *
- *      Call from SDIO driver when it detects that UniFi has been removed.
+ *	  Call from SDIO driver when it detects that UniFi has been removed.
  *
  *  Arguments:
- *      bus_id          Number of the card that was ejected.
+ *	  bus_id		  Number of the card that was ejected.
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 static void
 unregister_unifi_sdio(int bus_id)
 {
-    unifi_priv_t *priv;
-    int interfaceTag=0;
-    u8 reason = CONFIG_IND_EXIT;
-
-    if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
-        unifi_error(NULL, "unregister_unifi_sdio: invalid device %d\n",
-                bus_id);
-        return;
-    }
-
-    priv = Unifi_instances[bus_id];
-    if (priv == NULL) {
-        unifi_error(priv, "unregister_unifi_sdio: device %d is not registered\n",
-                bus_id);
-        func_exit();
-        return;
-    }
-
-    /* Stop the network traffic before freeing the core. */
-    for(interfaceTag=0;interfaceTag<priv->totalInterfaceCount;interfaceTag++)
-    {
-        netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
-        if(interfacePriv->netdev_registered)
-        {
-            netif_carrier_off(priv->netdev[interfaceTag]);
-            netif_tx_stop_all_queues(priv->netdev[interfaceTag]);
-        }
-    }
+	unifi_priv_t *priv;
+	int interfaceTag=0;
+	u8 reason = CONFIG_IND_EXIT;
+
+	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
+		unifi_error(NULL, "unregister_unifi_sdio: invalid device %d\n",
+				bus_id);
+		return;
+	}
+
+	priv = Unifi_instances[bus_id];
+	if (priv == NULL) {
+		unifi_error(priv, "unregister_unifi_sdio: device %d is not registered\n",
+				bus_id);
+		func_exit();
+		return;
+	}
+
+	/* Stop the network traffic before freeing the core. */
+	for(interfaceTag=0;interfaceTag<priv->totalInterfaceCount;interfaceTag++)
+	{
+		netInterface_priv_t *interfacePriv = priv->interfacePriv[interfaceTag];
+		if(interfacePriv->netdev_registered)
+		{
+			netif_carrier_off(priv->netdev[interfaceTag]);
+			netif_tx_stop_all_queues(priv->netdev[interfaceTag]);
+		}
+	}
 
 #ifdef CSR_NATIVE_LINUX
-    /*
-     * If the unifi thread was started, signal it to stop.  This
-     * should cause any userspace processes with open unifi device to
-     * close them.
-     */
-    uf_stop_thread(priv, &priv->bh_thread);
-
-    /* Unregister the interrupt handler */
-    if (csr_sdio_linux_remove_irq(priv->sdio)) {
-        unifi_notice(priv,
-                "csr_sdio_linux_remove_irq failed to talk to card.\n");
-    }
-
-    /* Ensure no MLME functions are waiting on a the mlme_event semaphore. */
-    uf_abort_mlme(priv);
+	/*
+	 * If the unifi thread was started, signal it to stop.  This
+	 * should cause any userspace processes with open unifi device to
+	 * close them.
+	 */
+	uf_stop_thread(priv, &priv->bh_thread);
+
+	/* Unregister the interrupt handler */
+	if (csr_sdio_linux_remove_irq(priv->sdio)) {
+		unifi_notice(priv,
+				"csr_sdio_linux_remove_irq failed to talk to card.\n");
+	}
+
+	/* Ensure no MLME functions are waiting on a the mlme_event semaphore. */
+	uf_abort_mlme(priv);
 #endif /* CSR_NATIVE_LINUX */
 
-    ul_log_config_ind(priv, &reason, sizeof(u8));
+	ul_log_config_ind(priv, &reason, sizeof(u8));
 
-    /* Deregister the UDI hook from the core. */
-    unifi_remove_udi_hook(priv->card, logging_handler);
+	/* Deregister the UDI hook from the core. */
+	unifi_remove_udi_hook(priv->card, logging_handler);
 
-    uf_put_instance(bus_id);
+	uf_put_instance(bus_id);
 
-    /*
-     * Wait until the device is cleaned up. i.e., when all userspace
-     * processes have closed any open unifi devices.
-     */
-    wait_event(Unifi_cleanup_wq, In_use[bus_id] == UNIFI_DEV_CLEANUP);
-    unifi_trace(NULL, UDBG5, "Received clean up event\n");
+	/*
+	 * Wait until the device is cleaned up. i.e., when all userspace
+	 * processes have closed any open unifi devices.
+	 */
+	wait_event(Unifi_cleanup_wq, In_use[bus_id] == UNIFI_DEV_CLEANUP);
+	unifi_trace(NULL, UDBG5, "Received clean up event\n");
 
-    /* Now we can free the private context and the char device nodes */
-    cleanup_unifi_sdio(priv);
+	/* Now we can free the private context and the char device nodes */
+	cleanup_unifi_sdio(priv);
 
 } /* unregister_unifi_sdio() */
 
@@ -696,22 +696,22 @@ unregister_unifi_sdio(int bus_id)
  * ---------------------------------------------------------------------------
  *  uf_find_instance
  *
- *      Find the context structure for a given UniFi device instance.
+ *	  Find the context structure for a given UniFi device instance.
  *
  *  Arguments:
- *      inst            The instance number to look for.
+ *	  inst			The instance number to look for.
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 unifi_priv_t *
 uf_find_instance(int inst)
 {
-    if ((inst < 0) || (inst >= MAX_UNIFI_DEVS)) {
-        return NULL;
-    }
-    return Unifi_instances[inst];
+	if ((inst < 0) || (inst >= MAX_UNIFI_DEVS)) {
+		return NULL;
+	}
+	return Unifi_instances[inst];
 } /* uf_find_instance() */
 
 
@@ -719,125 +719,125 @@ uf_find_instance(int inst)
  * ---------------------------------------------------------------------------
  *  uf_find_priv
  *
- *      Find the device instance for a given context structure.
+ *	  Find the device instance for a given context structure.
  *
  *  Arguments:
- *      priv            The context structure pointer to look for.
+ *	  priv			The context structure pointer to look for.
  *
  *  Returns:
- *      index of instance, -1 otherwise.
+ *	  index of instance, -1 otherwise.
  * ---------------------------------------------------------------------------
  */
 int
 uf_find_priv(unifi_priv_t *priv)
 {
-    int inst;
+	int inst;
 
-    if (!priv) {
-        return -1;
-    }
+	if (!priv) {
+		return -1;
+	}
 
-    for (inst = 0; inst < MAX_UNIFI_DEVS; inst++) {
-        if (Unifi_instances[inst] == priv) {
-            return inst;
-        }
-    }
+	for (inst = 0; inst < MAX_UNIFI_DEVS; inst++) {
+		if (Unifi_instances[inst] == priv) {
+			return inst;
+		}
+	}
 
-    return -1;
+	return -1;
 } /* uf_find_priv() */
 
 /*
  * ---------------------------------------------------------------------------
  *  uf_find_netdev_priv
  *
- *      Find the device instance for a given netdev context structure.
+ *	  Find the device instance for a given netdev context structure.
  *
  *  Arguments:
- *      priv            The context structure pointer to look for.
+ *	  priv			The context structure pointer to look for.
  *
  *  Returns:
- *      index of instance, -1 otherwise.
+ *	  index of instance, -1 otherwise.
  * ---------------------------------------------------------------------------
  */
 int
 uf_find_netdev_priv(netInterface_priv_t *priv)
 {
-    int inst;
+	int inst;
 
-    if (!priv) {
-        return -1;
-    }
+	if (!priv) {
+		return -1;
+	}
 
-    for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES; inst++) {
-        if (Unifi_netdev_instances[inst] == priv) {
-            return inst;
-        }
-    }
+	for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES; inst++) {
+		if (Unifi_netdev_instances[inst] == priv) {
+			return inst;
+		}
+	}
 
-    return -1;
+	return -1;
 } /* uf_find_netdev_priv() */
 
 /*
  * ---------------------------------------------------------------------------
  *  uf_get_instance
  *
- *      Find the context structure for a given UniFi device instance
- *      and increment the reference count.
+ *	  Find the context structure for a given UniFi device instance
+ *	  and increment the reference count.
  *
  *  Arguments:
- *      inst            The instance number to look for.
+ *	  inst			The instance number to look for.
  *
  *  Returns:
- *      Pointer to the instance or NULL if no instance exists.
+ *	  Pointer to the instance or NULL if no instance exists.
  * ---------------------------------------------------------------------------
  */
 unifi_priv_t *
 uf_get_instance(int inst)
 {
-    unifi_priv_t *priv;
+	unifi_priv_t *priv;
 
-    down(&Unifi_instance_mutex);
+	down(&Unifi_instance_mutex);
 
-    priv = uf_find_instance(inst);
-    if (priv) {
-        priv->ref_count++;
-    }
+	priv = uf_find_instance(inst);
+	if (priv) {
+		priv->ref_count++;
+	}
 
-    up(&Unifi_instance_mutex);
+	up(&Unifi_instance_mutex);
 
-    return priv;
+	return priv;
 }
 
 /*
  * ---------------------------------------------------------------------------
  *  uf_put_instance
  *
- *      Decrement the context reference count, freeing resources and
- *      shutting down the driver when the count reaches zero.
+ *	  Decrement the context reference count, freeing resources and
+ *	  shutting down the driver when the count reaches zero.
  *
  *  Arguments:
- *      inst            The instance number to look for.
+ *	  inst			The instance number to look for.
  *
  *  Returns:
- *      Pointer to the instance or NULL if no instance exists.
+ *	  Pointer to the instance or NULL if no instance exists.
  * ---------------------------------------------------------------------------
  */
 void
 uf_put_instance(int inst)
 {
-    unifi_priv_t *priv;
+	unifi_priv_t *priv;
 
-    down(&Unifi_instance_mutex);
+	down(&Unifi_instance_mutex);
 
-    priv = uf_find_instance(inst);
-    if (priv) {
-        priv->ref_count--;
-        if (priv->ref_count == 0) {
-            ask_unifi_sdio_cleanup(priv);
-        }
-    }
+	priv = uf_find_instance(inst);
+	if (priv) {
+		priv->ref_count--;
+		if (priv->ref_count == 0) {
+			ask_unifi_sdio_cleanup(priv);
+		}
+	}
 
-    up(&Unifi_instance_mutex);
+	up(&Unifi_instance_mutex);
 }
 
 
@@ -845,121 +845,121 @@ uf_put_instance(int inst)
  * ---------------------------------------------------------------------------
  *  uf_read_proc
  *
- *      Read method for driver node in /proc/driver/unifi0
+ *	  Read method for driver node in /proc/driver/unifi0
  *
  *  Arguments:
- *      page
- *      start
- *      offset
- *      count
- *      eof
- *      data
+ *	  page
+ *	  start
+ *	  offset
+ *	  count
+ *	  eof
+ *	  data
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 #ifdef CONFIG_PROC_FS
 static int
 uf_read_proc(char *page, char **start, off_t offset, int count,
-        int *eof, void *data)
+		int *eof, void *data)
 {
 #define UNIFI_DEBUG_TXT_BUFFER 8*1024
-    unifi_priv_t *priv;
-    int actual_amount_to_copy;
-    char *p, *orig_p;
-    s32 remain = UNIFI_DEBUG_TXT_BUFFER;
-    s32 written;
-    int i;
-
-    /*
-    * The following complex casting is in place in order to eliminate 64-bit compilation warning
-    * "cast to/from pointer from/to integer of different size"
-    */
-    priv = uf_find_instance((int)(long)data);
-    if (!priv) {
-        return 0;
-    }
-
-    p = kmalloc( UNIFI_DEBUG_TXT_BUFFER, GFP_KERNEL );
-
-    orig_p = p;
-
-    written = scnprintf(p, remain, "UniFi SDIO Driver: %s %s %s\n",
-            CSR_WIFI_VERSION, __DATE__, __TIME__);
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	unifi_priv_t *priv;
+	int actual_amount_to_copy;
+	char *p, *orig_p;
+	s32 remain = UNIFI_DEBUG_TXT_BUFFER;
+	s32 written;
+	int i;
+
+	/*
+	* The following complex casting is in place in order to eliminate 64-bit compilation warning
+	* "cast to/from pointer from/to integer of different size"
+	*/
+	priv = uf_find_instance((int)(long)data);
+	if (!priv) {
+		return 0;
+	}
+
+	p = kmalloc( UNIFI_DEBUG_TXT_BUFFER, GFP_KERNEL );
+
+	orig_p = p;
+
+	written = scnprintf(p, remain, "UniFi SDIO Driver: %s %s %s\n",
+			CSR_WIFI_VERSION, __DATE__, __TIME__);
+	UNIFI_SNPRINTF_RET(p, remain, written);
 #ifdef CSR_SME_USERSPACE
-    written = scnprintf(p, remain, "SME: CSR userspace ");
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	written = scnprintf(p, remain, "SME: CSR userspace ");
+	UNIFI_SNPRINTF_RET(p, remain, written);
 #ifdef CSR_SUPPORT_WEXT
-    written = scnprintf(p, remain, "with WEXT support\n");
+	written = scnprintf(p, remain, "with WEXT support\n");
 #else
-    written = scnprintf(p, remain, "\n");
+	written = scnprintf(p, remain, "\n");
 #endif /* CSR_SUPPORT_WEXT */
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	UNIFI_SNPRINTF_RET(p, remain, written);
 #endif /* CSR_SME_USERSPACE */
 #ifdef CSR_NATIVE_LINUX
-    written = scnprintf(p, remain, "SME: native\n");
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	written = scnprintf(p, remain, "SME: native\n");
+	UNIFI_SNPRINTF_RET(p, remain, written);
 #endif
 
 #ifdef CSR_SUPPORT_SME
-    written = scnprintf(p, remain,
-            "Firmware (ROM) build:%u, Patch:%u\n",
-            priv->card_info.fw_build,
-            priv->sme_versions.firmwarePatch);
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	written = scnprintf(p, remain,
+			"Firmware (ROM) build:%u, Patch:%u\n",
+			priv->card_info.fw_build,
+			priv->sme_versions.firmwarePatch);
+	UNIFI_SNPRINTF_RET(p, remain, written);
 #endif
-    p += unifi_print_status(priv->card, p, &remain);
-
-    written = scnprintf(p, remain, "Last dbg str: %s\n",
-            priv->last_debug_string);
-    UNIFI_SNPRINTF_RET(p, remain, written);
-
-    written = scnprintf(p, remain, "Last dbg16:");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    for (i = 0; i < 8; i++) {
-        written = scnprintf(p, remain, " %04X",
-                priv->last_debug_word16[i]);
-        UNIFI_SNPRINTF_RET(p, remain, written);
-    }
-    written = scnprintf(p, remain, "\n");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    written = scnprintf(p, remain, "           ");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    for (; i < 16; i++) {
-        written = scnprintf(p, remain, " %04X",
-                priv->last_debug_word16[i]);
-        UNIFI_SNPRINTF_RET(p, remain, written);
-    }
-    written = scnprintf(p, remain, "\n");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    *start = page;
-
-    written = UNIFI_DEBUG_TXT_BUFFER - remain;
-
-    if( offset >= written )
-    {
-        *eof = 1;
-        kfree( orig_p );
-        return(0);
-    }
-
-    if( offset + count > written )
-    {
-        actual_amount_to_copy = written - offset;
-        *eof = 1;
-    }
-    else
-    {
-        actual_amount_to_copy = count;
-    }
-
-    memcpy( page, &(orig_p[offset]), actual_amount_to_copy );
-
-    kfree( orig_p );
-
-    return( actual_amount_to_copy );
+	p += unifi_print_status(priv->card, p, &remain);
+
+	written = scnprintf(p, remain, "Last dbg str: %s\n",
+			priv->last_debug_string);
+	UNIFI_SNPRINTF_RET(p, remain, written);
+
+	written = scnprintf(p, remain, "Last dbg16:");
+	UNIFI_SNPRINTF_RET(p, remain, written);
+	for (i = 0; i < 8; i++) {
+		written = scnprintf(p, remain, " %04X",
+				priv->last_debug_word16[i]);
+		UNIFI_SNPRINTF_RET(p, remain, written);
+	}
+	written = scnprintf(p, remain, "\n");
+	UNIFI_SNPRINTF_RET(p, remain, written);
+	written = scnprintf(p, remain, "		   ");
+	UNIFI_SNPRINTF_RET(p, remain, written);
+	for (; i < 16; i++) {
+		written = scnprintf(p, remain, " %04X",
+				priv->last_debug_word16[i]);
+		UNIFI_SNPRINTF_RET(p, remain, written);
+	}
+	written = scnprintf(p, remain, "\n");
+	UNIFI_SNPRINTF_RET(p, remain, written);
+	*start = page;
+
+	written = UNIFI_DEBUG_TXT_BUFFER - remain;
+
+	if( offset >= written )
+	{
+		*eof = 1;
+		kfree( orig_p );
+		return(0);
+	}
+
+	if( offset + count > written )
+	{
+		actual_amount_to_copy = written - offset;
+		*eof = 1;
+	}
+	else
+	{
+		actual_amount_to_copy = count;
+	}
+
+	memcpy( page, &(orig_p[offset]), actual_amount_to_copy );
+
+	kfree( orig_p );
+
+	return( actual_amount_to_copy );
 } /* uf_read_proc() */
 #endif
 
@@ -969,19 +969,19 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 static void
 uf_lx_suspend(CsrSdioFunction *sdio_ctx)
 {
-    unifi_priv_t *priv = sdio_ctx->driverData;
-    unifi_suspend(priv);
+	unifi_priv_t *priv = sdio_ctx->driverData;
+	unifi_suspend(priv);
 
-    CsrSdioSuspendAcknowledge(sdio_ctx, CSR_RESULT_SUCCESS);
+	CsrSdioSuspendAcknowledge(sdio_ctx, CSR_RESULT_SUCCESS);
 }
 
 static void
 uf_lx_resume(CsrSdioFunction *sdio_ctx)
 {
-    unifi_priv_t *priv = sdio_ctx->driverData;
-    unifi_resume(priv);
+	unifi_priv_t *priv = sdio_ctx->driverData;
+	unifi_resume(priv);
 
-    CsrSdioResumeAcknowledge(sdio_ctx, CSR_RESULT_SUCCESS);
+	CsrSdioResumeAcknowledge(sdio_ctx, CSR_RESULT_SUCCESS);
 }
 
 static int active_slot = MAX_UNIFI_DEVS;
@@ -990,85 +990,85 @@ static struct device *os_devices[MAX_UNIFI_DEVS];
 void
 uf_add_os_device(int bus_id, struct device *os_device)
 {
-    if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
-        unifi_error(NULL, "uf_add_os_device: invalid device %d\n",
-                bus_id);
-        return;
-    }
-
-    active_slot = bus_id;
-    os_devices[bus_id] = os_device;
+	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
+		unifi_error(NULL, "uf_add_os_device: invalid device %d\n",
+				bus_id);
+		return;
+	}
+
+	active_slot = bus_id;
+	os_devices[bus_id] = os_device;
 } /* uf_add_os_device() */
 
 void
 uf_remove_os_device(int bus_id)
 {
-    if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
-        unifi_error(NULL, "uf_remove_os_device: invalid device %d\n",
-                bus_id);
-        return;
-    }
-
-    active_slot = bus_id;
-    os_devices[bus_id] = NULL;
+	if ((bus_id < 0) || (bus_id >= MAX_UNIFI_DEVS)) {
+		unifi_error(NULL, "uf_remove_os_device: invalid device %d\n",
+				bus_id);
+		return;
+	}
+
+	active_slot = bus_id;
+	os_devices[bus_id] = NULL;
 } /* uf_remove_os_device() */
 
 static void
 uf_sdio_inserted(CsrSdioFunction *sdio_ctx)
 {
-    unifi_priv_t *priv;
+	unifi_priv_t *priv;
 
-    unifi_trace(NULL, UDBG5, "uf_sdio_inserted(0x%p), slot_id=%d, dev=%p\n",
-            sdio_ctx, active_slot, os_devices[active_slot]);
+	unifi_trace(NULL, UDBG5, "uf_sdio_inserted(0x%p), slot_id=%d, dev=%p\n",
+			sdio_ctx, active_slot, os_devices[active_slot]);
 
-    priv = register_unifi_sdio(sdio_ctx, active_slot, os_devices[active_slot]);
-    if (priv == NULL) {
-        CsrSdioInsertedAcknowledge(sdio_ctx, CSR_RESULT_FAILURE);
-        return;
-    }
+	priv = register_unifi_sdio(sdio_ctx, active_slot, os_devices[active_slot]);
+	if (priv == NULL) {
+		CsrSdioInsertedAcknowledge(sdio_ctx, CSR_RESULT_FAILURE);
+		return;
+	}
 
-    sdio_ctx->driverData = priv;
+	sdio_ctx->driverData = priv;
 
-    CsrSdioInsertedAcknowledge(sdio_ctx, CSR_RESULT_SUCCESS);
+	CsrSdioInsertedAcknowledge(sdio_ctx, CSR_RESULT_SUCCESS);
 } /* uf_sdio_inserted() */
 
 
 static void
 uf_sdio_removed(CsrSdioFunction *sdio_ctx)
 {
-    unregister_unifi_sdio(active_slot);
-    CsrSdioRemovedAcknowledge(sdio_ctx);
+	unregister_unifi_sdio(active_slot);
+	CsrSdioRemovedAcknowledge(sdio_ctx);
 } /* uf_sdio_removed() */
 
 
 static void
 uf_sdio_dsr_handler(CsrSdioFunction *sdio_ctx)
 {
-    unifi_priv_t *priv = sdio_ctx->driverData;
+	unifi_priv_t *priv = sdio_ctx->driverData;
 
-    unifi_sdio_interrupt_handler(priv->card);
+	unifi_sdio_interrupt_handler(priv->card);
 } /* uf_sdio_dsr_handler() */
 
 /*
  * ---------------------------------------------------------------------------
  *  uf_sdio_int_handler
  *
- *      Interrupt callback function for SDIO interrupts.
- *      This is called in kernel context (i.e. not interrupt context).
- *      We retrieve the unifi context pointer and call the main UniFi
- *      interrupt handler.
+ *	  Interrupt callback function for SDIO interrupts.
+ *	  This is called in kernel context (i.e. not interrupt context).
+ *	  We retrieve the unifi context pointer and call the main UniFi
+ *	  interrupt handler.
  *
  *  Arguments:
- *      fdev      SDIO context pointer
+ *	  fdev	  SDIO context pointer
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 static CsrSdioInterruptDsrCallback
 uf_sdio_int_handler(CsrSdioFunction *sdio_ctx)
 {
-    return uf_sdio_dsr_handler;
+	return uf_sdio_dsr_handler;
 } /* uf_sdio_int_handler() */
 
 
@@ -1076,18 +1076,18 @@ uf_sdio_int_handler(CsrSdioFunction *sdio_ctx)
 
 static CsrSdioFunctionId unifi_ids[] =
 {
-    {
-        .manfId = SDIO_MANF_ID_CSR,
-        .cardId = SDIO_CARD_ID_UNIFI_3,
-        .sdioFunction = SDIO_WLAN_FUNC_ID_UNIFI_3,
-        .sdioInterface = CSR_SDIO_ANY_SDIO_INTERFACE,
-    },
-    {
-        .manfId = SDIO_MANF_ID_CSR,
-        .cardId = SDIO_CARD_ID_UNIFI_4,
-        .sdioFunction = SDIO_WLAN_FUNC_ID_UNIFI_4,
-        .sdioInterface = CSR_SDIO_ANY_SDIO_INTERFACE,
-    }
+	{
+		.manfId = SDIO_MANF_ID_CSR,
+		.cardId = SDIO_CARD_ID_UNIFI_3,
+		.sdioFunction = SDIO_WLAN_FUNC_ID_UNIFI_3,
+		.sdioInterface = CSR_SDIO_ANY_SDIO_INTERFACE,
+	},
+	{
+		.manfId = SDIO_MANF_ID_CSR,
+		.cardId = SDIO_CARD_ID_UNIFI_4,
+		.sdioFunction = SDIO_WLAN_FUNC_ID_UNIFI_4,
+		.sdioInterface = CSR_SDIO_ANY_SDIO_INTERFACE,
+	}
 };
 
 
@@ -1096,14 +1096,14 @@ static CsrSdioFunctionId unifi_ids[] =
  */
 static CsrSdioFunctionDriver unifi_sdioFunction_drv =
 {
-    .inserted = uf_sdio_inserted,
-    .removed = uf_sdio_removed,
-    .intr = uf_sdio_int_handler,
-    .suspend = uf_lx_suspend,
-    .resume = uf_lx_resume,
-
-    .ids = unifi_ids,
-    .idsCount = sizeof(unifi_ids) / sizeof(unifi_ids[0])
+	.inserted = uf_sdio_inserted,
+	.removed = uf_sdio_removed,
+	.intr = uf_sdio_int_handler,
+	.suspend = uf_lx_suspend,
+	.resume = uf_lx_resume,
+
+	.ids = unifi_ids,
+	.idsCount = sizeof(unifi_ids) / sizeof(unifi_ids[0])
 };
 
 
@@ -1112,29 +1112,29 @@ static CsrSdioFunctionDriver unifi_sdioFunction_drv =
  *  uf_sdio_load
  *  uf_sdio_unload
  *
- *      These functions are called from the main module load and unload
- *      functions. They perform the appropriate operations for the monolithic
- *      driver.
+ *	  These functions are called from the main module load and unload
+ *	  functions. They perform the appropriate operations for the monolithic
+ *	  driver.
  *
  *  Arguments:
- *      None.
+ *	  None.
  *
  *  Returns:
- *      None.
+ *	  None.
  * ---------------------------------------------------------------------------
  */
 int __init
 uf_sdio_load(void)
 {
-    CsrResult csrResult;
+	CsrResult csrResult;
 
-    csrResult = CsrSdioFunctionDriverRegister(&unifi_sdioFunction_drv);
-    if (csrResult != CSR_RESULT_SUCCESS) {
-        unifi_error(NULL, "Failed to register UniFi SDIO driver: csrResult=%d\n", csrResult);
-        return -EIO;
-    }
+	csrResult = CsrSdioFunctionDriverRegister(&unifi_sdioFunction_drv);
+	if (csrResult != CSR_RESULT_SUCCESS) {
+		unifi_error(NULL, "Failed to register UniFi SDIO driver: csrResult=%d\n", csrResult);
+		return -EIO;
+	}
 
-    return 0;
+	return 0;
 } /* uf_sdio_load() */
 
 
@@ -1142,6 +1142,6 @@ uf_sdio_load(void)
 void __exit
 uf_sdio_unload(void)
 {
-    CsrSdioFunctionDriverUnregister(&unifi_sdioFunction_drv);
+	CsrSdioFunctionDriverUnregister(&unifi_sdioFunction_drv);
 } /* uf_sdio_unload() */
 
-- 
1.7.9.5

