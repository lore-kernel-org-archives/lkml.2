Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab1FQLgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:36:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46673 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1FQLf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:35:56 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p5HBZcUb009720, This message is released by code: ctaloc0852
From: <edwin_rong@realsil.com.cn>
To: <error27@gmail.com>, <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: edwin_rong <edwin_rong@realsil.com.cn>
Subject: [PATCH 1/3] Realtek cr: clean up unnecessary whitespaces.
Date: Fri, 17 Jun 2011 19:35:09 +0800
X-BOX-Message-Id: p5HBZcUb009720
Message-ID: <1308310511-5659-1-git-send-email-edwin_rong@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: edwin_rong <edwin_rong@realsil.com.cn>

Signed-off-by: edwin_rong <edwin_rong@realsil.com.cn>
---
 drivers/usb/storage/realtek_cr.c |  110 +++++++++++++++++++------------------
 1 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index d509a4a..0b6e30b 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -70,14 +70,14 @@ struct rts51x_status {
 };
 
 struct rts51x_chip {
-	u16			vendor_id;
-	u16			product_id;
-	char			max_lun;
+	u16 vendor_id;
+	u16 product_id;
+	char max_lun;
 
-	struct rts51x_status	*status;
-	int			status_len;
+	struct rts51x_status *status;
+	int status_len;
 
-	u32			flag;
+	u32	flag;
 };
 
 /* flag definition */
@@ -143,8 +143,9 @@ static int init_realtek_cr(struct us_data *us);
 
 static const struct usb_device_id realtek_cr_ids[] = {
 #	include "unusual_realtek.h"
-	{ }		/* Terminating entry */
+	{}			/* Terminating entry */
 };
+
 MODULE_DEVICE_TABLE(usb, realtek_cr_ids);
 
 #undef UNUSUAL_DEV
@@ -165,7 +166,7 @@ MODULE_DEVICE_TABLE(usb, realtek_cr_ids);
 
 static struct us_unusual_dev realtek_cr_unusual_dev_list[] = {
 #	include "unusual_realtek.h"
-	{ }		/* Terminating entry */
+	{}			/* Terminating entry */
 };
 
 #undef UNUSUAL_DEV
@@ -174,8 +175,8 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 				 u8 *cmd, int cmd_len, u8 *buf, int buf_len,
 				 enum dma_data_direction dir, int *act_len)
 {
-	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
+	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *)us->iobuf;
+	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *)us->iobuf;
 	int result;
 	unsigned int residue;
 	unsigned int cswlen;
@@ -195,7 +196,7 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	/* send it to out endpoint */
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
-				bcb, cbwlen, NULL);
+					    bcb, cbwlen, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -204,24 +205,23 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	if (buf && buf_len) {
 		unsigned int pipe = (dir == DMA_FROM_DEVICE) ?
-				us->recv_bulk_pipe : us->send_bulk_pipe;
+		    us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_transfer_buf(us, pipe,
-				buf, buf_len, NULL);
+						    buf, buf_len, NULL);
 		if (result == USB_STOR_XFER_ERROR)
 			return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	/* get CSW for device status */
 	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
-				bcs, US_BULK_CS_WRAP_LEN, &cswlen);
+					    bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	/* check bulk status */
 	if (bcs->Signature != cpu_to_le32(US_BULK_CS_SIGN)) {
 		US_DEBUGP("Signature mismatch: got %08X, expecting %08X\n",
-			  le32_to_cpu(bcs->Signature),
-			  US_BULK_CS_SIGN);
+			  le32_to_cpu(bcs->Signature), US_BULK_CS_SIGN);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -249,8 +249,8 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	case US_BULK_STAT_PHASE:
 		/* phase error -- note that a transport reset will be
-			* invoked by the invoke_transport() function
-			*/
+		 * invoked by the invoke_transport() function
+		 */
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -266,10 +266,10 @@ static int rts51x_get_max_lun(struct us_data *us)
 	/* issue the command */
 	us->iobuf[0] = 0;
 	result = usb_stor_control_msg(us, us->recv_ctrl_pipe,
-				 US_BULK_GET_MAX_LUN,
-				 USB_DIR_IN | USB_TYPE_CLASS |
-				 USB_RECIP_INTERFACE,
-				 0, us->ifnum, us->iobuf, 1, 10*HZ);
+				      US_BULK_GET_MAX_LUN,
+				      USB_DIR_IN | USB_TYPE_CLASS |
+				      USB_RECIP_INTERFACE,
+				      0, us->ifnum, us->iobuf, 1, 10 * HZ);
 
 	US_DEBUGP("GetMaxLUN command result is %d, data is %d\n",
 		  result, us->iobuf[0]);
@@ -284,16 +284,16 @@ static int rts51x_get_max_lun(struct us_data *us)
 static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 {
 	int retval;
-	u8 cmnd[12] = {0};
+	u8 cmnd[12] = { 0 };
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0D;
-	cmnd[2] = (u8)(addr >> 8);
-	cmnd[3] = (u8)addr;
-	cmnd[4] = (u8)(len >> 8);
-	cmnd[5] = (u8)len;
+	cmnd[2] = (u8) (addr >> 8);
+	cmnd[3] = (u8) addr;
+	cmnd[4] = (u8) (len >> 8);
+	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
 				       data, len, DMA_FROM_DEVICE, NULL);
@@ -306,16 +306,16 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 {
 	int retval;
-	u8 cmnd[12] = {0};
+	u8 cmnd[12] = { 0 };
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0E;
-	cmnd[2] = (u8)(addr >> 8);
-	cmnd[3] = (u8)addr;
-	cmnd[4] = (u8)(len >> 8);
-	cmnd[5] = (u8)len;
+	cmnd[2] = (u8) (addr >> 8);
+	cmnd[3] = (u8) addr;
+	cmnd[4] = (u8) (len >> 8);
+	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
 				       data, len, DMA_TO_DEVICE, NULL);
@@ -329,7 +329,7 @@ static int rts51x_read_status(struct us_data *us,
 			      u8 lun, u8 *status, int len, int *actlen)
 {
 	int retval;
-	u8 cmnd[12] = {0};
+	u8 cmnd[12] = { 0 };
 
 	US_DEBUGP("%s, lun = %d\n", __func__, lun);
 
@@ -356,12 +356,12 @@ static int rts51x_check_status(struct us_data *us, u8 lun)
 
 	US_DEBUGP("chip->status_len = %d\n", chip->status_len);
 
-	chip->status[lun].vid = ((u16)buf[0] << 8) | buf[1];
-	chip->status[lun].pid = ((u16)buf[2] << 8) | buf[3];
+	chip->status[lun].vid = ((u16) buf[0] << 8) | buf[1];
+	chip->status[lun].pid = ((u16) buf[2] << 8) | buf[3];
 	chip->status[lun].cur_lun = buf[4];
 	chip->status[lun].card_type = buf[5];
 	chip->status[lun].total_lun = buf[6];
-	chip->status[lun].fw_ver = ((u16)buf[7] << 8) | buf[8];
+	chip->status[lun].fw_ver = ((u16) buf[7] << 8) | buf[8];
 	chip->status[lun].phy_exist = buf[9];
 	chip->status[lun].multi_flag = buf[10];
 	chip->status[lun].multi_card = buf[11];
@@ -465,7 +465,7 @@ static int config_autodelink_after_power_on(struct us_data *us)
 			CLR_BIT(value, 2);
 
 		if (CHECK_ID(chip, 0x0159, 0x5889) ||
-				CHECK_ID(chip, 0x0138, 0x3880)) {
+		    CHECK_ID(chip, 0x0138, 0x3880)) {
 			CLR_BIT(value, 0);
 			CLR_BIT(value, 7);
 		}
@@ -528,14 +528,14 @@ static int config_autodelink_before_power_down(struct us_data *us)
 			return -EIO;
 	} else {
 		if (CHECK_ID(chip, 0x0159, 0x5889) ||
-				CHECK_ID(chip, 0x0138, 0x3880) ||
-				CHECK_ID(chip, 0x0138, 0x3882)) {
+		    CHECK_ID(chip, 0x0138, 0x3880) ||
+		    CHECK_ID(chip, 0x0138, 0x3882)) {
 			retval = rts51x_read_mem(us, 0xFE47, &value, 1);
 			if (retval < 0)
 				return -EIO;
 
 			if (CHECK_ID(chip, 0x0159, 0x5889) ||
-					CHECK_ID(chip, 0x0138, 0x3880)) {
+			    CHECK_ID(chip, 0x0138, 0x3880)) {
 				SET_BIT(value, 0);
 				SET_BIT(value, 7);
 			}
@@ -602,13 +602,13 @@ static int init_realtek_cr(struct us_data *us)
 		goto INIT_FAIL;
 
 	for (i = 0; i <= (int)(chip->max_lun); i++) {
-		retval = rts51x_check_status(us, (u8)i);
+		retval = rts51x_check_status(us, (u8) i);
 		if (retval < 0)
 			goto INIT_FAIL;
 	}
 
 	if (CHECK_FW_VER(chip, 0x5888) || CHECK_FW_VER(chip, 0x5889) ||
-			CHECK_FW_VER(chip, 0x5901))
+	    CHECK_FW_VER(chip, 0x5901))
 		SET_AUTO_DELINK(chip);
 	if (STATUS_LEN(chip) == 16) {
 		if (SUPPORT_AUTO_DELINK(chip))
@@ -632,7 +632,7 @@ INIT_FAIL:
 }
 
 static int realtek_cr_probe(struct usb_interface *intf,
-			 const struct usb_device_id *id)
+			    const struct usb_device_id *id)
 {
 	struct us_data *us;
 	int result;
@@ -640,25 +640,27 @@ static int realtek_cr_probe(struct usb_interface *intf,
 	US_DEBUGP("Probe Realtek Card Reader!\n");
 
 	result = usb_stor_probe1(&us, intf, id,
-			(id - realtek_cr_ids) + realtek_cr_unusual_dev_list);
+				 (id - realtek_cr_ids) +
+				 realtek_cr_unusual_dev_list);
 	if (result)
 		return result;
 
 	result = usb_stor_probe2(us);
+
 	return result;
 }
 
 static struct usb_driver realtek_cr_driver = {
-	.name =		"ums-realtek",
-	.probe =	realtek_cr_probe,
-	.disconnect =	usb_stor_disconnect,
-	.suspend =	usb_stor_suspend,
-	.resume =	usb_stor_resume,
-	.reset_resume =	usb_stor_reset_resume,
-	.pre_reset =	usb_stor_pre_reset,
-	.post_reset =	usb_stor_post_reset,
-	.id_table =	realtek_cr_ids,
-	.soft_unbind =	1,
+	.name = "ums-realtek",
+	.probe = realtek_cr_probe,
+	.disconnect = usb_stor_disconnect,
+	.suspend = usb_stor_suspend,
+	.resume = usb_stor_resume,
+	.reset_resume = usb_stor_reset_resume,
+	.pre_reset = usb_stor_pre_reset,
+	.post_reset = usb_stor_post_reset,
+	.id_table = realtek_cr_ids,
+	.soft_unbind = 1,
 };
 
 static int __init realtek_cr_init(void)
-- 
1.7.4.1

