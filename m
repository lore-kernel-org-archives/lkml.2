Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0J1Cag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:30:36 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47125 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab0J1Cae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:30:34 -0400
Date: Thu, 28 Oct 2010 11:30:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: Fix up irq_node() for irq_data changes.
Message-ID: <20101028023031.GB10365@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the node ID is tracked in the irq_data structure, update the
irq_node() definition accordingly. This fixes up irq_node() usage under
GENERIC_HARDIRQS_NO_DEPRECATED && SMP.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/irqnr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 05aa8c2..3bc4dca 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -43,7 +43,7 @@ unsigned int irq_get_next_irq(unsigned int offset);
 		else
 
 #ifdef CONFIG_SMP
-#define irq_node(irq)	(irq_to_desc(irq)->node)
+#define irq_node(irq)	(irq_get_irq_data(irq)->node)
 #else
 #define irq_node(irq)	0
 #endif
