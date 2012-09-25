Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2IYFEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:04:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43070 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2IYFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:04:35 -0400
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 2/3] Staging:bcm: fix coding style error in InterfaceIsr.c
Date: Tue, 25 Sep 2012 11:04:28 +0600
Message-Id: <1348549469-7222-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the InterfaceIsr.c file that
fixes up a coding style issues found by the checkpatch.pl tool

Signed-off-by: Ilya Gorskin <revent82@gmail.com>
---
 drivers/staging/bcm/InterfaceIsr.c | 178 +++++++++++++++++++++----------------
 1 file changed, 102 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
index 6ee3428..4f78451 100644
--- a/drivers/staging/bcm/InterfaceIsr.c
+++ b/drivers/staging/bcm/InterfaceIsr.c
@@ -11,101 +11,123 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 		pr_info(PFX "%s: interrupt status %d\n",
 			Adapter->dev->name, status);
 
-	if(Adapter->device_removed == TRUE)
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Device has Got Removed.");
+	if (Adapter->device_removed == TRUE) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
+				iDBG_LVL_ALL, "Device has Got Removed.");
 		return ;
 	}
 
-	if(((Adapter->bPreparingForLowPowerMode == TRUE) && (Adapter->bDoSuspend == TRUE)) ||
-		psIntfAdapter->bSuspended ||
-		psIntfAdapter->bPreparingForBusSuspend)
-	{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt call back is called while suspending the device");
+	if (((Adapter->bPreparingForLowPowerMode == TRUE) &&
+				(Adapter->bDoSuspend == TRUE)) ||
+				psIntfAdapter->bSuspended ||
+				psIntfAdapter->bPreparingForBusSuspend) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
+					DBG_LVL_ALL,
+					"Interrupt call back is called
+					while suspending the device");
 			return ;
 	}
 
-	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL, "interrupt urb status %d", status);
+	/*BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,
+	* "interrupt urb status %d", status);*/
 	switch (status) {
-	    /* success */
-	    case STATUS_SUCCESS:
-		if ( urb->actual_length )
-		{
-
-			if(psIntfAdapter->ulInterruptData[1] & 0xFF)
-			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "Got USIM interrupt");
+	/* success */
+	case STATUS_SUCCESS:
+		if (urb->actual_length) {
+
+			if (psIntfAdapter->ulInterruptData[1] & 0xFF) {
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						INTF_INIT, DBG_LVL_ALL,
+						"Got USIM interrupt");
 			}
 
-			if(psIntfAdapter->ulInterruptData[1] & 0xFF00)
-			{
+			if (psIntfAdapter->ulInterruptData[1] & 0xFF00) {
 				atomic_set(&Adapter->CurrNumFreeTxDesc,
-					(psIntfAdapter->ulInterruptData[1] & 0xFF00) >> 8);
-				atomic_set (&Adapter->uiMBupdate, TRUE);
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL, "TX mailbox contains %d",
-					atomic_read(&Adapter->CurrNumFreeTxDesc));
+					(psIntfAdapter->ulInterruptData[1] &
+								0xFF00) >> 8);
+				atomic_set(&Adapter->uiMBupdate, TRUE);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						INTF_INIT, DBG_LVL_ALL,
+						"TX mailbox contains %d",
+				atomic_read(&Adapter->CurrNumFreeTxDesc));
 			}
-			if(psIntfAdapter->ulInterruptData[1] >> 16)
-			{
-				Adapter->CurrNumRecvDescs=
-					(psIntfAdapter->ulInterruptData[1]  >> 16);
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"RX mailbox contains %d",
+			if (psIntfAdapter->ulInterruptData[1] >> 16) {
+				Adapter->CurrNumRecvDescs =
+				(psIntfAdapter->ulInterruptData[1] >> 16);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						INTF_INIT, DBG_LVL_ALL,
+						"RX mailbox contains %d",
 					Adapter->CurrNumRecvDescs);
 				InterfaceRx(psIntfAdapter);
 			}
-			if(Adapter->fw_download_done &&
+			if (Adapter->fw_download_done &&
 				!Adapter->downloadDDR &&
-				atomic_read(&Adapter->CurrNumFreeTxDesc))
-			{
-				psIntfAdapter->psAdapter->downloadDDR +=1;
+				atomic_read(&Adapter->CurrNumFreeTxDesc)) {
+				psIntfAdapter->psAdapter->downloadDDR += 1;
 				wake_up(&Adapter->tx_packet_wait_queue);
 			}
-			if(FALSE == Adapter->waiting_to_fw_download_done)
-			{
+			if (FALSE == Adapter->waiting_to_fw_download_done) {
 				Adapter->waiting_to_fw_download_done = TRUE;
 				wake_up(&Adapter->ioctl_fw_dnld_wait_queue);
 			}
-			if(!atomic_read(&Adapter->TxPktAvail))
-			{
+			if (!atomic_read(&Adapter->TxPktAvail)) {
 				atomic_set(&Adapter->TxPktAvail, 1);
 				wake_up(&Adapter->tx_packet_wait_queue);
 			}
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Firing interrupt in URB");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
+					DBG_LVL_ALL, "Firing interrupt in URB");
 		}
 		break;
-		case -ENOENT :
+	case -ENOENT:
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"URB has got disconnected ....");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
+					DBG_LVL_ALL,
+					"URB has got disconnected ....");
 			return ;
 		}
-		case -EINPROGRESS:
+	case -EINPROGRESS:
 		{
-			//This situation may happened when URBunlink is used. for detail check usb_unlink_urb documentation.
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Impossibe condition has occurred... something very bad is going on");
+			/*This situation may happened when URBunlink is used.
+			* for detail check usb_unlink_urb documentation.*/
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
+					DBG_LVL_ALL,
+					"Impossibe condition has occurred...
+					something very bad is going on");
 			break ;
-			//return;
+			/*return;*/
 		}
-		case -EPIPE:
+	case -EPIPE:
 		{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt IN endPoint  has got halted/stalled...need to clear this");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						INTF_INIT, DBG_LVL_ALL,
+						"Interrupt IN endPoint
+						has got halted/stalled...
+						need to clear this");
 				Adapter->bEndPointHalted = TRUE ;
 				wake_up(&Adapter->tx_packet_wait_queue);
 				urb->status = STATUS_SUCCESS ;
 				return;
 		}
-	    /* software-driven interface shutdown */
-	    case -ECONNRESET: //URB got unlinked.
-	    case -ESHUTDOWN:		// hardware gone. this is the serious problem.
-	    						//Occurs only when something happens with the host controller device
-	    case -ENODEV : //Device got removed
-		case -EINVAL : //Some thing very bad happened with the URB. No description is available.
-	    	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"interrupt urb error %d", status);
+		/* software-driven interface shutdown */
+	case -ECONNRESET: /*URB got unlinked.*/
+	case -ESHUTDOWN:	/* hardware gone. this is the serious problem.*/
+	/*Occurs only when something happens with the host controller device*/
+	case -ENODEV: /*Device got removed*/
+	case -EINVAL: /*Some thing very bad happened with the URB.
+			No description is available.*/
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
+				DBG_LVL_ALL, "interrupt urb error %d", status);
 			urb->status = STATUS_SUCCESS ;
 			break ;
-			//return;
-	    default:
-			//This is required to check what is the defaults conditions when it occurs..
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, DBG_LVL_ALL,"GOT DEFAULT INTERRUPT URB STATUS :%d..Please Analyze it...", status);
+			/*return;*/
+		default:
+			/*This is required to check what is the defaults
+			* conditions when it occurs..*/
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,
+					DBG_LVL_ALL,
+					"GOT DEFAULT INTERRUPT URB
+					STATUS :%d..Please Analyze it...",
+								status);
 		break;
 	}
 
@@ -117,27 +139,29 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
 int CreateInterruptUrb(PS_INTERFACE_ADAPTER psIntfAdapter)
 {
 	psIntfAdapter->psInterruptUrb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!psIntfAdapter->psInterruptUrb)
-	{
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Cannot allocate interrupt urb");
+	if (!psIntfAdapter->psInterruptUrb) {
+		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS,
+				INTF_INIT, DBG_LVL_ALL,
+				"Cannot allocate interrupt urb");
 		return -ENOMEM;
 	}
 	psIntfAdapter->psInterruptUrb->transfer_buffer =
-								psIntfAdapter->ulInterruptData;
+						psIntfAdapter->ulInterruptData;
 	psIntfAdapter->psInterruptUrb->transfer_buffer_length =
-							sizeof(psIntfAdapter->ulInterruptData);
+					sizeof(psIntfAdapter->ulInterruptData);
 
 	psIntfAdapter->sIntrIn.int_in_pipe = usb_rcvintpipe(psIntfAdapter->udev,
-						psIntfAdapter->sIntrIn.int_in_endpointAddr);
+	psIntfAdapter->sIntrIn.int_in_endpointAddr);
 
 	usb_fill_int_urb(psIntfAdapter->psInterruptUrb, psIntfAdapter->udev,
 					psIntfAdapter->sIntrIn.int_in_pipe,
-					psIntfAdapter->psInterruptUrb->transfer_buffer,
-					psIntfAdapter->psInterruptUrb->transfer_buffer_length,
+				psIntfAdapter->psInterruptUrb->transfer_buffer,
+			psIntfAdapter->psInterruptUrb->transfer_buffer_length,
 					read_int_callback, psIntfAdapter,
 					psIntfAdapter->sIntrIn.int_in_interval);
 
-	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt Interval: %d\n",
+	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, INTF_INIT,
+			DBG_LVL_ALL, "Interrupt Interval: %d\n",
 				psIntfAdapter->sIntrIn.int_in_interval);
 	return 0;
 }
@@ -147,20 +171,22 @@ INT StartInterruptUrb(PS_INTERFACE_ADAPTER psIntfAdapter)
 {
 	INT status = 0;
 
-	if( FALSE == psIntfAdapter->psAdapter->device_removed &&
+	if (FALSE == psIntfAdapter->psAdapter->device_removed &&
 		FALSE == psIntfAdapter->psAdapter->bEndPointHalted &&
 		FALSE == psIntfAdapter->bSuspended &&
 		FALSE == psIntfAdapter->bPreparingForBusSuspend &&
-		FALSE == psIntfAdapter->psAdapter->StopAllXaction)
-	{
-		status = usb_submit_urb(psIntfAdapter->psInterruptUrb, GFP_ATOMIC);
-		if (status)
-		{
-			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Cannot send int urb %d\n", status);
-			if(status == -EPIPE)
-			{
-				psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
-				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
+		FALSE == psIntfAdapter->psAdapter->StopAllXaction) {
+		status = usb_submit_urb(psIntfAdapter->psInterruptUrb,
+								GFP_ATOMIC);
+		if (status) {
+			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,
+					DBG_TYPE_OTHERS, INTF_INIT,
+					DBG_LVL_ALL,
+					"Cannot send int urb %d\n", status);
+			if (status == -EPIPE) {
+				psIntfAdapter->psAdapter->bEndPointHalted =
+									TRUE ;
+		wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
 		}
 	}
-- 
1.7.12

