Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0JJO27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:28:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16651 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0JJO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:28:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6131"; a="57378706"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: Tatyana Brokhman <tlinder@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@intel.com>, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH 1/2] usb: usb30 ch11 definitions
Date: Sun, 10 Oct 2010 16:28:43 +0200
Message-Id: <1286720925-29143-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding hub SuperSpeed usb definitions as defined by ch10 of the USB3.0
spec.
This patch is a preparation for adding SuperSpeed support to the dummy_hcd.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
---
 include/linux/usb/ch11.h |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/hcd.h  |    4 +++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/ch11.h b/include/linux/usb/ch11.h
index 119194c..38a6a22 100644
--- a/include/linux/usb/ch11.h
+++ b/include/linux/usb/ch11.h
@@ -28,6 +28,13 @@
 #define HUB_STOP_TT		11
 
 /*
+ * Hub class aditional requests defined by USB 3.0 spec
+ * See USB 3.0 spec Table 10-6
+ */
+#define HUB_SET_DEPTH		12
+#define HUB_GET_PORT_ERR_COUNT	13
+
+/*
  * Hub Class feature numbers
  * See USB 2.0 spec Table 11-17
  */
@@ -83,6 +90,21 @@ struct usb_port_status {
 /* bits 13 to 15 are reserved */
 #define USB_PORT_STAT_SUPER_SPEED	0x8000	/* Linux-internal */
 
+
+/*
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
 /*
  * wPortChange bit field
  * See USB 2.0 spec Table 11-22
@@ -121,6 +143,31 @@ struct usb_hub_status {
 #define HUB_CHANGE_LOCAL_POWER	0x0001
 #define HUB_CHANGE_OVERCURRENT	0x0002
 
+/*
+ * Additions to wPortStatus bit filed from USB 3.0
+ * See USB 3.0 spec Table 10-10
+ */
+#define USB_PORT_STAT_LINK_STATE	0x01e0
+#define USB_SS_PORT_STAT_POWER		0x0200
+#define USB_PORT_STAT_SPEED_5GBPS	0x0000
+/* Valid only if port is enabled */
+
+/*
+ * Defenitions for PORT_LINK_STATE values
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
 
 /*
  * Hub descriptor
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
Sent by	an consultant of the Qualcomm Inovation Center, Inc.
The Qualcomm Inovation Center, Inc.is a member of the Code Aurora Forum.
