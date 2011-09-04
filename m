Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1IDK10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:27:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1IDK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:25 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 07/12] staging: et131x: Remove cached_mask_value from et131x_adapter
Date: Sun,  4 Sep 2011 11:24:38 +0100
Message-Id: <1315131883-11068-8-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cached_mask_value is only ever assigned, never read. Remove it.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_adapter.h |    2 --
 drivers/staging/et131x/et131x_isr.c     |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 8c6d5f9..292a771 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -200,8 +200,6 @@ struct et131x_adapter {
 	u16 pdown_speed;
 	u8 pdown_duplex;
 
-	u32 cached_mask_value;
-
 	/* Xcvr status at last poll */
 	u16 bmsr;
 
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index b3290e9..0747935 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -125,7 +125,6 @@ void et131x_enable_interrupts(struct et131x_adapter *adapter)
 	else
 		mask = INT_MASK_ENABLE_NO_FLOW;
 
-	adapter->cached_mask_value = mask;
 	writel(mask, &adapter->regs->global.int_mask);
 }
 
@@ -139,7 +138,6 @@ void et131x_enable_interrupts(struct et131x_adapter *adapter)
 void et131x_disable_interrupts(struct et131x_adapter *adapter)
 {
 	/* Disable all global interrupts */
-	adapter->cached_mask_value = INT_MASK_DISABLE;
 	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
 }
 
-- 
1.7.6

