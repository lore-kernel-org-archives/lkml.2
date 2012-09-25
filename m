Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2IYGom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:44:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51968 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2IYGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:44:40 -0400
From: Ilya gorskin <revent82@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ilya gorskin <revent82@gmail.com>
Subject: [PATCH 5/5] Staging:bcm: fix coding style error in InterfacerTx.c
Date: Tue, 25 Sep 2012 12:44:35 +0600
Message-Id: <1348555475-26071-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the InterfaceTx.c file that
fixes up a coding style issues found by the checkpatch.pl tool

Signed-off-by: Ilya Gorskin <revent82@gmail.com>
---
 drivers/staging/bcm/InterfaceTx.c | 201 +++++++++++++++++++-------------------
 1 file changed, 103 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/InterfaceTx.c
index 7e2b53b..043f753 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -3,26 +3,26 @@
 /*this is transmit call-back(BULK OUT)*/
 static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 {
-	PUSB_TCB pTcb= (PUSB_TCB)urb->context;
+	PUSB_TCB pTcb = (PUSB_TCB)urb->context;
 	PS_INTERFACE_ADAPTER psIntfAdapter = pTcb->psIntfAdapter;
-	struct bcm_link_request *pControlMsg = (struct bcm_link_request *)urb->transfer_buffer;
-	struct bcm_mini_adapter *psAdapter = psIntfAdapter->psAdapter ;
+	struct bcm_link_request *pControlMsg =
+				(struct bcm_link_request *)urb->transfer_buffer;
+	struct bcm_mini_adapter *psAdapter = psIntfAdapter->psAdapter;
 	BOOLEAN bpowerDownMsg = FALSE ;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-    if (unlikely(netif_msg_tx_done(Adapter)))
-	    pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name, urb->status);
-
-	if(urb->status != STATUS_SUCCESS)
-	{
-		if(urb->status == -EPIPE)
-		{
-			psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
-			wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
-		}
-		else
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Tx URB has got cancelled. status :%d", urb->status);
+	if (unlikely(netif_msg_tx_done(Adapter)))
+		pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name,
+								urb->status);
+
+	if (urb->status != STATUS_SUCCESS) {
+		if (urb->status == -EPIPE) {
+			psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
+		wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+					DBG_LVL_ALL, "Tx URB has got cancelled.
+					status :%d", urb->status);
 		}
 	}
 
@@ -31,69 +31,72 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 
 
-	if(TRUE == psAdapter->bPreparingForLowPowerMode)
-	{
-
-		if(((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
-			(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE)))
+	if (TRUE == psAdapter->bPreparingForLowPowerMode) {
 
-		{
+		if (((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
+		(pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE))) {
 			bpowerDownMsg = TRUE ;
-			//This covers the bus err while Idle Request msg sent down.
-			if(urb->status != STATUS_SUCCESS)
-			{
+		/*This covers the bus err while Idle Request msg sent down.*/
+			if (urb->status != STATUS_SUCCESS) {
 				psAdapter->bPreparingForLowPowerMode = FALSE ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Idle Mode Request msg failed to reach to Modem");
-				//Signalling the cntrl pkt path in Ioctl
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+						DBG_LVL_ALL, "Idle Mode Request
+						msg failed to reach to Modem");
+				/*Signalling the cntrl pkt path in Ioctl*/
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
 				goto err_exit;
 			}
 
-			if(psAdapter->bDoSuspend == FALSE)
-			{
+			if (psAdapter->bDoSuspend == FALSE) {
 				psAdapter->IdleMode = TRUE;
-				//since going in Idle mode completed hence making this var false;
-				psAdapter->bPreparingForLowPowerMode = FALSE ;
-
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Host Entered in Idle Mode State...");
-				//Signalling the cntrl pkt path in Ioctl
+	/*since going in Idle mode completed hence making this var false;*/
+				psAdapter->bPreparingForLowPowerMode = FALSE;
+
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+						DBG_LVL_ALL,
+						"Host Entered in Idle Mode
+								State...");
+				/*Signalling the cntrl pkt path in Ioctl*/
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 
-		}
-		else if((pControlMsg->Leader.Status == LINK_UP_CONTROL_REQ) &&
+		} else if ((pControlMsg->Leader.Status ==
+					LINK_UP_CONTROL_REQ) &&
 			(pControlMsg->szData[0] == LINK_UP_ACK) &&
-			(pControlMsg->szData[1] == LINK_SHUTDOWN_REQ_FROM_FIRMWARE)  &&
-			(pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER))
-		{
-			//This covers the bus err while shutdown Request msg sent down.
-			if(urb->status != STATUS_SUCCESS)
-			{
-				psAdapter->bPreparingForLowPowerMode = FALSE ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Shutdown Request Msg failed to reach to Modem");
-				//Signalling the cntrl pkt path in Ioctl
+			(pControlMsg->szData[1] ==
+				LINK_SHUTDOWN_REQ_FROM_FIRMWARE)  &&
+			(pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER)) {
+	/*This covers the bus err while shutdown Request msg sent down.*/
+				if (urb->status != STATUS_SUCCESS) {
+				psAdapter->bPreparingForLowPowerMode = FALSE;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+						DBG_LVL_ALL, "Shutdown Request
+						Msg failed to reach to Modem");
+				/*Signalling the cntrl pkt path in Ioctl*/
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 				StartInterruptUrb(psIntfAdapter);
 				goto err_exit;
 			}
 
-			bpowerDownMsg = TRUE ;
-			if(psAdapter->bDoSuspend == FALSE)
-			{
+			bpowerDownMsg = TRUE;
+			if (psAdapter->bDoSuspend == FALSE) {
 				psAdapter->bShutStatus = TRUE;
-				//since going in shutdown mode completed hence making this var false;
-				psAdapter->bPreparingForLowPowerMode = FALSE ;
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Host Entered in shutdown Mode State...");
-				//Signalling the cntrl pkt path in Ioctl
+	/*since going in shutdown mode completed hence making this var false;*/
+				psAdapter->bPreparingForLowPowerMode = FALSE;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+						DBG_LVL_ALL, "Host Entered in
+						shutdown Mode State...");
+				/*Signalling the cntrl pkt path in Ioctl*/
 				wake_up(&psAdapter->lowpower_mode_wait_queue);
 			}
 		}
 
-		if(psAdapter->bDoSuspend && bpowerDownMsg)
-		{
-			//issuing bus suspend request
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"Issuing the Bus suspend request to USB stack");
+		if (psAdapter->bDoSuspend && bpowerDownMsg) {
+			/*issuing bus suspend request*/
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+					DBG_LVL_ALL, "Issuing the Bus suspend
+							request to USB stack");
 			psIntfAdapter->bPreparingForBusSuspend = TRUE;
 			schedule_work(&psIntfAdapter->usbSuspendWork);
 
@@ -101,9 +104,9 @@ static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
 
 	}
 
-err_exit :
+err_exit:
 	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
- 			urb->transfer_buffer, urb->transfer_dma);
+			urb->transfer_buffer, urb->transfer_dma);
 }
 
 
@@ -112,15 +115,16 @@ static PUSB_TCB GetBulkOutTcb(PS_INTERFACE_ADAPTER psIntfAdapter)
 	PUSB_TCB pTcb = NULL;
 	UINT index = 0;
 
-	if((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
-		(psIntfAdapter->psAdapter->StopAllXaction ==FALSE))
-	{
+	if ((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
+		(psIntfAdapter->psAdapter->StopAllXaction == FALSE)) {
 		index = atomic_read(&psIntfAdapter->uCurrTcb);
 		pTcb = &psIntfAdapter->asUsbTcb[index];
 		pTcb->bUsed = TRUE;
-		pTcb->psIntfAdapter= psIntfAdapter;
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Got Tx desc %d used %d",
-			index, atomic_read(&psIntfAdapter->uNumTcbUsed));
+		pTcb->psIntfAdapter = psIntfAdapter;
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX,
+				NEXT_SEND, DBG_LVL_ALL,
+				"Got Tx desc %d used %d", index,
+				atomic_read(&psIntfAdapter->uNumTcbUsed));
 		index = (index + 1) % MAXIMUM_USB_TCB;
 		atomic_set(&psIntfAdapter->uCurrTcb, index);
 		atomic_inc(&psIntfAdapter->uNumTcbUsed);
@@ -128,52 +132,53 @@ static PUSB_TCB GetBulkOutTcb(PS_INTERFACE_ADAPTER psIntfAdapter)
 	return pTcb;
 }
 
-static int TransmitTcb(PS_INTERFACE_ADAPTER psIntfAdapter, PUSB_TCB pTcb, PVOID data, int len)
+static int TransmitTcb(PS_INTERFACE_ADAPTER psIntfAdapter, PUSB_TCB pTcb,
+							PVOID data, int len)
 {
 
 	struct urb *urb = pTcb->urb;
 	int retval = 0;
 
 	urb->transfer_buffer = usb_alloc_coherent(psIntfAdapter->udev, len,
- 						GFP_ATOMIC, &urb->transfer_dma);
-	if (!urb->transfer_buffer)
-	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "Error allocating memory\n");
+						GFP_ATOMIC, &urb->transfer_dma);
+	if (!urb->transfer_buffer) {
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0,
+						"Error allocating memory\n");
 		return  -ENOMEM;
 	}
 	memcpy(urb->transfer_buffer, data, len);
 	urb->transfer_buffer_length = len;
 
-	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "Sending Bulk out packet\n");
-	//For T3B,INT OUT end point will be used as bulk out end point
-	if((psIntfAdapter->psAdapter->chip_id == T3B) && (psIntfAdapter->bHighSpeedDevice == TRUE))
-	{
+	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND,
+				DBG_LVL_ALL, "Sending Bulk out packet\n");
+	/*For T3B,INT OUT end point will be used as bulk out end point*/
+	if ((psIntfAdapter->psAdapter->chip_id == T3B) &&
+			(psIntfAdapter->bHighSpeedDevice == TRUE)) {
 		usb_fill_int_urb(urb, psIntfAdapter->udev,
-	    	psIntfAdapter->sBulkOut.bulk_out_pipe,
-			urb->transfer_buffer, len, write_bulk_callback, pTcb,
-			psIntfAdapter->sBulkOut.int_out_interval);
-	}
-	else
-	{
+				psIntfAdapter->sBulkOut.bulk_out_pipe,
+				urb->transfer_buffer, len, write_bulk_callback,
+				pTcb, psIntfAdapter->sBulkOut.int_out_interval);
+	} else {
 	usb_fill_bulk_urb(urb, psIntfAdapter->udev,
-		  psIntfAdapter->sBulkOut.bulk_out_pipe,
-		  urb->transfer_buffer, len, write_bulk_callback, pTcb);
+			psIntfAdapter->sBulkOut.bulk_out_pipe,
+			urb->transfer_buffer, len, write_bulk_callback, pTcb);
 	}
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP; /* For DMA transfer */
 
-	if(FALSE == psIntfAdapter->psAdapter->device_removed &&
-	   FALSE == psIntfAdapter->psAdapter->bEndPointHalted &&
-	   FALSE == psIntfAdapter->bSuspended &&
-	   FALSE == psIntfAdapter->bPreparingForBusSuspend)
-	{
+	if (FALSE == psIntfAdapter->psAdapter->device_removed &&
+	FALSE == psIntfAdapter->psAdapter->bEndPointHalted &&
+	FALSE == psIntfAdapter->bSuspended &&
+	FALSE == psIntfAdapter->bPreparingForBusSuspend) {
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
-		if (retval)
-		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
-			if(retval == -EPIPE)
-			{
-				psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
-				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
+		if (retval) {
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX,
+					NEXT_SEND, DBG_LVL_ALL,
+					"failed submitting write urb, error %d",
+					retval);
+			if (retval == -EPIPE) {
+				psIntfAdapter->psAdapter->bEndPointHalted =
+									TRUE ;
+		wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
 		}
 	}
@@ -182,13 +187,13 @@ static int TransmitTcb(PS_INTERFACE_ADAPTER psIntfAdapter, PUSB_TCB pTcb, PVOID
 
 int InterfaceTransmitPacket(PVOID arg, PVOID data, UINT len)
 {
-	PUSB_TCB pTcb= NULL;
+	PUSB_TCB pTcb = NULL;
 
 	PS_INTERFACE_ADAPTER psIntfAdapter = (PS_INTERFACE_ADAPTER)arg;
-	pTcb= GetBulkOutTcb(psIntfAdapter);
-	if(pTcb == NULL)
-	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "No URB to transmit packet, dropping packet");
+	pTcb = GetBulkOutTcb(psIntfAdapter);
+	if (pTcb == NULL) {
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0,
+				"No URB to transmit packet, dropping packet");
 		return -EFAULT;
 	}
 	return TransmitTcb(psIntfAdapter, pTcb, data, len);
-- 
1.7.12

