Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab1FAV2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:28:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38547 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1FAV2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fv5VjKn7g5OvFtXBHTSdzHkrCTx7uFvxmREijWRAzQs6Su9oX15ThUbya9kYQ/ULi0
         zPgR5sUwXubVz4Jzdmuh65oQP1GgwF7I2neLNy9Nml1KFCBEPaPvRdm9MB5ZYfHLaQ4g
         Rg3lEWXAJ71WOEuXfgfUYlVXh1mELY4qPtSDE=
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH 1/2] xhci: Add defines for hardcoded slot states
Date: Wed,  1 Jun 2011 23:27:49 +0200
Message-Id: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
 drivers/usb/host/xhci-dbg.c |    8 ++++----
 drivers/usb/host/xhci.h     |    5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index 2e04861..1f50b44 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -438,13 +438,13 @@ char *xhci_get_slot_state(struct xhci_hcd *xhci,
 	struct xhci_slot_ctx *slot_ctx = xhci_get_slot_ctx(xhci, ctx);
 
 	switch (GET_SLOT_STATE(le32_to_cpu(slot_ctx->dev_state))) {
-	case 0:
+	case SLOT_STATE_ENABLED:
 		return "enabled/disabled";
-	case 1:
+	case SLOT_STATE_DEFAULT:
 		return "default";
-	case 2:
+	case SLOT_STATE_ADDRESSED:
 		return "addressed";
-	case 3:
+	case SLOT_STATE_CONFIGURED:
 		return "configured";
 	default:
 		return "reserved";
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index ac0196e..bbc1d9a 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -560,6 +560,11 @@ struct xhci_slot_ctx {
 #define SLOT_STATE	(0x1f << 27)
 #define GET_SLOT_STATE(p)	(((p) & (0x1f << 27)) >> 27)
 
+#define SLOT_STATE_DISABLED	0
+#define SLOT_STATE_ENABLED	SLOT_STATE_DISABLED
+#define SLOT_STATE_DEFAULT	1
+#define SLOT_STATE_ADDRESSED	2
+#define SLOT_STATE_CONFIGURED	3
 
 /**
  * struct xhci_ep_ctx
-- 
1.7.4.1

