Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2BXBkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:40:40 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62153 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2BXBjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.136.146 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 5/9] mei: remove indentation where else follows return
Date: Thu, 23 Feb 2012 20:38:52 -0500
Message-Id: <1330047536-3827-6-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

If a function returns early as the last statement of an if block, the
"else" is pretty much implied.

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |   58 ++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index b024270..ade5574 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -945,14 +945,13 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev, s32 *slots,
 			list_move_tail(&cb_pos->cb_list,
 				&cmpl_list->mei_cb.cb_list);
 			return -ENODEV;
-		} else {
-			if (mei_flow_ctrl_reduce(dev, cl))
-				return -ENODEV;
-			cl->status = 0;
-			cb_pos->information += mei_hdr->length;
-			list_move_tail(&cb_pos->cb_list,
-				&dev->write_waiting_list.mei_cb.cb_list);
 		}
+		if (mei_flow_ctrl_reduce(dev, cl))
+			return -ENODEV;
+		cl->status = 0;
+		cb_pos->information += mei_hdr->length;
+		list_move_tail(&cb_pos->cb_list,
+			&dev->write_waiting_list.mei_cb.cb_list);
 	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
 		/* buffer is still empty */
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
@@ -973,18 +972,17 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev, s32 *slots,
 			list_move_tail(&cb_pos->cb_list,
 				&cmpl_list->mei_cb.cb_list);
 			return -ENODEV;
-		} else {
-			cb_pos->information += mei_hdr->length;
-			dev_dbg(&dev->pdev->dev,
-					"cb_pos->request_buffer.size =%d"
-					" mei_hdr->msg_complete = %d\n",
-					cb_pos->request_buffer.size,
-					mei_hdr->msg_complete);
-			dev_dbg(&dev->pdev->dev, "cb_pos->information  =%lu\n",
-					cb_pos->information);
-			dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
-					mei_hdr->length);
 		}
+		cb_pos->information += mei_hdr->length;
+		dev_dbg(&dev->pdev->dev,
+				"cb_pos->request_buffer.size =%d"
+				" mei_hdr->msg_complete = %d\n",
+				cb_pos->request_buffer.size,
+				mei_hdr->msg_complete);
+		dev_dbg(&dev->pdev->dev, "cb_pos->information  =%lu\n",
+				cb_pos->information);
+		dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
+				mei_hdr->length);
 		return -EMSGSIZE;
 	} else {
 		return -EBADMSG;
@@ -1033,20 +1031,18 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 			cl->status = -ENODEV;
 			list_del(&cb_pos->cb_list);
 			return -ENODEV;
-		} else {
-			if (mei_flow_ctrl_reduce(dev, cl))
-				return -ENODEV;
-			dev->iamthif_msg_buf_index += mei_hdr->length;
-			cb_pos->information = dev->iamthif_msg_buf_index;
-			cl->status = 0;
-			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
-			dev->iamthif_flow_control_pending = true;
-			/* save iamthif cb sent to amthi client */
-			dev->iamthif_current_cb = cb_pos;
-			list_move_tail(&cb_pos->cb_list,
-				&dev->write_waiting_list.mei_cb.cb_list);
-
 		}
+		if (mei_flow_ctrl_reduce(dev, cl))
+			return -ENODEV;
+		dev->iamthif_msg_buf_index += mei_hdr->length;
+		cb_pos->information = dev->iamthif_msg_buf_index;
+		cl->status = 0;
+		dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+		dev->iamthif_flow_control_pending = true;
+		/* save iamthif cb sent to amthi client */
+		dev->iamthif_current_cb = cb_pos;
+		list_move_tail(&cb_pos->cb_list,
+			&dev->write_waiting_list.mei_cb.cb_list);
 	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
 			/* buffer is still empty */
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-- 
1.7.9.2

