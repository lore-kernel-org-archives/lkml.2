Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2IYEWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:22:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61973 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2IYEWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:22:12 -0400
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        dan.carpenter@oracle.com, marcos.mage@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH] Staging:bcm: fix coding style error in InterfaceDld.c and InterfaceIdleMode.c
Date: Tue, 25 Sep 2012 10:22:04 +0600
Message-Id: <1348546924-7021-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the InterfaceIdleMode.c, InterfaceDld.c files that
fixes up a coding style errors found by the checkpatch.pl tool

Signed-off-by: Ilya Gorskin <revent82@gmail.com>
---
 drivers/staging/bcm/InterfaceDld.c      |  16 +--
 drivers/staging/bcm/InterfaceIdleMode.c | 219 +++++++++++++-------------------
 2 files changed, 99 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index 3a89e33..1810d4a 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -35,9 +35,9 @@ int InterfaceFileDownload(PVOID arg, struct file *flp, unsigned int on_chip_loc)
 			break;
 		}
 		/* BCM_DEBUG_PRINT_BUFFER(Adapter,DBG_TYPE_INITEXIT, MP_INIT,
-		 *			  DBG_LVL_ALL, buff,
-		 *			  MAX_TRANSFER_CTRL_BYTE_USB);
-		 */
+		*				DBG_LVL_ALL, buff,
+		*				MAX_TRANSFER_CTRL_BYTE_USB);
+		*/
 		errno = InterfaceWRM(psIntfAdapter, on_chip_loc, buff, len);
 		if (errno) {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,
@@ -115,7 +115,7 @@ int InterfaceFileReadbackFromChip(PVOID arg, struct file *flp, unsigned int on_c
 			while (len) {
 				if (*(unsigned int *)&buff_readback[len] != *(unsigned int *)&buff[len]) {
 					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Firmware Download is not proper %d", fw_down);
-					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Val from Binary %x, Val From Read Back %x ", *(unsigned int *)&buff[len], *(unsigned int*)&buff_readback[len]);
+					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Val from Binary %x, Val From Read Back %x ", *(unsigned int *)&buff[len], *(unsigned int *)&buff_readback[len]);
 					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "len =%x!!!", len);
 					Status = -EIO;
 					goto exit;
@@ -218,7 +218,7 @@ static int bcm_compare_buff_contents(unsigned char *readbackbuff, unsigned char
 		while (len) {
 			if (*(unsigned int *)&readbackbuff[len] != *(unsigned int *)&buff[len]) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Firmware Download is not proper");
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Val from Binary %x, Val From Read Back %x ", *(unsigned int *)&buff[len], *(unsigned int*)&readbackbuff[len]);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "Val from Binary %x, Val From Read Back %x ", *(unsigned int *)&buff[len], *(unsigned int *)&readbackbuff[len]);
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "len =%x!!!", len);
 				retval = -EINVAL;
 				break;
@@ -235,9 +235,9 @@ int bcm_ioctl_fw_download(struct bcm_mini_adapter *Adapter, struct bcm_firmware_
 	PUCHAR buff = NULL;
 
 	/* Config File is needed for the Driver to download the Config file and
-	 * Firmware. Check for the Config file to be first to be sent from the
-	 * Application
-	 */
+	* Firmware. Check for the Config file to be first to be sent from the
+	* Application
+	*/
 	atomic_set(&Adapter->uiMBupdate, FALSE);
 	if (!Adapter->bCfgDownloaded && psFwInfo->u32StartingAddress != CONFIG_BEGIN_ADDR) {
 		/* Can't Download Firmware. */
diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index 4f2f490..de48630 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -42,161 +42,141 @@ send to f/w with in 200 ms after the Idle/Shutdown req issued
 */
 
 
-int InterfaceIdleModeRespond(struct bcm_mini_adapter *Adapter, unsigned int* puiBuffer)
+int InterfaceIdleModeRespond(struct bcm_mini_adapter *Adapter,
+							unsigned int *puiBuffer)
 {
 	int	status = STATUS_SUCCESS;
 	unsigned int	uiRegRead = 0;
 	int bytes;
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"SubType of Message :0x%X", ntohl(*puiBuffer));
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,
+				"SubType of Message :0x%X", ntohl(*puiBuffer));
 
-	if(ntohl(*puiBuffer) == GO_TO_IDLE_MODE_PAYLOAD)
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL," Got GO_TO_IDLE_MODE_PAYLOAD(210) Msg Subtype");
-		if(ntohl(*(puiBuffer+1)) == 0 )
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"Got IDLE MODE WAKE UP Response From F/W");
+	if (ntohl(*puiBuffer) == GO_TO_IDLE_MODE_PAYLOAD) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, " Got GO_TO_IDLE_MODE_PAYLOAD(210) Msg Subtype");
+		if (ntohl(*(puiBuffer+1)) == 0) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Got IDLE MODE WAKE UP Response From F/W");
 
-			status = wrmalt (Adapter,SW_ABORT_IDLEMODE_LOC, &uiRegRead, sizeof(uiRegRead));
-			if(status)
-			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "wrm failed while clearing Idle Mode Reg");
+			status = wrmalt (Adapter, SW_ABORT_IDLEMODE_LOC, &uiRegRead, sizeof(uiRegRead));
+			if (status) {
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm failed while clearing Idle Mode Reg");
 				return status;
 			}
 
-			if(Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING)
-			{
+			if (Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) {
 				uiRegRead = 0x00000000 ;
-				status = wrmalt (Adapter,DEBUG_INTERRUPT_GENERATOR_REGISTOR, &uiRegRead, sizeof(uiRegRead));
-				if(status)
-				{
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "wrm failed while clearing Idle Mode	Reg");
+				status = wrmalt (Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR, &uiRegRead, sizeof(uiRegRead));
+				if (status) {
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm failed while clearing Idle Mode	Reg");
 					return status;
 				}
 			}
-			//Below Register should not br read in case of Manual and Protocol Idle mode.
-			else if(Adapter->ulPowerSaveMode != DEVICE_POWERSAVE_MODE_AS_PROTOCOL_IDLE_MODE)
-			{
-				//clear on read Register
+			/*Below Register should not br read in case
+			* of Manual and Protocol Idle mode.*/
+			else if (Adapter->ulPowerSaveMode != DEVICE_POWERSAVE_MODE_AS_PROTOCOL_IDLE_MODE) {
+				/*clear on read Register*/
 				bytes = rdmalt(Adapter, DEVICE_INT_OUT_EP_REG0, &uiRegRead, sizeof(uiRegRead));
 				if (bytes < 0) {
 					status = bytes;
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "rdm failed while clearing H/W Abort Reg0");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "rdm failed while clearing H/W Abort Reg0");
 					return status;
 				}
-				//clear on read Register
+				/*clear on read Register*/
 				bytes = rdmalt(Adapter, DEVICE_INT_OUT_EP_REG1, &uiRegRead, sizeof(uiRegRead));
 				if (bytes < 0) {
 					status = bytes;
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "rdm failed while clearing H/W Abort	Reg1");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "rdm failed while clearing H/W Abort	Reg1");
 					return status;
 				}
 			}
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Device Up from Idle Mode");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Device Up from Idle Mode");
 
-			// Set Idle Mode Flag to False and Clear IdleMode reg.
+			/*Set Idle Mode Flag to False and Clear IdleMode reg.*/
 			Adapter->IdleMode = FALSE;
 			Adapter->bTriedToWakeUpFromlowPowerMode = FALSE;
 
 			wake_up(&Adapter->lowpower_mode_wait_queue);
 
-		}
-		else
-		{
-			if(TRUE == Adapter->IdleMode)
-			{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"Device is already in Idle mode....");
+		} else {
+			if (TRUE == Adapter->IdleMode) {
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Device is already in Idle mode....");
 				return status ;
 			}
 
 			uiRegRead = 0;
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Got Req from F/W to go in IDLE mode \n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Got Req from F/W to go in IDLE mode \n");
 
-			if (Adapter->chip_id== BCS220_2 ||
+			if (Adapter->chip_id == BCS220_2 ||
 				Adapter->chip_id == BCS220_2BC ||
-					Adapter->chip_id== BCS250_BC ||
-					Adapter->chip_id== BCS220_3)
-			{
+					Adapter->chip_id == BCS250_BC ||
+					Adapter->chip_id == BCS220_3) {
 
 				bytes = rdmalt(Adapter, HPM_CONFIG_MSW, &uiRegRead, sizeof(uiRegRead));
 				if (bytes < 0) {
 					status = bytes;
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "rdm failed while Reading HPM_CONFIG_LDO145 Reg 0\n");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "rdm failed while Reading HPM_CONFIG_LDO145 Reg 0\n");
 					return status;
 				}
 
 
 				uiRegRead |= (1<<17);
 
-				status = wrmalt (Adapter,HPM_CONFIG_MSW, &uiRegRead, sizeof(uiRegRead));
-				if(status)
-				{
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "wrm failed while clearing Idle Mode Reg\n");
+				status = wrmalt (Adapter, HPM_CONFIG_MSW, &uiRegRead, sizeof(uiRegRead));
+				if (status) {
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm failed while clearing Idle Mode Reg\n");
 					return status;
 				}
 
 			}
 			SendIdleModeResponse(Adapter);
 		}
-	}
-	else if(ntohl(*puiBuffer) == IDLE_MODE_SF_UPDATE_MSG)
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "OverRiding Service Flow Params");
-		OverrideServiceFlowParams(Adapter,puiBuffer);
+	} else if (ntohl(*puiBuffer) == IDLE_MODE_SF_UPDATE_MSG) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "OverRiding Service Flow Params");
+		OverrideServiceFlowParams(Adapter, puiBuffer);
 	}
 	return status;
 }
 
 static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter, unsigned int Pattern)
 {
-	int 	status = STATUS_SUCCESS;
+	int status = STATUS_SUCCESS;
 	unsigned int value;
 	unsigned int chip_id ;
-	unsigned long timeout = 0 ,itr = 0;
+	unsigned long timeout = 0, itr = 0;
 
-	int 	lenwritten = 0;
-	unsigned char aucAbortPattern[8]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
+	int lenwritten = 0;
+	unsigned char aucAbortPattern[8] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	PS_INTERFACE_ADAPTER psInterfaceAdapter = Adapter->pvInterfaceAdapter;
 
-	//Abort Bus suspend if its already suspended
-	if((TRUE == psInterfaceAdapter->bSuspended) && (TRUE == Adapter->bDoSuspend))
-	{
+	/*Abort Bus suspend if its already suspended*/
+	if ((TRUE == psInterfaceAdapter->bSuspended) && (TRUE == Adapter->bDoSuspend)) {
 		status = usb_autopm_get_interface(psInterfaceAdapter->interface);
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"Bus got wakeup..Aborting Idle mode... status:%d \n",status);
-
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Bus got wakeup..Aborting Idle mode... status:%d \n", status);
 	}
 
-	if((Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING)
-									||
-	   (Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_PROTOCOL_IDLE_MODE))
-	{
-		//write the SW abort pattern.
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Writing pattern<%d> to SW_ABORT_IDLEMODE_LOC\n", Pattern);
-		status = wrmalt(Adapter,SW_ABORT_IDLEMODE_LOC, &Pattern, sizeof(Pattern));
-		if(status)
-		{
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"WRM to Register SW_ABORT_IDLEMODE_LOC failed..");
+	if ((Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) || (Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_PROTOCOL_IDLE_MODE)) {
+		/*write the SW abort pattern.*/
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Writing pattern<%d> to SW_ABORT_IDLEMODE_LOC\n", Pattern);
+		status = wrmalt(Adapter, SW_ABORT_IDLEMODE_LOC, &Pattern, sizeof(Pattern));
+		if (status) {
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "WRM to Register SW_ABORT_IDLEMODE_LOC failed..");
 				return status;
 		}
 	}
 
-	if(Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING)
-	{
+	if (Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) {
 		value = 0x80000000;
-		status = wrmalt(Adapter,DEBUG_INTERRUPT_GENERATOR_REGISTOR, &value, sizeof(value));
-		if(status)
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Register failed");
+		status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR, &value, sizeof(value));
+		if (status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Register failed");
 			return status;
 		}
-	}
-	else if(Adapter->ulPowerSaveMode != DEVICE_POWERSAVE_MODE_AS_PROTOCOL_IDLE_MODE)
-	{
+	} else if (Adapter->ulPowerSaveMode != DEVICE_POWERSAVE_MODE_AS_PROTOCOL_IDLE_MODE) {
 		/*
-		 * Get a Interrupt Out URB and send 8 Bytes Down
-		 * To be Done in Thread Context.
-		 * Not using Asynchronous Mechanism.
-		 */
+		* Get a Interrupt Out URB and send 8 Bytes Down
+		* To be Done in Thread Context.
+		* Not using Asynchronous Mechanism.
+		*/
 		status = usb_interrupt_msg (psInterfaceAdapter->udev,
 			usb_sndintpipe(psInterfaceAdapter->udev,
 			psInterfaceAdapter->sIntrOut.int_out_endpointAddr),
@@ -204,43 +184,34 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter, unsigned int
 			8,
 			&lenwritten,
 			5000);
-		if(status)
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Sending Abort pattern down fails with status:%d..\n",status);
+		if (status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Sending Abort pattern down fails with status:%d..\n", status);
 			return status;
-		}
-		else
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "NOB Sent down :%d", lenwritten);
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "NOB Sent down :%d", lenwritten);
 		}
 
-		//mdelay(25);
+		/*mdelay(25);*/
 
-		timeout= jiffies +  msecs_to_jiffies(50) ;
-		while( timeout > jiffies )
-		{
+		timeout = jiffies +  msecs_to_jiffies(50) ;
+		while (timeout > jiffies) {
 			itr++ ;
 			rdmalt(Adapter, CHIP_ID_REG, &chip_id, sizeof(UINT));
-			if(0xbece3200==(chip_id&~(0xF0)))
-			{
+			if (0xbece3200 == (chip_id&~(0xF0))) {
 				chip_id = chip_id&~(0xF0);
 			}
-			if(chip_id == Adapter->chip_id)
+			if (chip_id == Adapter->chip_id)
 				break;
 		}
-		if(timeout < jiffies )
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"Not able to read chip-id even after 25 msec");
-		}
-		else
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"Number of completed iteration to read chip-id :%lu", itr);
+		if (timeout < jiffies) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Not able to read chip-id even after 25 msec");
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Number of completed iteration to read chip-id :%lu", itr);
 		}
 
-		status = wrmalt(Adapter,SW_ABORT_IDLEMODE_LOC, &Pattern, sizeof(status));
-		if(status)
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"WRM to Register SW_ABORT_IDLEMODE_LOC failed..");
+		status = wrmalt(Adapter, SW_ABORT_IDLEMODE_LOC, &Pattern, sizeof(status));
+		if (status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM to Register SW_ABORT_IDLEMODE_LOC failed..");
 			return status;
 		}
 	}
@@ -249,13 +220,10 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter, unsigned int
 int InterfaceIdleModeWakeup(struct bcm_mini_adapter *Adapter)
 {
 	ULONG	Status = 0;
-	if(Adapter->bTriedToWakeUpFromlowPowerMode)
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Wake up already attempted.. ignoring\n");
-	}
-	else
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL,"Writing Low Power Mode Abort pattern to the Device\n");
+	if (Adapter->bTriedToWakeUpFromlowPowerMode) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Wake up already attempted.. ignoring\n");
+	} else {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, IDLE_MODE, DBG_LVL_ALL, "Writing Low Power Mode Abort pattern to the Device\n");
 		Adapter->bTriedToWakeUpFromlowPowerMode = TRUE;
 		InterfaceAbortIdlemode(Adapter, Adapter->usIdleModePattern);
 
@@ -269,33 +237,28 @@ void InterfaceHandleShutdownModeWakeup(struct bcm_mini_adapter *Adapter)
 	INT Status = 0;
 	int bytes;
 
-	if(Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING)
-	{
-		// clear idlemode interrupt.
+	if (Adapter->ulPowerSaveMode == DEVICE_POWERSAVE_MODE_AS_MANUAL_CLOCK_GATING) {
+		/* clear idlemode interrupt.*/
 		uiRegVal = 0;
-		Status =wrmalt(Adapter,DEBUG_INTERRUPT_GENERATOR_REGISTOR, &uiRegVal, sizeof(uiRegVal));
-		if(Status)
-		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Failed with err :%d", Status);
+		Status = wrmalt(Adapter, DEBUG_INTERRUPT_GENERATOR_REGISTOR, &uiRegVal, sizeof(uiRegVal));
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM to DEBUG_INTERRUPT_GENERATOR_REGISTOR Failed with err :%d", Status);
 			return;
 		}
-	}
-
-    else
-	{
+	} else {
 
-        //clear Interrupt EP registers.
-		bytes = rdmalt(Adapter,DEVICE_INT_OUT_EP_REG0, &uiRegVal, sizeof(uiRegVal));
+		/*clear Interrupt EP registers.*/
+		bytes = rdmalt(Adapter, iDEVICE_INT_OUT_EP_REG0, &uiRegVal, sizeof(uiRegVal));
 		if (bytes < 0) {
 			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"RDM of DEVICE_INT_OUT_EP_REG0 failed with Err :%d", Status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "RDM of DEVICE_INT_OUT_EP_REG0 failed with Err :%d", Status);
 			return;
 		}
 
-		bytes = rdmalt(Adapter,DEVICE_INT_OUT_EP_REG1, &uiRegVal, sizeof(uiRegVal));
+		bytes = rdmalt(Adapter, DEVICE_INT_OUT_EP_REG1, &uiRegVal, sizeof(uiRegVal));
 		if (bytes < 0) {
 			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"RDM of DEVICE_INT_OUT_EP_REG1 failed with Err :%d", Status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "RDM of DEVICE_INT_OUT_EP_REG1 failed with Err :%d", Status);
 			return;
 		}
 	}
-- 
1.7.12

