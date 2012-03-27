Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927Ab2C3XDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:03:32 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934822Ab2C3VFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:10 -0400
Message-Id: <201203302104.q2UL4tYU006258@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 15:21:00 -0400
Subject: [PATCH] arch/tile: use 0 for IRQ_RESCHEDULE instead of 1
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:55.0397 (UTC) FILETIME=[C1EDC950:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids assigning IRQ 0 to PCI devices, because we've seen that
doesn't always work well.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index f80f8ce..33cff9a 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
@@ -21,7 +21,7 @@
 #define NR_IRQS 32
 
 /* IRQ numbers used for linux IPIs. */
-#define IRQ_RESCHEDULE 1
+#define IRQ_RESCHEDULE 0
 
 #define irq_canonicalize(irq)   (irq)
 
-- 
1.6.5.2

