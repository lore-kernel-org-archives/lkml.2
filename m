Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2GDQZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:25:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:46132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab2GDQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166923250"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/6] mei: mei_irq_thread_write_handler - line break fix
Date: Wed,  4 Jul 2012 19:24:54 +0300
Message-Id: <1341419094-4204-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
References: <1341419094-4204-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. straight up lines that doesn't cross 80 characters
2. don't break strings

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |   44 +++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 4a3b117..c6ffbbe 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1199,8 +1199,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	dev_dbg(&dev->pdev->dev, "complete all waiting for write cb.\n");
 
 	list = &dev->write_waiting_list;
-	list_for_each_entry_safe(pos, next,
-			&list->mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &list->mei_cb.cb_list, cb_list) {
 		cl = (struct mei_cl *)pos->file_private;
 		if (cl == NULL)
 			continue;
@@ -1210,17 +1209,15 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		if (MEI_WRITING == cl->writing_state &&
 		   (pos->major_file_operations == MEI_WRITE) &&
 		   (cl != &dev->iamthif_cl)) {
-			dev_dbg(&dev->pdev->dev,
-				"MEI WRITE COMPLETE\n");
+			dev_dbg(&dev->pdev->dev, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
 			list_add_tail(&pos->cb_list,
-				&cmpl_list->mei_cb.cb_list);
+				      &cmpl_list->mei_cb.cb_list);
 		}
 		if (cl == &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "check iamthif flow control.\n");
 			if (dev->iamthif_flow_control_pending) {
-				ret = _mei_irq_thread_iamthif_read(
-						dev, slots);
+				ret = _mei_irq_thread_iamthif_read(dev, slots);
 				if (ret)
 					return ret;
 			}
@@ -1245,12 +1242,11 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	}
 	if (dev->mei_state == MEI_ENABLED) {
 		if (dev->wd_pending &&
-			mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
+		    mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
 			if (mei_wd_send(dev))
 				dev_dbg(&dev->pdev->dev, "wd send failed.\n");
-			else
-				if (mei_flow_ctrl_reduce(dev, &dev->wd_cl))
-					return -ENODEV;
+			else if (mei_flow_ctrl_reduce(dev, &dev->wd_cl))
+				return -ENODEV;
 
 			dev->wd_pending = false;
 
@@ -1305,7 +1301,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	/* complete  write list CB */
 	dev_dbg(&dev->pdev->dev, "complete write list cb.\n");
 	list_for_each_entry_safe(pos, next,
-			&dev->write_list.mei_cb.cb_list, cb_list) {
+				&dev->write_list.mei_cb.cb_list, cb_list) {
 		cl = (struct mei_cl *)pos->file_private;
 		if (cl == NULL)
 			continue;
@@ -1313,15 +1309,12 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		if (cl != &dev->iamthif_cl) {
 			if (mei_flow_ctrl_creds(dev, cl) <= 0) {
 				dev_dbg(&dev->pdev->dev,
-					"No flow control"
-				    " credentials for client"
-				    " %d, not sending.\n",
-				    cl->host_client_id);
+					"No flow control credentials for client %d, not sending.\n",
+					cl->host_client_id);
 				continue;
 			}
-			ret = _mei_irq_thread_cmpl(dev, slots,
-					    pos,
-					    cl, cmpl_list);
+			ret = _mei_irq_thread_cmpl(dev, slots, pos,
+						cl, cmpl_list);
 			if (ret)
 				return ret;
 
@@ -1330,17 +1323,12 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			dev_dbg(&dev->pdev->dev, "complete amthi write cb.\n");
 			if (mei_flow_ctrl_creds(dev, cl) <= 0) {
 				dev_dbg(&dev->pdev->dev,
-					"No flow control"
-				    " credentials for amthi"
-				    " client %d.\n",
-				    cl->host_client_id);
+					"No flow control credentials for amthi client %d.\n",
+					cl->host_client_id);
 				continue;
 			}
-			ret = _mei_irq_thread_cmpl_iamthif(dev,
-						slots,
-						pos,
-						cl,
-						cmpl_list);
+			ret = _mei_irq_thread_cmpl_iamthif(dev, slots, pos,
+						cl, cmpl_list);
 			if (ret)
 				return ret;
 
-- 
1.7.4.4

