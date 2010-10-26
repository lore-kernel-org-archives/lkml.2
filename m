Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0JZCyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043Ab0JZCyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 11/43] MN10300: Move DMA engine control reg defs to
 MN103E010 processor directory
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:00 +0100
Message-ID: <20101026025400.23512.37567.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Move the DMA engine control register definitions to the MN103E010 processor
directory so that the MN2WS0050 processor can have its own.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/dmactl-regs.h             |   87 -----------------
 .../proc-mn103e010/include/proc/dmactl-regs.h      |  102 ++++++++++++++++++++
 2 files changed, 103 insertions(+), 86 deletions(-)
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/dmactl-regs.h


diff --git a/arch/mn10300/include/asm/dmactl-regs.h b/arch/mn10300/include/asm/dmactl-regs.h
index 58a199d..80337b3 100644
--- a/arch/mn10300/include/asm/dmactl-regs.h
+++ b/arch/mn10300/include/asm/dmactl-regs.h
@@ -11,91 +11,6 @@
 #ifndef _ASM_DMACTL_REGS_H
 #define _ASM_DMACTL_REGS_H
 
-#include <asm/cpu-regs.h>
-
-#ifdef __KERNEL__
-
-/* DMA registers */
-#define	DMxCTR(N)		__SYSREG(0xd2000000 + ((N) * 0x100), u32)	/* control reg */
-#define	DMxCTR_BG		0x0000001f	/* transfer request source */
-#define	DMxCTR_BG_SOFT		0x00000000	/* - software source */
-#define	DMxCTR_BG_SC0TX		0x00000002	/* - serial port 0 transmission */
-#define	DMxCTR_BG_SC0RX		0x00000003	/* - serial port 0 reception */
-#define	DMxCTR_BG_SC1TX		0x00000004	/* - serial port 1 transmission */
-#define	DMxCTR_BG_SC1RX		0x00000005	/* - serial port 1 reception */
-#define	DMxCTR_BG_SC2TX		0x00000006	/* - serial port 2 transmission */
-#define	DMxCTR_BG_SC2RX		0x00000007	/* - serial port 2 reception */
-#define	DMxCTR_BG_TM0UFLOW	0x00000008	/* - timer 0 underflow */
-#define	DMxCTR_BG_TM1UFLOW	0x00000009	/* - timer 1 underflow */
-#define	DMxCTR_BG_TM2UFLOW	0x0000000a	/* - timer 2 underflow */
-#define	DMxCTR_BG_TM3UFLOW	0x0000000b	/* - timer 3 underflow */
-#define	DMxCTR_BG_TM6ACMPCAP	0x0000000c	/* - timer 6A compare/capture */
-#define	DMxCTR_BG_AFE		0x0000000d	/* - analogue front-end interrupt source */
-#define	DMxCTR_BG_ADC		0x0000000e	/* - A/D conversion end interrupt source */
-#define	DMxCTR_BG_IRDA		0x0000000f	/* - IrDA interrupt source */
-#define	DMxCTR_BG_RTC		0x00000010	/* - RTC interrupt source */
-#define	DMxCTR_BG_XIRQ0		0x00000011	/* - XIRQ0 pin interrupt source */
-#define	DMxCTR_BG_XIRQ1		0x00000012	/* - XIRQ1 pin interrupt source */
-#define	DMxCTR_BG_XDMR0		0x00000013	/* - external request 0 source (XDMR0 pin) */
-#define	DMxCTR_BG_XDMR1		0x00000014	/* - external request 1 source (XDMR1 pin) */
-#define	DMxCTR_SAM		0x000000e0	/* DMA transfer src addr mode */
-#define	DMxCTR_SAM_INCR		0x00000000	/* - increment */
-#define	DMxCTR_SAM_DECR		0x00000020	/* - decrement */
-#define	DMxCTR_SAM_FIXED	0x00000040	/* - fixed */
-#define	DMxCTR_DAM		0x00000000	/* DMA transfer dest addr mode */
-#define	DMxCTR_DAM_INCR		0x00000000	/* - increment */
-#define	DMxCTR_DAM_DECR		0x00000100	/* - decrement */
-#define	DMxCTR_DAM_FIXED	0x00000200	/* - fixed */
-#define	DMxCTR_TM		0x00001800	/* DMA transfer mode */
-#define	DMxCTR_TM_BATCH		0x00000000	/* - batch transfer */
-#define	DMxCTR_TM_INTERM	0x00001000	/* - intermittent transfer */
-#define	DMxCTR_UT		0x00006000	/* DMA transfer unit */
-#define	DMxCTR_UT_1		0x00000000	/* - 1 byte */
-#define	DMxCTR_UT_2		0x00002000	/* - 2 byte */
-#define	DMxCTR_UT_4		0x00004000	/* - 4 byte */
-#define	DMxCTR_UT_16		0x00006000	/* - 16 byte */
-#define	DMxCTR_TEN		0x00010000	/* DMA channel transfer enable */
-#define	DMxCTR_RQM		0x00060000	/* external request input source mode */
-#define	DMxCTR_RQM_FALLEDGE	0x00000000	/* - falling edge */
-#define	DMxCTR_RQM_RISEEDGE	0x00020000	/* - rising edge */
-#define	DMxCTR_RQM_LOLEVEL	0x00040000	/* - low level */
-#define	DMxCTR_RQM_HILEVEL	0x00060000	/* - high level */
-#define	DMxCTR_RQF		0x01000000	/* DMA transfer request flag */
-#define	DMxCTR_XEND		0x80000000	/* DMA transfer end flag */
-
-#define	DMxSRC(N)		__SYSREG(0xd2000004 + ((N) * 0x100), u32)	/* control reg */
-
-#define	DMxDST(N)		__SYSREG(0xd2000008 + ((N) * 0x100), u32)	/* src addr reg */
-
-#define	DMxSIZ(N)		__SYSREG(0xd200000c + ((N) * 0x100), u32)	/* dest addr reg */
-#define DMxSIZ_CT		0x000fffff	/* number of bytes to transfer */
-
-#define	DMxCYC(N)		__SYSREG(0xd2000010 + ((N) * 0x100), u32)	/* intermittent
-										 * size reg */
-#define DMxCYC_CYC		0x000000ff	/* number of interrmittent transfers -1 */
-
-#define DM0IRQ			16		/* DMA channel 0 complete IRQ */
-#define DM1IRQ			17		/* DMA channel 1 complete IRQ */
-#define DM2IRQ			18		/* DMA channel 2 complete IRQ */
-#define DM3IRQ			19		/* DMA channel 3 complete IRQ */
-
-#define	DM0ICR			GxICR(DM0IRQ)	/* DMA channel 0 complete intr ctrl reg */
-#define	DM1ICR			GxICR(DM0IR1)	/* DMA channel 1 complete intr ctrl reg */
-#define	DM2ICR			GxICR(DM0IR2)	/* DMA channel 2 complete intr ctrl reg */
-#define	DM3ICR			GxICR(DM0IR3)	/* DMA channel 3 complete intr ctrl reg */
-
-#ifndef __ASSEMBLY__
-
-struct mn10300_dmactl_regs {
-	u32		ctr;
-	const void	*src;
-	void		*dst;
-	u32		siz;
-	u32		cyc;
-} __attribute__((aligned(0x100)));
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
+#include <proc/dmactl-regs.h>
 
 #endif /* _ASM_DMACTL_REGS_H */
diff --git a/arch/mn10300/proc-mn103e010/include/proc/dmactl-regs.h b/arch/mn10300/proc-mn103e010/include/proc/dmactl-regs.h
new file mode 100644
index 0000000..d72d328
--- /dev/null
+++ b/arch/mn10300/proc-mn103e010/include/proc/dmactl-regs.h
@@ -0,0 +1,102 @@
+/* MN103E010 on-board DMA controller registers
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_DMACTL_REGS_H
+#define _ASM_PROC_DMACTL_REGS_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+
+/* DMA registers */
+#define	DMxCTR(N)		__SYSREG(0xd2000000 + ((N) * 0x100), u32)	/* control reg */
+#define	DMxCTR_BG		0x0000001f	/* transfer request source */
+#define	DMxCTR_BG_SOFT		0x00000000	/* - software source */
+#define	DMxCTR_BG_SC0TX		0x00000002	/* - serial port 0 transmission */
+#define	DMxCTR_BG_SC0RX		0x00000003	/* - serial port 0 reception */
+#define	DMxCTR_BG_SC1TX		0x00000004	/* - serial port 1 transmission */
+#define	DMxCTR_BG_SC1RX		0x00000005	/* - serial port 1 reception */
+#define	DMxCTR_BG_SC2TX		0x00000006	/* - serial port 2 transmission */
+#define	DMxCTR_BG_SC2RX		0x00000007	/* - serial port 2 reception */
+#define	DMxCTR_BG_TM0UFLOW	0x00000008	/* - timer 0 underflow */
+#define	DMxCTR_BG_TM1UFLOW	0x00000009	/* - timer 1 underflow */
+#define	DMxCTR_BG_TM2UFLOW	0x0000000a	/* - timer 2 underflow */
+#define	DMxCTR_BG_TM3UFLOW	0x0000000b	/* - timer 3 underflow */
+#define	DMxCTR_BG_TM6ACMPCAP	0x0000000c	/* - timer 6A compare/capture */
+#define	DMxCTR_BG_AFE		0x0000000d	/* - analogue front-end interrupt source */
+#define	DMxCTR_BG_ADC		0x0000000e	/* - A/D conversion end interrupt source */
+#define	DMxCTR_BG_IRDA		0x0000000f	/* - IrDA interrupt source */
+#define	DMxCTR_BG_RTC		0x00000010	/* - RTC interrupt source */
+#define	DMxCTR_BG_XIRQ0		0x00000011	/* - XIRQ0 pin interrupt source */
+#define	DMxCTR_BG_XIRQ1		0x00000012	/* - XIRQ1 pin interrupt source */
+#define	DMxCTR_BG_XDMR0		0x00000013	/* - external request 0 source (XDMR0 pin) */
+#define	DMxCTR_BG_XDMR1		0x00000014	/* - external request 1 source (XDMR1 pin) */
+#define	DMxCTR_SAM		0x000000e0	/* DMA transfer src addr mode */
+#define	DMxCTR_SAM_INCR		0x00000000	/* - increment */
+#define	DMxCTR_SAM_DECR		0x00000020	/* - decrement */
+#define	DMxCTR_SAM_FIXED	0x00000040	/* - fixed */
+#define	DMxCTR_DAM		0x00000000	/* DMA transfer dest addr mode */
+#define	DMxCTR_DAM_INCR		0x00000000	/* - increment */
+#define	DMxCTR_DAM_DECR		0x00000100	/* - decrement */
+#define	DMxCTR_DAM_FIXED	0x00000200	/* - fixed */
+#define	DMxCTR_TM		0x00001800	/* DMA transfer mode */
+#define	DMxCTR_TM_BATCH		0x00000000	/* - batch transfer */
+#define	DMxCTR_TM_INTERM	0x00001000	/* - intermittent transfer */
+#define	DMxCTR_UT		0x00006000	/* DMA transfer unit */
+#define	DMxCTR_UT_1		0x00000000	/* - 1 byte */
+#define	DMxCTR_UT_2		0x00002000	/* - 2 byte */
+#define	DMxCTR_UT_4		0x00004000	/* - 4 byte */
+#define	DMxCTR_UT_16		0x00006000	/* - 16 byte */
+#define	DMxCTR_TEN		0x00010000	/* DMA channel transfer enable */
+#define	DMxCTR_RQM		0x00060000	/* external request input source mode */
+#define	DMxCTR_RQM_FALLEDGE	0x00000000	/* - falling edge */
+#define	DMxCTR_RQM_RISEEDGE	0x00020000	/* - rising edge */
+#define	DMxCTR_RQM_LOLEVEL	0x00040000	/* - low level */
+#define	DMxCTR_RQM_HILEVEL	0x00060000	/* - high level */
+#define	DMxCTR_RQF		0x01000000	/* DMA transfer request flag */
+#define	DMxCTR_XEND		0x80000000	/* DMA transfer end flag */
+
+#define	DMxSRC(N)		__SYSREG(0xd2000004 + ((N) * 0x100), u32)	/* control reg */
+
+#define	DMxDST(N)		__SYSREG(0xd2000008 + ((N) * 0x100), u32)	/* src addr reg */
+
+#define	DMxSIZ(N)		__SYSREG(0xd200000c + ((N) * 0x100), u32)	/* dest addr reg */
+#define DMxSIZ_CT		0x000fffff	/* number of bytes to transfer */
+
+#define	DMxCYC(N)		__SYSREG(0xd2000010 + ((N) * 0x100), u32)	/* intermittent
+										 * size reg */
+#define DMxCYC_CYC		0x000000ff	/* number of interrmittent transfers -1 */
+
+#define DM0IRQ			16		/* DMA channel 0 complete IRQ */
+#define DM1IRQ			17		/* DMA channel 1 complete IRQ */
+#define DM2IRQ			18		/* DMA channel 2 complete IRQ */
+#define DM3IRQ			19		/* DMA channel 3 complete IRQ */
+
+#define	DM0ICR			GxICR(DM0IRQ)	/* DMA channel 0 complete intr ctrl reg */
+#define	DM1ICR			GxICR(DM0IR1)	/* DMA channel 1 complete intr ctrl reg */
+#define	DM2ICR			GxICR(DM0IR2)	/* DMA channel 2 complete intr ctrl reg */
+#define	DM3ICR			GxICR(DM0IR3)	/* DMA channel 3 complete intr ctrl reg */
+
+#ifndef __ASSEMBLY__
+
+struct mn10300_dmactl_regs {
+	u32		ctr;
+	const void	*src;
+	void		*dst;
+	u32		siz;
+	u32		cyc;
+} __attribute__((aligned(0x100)));
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_PROC_DMACTL_REGS_H */

