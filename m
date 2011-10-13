Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1JMSNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:13:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48498 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JMSN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:13:29 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4] staging: et131x: Moving two extern inline functions to .c file
Date: Thu, 13 Oct 2011 19:11:55 +0100
Message-Id: <1318529518-4922-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two helper functions for adding 10bit/12bit umbers with wrapping are
defined in the header. Moved them to the driver .c file.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   11 +++++++++++
 drivers/staging/et131x/et131x.h |   10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 9596102..14f54e4 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2666,6 +2666,17 @@ void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 	}
 }
 
+
+static inline void add_10bit(u32 *v, int n)
+{
+	*v = INDEX10(*v + n) | (*v & ET_DMA10_WRAP);
+}
+
+static inline void add_12bit(u32 *v, int n)
+{
+	*v = INDEX12(*v + n) | (*v & ET_DMA12_WRAP);
+}
+
 /**
  * nic_rx_pkts - Checks the hardware for available packets
  * @adapter: pointer to our adapter
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 84b274d..7eed3c8 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -230,16 +230,6 @@ struct global_regs {				/* Location: */
 #define INDEX10(x)	((x) & ET_DMA10_MASK)
 #define INDEX4(x)	((x) & ET_DMA4_MASK)
 
-extern inline void add_10bit(u32 *v, int n)
-{
-	*v = INDEX10(*v + n) | (*v & ET_DMA10_WRAP);
-}
-
-extern inline void add_12bit(u32 *v, int n)
-{
-	*v = INDEX12(*v + n) | (*v & ET_DMA12_WRAP);
-}
-
 /*
  * 10bit DMA with wrap
  * txdma tx queue write address reg in txdma address map at 0x1010
-- 
1.7.6.4

