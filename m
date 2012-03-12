Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2CLAvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:51:00 -0400
Received: from 1wt.eu ([62.212.114.60]:63123 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2CLAtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:49:05 -0400
Message-Id: <20120312004411.363210592@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, stable@kernel.org
Cc: Eric B Munson <emunson@mgebm.net>, benh@kernel.crashing.org,
        Michael Neuling <mikey@neuling.org>
Subject: [ 01/13] powerpc: Add more Power7 specific definitions
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

stable-2.6.27.60 added c24cb8e5 which uses PV_POWER7 but it's not
defined.  Following patch adds these definitions.

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 50fb8ebe7c4ad60d147700d253f78bd1e615a526 upstream

powerpc: Add more Power7 specific definitions

This adds more SPR definitions used on newer processors when running
in hypervisor mode. Along with some other P7 specific bits and pieces

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/include/asm/ppc_asm.h |    1 
 arch/powerpc/include/asm/reg.h     |   45 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

Index: clone1/arch/powerpc/include/asm/ppc_asm.h
===================================================================
--- clone1.orig/arch/powerpc/include/asm/ppc_asm.h
+++ clone1/arch/powerpc/include/asm/ppc_asm.h
@@ -166,6 +166,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_PURR);
 #define HMT_MEDIUM	or	2,2,2
 #define HMT_MEDIUM_HIGH or	5,5,5		# medium high priority
 #define HMT_HIGH	or	3,3,3
+#define HMT_EXTRA_HIGH	or	7,7,7		# power7 only
 
 /* handle instructions that older assemblers may not know */
 #define RFCI		.long 0x4c000066	/* rfci instruction */
Index: clone1/arch/powerpc/include/asm/reg.h
===================================================================
--- clone1.orig/arch/powerpc/include/asm/reg.h
+++ clone1/arch/powerpc/include/asm/reg.h
@@ -172,8 +172,43 @@
 #define SPRN_TBWL	0x11C	/* Time Base Lower Register (super, R/W) */
 #define SPRN_TBWU	0x11D	/* Time Base Upper Register (super, R/W) */
 #define SPRN_SPURR	0x134	/* Scaled PURR */
+#define SPRN_HSPRG0	0x130	/* Hypervisor Scratch 0 */
+#define SPRN_HSPRG1	0x131	/* Hypervisor Scratch 1 */
+#define SPRN_HDSISR     0x132
+#define SPRN_HDAR       0x133
+#define SPRN_HDEC	0x136	/* Hypervisor Decrementer */
 #define SPRN_HIOR	0x137	/* 970 Hypervisor interrupt offset */
+#define SPRN_RMOR	0x138	/* Real mode offset register */
+#define SPRN_HRMOR	0x139	/* Real mode offset register */
+#define SPRN_HSRR0	0x13A	/* Hypervisor Save/Restore 0 */
+#define SPRN_HSRR1	0x13B	/* Hypervisor Save/Restore 1 */
 #define SPRN_LPCR	0x13E	/* LPAR Control Register */
+#define   LPCR_VPM0	(1ul << (63-0))
+#define   LPCR_VPM1	(1ul << (63-1))
+#define   LPCR_ISL	(1ul << (63-2))
+#define   LPCR_DPFD_SH	(63-11)
+#define   LPCR_VRMA_L	(1ul << (63-12))
+#define   LPCR_VRMA_LP0	(1ul << (63-15))
+#define   LPCR_VRMA_LP1	(1ul << (63-16))
+#define   LPCR_RMLS    0x1C000000      /* impl dependent rmo limit sel */
+#define   LPCR_ILE     0x02000000      /* !HV irqs set MSR:LE */
+#define   LPCR_PECE	0x00007000	/* powersave exit cause enable */
+#define     LPCR_PECE0	0x00004000	/* ext. exceptions can cause exit */
+#define     LPCR_PECE1	0x00002000	/* decrementer can cause exit */
+#define     LPCR_PECE2	0x00001000	/* machine check etc can cause exit */
+#define   LPCR_MER	0x00000800	/* Mediated External Exception */
+#define   LPCR_LPES0   0x00000008      /* LPAR Env selector 0 */
+#define   LPCR_LPES1   0x00000004      /* LPAR Env selector 1 */
+#define   LPCR_RMI     0x00000002      /* real mode is cache inhibit */
+#define   LPCR_HDICE   0x00000001      /* Hyp Decr enable (HV,PR,EE) */
+#define SPRN_LPID	0x13F	/* Logical Partition Identifier */
+#define	SPRN_HMER	0x150	/* Hardware m? error recovery */
+#define	SPRN_HMEER	0x151	/* Hardware m? enable error recovery */
+#define	SPRN_HEIR	0x153	/* Hypervisor Emulated Instruction Register */
+#define SPRN_TLBINDEXR	0x154	/* P7 TLB control register */
+#define SPRN_TLBVPNR	0x155	/* P7 TLB control register */
+#define SPRN_TLBRPNR	0x156	/* P7 TLB control register */
+#define SPRN_TLBLPIDR	0x157	/* P7 TLB control register */
 #define SPRN_DBAT0L	0x219	/* Data BAT 0 Lower Register */
 #define SPRN_DBAT0U	0x218	/* Data BAT 0 Upper Register */
 #define SPRN_DBAT1L	0x21B	/* Data BAT 1 Lower Register */
@@ -392,12 +427,18 @@
 #define SPRN_SRR0	0x01A	/* Save/Restore Register 0 */
 #define SPRN_SRR1	0x01B	/* Save/Restore Register 1 */
 #define   SRR1_WAKEMASK		0x00380000 /* reason for wakeup */
-#define   SRR1_WAKERESET	0x00380000 /* System reset */
 #define   SRR1_WAKESYSERR	0x00300000 /* System error */
 #define   SRR1_WAKEEE		0x00200000 /* External interrupt */
 #define   SRR1_WAKEMT		0x00280000 /* mtctrl */
+#define	  SRR1_WAKEHMI		0x00280000 /* Hypervisor maintenance */
 #define   SRR1_WAKEDEC		0x00180000 /* Decrementer interrupt */
 #define   SRR1_WAKETHERM	0x00100000 /* Thermal management interrupt */
+#define	  SRR1_WAKERESET	0x00100000 /* System reset */
+#define	  SRR1_WAKESTATE	0x00030000 /* Powersave exit mask [46:47] */
+#define	  SRR1_WS_DEEPEST	0x00030000 /* Some resources not maintained,
+					  * may not be recoverable */
+#define	  SRR1_WS_DEEPER	0x00020000 /* Some resources not maintained */
+#define	  SRR1_WS_DEEP		0x00010000 /* All resources maintained */
 #define SPRN_HSRR0	0x13A	/* Save/Restore Register 0 */
 #define SPRN_HSRR1	0x13B	/* Save/Restore Register 1 */
 
@@ -698,6 +739,8 @@
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
 #define PV_970FX	0x003C
+#define PV_POWER6	0x003E
+#define PV_POWER7	0x003F
 #define PV_630		0x0040
 #define PV_630p	0x0041
 #define PV_970MP	0x0044



