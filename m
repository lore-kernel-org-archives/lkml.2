Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab1IKMDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:03:36 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38285 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760105Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 11/28] m68k/irq: Rename {,__}m68k_handle_int()
Date: Sun, 11 Sep 2011 13:59:37 +0200
Message-Id: <1315742394-16036-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Rename m68k_handle_int() to generic_handle_irq(), and drop the unneeded
    asmlinkage,
  - Rename __m68k_handle_int() to do_IRQ().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v3: Added this changeset
---
 arch/m68k/amiga/amiints.c   |   24 ++++++++++++------------
 arch/m68k/amiga/cia.c       |    2 +-
 arch/m68k/apollo/dn_ints.c  |    2 +-
 arch/m68k/include/asm/irq.h |    4 ++--
 arch/m68k/kernel/entry_mm.S |    4 ++--
 arch/m68k/kernel/ints.c     |   10 +++++-----
 arch/m68k/mac/baboon.c      |    2 +-
 arch/m68k/mac/oss.c         |    4 ++--
 arch/m68k/mac/psc.c         |    2 +-
 arch/m68k/mac/via.c         |    6 +++---
 arch/m68k/q40/q40ints.c     |    8 ++++----
 arch/m68k/sun3/sun3ints.c   |    2 +-
 12 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index 8af5ea3..0daa7fc 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -124,19 +124,19 @@ static irqreturn_t ami_int1(int irq, void *dev_id)
 	/* if serial transmit buffer empty, interrupt */
 	if (ints & IF_TBE) {
 		amiga_custom.intreq = IF_TBE;
-		m68k_handle_int(IRQ_AMIGA_TBE);
+		generic_handle_irq(IRQ_AMIGA_TBE);
 	}
 
 	/* if floppy disk transfer complete, interrupt */
 	if (ints & IF_DSKBLK) {
 		amiga_custom.intreq = IF_DSKBLK;
-		m68k_handle_int(IRQ_AMIGA_DSKBLK);
+		generic_handle_irq(IRQ_AMIGA_DSKBLK);
 	}
 
 	/* if software interrupt set, interrupt */
 	if (ints & IF_SOFT) {
 		amiga_custom.intreq = IF_SOFT;
-		m68k_handle_int(IRQ_AMIGA_SOFT);
+		generic_handle_irq(IRQ_AMIGA_SOFT);
 	}
 	return IRQ_HANDLED;
 }
@@ -148,19 +148,19 @@ static irqreturn_t ami_int3(int irq, void *dev_id)
 	/* if a blitter interrupt */
 	if (ints & IF_BLIT) {
 		amiga_custom.intreq = IF_BLIT;
-		m68k_handle_int(IRQ_AMIGA_BLIT);
+		generic_handle_irq(IRQ_AMIGA_BLIT);
 	}
 
 	/* if a copper interrupt */
 	if (ints & IF_COPER) {
 		amiga_custom.intreq = IF_COPER;
-		m68k_handle_int(IRQ_AMIGA_COPPER);
+		generic_handle_irq(IRQ_AMIGA_COPPER);
 	}
 
 	/* if a vertical blank interrupt */
 	if (ints & IF_VERTB) {
 		amiga_custom.intreq = IF_VERTB;
-		m68k_handle_int(IRQ_AMIGA_VERTB);
+		generic_handle_irq(IRQ_AMIGA_VERTB);
 	}
 	return IRQ_HANDLED;
 }
@@ -172,25 +172,25 @@ static irqreturn_t ami_int4(int irq, void *dev_id)
 	/* if audio 0 interrupt */
 	if (ints & IF_AUD0) {
 		amiga_custom.intreq = IF_AUD0;
-		m68k_handle_int(IRQ_AMIGA_AUD0);
+		generic_handle_irq(IRQ_AMIGA_AUD0);
 	}
 
 	/* if audio 1 interrupt */
 	if (ints & IF_AUD1) {
 		amiga_custom.intreq = IF_AUD1;
-		m68k_handle_int(IRQ_AMIGA_AUD1);
+		generic_handle_irq(IRQ_AMIGA_AUD1);
 	}
 
 	/* if audio 2 interrupt */
 	if (ints & IF_AUD2) {
 		amiga_custom.intreq = IF_AUD2;
-		m68k_handle_int(IRQ_AMIGA_AUD2);
+		generic_handle_irq(IRQ_AMIGA_AUD2);
 	}
 
 	/* if audio 3 interrupt */
 	if (ints & IF_AUD3) {
 		amiga_custom.intreq = IF_AUD3;
-		m68k_handle_int(IRQ_AMIGA_AUD3);
+		generic_handle_irq(IRQ_AMIGA_AUD3);
 	}
 	return IRQ_HANDLED;
 }
@@ -202,13 +202,13 @@ static irqreturn_t ami_int5(int irq, void *dev_id)
 	/* if serial receive buffer full interrupt */
 	if (ints & IF_RBF) {
 		/* acknowledge of IF_RBF must be done by the serial interrupt */
-		m68k_handle_int(IRQ_AMIGA_RBF);
+		generic_handle_irq(IRQ_AMIGA_RBF);
 	}
 
 	/* if a disk sync interrupt */
 	if (ints & IF_DSKSYN) {
 		amiga_custom.intreq = IF_DSKSYN;
-		m68k_handle_int(IRQ_AMIGA_DSKSYN);
+		generic_handle_irq(IRQ_AMIGA_DSKSYN);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index 84663ae..18c0e29 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -93,7 +93,7 @@ static irqreturn_t cia_handler(int irq, void *dev_id)
 	amiga_custom.intreq = base->int_mask;
 	for (; ints; mach_irq++, ints >>= 1) {
 		if (ints & 1)
-			m68k_handle_int(mach_irq);
+			generic_handle_irq(mach_irq);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index bdc4428..4b76431 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -6,7 +6,7 @@
 
 void dn_process_int(unsigned int irq, struct pt_regs *fp)
 {
-	__m68k_handle_int(irq, fp);
+	do_IRQ(irq, fp);
 
 	*(volatile unsigned char *)(pica)=0x20;
 	*(volatile unsigned char *)(picb)=0x20;
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index d0b7efd..9a2bae8 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -118,8 +118,8 @@ extern void m68k_setup_irq_chip(struct irq_chip *, unsigned int, unsigned int);
 #define m68k_setup_irq_controller(chip, dummy, irq, cnt) \
 	m68k_setup_irq_chip((chip), (irq), (cnt))
 
-asmlinkage void m68k_handle_int(unsigned int);
-asmlinkage void __m68k_handle_int(unsigned int, struct pt_regs *);
+extern void generic_handle_irq(unsigned int);
+asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
 
 #else
 #define irq_canonicalize(irq)  (irq)
diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index bd0ec05..f5927d0 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -207,7 +207,7 @@ ENTRY(auto_inthandler)
 	movel	%sp,%sp@-
 	movel	%d0,%sp@-		|  put vector # on stack
 auto_irqhandler_fixup = . + 2
-	jsr	__m68k_handle_int	|  process the IRQ
+	jsr	do_IRQ			|  process the IRQ
 	addql	#8,%sp			|  pop parameters off stack
 
 ret_from_interrupt:
@@ -241,7 +241,7 @@ user_irqvec_fixup = . + 2
 	movel	%sp,%sp@-
 	movel	%d0,%sp@-		|  put vector # on stack
 user_irqhandler_fixup = . + 2
-	jsr	__m68k_handle_int	|  process the IRQ
+	jsr	do_IRQ			|  process the IRQ
 	addql	#8,%sp			|  pop parameters off stack
 
 	subqb	#1,%curptr@(TASK_INFO+TINFO_PREEMPT+1)
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 4f9868e..15dbbe2 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -110,7 +110,7 @@ void __init init_IRQ(void)
  * @handler: called from auto vector interrupts
  *
  * setup the handler to be called from auto vector interrupts instead of the
- * standard __m68k_handle_int(), it will be called with irq numbers in the range
+ * standard do_IRQ(), it will be called with irq numbers in the range
  * from IRQ_AUTO_1 - IRQ_AUTO_7.
  */
 void __init m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_regs *))
@@ -129,7 +129,7 @@ void __init m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_re
  * setup user vector interrupts, this includes activating the specified range
  * of interrupts, only then these interrupts can be requested (note: this is
  * different from auto vector interrupts). An optional handler can be installed
- * to be called instead of the default __m68k_handle_int(), it will be called
+ * to be called instead of the default do_IRQ(), it will be called
  * with irq numbers starting from IRQ_USER.
  */
 void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
@@ -398,7 +398,7 @@ unsigned int irq_canonicalize(unsigned int irq)
 
 EXPORT_SYMBOL(irq_canonicalize);
 
-asmlinkage void m68k_handle_int(unsigned int irq)
+void generic_handle_irq(unsigned int irq)
 {
 	struct irq_data *node;
 	kstat_cpu(0).irqs[irq]++;
@@ -409,11 +409,11 @@ asmlinkage void m68k_handle_int(unsigned int irq)
 	} while (node);
 }
 
-asmlinkage void __m68k_handle_int(unsigned int irq, struct pt_regs *regs)
+asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
 	old_regs = set_irq_regs(regs);
-	m68k_handle_int(irq);
+	generic_handle_irq(irq);
 	set_irq_regs(old_regs);
 }
 
diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index 2a96beb..f264791 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -72,7 +72,7 @@ static irqreturn_t baboon_irq(int irq, void *dev_id)
 	do {
 	        if (events & irq_bit) {
 			baboon->mb_ifr &= ~irq_bit;
-			m68k_handle_int(irq_num);
+			generic_handle_irq(irq_num);
 		}
 		irq_bit <<= 1;
 		irq_num++;
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index a9c0f5a..ad51241 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -113,7 +113,7 @@ static irqreturn_t oss_irq(int irq, void *dev_id)
 		/* FIXME: call sound handler */
 	} else if (events & OSS_IP_SCSI) {
 		oss->irq_pending &= ~OSS_IP_SCSI;
-		m68k_handle_int(IRQ_MAC_SCSI);
+		generic_handle_irq(IRQ_MAC_SCSI);
 	} else {
 		/* FIXME: error check here? */
 	}
@@ -148,7 +148,7 @@ static irqreturn_t oss_nubus_irq(int irq, void *dev_id)
 		irq_bit >>= 1;
 		if (events & irq_bit) {
 			oss->irq_pending &= ~irq_bit;
-			m68k_handle_int(NUBUS_SOURCE_BASE + i);
+			generic_handle_irq(NUBUS_SOURCE_BASE + i);
 		}
 	} while(events & (irq_bit - 1));
 	return IRQ_HANDLED;
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index a4c3eb6..26c2b65 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -152,7 +152,7 @@ irqreturn_t psc_irq(int irq, void *dev_id)
 	do {
 		if (events & irq_bit) {
 			psc_write_byte(pIFR, irq_bit);
-			m68k_handle_int(irq_num);
+			generic_handle_irq(irq_num);
 		}
 		irq_num++;
 		irq_bit <<= 1;
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index e71166d..0678570 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -460,7 +460,7 @@ irqreturn_t via1_irq(int irq, void *dev_id)
 	do {
 		if (events & irq_bit) {
 			via1[vIFR] = irq_bit;
-			m68k_handle_int(irq_num);
+			generic_handle_irq(irq_num);
 		}
 		++irq_num;
 		irq_bit <<= 1;
@@ -482,7 +482,7 @@ irqreturn_t via2_irq(int irq, void *dev_id)
 	do {
 		if (events & irq_bit) {
 			via2[gIFR] = irq_bit | rbv_clear;
-			m68k_handle_int(irq_num);
+			generic_handle_irq(irq_num);
 		}
 		++irq_num;
 		irq_bit <<= 1;
@@ -514,7 +514,7 @@ irqreturn_t via_nubus_irq(int irq, void *dev_id)
 		do {
 			if (events & slot_bit) {
 				events &= ~slot_bit;
-				m68k_handle_int(slot_irq);
+				generic_handle_irq(slot_irq);
 			}
 			--slot_irq;
 			slot_bit >>= 1;
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index a8a5ce8..afe600c 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -220,11 +220,11 @@ static void q40_irq_handler(unsigned int irq, struct pt_regs *fp)
 	switch (irq) {
 	case 4:
 	case 6:
-		__m68k_handle_int(Q40_IRQ_SAMPLE, fp);
+		do_IRQ(Q40_IRQ_SAMPLE, fp);
 		return;
 	}
 	if (mir & Q40_IRQ_FRAME_MASK) {
-		__m68k_handle_int(Q40_IRQ_FRAME, fp);
+		do_IRQ(Q40_IRQ_FRAME, fp);
 		master_outb(-1, FRAME_CLEAR_REG);
 	}
 	if ((mir & Q40_IRQ_SER_MASK) || (mir & Q40_IRQ_EXT_MASK)) {
@@ -259,7 +259,7 @@ static void q40_irq_handler(unsigned int irq, struct pt_regs *fp)
 					goto iirq;
 				}
 				q40_state[irq] |= IRQ_INPROGRESS;
-				__m68k_handle_int(irq, fp);
+				do_IRQ(irq, fp);
 				q40_state[irq] &= ~IRQ_INPROGRESS;
 
 				/* naively enable everything, if that fails than    */
@@ -290,7 +290,7 @@ static void q40_irq_handler(unsigned int irq, struct pt_regs *fp)
 	mir = master_inb(IIRQ_REG);
 	/* should test whether keyboard irq is really enabled, doing it in defhand */
 	if (mir & Q40_IRQ_KEYB_MASK)
-		__m68k_handle_int(Q40_IRQ_KEYBOARD, fp);
+		do_IRQ(Q40_IRQ_KEYBOARD, fp);
 
 	return;
 }
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 2046127..20ffee7 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -83,7 +83,7 @@ static void sun3_inthandle(unsigned int irq, struct pt_regs *fp)
 {
         *sun3_intreg &= ~(1 << irq);
 
-	__m68k_handle_int(irq, fp);
+	do_IRQ(irq, fp);
 }
 
 static void sun3_irq_enable(struct irq_data *data)
-- 
1.7.0.4

