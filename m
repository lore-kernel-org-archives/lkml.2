Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1IVJA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:00:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63555 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1IVJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:00:23 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Torben Hohn <torbenh@gmx.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-cris-kernel@axis.com
Subject: [PATCH 05/55] cris: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:32 +0800
Message-Id: <1316681962-8217-6-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/drivers/gpio.c         |    4 ++--
 arch/cris/arch-v10/drivers/sync_serial.c  |    4 ++--
 arch/cris/arch-v10/kernel/time.c          |    4 ++--
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |    2 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |    4 ++--
 arch/cris/arch-v32/kernel/fasttimer.c     |    2 +-
 arch/cris/arch-v32/kernel/irq.c           |    4 ++--
 arch/cris/arch-v32/kernel/smp.c           |    1 -
 arch/cris/arch-v32/kernel/time.c          |    4 ++--
 arch/cris/arch-v32/mach-a3/arbiter.c      |    4 ++--
 arch/cris/arch-v32/mach-fs/arbiter.c      |    2 +-
 arch/cris/include/arch-v10/arch/irq.h     |    5 +++--
 arch/cris/include/arch-v32/arch/irq.h     |    5 +++--
 arch/cris/kernel/irq.c                    |    3 +--
 14 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index a276f08..c19bc55 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -839,13 +839,13 @@ static int __init gpio_init(void)
 	 * in some tests.
 	 */
 	res = request_irq(TIMER0_IRQ_NBR, gpio_poll_timer_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio poll", gpio_name);
+		IRQF_SHARED, "gpio poll", gpio_name);
 	if (res) {
 		printk(KERN_CRIT "err: timer0 irq for gpio\n");
 		return res;
 	}
 	res = request_irq(PA_IRQ_NBR, gpio_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio PA", gpio_name);
+		IRQF_SHARED, "gpio PA", gpio_name);
 	if (res)
 		printk(KERN_CRIT "err: PA irq for gpio\n");
 
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 466af40..c25fe35 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -581,7 +581,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 			if (port == &ports[0]) {
 				if (request_irq(8,
 						manual_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED,
 						"synchronous serial manual irq",
 						&ports[0])) {
 					printk(KERN_CRIT "Can't alloc "
@@ -591,7 +591,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 			} else if (port == &ports[1]) {
 				if (request_irq(8,
 						manual_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED,
 						"synchronous serial manual irq",
 						&ports[1])) {
 					printk(KERN_CRIT "Can't alloc "
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 20c85b5..7d40c18 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -183,12 +183,12 @@ timer_interrupt(int irq, void *dev_id)
 }
 
 /* timer is IRQF_SHARED so drivers can add stuff to the timer irq chain
- * it needs to be IRQF_DISABLED to make the jiffies update work properly
+ * it needs irqs to be disabled to make the jiffies update work properly
  */
 
 static struct irqaction irq2  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.flags = IRQF_SHARED,
 	.name = "timer",
 };
 
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index c845831..50402d6 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -979,7 +979,7 @@ static int __init gpio_init(void)
 	CRIS_LED_DISK_WRITE(0);
 
 	int res2 = request_irq(GIO_INTR_VECT, gpio_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio", &alarmlist);
+		IRQF_SHARED, "gpio", &alarmlist);
 	if (res2) {
 		printk(KERN_ERR "err: irq for gpio\n");
 		return res2;
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index ee90d26..77b7c49 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -965,11 +965,11 @@ gpio_init(void)
 	 * in some tests.
 	 */
 	if (request_irq(TIMER0_INTR_VECT, gpio_poll_timer_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "gpio poll", &alarmlist))
+			IRQF_SHARED, "gpio poll", &alarmlist))
 		printk(KERN_ERR "timer0 irq for gpio\n");
 
 	if (request_irq(GIO_INTR_VECT, gpio_pa_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "gpio PA", &alarmlist))
+			IRQF_SHARED, "gpio PA", &alarmlist))
 		printk(KERN_ERR "PA irq for gpio\n");
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index 111caa1..a75114c 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -822,7 +822,7 @@ int fast_timer_init(void)
       fasttimer_proc_entry->read_proc = proc_fasttimer_read;
 #endif /* PROC_FS */
 		if (request_irq(TIMER0_INTR_VECT, timer_trig_interrupt,
-				IRQF_SHARED | IRQF_DISABLED,
+				IRQF_SHARED,
 				"fast timer int", &fast_timer_list))
 			printk(KERN_ERR "err: fasttimer irq\n");
     fast_timer_is_init = 1;
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 5ebe6e8..3b718f2 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -331,8 +331,8 @@ extern void do_IRQ(int irq, struct pt_regs * regs);
 void
 crisv32_do_IRQ(int irq, int block, struct pt_regs* regs)
 {
-	/* Interrupts that may not be moved to another CPU and
-         * are IRQF_DISABLED may skip blocking. This is currently
+	/* Interrupts that may not be moved to another CPU may
+	 * skip blocking. This is currently
          * only valid for the timer IRQ and the IPI and is used
          * for the timer interrupt to avoid watchdog starvation.
          */
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 0b99df7..553de03 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -64,7 +64,6 @@ static irqreturn_t crisv32_ipi_interrupt(int irq, void *dev_id);
 static int send_ipi(int vector, int wait, cpumask_t cpu_mask);
 static struct irqaction irq_ipi  = {
 	.handler = crisv32_ipi_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "ipi",
 };
 
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index bb978ed..d1f02ff 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -221,11 +221,11 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
 }
 
 /* Timer is IRQF_SHARED so drivers can add stuff to the timer irq chain.
- * It needs to be IRQF_DISABLED to make the jiffies update work properly.
+ * It needs irqs to be disabled to make the jiffies update work properly.
  */
 static struct irqaction irq_timer = {
 	.handler = timer_interrupt,
-	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.flags = IRQF_SHARED,
 	.name = "timer"
 };
 
diff --git a/arch/cris/arch-v32/mach-a3/arbiter.c b/arch/cris/arch-v32/mach-a3/arbiter.c
index 15f5c9d..ab5c421 100644
--- a/arch/cris/arch-v32/mach-a3/arbiter.c
+++ b/arch/cris/arch-v32/mach-a3/arbiter.c
@@ -256,11 +256,11 @@ static void crisv32_arbiter_init(void)
 	crisv32_arbiter_config(1, EXT_REGION, 0);
 
 	if (request_irq(MEMARB_FOO_INTR_VECT, crisv32_foo_arbiter_irq,
-			IRQF_DISABLED, "arbiter", NULL))
+			0, "arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
 	if (request_irq(MEMARB_BAR_INTR_VECT, crisv32_bar_arbiter_irq,
-			IRQF_DISABLED, "arbiter", NULL))
+			0, "arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
 #ifndef CONFIG_ETRAX_KGDB
diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
index 3f8ebb5..c97f4d8 100644
--- a/arch/cris/arch-v32/mach-fs/arbiter.c
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -184,7 +184,7 @@ static void crisv32_arbiter_init(void)
 	crisv32_arbiter_config(EXT_REGION, 0);
 	crisv32_arbiter_config(INT_REGION, 0);
 
-	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, IRQF_DISABLED,
+	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, 0,
 			"arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
diff --git a/arch/cris/include/arch-v10/arch/irq.h b/arch/cris/include/arch-v10/arch/irq.h
index 7d34594..4f20ed7 100644
--- a/arch/cris/include/arch-v10/arch/irq.h
+++ b/arch/cris/include/arch-v10/arch/irq.h
@@ -142,8 +142,9 @@ __asm__ ( \
  * it here, we would not get the multiple_irq at all.
  *
  * The non-blocking here is based on the knowledge that the timer interrupt is 
- * registred as a fast interrupt (IRQF_DISABLED) so that we _know_ there will not
- * be an sti() before the timer irq handler is run to acknowledge the interrupt.
+ * registred as a fast interrupt (called with irqs disabled) so that we _know_
+ * there will not be an sti() before the timer irq handler is run to acknowledge
+ * the interrupt.
  */
 
 #define BUILD_TIMER_IRQ(nr,mask) \
diff --git a/arch/cris/include/arch-v32/arch/irq.h b/arch/cris/include/arch-v32/arch/irq.h
index b31e998..8076d81 100644
--- a/arch/cris/include/arch-v32/arch/irq.h
+++ b/arch/cris/include/arch-v32/arch/irq.h
@@ -103,8 +103,9 @@ __asm__ (				\
  * if we had BLOCK'edit here, we would not get the multiple_irq at all.
  *
  * The non-blocking here is based on the knowledge that the timer interrupt is
- * registred as a fast interrupt (IRQF_DISABLED) so that we _know_ there will not
- * be an sti() before the timer irq handler is run to acknowledge the interrupt.
+ * registred as a fast interrupt (called with irqs disabled) so that we _know_
+ * there will not be an sti() before the timer irq handler is run to acknowledge
+ * the interrupt.
  */
 #define BUILD_TIMER_IRQ(nr, mask) 	\
 void IRQ_NAME(nr);			\
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 788eb22..9fa8e45 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -40,8 +40,7 @@
 /* called by the assembler IRQ entry functions defined in irq.h
  * to dispatch the interrupts to registered handlers
  * interrupts are disabled upon entry - depending on if the
- * interrupt was registered with IRQF_DISABLED or not, interrupts
- * are re-enabled or not.
+ * interrupts are re-enabled or not.
  */
 
 asmlinkage void do_IRQ(int irq, struct pt_regs * regs)
-- 
1.7.4.1

