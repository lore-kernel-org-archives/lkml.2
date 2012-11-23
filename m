Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2KWPKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:10:49 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45179 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2KWPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:10:09 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 1/8] DMA: PL330: use prefix in reg names to build under x86
Date: Fri, 23 Nov 2012 16:08:23 +0100
Message-Id: <1353683310-23654-2-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

This driver would not compile if ARM_AMBA is selected under x86,
because "CS" and "DS" are already defined there.  But AMBA
is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.

The patch adds the "PL330_" prefix to all register and bit fields,
so it can be built by randomconfig after ARM_AMBA appears within x86.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/dma/pl330.c |  581 ++++++++++++++++++++++++++-------------------------
 1 file changed, 292 insertions(+), 289 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 665668b..6de6de3 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -69,129 +69,129 @@ enum pl330_reqtype {
 };
 
 /* Register and Bit field Definitions */
-#define DS			0x0
-#define DS_ST_STOP		0x0
-#define DS_ST_EXEC		0x1
-#define DS_ST_CMISS		0x2
-#define DS_ST_UPDTPC		0x3
-#define DS_ST_WFE		0x4
-#define DS_ST_ATBRR		0x5
-#define DS_ST_QBUSY		0x6
-#define DS_ST_WFP		0x7
-#define DS_ST_KILL		0x8
-#define DS_ST_CMPLT		0x9
-#define DS_ST_FLTCMP		0xe
-#define DS_ST_FAULT		0xf
-
-#define DPC			0x4
-#define INTEN			0x20
-#define ES			0x24
-#define INTSTATUS		0x28
-#define INTCLR			0x2c
-#define FSM			0x30
-#define FSC			0x34
-#define FTM			0x38
-
-#define _FTC			0x40
-#define FTC(n)			(_FTC + (n)*0x4)
-
-#define _CS			0x100
-#define CS(n)			(_CS + (n)*0x8)
-#define CS_CNS			(1 << 21)
-
-#define _CPC			0x104
-#define CPC(n)			(_CPC + (n)*0x8)
-
-#define _SA			0x400
-#define SA(n)			(_SA + (n)*0x20)
-
-#define _DA			0x404
-#define DA(n)			(_DA + (n)*0x20)
-
-#define _CC			0x408
-#define CC(n)			(_CC + (n)*0x20)
-
-#define CC_SRCINC		(1 << 0)
-#define CC_DSTINC		(1 << 14)
-#define CC_SRCPRI		(1 << 8)
-#define CC_DSTPRI		(1 << 22)
-#define CC_SRCNS		(1 << 9)
-#define CC_DSTNS		(1 << 23)
-#define CC_SRCIA		(1 << 10)
-#define CC_DSTIA		(1 << 24)
-#define CC_SRCBRSTLEN_SHFT	4
-#define CC_DSTBRSTLEN_SHFT	18
-#define CC_SRCBRSTSIZE_SHFT	1
-#define CC_DSTBRSTSIZE_SHFT	15
-#define CC_SRCCCTRL_SHFT	11
-#define CC_SRCCCTRL_MASK	0x7
-#define CC_DSTCCTRL_SHFT	25
-#define CC_DRCCCTRL_MASK	0x7
-#define CC_SWAP_SHFT		28
-
-#define _LC0			0x40c
-#define LC0(n)			(_LC0 + (n)*0x20)
-
-#define _LC1			0x410
-#define LC1(n)			(_LC1 + (n)*0x20)
-
-#define DBGSTATUS		0xd00
-#define DBG_BUSY		(1 << 0)
-
-#define DBGCMD			0xd04
-#define DBGINST0		0xd08
-#define DBGINST1		0xd0c
-
-#define CR0			0xe00
-#define CR1			0xe04
-#define CR2			0xe08
-#define CR3			0xe0c
-#define CR4			0xe10
-#define CRD			0xe14
-
-#define PERIPH_ID		0xfe0
-#define PERIPH_REV_SHIFT	20
-#define PERIPH_REV_MASK		0xf
-#define PERIPH_REV_R0P0		0
-#define PERIPH_REV_R1P0		1
-#define PERIPH_REV_R1P1		2
-#define PCELL_ID		0xff0
-
-#define CR0_PERIPH_REQ_SET	(1 << 0)
-#define CR0_BOOT_EN_SET		(1 << 1)
-#define CR0_BOOT_MAN_NS		(1 << 2)
-#define CR0_NUM_CHANS_SHIFT	4
-#define CR0_NUM_CHANS_MASK	0x7
-#define CR0_NUM_PERIPH_SHIFT	12
-#define CR0_NUM_PERIPH_MASK	0x1f
-#define CR0_NUM_EVENTS_SHIFT	17
-#define CR0_NUM_EVENTS_MASK	0x1f
-
-#define CR1_ICACHE_LEN_SHIFT	0
-#define CR1_ICACHE_LEN_MASK	0x7
-#define CR1_NUM_ICACHELINES_SHIFT	4
-#define CR1_NUM_ICACHELINES_MASK	0xf
-
-#define CRD_DATA_WIDTH_SHIFT	0
-#define CRD_DATA_WIDTH_MASK	0x7
-#define CRD_WR_CAP_SHIFT	4
-#define CRD_WR_CAP_MASK		0x7
-#define CRD_WR_Q_DEP_SHIFT	8
-#define CRD_WR_Q_DEP_MASK	0xf
-#define CRD_RD_CAP_SHIFT	12
-#define CRD_RD_CAP_MASK		0x7
-#define CRD_RD_Q_DEP_SHIFT	16
-#define CRD_RD_Q_DEP_MASK	0xf
-#define CRD_DATA_BUFF_SHIFT	20
-#define CRD_DATA_BUFF_MASK	0x3ff
-
-#define PART			0x330
-#define DESIGNER		0x41
-#define REVISION		0x0
-#define INTEG_CFG		0x0
-#define PERIPH_ID_VAL		((PART << 0) | (DESIGNER << 12))
-
-#define PCELL_ID_VAL		0xb105f00d
+#define PL330_DS			0x0
+#define PL330_DS_ST_STOP		0x0
+#define PL330_DS_ST_EXEC		0x1
+#define PL330_DS_ST_CMISS		0x2
+#define PL330_DS_ST_UPDTPC		0x3
+#define PL330_DS_ST_WFE			0x4
+#define PL330_DS_ST_ATBRR		0x5
+#define PL330_DS_ST_QBUSY		0x6
+#define PL330_DS_ST_WFP			0x7
+#define PL330_DS_ST_KILL		0x8
+#define PL330_DS_ST_CMPLT		0x9
+#define PL330_DS_ST_FLTCMP		0xe
+#define PL330_DS_ST_FAULT		0xf
+
+#define PL330_DPC			0x4
+#define PL330_INTEN			0x20
+#define PL330_ES			0x24
+#define PL330_INTSTATUS			0x28
+#define PL330_INTCLR			0x2c
+#define PL330_FSM			0x30
+#define PL330_FSC			0x34
+#define PL330_FTM			0x38
+
+#define _FTC				0x40
+#define PL330_FTC(n)			(_FTC + (n)*0x4)
+
+#define _CS				0x100
+#define PL330_CS(n)			(_CS + (n)*0x8)
+#define PL330_CS_CNS			(1 << 21)
+
+#define _CPC				0x104
+#define PL330_CPC(n)			(_CPC + (n)*0x8)
+
+#define _SA				0x400
+#define PL330_SA(n)			(_SA + (n)*0x20)
+
+#define _DA				0x404
+#define PL330_DA(n)			(_DA + (n)*0x20)
+
+#define _CC				0x408
+#define PL330_CC(n)			(_CC + (n)*0x20)
+
+#define PL330_CC_SRCINC			(1 << 0)
+#define PL330_CC_DSTINC			(1 << 14)
+#define PL330_CC_SRCPRI			(1 << 8)
+#define PL330_CC_DSTPRI			(1 << 22)
+#define PL330_CC_SRCNS			(1 << 9)
+#define PL330_CC_DSTNS			(1 << 23)
+#define PL330_CC_SRCIA			(1 << 10)
+#define PL330_CC_DSTIA			(1 << 24)
+#define PL330_CC_SRCBRSTLEN_SHFT	4
+#define PL330_CC_DSTBRSTLEN_SHFT	18
+#define PL330_CC_SRCBRSTSIZE_SHFT	1
+#define PL330_CC_DSTBRSTSIZE_SHFT	15
+#define PL330_CC_SRCCCTRL_SHFT		11
+#define PL330_CC_SRCCCTRL_MASK		0x7
+#define PL330_CC_DSTCCTRL_SHFT		25
+#define PL330_CC_DRCCCTRL_MASK		0x7
+#define PL330_CC_SWAP_SHFT		28
+
+#define _LC0				0x40c
+#define PL330_LC0(n)			(_LC0 + (n)*0x20)
+
+#define _LC1				0x410
+#define PL330_LC1(n)			(_LC1 + (n)*0x20)
+
+#define PL330_DBGSTATUS			0xd00
+#define PL330_DBG_BUSY			(1 << 0)
+
+#define PL330_DBGCMD			0xd04
+#define PL330_DBGINST0			0xd08
+#define PL330_DBGINST1			0xd0c
+
+#define PL330_CR0			0xe00
+#define PL330_CR1			0xe04
+#define PL330_CR2			0xe08
+#define PL330_CR3			0xe0c
+#define PL330_CR4			0xe10
+#define PL330_CRD			0xe14
+
+#define PL330_PERIPH_ID			0xfe0
+#define PL330_PERIPH_REV_SHIFT		20
+#define PL330_PERIPH_REV_MASK		0xf
+#define PL330_PERIPH_REV_R0P0		0
+#define PL330_PERIPH_REV_R1P0		1
+#define PL330_PERIPH_REV_R1P1		2
+#define PL330_PCELL_ID			0xff0
+
+#define PL330_CR0_PERIPH_REQ_SET	(1 << 0)
+#define PL330_CR0_BOOT_EN_SET		(1 << 1)
+#define PL330_CR0_BOOT_MAN_NS		(1 << 2)
+#define PL330_CR0_NUM_CHANS_SHIFT	4
+#define PL330_CR0_NUM_CHANS_MASK	0x7
+#define PL330_CR0_NUM_PERIPH_SHIFT	12
+#define PL330_CR0_NUM_PERIPH_MASK	0x1f
+#define PL330_CR0_NUM_EVENTS_SHIFT	17
+#define PL330_CR0_NUM_EVENTS_MASK	0x1f
+
+#define PL330_CR1_ICACHE_LEN_SHIFT	0
+#define PL330_CR1_ICACHE_LEN_MASK	0x7
+#define PL330_CR1_NUM_ICACHELINES_SHIFT	4
+#define PL330_CR1_NUM_ICACHELINES_MASK	0xf
+
+#define PL330_CRD_DATA_WIDTH_SHIFT	0
+#define PL330_CRD_DATA_WIDTH_MASK	0x7
+#define PL330_CRD_WR_CAP_SHIFT		4
+#define PL330_CRD_WR_CAP_MASK		0x7
+#define PL330_CRD_WR_Q_DEP_SHIFT	8
+#define PL330_CRD_WR_Q_DEP_MASK		0xf
+#define PL330_CRD_RD_CAP_SHIFT		12
+#define PL330_CRD_RD_CAP_MASK		0x7
+#define PL330_CRD_RD_Q_DEP_SHIFT	16
+#define PL330_CRD_RD_Q_DEP_MASK		0xf
+#define PL330_CRD_DATA_BUFF_SHIFT	20
+#define PL330_CRD_DATA_BUFF_MASK	0x3ff
+
+#define PL330_PART			0x330
+#define PL330_DESIGNER			0x41
+#define PL330_REVISION			0x0
+#define PL330_INTEG_CFG			0x0
+#define PL330_PERIPH_ID_VAL	((PL330_PART << 0) | (PL330_DESIGNER << 12))
+
+#define PL330_PCELL_ID_VAL		0xb105f00d
 
 #define PL330_STATE_STOPPED		(1 << 0)
 #define PL330_STATE_EXECUTING		(1 << 1)
@@ -210,48 +210,48 @@ enum pl330_reqtype {
 #define PL330_STABLE_STATES (PL330_STATE_STOPPED | PL330_STATE_EXECUTING \
 				| PL330_STATE_WFE | PL330_STATE_FAULTING)
 
-#define CMD_DMAADDH		0x54
-#define CMD_DMAEND		0x00
-#define CMD_DMAFLUSHP		0x35
-#define CMD_DMAGO		0xa0
-#define CMD_DMALD		0x04
-#define CMD_DMALDP		0x25
-#define CMD_DMALP		0x20
-#define CMD_DMALPEND		0x28
-#define CMD_DMAKILL		0x01
-#define CMD_DMAMOV		0xbc
-#define CMD_DMANOP		0x18
-#define CMD_DMARMB		0x12
-#define CMD_DMASEV		0x34
-#define CMD_DMAST		0x08
-#define CMD_DMASTP		0x29
-#define CMD_DMASTZ		0x0c
-#define CMD_DMAWFE		0x36
-#define CMD_DMAWFP		0x30
-#define CMD_DMAWMB		0x13
-
-#define SZ_DMAADDH		3
-#define SZ_DMAEND		1
-#define SZ_DMAFLUSHP		2
-#define SZ_DMALD		1
-#define SZ_DMALDP		2
-#define SZ_DMALP		2
-#define SZ_DMALPEND		2
-#define SZ_DMAKILL		1
-#define SZ_DMAMOV		6
-#define SZ_DMANOP		1
-#define SZ_DMARMB		1
-#define SZ_DMASEV		2
-#define SZ_DMAST		1
-#define SZ_DMASTP		2
-#define SZ_DMASTZ		1
-#define SZ_DMAWFE		2
-#define SZ_DMAWFP		2
-#define SZ_DMAWMB		1
-#define SZ_DMAGO		6
-
-#define BRST_LEN(ccr)		((((ccr) >> CC_SRCBRSTLEN_SHFT) & 0xf) + 1)
-#define BRST_SIZE(ccr)		(1 << (((ccr) >> CC_SRCBRSTSIZE_SHFT) & 0x7))
+#define PL330_CMD_DMAADDH		0x54
+#define PL330_CMD_DMAEND		0x00
+#define PL330_CMD_DMAFLUSHP		0x35
+#define PL330_CMD_DMAGO			0xa0
+#define PL330_CMD_DMALD			0x04
+#define PL330_CMD_DMALDP		0x25
+#define PL330_CMD_DMALP			0x20
+#define PL330_CMD_DMALPEND		0x28
+#define PL330_CMD_DMAKILL		0x01
+#define PL330_CMD_DMAMOV		0xbc
+#define PL330_CMD_DMANOP		0x18
+#define PL330_CMD_DMARMB		0x12
+#define PL330_CMD_DMASEV		0x34
+#define PL330_CMD_DMAST			0x08
+#define PL330_CMD_DMASTP		0x29
+#define PL330_CMD_DMASTZ		0x0c
+#define PL330_CMD_DMAWFE		0x36
+#define PL330_CMD_DMAWFP		0x30
+#define PL330_CMD_DMAWMB		0x13
+
+#define PL330_SZ_DMAADDH		3
+#define PL330_SZ_DMAEND			1
+#define PL330_SZ_DMAFLUSHP		2
+#define PL330_SZ_DMALD			1
+#define PL330_SZ_DMALDP			2
+#define PL330_SZ_DMALP			2
+#define PL330_SZ_DMALPEND		2
+#define PL330_SZ_DMAKILL		1
+#define PL330_SZ_DMAMOV			6
+#define PL330_SZ_DMANOP			1
+#define PL330_SZ_DMARMB			1
+#define PL330_SZ_DMASEV			2
+#define PL330_SZ_DMAST			1
+#define PL330_SZ_DMASTP			2
+#define PL330_SZ_DMASTZ			1
+#define PL330_SZ_DMAWFE			2
+#define PL330_SZ_DMAWFP			2
+#define PL330_SZ_DMAWMB			1
+#define PL330_SZ_DMAGO			6
+
+#define BRST_LEN(ccr)	((((ccr) >> PL330_CC_SRCBRSTLEN_SHFT) & 0xf) + 1)
+#define BRST_SIZE(ccr)	(1 << (((ccr) >> PL330_CC_SRCBRSTSIZE_SHFT) & 0x7))
 
 #define BYTE_TO_BURST(b, ccr)	((b) / BRST_SIZE(ccr) / BRST_LEN(ccr))
 #define BURST_TO_BYTE(c, ccr)	((c) * BRST_SIZE(ccr) * BRST_LEN(ccr))
@@ -265,7 +265,7 @@ enum pl330_reqtype {
 #define MCODE_BUFF_PER_REQ	256
 
 /* If the _pl330_req is available to the client */
-#define IS_FREE(req)	(*((u8 *)((req)->mc_cpu)) == CMD_DMAEND)
+#define IS_FREE(req)	(*((u8 *)((req)->mc_cpu)) == PL330_CMD_DMAEND)
 
 /* Use this _only_ to wait on transient states */
 #define UNTIL(t, s)	while (!(_state(t) & (s))) cpu_relax();
@@ -658,43 +658,43 @@ static inline u32 get_id(struct pl330_info *pi, u32 off)
 
 static inline u32 get_revision(u32 periph_id)
 {
-	return (periph_id >> PERIPH_REV_SHIFT) & PERIPH_REV_MASK;
+	return (periph_id >> PL330_PERIPH_REV_SHIFT) & PL330_PERIPH_REV_MASK;
 }
 
 static inline u32 _emit_ADDH(unsigned dry_run, u8 buf[],
 		enum pl330_dst da, u16 val)
 {
 	if (dry_run)
-		return SZ_DMAADDH;
+		return PL330_SZ_DMAADDH;
 
-	buf[0] = CMD_DMAADDH;
+	buf[0] = PL330_CMD_DMAADDH;
 	buf[0] |= (da << 1);
 	*((u16 *)&buf[1]) = val;
 
-	PL330_DBGCMD_DUMP(SZ_DMAADDH, "\tDMAADDH %s %u\n",
+	PL330_DBGCMD_DUMP(PL330_SZ_DMAADDH, "\tDMAADDH %s %u\n",
 		da == 1 ? "DA" : "SA", val);
 
-	return SZ_DMAADDH;
+	return PL330_SZ_DMAADDH;
 }
 
 static inline u32 _emit_END(unsigned dry_run, u8 buf[])
 {
 	if (dry_run)
-		return SZ_DMAEND;
+		return PL330_SZ_DMAEND;
 
-	buf[0] = CMD_DMAEND;
+	buf[0] = PL330_CMD_DMAEND;
 
-	PL330_DBGCMD_DUMP(SZ_DMAEND, "\tDMAEND\n");
+	PL330_DBGCMD_DUMP(PL330_SZ_DMAEND, "\tDMAEND\n");
 
-	return SZ_DMAEND;
+	return PL330_SZ_DMAEND;
 }
 
 static inline u32 _emit_FLUSHP(unsigned dry_run, u8 buf[], u8 peri)
 {
 	if (dry_run)
-		return SZ_DMAFLUSHP;
+		return PL330_SZ_DMAFLUSHP;
 
-	buf[0] = CMD_DMAFLUSHP;
+	buf[0] = PL330_CMD_DMAFLUSHP;
 
 	peri &= 0x1f;
 	peri <<= 3;
@@ -702,15 +702,15 @@ static inline u32 _emit_FLUSHP(unsigned dry_run, u8 buf[], u8 peri)
 
 	PL330_DBGCMD_DUMP(SZ_DMAFLUSHP, "\tDMAFLUSHP %u\n", peri >> 3);
 
-	return SZ_DMAFLUSHP;
+	return PL330_SZ_DMAFLUSHP;
 }
 
 static inline u32 _emit_LD(unsigned dry_run, u8 buf[],	enum pl330_cond cond)
 {
 	if (dry_run)
-		return SZ_DMALD;
+		return PL330_SZ_DMALD;
 
-	buf[0] = CMD_DMALD;
+	buf[0] = PL330_CMD_DMALD;
 
 	if (cond == SINGLE)
 		buf[0] |= (0 << 1) | (1 << 0);
@@ -720,16 +720,16 @@ static inline u32 _emit_LD(unsigned dry_run, u8 buf[],	enum pl330_cond cond)
 	PL330_DBGCMD_DUMP(SZ_DMALD, "\tDMALD%c\n",
 		cond == SINGLE ? 'S' : (cond == BURST ? 'B' : 'A'));
 
-	return SZ_DMALD;
+	return PL330_SZ_DMALD;
 }
 
 static inline u32 _emit_LDP(unsigned dry_run, u8 buf[],
 		enum pl330_cond cond, u8 peri)
 {
 	if (dry_run)
-		return SZ_DMALDP;
+		return PL330_SZ_DMALDP;
 
-	buf[0] = CMD_DMALDP;
+	buf[0] = PL330_CMD_DMALDP;
 
 	if (cond == BURST)
 		buf[0] |= (1 << 1);
@@ -741,16 +741,16 @@ static inline u32 _emit_LDP(unsigned dry_run, u8 buf[],
 	PL330_DBGCMD_DUMP(SZ_DMALDP, "\tDMALDP%c %u\n",
 		cond == SINGLE ? 'S' : 'B', peri >> 3);
 
-	return SZ_DMALDP;
+	return PL330_SZ_DMALDP;
 }
 
 static inline u32 _emit_LP(unsigned dry_run, u8 buf[],
 		unsigned loop, u8 cnt)
 {
 	if (dry_run)
-		return SZ_DMALP;
+		return PL330_SZ_DMALP;
 
-	buf[0] = CMD_DMALP;
+	buf[0] = PL330_CMD_DMALP;
 
 	if (loop)
 		buf[0] |= (1 << 1);
@@ -760,7 +760,7 @@ static inline u32 _emit_LP(unsigned dry_run, u8 buf[],
 
 	PL330_DBGCMD_DUMP(SZ_DMALP, "\tDMALP_%c %u\n", loop ? '1' : '0', cnt);
 
-	return SZ_DMALP;
+	return PL330_SZ_DMALP;
 }
 
 struct _arg_LPEND {
@@ -779,9 +779,9 @@ static inline u32 _emit_LPEND(unsigned dry_run, u8 buf[],
 	u8 bjump = arg->bjump;
 
 	if (dry_run)
-		return SZ_DMALPEND;
+		return PL330_SZ_DMALPEND;
 
-	buf[0] = CMD_DMALPEND;
+	buf[0] = PL330_CMD_DMALPEND;
 
 	if (loop)
 		buf[0] |= (1 << 2);
@@ -802,65 +802,65 @@ static inline u32 _emit_LPEND(unsigned dry_run, u8 buf[],
 			loop ? '1' : '0',
 			bjump);
 
-	return SZ_DMALPEND;
+	return PL330_SZ_DMALPEND;
 }
 
 static inline u32 _emit_KILL(unsigned dry_run, u8 buf[])
 {
 	if (dry_run)
-		return SZ_DMAKILL;
+		return PL330_SZ_DMAKILL;
 
-	buf[0] = CMD_DMAKILL;
+	buf[0] = PL330_CMD_DMAKILL;
 
-	return SZ_DMAKILL;
+	return PL330_SZ_DMAKILL;
 }
 
 static inline u32 _emit_MOV(unsigned dry_run, u8 buf[],
 		enum dmamov_dst dst, u32 val)
 {
 	if (dry_run)
-		return SZ_DMAMOV;
+		return PL330_SZ_DMAMOV;
 
-	buf[0] = CMD_DMAMOV;
+	buf[0] = PL330_CMD_DMAMOV;
 	buf[1] = dst;
 	*((u32 *)&buf[2]) = val;
 
 	PL330_DBGCMD_DUMP(SZ_DMAMOV, "\tDMAMOV %s 0x%x\n",
 		dst == SAR ? "SAR" : (dst == DAR ? "DAR" : "CCR"), val);
 
-	return SZ_DMAMOV;
+	return PL330_SZ_DMAMOV;
 }
 
 static inline u32 _emit_NOP(unsigned dry_run, u8 buf[])
 {
 	if (dry_run)
-		return SZ_DMANOP;
+		return PL330_SZ_DMANOP;
 
-	buf[0] = CMD_DMANOP;
+	buf[0] = PL330_CMD_DMANOP;
 
 	PL330_DBGCMD_DUMP(SZ_DMANOP, "\tDMANOP\n");
 
-	return SZ_DMANOP;
+	return PL330_SZ_DMANOP;
 }
 
 static inline u32 _emit_RMB(unsigned dry_run, u8 buf[])
 {
 	if (dry_run)
-		return SZ_DMARMB;
+		return PL330_SZ_DMARMB;
 
-	buf[0] = CMD_DMARMB;
+	buf[0] = PL330_CMD_DMARMB;
 
 	PL330_DBGCMD_DUMP(SZ_DMARMB, "\tDMARMB\n");
 
-	return SZ_DMARMB;
+	return PL330_SZ_DMARMB;
 }
 
 static inline u32 _emit_SEV(unsigned dry_run, u8 buf[], u8 ev)
 {
 	if (dry_run)
-		return SZ_DMASEV;
+		return PL330_SZ_DMASEV;
 
-	buf[0] = CMD_DMASEV;
+	buf[0] = PL330_CMD_DMASEV;
 
 	ev &= 0x1f;
 	ev <<= 3;
@@ -868,15 +868,15 @@ static inline u32 _emit_SEV(unsigned dry_run, u8 buf[], u8 ev)
 
 	PL330_DBGCMD_DUMP(SZ_DMASEV, "\tDMASEV %u\n", ev >> 3);
 
-	return SZ_DMASEV;
+	return PL330_SZ_DMASEV;
 }
 
 static inline u32 _emit_ST(unsigned dry_run, u8 buf[], enum pl330_cond cond)
 {
 	if (dry_run)
-		return SZ_DMAST;
+		return PL330_SZ_DMAST;
 
-	buf[0] = CMD_DMAST;
+	buf[0] = PL330_CMD_DMAST;
 
 	if (cond == SINGLE)
 		buf[0] |= (0 << 1) | (1 << 0);
@@ -886,16 +886,16 @@ static inline u32 _emit_ST(unsigned dry_run, u8 buf[], enum pl330_cond cond)
 	PL330_DBGCMD_DUMP(SZ_DMAST, "\tDMAST%c\n",
 		cond == SINGLE ? 'S' : (cond == BURST ? 'B' : 'A'));
 
-	return SZ_DMAST;
+	return PL330_SZ_DMAST;
 }
 
 static inline u32 _emit_STP(unsigned dry_run, u8 buf[],
 		enum pl330_cond cond, u8 peri)
 {
 	if (dry_run)
-		return SZ_DMASTP;
+		return PL330_SZ_DMASTP;
 
-	buf[0] = CMD_DMASTP;
+	buf[0] = PL330_CMD_DMASTP;
 
 	if (cond == BURST)
 		buf[0] |= (1 << 1);
@@ -907,28 +907,28 @@ static inline u32 _emit_STP(unsigned dry_run, u8 buf[],
 	PL330_DBGCMD_DUMP(SZ_DMASTP, "\tDMASTP%c %u\n",
 		cond == SINGLE ? 'S' : 'B', peri >> 3);
 
-	return SZ_DMASTP;
+	return PL330_SZ_DMASTP;
 }
 
 static inline u32 _emit_STZ(unsigned dry_run, u8 buf[])
 {
 	if (dry_run)
-		return SZ_DMASTZ;
+		return PL330_SZ_DMASTZ;
 
-	buf[0] = CMD_DMASTZ;
+	buf[0] = PL330_CMD_DMASTZ;
 
 	PL330_DBGCMD_DUMP(SZ_DMASTZ, "\tDMASTZ\n");
 
-	return SZ_DMASTZ;
+	return PL330_SZ_DMASTZ;
 }
 
 static inline u32 _emit_WFE(unsigned dry_run, u8 buf[], u8 ev,
 		unsigned invalidate)
 {
 	if (dry_run)
-		return SZ_DMAWFE;
+		return PL330_SZ_DMAWFE;
 
-	buf[0] = CMD_DMAWFE;
+	buf[0] = PL330_CMD_DMAWFE;
 
 	ev &= 0x1f;
 	ev <<= 3;
@@ -940,16 +940,16 @@ static inline u32 _emit_WFE(unsigned dry_run, u8 buf[], u8 ev,
 	PL330_DBGCMD_DUMP(SZ_DMAWFE, "\tDMAWFE %u%s\n",
 		ev >> 3, invalidate ? ", I" : "");
 
-	return SZ_DMAWFE;
+	return PL330_SZ_DMAWFE;
 }
 
 static inline u32 _emit_WFP(unsigned dry_run, u8 buf[],
 		enum pl330_cond cond, u8 peri)
 {
 	if (dry_run)
-		return SZ_DMAWFP;
+		return PL330_SZ_DMAWFP;
 
-	buf[0] = CMD_DMAWFP;
+	buf[0] = PL330_CMD_DMAWFP;
 
 	if (cond == SINGLE)
 		buf[0] |= (0 << 1) | (0 << 0);
@@ -965,19 +965,19 @@ static inline u32 _emit_WFP(unsigned dry_run, u8 buf[],
 	PL330_DBGCMD_DUMP(SZ_DMAWFP, "\tDMAWFP%c %u\n",
 		cond == SINGLE ? 'S' : (cond == BURST ? 'B' : 'P'), peri >> 3);
 
-	return SZ_DMAWFP;
+	return PL330_SZ_DMAWFP;
 }
 
 static inline u32 _emit_WMB(unsigned dry_run, u8 buf[])
 {
 	if (dry_run)
-		return SZ_DMAWMB;
+		return PL330_SZ_DMAWMB;
 
-	buf[0] = CMD_DMAWMB;
+	buf[0] = PL330_CMD_DMAWMB;
 
 	PL330_DBGCMD_DUMP(SZ_DMAWMB, "\tDMAWMB\n");
 
-	return SZ_DMAWMB;
+	return PL330_SZ_DMAWMB;
 }
 
 struct _arg_GO {
@@ -994,16 +994,16 @@ static inline u32 _emit_GO(unsigned dry_run, u8 buf[],
 	unsigned ns = arg->ns;
 
 	if (dry_run)
-		return SZ_DMAGO;
+		return PL330_SZ_DMAGO;
 
-	buf[0] = CMD_DMAGO;
+	buf[0] = PL330_CMD_DMAGO;
 	buf[0] |= (ns << 1);
 
 	buf[1] = chan & 0x7;
 
 	*((u32 *)&buf[2]) = addr;
 
-	return SZ_DMAGO;
+	return PL330_SZ_DMAGO;
 }
 
 #define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
@@ -1016,7 +1016,7 @@ static bool _until_dmac_idle(struct pl330_thread *thrd)
 
 	do {
 		/* Until Manager is Idle */
-		if (!(readl(regs + DBGSTATUS) & DBG_BUSY))
+		if (!(readl(regs + PL330_DBGSTATUS) & PL330_DBG_BUSY))
 			break;
 
 		cpu_relax();
@@ -1039,10 +1039,10 @@ static inline void _execute_DBGINSN(struct pl330_thread *thrd,
 		val |= (1 << 0);
 		val |= (thrd->id << 8); /* Channel Number */
 	}
-	writel(val, regs + DBGINST0);
+	writel(val, regs + PL330_DBGINST0);
 
 	val = *((u32 *)&insn[2]);
-	writel(val, regs + DBGINST1);
+	writel(val, regs + PL330_DBGINST1);
 
 	/* If timed out due to halted state-machine */
 	if (_until_dmac_idle(thrd)) {
@@ -1051,7 +1051,7 @@ static inline void _execute_DBGINSN(struct pl330_thread *thrd,
 	}
 
 	/* Get going */
-	writel(0, regs + DBGCMD);
+	writel(0, regs + PL330_DBGCMD);
 }
 
 /*
@@ -1078,47 +1078,47 @@ static inline u32 _state(struct pl330_thread *thrd)
 	if (is_manager(thrd))
 		val = readl(regs + DS) & 0xf;
 	else
-		val = readl(regs + CS(thrd->id)) & 0xf;
+		val = readl(regs + PL330_CS(thrd->id)) & 0xf;
 
 	switch (val) {
-	case DS_ST_STOP:
+	case PL330_DS_ST_STOP:
 		return PL330_STATE_STOPPED;
-	case DS_ST_EXEC:
+	case PL330_DS_ST_EXEC:
 		return PL330_STATE_EXECUTING;
-	case DS_ST_CMISS:
+	case PL330_DS_ST_CMISS:
 		return PL330_STATE_CACHEMISS;
-	case DS_ST_UPDTPC:
+	case PL330_DS_ST_UPDTPC:
 		return PL330_STATE_UPDTPC;
-	case DS_ST_WFE:
+	case PL330_DS_ST_WFE:
 		return PL330_STATE_WFE;
-	case DS_ST_FAULT:
+	case PL330_DS_ST_FAULT:
 		return PL330_STATE_FAULTING;
-	case DS_ST_ATBRR:
+	case PL330_DS_ST_ATBRR:
 		if (is_manager(thrd))
 			return PL330_STATE_INVALID;
 		else
 			return PL330_STATE_ATBARRIER;
-	case DS_ST_QBUSY:
+	case PL330_DS_ST_QBUSY:
 		if (is_manager(thrd))
 			return PL330_STATE_INVALID;
 		else
 			return PL330_STATE_QUEUEBUSY;
-	case DS_ST_WFP:
+	case PL330_DS_ST_WFP:
 		if (is_manager(thrd))
 			return PL330_STATE_INVALID;
 		else
 			return PL330_STATE_WFP;
-	case DS_ST_KILL:
+	case PL330_DS_ST_KILL:
 		if (is_manager(thrd))
 			return PL330_STATE_INVALID;
 		else
 			return PL330_STATE_KILLING;
-	case DS_ST_CMPLT:
+	case PL330_DS_ST_CMPLT:
 		if (is_manager(thrd))
 			return PL330_STATE_INVALID;
 		else
 			return PL330_STATE_COMPLETING;
-	case DS_ST_FLTCMP:
+	case PL330_DS_ST_FLTCMP:
 		if (is_manager(thrd))
 			return PL330_STATE_INVALID;
 		else
@@ -1145,7 +1145,8 @@ static void _stop(struct pl330_thread *thrd)
 	_emit_KILL(0, insn);
 
 	/* Stop generating interrupts for SEV */
-	writel(readl(regs + INTEN) & ~(1 << thrd->ev), regs + INTEN);
+	writel(readl(regs + PL330_INTEN) & ~(1 << thrd->ev),
+	       regs + PL330_INTEN);
 
 	_execute_DBGINSN(thrd, insn, is_manager(thrd));
 }
@@ -1184,7 +1185,7 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	if (r->cfg)
 		ns = r->cfg->nonsecure ? 1 : 0;
-	else if (readl(regs + CS(thrd->id)) & CS_CNS)
+	else if (readl(regs + PL330_CS(thrd->id)) & PL330_CS_CNS)
 		ns = 1;
 	else
 		ns = 0;
@@ -1200,7 +1201,7 @@ static bool _trigger(struct pl330_thread *thrd)
 	_emit_GO(0, insn, &go);
 
 	/* Set to generate interrupts for SEV */
-	writel(readl(regs + INTEN) | (1 << thrd->ev), regs + INTEN);
+	writel(readl(regs + PL330_INTEN) | (1 << thrd->ev), regs + PL330_INTEN);
 
 	/* Only manager can execute GO */
 	_execute_DBGINSN(thrd, insn, true);
@@ -1250,7 +1251,7 @@ static inline int _ldst_memtomem(unsigned dry_run, u8 buf[],
 	struct pl330_config *pcfg = pxs->r->cfg->pcfg;
 
 	/* check lock-up free version */
-	if (get_revision(pcfg->periph_id) >= PERIPH_REV_R1P0) {
+	if (get_revision(pcfg->periph_id) >= PL330_PERIPH_REV_R1P0) {
 		while (cyc--) {
 			off += _emit_LD(dry_run, &buf[off], ALWAYS);
 			off += _emit_ST(dry_run, &buf[off], ALWAYS);
@@ -1475,29 +1476,29 @@ static inline u32 _prepare_ccr(const struct pl330_reqcfg *rqc)
 	u32 ccr = 0;
 
 	if (rqc->src_inc)
-		ccr |= CC_SRCINC;
+		ccr |= PL330_CC_SRCINC;
 
 	if (rqc->dst_inc)
-		ccr |= CC_DSTINC;
+		ccr |= PL330_CC_DSTINC;
 
 	/* We set same protection levels for Src and DST for now */
 	if (rqc->privileged)
-		ccr |= CC_SRCPRI | CC_DSTPRI;
+		ccr |= PL330_CC_SRCPRI | PL330_CC_DSTPRI;
 	if (rqc->nonsecure)
-		ccr |= CC_SRCNS | CC_DSTNS;
+		ccr |= PL330_CC_SRCNS | PL330_CC_DSTNS;
 	if (rqc->insnaccess)
-		ccr |= CC_SRCIA | CC_DSTIA;
+		ccr |= PL330_CC_SRCIA | PL330_CC_DSTIA;
 
-	ccr |= (((rqc->brst_len - 1) & 0xf) << CC_SRCBRSTLEN_SHFT);
-	ccr |= (((rqc->brst_len - 1) & 0xf) << CC_DSTBRSTLEN_SHFT);
+	ccr |= (((rqc->brst_len - 1) & 0xf) << PL330_CC_SRCBRSTLEN_SHFT);
+	ccr |= (((rqc->brst_len - 1) & 0xf) << PL330_CC_DSTBRSTLEN_SHFT);
 
-	ccr |= (rqc->brst_size << CC_SRCBRSTSIZE_SHFT);
-	ccr |= (rqc->brst_size << CC_DSTBRSTSIZE_SHFT);
+	ccr |= (rqc->brst_size << PL330_CC_SRCBRSTSIZE_SHFT);
+	ccr |= (rqc->brst_size << PL330_CC_DSTBRSTSIZE_SHFT);
 
-	ccr |= (rqc->scctl << CC_SRCCCTRL_SHFT);
-	ccr |= (rqc->dcctl << CC_DSTCCTRL_SHFT);
+	ccr |= (rqc->scctl << PL330_CC_SRCCCTRL_SHFT);
+	ccr |= (rqc->dcctl << PL330_CC_DSTCCTRL_SHFT);
 
-	ccr |= (rqc->swap << CC_SWAP_SHFT);
+	ccr |= (rqc->swap << PL330_CC_SWAP_SHFT);
 
 	return ccr;
 }
@@ -1507,8 +1508,8 @@ static inline bool _is_valid(u32 ccr)
 	enum pl330_dstcachectrl dcctl;
 	enum pl330_srccachectrl scctl;
 
-	dcctl = (ccr >> CC_DSTCCTRL_SHFT) & CC_DRCCCTRL_MASK;
-	scctl = (ccr >> CC_SRCCCTRL_SHFT) & CC_SRCCCTRL_MASK;
+	dcctl = (ccr >> PL330_CC_DSTCCTRL_SHFT) & PL330_CC_DRCCCTRL_MASK;
+	scctl = (ccr >> PL330_CC_SRCCCTRL_SHFT) & PL330_CC_SRCCCTRL_MASK;
 
 	if (dcctl == DINVALID1 || dcctl == DINVALID2
 			|| scctl == SINVALID1 || scctl == SINVALID2)
@@ -1575,7 +1576,7 @@ static int pl330_submit_req(void *ch_id, struct pl330_req *r)
 
 		ccr = _prepare_ccr(r->cfg);
 	} else {
-		ccr = readl(regs + CC(thrd->id));
+		ccr = readl(regs + PL330_CC(thrd->id));
 	}
 
 	/* If this req doesn't have valid xfer settings */
@@ -1652,7 +1653,7 @@ static void pl330_dotask(unsigned long data)
 
 			_stop(thrd);
 
-			if (readl(regs + FSC) & (1 << thrd->id))
+			if (readl(regs + PL330_FSC) & (1 << thrd->id))
 				err = PL330_ERR_FAIL;
 			else
 				err = PL330_ERR_ABORT;
@@ -1697,13 +1698,13 @@ static int pl330_update(const struct pl330_info *pi)
 
 	spin_lock_irqsave(&pl330->lock, flags);
 
-	val = readl(regs + FSM) & 0x1;
+	val = readl(regs + PL330_FSM) & 0x1;
 	if (val)
 		pl330->dmac_tbd.reset_mngr = true;
 	else
 		pl330->dmac_tbd.reset_mngr = false;
 
-	val = readl(regs + FSC) & ((1 << pi->pcfg.num_chan) - 1);
+	val = readl(regs + PL330_FSC) & ((1 << pi->pcfg.num_chan) - 1);
 	pl330->dmac_tbd.reset_chan |= val;
 	if (val) {
 		int i = 0;
@@ -1711,8 +1712,8 @@ static int pl330_update(const struct pl330_info *pi)
 			if (val & (1 << i)) {
 				dev_info(pi->dev,
 					"Reset Channel-%d\t CS-%x FTC-%x\n",
-						i, readl(regs + CS(i)),
-						readl(regs + FTC(i)));
+						i, readl(regs + PL330_CS(i)),
+						readl(regs + PL330_FTC(i)));
 				_stop(&pl330->channels[i]);
 			}
 			i++;
@@ -1732,12 +1733,12 @@ static int pl330_update(const struct pl330_info *pi)
 	for (ev = 0; ev < pi->pcfg.num_events; ev++) {
 		if (val & (1 << ev)) { /* Event occurred */
 			struct pl330_thread *thrd;
-			u32 inten = readl(regs + INTEN);
+			u32 inten = readl(regs + PL330_INTEN);
 			int active;
 
 			/* Clear the event */
 			if (inten & (1 << ev))
-				writel(1 << ev, regs + INTCLR);
+				writel(1 << ev, regs + PL330_INTCLR);
 
 			ret = 1;
 
@@ -1944,44 +1945,45 @@ static void read_dmac_config(struct pl330_info *pi)
 	void __iomem *regs = pi->base;
 	u32 val;
 
-	val = readl(regs + CRD) >> CRD_DATA_WIDTH_SHIFT;
-	val &= CRD_DATA_WIDTH_MASK;
+	val = readl(regs + PL330_CRD) >> PL330_CRD_DATA_WIDTH_SHIFT;
+	val &= PL330_CRD_DATA_WIDTH_MASK;
 	pi->pcfg.data_bus_width = 8 * (1 << val);
 
-	val = readl(regs + CRD) >> CRD_DATA_BUFF_SHIFT;
-	val &= CRD_DATA_BUFF_MASK;
+	val = readl(regs + PL330_CRD) >> PL330_CRD_DATA_BUFF_SHIFT;
+	val &= PL330_CRD_DATA_BUFF_MASK;
 	pi->pcfg.data_buf_dep = val + 1;
 
-	val = readl(regs + CR0) >> CR0_NUM_CHANS_SHIFT;
-	val &= CR0_NUM_CHANS_MASK;
+	val = readl(regs + PL330_CR0) >> PL330_CR0_NUM_CHANS_SHIFT;
+	val &= PL330_CR0_NUM_CHANS_MASK;
 	val += 1;
 	pi->pcfg.num_chan = val;
 
-	val = readl(regs + CR0);
-	if (val & CR0_PERIPH_REQ_SET) {
-		val = (val >> CR0_NUM_PERIPH_SHIFT) & CR0_NUM_PERIPH_MASK;
+	val = readl(regs + PL330_CR0);
+	if (val & PL330_CR0_PERIPH_REQ_SET) {
+		val = (val >> PL330_CR0_NUM_PERIPH_SHIFT)
+			& PL330_CR0_NUM_PERIPH_MASK;
 		val += 1;
 		pi->pcfg.num_peri = val;
-		pi->pcfg.peri_ns = readl(regs + CR4);
+		pi->pcfg.peri_ns = readl(regs + PL330_CR4);
 	} else {
 		pi->pcfg.num_peri = 0;
 	}
 
-	val = readl(regs + CR0);
-	if (val & CR0_BOOT_MAN_NS)
+	val = readl(regs + PL330_CR0);
+	if (val & PL330_CR0_BOOT_MAN_NS)
 		pi->pcfg.mode |= DMAC_MODE_NS;
 	else
 		pi->pcfg.mode &= ~DMAC_MODE_NS;
 
-	val = readl(regs + CR0) >> CR0_NUM_EVENTS_SHIFT;
-	val &= CR0_NUM_EVENTS_MASK;
+	val = readl(regs + PL330_CR0) >> PL330_CR0_NUM_EVENTS_SHIFT;
+	val &= PL330_CR0_NUM_EVENTS_MASK;
 	val += 1;
 	pi->pcfg.num_events = val;
 
-	pi->pcfg.irq_ns = readl(regs + CR3);
+	pi->pcfg.irq_ns = readl(regs + PL330_CR3);
 
-	pi->pcfg.periph_id = get_id(pi, PERIPH_ID);
-	pi->pcfg.pcell_id = get_id(pi, PCELL_ID);
+	pi->pcfg.periph_id = get_id(pi, PL330_PERIPH_ID);
+	pi->pcfg.pcell_id = get_id(pi, PL330_PCELL_ID);
 }
 
 static inline void _reset_thread(struct pl330_thread *thrd)
@@ -2091,10 +2093,11 @@ static int pl330_add(struct pl330_info *pi)
 	regs = pi->base;
 
 	/* Check if we can handle this DMAC */
-	if ((get_id(pi, PERIPH_ID) & 0xfffff) != PERIPH_ID_VAL
-	   || get_id(pi, PCELL_ID) != PCELL_ID_VAL) {
+	if ((get_id(pi, PL330_PERIPH_ID) & 0xfffff) != PL330_PERIPH_ID_VAL
+	   || get_id(pi, PL330_PCELL_ID) != PL330_PCELL_ID_VAL) {
 		dev_err(pi->dev, "PERIPH_ID 0x%x, PCELL_ID 0x%x !\n",
-			get_id(pi, PERIPH_ID), get_id(pi, PCELL_ID));
+			get_id(pi, PL330_PERIPH_ID),
+			get_id(pi, PL330_PCELL_ID));
 		return -EINVAL;
 	}
 
-- 
1.7.10.4

