Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1CGQtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:49:02 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1CGQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:49:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6277"; a="78468616"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: gregkh@suse.de
Cc: linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH 5/5] uas: HACK needed for UAS host.
Date: Mon,  7 Mar 2011 18:48:51 +0200
Message-Id: <1299516532-28866-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REMOVE LATER ON!
In today's UAS host driver MODE SENSE command isn't handled correctly.
Each time after power up there is a unit attention condition of
RESET_OCCURRED that needs to be cleared (= acknowledged by the
host) by the MODE SENSE command.
Due to the above this patch resets the RESET_OCCURRED unit attention.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/usb/gadget/uasp_cmdiu.c b/drivers/usb/gadget/uasp_cmdiu.c
index 4df3d98..51eb132 100644
--- a/drivers/usb/gadget/uasp_cmdiu.c
+++ b/drivers/usb/gadget/uasp_cmdiu.c
@@ -83,6 +83,13 @@ static __u32 check_cmdiu(struct uasp_dev *udev,
 			curlun->lun->unit_attention_data = SS_NO_SENSE;
 			return ua_data;
 		}
+			/* HACK!!! REMOVE!!! */
+		if (curlun->lun->unit_attention_data == SS_RESET_OCCURRED &&
+			cmdiu->cdb[0] == INQUIRY) {
+			curlun->lun->unit_attention_data = SS_NO_SENSE;
+			DBG(udev->ucommon->common, "check_cmdiu() - "
+			       "HACK!!! RESETTING  unit attention condition\n");
+		}
 	}
 
 	if (curlun && !(curlun->lun->filp) && needs_medium) {
-- 
1.7.0.4

--
Sent by a Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
