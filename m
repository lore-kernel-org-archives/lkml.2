Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1AUHqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:46:01 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6280 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1AUHp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:45:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71349521"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 4/4] uasp: TASK MANAGEMENT IU handling infrastructure
Date: Fri, 21 Jan 2011 09:45:47 +0200
Message-Id: <1295595948-23360-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines APIs for different TASK MANAGEMENT IUs implementation

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 drivers/usb/gadget/uasp_tmiu.c |  219 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/uasp_tmiu.c b/drivers/usb/gadget/uasp_tmiu.c
index 4e244ae..6733545 100644
--- a/drivers/usb/gadget/uasp_tmiu.c
+++ b/drivers/usb/gadget/uasp_tmiu.c
@@ -48,6 +48,194 @@ void fill_response_iu(struct uasp_dev *udev,
 }
 
 /**
+ * reset_lun() - performs RESET LUN TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function performs LUN reset. It aborts all of the given LUN pending
+ * commands.
+ */
+static void reset_lun(struct uasp_dev *udev,
+		      struct uasp_lun *curlun,
+		      struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * abort_task() - This function performs ABORT TASK TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function aborts the command with the same ip_tag as in the
+ * tmiu->task_tag. It's valid only for command that are handled by a specific
+ * LUN .
+ */
+static void abort_task(struct uasp_dev *udev,
+		       struct uasp_lun *curlun,
+		       struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * abort_task_set() - This function performs ABORT TASK SET TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function aborts all the commands pending for the specified LUN.
+ */
+static void abort_task_set(struct uasp_dev *udev,
+			   struct uasp_lun *curlun,
+			   struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * reset_nexus() - This function performs RESET NEXUS TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @tmiu: TM FUNCTION IU to be processed.
+ */
+static void reset_nexus(struct uasp_dev *udev,
+			struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * query_unit_attention() - performs QUERY UNIT ATTENTION TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu: TM FUNCTION IU to be processed.
+ *
+ * This function is used to obtain a unit attention condition or a deferred
+ * error pending, if such exists, for the LUN on which the task management
+ * function was received.
+ */
+static void query_unit_attention(struct uasp_dev *udev,
+				 struct uasp_lun *curlun,
+				 struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+
+/**
+ * This function performs QUERY TASK TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu TM FUNCTION IU to be processed.
+ */
+static void query_task(struct uasp_dev *udev,
+		       struct uasp_lun *curlun,
+		       struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * This function performs QUERY TASK SET TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @tmiu TM FUNCTION IU to be processed.
+ */
+static void query_task_set(struct uasp_dev *udev,
+			   struct uasp_lun *curlun,
+			   struct tm_iu *tmiu)
+{
+	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+}
+
+/**
+ * process_tmiu() - process a given TM FUNCTION IU.
+ * @udev: Programming view of UASP device.
+ * @curlun: Pointer to struct uasp_lun if the COMMAND IU to be performed is
+ *	   addressed to a valid LUN, 0 otherwise.
+ * @miu: TM FUNCTION IU to be processed.
+ */
+static void process_tmiu(struct uasp_dev *udev,
+			 struct uasp_lun *curlun,
+			 struct tm_iu *tmiu)
+{
+	struct response_iu *riu;
+	unsigned long flags;
+
+	switch (tmiu->tm_function) {
+	case TM_FUNCTION_ABORT_TASK:
+		abort_task(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_ABORT_TASK_SET:
+	case TM_FUNCTION_CLEAR_TASK_SET:
+		abort_task_set(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_RESET_LUN:
+		reset_lun(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_IT_NEXUS_RESET:
+		reset_nexus(udev, tmiu);
+		break;
+
+	case TM_FUNCTION_QUERY_TASK:
+		query_task(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_QUERY_TASK_SET:
+		query_task_set(udev, curlun, tmiu);
+		break;
+
+	case TM_FUNCTION_QUERY_ASYNC_EVENT:
+		query_unit_attention(udev, curlun, tmiu);
+		break;
+
+	default:
+		ERROR(udev->ucommon->common, "%s(): Unsupported  tmiu = %x\n",
+		    __func__, tmiu->tm_function);
+		riu = (struct response_iu *)tmiu->bh->inreq->buf;
+		fill_response_iu(udev, riu, IUGETW(tmiu->ip_tag), 0,
+			  RESPONSE_TM_FUNCTION_NOT_SUPPORTED);
+
+		fill_usb_request(tmiu->bh->inreq, (void *)riu,
+				 UASP_SIZEOF_RESPONSE_IU, 0,
+				 (void *)tmiu, 0, IUGETW(tmiu->ip_tag),
+				 status_complete);
+		tmiu->ep = udev->status;
+		break;
+	}
+
+	tmiu->state = COMMAND_STATE_STATUS;
+	if (usb_ep_queue(tmiu->ep, tmiu->bh->inreq, 0)) {
+		ERROR(udev->ucommon->common,
+			      "%s()usb_ep_queue failed\n",  __func__);
+		tmiu->state = COMMAND_STATE_FAILED;
+	} else {
+		if (curlun) {
+			spin_lock_irqsave(&(curlun->lock), flags);
+			curlun->active_requests++;
+			spin_unlock_irqrestore(&(curlun->lock), flags);
+		} else {
+			spin_lock_irqsave(&(udev->ucommon->common->lock),
+					  flags);
+			udev->active_requests++;
+			spin_unlock_irqrestore(&(udev->ucommon->common->lock),
+					       flags);
+		}
+	}
+}
+
+/**
  * do_tmdiu() - processes the TM FUNCTION IUs from a given queue.
  * @udev: Programming view of file storage gadget.
  * @curlun: Pointer to struct uasp_lun if TM FUNCTION IUs from
@@ -57,5 +245,36 @@ void fill_response_iu(struct uasp_dev *udev,
  */
 void do_tmiu(struct uasp_dev *udev, struct uasp_lun *curlun)
 {
+	struct list_head *link;
+	struct tm_iu *tmiu, *tmp;
+	unsigned long flags;
+
 	DBG(udev->ucommon->common, "%s() - Enter\n", __func__);
+
+	/* Select the tm_func_queue from which tmius should be processed */
+	if (curlun)
+		link = &curlun->tm_func_queue;
+	else
+		link = &udev->tm_func_queue;
+
+	DBG(udev->ucommon->common, "%s() - Rolling over tmiu queue\n",
+	     __func__);
+	list_for_each_entry_safe(tmiu, tmp, link, node) {
+		if (tmiu->state != COMMAND_STATE_IDLE)
+			continue;
+
+		/* Try to get buffer for tmiu provessing */
+		spin_lock_irqsave(&(udev->ucommon->common->lock), flags);
+		tmiu->bh = get_buffhd(udev->ucommon->common->buffhds);
+		spin_unlock_irqrestore(&(udev->ucommon->common->lock), flags);
+
+		if (!tmiu->bh) {
+			ERROR(udev->ucommon->common,
+			      "%s() -Didnt manage to get buffers for tmiu!\n",
+			      __func__);
+			continue;
+		}
+
+		process_tmiu(udev, curlun, tmiu);
+	}
 }
-- 
1.6.3.3
--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
