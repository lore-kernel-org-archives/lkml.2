Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0JGSez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:34:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16083 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0JGSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:34:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57077784"
From: Brokhman Tatyana <tlinder@codeaurora.org>
To: linux-usb@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Brokhman Tatyana <tlinder@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC/PATCH v3] usb: usb3.0 ch9 definitions
Date: Thu,  7 Oct 2010 20:34:28 +0200
Message-Id: <1286476470-15265-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding SuperSpeed usb definitions as defined by ch9 of the USB3.0 spec.
This patch is a preparation for adding SuperSpeed support to the gadget
framework.

Signed-off-by: Brokhman Tatyana <tlinder@codeaurora.org>
---
 include/linux/usb/ch9.h |   58 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index da2ed77..a779b86 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -123,8 +123,23 @@
 #define USB_DEVICE_A_ALT_HNP_SUPPORT	5	/* (otg) other RH port does */
 #define USB_DEVICE_DEBUG_MODE		6	/* (special devices only) */
 
+/*
+ * New Feature Selectors as added by USB 3.0
+ * See USB 3.0 spec Table 9-6
+ */
+#define USB_DEVICE_U1_ENABLE	48	/* dev may initiate U1 transition */
+#define USB_DEVICE_U2_ENABLE	49	/* dev may initiate U2 transition*/
+#define USB_DEVICE_LTM_ENABLE	50	/* dev may send LTM*/
+#define USB_INTRF_FUNC_SUSPEND	0	/* function suspend*/
+
+#define USB_INTR_FUNC_SUSPEND_OPT_MASK	0xFF00
+
 #define USB_ENDPOINT_HALT		0	/* IN/OUT will STALL */
 
+/* Bit array elements as returned by the USB_REQ_GET_STATUS request. */
+#define USB_DEV_STAT_U1_ENABLED		2	/* transition into U1 state */
+#define USB_DEV_STAT_U2_ENABLED		3	/* transition into U2 state */
+#define USB_DEV_STAT_LTM_ENABLED	4	/* Latency tolerance messages*/
 
 /**
  * struct usb_ctrlrequest - SETUP data for a USB device control request
@@ -675,6 +690,7 @@ struct usb_bos_descriptor {
 	__u8  bNumDeviceCaps;
 } __attribute__((packed));
 
+#define USB_DT_BOS_SIZE		5
 /*-------------------------------------------------------------------------*/
 
 /* USB_DT_DEVICE_CAPABILITY:  grouped with BOS */
@@ -712,16 +728,56 @@ struct usb_wireless_cap_descriptor {	/* Ultra Wide Band */
 	__u8  bReserved;
 } __attribute__((packed));
 
+/* USB 2.0 Extension descriptor */
 #define	USB_CAP_TYPE_EXT		2
 
 struct usb_ext_cap_descriptor {		/* Link Power Management */
 	__u8  bLength;
 	__u8  bDescriptorType;
 	__u8  bDevCapabilityType;
-	__u8  bmAttributes;
+	__u32 bmAttributes;
 #define USB_LPM_SUPPORT			(1 << 1)	/* supports LPM */
 } __attribute__((packed));
 
+#define USB_DT_USB_EXT_CAP_SIZE	7
+
+/*
+ * SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed USB
+ * specific device level capabilities
+ */
+#define		USB_SS_CAP_TYPE		3
+struct usb_ss_cap_descriptor {		/* Link Power Management */
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDevCapabilityType;
+	__u8  bmAttributes;
+#define USB_LTM_SUPPORT			(1 << 1) /* supports LTM */
+	__u16 wSpeedSupported;
+#define USB_LOW_SPEED_OPERATION		(1)	 /* Low speed operation */
+#define USB_FULL_SPEED_OPERATION	(1 << 1) /* Full speed operation */
+#define USB_HIGH_SPEED_OPERATION	(1 << 2) /* High speed operation */
+#define USB_5GBPS_OPERATION		(1 << 3) /* Operation at 5Gbps */
+	__u8  bFunctionalitySupport;
+	__u8  bU1devExitLat;
+	__u16 bU2DevExitLat;
+} __attribute__((packed));
+
+#define USB_DT_USB_SS_CAP_SIZE	10
+
+/*
+ * Container ID Capability descriptor: Defines the instance unique ID used to
+ * identify the instance across all operating modes
+ */
+#define	CONTAINER_ID_TYPE	4
+struct usb_ss_container_id_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDevCapabilityType;
+	__u8  bReserved;
+	__u8  ContainerID[16]; /* 128-bit number */
+} __attribute__((packed));
+
+#define USB_DT_USB_SS_CONTN_ID_SIZE	20
 /*-------------------------------------------------------------------------*/
 
 /* USB_DT_WIRELESS_ENDPOINT_COMP:  companion descriptor associated with
-- 
1.6.3.3

