Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3AHVMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:12:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3AHVIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605028"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 10/21] mei: rename remaining amthi strings to amthif
Date: Tue,  8 Jan 2013 23:07:21 +0200
Message-Id: <1357679252-12958-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the only real thing that left was mei_amthi_guid
the rest was in the strings and comments

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |   62 ++++++++++++++++++++++----------------------
 drivers/misc/mei/client.c  |    2 +-
 drivers/misc/mei/main.c    |    6 ++--
 drivers/misc/mei/mei_dev.h |    2 +-
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index adc4120..64a9bfa 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -38,9 +38,9 @@
 #include "hw-me.h"
 #include "client.h"
 
-const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
-						0xa8, 0x46, 0xe0, 0xff, 0x65,
-						0x81, 0x4c);
+const uuid_le mei_amthif_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d,
+					 0xac, 0xa8, 0x46, 0xe0,
+					 0xff, 0x65, 0x81, 0x4c);
 
 /**
  * mei_amthif_reset_params - initializes mei device iamthif
@@ -73,9 +73,9 @@ void mei_amthif_host_init(struct mei_device *dev)
 	mei_cl_init(&dev->iamthif_cl, dev);
 	dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
 
-	/* find ME amthi client */
+	/* find ME amthif client */
 	i = mei_cl_link_me(&dev->iamthif_cl,
-			    &mei_amthi_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
+			    &mei_amthif_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
 	if (i < 0) {
 		dev_info(&dev->pdev->dev, "failed to find iamthif client.\n");
 		return;
@@ -169,10 +169,10 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	i = mei_me_cl_by_id(dev, dev->iamthif_cl.me_client_id);
 
 	if (i < 0) {
-		dev_dbg(&dev->pdev->dev, "amthi client not found.\n");
+		dev_dbg(&dev->pdev->dev, "amthif client not found.\n");
 		return -ENODEV;
 	}
-	dev_dbg(&dev->pdev->dev, "checking amthi data\n");
+	dev_dbg(&dev->pdev->dev, "checking amthif data\n");
 	cb = mei_amthif_find_read_list_entry(dev, file);
 
 	/* Check for if we can block or not*/
@@ -180,7 +180,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		return -EAGAIN;
 
 
-	dev_dbg(&dev->pdev->dev, "waiting for amthi data\n");
+	dev_dbg(&dev->pdev->dev, "waiting for amthif data\n");
 	while (cb == NULL) {
 		/* unlock the Mutex */
 		mutex_unlock(&dev->device_lock);
@@ -198,17 +198,17 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	}
 
 
-	dev_dbg(&dev->pdev->dev, "Got amthi data\n");
+	dev_dbg(&dev->pdev->dev, "Got amthif data\n");
 	dev->iamthif_timer = 0;
 
 	if (cb) {
 		timeout = cb->read_time +
 			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
-		dev_dbg(&dev->pdev->dev, "amthi timeout = %lud\n",
+		dev_dbg(&dev->pdev->dev, "amthif timeout = %lud\n",
 				timeout);
 
 		if  (time_after(jiffies, timeout)) {
-			dev_dbg(&dev->pdev->dev, "amthi Time out\n");
+			dev_dbg(&dev->pdev->dev, "amthif Time out\n");
 			/* 15 sec for the message has expired */
 			list_del(&cb->list);
 			rets = -ETIMEDOUT;
@@ -228,9 +228,9 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		 * remove message from deletion list
 		 */
 
-	dev_dbg(&dev->pdev->dev, "amthi cb->response_buffer size - %d\n",
+	dev_dbg(&dev->pdev->dev, "amthif cb->response_buffer size - %d\n",
 	    cb->response_buffer.size);
-	dev_dbg(&dev->pdev->dev, "amthi cb->buf_idx - %lu\n", cb->buf_idx);
+	dev_dbg(&dev->pdev->dev, "amthif cb->buf_idx - %lu\n", cb->buf_idx);
 
 	/* length is being turncated to PAGE_SIZE, however,
 	 * the buf_idx may point beyond */
@@ -246,7 +246,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 		}
 	}
 free:
-	dev_dbg(&dev->pdev->dev, "free amthi cb memory.\n");
+	dev_dbg(&dev->pdev->dev, "free amthif cb memory.\n");
 	*offset = 0;
 	mei_io_cb_free(cb);
 out:
@@ -270,7 +270,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (!dev || !cb)
 		return -ENODEV;
 
-	dev_dbg(&dev->pdev->dev, "write data to amthi client.\n");
+	dev_dbg(&dev->pdev->dev, "write data to amthif client.\n");
 
 	dev->iamthif_state = MEI_IAMTHIF_WRITING;
 	dev->iamthif_current_cb = cb;
@@ -309,12 +309,12 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 				return -ENODEV;
 			dev->iamthif_flow_control_pending = true;
 			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
-			dev_dbg(&dev->pdev->dev, "add amthi cb to write waiting list\n");
+			dev_dbg(&dev->pdev->dev, "add amthif cb to write waiting list\n");
 			dev->iamthif_current_cb = cb;
 			dev->iamthif_file_object = cb->file_object;
 			list_add_tail(&cb->list, &dev->write_waiting_list.list);
 		} else {
-			dev_dbg(&dev->pdev->dev, "message does not complete, so add amthi cb to write list.\n");
+			dev_dbg(&dev->pdev->dev, "message does not complete, so add amthif cb to write list.\n");
 			list_add_tail(&cb->list, &dev->write_list.list);
 		}
 	} else {
@@ -383,7 +383,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 	dev->iamthif_timer = 0;
 	dev->iamthif_file_object = NULL;
 
-	dev_dbg(&dev->pdev->dev, "complete amthi cmd_list cb.\n");
+	dev_dbg(&dev->pdev->dev, "complete amthif cmd_list cb.\n");
 
 	list_for_each_entry_safe(pos, next, &dev->amthif_cmd_list.list, list) {
 		list_del(&pos->list);
@@ -392,7 +392,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 			status = mei_amthif_send_cmd(dev, pos);
 			if (status) {
 				dev_dbg(&dev->pdev->dev,
-					"amthi write failed status = %d\n",
+					"amthif write failed status = %d\n",
 						status);
 				return;
 			}
@@ -412,7 +412,7 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 	if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE &&
 		dev->iamthif_file_object == file) {
 		mask |= (POLLIN | POLLRDNORM);
-		dev_dbg(&dev->pdev->dev, "run next amthi cb\n");
+		dev_dbg(&dev->pdev->dev, "run next amthif cb\n");
 		mei_amthif_run_next_cmd(dev);
 	}
 	return mask;
@@ -478,7 +478,7 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 		dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
 		dev->iamthif_flow_control_pending = true;
 
-		/* save iamthif cb sent to amthi client */
+		/* save iamthif cb sent to amthif client */
 		cb->buf_idx = dev->iamthif_msg_buf_index;
 		dev->iamthif_current_cb = cb;
 
@@ -491,11 +491,11 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 
 /**
  * mei_amthif_irq_read_message - read routine after ISR to
- *			handle the read amthi message
+ *			handle the read amthif message
  *
  * @complete_list: An instance of our list structure
  * @dev: the device structure
- * @mei_hdr: header of amthi message
+ * @mei_hdr: header of amthif message
  *
  * returns 0 on success, <0 on failure.
  */
@@ -519,10 +519,10 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
 		return 0;
 
 	dev_dbg(&dev->pdev->dev,
-			"amthi_message_buffer_index =%d\n",
+			"amthif_message_buffer_index =%d\n",
 			mei_hdr->length);
 
-	dev_dbg(&dev->pdev->dev, "completed amthi read.\n ");
+	dev_dbg(&dev->pdev->dev, "completed amthif read.\n ");
 	if (!dev->iamthif_current_cb)
 		return -ENODEV;
 
@@ -537,8 +537,8 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
 	cb->read_time = jiffies;
 	if (dev->iamthif_ioctl && cb->cl == &dev->iamthif_cl) {
 		/* found the iamthif cb */
-		dev_dbg(&dev->pdev->dev, "complete the amthi read cb.\n ");
-		dev_dbg(&dev->pdev->dev, "add the amthi read cb to complete.\n ");
+		dev_dbg(&dev->pdev->dev, "complete the amthif read cb.\n ");
+		dev_dbg(&dev->pdev->dev, "add the amthif read cb to complete.\n ");
 		list_add_tail(&cb->list, &complete_list->list);
 	}
 	return 0;
@@ -590,7 +590,7 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
 				dev->iamthif_msg_buf,
 				dev->iamthif_msg_buf_index);
 		list_add_tail(&cb->list, &dev->amthif_rd_complete_list.list);
-		dev_dbg(&dev->pdev->dev, "amthi read completed\n");
+		dev_dbg(&dev->pdev->dev, "amthif read completed\n");
 		dev->iamthif_timer = jiffies;
 		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
 				dev->iamthif_timer);
@@ -598,7 +598,7 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
 		mei_amthif_run_next_cmd(dev);
 	}
 
-	dev_dbg(&dev->pdev->dev, "completing amthi call back.\n");
+	dev_dbg(&dev->pdev->dev, "completing amthif call back.\n");
 	wake_up_interruptible(&dev->iamthif_cl.wait);
 }
 
@@ -704,11 +704,11 @@ int mei_amthif_release(struct mei_device *dev, struct file *file)
 	if (dev->iamthif_file_object == file &&
 	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
 
-		dev_dbg(&dev->pdev->dev, "amthi canceled iamthif state %d\n",
+		dev_dbg(&dev->pdev->dev, "amthif canceled iamthif state %d\n",
 		    dev->iamthif_state);
 		dev->iamthif_canceled = true;
 		if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
-			dev_dbg(&dev->pdev->dev, "run next amthi iamthif cb\n");
+			dev_dbg(&dev->pdev->dev, "run next amthif iamthif cb\n");
 			mei_amthif_run_next_cmd(dev);
 		}
 	}
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 231eda2..8103d94 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -345,7 +345,7 @@ void mei_host_client_init(struct work_struct *work)
 	for (i = 0; i < dev->me_clients_num; i++) {
 		client_props = &dev->me_clients[i].props;
 
-		if (!uuid_le_cmp(client_props->protocol_name, mei_amthi_guid))
+		if (!uuid_le_cmp(client_props->protocol_name, mei_amthif_guid))
 			mei_amthif_host_init(dev);
 		else if (!uuid_le_cmp(client_props->protocol_name, mei_wd_guid))
 			mei_wd_host_init(dev);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 5c7c855..d5d1a59 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -497,7 +497,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 		if (rets) {
 			dev_err(&dev->pdev->dev,
-				"amthi write failed with status = %d\n", rets);
+				"amthif write failed with status = %d\n", rets);
 			goto err;
 		}
 		mutex_unlock(&dev->device_lock);
@@ -611,10 +611,10 @@ static int mei_ioctl_connect_client(struct file *file,
 	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
 			dev->me_clients[i].props.max_msg_length);
 
-	/* if we're connecting to amthi client then we will use the
+	/* if we're connecting to amthif client then we will use the
 	 * existing connection
 	 */
-	if (uuid_le_cmp(data->in_client_uuid, mei_amthi_guid) == 0) {
+	if (uuid_le_cmp(data->in_client_uuid, mei_amthif_guid) == 0) {
 		dev_dbg(&dev->pdev->dev, "FW Client is amthi\n");
 		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
 			rets = -ENODEV;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 681c0ee..285e8e0 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -46,7 +46,7 @@
 /*
  * AMTHI Client UUID
  */
-extern const uuid_le mei_amthi_guid;
+extern const uuid_le mei_amthif_guid;
 
 /*
  * Watchdog Client UUID
-- 
1.7.4.4

