Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab0JSNkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:40:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab0JSNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:40:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6140"; a="58491208"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] usb: USB3.0 ch11 definitions
Date: Tue, 19 Oct 2010 15:38:50 +0200
Message-Id: <1287495546-22758-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding hub SuperSpeed usb definitions as defined by ch10 of the USB3.0
spec.

Signed-off-by: tlinder <tlinder@codeaurora.org>
---
 include/linux/usb/ch11.h |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/hcd.h  |    4 +++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/ch11.h b/include/linux/usb/ch11.h
index 119194c..10ec069 100644
--- a/include/linux/usb/ch11.h
+++ b/include/linux/usb/ch11.h
@@ -28,6 +28,13 @@
 #define HUB_STOP_TT		11
 
 /*
+ * Hub class additional requests defined by USB 3.0 spec
+ * See USB 3.0 spec Table 10-6
+ */
+#define HUB_SET_DEPTH		12
+#define HUB_GET_PORT_ERR_COUNT	13
+
+/*
  * Hub Class feature numbers
  * See USB 2.0 spec Table 11-17
  */
@@ -56,6 +63,20 @@
 #define USB_PORT_FEAT_C_PORT_L1         23
 
 /*
+ * Port feature selectors added by USB 3.0 spec.
+ * See USB 3.0 spec Table 10-7
+ */
+#define USB_PORT_FEAT_LINK_STATE		5
+#define USB_PORT_FEAT_U1_TIMEOUT		23
+#define USB_PORT_FEAT_U2_TIMEOUT		24
+#define USB_PORT_FEAT_C_LINK_STATE		25
+#define USB_PORT_FEAT_C_CONFIG_ERR		26
+#define USB_PORT_FEAT_REMOTE_WAKE_MASK		27
+#define USB_PORT_FEAT_BH_PORT_RESET		28
+#define USB_PORT_FEAT_C_BH_PORT_RESET		29
+#define USB_PORT_FEAT_FORCE_LINKPM_ACCEPT	30
+
+/*
  * Hub Status and Hub Change results
  * See USB 2.0 spec Table 11-19 and Table 11-20
  */
@@ -84,6 +105,32 @@ struct usb_port_status {
 #define USB_PORT_STAT_SUPER_SPEED	0x8000	/* Linux-internal */
 
 /*
+ * Additions to wPortStatus bit field from USB 3.0
+ * See USB 3.0 spec Table 10-10
+ */
+#define USB_PORT_STAT_LINK_STATE	0x01e0
+#define USB_SS_PORT_STAT_POWER		0x0200
+#define USB_PORT_STAT_SPEED_5GBPS	0x0000
+/* Valid only if port is enabled */
+
+/*
+ * Definitions for PORT_LINK_STATE values
+ * (bits 5-8) in wPortStatus
+ */
+#define USB_SS_PORT_LS_U0		0x0000
+#define USB_SS_PORT_LS_U1		0x0020
+#define USB_SS_PORT_LS_U2		0x0040
+#define USB_SS_PORT_LS_U3		0x0060
+#define USB_SS_PORT_LS_SS_DISABLED	0x0080
+#define USB_SS_PORT_LS_RX_DETECT	0x00a0
+#define USB_SS_PORT_LS_SS_INACTIVE	0x00c0
+#define USB_SS_PORT_LS_POLLING		0x00e0
+#define USB_SS_PORT_LS_RECOVERY		0x0100
+#define USB_SS_PORT_LS_HOT_RESET	0x0120
+#define USB_SS_PORT_LS_COMP_MOD		0x0140
+#define USB_SS_PORT_LS_LOOPBACK		0x0160
+
+/*
  * wPortChange bit field
  * See USB 2.0 spec Table 11-22
  * Bits 0 to 4 shown, bits 5 to 15 are reserved
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 3b571f1..d7738de 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -469,6 +469,10 @@ extern void usb_ep0_reinit(struct usb_device *);
 
 /*-------------------------------------------------------------------------*/
 
+/* class requests from USB 3.0 hub spec, table 10-5 */
+#define SetHubDepth		(0x3000 | HUB_SET_DEPTH)
+#define GetPortErrorCount	(0x8000 | HUB_GET_PORT_ERR_COUNT)
+
 /*
  * Generic bandwidth allocation constants/support
  */
-- 
1.6.3.3

--
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
