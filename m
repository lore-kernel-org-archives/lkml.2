Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1CGIZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:25:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1CGIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rcyb68B3O8igHPVZ8o9HoNelkDKxnMclHpzpLN65qxz7eDIIeE8yonnDuUb+ZTUhQw
         P0BPWNs7kdXTuc8wO05upCTDXgTfkqcHunaCq3YFz1VTXvLtMPMRM2/wbL3plDP1EaPq
         OzEApV4wfWbAW+hlKX8NxUpfblB2bo3ZFnT/0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 07/21] staging: ft1000: Fix coding style in init_ft1000_netdev function.
Date: Mon,  7 Mar 2011 09:21:12 +0100
Message-Id: <1299486086-7325-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  126 +++++++++++--------------
 1 files changed, 57 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index bf2c729..adf16c6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -712,7 +712,7 @@ static const struct net_device_ops ftnet_ops =
 //---------------------------------------------------------------------------
 u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 {
-    struct net_device *netdev;
+	struct net_device *netdev;
 	struct ft1000_info *pInfo = NULL;
 	struct dpram_blk *pdpram_blk;
 	int i, ret_val;
@@ -720,27 +720,23 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	char card_nr[2];
 	unsigned long gCardIndex = 0;
 
-    DEBUG("Enter init_ft1000_netdev...\n");
-
+	DEBUG("Enter init_ft1000_netdev...\n");
 
 	netdev = alloc_etherdev(sizeof(struct ft1000_info));
-    if (!netdev )
-    {
-        DEBUG("init_ft1000_netdev: can not allocate network device\n");
-	return -ENOMEM;
-    }
+	if (!netdev) {
+		DEBUG("init_ft1000_netdev: can not allocate network device\n");
+		return -ENOMEM;
+	}
 
 	pInfo = netdev_priv(netdev);
 
-    //DEBUG("init_ft1000_netdev: gFt1000Info=%x, netdev=%x, ft1000dev=%x\n", gFt1000Info, netdev, ft1000dev);
-
 	memset(pInfo, 0, sizeof(struct ft1000_info));
 
-    dev_alloc_name(netdev, netdev->name);
+	dev_alloc_name(netdev, netdev->name);
 
-        DEBUG("init_ft1000_netdev: network device name is %s\n", netdev->name);
+	DEBUG("init_ft1000_netdev: network device name is %s\n", netdev->name);
 
-	if ( strncmp(netdev->name,"eth", 3) == 0) {
+	if (strncmp(netdev->name, "eth", 3) == 0) {
 		card_nr[0] = netdev->name[3];
 		card_nr[1] = '\0';
 		ret_val = strict_strtoul(card_nr, 10, &gCardIndex);
@@ -749,89 +745,83 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 			goto err_net;
 		}
 
-            pInfo->CardNumber = gCardIndex;
-            DEBUG("card number = %d\n", pInfo->CardNumber);
-        }
-        else {
-            printk(KERN_ERR "ft1000: Invalid device name\n");
+		pInfo->CardNumber = gCardIndex;
+		DEBUG("card number = %d\n", pInfo->CardNumber);
+	} else {
+		printk(KERN_ERR "ft1000: Invalid device name\n");
 		ret_val = -ENXIO;
 		goto err_net;
-        }
+	}
 
-    memset(&pInfo->stats, 0, sizeof(struct net_device_stats) );
-
-   spin_lock_init(&pInfo->dpram_lock);
-    pInfo->pFt1000Dev = ft1000dev;
-    pInfo->DrvErrNum = 0;
-    pInfo->ASICResetNum = 0;
-    pInfo->registered = 1;
-    pInfo->ft1000_reset = ft1000_reset;
-    pInfo->mediastate = 0;
-    pInfo->fifo_cnt = 0;
-    pInfo->DeviceCreated = FALSE;
-    pInfo->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
-    pInfo->InterruptsEnabled = FALSE;
-    pInfo->CardReady = 0;
-    pInfo->DSP_TIME[0] = 0;
-    pInfo->DSP_TIME[1] = 0;
-    pInfo->DSP_TIME[2] = 0;
-    pInfo->DSP_TIME[3] = 0;
-    pInfo->fAppMsgPend = 0;
-    pInfo->fCondResetPend = 0;
+	memset(&pInfo->stats, 0, sizeof(struct net_device_stats));
+
+	spin_lock_init(&pInfo->dpram_lock);
+	pInfo->pFt1000Dev = ft1000dev;
+	pInfo->DrvErrNum = 0;
+	pInfo->ASICResetNum = 0;
+	pInfo->registered = 1;
+	pInfo->ft1000_reset = ft1000_reset;
+	pInfo->mediastate = 0;
+	pInfo->fifo_cnt = 0;
+	pInfo->DeviceCreated = FALSE;
+	pInfo->CurrentInterruptEnableMask = ISR_DEFAULT_MASK;
+	pInfo->InterruptsEnabled = FALSE;
+	pInfo->CardReady = 0;
+	pInfo->DSP_TIME[0] = 0;
+	pInfo->DSP_TIME[1] = 0;
+	pInfo->DSP_TIME[2] = 0;
+	pInfo->DSP_TIME[3] = 0;
+	pInfo->fAppMsgPend = 0;
+	pInfo->fCondResetPend = 0;
 	pInfo->usbboot = 0;
 	pInfo->dspalive = 0;
 	memset(&pInfo->tempbuf[0], 0, sizeof(pInfo->tempbuf));
 
-    INIT_LIST_HEAD(&pInfo->prov_list);
+	INIT_LIST_HEAD(&pInfo->prov_list);
 
 	INIT_LIST_HEAD(&pInfo->nodes.list);
-//mbelian
+
 #ifdef HAVE_NET_DEVICE_OPS
 	netdev->netdev_ops = &ftnet_ops;
 #else
-    netdev->hard_start_xmit = &ft1000_start_xmit;
-    netdev->get_stats = &ft1000_netdev_stats;
-    netdev->open = &ft1000_open;
-    netdev->stop = &ft1000_close;
+	netdev->hard_start_xmit = &ft1000_start_xmit;
+	netdev->get_stats = &ft1000_netdev_stats;
+	netdev->open = &ft1000_open;
+	netdev->stop = &ft1000_close;
 #endif
 
-    ft1000dev->net = netdev;
-
-
+	ft1000dev->net = netdev;
 
-//init free_buff_lock, freercvpool, numofmsgbuf, pdpram_blk
-//only init once per card
-//Jim
-    	  DEBUG("Initialize free_buff_lock and freercvpool\n");
-        spin_lock_init(&free_buff_lock);
+	DEBUG("Initialize free_buff_lock and freercvpool\n");
+	spin_lock_init(&free_buff_lock);
 
-        // initialize a list of buffers to be use for queuing up receive command data
-        INIT_LIST_HEAD (&freercvpool);
+	/* initialize a list of buffers to be use for queuing
+	 * up receive command data
+	 */
+	INIT_LIST_HEAD(&freercvpool);
 
-        // create list of free buffers
-        for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
-            // Get memory for DPRAM_DATA link list
+	/* create list of free buffers */
+	for (i = 0; i < NUM_OF_FREE_BUFFERS; i++) {
+		/* Get memory for DPRAM_DATA link list */
 		pdpram_blk = kmalloc(sizeof(struct dpram_blk), GFP_KERNEL);
 		if (pdpram_blk == NULL) {
 			ret_val = -ENOMEM;
 			goto err_free;
 		}
-            // Get a block of memory to store command data
-            pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
+		/* Get a block of memory to store command data */
+		pdpram_blk->pbuffer = kmalloc(MAX_CMD_SQSIZE, GFP_KERNEL);
 		if (pdpram_blk->pbuffer == NULL) {
 			ret_val = -ENOMEM;
 			kfree(pdpram_blk);
 			goto err_free;
 		}
-            // link provisioning data
-            list_add_tail (&pdpram_blk->list, &freercvpool);
-        }
-        numofmsgbuf = NUM_OF_FREE_BUFFERS;
-
+		/* link provisioning data */
+		list_add_tail(&pdpram_blk->list, &freercvpool);
+	}
+	numofmsgbuf = NUM_OF_FREE_BUFFERS;
 
 	return 0;
 
-
 err_free:
 	list_for_each_safe(cur, tmp, &freercvpool) {
 		pdpram_blk = list_entry(cur, struct dpram_blk, list);
@@ -844,8 +834,6 @@ err_net:
 	return ret_val;
 }
 
-
-
 //---------------------------------------------------------------------------
 // Function:    reg_ft1000_netdev
 //
-- 
1.7.1

