Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1FPHeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:34:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45756 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab1FPHBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:16 -0400
X-Sasl-enc: T3tKrE2xErVopVKXGOrq00SDKTIvqYCucnLjefX3frOs 1308207675
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:34 2011
Message-Id: <20110616000234.881084533@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [60/89] xhci: Add defines for hardcoded slot states
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maarten Lankhorst <m.b.lankhorst@gmail.com>

commit e2b0217715c6d10379d94bdfe5560af96eecbb7c upstream.

This needs to be added to the stable trees back to 2.6.34 to support an
upcoming bug fix.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-dbg.c |    8 ++++----
 drivers/usb/host/xhci.h     |    5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -437,13 +437,13 @@ char *xhci_get_slot_state(struct xhci_hc
 	struct xhci_slot_ctx *slot_ctx = xhci_get_slot_ctx(xhci, ctx);
 
 	switch (GET_SLOT_STATE(slot_ctx->dev_state)) {
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


