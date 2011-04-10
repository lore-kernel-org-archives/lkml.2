Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1DJJCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 05:02:07 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:38159 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1DJJCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 05:02:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] genirq: Forgotten updates/deletions after removal of compat code
Date: Sun, 10 Apr 2011 11:01:51 +0200
Message-Id: <1302426113-13808-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0c6f8a8b917ad361319c8ace3e9f28e69bfdb4c1 ("genirq: Remove compat code")
removed the compat code, but forgot to update some references in comments and
delete some of its documentation.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/irq.h     |   19 +------------------
 include/linux/irqdesc.h |    2 +-
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 09a3080..a71dd18 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -53,7 +53,7 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * Bits which can be modified via irq_set/clear/modify_status_flags()
  * IRQ_LEVEL			- Interrupt is level type. Will be also
  *				  updated in the code when the above trigger
- *				  bits are modified via set_irq_type()
+ *				  bits are modified via irq_set_irq_type()
  * IRQ_PER_CPU			- Mark an interrupt PER_CPU. Will protect
  *				  it from affinity setting
  * IRQ_NOPROBE			- Interrupt cannot be probed by autoprobing
@@ -261,23 +261,6 @@ static inline void irqd_clr_chained_irq_inprogress(struct irq_data *d)
  * struct irq_chip - hardware interrupt chip descriptor
  *
  * @name:		name for /proc/interrupts
- * @startup:		deprecated, replaced by irq_startup
- * @shutdown:		deprecated, replaced by irq_shutdown
- * @enable:		deprecated, replaced by irq_enable
- * @disable:		deprecated, replaced by irq_disable
- * @ack:		deprecated, replaced by irq_ack
- * @mask:		deprecated, replaced by irq_mask
- * @mask_ack:		deprecated, replaced by irq_mask_ack
- * @unmask:		deprecated, replaced by irq_unmask
- * @eoi:		deprecated, replaced by irq_eoi
- * @end:		deprecated, will go away with __do_IRQ()
- * @set_affinity:	deprecated, replaced by irq_set_affinity
- * @retrigger:		deprecated, replaced by irq_retrigger
- * @set_type:		deprecated, replaced by irq_set_type
- * @set_wake:		deprecated, replaced by irq_wake
- * @bus_lock:		deprecated, replaced by irq_bus_lock
- * @bus_sync_unlock:	deprecated, replaced by irq_bus_sync_unlock
- *
  * @irq_startup:	start up the interrupt (defaults to ->enable if NULL)
  * @irq_shutdown:	shut down the interrupt (defaults to ->disable if NULL)
  * @irq_enable:		enable the interrupt (defaults to chip->unmask if NULL)
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index a082905..8e1dc8e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -21,7 +21,7 @@ struct timer_rand_state;
  * @status:		status information
  * @core_internal_state__do_not_mess_with_it: core internal status information
  * @depth:		disable-depth, for nested irq_disable() calls
- * @wake_depth:		enable depth, for multiple set_irq_wake() callers
+ * @wake_depth:		enable depth, for multiple irq_set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
-- 
1.7.0.4

