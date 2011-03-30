Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1C3Ov6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:51:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:50709 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab1C3Ov4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:51:56 -0400
Date: Wed, 30 Mar 2011 16:51:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq fixes for .39.rc
Message-ID: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6>
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

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Fallout of the conversion and some leftovers removed.

Thanks,

	tglx

P.S.: Just noticed that I still have a few msg ids there, but I prefer
to get slapped for this rather than for rebasing the whole lot :)

------------------>
Grant Likely (1):
      arm: versatile : Fix typo introduced in irq namespace cleanup

Richard Cochran (1):
      powerpc: qe_ic: Rename get_irq_desc_data and get_irq_desc_chip

Thomas Gleixner (8):
      genirq: Fix misnamed label in handle_edge_eoi_irq
      x86: apb_timer: Fixup genirq fallout
      sh: Fix irq cleanup fallout
      genirq: Remove now obsolete set_irq_wake()
      genirq: Remove obsolete comment
      sound: Fixup the last user of the old irq functions
      genirq: Remove the now obsolete config options and select statements
      avr32: Fix missing irq namespace conversion


 arch/alpha/Kconfig               |    1 -
 arch/arm/mach-versatile/core.c   |    2 +-
 arch/avr32/Kconfig               |    1 -
 arch/avr32/mach-at32ap/pio.c     |    2 +-
 arch/blackfin/Kconfig            |    1 -
 arch/cris/Kconfig                |    1 -
 arch/frv/Kconfig                 |    1 -
 arch/h8300/Kconfig               |    1 -
 arch/m32r/Kconfig                |    1 -
 arch/m68k/Kconfig                |    1 -
 arch/microblaze/Kconfig          |    1 -
 arch/mn10300/Kconfig             |    1 -
 arch/parisc/Kconfig              |    1 -
 arch/powerpc/Kconfig             |    1 -
 arch/powerpc/include/asm/qe_ic.h |   16 ++++++++--------
 arch/score/Kconfig               |    1 -
 arch/sh/Kconfig                  |    1 -
 arch/sparc/Kconfig               |    1 -
 arch/tile/Kconfig                |    1 -
 arch/um/Kconfig.common           |    1 -
 arch/unicore32/Kconfig           |    1 -
 arch/x86/kernel/apb_timer.c      |    2 +-
 arch/xtensa/Kconfig              |    1 -
 drivers/sh/intc/internals.h      |    4 ++--
 include/linux/interrupt.h        |    8 --------
 include/linux/irq.h              |    7 -------
 kernel/irq/Kconfig               |    3 ---
 kernel/irq/chip.c                |    2 +-
 sound/soc/soc-jack.c             |    2 +-
 29 files changed, 15 insertions(+), 52 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index bd4160c..9808998 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -12,7 +12,6 @@ config ALPHA
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 96e59e3..eb7ffa0 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -314,7 +314,7 @@ static struct mmci_platform_data mmc0_plat_data = {
 	.gpio_cd	= -1,
 };
 
-static struct resource chalcd_resources[] = {
+static struct resource char_lcd_resources[] = {
 	{
 		.start = VERSATILE_CHAR_LCD_BASE,
 		.end   = (VERSATILE_CHAR_LCD_BASE + SZ_4K - 1),
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 49642b5..e9d689b 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,7 +10,6 @@ config AVR32
 	select GENERIC_IRQ_PROBE
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index 3753410..f308e1d 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -282,7 +282,7 @@ static struct irq_chip gpio_irqchip = {
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct pio_device	*pio = get_irq_desc_chip_data(desc);
+	struct pio_device	*pio = irq_desc_get_chip_data(desc);
 	unsigned		gpio_irq;
 
 	gpio_irq = (unsigned) irq_get_handler_data(irq);
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 672c216..8addb12 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -34,7 +34,6 @@ config BLACKFIN
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU if SMP
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 617925d..a6d0306 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -55,7 +55,6 @@ config CRIS
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 
 config HZ
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 6db8aea..064f621 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -7,7 +7,6 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config ZONE_DMA
 	bool
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 931a1ac..e20322f 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -3,7 +3,6 @@ config H8300
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 
 config SYMBOL_PREFIX
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index b28d090..736b808 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -8,7 +8,6 @@ config M32R
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6e056d3..75531da 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -5,7 +5,6 @@ config M68K
 	select HAVE_AOUT if MMU
 	select GENERIC_ATOMIC64 if MMU
 	select HAVE_GENERIC_HARDIRQS if !MMU
-	select GENERIC_HARDIRQS_NO_DEPRECATED if !MMU
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index c49c326..851b3bf 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -17,7 +17,6 @@ config MICROBLAZE
 	select OF_EARLY_FLATTREE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 
 config SWAP
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index a523c94..feaf09c 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -2,7 +2,6 @@ config MN10300
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 9b1f427..69ff049 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -15,7 +15,6 @@ config PARISC
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d0e8a1d..b6ff882 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -138,7 +138,6 @@ config PPC
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
 	select IRQ_PER_CPU
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 
diff --git a/arch/powerpc/include/asm/qe_ic.h b/arch/powerpc/include/asm/qe_ic.h
index 9e2cb20..f706164 100644
--- a/arch/powerpc/include/asm/qe_ic.h
+++ b/arch/powerpc/include/asm/qe_ic.h
@@ -81,7 +81,7 @@ int qe_ic_set_high_priority(unsigned int virq, unsigned int priority, int high);
 static inline void qe_ic_cascade_low_ipic(unsigned int irq,
 					  struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -91,7 +91,7 @@ static inline void qe_ic_cascade_low_ipic(unsigned int irq,
 static inline void qe_ic_cascade_high_ipic(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
 
 	if (cascade_irq != NO_IRQ)
@@ -101,9 +101,9 @@ static inline void qe_ic_cascade_high_ipic(unsigned int irq,
 static inline void qe_ic_cascade_low_mpic(unsigned int irq,
 					  struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_low_irq(qe_ic);
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
@@ -114,9 +114,9 @@ static inline void qe_ic_cascade_low_mpic(unsigned int irq,
 static inline void qe_ic_cascade_high_mpic(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq = qe_ic_get_high_irq(qe_ic);
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
@@ -127,9 +127,9 @@ static inline void qe_ic_cascade_high_mpic(unsigned int irq,
 static inline void qe_ic_cascade_muxed_mpic(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	struct qe_ic *qe_ic = get_irq_desc_data(desc);
+	struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);
 	unsigned int cascade_irq;
-	struct irq_chip *chip = get_irq_desc_chip(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	cascade_irq = qe_ic_get_high_irq(qe_ic);
 	if (cascade_irq == NO_IRQ)
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4278bbc..e73bc78 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -3,7 +3,6 @@ menu "Machine selection"
 config SCORE
        def_bool y
        select HAVE_GENERIC_HARDIRQS
-       select GENERIC_HARDIRQS_NO_DEPRECATED
        select GENERIC_IRQ_SHOW
 
 choice
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 9af3c8d..bc439de 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -23,7 +23,6 @@ config SUPERH
 	select HAVE_SPARSE_IRQ
 	select RTC_LIB
 	select GENERIC_ATOMIC64
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 14b2346..e560d10 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -51,7 +51,6 @@ config SPARC64
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 	select IRQ_PREFLOW_FASTEOI
 
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 5e34a9f..6e2cdd5 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -11,7 +11,6 @@ config TILE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 
 # FIXME: investigate whether we need/want these options.
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 109ddc0..a923483 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -7,7 +7,6 @@ config UML
 	bool
 	default y
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 
 config MMU
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 04e0249..d3a3032 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -10,7 +10,6 @@ config UNICORE32
 	select HAVE_KERNEL_LZMA
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	help
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 1293c70..cd1ffed 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -316,7 +316,7 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
 	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
 	/* APB timer irqs are set up as mp_irqs, timer is edge type */
-	__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
+	__irq_set_handler(adev->irq, handle_edge_irq, 0, "edge");
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (request_irq(adev->irq, apbt_interrupt_handler,
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 1d730b5..7c275f5 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -9,7 +9,6 @@ config XTENSA
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/drivers/sh/intc/internals.h b/drivers/sh/intc/internals.h
index df36a42..5b93485 100644
--- a/drivers/sh/intc/internals.h
+++ b/drivers/sh/intc/internals.h
@@ -86,7 +86,7 @@ enum {	MODE_ENABLE_REG = 0, /* Bit(s) set -> interrupt enabled */
 
 static inline struct intc_desc_int *get_intc_desc(unsigned int irq)
 {
-	struct irq_chip *chip = get_irq_chip(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
 
 	return container_of(chip, struct intc_desc_int, chip);
 }
@@ -103,7 +103,7 @@ static inline void activate_irq(int irq)
 	set_irq_flags(irq, IRQF_VALID);
 #else
 	/* same effect on other architectures */
-	set_irq_noprobe(irq);
+	irq_set_noprobe(irq);
 #endif
 }
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 59b72ca..943c9b5 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -338,14 +338,6 @@ static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long
 /* IRQ wakeup (PM) control: */
 extern int irq_set_irq_wake(unsigned int irq, unsigned int on);
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
-/* Please do not use: Use the replacement functions instead */
-static inline int set_irq_wake(unsigned int irq, unsigned int on)
-{
-	return irq_set_irq_wake(irq, on);
-}
-#endif
-
 static inline int enable_irq_wake(unsigned int irq)
 {
 	return irq_set_irq_wake(irq, 1);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 2a375a7..09a3080 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -64,13 +64,6 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
  * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
- *
- * Deprecated bits. They are kept updated as long as
- * CONFIG_GENERIC_HARDIRQS_NO_COMPAT is not set. Will go away soon. These bits
- * are internal state of the core code and if you really need to acces
- * them then talk to the genirq maintainer instead of hacking
- * something weird.
- *
  */
 enum {
 	IRQ_TYPE_NONE		= 0x00000000,
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index a69c333..c574f9a 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -10,9 +10,6 @@ menu "IRQ subsystem"
 config GENERIC_HARDIRQS
        def_bool y
 
-config GENERIC_HARDIRQS_NO_COMPAT
-       bool
-
 # Options selectable by the architecture code
 
 # Make sparse irq Kconfig switch below available
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 616ec1c..1dafc86 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -514,7 +514,7 @@ void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc)
 	} while ((desc->istate & IRQS_PENDING) &&
 		 !irqd_irq_disabled(&desc->irq_data));
 
-out_unlock:
+out_eoi:
 	chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index fcab80b..fc017c0 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -331,7 +331,7 @@ int snd_soc_jack_add_gpios(struct snd_soc_jack *jack, int count,
 			goto err;
 
 		if (gpios[i].wake) {
-			ret = set_irq_wake(gpio_to_irq(gpios[i].gpio), 1);
+			ret = irq_set_irq_wake(gpio_to_irq(gpios[i].gpio), 1);
 			if (ret != 0)
 				printk(KERN_ERR
 				  "Failed to mark GPIO %d as wake source: %d\n",
