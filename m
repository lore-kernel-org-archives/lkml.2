Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2IFF0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:26:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19448 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2IFF0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:26:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Sep 2012 22:19:32 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <balbi@ti.com>, <fengguang.wu@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: phy: fix build break
Date: Thu, 6 Sep 2012 10:42:15 +0530
Message-ID: <1346908335-25160-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During phy interface separation from otg.h, as the enum "usb_otg_state"
was having multiple otg states info and removal of member 'state'
of this enum type from usb_phy struct did not generate any compilation
issues, I removed member state from struct usb_phy.

As this is causing build break in musb code, adding member 'state'
to usb_phy structure.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 include/linux/usb/otg.h |   24 ------------------------
 include/linux/usb/phy.h |   25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 65a2b6a..e8a5fe8 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -11,30 +11,6 @@
 
 #include <linux/usb/phy.h>
 
-/* OTG defines lots of enumeration states before device reset */
-enum usb_otg_state {
-	OTG_STATE_UNDEFINED = 0,
-
-	/* single-role peripheral, and dual-role default-b */
-	OTG_STATE_B_IDLE,
-	OTG_STATE_B_SRP_INIT,
-	OTG_STATE_B_PERIPHERAL,
-
-	/* extra dual-role default-b states */
-	OTG_STATE_B_WAIT_ACON,
-	OTG_STATE_B_HOST,
-
-	/* dual-role default-a */
-	OTG_STATE_A_IDLE,
-	OTG_STATE_A_WAIT_VRISE,
-	OTG_STATE_A_WAIT_BCON,
-	OTG_STATE_A_HOST,
-	OTG_STATE_A_SUSPEND,
-	OTG_STATE_A_PERIPHERAL,
-	OTG_STATE_A_WAIT_VFALL,
-	OTG_STATE_A_VBUS_ERR,
-};
-
 struct usb_otg {
 	u8			default_a;
 
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 88fc160..06b5bae 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -26,6 +26,30 @@ enum usb_phy_type {
 	USB_PHY_TYPE_USB3,
 };
 
+/* OTG defines lots of enumeration states before device reset */
+enum usb_otg_state {
+	OTG_STATE_UNDEFINED = 0,
+
+	/* single-role peripheral, and dual-role default-b */
+	OTG_STATE_B_IDLE,
+	OTG_STATE_B_SRP_INIT,
+	OTG_STATE_B_PERIPHERAL,
+
+	/* extra dual-role default-b states */
+	OTG_STATE_B_WAIT_ACON,
+	OTG_STATE_B_HOST,
+
+	/* dual-role default-a */
+	OTG_STATE_A_IDLE,
+	OTG_STATE_A_WAIT_VRISE,
+	OTG_STATE_A_WAIT_BCON,
+	OTG_STATE_A_HOST,
+	OTG_STATE_A_SUSPEND,
+	OTG_STATE_A_PERIPHERAL,
+	OTG_STATE_A_WAIT_VFALL,
+	OTG_STATE_A_VBUS_ERR,
+};
+
 struct usb_phy;
 struct usb_otg;
 
@@ -43,6 +67,7 @@ struct usb_phy {
 	unsigned int		 flags;
 
 	enum usb_phy_type	type;
+	enum usb_otg_state	state;
 	enum usb_phy_events	last_event;
 
 	struct usb_otg		*otg;
-- 
1.7.1.1

