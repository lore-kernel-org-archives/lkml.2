Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1CYQxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:53:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:46936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753816Ab1CYQxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:53:08 -0400
Date: Fri, 25 Mar 2011 17:52:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] irq cleanups for .39
Message-ID: <alpine.LFD.2.00.1103251747450.31464@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-cleanup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-cleanup-for-linus

This contains the irq/urgent bits which Ingo asked to pull earlier, so
whatever you pull first does not matter.

The gpio patches have been acked by Grant.

The avr, h8300, xtensa, m32r, um bits is stuff which got ignored by
the arch maintainers. Those archs seem to be orphaned. 

The cleanup is necessary as we really want to get rid of all the
deprecated and compat stuff asap.

Thanks,

	tglx

------------------>
Ryan Mallon (1):
      arm: ep93xx: Add basic interrupt info

Thomas Gleixner (25):
      genirq; Remove the last leftovers of the old sparse irq code
      genirq: Provide a lockdep helper
      genirq: Provide locked setter for chip, handler, name
      avr32: At32ap: Convert extint irq_chip to new functions
      avr32: At32ap: Convert intc irq_chip to new functions
      avr32: At32ap: Convert pop irq_chip to new functions
      avr32: Use generic IRQ config, enable GENERIC_HARDIRQS_NO_DEPRECATED
      avr: Cleanup genirq namespace
      avr32: Use generic show_interrupts()
      avr32: Cleanup eic_set_irq_type()
      h8300: Convert genirq namespace
      h8300: Use generic show_interrupts()
      m32r: Convert genirq namespace
      m32r: Use generic show_interrupts()
      um: Convert genirq namespace
      um: Use generic show_interrupts()
      xtensa: Convert main irq_chip to new functions
      xtensa: Convert s6000 gpio irq_chip to new functions
      xtensa: Use generic IRQ Kconfig and set GENERIC_HARDIRQS_NO_DEPRECATED
      xtensa: Convert genirq namespace
      xtensa: Use generic show_interrupts()
      arm/gpio: Remove three copies of broken and racy debug code
      gpio: Cleanup genirq namespace
      gpio: Fold irq_set_chip/irq_set_handler to irq_set_chip_and_handler
      genirq: Expand generic show_interrupts()


 arch/arm/mach-ep93xx/gpio.c          |   46 +-------------
 arch/arm/plat-nomadik/gpio.c         |   45 --------------
 arch/avr32/Kconfig                   |   14 ++---
 arch/avr32/boards/atngw100/mrmt.c    |    2 +-
 arch/avr32/boards/atngw100/setup.c   |    2 +-
 arch/avr32/kernel/irq.c              |   37 ------------
 arch/avr32/mach-at32ap/extint.c      |   82 ++++++++++++--------------
 arch/avr32/mach-at32ap/intc.c        |   14 ++---
 arch/avr32/mach-at32ap/pio.c         |   37 ++++++------
 arch/h8300/Kconfig                   |    1 +
 arch/h8300/kernel/irq.c              |   33 +----------
 arch/m32r/Kconfig                    |    1 +
 arch/m32r/kernel/irq.c               |   45 --------------
 arch/m32r/platforms/m32104ut/setup.c |    8 +-
 arch/m32r/platforms/m32700ut/setup.c |   28 +++++-----
 arch/m32r/platforms/mappi/setup.c    |   16 +++---
 arch/m32r/platforms/mappi2/setup.c   |   20 +++---
 arch/m32r/platforms/mappi3/setup.c   |   20 +++---
 arch/m32r/platforms/oaks32r/setup.c  |   12 ++--
 arch/m32r/platforms/opsput/setup.c   |   28 +++++-----
 arch/m32r/platforms/usrv/setup.c     |   18 +++---
 arch/um/Kconfig.common               |    1 +
 arch/um/kernel/irq.c                 |   53 +----------------
 arch/xtensa/Kconfig                  |    6 +-
 arch/xtensa/kernel/irq.c             |  106 +++++++++++-----------------------
 arch/xtensa/platforms/s6105/device.c |    2 +-
 arch/xtensa/variants/s6000/gpio.c    |   45 +++++++-------
 drivers/gpio/adp5588-gpio.c          |    8 +-
 drivers/gpio/gpiolib.c               |   45 --------------
 drivers/gpio/max732x.c               |    8 +-
 drivers/gpio/pca953x.c               |    6 +-
 drivers/gpio/pl061.c                 |   14 ++--
 drivers/gpio/stmpe-gpio.c            |   12 ++--
 drivers/gpio/sx150x.c                |    9 +--
 drivers/gpio/tc3589x-gpio.c          |   12 ++--
 drivers/gpio/timbgpio.c              |   18 +++---
 drivers/gpio/vr41xx_giu.c            |   12 ++--
 include/linux/irq.h                  |    4 +
 include/linux/irqdesc.h              |   45 +++++++++++----
 kernel/irq/Kconfig                   |    4 +
 kernel/irq/irqdesc.c                 |   14 -----
 kernel/irq/proc.c                    |   15 +++++-
 42 files changed, 318 insertions(+), 630 deletions(-)

diff --git a/arch/arm/mach-ep93xx/gpio.c b/arch/arm/mach-ep93xx/gpio.c
index a889fa7..34e071d 100644
--- a/arch/arm/mach-ep93xx/gpio.c
+++ b/arch/arm/mach-ep93xx/gpio.c
@@ -360,52 +360,14 @@ static void ep93xx_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	gpio = ep93xx_chip->chip.base;
 	for (i = 0; i < chip->ngpio; i++, gpio++) {
 		int is_out = data_dir_reg & (1 << i);
+		int irq = gpio_to_irq(gpio);
 
-		seq_printf(s, " %s%d gpio-%-3d (%-12s) %s %s",
+		seq_printf(s, " %s%d gpio-%-3d (%-12s) %s %s %s\n",
 				chip->label, i, gpio,
 				gpiochip_is_requested(chip, i) ? : "",
 				is_out ? "out" : "in ",
-				(data_reg & (1 << i)) ? "hi" : "lo");
-
-		if (!is_out) {
-			int irq = gpio_to_irq(gpio);
-			struct irq_desc *desc = irq_desc + irq;
-
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-						irq, trigger,
-						(desc->status & IRQ_WAKEUP)
-							? " wakeup" : "");
-			}
-		}
-
-		seq_printf(s, "\n");
+				(data_reg & (1<<  i)) ? "hi" : "lo",
+				(!is_out && irq>= 0) ? "(interrupt)" : "");
 	}
 }
 
diff --git a/arch/arm/plat-nomadik/gpio.c b/arch/arm/plat-nomadik/gpio.c
index 7062042..80643bc 100644
--- a/arch/arm/plat-nomadik/gpio.c
+++ b/arch/arm/plat-nomadik/gpio.c
@@ -832,51 +832,6 @@ static void nmk_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 				: "?  ",
 			(mode < 0) ? "unknown" : modes[mode],
 			pull ? "pull" : "none");
-
-		if (!is_out) {
-			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_to_desc(irq);
-
-			/* This races with request_irq(), set_irq_type(),
-			 * and set_irq_wake() ... but those are "rare".
-			 *
-			 * More significantly, trigger type flags aren't
-			 * currently maintained by genirq.
-			 */
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-					irq, trigger,
-					(desc->status & IRQ_WAKEUP)
-						? " wakeup" : "");
-			}
-		}
-
 		seq_printf(s, "\n");
 	}
 }
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index cd2062f..49642b5 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -6,6 +6,11 @@ config AVR32
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_PROBE
+	select HARDIRQS_SW_RESEND
+	select GENERIC_IRQ_SHOW
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -17,9 +22,6 @@ config AVR32
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -29,12 +31,6 @@ config LOCKDEP_SUPPORT
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
-config HARDIRQS_SW_RESEND
-	def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
diff --git a/arch/avr32/boards/atngw100/mrmt.c b/arch/avr32/boards/atngw100/mrmt.c
index 7919be3..f914319 100644
--- a/arch/avr32/boards/atngw100/mrmt.c
+++ b/arch/avr32/boards/atngw100/mrmt.c
@@ -301,7 +301,7 @@ static int __init mrmt1_init(void)
 	/* Select the Touchscreen interrupt pin mode */
 	at32_select_periph( GPIO_PIOB_BASE, 1 << (PB_EXTINT_BASE+TS_IRQ),
 			GPIO_PERIPH_A, AT32_GPIOF_DEGLITCH);
-	set_irq_type( AT32_EXTINT(TS_IRQ), IRQ_TYPE_EDGE_FALLING );
+	irq_set_irq_type(AT32_EXTINT(TS_IRQ), IRQ_TYPE_EDGE_FALLING);
 	at32_spi_setup_slaves(0,spi01_board_info,ARRAY_SIZE(spi01_board_info));
 	spi_register_board_info(spi01_board_info,ARRAY_SIZE(spi01_board_info));
 #endif
diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index 659d119..fafed4c 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -322,6 +322,6 @@ static int __init atngw100_arch_init(void)
 	/* set_irq_type() after the arch_initcall for EIC has run, and
 	 * before the I2C subsystem could try using this IRQ.
 	 */
-	return set_irq_type(AT32_EXTINT(3), IRQ_TYPE_EDGE_FALLING);
+	return irq_set_irq_type(AT32_EXTINT(3), IRQ_TYPE_EDGE_FALLING);
 }
 arch_initcall(atngw100_arch_init);
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index 9604f77..bc3aa18 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -26,40 +26,3 @@ void __weak nmi_disable(void)
 {
 
 }
-
-#ifdef CONFIG_PROC_FS
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *)v, cpu;
-	struct irqaction *action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_puts(p, "           ");
-		for_each_online_cpu(cpu)
-			seq_printf(p, "CPU%d       ", cpu);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
-		if (!action)
-			goto unlock;
-
-		seq_printf(p, "%3d: ", i);
-		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
-		seq_printf(p, "  %s", action->name);
-		for (action = action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-	unlock:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	}
-
-	return 0;
-}
-#endif
diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index e9d1205..47ba4b9 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -61,45 +61,42 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(unsigned int irq)
+static void eic_ack_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_irq(unsigned int irq)
+static void eic_mask_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(unsigned int irq)
+static void eic_mask_ack_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
-	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
+	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(unsigned int irq)
+static void eic_unmask_irq(struct irq_chip *d)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	eic_writel(eic, IER, 1 << (irq - eic->first_irq));
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	eic_writel(eic, IER, 1 << (d->irq - eic->first_irq));
 }
 
-static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
+static int eic_set_irq_type(struct irq_chip *d, unsigned int flow_type)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	struct irq_desc *desc;
+	struct eic *eic = irq_data_get_irq_chip_data(data);
+	unsigned int irq = d->irq;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
-	int ret = 0;
 
 	flow_type &= IRQ_TYPE_SENSE_MASK;
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	desc = &irq_desc[irq];
-
 	mode = eic_readl(eic, MODE);
 	edge = eic_readl(eic, EDGE);
 	level = eic_readl(eic, LEVEL);
@@ -122,39 +119,34 @@ static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
 		edge &= ~(1 << i);
 		break;
 	default:
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-	if (ret == 0) {
-		eic_writel(eic, MODE, mode);
-		eic_writel(eic, EDGE, edge);
-		eic_writel(eic, LEVEL, level);
-
-		if (flow_type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH)) {
-			flow_type |= IRQ_LEVEL;
-			__set_irq_handler_unlocked(irq, handle_level_irq);
-		} else
-			__set_irq_handler_unlocked(irq, handle_edge_irq);
-		desc->status &= ~(IRQ_TYPE_SENSE_MASK | IRQ_LEVEL);
-		desc->status |= flow_type;
-	}
+	eic_writel(eic, MODE, mode);
+	eic_writel(eic, EDGE, edge);
+	eic_writel(eic, LEVEL, level);
 
-	return ret;
+	irqd_set_trigger_type(d, flow_type);
+	if (flow_type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+		__irq_set_handler_locked(irq, handle_level_irq);
+	else
+		__irq_set_handler_locked(irq, handle_edge_irq);
+
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 static struct irq_chip eic_chip = {
 	.name		= "eic",
-	.ack		= eic_ack_irq,
-	.mask		= eic_mask_irq,
-	.mask_ack	= eic_mask_ack_irq,
-	.unmask		= eic_unmask_irq,
-	.set_type	= eic_set_irq_type,
+	.irq_ack	= eic_ack_irq,
+	.irq_mask	= eic_mask_irq,
+	.irq_mask_ack	= eic_mask_ack_irq,
+	.irq_unmask	= eic_unmask_irq,
+	.irq_set_type	= eic_set_irq_type,
 };
 
 static void demux_eic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct eic *eic = desc->handler_data;
+	struct eic *eic = irq_desc_get_handler_data(desc);
 	unsigned long status, pending;
 	unsigned int i;
 
@@ -234,13 +226,13 @@ static int __init eic_probe(struct platform_device *pdev)
 	eic->chip = &eic_chip;
 
 	for (i = 0; i < nr_of_irqs; i++) {
-		set_irq_chip_and_handler(eic->first_irq + i, &eic_chip,
+		irq_set_chip_and_handler(eic->first_irq + i, &eic_chip,
 					 handle_level_irq);
-		set_irq_chip_data(eic->first_irq + i, eic);
+		irq_set_chip_data(eic->first_irq + i, eic);
 	}
 
-	set_irq_chained_handler(int_irq, demux_eic_irq);
-	set_irq_data(int_irq, eic);
+	irq_set_chained_handler(int_irq, demux_eic_irq);
+	irq_set_handler_data(int_irq, eic);
 
 	if (pdev->id == 0) {
 		nmi_eic = eic;
diff --git a/arch/avr32/mach-at32ap/intc.c b/arch/avr32/mach-at32ap/intc.c
index 994c454..21ce35f 100644
--- a/arch/avr32/mach-at32ap/intc.c
+++ b/arch/avr32/mach-at32ap/intc.c
@@ -34,12 +34,12 @@ extern struct platform_device at32_intc0_device;
  * TODO: We may be able to implement mask/unmask by setting IxM flags
  * in the status register.
  */
-static void intc_mask_irq(unsigned int irq)
+static void intc_mask_irq(struct irq_data *d)
 {
 
 }
 
-static void intc_unmask_irq(unsigned int irq)
+static void intc_unmask_irq(struct irq_data *d)
 {
 
 }
@@ -47,8 +47,8 @@ static void intc_unmask_irq(unsigned int irq)
 static struct intc intc0 = {
 	.chip = {
 		.name		= "intc",
-		.mask		= intc_mask_irq,
-		.unmask		= intc_unmask_irq,
+		.irq_mask	= intc_mask_irq,
+		.irq_unmask	= intc_unmask_irq,
 	},
 };
 
@@ -57,7 +57,6 @@ static struct intc intc0 = {
  */
 asmlinkage void do_IRQ(int level, struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	struct pt_regs *old_regs;
 	unsigned int irq;
 	unsigned long status_reg;
@@ -69,8 +68,7 @@ asmlinkage void do_IRQ(int level, struct pt_regs *regs)
 	irq_enter();
 
 	irq = intc_readl(&intc0, INTCAUSE0 - 4 * level);
-	desc = irq_desc + irq;
-	desc->handle_irq(irq, desc);
+	generic_handle_irq(irq);
 
 	/*
 	 * Clear all interrupt level masks so that we may handle
@@ -128,7 +126,7 @@ void __init init_IRQ(void)
 		intc_writel(&intc0, INTPR0 + 4 * i, offset);
 		readback = intc_readl(&intc0, INTPR0 + 4 * i);
 		if (readback == offset)
-			set_irq_chip_and_handler(i, &intc0.chip,
+			irq_set_chip_and_handler(i, &intc0.chip,
 						 handle_simple_irq);
 	}
 
diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index 09a274c..3753410 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -249,23 +249,23 @@ static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 /* GPIO IRQ support */
 
-static void gpio_irq_mask(unsigned irq)
+static void gpio_irq_mask(struct irq_data *d)
 {
-	unsigned		gpio = irq_to_gpio(irq);
+	unsigned		gpio = irq_to_gpio(d->irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
 
 	pio_writel(pio, IDR, 1 << (gpio & 0x1f));
 }
 
-static void gpio_irq_unmask(unsigned irq)
+static void gpio_irq_unmask(struct irq_data *d))
 {
-	unsigned		gpio = irq_to_gpio(irq);
+	unsigned		gpio = irq_to_gpio(d->irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
 
 	pio_writel(pio, IER, 1 << (gpio & 0x1f));
 }
 
-static int gpio_irq_type(unsigned irq, unsigned type)
+static int gpio_irq_type(struct irq_data *d, unsigned type)
 {
 	if (type != IRQ_TYPE_EDGE_BOTH && type != IRQ_TYPE_NONE)
 		return -EINVAL;
@@ -275,20 +275,19 @@ static int gpio_irq_type(unsigned irq, unsigned type)
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "gpio",
-	.mask		= gpio_irq_mask,
-	.unmask		= gpio_irq_unmask,
-	.set_type	= gpio_irq_type,
+	.irq_mask	= gpio_irq_mask,
+	.irq_unmask	= gpio_irq_unmask,
+	.irq_set_type	= gpio_irq_type,
 };
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct pio_device	*pio = get_irq_chip_data(irq);
+	struct pio_device	*pio = get_irq_desc_chip_data(desc);
 	unsigned		gpio_irq;
 
-	gpio_irq = (unsigned) get_irq_data(irq);
+	gpio_irq = (unsigned) irq_get_handler_data(irq);
 	for (;;) {
 		u32		isr;
-		struct irq_desc	*d;
 
 		/* ack pending GPIO interrupts */
 		isr = pio_readl(pio, ISR) & pio_readl(pio, IMR);
@@ -301,9 +300,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 			isr &= ~(1 << i);
 
 			i += gpio_irq;
-			d = &irq_desc[i];
-
-			d->handle_irq(i, d);
+			generic_handle_irq(i);
 		} while (isr);
 	}
 }
@@ -313,16 +310,16 @@ gpio_irq_setup(struct pio_device *pio, int irq, int gpio_irq)
 {
 	unsigned	i;
 
-	set_irq_chip_data(irq, pio);
-	set_irq_data(irq, (void *) gpio_irq);
+	irq_set_chip_data(irq, pio);
+	irq_set_handler_data(irq, (void *)gpio_irq);
 
 	for (i = 0; i < 32; i++, gpio_irq++) {
-		set_irq_chip_data(gpio_irq, pio);
-		set_irq_chip_and_handler(gpio_irq, &gpio_irqchip,
-				handle_simple_irq);
+		irq_set_chip_data(gpio_irq, pio);
+		irq_set_chip_and_handler(gpio_irq, &gpio_irqchip,
+					 handle_simple_irq);
 	}
 
-	set_irq_chained_handler(irq, gpio_irq_handler);
+	irq_set_chained_handler(irq, gpio_irq_handler);
 }
 
 /*--------------------------------------------------------------------------*/
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 6df692d..f94d4e6 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -4,6 +4,7 @@ config H8300
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index 7643d39..1f67fed 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -155,7 +155,7 @@ void __init init_IRQ(void)
 	setup_vector();
 
 	for (c = 0; c < NR_IRQS; c++)
-		set_irq_chip_and_handler(c, &h8300irq_chip, handle_simple_irq);
+		irq_set_chip_and_handler(c, &h8300irq_chip, handle_simple_irq);
 }
 
 asmlinkage void do_IRQ(int irq)
@@ -164,34 +164,3 @@ asmlinkage void do_IRQ(int irq)
 	generic_handle_irq(irq);
 	irq_exit();
 }
-
-#if defined(CONFIG_PROC_FS)
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v;
-	struct irqaction * action;
-	unsigned long flags;
-
-	if (i == 0)
-		seq_puts(p, "           CPU0");
-
-	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
-		if (!action)
-			goto unlock;
-		seq_printf(p, "%3d: ",i);
-		seq_printf(p, "%10u ", kstat_irqs(i));
-		seq_printf(p, " %14s", irq_desc[i].irq_data.chip->name);
-		seq_printf(p, "-%-8s", irq_desc[i].name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-		seq_putc(p, '\n');
-unlock:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	}
-	return 0;
-}
-#endif
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ef4c1e4..ad45b82 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_PROBE
+	select GENERIC_IRQ_SHOW
 
 config SBUS
 	bool
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index 76eaf38..c7272b8 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -18,55 +18,10 @@
 
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
-#include <linux/seq_file.h>
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
 /*
- * Generic, controller-independent functions:
- */
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, j;
-	struct irqaction * action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "           ");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%d       ",j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ",i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
-		seq_printf(p, " %14s", desc->irq_data.chip->name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-skip:
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	}
-	return 0;
-}
-
-/*
  * do_IRQ handles all normal device IRQs (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
index 4a693d0..34671d3 100644
--- a/arch/m32r/platforms/m32104ut/setup.c
+++ b/arch/m32r/platforms/m32104ut/setup.c
@@ -76,7 +76,7 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32104UT-LAN (SMC91C111)*/
-	set_irq_chip_and_handler(M32R_IRQ_INT0, &m32104ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT0, &m32104ut_irq_type,
 				 handle_level_irq);
 	/* "H" level sense */
 	cu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11;
@@ -84,20 +84,20 @@ void __init init_IRQ(void)
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &m32104ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &m32104ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &m32104ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &m32104ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &m32104ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &m32104ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_S);
diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index 2074bcc..1053e1c 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -259,76 +259,76 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32700UT-LAN (SMC91C111)*/
-	set_irq_chip_and_handler(M32700UT_LAN_IRQ_LAN,
+	irq_set_chip_and_handler(M32700UT_LAN_IRQ_LAN,
 				 &m32700ut_lanpld_irq_type, handle_level_irq);
 	lanpld_icu_data[irq2lanpldirq(M32700UT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_m32700ut_lanpld_irq(M32700UT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32700ut_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	set_irq_chip_and_handler(M32R_IRQ_DMA1, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_DMA1, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_EJECT);
@@ -349,7 +349,7 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
-	set_irq_chip_and_handler(M32700UT_LCD_IRQ_USB_INT1,
+	irq_set_chip_and_handler(M32700UT_LCD_IRQ_USB_INT1,
 				 &m32700ut_lcdpld_irq_type, handle_level_irq);
 
 	lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
@@ -366,7 +366,7 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	set_irq_chip_and_handler(M32R_IRQ_INT3, &m32700ut_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT3, &m32700ut_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_m32700ut_irq(M32R_IRQ_INT3);
diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
index cdd8c45..35130ac 100644
--- a/arch/m32r/platforms/mappi/setup.c
+++ b/arch/m32r/platforms/mappi/setup.c
@@ -75,39 +75,39 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT0 : LAN controller (RTL8019AS) */
-	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT0, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
@@ -115,13 +115,13 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_M32R_PCC)
 	/* INT1 : pccard0 interrupt */
-	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT1, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT1);
 
 	/* INT2 : pccard1 interrupt */
-	set_irq_chip_and_handler(M32R_IRQ_INT2, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT2, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT2].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT2);
diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
index 9117c30..f3ed6b6 100644
--- a/arch/m32r/platforms/mappi2/setup.c
+++ b/arch/m32r/platforms/mappi2/setup.c
@@ -76,38 +76,38 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT0, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi2_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_S);
@@ -115,27 +115,27 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi2_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT1, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* ICUCR40: CFC IREQ */
-	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &mappi2_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFIREQ, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi2_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi2_irq(PLD_IRQ_CFC_INSERT);
 
 	/* ICUCR42: CFC Eject */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &mappi2_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_EJECT, &mappi2_irq_type,
 				 handle_level_irq);
 	icu_data[PLD_IRQ_CFC_EJECT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(PLD_IRQ_CFC_EJECT);
diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
index b44f5de..2408e35 100644
--- a/arch/m32r/platforms/mappi3/setup.c
+++ b/arch/m32r/platforms/mappi3/setup.c
@@ -75,38 +75,38 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT0, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi3_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_S);
@@ -114,21 +114,21 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi3_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT1, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* CFC IREQ */
-	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &mappi3_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFIREQ, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert & eject */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi3_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi3_irq(PLD_IRQ_CFC_INSERT);
@@ -136,7 +136,7 @@ void __init init_IRQ(void)
 #endif /* CONFIG_M32R_CFC */
 
 	/* IDE IREQ */
-	set_irq_chip_and_handler(PLD_IRQ_IDEIREQ, &mappi3_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_IDEIREQ, &mappi3_irq_type,
 				 handle_level_irq);
 	icu_data[PLD_IRQ_IDEIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(PLD_IRQ_IDEIREQ);
diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
index 19a02db..83b46b0 100644
--- a/arch/m32r/platforms/oaks32r/setup.c
+++ b/arch/m32r/platforms/oaks32r/setup.c
@@ -74,39 +74,39 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT3 : LAN controller (RTL8019AS) */
-	set_irq_chip_and_handler(M32R_IRQ_INT3, &oaks32r_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT3, &oaks32r_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_oaks32r_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &oaks32r_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &oaks32r_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_oaks32r_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &oaks32r_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &oaks32r_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &oaks32r_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &oaks32r_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &oaks32r_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &oaks32r_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &oaks32r_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &oaks32r_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_S);
diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
index 1273154..3266070 100644
--- a/arch/m32r/platforms/opsput/setup.c
+++ b/arch/m32r/platforms/opsput/setup.c
@@ -259,76 +259,76 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on OPSPUT-LAN (SMC91C111)*/
-	set_irq_chip_and_handler(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type,
+	irq_set_chip_and_handler(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type,
 				 handle_level_irq);
 	lanpld_icu_data[irq2lanpldirq(OPSPUT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_opsput_lanpld_irq(OPSPUT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_opsput_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	set_irq_chip_and_handler(M32R_IRQ_DMA1, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_DMA1, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &opsput_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFIREQ, &opsput_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_EJECT);
@@ -349,7 +349,7 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR);	/* USBCR: non-OTG */
-	set_irq_chip_and_handler(OPSPUT_LCD_IRQ_USB_INT1,
+	irq_set_chip_and_handler(OPSPUT_LCD_IRQ_USB_INT1,
 				 &opsput_lcdpld_irq_type, handle_level_irq);
 	lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
 	disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
@@ -365,7 +365,7 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	set_irq_chip_and_handler(M32R_IRQ_INT3, &opsput_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_INT3, &opsput_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_opsput_irq(M32R_IRQ_INT3);
diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index f3cff26..0c7a1e8 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -138,32 +138,32 @@ void __init init_IRQ(void)
 		once++;
 
 	/* MFT2 : system timer */
-	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #if defined(CONFIG_SERIAL_M32R_SIO)
 	/* SIO0_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
+	irq_set_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
 				 handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
@@ -171,7 +171,7 @@ void __init init_IRQ(void)
 
 	/* INT#67-#71: CFC#0 IREQ on PLD */
 	for (i = 0 ; i < CONFIG_M32R_CFC_NUM ; i++ ) {
-		set_irq_chip_and_handler(PLD_IRQ_CF0 + i,
+		irq_set_chip_and_handler(PLD_IRQ_CF0 + i,
 					 &m32700ut_pld_irq_type,
 					 handle_level_irq);
 		pld_icu_data[irq2pldirq(PLD_IRQ_CF0 + i)].icucr
@@ -181,14 +181,14 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* INT#76: 16552D#0 IREQ on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_UART0, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_UART0, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART0)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART0);
 
 	/* INT#77: 16552D#1 IREQ on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_UART1, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_UART1, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART1)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
@@ -197,7 +197,7 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
 	/* INT#80: AK4524 IREQ on PLD */
-	set_irq_chip_and_handler(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type,
+	irq_set_chip_and_handler(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type,
 				 handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
 		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 1e78940..109ddc0 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -8,6 +8,7 @@ config UML
 	default y
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_HARDIRQS_NO_DEPRECATED
+	select GENERIC_IRQ_SHOW
 
 config MMU
 	bool
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 64cfea8..9e485c7 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -18,52 +18,6 @@
 #include "os.h"
 
 /*
- * Generic, controller-independent functions:
- */
-
-int show_interrupts(struct seq_file *p, void *v)
-{
-	int i = *(loff_t *) v, j;
-	struct irqaction * action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "           ");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%d       ",j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		raw_spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ",i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
-		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-skip:
-		raw_spin_unlock_irqrestore(&desc->lock, flags);
-	} else if (i == NR_IRQS)
-		seq_putc(p, '\n');
-
-	return 0;
-}
-
-/*
  * This list is accessed under irq_lock, except in sigio_handler,
  * where it is safe from being modified.  IRQ handlers won't change it -
  * if an IRQ source has vanished, it will be freed by free_irqs just
@@ -390,11 +344,10 @@ void __init init_IRQ(void)
 {
 	int i;
 
-	set_irq_chip_and_handler(TIMER_IRQ, &SIGVTALRM_irq_type, handle_edge_irq);
+	irq_set_chip_and_handler(TIMER_IRQ, &SIGVTALRM_irq_type, handle_edge_irq);
 
-	for (i = 1; i < NR_IRQS; i++) {
-		set_irq_chip_and_handler(i, &normal_irq_type, handle_edge_irq);
-	}
+	for (i = 1; i < NR_IRQS; i++)
+		irq_set_chip_and_handler(i, &normal_irq_type, handle_edge_irq);
 }
 
 /*
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d373d15..d0ecf7e 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -7,6 +7,9 @@ config ZONE_DMA
 config XTENSA
 	def_bool y
 	select HAVE_IDE
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_SHOW
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
@@ -24,9 +27,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_HARDIRQS
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 8750888..d77089d 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -35,7 +35,6 @@ atomic_t irq_err_count;
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc = irq_desc + irq;
 
 	if (irq >= NR_IRQS) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -57,104 +56,69 @@ asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 			       sp - sizeof(struct thread_info));
 	}
 #endif
-	desc->handle_irq(irq, desc);
+	generic_handle_irq(irq);
 
 	irq_exit();
 	set_irq_regs(old_regs);
 }
 
-/*
- * Generic, controller-independent functions:
- */
-
-int show_interrupts(struct seq_file *p, void *v)
+int arch_show_interrupts(struct seq_file *p, int prec)
 {
-	int i = *(loff_t *) v, j;
-	struct irqaction * action;
-	unsigned long flags;
-
-	if (i == 0) {
-		seq_printf(p, "           ");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%d       ",j);
-		seq_putc(p, '\n');
-	}
-
-	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
-		if (!action)
-			goto skip;
-		seq_printf(p, "%3d: ",i);
-#ifndef CONFIG_SMP
-		seq_printf(p, "%10u ", kstat_irqs(i));
-#else
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
-		seq_printf(p, "  %s", action->name);
-
-		for (action=action->next; action; action = action->next)
-			seq_printf(p, ", %s", action->name);
-
-		seq_putc(p, '\n');
-skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
-	} else if (i == NR_IRQS) {
-		seq_printf(p, "NMI: ");
-		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", nmi_count(j));
-		seq_putc(p, '\n');
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
-	}
+	int j;
+
+	seq_printf(p, "%*s: ", prec, "NMI");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", nmi_count(j));
+	seq_putc(p, '\n');
+	seq_printf(p, "%*s: ", prec, "ERR");
+	seq_printf(p, "%10u\n", atomic_read(&irq_err_count));
 	return 0;
 }
 
-static void xtensa_irq_mask(unsigned int irq)
+static void xtensa_irq_mask(struct irq_chip *d)
 {
-	cached_irq_mask &= ~(1 << irq);
+	cached_irq_mask &= ~(1 << d->irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(unsigned int irq)
+static void xtensa_irq_unmask(struct irq_chip *d)
 {
-	cached_irq_mask |= 1 << irq;
+	cached_irq_mask |= 1 << d->irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_enable(unsigned int irq)
+static void xtensa_irq_enable(struct irq_chip *d)
 {
-	variant_irq_enable(irq);
-	xtensa_irq_unmask(irq);
+	variant_irq_enable(d->irq);
+	xtensa_irq_unmask(d->irq);
 }
 
-static void xtensa_irq_disable(unsigned int irq)
+static void xtensa_irq_disable(struct irq_chip *d)
 {
-	xtensa_irq_mask(irq);
-	variant_irq_disable(irq);
+	xtensa_irq_mask(d->irq);
+	variant_irq_disable(d->irq);
 }
 
-static void xtensa_irq_ack(unsigned int irq)
+static void xtensa_irq_ack(struct irq_chip *d)
 {
-	set_sr(1 << irq, INTCLEAR);
+	set_sr(1 << d->irq, INTCLEAR);
 }
 
-static int xtensa_irq_retrigger(unsigned int irq)
+static int xtensa_irq_retrigger(struct irq_chip *d)
 {
-	set_sr (1 << irq, INTSET);
+	set_sr (1 << d->irq, INTSET);
 	return 1;
 }
 
 
 static struct irq_chip xtensa_irq_chip = {
 	.name		= "xtensa",
-	.enable		= xtensa_irq_enable,
-	.disable	= xtensa_irq_disable,
-	.mask		= xtensa_irq_mask,
-	.unmask		= xtensa_irq_unmask,
-	.ack		= xtensa_irq_ack,
-	.retrigger	= xtensa_irq_retrigger,
+	.irq_enable	= xtensa_irq_enable,
+	.irq_disable	= xtensa_irq_disable,
+	.irq_mask	= xtensa_irq_mask,
+	.irq_unmask	= xtensa_irq_unmask,
+	.irq_ack	= xtensa_irq_ack,
+	.irq_retrigger	= xtensa_irq_retrigger,
 };
 
 void __init init_IRQ(void)
@@ -165,25 +129,25 @@ void __init init_IRQ(void)
 		int mask = 1 << index;
 
 		if (mask & XCHAL_INTTYPE_MASK_SOFTWARE)
-			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+			irq_set_chip_and_handler(index, &xtensa_irq_chip,
 						 handle_simple_irq);
 
 		else if (mask & XCHAL_INTTYPE_MASK_EXTERN_EDGE)
-			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+			irq_set_chip_and_handler(index, &xtensa_irq_chip,
 						 handle_edge_irq);
 
 		else if (mask & XCHAL_INTTYPE_MASK_EXTERN_LEVEL)
-			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+			irq_set_chip_and_handler(index, &xtensa_irq_chip,
 						 handle_level_irq);
 
 		else if (mask & XCHAL_INTTYPE_MASK_TIMER)
-			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+			irq_set_chip_and_handler(index, &xtensa_irq_chip,
 						 handle_edge_irq);
 
 		else	/* XCHAL_INTTYPE_MASK_WRITE_ERROR */
 			/* XCHAL_INTTYPE_MASK_NMI */
 
-			set_irq_chip_and_handler(index, &xtensa_irq_chip,
+			irq_set_chip_and_handler(index, &xtensa_irq_chip,
 						 handle_level_irq);
 	}
 
diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 65333ff..4f4fc97 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -120,7 +120,7 @@ static int __init prepare_phy_irq(int pin)
 	irq = gpio_to_irq(pin);
 	if (irq < 0)
 		goto free;
-	if (set_irq_type(irq, IRQ_TYPE_LEVEL_LOW) < 0)
+	if (irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW) < 0)
 		goto free;
 	return irq;
 free:
diff --git a/arch/xtensa/variants/s6000/gpio.c b/arch/xtensa/variants/s6000/gpio.c
index 380a70f..7af0757 100644
--- a/arch/xtensa/variants/s6000/gpio.c
+++ b/arch/xtensa/variants/s6000/gpio.c
@@ -85,30 +85,29 @@ int s6_gpio_init(u32 afsel)
 	return gpiochip_add(&gpiochip);
 }
 
-static void ack(unsigned int irq)
+static void ack(struct irq_data *d)
 {
-	writeb(1 << (irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
+	writeb(1 << (d->irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
 }
 
-static void mask(unsigned int irq)
+static void mask(struct irq_data *d)
 {
 	u8 r = readb(S6_REG_GPIO + S6_GPIO_IE);
-	r &= ~(1 << (irq - IRQ_BASE));
+	r &= ~(1 << (d->irq - IRQ_BASE));
 	writeb(r, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static void unmask(unsigned int irq)
+static void unmask(struct irq_data *d)
 {
 	u8 m = readb(S6_REG_GPIO + S6_GPIO_IE);
-	m |= 1 << (irq - IRQ_BASE);
+	m |= 1 << (d->irq - IRQ_BASE);
 	writeb(m, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static int set_type(unsigned int irq, unsigned int type)
+static int set_type(struct irq_data *d, unsigned int type)
 {
-	const u8 m = 1 << (irq - IRQ_BASE);
+	const u8 m = 1 << (d->irq - IRQ_BASE);
 	irq_flow_handler_t handler;
-	struct irq_desc *desc;
 	u8 reg;
 
 	if (type == IRQ_TYPE_PROBE) {
@@ -129,8 +128,7 @@ static int set_type(unsigned int irq, unsigned int type)
 		handler = handle_edge_irq;
 	}
 	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IS);
-	desc = irq_to_desc(irq);
-	desc->handle_irq = handler;
+	__irq_set_handler_locked(irq, handler);
 
 	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IEV);
 	if (type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING))
@@ -150,22 +148,23 @@ static int set_type(unsigned int irq, unsigned int type)
 
 static struct irq_chip gpioirqs = {
 	.name = "GPIO",
-	.ack = ack,
-	.mask = mask,
-	.unmask = unmask,
-	.set_type = set_type,
+	.irq_ack = ack,
+	.irq_mask = mask,
+	.irq_unmask = unmask,
+	.irq_set_type = set_type,
 };
 
 static u8 demux_masks[4];
 
 static void demux_irqs(unsigned int irq, struct irq_desc *desc)
 {
-	u8 *mask = get_irq_desc_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	u8 *mask = irq_desc_get_handler_data(desc);
 	u8 pending;
 	int cirq;
 
-	desc->chip->mask(irq);
-	desc->chip->ack(irq);
+	chip->irq_mask(&desc->irq_data);
+	chip->irq_ack(&desc->irq_data));
 	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
 	cirq = IRQ_BASE - 1;
 	while (pending) {
@@ -174,7 +173,7 @@ static void demux_irqs(unsigned int irq, struct irq_desc *desc)
 		pending >>= n;
 		generic_handle_irq(cirq);
 	}
-	desc->chip->unmask(irq);
+	chip->irq_unmask(&desc->irq_data));
 }
 
 extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];
@@ -219,11 +218,11 @@ void __init variant_init_irq(void)
 				i = ffs(mask);
 				cirq += i;
 				mask >>= i;
-				set_irq_chip(cirq, &gpioirqs);
-				set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
+				irq_set_chip(cirq, &gpioirqs);
+				irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
 			} while (mask);
-			set_irq_data(irq, demux_masks + n);
-			set_irq_chained_handler(irq, demux_irqs);
+			irq_set_handler_data(irq, demux_masks + n);
+			irq_set_chained_handler(irq, demux_irqs);
 			if (++n == ARRAY_SIZE(demux_masks))
 				break;
 		}
diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
index 33fc685..3525ad9 100644
--- a/drivers/gpio/adp5588-gpio.c
+++ b/drivers/gpio/adp5588-gpio.c
@@ -289,10 +289,10 @@ static int adp5588_irq_setup(struct adp5588_gpio *dev)
 
 	for (gpio = 0; gpio < dev->gpio_chip.ngpio; gpio++) {
 		int irq = gpio + dev->irq_base;
-		set_irq_chip_data(irq, dev);
-		set_irq_chip_and_handler(irq, &adp5588_irq_chip,
+		irq_set_chip_data(irq, dev);
+		irq_set_chip_and_handler(irq, &adp5588_irq_chip,
 					 handle_level_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		/*
 		 * ARM needs us to explicitly flag the IRQ as VALID,
@@ -300,7 +300,7 @@ static int adp5588_irq_setup(struct adp5588_gpio *dev)
 		 */
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 649550e..36a2974 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1656,51 +1656,6 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ");
-
-		if (!is_out) {
-			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_to_desc(irq);
-
-			/* This races with request_irq(), set_irq_type(),
-			 * and set_irq_wake() ... but those are "rare".
-			 *
-			 * More significantly, trigger type flags aren't
-			 * currently maintained by genirq.
-			 */
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-					irq, trigger,
-					(desc->status & IRQ_WAKEUP)
-						? " wakeup" : "");
-			}
-		}
-
 		seq_printf(s, "\n");
 	}
 }
diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
index 9e1d01f..ad6951e 100644
--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/max732x.c
@@ -470,14 +470,14 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 			if (!(chip->dir_input & (1 << lvl)))
 				continue;
 
-			set_irq_chip_data(irq, chip);
-			set_irq_chip_and_handler(irq, &max732x_irq_chip,
+			irq_set_chip_data(irq, chip);
+			irq_set_chip_and_handler(irq, &max732x_irq_chip,
 						 handle_edge_irq);
-			set_irq_nested_thread(irq, 1);
+			irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
-			set_irq_noprobe(irq);
+			irq_set_noprobe(irq);
 #endif
 		}
 
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 2fc25de..583e925 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -395,13 +395,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
 			int irq = lvl + chip->irq_base;
 
-			set_irq_chip_data(irq, chip);
-			set_irq_chip_and_handler(irq, &pca953x_irq_chip,
+			irq_set_chip_data(irq, chip);
+			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
 						 handle_edge_irq);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
-			set_irq_noprobe(irq);
+			irq_set_noprobe(irq);
 #endif
 		}
 
diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index 838ddbd..6fcb28c 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -210,7 +210,7 @@ static struct irq_chip pl061_irqchip = {
 
 static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct list_head *chip_list = get_irq_data(irq);
+	struct list_head *chip_list = irq_get_handler_data(irq);
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
@@ -294,7 +294,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 		ret = -ENODEV;
 		goto iounmap;
 	}
-	set_irq_chained_handler(irq, pl061_irq_handler);
+	irq_set_chained_handler(irq, pl061_irq_handler);
 	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
 		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
 		if (chip_list == NULL) {
@@ -303,9 +303,9 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 			goto iounmap;
 		}
 		INIT_LIST_HEAD(chip_list);
-		set_irq_data(irq, chip_list);
+		irq_set_handler_data(irq, chip_list);
 	} else
-		chip_list = get_irq_data(irq);
+		chip_list = irq_get_handler_data(irq);
 	list_add(&chip->list, chip_list);
 
 	for (i = 0; i < PL061_GPIO_NR; i++) {
@@ -315,10 +315,10 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 		else
 			pl061_direction_input(&chip->gc, i);
 
-		set_irq_chip(i+chip->irq_base, &pl061_irqchip);
-		set_irq_handler(i+chip->irq_base, handle_simple_irq);
+		irq_set_chip_and_handler(i + chip->irq_base, &pl061_irqchip,
+					 handle_simple_irq);
 		set_irq_flags(i+chip->irq_base, IRQF_VALID);
-		set_irq_chip_data(i+chip->irq_base, chip);
+		irq_set_chip_data(i + chip->irq_base, chip);
 	}
 
 	return 0;
diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index eb2901f..4c980b5 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -254,14 +254,14 @@ static int __devinit stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
 	int irq;
 
 	for (irq = base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
-		set_irq_chip_data(irq, stmpe_gpio);
-		set_irq_chip_and_handler(irq, &stmpe_gpio_irq_chip,
+		irq_set_chip_data(irq, stmpe_gpio);
+		irq_set_chip_and_handler(irq, &stmpe_gpio_irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -277,8 +277,8 @@ static void stmpe_gpio_irq_remove(struct stmpe_gpio *stmpe_gpio)
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
diff --git a/drivers/gpio/sx150x.c b/drivers/gpio/sx150x.c
index d2f874c..a4f7353 100644
--- a/drivers/gpio/sx150x.c
+++ b/drivers/gpio/sx150x.c
@@ -551,12 +551,12 @@ static int sx150x_install_irq_chip(struct sx150x_chip *chip,
 
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = irq_base + n;
-		set_irq_chip_and_handler(irq, &chip->irq_chip, handle_edge_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_chip_and_handler(irq, &chip->irq_chip, handle_edge_irq);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -583,8 +583,7 @@ static void sx150x_remove_irq_chip(struct sx150x_chip *chip)
 
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = chip->irq_base + n;
-		set_irq_handler(irq, NULL);
-		set_irq_chip(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
 	}
 }
 
diff --git a/drivers/gpio/tc3589x-gpio.c b/drivers/gpio/tc3589x-gpio.c
index 27200af..2a82e89 100644
--- a/drivers/gpio/tc3589x-gpio.c
+++ b/drivers/gpio/tc3589x-gpio.c
@@ -239,14 +239,14 @@ static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio)
 	int irq;
 
 	for (irq = base; irq < base + tc3589x_gpio->chip.ngpio; irq++) {
-		set_irq_chip_data(irq, tc3589x_gpio);
-		set_irq_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
+		irq_set_chip_data(irq, tc3589x_gpio);
+		irq_set_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -262,8 +262,8 @@ static void tc3589x_gpio_irq_remove(struct tc3589x_gpio *tc3589x_gpio)
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index 58c8f30..0265872 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -195,7 +195,7 @@ out:
 
 static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_data(irq);
+	struct timbgpio *tgpio = irq_get_handler_data(irq);
 	unsigned long ipr;
 	int offset;
 
@@ -291,16 +291,16 @@ static int __devinit timbgpio_probe(struct platform_device *pdev)
 		return 0;
 
 	for (i = 0; i < pdata->nr_pins; i++) {
-		set_irq_chip_and_handler_name(tgpio->irq_base + i,
+		irq_set_chip_and_handler_name(tgpio->irq_base + i,
 			&timbgpio_irqchip, handle_simple_irq, "mux");
-		set_irq_chip_data(tgpio->irq_base + i, tgpio);
+		irq_set_chip_data(tgpio->irq_base + i, tgpio);
 #ifdef CONFIG_ARM
 		set_irq_flags(tgpio->irq_base + i, IRQF_VALID | IRQF_PROBE);
 #endif
 	}
 
-	set_irq_data(irq, tgpio);
-	set_irq_chained_handler(irq, timbgpio_irq);
+	irq_set_handler_data(irq, tgpio);
+	irq_set_chained_handler(irq, timbgpio_irq);
 
 	return 0;
 
@@ -327,12 +327,12 @@ static int __devexit timbgpio_remove(struct platform_device *pdev)
 	if (irq >= 0 && tgpio->irq_base > 0) {
 		int i;
 		for (i = 0; i < pdata->nr_pins; i++) {
-			set_irq_chip(tgpio->irq_base + i, NULL);
-			set_irq_chip_data(tgpio->irq_base + i, NULL);
+			irq_set_chip(tgpio->irq_base + i, NULL);
+			irq_set_chip_data(tgpio->irq_base + i, NULL);
 		}
 
-		set_irq_handler(irq, NULL);
-		set_irq_data(irq, NULL);
+		irq_set_handler(irq, NULL);
+		irq_set_handler_data(irq, NULL);
 	}
 
 	err = gpiochip_remove(&tgpio->gpio);
diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index cffa3bd..a365be0 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -238,13 +238,13 @@ void vr41xx_set_irq_trigger(unsigned int pin, irq_trigger_t trigger,
 					break;
 				}
 			}
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_low_irq_chip,
 						 handle_edge_irq);
 		} else {
 			giu_clear(GIUINTTYPL, mask);
 			giu_clear(GIUINTHTSELL, mask);
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_low_irq_chip,
 						 handle_level_irq);
 		}
@@ -273,13 +273,13 @@ void vr41xx_set_irq_trigger(unsigned int pin, irq_trigger_t trigger,
 					break;
 				}
 			}
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_high_irq_chip,
 						 handle_edge_irq);
 		} else {
 			giu_clear(GIUINTTYPH, mask);
 			giu_clear(GIUINTHTSELH, mask);
-			set_irq_chip_and_handler(GIU_IRQ(pin),
+			irq_set_chip_and_handler(GIU_IRQ(pin),
 						 &giuint_high_irq_chip,
 						 handle_level_irq);
 		}
@@ -539,9 +539,9 @@ static int __devinit giu_probe(struct platform_device *pdev)
 			chip = &giuint_high_irq_chip;
 
 		if (trigger & (1 << pin))
-			set_irq_chip_and_handler(i, chip, handle_edge_irq);
+			irq_set_chip_and_handler(i, chip, handle_edge_irq);
 		else
-			set_irq_chip_and_handler(i, chip, handle_level_irq);
+			irq_set_chip_and_handler(i, chip, handle_level_irq);
 
 	}
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1d3577f..5d876c9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -28,6 +28,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
 
+struct seq_file;
 struct irq_desc;
 struct irq_data;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
@@ -270,6 +271,7 @@ static inline bool irqd_can_move_in_process_context(struct irq_data *d)
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
+ * @irq_print_chip:	optional to print special chip info in show_interrupts
  * @flags:		chip specific flags
  *
  * @release:		release function solely used by UML
@@ -317,6 +319,8 @@ struct irq_chip {
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
 
+	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
+
 	unsigned long	flags;
 
 	/* Currently used only by UML, might disappear one day.*/
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 0021837..15e6c39 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -100,13 +100,6 @@ struct irq_desc {
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
 
-/* Will be removed once the last users in power and sh are gone */
-extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
-static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
-{
-	return desc;
-}
-
 #ifdef CONFIG_GENERIC_HARDIRQS
 
 static inline struct irq_data *irq_desc_get_irq_data(struct irq_desc *desc)
@@ -178,24 +171,52 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
-static inline int irq_balancing_disabled(unsigned int irq)
+/* caller has locked the irq_desc and both params are valid */
+static inline void __irq_set_handler_locked(unsigned int irq,
+					    irq_flow_handler_t handler)
 {
 	struct irq_desc *desc;
 
 	desc = irq_to_desc(irq);
-	return desc->status & IRQ_NO_BALANCING_MASK;
+	desc->handle_irq = handler;
 }
-#endif
 
 /* caller has locked the irq_desc and both params are valid */
+static inline void
+__irq_set_chip_handler_name_locked(unsigned int irq, struct irq_chip *chip,
+				   irq_flow_handler_t handler, const char *name)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	irq_desc_get_irq_data(desc)->chip = chip;
+	desc->handle_irq = handler;
+	desc->name = name;
+}
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 static inline void __set_irq_handler_unlocked(int irq,
 					      irq_flow_handler_t handler)
 {
+	__irq_set_handler_locked(irq, handler);
+}
+
+static inline int irq_balancing_disabled(unsigned int irq)
+{
 	struct irq_desc *desc;
 
 	desc = irq_to_desc(irq);
-	desc->handle_irq = handler;
+	return desc->status & IRQ_NO_BALANCING_MASK;
+}
+#endif
+
+static inline void
+irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc)
+		lockdep_set_class(&desc->lock, class);
 }
 
 #ifdef CONFIG_IRQ_PREFLOW_FASTEOI
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 09bef82..00f2c03 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -31,6 +31,10 @@ config GENERIC_IRQ_PROBE
 config GENERIC_IRQ_SHOW
        bool
 
+# Print level/edge extra information
+config GENERIC_IRQ_SHOW_LEVEL
+       bool
+
 # Support for delayed migration from interrupt context
 config GENERIC_PENDING_IRQ
 	bool
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index dbccc79..6fb014f 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -198,15 +198,6 @@ err:
 	return -ENOMEM;
 }
 
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	int res = irq_alloc_descs(irq, irq, 1, node);
-
-	if (res == -EEXIST || res == irq)
-		return irq_to_desc(irq);
-	return NULL;
-}
-
 static int irq_expand_nr_irqs(unsigned int nr)
 {
 	if (nr > IRQ_BITMAP_BITS)
@@ -283,11 +274,6 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
-{
-	return irq_to_desc(irq);
-}
-
 static void free_desc(unsigned int irq)
 {
 	dynamic_irq_cleanup(irq);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 760248d..626d092 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -404,7 +404,20 @@ int show_interrupts(struct seq_file *p, void *v)
 	seq_printf(p, "%*d: ", prec, i);
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-	seq_printf(p, " %8s", desc->irq_data.chip->name);
+
+	if (desc->irq_data.chip) {
+		if (desc->irq_data.chip->irq_print_chip)
+			desc->irq_data.chip->irq_print_chip(&desc->irq_data, p);
+		else if (desc->irq_data.chip->name)
+			seq_printf(p, " %8s", desc->irq_data.chip->name);
+		else
+			seq_printf(p, " %8s", "-");
+	} else {
+		seq_printf(p, " %8s", "None");
+	}
+#ifdef CONFIG_GENIRC_IRQ_SHOW_LEVEL
+	seq_printf(p, " %-8s", irqd_is_level_type(&desc->irq_data) ? "Level" : "Edge");
+#endif
 	if (desc->name)
 		seq_printf(p, "-%-8s", desc->name);
 
