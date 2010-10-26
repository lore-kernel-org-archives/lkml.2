Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0JZHTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:19:40 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50089 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab0JZHTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:19:39 -0400
Date: Tue, 26 Oct 2010 16:19:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: Add single IRQ reservation helper.
Message-ID: <20101026071912.GD4733@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For cases that wish to reserve a single IRQ simply provide a wrapper in
to the ranged reservation routine.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

I picked irq_reserve_irq() to follow the irq_alloc_descs/desc naming
scheme, but perhaps irq_reserve() or irq_reserve_at() is less visually
offensive? Feel free to mangle away as necessary :-)

 include/linux/irq.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index e963911..abde252 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -412,6 +412,11 @@ static inline void irq_free_desc(unsigned int irq)
 	irq_free_descs(irq, 1);
 }
 
+static inline int irq_reserve_irq(unsigned int irq)
+{
+	return irq_reserve_irqs(irq, 1);
+}
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #endif /* !CONFIG_S390 */
