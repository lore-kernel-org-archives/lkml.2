Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2IXKo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:44:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44783 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2IXKoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:44:55 -0400
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH] Staging:bcm: fix coding style issue in Bcmchar.c
Date: Mon, 24 Sep 2012 16:44:43 +0600
Message-Id: <1348483483-32545-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the Bcmchar.c file that fixes up a coding style
warning found by the checkpatch.pl tool

Signed-off-by: Ilya Gorskin <revent82@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c | 985 +++++++++++++++++++++++++++++-------------
 1 file changed, 688 insertions(+), 297 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index cf411d1..4fbb660 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -13,7 +13,7 @@
 * Returns	  - Zero(Success)
 ****************************************************************/
 
-static int bcm_char_open(struct inode *inode, struct file * filp)
+static int bcm_char_open(struct inode *inode, struct file *filp)
 {
 	struct bcm_mini_adapter *Adapter = NULL;
 	struct bcm_tarang_data *pTarang = NULL;
@@ -104,7 +104,8 @@ static ssize_t bcm_char_read(struct file *filp, char __user *buf, size_t size,
 	int wait_ret_val = 0;
 	unsigned long ret = 0;
 
-	wait_ret_val = wait_event_interruptible(Adapter->process_read_wait_queue,
+	wait_ret_val = wait_event_interruptible(
+					Adapter->process_read_wait_queue,
 						(pTarang->RxAppControlHead ||
 						 Adapter->device_removed));
 	if ((wait_ret_val == -ERESTARTSYS)) {
@@ -163,7 +164,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	IOCTL_BUFFER IoBuffer;
 	int bytes;
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Parameters Passed to control IOCTL cmd=0x%X arg=0x%lX", cmd, arg);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+			"Parameters Passed to control IOCTL cmd=0x%X arg=0x%lX",
+			cmd, arg);
 
 	if (_IOC_TYPE(cmd) != BCM_IOCTL)
 		return -EFAULT;
@@ -215,7 +218,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(sRdmBuffer))
 			return -EINVAL;
 
-		if (copy_from_user(&sRdmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&sRdmBuffer, IoBuffer.InputBuffer,
+						IoBuffer.InputLength))
 			return -EFAULT;
 
 		if (IoBuffer.OutputLength > USHRT_MAX ||
@@ -235,7 +239,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				(PUINT)temp_buff, Bufflen);
 		if (bytes > 0) {
 			Status = STATUS_SUCCESS;
-			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, bytes)) {
+			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff,
+								bytes)) {
 				kfree(temp_buff);
 				return -EFAULT;
 			}
@@ -259,7 +264,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			return -EINVAL;
 
 		/* Get WrmBuffer structure */
-		if (copy_from_user(&sWrmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&sWrmBuffer, IoBuffer.InputBuffer,
+						IoBuffer.InputLength))
 			return -EFAULT;
 
 		uiTempVar = sWrmBuffer.Register & EEPROM_REJECT_MASK;
@@ -269,7 +275,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				(uiTempVar == EEPROM_REJECT_REG_3) ||
 				(uiTempVar == EEPROM_REJECT_REG_4))) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "EEPROM Access Denied, not in VSG Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"EEPROM Access Denied, not in VSG Mode\n");
 			return -EFAULT;
 		}
 
@@ -277,9 +284,11 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				(PUINT)sWrmBuffer.Data, sizeof(ULONG));
 
 		if (Status == STATUS_SUCCESS) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "WRM Done\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+						DBG_LVL_ALL, "WRM Done\n");
 		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "WRM Failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+						DBG_LVL_ALL, "WRM Failed\n");
 			Status = -EFAULT;
 		}
 		break;
@@ -294,7 +303,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device in Idle Mode, Blocking Rdms\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Device in Idle Mode, Blocking Rdms\n");
 			return -EACCES;
 		}
 
@@ -305,7 +315,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(sRdmBuffer))
 			return -EINVAL;
 
-		if (copy_from_user(&sRdmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&sRdmBuffer, IoBuffer.InputBuffer,
+						IoBuffer.InputLength))
 			return -EFAULT;
 
 		if (IoBuffer.OutputLength > USHRT_MAX ||
@@ -320,7 +331,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if ((((ULONG)sRdmBuffer.Register & 0x0F000000) != 0x0F000000) ||
 			((ULONG)sRdmBuffer.Register & 0x3)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "RDM Done On invalid Address : %x Access Denied.\n",
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+			"RDM Done On invalid Address : %x Access Denied.\n",
 					(int)sRdmBuffer.Register);
 
 			kfree(temp_buff);
@@ -328,11 +340,13 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		}
 
 		uiTempVar = sRdmBuffer.Register & EEPROM_REJECT_MASK;
-		bytes = rdmaltWithLock(Adapter, (UINT)sRdmBuffer.Register, (PUINT)temp_buff, IoBuffer.OutputLength);
+		bytes = rdmaltWithLock(Adapter, (UINT)sRdmBuffer.Register,
+				(PUINT)temp_buff, IoBuffer.OutputLength);
 
 		if (bytes > 0) {
 			Status = STATUS_SUCCESS;
-			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, bytes)) {
+			if (copy_to_user(IoBuffer.OutputBuffer,
+						temp_buff, bytes)) {
 				kfree(temp_buff);
 				return -EFAULT;
 			}
@@ -351,7 +365,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device in Idle Mode, Blocking Wrms\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Device in Idle Mode, Blocking Wrms\n");
 			return -EACCES;
 		}
 
@@ -363,13 +378,16 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			return -EINVAL;
 
 		/* Get WrmBuffer structure */
-		if (copy_from_user(&sWrmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&sWrmBuffer, IoBuffer.InputBuffer,
+						IoBuffer.InputLength))
 			return -EFAULT;
 
 		if ((((ULONG)sWrmBuffer.Register & 0x0F000000) != 0x0F000000) ||
 			((ULONG)sWrmBuffer.Register & 0x3)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Done On invalid Address : %x Access Denied.\n", (int)sWrmBuffer.Register);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+			"WRM Done On invalid Address : %x Access Denied.\n",
+						(int)sWrmBuffer.Register);
 			return -EINVAL;
 		}
 
@@ -381,17 +399,21 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				(uiTempVar == EEPROM_REJECT_REG_4)) &&
 				(cmd == IOCTL_BCM_REGISTER_WRITE)) {
 
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "EEPROM Access Denied, not in VSG Mode\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"EEPROM Access Denied, not in VSG Mode\n");
 				return -EFAULT;
 		}
 
 		Status = wrmaltWithLock(Adapter, (UINT)sWrmBuffer.Register,
-					(PUINT)sWrmBuffer.Data, sWrmBuffer.Length);
+					(PUINT)sWrmBuffer.Data,
+					sWrmBuffer.Length);
 
 		if (Status == STATUS_SUCCESS) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG, DBG_LVL_ALL, "WRM Done\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG,
+						DBG_LVL_ALL, "WRM Done\n");
 		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "WRM Failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+						DBG_LVL_ALL, "WRM Failed\n");
 			Status = -EFAULT;
 		}
 		break;
@@ -407,7 +429,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "GPIO Can't be set/clear in Low power Mode");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+		DBG_LVL_ALL, "GPIO Can't be set/clear in Low power Mode");
 			return -EACCES;
 		}
 
@@ -417,7 +440,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(gpio_info))
 			return -EINVAL;
 
-		if (copy_from_user(&gpio_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&gpio_info, IoBuffer.InputBuffer,
+					IoBuffer.InputLength))
 			return -EFAULT;
 
 		uiBit  = gpio_info.uiGpioNumber;
@@ -425,7 +449,10 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		value = (1<<uiBit);
 
 		if (IsReqGpioIsLedInNVM(Adapter, value) == FALSE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Sorry, Requested GPIO<0x%X> is not correspond to LED !!!", value);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+			DBG_LVL_ALL,
+		"Sorry, Requested GPIO<0x%X> is not correspond to LED !!!",
+			value);
 			Status = -EINVAL;
 			break;
 		}
@@ -433,30 +460,40 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		/* Set - setting 1 */
 		if (uiOperation) {
 			/* Set the gpio output register */
-			Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_SET_REG, (PUINT)(&value), sizeof(UINT));
+			Status = wrmaltWithLock(Adapter,
+			BCM_GPIO_OUTPUT_SET_REG, (PUINT)(&value), sizeof(UINT));
 
 			if (Status == STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Set the GPIO bit\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+				OSAL_DBG, DBG_LVL_ALL, "Set the GPIO bit\n");
 			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Failed to set the %dth GPIO\n", uiBit);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+				OSAL_DBG, DBG_LVL_ALL,
+				"Failed to set the %dth GPIO\n", uiBit);
 				break;
 			}
 		} else {
 			/* Set the gpio output register */
-			Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_CLR_REG, (PUINT)(&value), sizeof(UINT));
+			Status = wrmaltWithLock(Adapter,
+			BCM_GPIO_OUTPUT_CLR_REG, (PUINT)(&value), sizeof(UINT));
 
 			if (Status == STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Set the GPIO bit\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+				OSAL_DBG, DBG_LVL_ALL, "Set the GPIO bit\n");
 			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Failed to clear the %dth GPIO\n", uiBit);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+				OSAL_DBG, DBG_LVL_ALL,
+				"Failed to clear the %dth GPIO\n", uiBit);
 				break;
 			}
 		}
 
-		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
+		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER,
+				(PUINT)ucResetValue, sizeof(UINT));
 		if (bytes < 0) {
 			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
 					"GPIO_MODE_REGISTER read failed");
 			break;
 		} else {
@@ -469,9 +506,11 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					(PUINT)ucResetValue, sizeof(UINT));
 
 		if (Status == STATUS_SUCCESS) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Set the GPIO to output Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "Set the GPIO to output Mode\n");
 		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Failed to put GPIO in Output Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+			DBG_LVL_ALL, "Failed to put GPIO in Output Mode\n");
 			break;
 		}
 	}
@@ -479,13 +518,15 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 	case BCM_LED_THREAD_STATE_CHANGE_REQ: {
 		USER_THREAD_REQ threadReq = {0};
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "User made LED thread InActive");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "User made LED thread InActive");
 
 		if ((Adapter->IdleMode == TRUE) ||
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "GPIO Can't be set/clear in Low power Mode");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+		DBG_LVL_ALL, "GPIO Can't be set/clear in Low power Mode");
 			Status = -EACCES;
 			break;
 		}
@@ -496,16 +537,23 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(threadReq))
 			return -EINVAL;
 
-		if (copy_from_user(&threadReq, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&threadReq, IoBuffer.InputBuffer,
+					IoBuffer.InputLength))
 			return -EFAULT;
 
-		/* if LED thread is running(Actively or Inactively) set it state to make inactive */
+		/* if LED thread is running(Actively or Inactively) set * */
+		/* it state to make inactive */
 		if (Adapter->LEDInfo.led_thread_running) {
-			if (threadReq.ThreadState == LED_THREAD_ACTIVATION_REQ) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Activating thread req");
+			if (threadReq.ThreadState ==
+					LED_THREAD_ACTIVATION_REQ) {
+
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+				OSAL_DBG, DBG_LVL_ALL, "Activating thread req");
 				Adapter->DriverState = LED_THREAD_ACTIVE;
 			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DeActivating Thread req.....");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						"DeActivating Thread req.....");
 				Adapter->DriverState = LED_THREAD_INACTIVE;
 			}
 
@@ -531,7 +579,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(gpio_info))
 			return -EINVAL;
 
-		if (copy_from_user(&gpio_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&gpio_info, IoBuffer.InputBuffer,
+						IoBuffer.InputLength))
 			return -EFAULT;
 
 		uiBit = gpio_info.uiGpioNumber;
@@ -542,7 +591,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 		if (bytes < 0) {
 			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "RDM Failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+							"RDM Failed\n");
 			return Status;
 		} else {
 			Status = STATUS_SUCCESS;
@@ -553,7 +603,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	case IOCTL_BCM_GPIO_MULTI_REQUEST: {
 		UCHAR ucResetValue[4];
 		GPIO_MULTI_INFO gpio_multi_info[MAX_IDX];
-		PGPIO_MULTI_INFO pgpio_multi_info = (PGPIO_MULTI_INFO)gpio_multi_info;
+		PGPIO_MULTI_INFO pgpio_multi_info =
+					(PGPIO_MULTI_INFO)gpio_multi_info;
 
 		memset(pgpio_multi_info, 0, MAX_IDX * sizeof(GPIO_MULTI_INFO));
 
@@ -568,13 +619,17 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(gpio_multi_info))
 			return -EINVAL;
 
-		if (copy_from_user(&gpio_multi_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&gpio_multi_info, IoBuffer.InputBuffer,
+							IoBuffer.InputLength))
 			return -EFAULT;
 
-		if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_info[WIMAX_IDX].uiGPIOMask) == FALSE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
-					pgpio_multi_info[WIMAX_IDX].uiGPIOMask, Adapter->gpioBitMap);
+		if (IsReqGpioIsLedInNVM(Adapter,
+			pgpio_multi_info[WIMAX_IDX].uiGPIOMask) == FALSE) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+								DBG_LVL_ALL,
+"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
+					pgpio_multi_info[WIMAX_IDX].uiGPIOMask,
+					Adapter->gpioBitMap);
 			Status = -EINVAL;
 			break;
 		}
@@ -583,52 +638,68 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if ((pgpio_multi_info[WIMAX_IDX].uiGPIOMask) &
 			(pgpio_multi_info[WIMAX_IDX].uiGPIOCommand)) {
 			/* Set 1's in GPIO OUTPUT REGISTER */
-			*(UINT *)ucResetValue =  pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
+			*(UINT *)ucResetValue =
+				pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
 				pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
 				pgpio_multi_info[WIMAX_IDX].uiGPIOValue;
 
 			if (*(UINT *) ucResetValue)
-				Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_SET_REG,
-							(PUINT)ucResetValue, sizeof(ULONG));
+				Status = wrmaltWithLock(Adapter,
+						BCM_GPIO_OUTPUT_SET_REG,
+							(PUINT)ucResetValue,
+								sizeof(ULONG));
 
 			if (Status != STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM to BCM_GPIO_OUTPUT_SET_REG Failed.");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"WRM to BCM_GPIO_OUTPUT_SET_REG Failed.");
 				return Status;
 			}
 
 			/* Clear to 0's in GPIO OUTPUT REGISTER */
-			*(UINT *)ucResetValue = (pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
-						pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
-						(~(pgpio_multi_info[WIMAX_IDX].uiGPIOValue)));
+			*(UINT *)ucResetValue = (
+					pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
+				pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
+				(~(pgpio_multi_info[WIMAX_IDX].uiGPIOValue)));
 
 			if (*(UINT *) ucResetValue)
-				Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_CLR_REG, (PUINT)ucResetValue, sizeof(ULONG));
+				Status = wrmaltWithLock(Adapter,
+						BCM_GPIO_OUTPUT_CLR_REG,
+						(PUINT)ucResetValue,
+						sizeof(ULONG));
 
 			if (Status != STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM to BCM_GPIO_OUTPUT_CLR_REG Failed.");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"WRM to BCM_GPIO_OUTPUT_CLR_REG Failed.");
 				return Status;
 			}
 		}
 
 		if (pgpio_multi_info[WIMAX_IDX].uiGPIOMask) {
-			bytes = rdmaltWithLock(Adapter, (UINT)GPIO_PIN_STATE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
+			bytes = rdmaltWithLock(Adapter,
+					(UINT)GPIO_PIN_STATE_REGISTER,
+					(PUINT)ucResetValue, sizeof(UINT));
 
 			if (bytes < 0) {
 				Status = bytes;
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "RDM to GPIO_PIN_STATE_REGISTER Failed.");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"RDM to GPIO_PIN_STATE_REGISTER Failed.");
 				return Status;
 			} else {
 				Status = STATUS_SUCCESS;
 			}
 
-			pgpio_multi_info[WIMAX_IDX].uiGPIOValue = (*(UINT *)ucResetValue &
-								pgpio_multi_info[WIMAX_IDX].uiGPIOMask);
+			pgpio_multi_info[WIMAX_IDX].uiGPIOValue =
+							(*(UINT *)ucResetValue &
+				pgpio_multi_info[WIMAX_IDX].uiGPIOMask);
 		}
 
-		Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_info, IoBuffer.OutputLength);
+		Status = copy_to_user(IoBuffer.OutputBuffer,
+				&gpio_multi_info, IoBuffer.OutputLength);
 		if (Status) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Failed while copying Content to IOBufer for user space err:%d", Status);
+					"Failed while copying Content
+					to IOBufer for user space err:%d",
+					Status);
 			return -EFAULT;
 		}
 	}
@@ -637,7 +708,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	case IOCTL_BCM_GPIO_MODE_REQUEST: {
 		UCHAR ucResetValue[4];
 		GPIO_MULTI_MODE gpio_multi_mode[MAX_IDX];
-		PGPIO_MULTI_MODE pgpio_multi_mode = (PGPIO_MULTI_MODE)gpio_multi_mode;
+		PGPIO_MULTI_MODE pgpio_multi_mode =
+			(PGPIO_MULTI_MODE)gpio_multi_mode;
 
 		if ((Adapter->IdleMode == TRUE) ||
 			(Adapter->bShutStatus == TRUE) ||
@@ -650,61 +722,79 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		if (IoBuffer.InputLength > sizeof(gpio_multi_mode))
 			return -EINVAL;
 
-		if (copy_from_user(&gpio_multi_mode, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		if (copy_from_user(&gpio_multi_mode, IoBuffer.InputBuffer,
+							IoBuffer.InputLength))
 			return -EFAULT;
 
-		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
+		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER,
+					(PUINT)ucResetValue, sizeof(UINT));
 
 		if (bytes < 0) {
 			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Read of GPIO_MODE_REGISTER failed");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Read of GPIO_MODE_REGISTER failed");
 			return Status;
 		} else {
 			Status = STATUS_SUCCESS;
 		}
 
 		/* Validating the request */
-		if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_mode[WIMAX_IDX].uiGPIOMask) == FALSE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
-					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask, Adapter->gpioBitMap);
+		if (IsReqGpioIsLedInNVM(Adapter,
+					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask)
+								== FALSE) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"Sorry, Requested GPIO<0x%X> is not
+					correspond to NVM LED bit map<0x%X>!!!",
+					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask,
+							Adapter->gpioBitMap);
 			Status = -EINVAL;
 			break;
 		}
 
 		if (pgpio_multi_mode[WIMAX_IDX].uiGPIOMask) {
 			/* write all OUT's (1's) */
-			*(UINT *) ucResetValue |= (pgpio_multi_mode[WIMAX_IDX].uiGPIOMode &
-						pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
+			*(UINT *) ucResetValue |=
+				(pgpio_multi_mode[WIMAX_IDX].uiGPIOMode &
+					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
 
 			/* write all IN's (0's) */
-			*(UINT *) ucResetValue &= ~((~pgpio_multi_mode[WIMAX_IDX].uiGPIOMode) &
-						pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
+			*(UINT *) ucResetValue &=
+				~((~pgpio_multi_mode[WIMAX_IDX].uiGPIOMode) &
+					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
 
 			/* Currently implemented return the modes of all GPIO's
-			 * else needs to bit AND with  mask
-			 */
-			pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *(UINT *)ucResetValue;
+			* else needs to bit AND with  mask
+			*/
+			pgpio_multi_mode[WIMAX_IDX].uiGPIOMode =
+							*(UINT *)ucResetValue;
 
-			Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(ULONG));
+			Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER,
+					(PUINT)ucResetValue, sizeof(ULONG));
 			if (Status == STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-						"WRM to GPIO_MODE_REGISTER Done");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						"WRM to GPIO_MODE_REGISTER
+									Done");
 			} else {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-						"WRM to GPIO_MODE_REGISTER Failed");
+						"WRM to GPIO_MODE_REGISTER
+								Failed");
 				Status = -EFAULT;
 				break;
 			}
 		} else {
 /* if uiGPIOMask is 0 then return mode register configuration */
-			pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *(UINT *)ucResetValue;
+			pgpio_multi_mode[WIMAX_IDX].uiGPIOMode =
+							*(UINT *)ucResetValue;
 		}
 
-		Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_mode, IoBuffer.OutputLength);
+		Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_mode,
+							IoBuffer.OutputLength);
 		if (Status) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Failed while copying Content to IOBufer for user space err:%d", Status);
+					"Failed while copying Content to
+					IOBufer for user space err:%d", Status);
 			return -EFAULT;
 		}
 	}
@@ -729,20 +819,24 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			return -EINVAL;
 
 		pvBuffer = memdup_user(IoBuffer.InputBuffer,
-				       IoBuffer.InputLength);
+					IoBuffer.InputLength);
 		if (IS_ERR(pvBuffer))
 			return PTR_ERR(pvBuffer);
 
 		down(&Adapter->LowPowerModeSync);
-		Status = wait_event_interruptible_timeout(Adapter->lowpower_mode_wait_queue,
-							!Adapter->bPreparingForLowPowerMode,
-							(1 * HZ));
+		Status = wait_event_interruptible_timeout(
+					Adapter->lowpower_mode_wait_queue,
+					!Adapter->bPreparingForLowPowerMode,
+								(1 * HZ));
 		if (Status == -ERESTARTSYS)
 			goto cntrlEnd;
 
 		if (Adapter->bPreparingForLowPowerMode) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"Preparing Idle Mode is still True - Hence Rejecting control message\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+								DBG_LVL_ALL,
+					"Preparing Idle Mode is still
+					True - Hence Rejecting control
+					message\n");
 			Status = STATUS_FAILURE;
 			goto cntrlEnd;
 		}
@@ -756,13 +850,16 @@ cntrlEnd:
 
 	case IOCTL_BCM_BUFFER_DOWNLOAD_START: {
 		if (down_trylock(&Adapter->NVMRdmWrmLock)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"IOCTL_BCM_CHIP_RESET not allowed as EEPROM Read/Write is in progress\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+								DBG_LVL_ALL,
+					"IOCTL_BCM_CHIP_RESET not allowed as
+					EEPROM Read/Write is in progress\n");
 			return -EACCES;
 		}
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-				"Starting the firmware download PID =0x%x!!!!\n", current->pid);
+				"Starting the firmware download
+				PID =0x%x!!!!\n", current->pid);
 
 		if (down_trylock(&Adapter->fw_download_sema))
 			return -EBUSY;
@@ -775,7 +872,8 @@ cntrlEnd:
 		netif_stop_queue(Adapter->dev);
 		Status = reset_card_proc(Adapter);
 		if (Status) {
-			pr_err(PFX "%s: reset_card_proc Failed!\n", Adapter->dev->name);
+			pr_err(PFX "%s: reset_card_proc Failed!\n",
+						Adapter->dev->name);
 			up(&Adapter->fw_download_sema);
 			up(&Adapter->NVMRdmWrmLock);
 			return Status;
@@ -788,11 +886,14 @@ cntrlEnd:
 
 	case IOCTL_BCM_BUFFER_DOWNLOAD: {
 		struct bcm_firmware_info *psFwInfo = NULL;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Starting the firmware download PID =0x%x!!!!\n", current->pid);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Starting the firmware download
+				PID =0x%x!!!!\n", current->pid);
 
 		if (!down_trylock(&Adapter->fw_download_sema)) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Invalid way to download buffer. Use Start and then call this!!!\n");
+					"Invalid way to download buffer.
+					Use Start and then call this!!!\n");
 			up(&Adapter->fw_download_sema);
 			Status = -EINVAL;
 			return Status;
@@ -805,7 +906,8 @@ cntrlEnd:
 		}
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-				"Length for FW DLD is : %lx\n", IoBuffer.InputLength);
+				"Length for FW DLD is : %lx\n",
+						IoBuffer.InputLength);
 
 		if (IoBuffer.InputLength > sizeof(struct bcm_firmware_info)) {
 			up(&Adapter->fw_download_sema);
@@ -818,7 +920,8 @@ cntrlEnd:
 			return -ENOMEM;
 		}
 
-		if (copy_from_user(psFwInfo, IoBuffer.InputBuffer, IoBuffer.InputLength)) {
+		if (copy_from_user(psFwInfo, IoBuffer.InputBuffer,
+						IoBuffer.InputLength)) {
 			up(&Adapter->fw_download_sema);
 			return -EFAULT;
 		}
@@ -826,7 +929,8 @@ cntrlEnd:
 		if (!psFwInfo->pvMappedFirmwareAddress ||
 			(psFwInfo->u32FirmwareLength == 0)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Something else is wrong %lu\n",
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Something else is wrong %lu\n",
 					psFwInfo->u32FirmwareLength);
 			up(&Adapter->fw_download_sema);
 			Status = -EINVAL;
@@ -837,13 +941,18 @@ cntrlEnd:
 
 		if (Status != STATUS_SUCCESS) {
 			if (psFwInfo->u32StartingAddress == CONFIG_BEGIN_ADDR)
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "IOCTL: Configuration File Upload Failed\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"IOCTL: Configuration File
+							Upload Failed\n");
 			else
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,	"IOCTL: Firmware File Upload Failed\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"IOCTL: Firmware File Upload
+								Failed\n");
 
 			/* up(&Adapter->fw_download_sema); */
 
-			if (Adapter->LEDInfo.led_thread_running & BCM_LED_THREAD_RUNNING_ACTIVELY) {
+			if (Adapter->LEDInfo.led_thread_running &
+					BCM_LED_THREAD_RUNNING_ACTIVELY) {
 				Adapter->DriverState = DRIVER_INIT;
 				Adapter->LEDInfo.bLedInitDone = FALSE;
 				wake_up(&Adapter->LEDInfo.notify_led_event);
@@ -853,7 +962,8 @@ cntrlEnd:
 		if (Status != STATUS_SUCCESS)
 			up(&Adapter->fw_download_sema);
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG, DBG_LVL_ALL, "IOCTL: Firmware File Uploaded\n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG,
+				DBG_LVL_ALL, "IOCTL: Firmware File Uploaded\n");
 		kfree(psFwInfo);
 		return Status;
 	}
@@ -866,7 +976,8 @@ cntrlEnd:
 
 		if (down_trylock(&Adapter->NVMRdmWrmLock)) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"FW download blocked as EEPROM Read/Write is in progress\n");
+					"FW download blocked as EEPROM
+					Read/Write is in progress\n");
 			up(&Adapter->fw_download_sema);
 			return -EACCES;
 		}
@@ -881,7 +992,8 @@ cntrlEnd:
 		Status = run_card_proc(Adapter);
 
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Firm Download Failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Firm Download Failed\n");
 			up(&Adapter->fw_download_sema);
 			up(&Adapter->NVMRdmWrmLock);
 			return Status;
@@ -893,8 +1005,10 @@ cntrlEnd:
 		mdelay(10);
 
 		/* Wait for MailBox Interrupt */
-		if (StartInterruptUrb((PS_INTERFACE_ADAPTER)Adapter->pvInterfaceAdapter))
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Unable to send interrupt...\n");
+		if (StartInterruptUrb((PS_INTERFACE_ADAPTER)
+					Adapter->pvInterfaceAdapter))
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Unable to send interrupt...\n");
 
 		timeout = 5*HZ;
 		Adapter->waiting_to_fw_download_done = FALSE;
@@ -909,7 +1023,8 @@ cntrlEnd:
 		Adapter->LinkUpStatus = 0;
 		Adapter->LinkStatus = 0;
 
-		if (Adapter->LEDInfo.led_thread_running & BCM_LED_THREAD_RUNNING_ACTIVELY) {
+		if (Adapter->LEDInfo.led_thread_running &
+				BCM_LED_THREAD_RUNNING_ACTIVELY) {
 			Adapter->DriverState = FW_DOWNLOAD_DONE;
 			wake_up(&Adapter->LEDInfo.notify_led_event);
 		}
@@ -924,20 +1039,24 @@ cntrlEnd:
 
 	case IOCTL_BE_BUCKET_SIZE:
 		Status = 0;
-		if (get_user(Adapter->BEBucketSize, (unsigned long __user *)arg))
+		if (get_user(Adapter->BEBucketSize,
+					(unsigned long __user *)arg))
 			Status = -EFAULT;
 		break;
 
 	case IOCTL_RTPS_BUCKET_SIZE:
 		Status = 0;
-		if (get_user(Adapter->rtPSBucketSize, (unsigned long __user *)arg))
+		if (get_user(Adapter->rtPSBucketSize,
+					(unsigned long __user *)arg))
 			Status = -EFAULT;
 		break;
 
 	case IOCTL_CHIP_RESET: {
 		INT NVMAccess = down_trylock(&Adapter->NVMRdmWrmLock);
 		if (NVMAccess) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, " IOCTL_BCM_CHIP_RESET not allowed as EEPROM Read/Write is in progress\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					" IOCTL_BCM_CHIP_RESET not allowed as
+					EEPROM Read/Write is in progress\n");
 			return -EACCES;
 		}
 
@@ -954,7 +1073,8 @@ cntrlEnd:
 		USHORT uiLoopIndex;
 
 		Status = 0;
-		for (uiLoopIndex = 0; uiLoopIndex < NO_OF_QUEUES; uiLoopIndex++) {
+		for (uiLoopIndex = 0; uiLoopIndex < NO_OF_QUEUES;
+						uiLoopIndex++) {
 			if (get_user(Adapter->PackInfo[uiLoopIndex].uiThreshold,
 					(unsigned long __user *)arg)) {
 				Status = -EFAULT;
@@ -971,7 +1091,8 @@ cntrlEnd:
 		break;
 
 	case IOCTL_GET_PACK_INFO:
-		if (copy_to_user(argp, &Adapter->PackInfo, sizeof(struct bcm_packet_info)*NO_OF_QUEUES))
+		if (copy_to_user(argp, &Adapter->PackInfo,
+				sizeof(struct bcm_packet_info)*NO_OF_QUEUES))
 			return -EFAULT;
 		Status = STATUS_SUCCESS;
 		break;
@@ -983,11 +1104,18 @@ cntrlEnd:
 
 		if (uiData) {
 			/* Allow All Packets */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SWITCH_TRANSFER_MODE: ETH_PACKET_TUNNELING_MODE\n");
-				Adapter->TransferMode = ETH_PACKET_TUNNELING_MODE;
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"IOCTL_BCM_SWITCH_TRANSFER_MODE:
+					ETH_PACKET_TUNNELING_MODE\n");
+				Adapter->TransferMode =
+					ETH_PACKET_TUNNELING_MODE;
 		} else {
 			/* Allow IP only Packets */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SWITCH_TRANSFER_MODE: IP_PACKET_ONLY_MODE\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"IOCTL_BCM_SWITCH_TRANSFER_MODE:
+					IP_PACKET_ONLY_MODE\n");
 			Adapter->TransferMode = IP_PACKET_ONLY_MODE;
 		}
 		Status = STATUS_SUCCESS;
@@ -1001,9 +1129,11 @@ cntrlEnd:
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
 
-		len = min_t(ulong, IoBuffer.OutputLength, strlen(VER_FILEVERSION_STR) + 1);
+		len = min_t(ulong, IoBuffer.OutputLength,
+				strlen(VER_FILEVERSION_STR) + 1);
 
-		if (copy_to_user(IoBuffer.OutputBuffer, VER_FILEVERSION_STR, len))
+		if (copy_to_user(IoBuffer.OutputBuffer, VER_FILEVERSION_STR,
+									len))
 			return -EFAULT;
 		Status = STATUS_SUCCESS;
 		break;
@@ -1014,7 +1144,8 @@ cntrlEnd:
 
 		/* Copy Ioctl Buffer structure */
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER))) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "copy_from_user failed..\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"copy_from_user failed..\n");
 			return -EFAULT;
 		}
 
@@ -1028,8 +1159,11 @@ cntrlEnd:
 		link_state.bShutdownMode = Adapter->bShutStatus;
 		link_state.ucLinkStatus = Adapter->LinkStatus;
 
-		if (copy_to_user(IoBuffer.OutputBuffer, &link_state, min_t(size_t, sizeof(link_state), IoBuffer.OutputLength))) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy_to_user Failed..\n");
+		if (copy_to_user(IoBuffer.OutputBuffer, &link_state,
+				min_t(size_t, sizeof(link_state),
+					IoBuffer.OutputLength))) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Copy_to_user Failed..\n");
 			return -EFAULT;
 		}
 		Status = STATUS_SUCCESS;
@@ -1043,7 +1177,8 @@ cntrlEnd:
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
 
-		if (copy_from_user(&tracing_flag, IoBuffer.InputBuffer, sizeof(UINT)))
+		if (copy_from_user(&tracing_flag, IoBuffer.InputBuffer,
+								sizeof(UINT)))
 			return -EFAULT;
 
 		if (tracing_flag)
@@ -1061,15 +1196,20 @@ cntrlEnd:
 		if (IoBuffer.OutputLength < sizeof(stLocalSFAddIndicationAlt)) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
 					"Mismatch req: %lx needed is =0x%zx!!!",
-					IoBuffer.OutputLength, sizeof(stLocalSFAddIndicationAlt));
+					IoBuffer.OutputLength,
+					sizeof(stLocalSFAddIndicationAlt));
 			return -EINVAL;
 		}
 
-		if (copy_from_user(&ulSFId, IoBuffer.InputBuffer, sizeof(ulSFId)))
+		if (copy_from_user(&ulSFId, IoBuffer.InputBuffer,
+							sizeof(ulSFId)))
 			return -EFAULT;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Get DSX Data SF ID is =%lx\n", ulSFId);
-		get_dsx_sf_data_to_application(Adapter, ulSFId, IoBuffer.OutputBuffer);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "Get DSX Data SF ID is =%lx\n",
+								ulSFId);
+		get_dsx_sf_data_to_application(Adapter, ulSFId,
+						IoBuffer.OutputBuffer);
 		Status = STATUS_SUCCESS;
 	}
 	break;
@@ -1083,7 +1223,8 @@ cntrlEnd:
 		if (IoBuffer.OutputLength != sizeof(S_MIBS_HOST_STATS_MIBS)) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
 					"Length Check failed %lu %zd\n",
-					IoBuffer.OutputLength, sizeof(S_MIBS_HOST_STATS_MIBS));
+					IoBuffer.OutputLength,
+					sizeof(S_MIBS_HOST_STATS_MIBS));
 			return -EINVAL;
 		}
 
@@ -1096,7 +1237,8 @@ cntrlEnd:
 		GetDroppedAppCntrlPktMibs(temp_buff, pTarang);
 
 		if (Status != STATUS_FAILURE)
-			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, sizeof(S_MIBS_HOST_STATS_MIBS))) {
+			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff,
+					sizeof(S_MIBS_HOST_STATS_MIBS))) {
 				kfree(temp_buff);
 				return -EFAULT;
 			}
@@ -1106,7 +1248,8 @@ cntrlEnd:
 	}
 
 	case IOCTL_BCM_WAKE_UP_DEVICE_FROM_IDLE:
-		if ((FALSE == Adapter->bTriedToWakeUpFromlowPowerMode) && (TRUE == Adapter->IdleMode)) {
+		if ((FALSE == Adapter->bTriedToWakeUpFromlowPowerMode) &&
+						(TRUE == Adapter->IdleMode)) {
 			Adapter->usIdleModePattern = ABORT_IDLE_MODE;
 			Adapter->bWakeUpDevice = TRUE;
 			wake_up(&Adapter->process_rx_cntrlpkt);
@@ -1124,7 +1267,9 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "Device in Idle/Shutdown Mode, Blocking Wrms\n");
+			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Device in Idle/Shutdown Mode,
+							Blocking Wrms\n");
 			Status = -EACCES;
 			break;
 		}
@@ -1137,7 +1282,7 @@ cntrlEnd:
 			return -EINVAL;
 
 		pvBuffer = memdup_user(IoBuffer.InputBuffer,
-				       IoBuffer.InputLength);
+					IoBuffer.InputLength);
 		if (IS_ERR(pvBuffer))
 			return PTR_ERR(pvBuffer);
 
@@ -1146,7 +1291,10 @@ cntrlEnd:
 		if (((ULONG)pBulkBuffer->Register & 0x0F000000) != 0x0F000000 ||
 			((ULONG)pBulkBuffer->Register & 0x3)) {
 			kfree(pvBuffer);
-			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Done On invalid Address : %x Access Denied.\n", (int)pBulkBuffer->Register);
+			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"WRM Done On invalid Address : %x
+					Access Denied.\n",
+					(int)pBulkBuffer->Register);
 			Status = -EINVAL;
 			break;
 		}
@@ -1160,18 +1308,27 @@ cntrlEnd:
 			(cmd == IOCTL_BCM_REGISTER_WRITE)) {
 
 			kfree(pvBuffer);
-			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "EEPROM Access Denied, not in VSG Mode\n");
+			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"EEPROM Access Denied, not in
+								VSG Mode\n");
 			Status = -EFAULT;
 			break;
 		}
 
 		if (pBulkBuffer->SwapEndian == FALSE)
-			Status = wrmWithLock(Adapter, (UINT)pBulkBuffer->Register, (PCHAR)pBulkBuffer->Values, IoBuffer.InputLength - 2*sizeof(ULONG));
+			Status = wrmWithLock(Adapter,
+					(UINT)pBulkBuffer->Register,
+					(PCHAR)pBulkBuffer->Values,
+					IoBuffer.InputLength - 2*sizeof(ULONG));
 		else
-			Status = wrmaltWithLock(Adapter, (UINT)pBulkBuffer->Register, (PUINT)pBulkBuffer->Values, IoBuffer.InputLength - 2*sizeof(ULONG));
+			Status = wrmaltWithLock(Adapter,
+					(UINT)pBulkBuffer->Register,
+					(PUINT)pBulkBuffer->Values,
+					IoBuffer.InputLength - 2*sizeof(ULONG));
 
 		if (Status != STATUS_SUCCESS)
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+							"WRM Failed\n");
 
 		kfree(pvBuffer);
 		break;
@@ -1181,8 +1338,11 @@ cntrlEnd:
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
 
-		if (Adapter->eNVMType == NVM_EEPROM || Adapter->eNVMType == NVM_FLASH) {
-			if (copy_to_user(IoBuffer.OutputBuffer, &Adapter->uiNVMDSDSize, sizeof(UINT)))
+		if (Adapter->eNVMType == NVM_EEPROM || Adapter->eNVMType ==
+								NVM_FLASH) {
+			if (copy_to_user(IoBuffer.OutputBuffer,
+						&Adapter->uiNVMDSDSize,
+								sizeof(UINT)))
 				return -EFAULT;
 		}
 
@@ -1192,28 +1352,39 @@ cntrlEnd:
 	case IOCTL_BCM_CAL_INIT: {
 		UINT uiSectorSize = 0 ;
 		if (Adapter->eNVMType == NVM_FLASH) {
-			if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
+			if (copy_from_user(&IoBuffer, argp,
+						sizeof(IOCTL_BUFFER)))
 				return -EFAULT;
 
-			if (copy_from_user(&uiSectorSize, IoBuffer.InputBuffer, sizeof(UINT)))
+			if (copy_from_user(&uiSectorSize, IoBuffer.InputBuffer,
+								sizeof(UINT)))
 				return -EFAULT;
 
-			if ((uiSectorSize < MIN_SECTOR_SIZE) || (uiSectorSize > MAX_SECTOR_SIZE)) {
-				if (copy_to_user(IoBuffer.OutputBuffer, &Adapter->uiSectorSize,
+			if ((uiSectorSize < MIN_SECTOR_SIZE) || (uiSectorSize >
+							MAX_SECTOR_SIZE)) {
+				if (copy_to_user(IoBuffer.OutputBuffer,
+							&Adapter->uiSectorSize,
 							sizeof(UINT)))
 					return -EFAULT;
 			} else {
 				if (IsFlash2x(Adapter)) {
-					if (copy_to_user(IoBuffer.OutputBuffer,	&Adapter->uiSectorSize, sizeof(UINT)))
+					if (copy_to_user(IoBuffer.OutputBuffer,
+							&Adapter->uiSectorSize,
+								sizeof(UINT)))
 						return -EFAULT;
 				} else {
-					if ((TRUE == Adapter->bShutStatus) || (TRUE == Adapter->IdleMode)) {
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device is in Idle/Shutdown Mode\n");
+					if ((TRUE == Adapter->bShutStatus) ||
+						(TRUE == Adapter->IdleMode)) {
+						BCM_DEBUG_PRINT(Adapter,
+							DBG_TYPE_PRINTK,
+							0, 0, "Device is in
+							Idle/Shutdown Mode\n");
 						return -EACCES;
 					}
 
 					Adapter->uiSectorSize = uiSectorSize;
-					BcmUpdateSectorSize(Adapter, Adapter->uiSectorSize);
+					BcmUpdateSectorSize(Adapter,
+							Adapter->uiSectorSize);
 				}
 			}
 			Status = STATUS_SUCCESS;
@@ -1228,30 +1399,38 @@ cntrlEnd:
 	{
 		USER_BCM_DBG_STATE sUserDebugState;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "In SET_DEBUG ioctl\n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "In SET_DEBUG ioctl\n");
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
 
-		if (copy_from_user(&sUserDebugState, IoBuffer.InputBuffer, sizeof(USER_BCM_DBG_STATE)))
+		if (copy_from_user(&sUserDebugState, IoBuffer.InputBuffer,
+						sizeof(USER_BCM_DBG_STATE)))
 			return -EFAULT;
 
-		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "IOCTL_BCM_SET_DEBUG: OnOff=%d Type = 0x%x ",
+		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"IOCTL_BCM_SET_DEBUG: OnOff=%d Type = 0x%x ",
 				sUserDebugState.OnOff, sUserDebugState.Type);
 		/* sUserDebugState.Subtype <<= 1; */
 		sUserDebugState.Subtype = 1 << sUserDebugState.Subtype;
-		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "actual Subtype=0x%x\n", sUserDebugState.Subtype);
+		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"actual Subtype=0x%x\n",
+					sUserDebugState.Subtype);
 
 		/* Update new 'DebugState' in the Adapter */
 		Adapter->stDebugState.type |= sUserDebugState.Type;
 		/* Subtype: A bitmap of 32 bits for Subtype per Type.
-		 * Valid indexes in 'subtype' array: 1,2,4,8
-		 * corresponding to valid Type values. Hence we can use the 'Type' field
-		 * as the index value, ignoring the array entries 0,3,5,6,7 !
-		 */
+		* Valid indexes in 'subtype' array: 1,2,4,8
+		* corresponding to valid Type values. Hence we can use the
+		* 'Type' field
+		* as the index value, ignoring the array entries 0,3,5,6,7 !
+		*/
 		if (sUserDebugState.OnOff)
-			Adapter->stDebugState.subtype[sUserDebugState.Type] |= sUserDebugState.Subtype;
+			Adapter->stDebugState.subtype[sUserDebugState.Type] |=
+						sUserDebugState.Subtype;
 		else
-			Adapter->stDebugState.subtype[sUserDebugState.Type] &= ~sUserDebugState.Subtype;
+			Adapter->stDebugState.subtype[sUserDebugState.Type] &=
+						~sUserDebugState.Subtype;
 
 		BCM_SHOW_DEBUG_BITMAP(Adapter);
 	}
@@ -1266,8 +1445,12 @@ cntrlEnd:
 		struct timeval tv0, tv1;
 		memset(&tv0, 0, sizeof(struct timeval));
 		memset(&tv1, 0, sizeof(struct timeval));
-		if ((Adapter->eNVMType == NVM_FLASH) && (Adapter->uiFlashLayoutMajorVersion == 0)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "The Flash Control Section is Corrupted. Hence Rejection on NVM Read/Write\n");
+		if ((Adapter->eNVMType == NVM_FLASH) &&
+				(Adapter->uiFlashLayoutMajorVersion == 0)) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"The Flash Control Section is
+					Corrupted. Hence Rejection on
+							NVM Read/Write\n");
 			return -EFAULT;
 		}
 
@@ -1276,7 +1459,9 @@ cntrlEnd:
 				(Adapter->eActiveDSD != DSD1) &&
 				(Adapter->eActiveDSD != DSD2)) {
 
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "No DSD is active..hence NVM Command is blocked");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"No DSD is active..hence NVM
+							Command is blocked");
 				return STATUS_FAILURE;
 			}
 		}
@@ -1286,18 +1471,24 @@ cntrlEnd:
 			return -EFAULT;
 
 		if (copy_from_user(&stNVMReadWrite,
-					(IOCTL_BCM_NVM_READ == cmd) ? IoBuffer.OutputBuffer : IoBuffer.InputBuffer,
+					(IOCTL_BCM_NVM_READ == cmd) ?
+						IoBuffer.OutputBuffer :
+						IoBuffer.InputBuffer,
 					sizeof(NVM_READWRITE)))
 			return -EFAULT;
 
 		/*
-		 * Deny the access if the offset crosses the cal area limit.
-		 */
+		* Deny the access if the offset crosses the cal area limit.
+		*/
 		if (stNVMReadWrite.uiNumBytes > Adapter->uiNVMDSDSize)
 			return STATUS_FAILURE;
 
-		if (stNVMReadWrite.uiOffset > Adapter->uiNVMDSDSize - stNVMReadWrite.uiNumBytes) {
-			/* BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Can't allow access beyond NVM Size: 0x%x 0x%x\n", stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes); */
+		if (stNVMReadWrite.uiOffset > Adapter->uiNVMDSDSize -
+						stNVMReadWrite.uiNumBytes) {
+			/* BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK,
+			* 0, 0,"Can't allow access beyond NVM Size:
+			* 0x%x 0x%x\n", stNVMReadWrite.uiOffset,
+			* stNVMReadWrite.uiNumBytes); */
 			return STATUS_FAILURE;
 		}
 
@@ -1314,13 +1505,18 @@ cntrlEnd:
 				(Adapter->bShutStatus == TRUE) ||
 				(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						"Device is in Idle/Shutdown
+								Mode\n");
 				up(&Adapter->NVMRdmWrmLock);
 				kfree(pReadData);
 				return -EACCES;
 			}
 
-			Status = BeceemNVMRead(Adapter, (PUINT)pReadData, stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes);
+			Status = BeceemNVMRead(Adapter, (PUINT)pReadData,
+						stNVMReadWrite.uiOffset,
+						stNVMReadWrite.uiNumBytes);
 			up(&Adapter->NVMRdmWrmLock);
 
 			if (Status != STATUS_SUCCESS) {
@@ -1328,7 +1524,8 @@ cntrlEnd:
 				return Status;
 			}
 
-			if (copy_to_user(stNVMReadWrite.pBuffer, pReadData, stNVMReadWrite.uiNumBytes)) {
+			if (copy_to_user(stNVMReadWrite.pBuffer, pReadData,
+						stNVMReadWrite.uiNumBytes)) {
 				kfree(pReadData);
 				return -EFAULT;
 			}
@@ -1339,7 +1536,10 @@ cntrlEnd:
 				(Adapter->bShutStatus == TRUE) ||
 				(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						"Device is in Idle/Shutdown
+								Mode\n");
 				up(&Adapter->NVMRdmWrmLock);
 				kfree(pReadData);
 				return -EACCES;
@@ -1348,31 +1548,60 @@ cntrlEnd:
 			Adapter->bHeaderChangeAllowed = TRUE;
 			if (IsFlash2x(Adapter)) {
 				/*
-				 *			New Requirement:-
-				 *			DSD section updation will be allowed in two case:-
-				 *			1.  if DSD sig is present in DSD header means dongle is ok and updation is fruitfull
-				 *			2.  if point 1 failes then user buff should have DSD sig. this point ensures that if dongle is
-				 *			      corrupted then user space program first modify the DSD header with valid DSD sig so
-				 *			      that this as well as further write may be worthwhile.
-				 *
-				 *			 This restriction has been put assuming that if DSD sig is corrupted, DSD
-				 *			 data won't be considered valid.
-				 */
-
-				Status = BcmFlash2xCorruptSig(Adapter, Adapter->eActiveDSD);
+				* New Requirement:-
+				* DSD section updation will be
+				* allowed in two case:-
+				* 1.  if DSD sig is present in
+				* DSD header means dongle is
+				* ok and updation is fruitfull
+				* 2.  if point 1 failes then
+				* user buff should have DSD sig.
+				* this point ensures that if dongle is
+				* corrupted then user space program
+				* first modify the DSD header with
+				* valid DSD sig so
+				* that this as well as further
+				* write may be worthwhile.
+				*
+				* This restriction has been
+				* put assuming that if DSD
+				* sig is corrupted, DSD
+				* data won't be considered valid.
+				*/
+
+				Status = BcmFlash2xCorruptSig(Adapter,
+							Adapter->eActiveDSD);
 				if (Status != STATUS_SUCCESS) {
-					if (((stNVMReadWrite.uiOffset + stNVMReadWrite.uiNumBytes) != Adapter->uiNVMDSDSize) ||
-						(stNVMReadWrite.uiNumBytes < SIGNATURE_SIZE)) {
-
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DSD Sig is present neither in Flash nor User provided Input..");
+					if (((stNVMReadWrite.uiOffset +
+						stNVMReadWrite.uiNumBytes) !=
+						Adapter->uiNVMDSDSize) ||
+						(stNVMReadWrite.uiNumBytes <
+						SIGNATURE_SIZE)) {
+
+						BCM_DEBUG_PRINT(Adapter,
+							DBG_TYPE_OTHERS,
+							OSAL_DBG, DBG_LVL_ALL,
+							"DSD Sig is present
+							neither in Flash nor
+							User provided Input..");
 						up(&Adapter->NVMRdmWrmLock);
 						kfree(pReadData);
 						return Status;
 					}
 
-					ulDSDMagicNumInUsrBuff = ntohl(*(PUINT)(pReadData + stNVMReadWrite.uiNumBytes - SIGNATURE_SIZE));
-					if (ulDSDMagicNumInUsrBuff != DSD_IMAGE_MAGIC_NUMBER) {
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DSD Sig is present neither in Flash nor User provided Input..");
+					ulDSDMagicNumInUsrBuff = ntohl(*(PUINT)
+						(pReadData +
+						stNVMReadWrite.uiNumBytes -
+						SIGNATURE_SIZE));
+					if (ulDSDMagicNumInUsrBuff !=
+						DSD_IMAGE_MAGIC_NUMBER) {
+							BCM_DEBUG_PRINT(Adapter,
+							DBG_TYPE_OTHERS,
+							OSAL_DBG,
+							DBG_LVL_ALL,
+							"DSD Sig is present
+							neither in Flash nor
+							User provided Input..");
 						up(&Adapter->NVMRdmWrmLock);
 						kfree(pReadData);
 						return Status;
@@ -1380,9 +1609,13 @@ cntrlEnd:
 				}
 			}
 
-			Status = BeceemNVMWrite(Adapter, (PUINT)pReadData, stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes, stNVMReadWrite.bVerify);
+			Status = BeceemNVMWrite(Adapter, (PUINT)pReadData,
+					stNVMReadWrite.uiOffset,
+					stNVMReadWrite.uiNumBytes,
+					stNVMReadWrite.bVerify);
 			if (IsFlash2x(Adapter))
-				BcmFlash2xWriteSig(Adapter, Adapter->eActiveDSD);
+				BcmFlash2xWriteSig(Adapter,
+						Adapter->eActiveDSD);
 
 			Adapter->bHeaderChangeAllowed = FALSE;
 
@@ -1395,7 +1628,10 @@ cntrlEnd:
 		}
 
 		do_gettimeofday(&tv1);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " timetaken by Write/read :%ld msec\n", (tv1.tv_sec - tv0.tv_sec)*1000 + (tv1.tv_usec - tv0.tv_usec)/1000);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, " timetaken by Write/read :%ld
+				msec\n", (tv1.tv_sec - tv0.tv_sec)*1000 +
+				(tv1.tv_usec - tv0.tv_usec)/1000);
 
 		kfree(pReadData);
 		return STATUS_SUCCESS;
@@ -1411,24 +1647,37 @@ cntrlEnd:
 		void __user *OutPutBuff;
 
 		if (IsFlash2x(Adapter) != TRUE)	{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Flash Does not have 2.x map");
 			return -EINVAL;
 		}
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_READ Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_READ
+								Called");
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
 
 		/* Reading FLASH 2.x READ structure */
-		if (copy_from_user(&sFlash2xRead, IoBuffer.InputBuffer, sizeof(FLASH2X_READWRITE)))
-			return -EFAULT;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.Section :%x", sFlash2xRead.Section);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.offset :%x", sFlash2xRead.offset);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xRead.numOfBytes);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xRead.bVerify);
-
-		/* This was internal to driver for raw read. now it has ben exposed to user space app. */
+		if (copy_from_user(&sFlash2xRead, IoBuffer.InputBuffer,
+						sizeof(FLASH2X_READWRITE)))
+			return -EFAULT;
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.Section :%x",
+							sFlash2xRead.Section);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.offset :%x",
+							sFlash2xRead.offset);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x",
+						sFlash2xRead.numOfBytes);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n",
+							sFlash2xRead.bVerify);
+
+		/* This was internal to driver for raw read.
+		* now it has ben exposed to user space app. */
 		if (validateFlash2xReadWrite(Adapter, &sFlash2xRead) == FALSE)
 			return STATUS_FAILURE;
 
@@ -1443,7 +1692,9 @@ cntrlEnd:
 		pReadBuff = (PCHAR)kzalloc(BuffSize , GFP_KERNEL);
 
 		if (pReadBuff == NULL) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for Flash 2.x Read Structure");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Memory allocation failed for
+					Flash 2.x Read Structure");
 			return -ENOMEM;
 		}
 		down(&Adapter->NVMRdmWrmLock);
@@ -1452,7 +1703,9 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL, "Device is in
+						Idle/Shutdown Mode\n");
 			up(&Adapter->NVMRdmWrmLock);
 			kfree(pReadBuff);
 			return -EACCES;
@@ -1465,17 +1718,26 @@ cntrlEnd:
 				ReadBytes = NOB;
 
 			/* Reading the data from Flash 2.x */
-			Status = BcmFlash2xBulkRead(Adapter, (PUINT)pReadBuff, sFlash2xRead.Section, ReadOffset, ReadBytes);
+			Status = BcmFlash2xBulkRead(Adapter, (PUINT)pReadBuff,
+				sFlash2xRead.Section, ReadOffset, ReadBytes);
 			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Flash 2x read err with Status :%d", Status);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						"Flash 2x read err with
+							Status :%d", Status);
 				break;
 			}
 
-			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pReadBuff, ReadBytes);
+			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL, pReadBuff,
+								ReadBytes);
 
 			Status = copy_to_user(OutPutBuff, pReadBuff, ReadBytes);
 			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Copy to use failed with status :%d", Status);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						"Copy to use failed with
+						status :%d", Status);
 				up(&Adapter->NVMRdmWrmLock);
 				kfree(pReadBuff);
 				return -EFAULT;
@@ -1502,29 +1764,45 @@ cntrlEnd:
 		UINT WriteBytes = 0;
 
 		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Flash Does not have 2.x map");
 			return -EINVAL;
 		}
 
-		/* First make this False so that we can enable the Sector Permission Check in BeceemFlashBulkWrite */
+		/* First make this False so that we can enable the
+		* Sector Permission Check in BeceemFlashBulkWrite */
 		Adapter->bAllDSDWriteAllow = FALSE;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_WRITE Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"IOCTL_BCM_FLASH2X_SECTION_WRITE Called");
 
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
 
 		/* Reading FLASH 2.x READ structure */
-		if (copy_from_user(&sFlash2xWrite, IoBuffer.InputBuffer, sizeof(FLASH2X_READWRITE)))
-			return -EFAULT;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.Section :%x", sFlash2xWrite.Section);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.offset :%d", sFlash2xWrite.offset);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xWrite.numOfBytes);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xWrite.bVerify);
-
-		if ((sFlash2xWrite.Section != VSA0) && (sFlash2xWrite.Section != VSA1) && (sFlash2xWrite.Section != VSA2)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Only VSA write is allowed");
+		if (copy_from_user(&sFlash2xWrite, IoBuffer.InputBuffer,
+						sizeof(FLASH2X_READWRITE)))
+			return -EFAULT;
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.Section :%x",
+							sFlash2xWrite.Section);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.offset :%d",
+							sFlash2xWrite.offset);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x",
+						sFlash2xWrite.numOfBytes);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n",
+							sFlash2xWrite.bVerify);
+
+		if ((sFlash2xWrite.Section != VSA0) &&
+				(sFlash2xWrite.Section != VSA1) &&
+					(sFlash2xWrite.Section != VSA2)) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"Only VSA write is allowed");
 			return -EINVAL;
 		}
 
@@ -1548,7 +1826,8 @@ cntrlEnd:
 		/* extracting the remainder of the given offset. */
 		WriteBytes = Adapter->uiSectorSize;
 		if (WriteOffset % Adapter->uiSectorSize)
-			WriteBytes = Adapter->uiSectorSize - (WriteOffset % Adapter->uiSectorSize);
+			WriteBytes = Adapter->uiSectorSize -
+				(WriteOffset % Adapter->uiSectorSize);
 
 		if (NOB < WriteBytes)
 			WriteBytes = NOB;
@@ -1559,7 +1838,9 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL, "Device is in
+							Idle/Shutdown Mode\n");
 			up(&Adapter->NVMRdmWrmLock);
 			kfree(pWriteBuff);
 			return -EACCES;
@@ -1567,20 +1848,30 @@ cntrlEnd:
 
 		BcmFlash2xCorruptSig(Adapter, sFlash2xWrite.Section);
 		do {
-			Status = copy_from_user(pWriteBuff, InputAddr, WriteBytes);
+			Status = copy_from_user(pWriteBuff, InputAddr,
+								WriteBytes);
 			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy to user failed with status :%d", Status);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Copy to user failed with
+						status :%d", Status);
 				up(&Adapter->NVMRdmWrmLock);
 				kfree(pWriteBuff);
 				return -EFAULT;
 			}
-			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pWriteBuff, WriteBytes);
+			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL, pWriteBuff,
+								WriteBytes);
 
 			/* Writing the data from Flash 2.x */
-			Status = BcmFlash2xBulkWrite(Adapter, (PUINT)pWriteBuff, sFlash2xWrite.Section, WriteOffset, WriteBytes, sFlash2xWrite.bVerify);
+			Status = BcmFlash2xBulkWrite(Adapter,
+					(PUINT)pWriteBuff,
+					sFlash2xWrite.Section, WriteOffset,
+					WriteBytes, sFlash2xWrite.bVerify);
 
 			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash 2x read err with Status :%d", Status);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Flash 2x read err with
+						Status :%d", Status);
 				break;
 			}
 
@@ -1603,7 +1894,9 @@ cntrlEnd:
 
 	case IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP: {
 		PFLASH2X_BITMAP psFlash2xBitMap;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL,
+				"IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP Called");
 
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
@@ -1613,7 +1906,8 @@ cntrlEnd:
 
 		psFlash2xBitMap = kzalloc(sizeof(FLASH2X_BITMAP), GFP_KERNEL);
 		if (psFlash2xBitMap == NULL) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory is not available");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Memory is not available");
 			return -ENOMEM;
 		}
 
@@ -1624,7 +1918,9 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL, "Device is in
+						Idle/Shutdown Mode\n");
 			up(&Adapter->NVMRdmWrmLock);
 			kfree(psFlash2xBitMap);
 			return -EACCES;
@@ -1632,7 +1928,8 @@ cntrlEnd:
 
 		BcmGetFlash2xSectionalBitMap(Adapter, psFlash2xBitMap);
 		up(&Adapter->NVMRdmWrmLock);
-		if (copy_to_user(IoBuffer.OutputBuffer, psFlash2xBitMap, sizeof(FLASH2X_BITMAP))) {
+		if (copy_to_user(IoBuffer.OutputBuffer, psFlash2xBitMap,
+						sizeof(FLASH2X_BITMAP))) {
 			kfree(psFlash2xBitMap);
 			return -EFAULT;
 		}
@@ -1643,22 +1940,28 @@ cntrlEnd:
 
 	case IOCTL_BCM_SET_ACTIVE_SECTION: {
 		FLASH2X_SECTION_VAL eFlash2xSectionVal = 0;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SET_ACTIVE_SECTION Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "IOCTL_BCM_SET_ACTIVE_SECTION
+								Called");
 
 		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Flash Does not have 2.x map");
 			return -EINVAL;
 		}
 
 		Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy of IOCTL BUFFER failed");
 			return -EFAULT;
 		}
 
-		Status = copy_from_user(&eFlash2xSectionVal, IoBuffer.InputBuffer, sizeof(INT));
+		Status = copy_from_user(&eFlash2xSectionVal,
+					IoBuffer.InputBuffer, sizeof(INT));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy of flash section val failed");
 			return -EFAULT;
 		}
 
@@ -1668,14 +1971,18 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL, "Device is in
+						Idle/Shutdown Mode\n");
 			up(&Adapter->NVMRdmWrmLock);
 			return -EACCES;
 		}
 
 		Status = BcmSetActiveSection(Adapter, eFlash2xSectionVal);
 		if (Status)
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Failed to make it's priority Highest. Status %d", Status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Failed to make it's priority Highest.
+							Status %d", Status);
 
 		up(&Adapter->NVMRdmWrmLock);
 	}
@@ -1684,7 +1991,9 @@ cntrlEnd:
 	case IOCTL_BCM_IDENTIFY_ACTIVE_SECTION: {
 		/* Right Now we are taking care of only DSD */
 		Adapter->bAllDSDWriteAllow = FALSE;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_IDENTIFY_ACTIVE_SECTION called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "IOCTL_BCM_IDENTIFY_ACTIVE_SECTION
+								called");
 		Status = STATUS_SUCCESS;
 	}
 	break;
@@ -1692,43 +2001,66 @@ cntrlEnd:
 	case IOCTL_BCM_COPY_SECTION: {
 		FLASH2X_COPY_SECTION sCopySectStrut = {0};
 		Status = STATUS_SUCCESS;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_COPY_SECTION  Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "IOCTL_BCM_COPY_SECTION  Called");
 
 		Adapter->bAllDSDWriteAllow = FALSE;
 		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Flash Does not have 2.x map");
 			return -EINVAL;
 		}
 
 		Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed Status :%d", Status);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy of IOCTL BUFFER failed
+							Status :%d", Status);
 			return -EFAULT;
 		}
 
-		Status = copy_from_user(&sCopySectStrut, IoBuffer.InputBuffer, sizeof(FLASH2X_COPY_SECTION));
+		Status = copy_from_user(&sCopySectStrut, IoBuffer.InputBuffer,
+						sizeof(FLASH2X_COPY_SECTION));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of Copy_Section_Struct failed with Status :%d", Status);
-			return -EFAULT;
-		}
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Source SEction :%x", sCopySectStrut.SrcSection);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Destination SEction :%x", sCopySectStrut.DstSection);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "offset :%x", sCopySectStrut.offset);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "NOB :%x", sCopySectStrut.numOfBytes);
-
-		if (IsSectionExistInFlash(Adapter, sCopySectStrut.SrcSection) == FALSE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Source Section<%x> does not exixt in Flash ", sCopySectStrut.SrcSection);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy of Copy_Section_Struct failed
+						with Status :%d", Status);
+			return -EFAULT;
+		}
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "Source SEction :%x",
+					sCopySectStrut.SrcSection);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "Destination SEction :%x",
+					sCopySectStrut.DstSection);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "offset :%x",
+						sCopySectStrut.offset);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "NOB :%x",
+					sCopySectStrut.numOfBytes);
+
+		if (IsSectionExistInFlash(Adapter,
+					sCopySectStrut.SrcSection) == FALSE) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Source Section<%x> does not exixt in
+					Flash ", sCopySectStrut.SrcSection);
 			return -EINVAL;
 		}
 
-		if (IsSectionExistInFlash(Adapter, sCopySectStrut.DstSection) == FALSE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Destinatio Section<%x> does not exixt in Flash ", sCopySectStrut.DstSection);
+		if (IsSectionExistInFlash(Adapter,
+					sCopySectStrut.DstSection) == FALSE) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Destinatio Section<%x> does not exixt
+					in Flash ", sCopySectStrut.DstSection);
 			return -EINVAL;
 		}
 
 		if (sCopySectStrut.SrcSection == sCopySectStrut.DstSection) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Source and Destination section should be different");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL, "Source and Destination
+					section should be different");
 			return -EINVAL;
 		}
 
@@ -1738,19 +2070,26 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"Device is in Idle/Shutdown Mode\n");
 			up(&Adapter->NVMRdmWrmLock);
 			return -EACCES;
 		}
 
-		if (sCopySectStrut.SrcSection == ISO_IMAGE1 || sCopySectStrut.SrcSection == ISO_IMAGE2) {
+		if (sCopySectStrut.SrcSection == ISO_IMAGE1 ||
+				sCopySectStrut.SrcSection == ISO_IMAGE2) {
 			if (IsNonCDLessDevice(Adapter)) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device is Non-CDLess hence won't have ISO !!");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Device is Non-CDLess hence
+							won't have ISO !!");
 				Status = -EINVAL;
 			} else if (sCopySectStrut.numOfBytes == 0) {
 				Status = BcmCopyISO(Adapter, sCopySectStrut);
 			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Partial Copy of ISO section is not Allowed..");
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Partial Copy of ISO section
+							is not Allowed..");
 				Status = STATUS_FAILURE;
 			}
 			up(&Adapter->NVMRdmWrmLock);
@@ -1758,23 +2097,29 @@ cntrlEnd:
 		}
 
 		Status = BcmCopySection(Adapter, sCopySectStrut.SrcSection,
-					sCopySectStrut.DstSection, sCopySectStrut.offset, sCopySectStrut.numOfBytes);
+					sCopySectStrut.DstSection,
+					sCopySectStrut.offset,
+					sCopySectStrut.numOfBytes);
 		up(&Adapter->NVMRdmWrmLock);
 	}
 	break;
 
 	case IOCTL_BCM_GET_FLASH_CS_INFO: {
 		Status = STATUS_SUCCESS;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " IOCTL_BCM_GET_FLASH_CS_INFO Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, " IOCTL_BCM_GET_FLASH_CS_INFO
+								Called");
 
 		Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"Copy of IOCTL BUFFER failed");
 			return -EFAULT;
 		}
 
 		if (Adapter->eNVMType != NVM_FLASH) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Connected device does not have flash");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Connected device does not have flash");
 			Status = -EINVAL;
 			break;
 		}
@@ -1783,13 +2128,17 @@ cntrlEnd:
 			if (IoBuffer.OutputLength < sizeof(FLASH2X_CS_INFO))
 				return -EINVAL;
 
-			if (copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlash2xCSInfo, sizeof(FLASH2X_CS_INFO)))
+			if (copy_to_user(IoBuffer.OutputBuffer,
+						Adapter->psFlash2xCSInfo,
+						sizeof(FLASH2X_CS_INFO)))
 				return -EFAULT;
 		} else {
 			if (IoBuffer.OutputLength < sizeof(FLASH_CS_INFO))
 				return -EINVAL;
 
-			if (copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlashCSInfo, sizeof(FLASH_CS_INFO)))
+			if (copy_to_user(IoBuffer.OutputBuffer,
+						Adapter->psFlashCSInfo,
+						sizeof(FLASH_CS_INFO)))
 				return -EFAULT;
 		}
 	}
@@ -1799,36 +2148,49 @@ cntrlEnd:
 		UINT SectOfset = 0;
 		FLASH2X_SECTION_VAL eFlash2xSectionVal;
 		eFlash2xSectionVal = NO_SECTION_VAL;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SELECT_DSD Called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "IOCTL_BCM_SELECT_DSD Called");
 
 		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Flash Does not have 2.x map");
 			return -EINVAL;
 		}
 
 		Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy of IOCTL BUFFER failed");
 			return -EFAULT;
 		}
-		Status = copy_from_user(&eFlash2xSectionVal, IoBuffer.InputBuffer, sizeof(INT));
+		Status = copy_from_user(&eFlash2xSectionVal,
+				IoBuffer.InputBuffer, sizeof(INT));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy of flash section val failed");
 			return -EFAULT;
 		}
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Read Section :%d", eFlash2xSectionVal);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "Read Section :%d",
+						eFlash2xSectionVal);
 		if ((eFlash2xSectionVal != DSD0) &&
 			(eFlash2xSectionVal != DSD1) &&
 			(eFlash2xSectionVal != DSD2)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Passed section<%x> is not DSD section", eFlash2xSectionVal);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Passed section<%x> is not DSD section",
+							eFlash2xSectionVal);
 			return STATUS_FAILURE;
 		}
 
-		SectOfset = BcmGetSectionValStartOffset(Adapter, eFlash2xSectionVal);
+		SectOfset = BcmGetSectionValStartOffset(Adapter,
+							eFlash2xSectionVal);
 		if (SectOfset == INVALID_OFFSET) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Provided Section val <%d> does not exixt in Flash 2.x", eFlash2xSectionVal);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Provided Section val <%d> does not
+					exixt in Flash 2.x",
+							eFlash2xSectionVal);
 			return -EINVAL;
 		}
 
@@ -1849,17 +2211,20 @@ cntrlEnd:
 		void __user *OutPutBuff;
 
 		if (Adapter->eNVMType != NVM_FLASH) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NVM TYPE is not Flash");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"NVM TYPE is not Flash");
 			return -EINVAL;
 		}
 
 		/* Copy Ioctl Buffer structure */
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER))) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "copy_from_user 1 failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+						"copy_from_user 1 failed\n");
 			return -EFAULT;
 		}
 
-		if (copy_from_user(&stNVMRead, IoBuffer.OutputBuffer, sizeof(NVM_READWRITE)))
+		if (copy_from_user(&stNVMRead, IoBuffer.OutputBuffer,
+							sizeof(NVM_READWRITE)))
 			return -EFAULT;
 
 		NOB = stNVMRead.uiNumBytes;
@@ -1875,7 +2240,9 @@ cntrlEnd:
 
 		pReadBuff = kzalloc(BuffSize , GFP_KERNEL);
 		if (pReadBuff == NULL) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for Flash 2.x Read Structure");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Memory allocation failed for Flash
+							2.x Read Structure");
 			Status = -ENOMEM;
 			break;
 		}
@@ -1885,7 +2252,9 @@ cntrlEnd:
 			(Adapter->bShutStatus == TRUE) ||
 			(Adapter->bPreparingForLowPowerMode == TRUE)) {
 
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"Device is in Idle/Shutdown Mode\n");
 			kfree(pReadBuff);
 			up(&Adapter->NVMRdmWrmLock);
 			return -EACCES;
@@ -1900,17 +2269,24 @@ cntrlEnd:
 				ReadBytes = NOB;
 
 			/* Reading the data from Flash 2.x */
-			Status = BeceemNVMRead(Adapter, (PUINT)pReadBuff, ReadOffset, ReadBytes);
+			Status = BeceemNVMRead(Adapter, (PUINT)pReadBuff,
+							ReadOffset, ReadBytes);
 			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash 2x read err with Status :%d", Status);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Flash 2x read err with Status :%d",
+									Status);
 				break;
 			}
 
-			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pReadBuff, ReadBytes);
+			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS,
+						OSAL_DBG, DBG_LVL_ALL,
+						pReadBuff, ReadBytes);
 
 			Status = copy_to_user(OutPutBuff, pReadBuff, ReadBytes);
 			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy to use failed with status :%d", Status);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"Copy to use failed with status:%d",
+									Status);
 				up(&Adapter->NVMRdmWrmLock);
 				kfree(pReadBuff);
 				return -EFAULT;
@@ -1933,7 +2309,10 @@ cntrlEnd:
 		/* Copy Ioctl Buffer structure */
 		Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "copy of Ioctl buffer is failed from user space");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL,
+					"copy of Ioctl buffer is failed
+							from user space");
 			return -EFAULT;
 		}
 
@@ -1942,12 +2321,17 @@ cntrlEnd:
 			break;
 		}
 
-		Status = copy_from_user(&RxCntrlMsgBitMask, IoBuffer.InputBuffer, IoBuffer.InputLength);
+		Status = copy_from_user(&RxCntrlMsgBitMask,
+				IoBuffer.InputBuffer, IoBuffer.InputLength);
 		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "copy of control bit mask failed from user space");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+					DBG_LVL_ALL, "copy of control bit mask
+						failed from user space");
 			return -EFAULT;
 		}
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\n Got user defined cntrl msg bit mask :%lx", RxCntrlMsgBitMask);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"\n Got user defined cntrl msg bit mask :%lx",
+							RxCntrlMsgBitMask);
 		pTarang->RxCntrlMsgBitMask = RxCntrlMsgBitMask;
 	}
 	break;
@@ -1955,7 +2339,8 @@ cntrlEnd:
 	case IOCTL_BCM_GET_DEVICE_DRIVER_INFO: {
 		DEVICE_DRIVER_INFO DevInfo;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
 
 		DevInfo.MaxRDMBufferSize = BUFFER_4K;
 		DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
@@ -1969,7 +2354,8 @@ cntrlEnd:
 		if (IoBuffer.OutputLength < sizeof(DevInfo))
 			return -EINVAL;
 
-		if (copy_to_user(IoBuffer.OutputBuffer, &DevInfo, sizeof(DevInfo)))
+		if (copy_to_user(IoBuffer.OutputBuffer, &DevInfo,
+						sizeof(DevInfo)))
 			return -EFAULT;
 	}
 	break;
@@ -1977,7 +2363,8 @@ cntrlEnd:
 	case IOCTL_BCM_TIME_SINCE_NET_ENTRY: {
 		ST_TIME_ELAPSED stTimeElapsedSinceNetEntry = {0};
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_TIME_SINCE_NET_ENTRY called");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"IOCTL_BCM_TIME_SINCE_NET_ENTRY called");
 
 		if (copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			return -EFAULT;
@@ -1985,15 +2372,19 @@ cntrlEnd:
 		if (IoBuffer.OutputLength < sizeof(ST_TIME_ELAPSED))
 			return -EINVAL;
 
-		stTimeElapsedSinceNetEntry.ul64TimeElapsedSinceNetEntry = get_seconds() - Adapter->liTimeSinceLastNetEntry;
+		stTimeElapsedSinceNetEntry.ul64TimeElapsedSinceNetEntry =
+			get_seconds() - Adapter->liTimeSinceLastNetEntry;
 
-		if (copy_to_user(IoBuffer.OutputBuffer, &stTimeElapsedSinceNetEntry, sizeof(ST_TIME_ELAPSED)))
+		if (copy_to_user(IoBuffer.OutputBuffer,
+					&stTimeElapsedSinceNetEntry,
+						sizeof(ST_TIME_ELAPSED)))
 			return -EFAULT;
 	}
 	break;
 
 	case IOCTL_CLOSE_NOTIFICATION:
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_CLOSE_NOTIFICATION");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+						"IOCTL_CLOSE_NOTIFICATION");
 		break;
 
 	default:
-- 
1.7.12

