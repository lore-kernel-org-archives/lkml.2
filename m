Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1EJAj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 20:39:29 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:43023 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab1EJAj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 20:39:28 -0400
Date: Mon, 9 May 2011 17:39:30 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
X-X-Sender: sbhatewara@sbhatewara-dev1.eng.vmware.com
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
cc: pv-drivers@vmware.com
Subject: [PATCH net-next] vmxnet3: Use single tx queue when CONFIG_PCI_MSI
 not defined
Message-ID: <alpine.LRH.2.00.1105091715150.26660@sbhatewara-dev1.eng.vmware.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Limit number of Tx queues to 1 if MSI/MSI-X support is not configured in 
the kernel. This will make number of tx and rx queues equal when MSI/X is 
not configured thus providing better performance.

Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>

---

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 7a494f7..537e387 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2890,10 +2890,12 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #endif
 		num_rx_queues = 1;
 
+#ifdef CONFIG_PCI_MSI
 	if (enable_mq)
 		num_tx_queues = min(VMXNET3_DEVICE_MAX_TX_QUEUES,
 				    (int)num_online_cpus());
 	else
+#endif
 		num_tx_queues = 1;
 
 	netdev = alloc_etherdev_mq(sizeof(struct vmxnet3_adapter),
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 8ba7b5f..f50d36f 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -68,10 +68,10 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.0.25.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.1.9.0-k"
 
 /* a 32-bit int, each byte encode a verion number in VMXNET3_DRIVER_VERSION */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01001900
+#define VMXNET3_DRIVER_VERSION_NUM      0x01010900
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */
