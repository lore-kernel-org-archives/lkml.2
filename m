Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2LJNoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:44:19 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35740 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab2LJNoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:44:15 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH v4 1/7] DMA: PL330: use prefix in reg names to build under x86
Date: Mon, 10 Dec 2012 14:42:30 +0100
Message-Id: <1355146956-6009-2-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

    This driver would not compile if ARM_AMBA is selected under x86,
    because "CS" and "DS" are already defined there.  But AMBA
    is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.

    The patch just adds the "PL330_" prefix to all registers,
    so it can be built by randomconfig after ARM_AMBA appears within x86.
    No other technical changes have been performed.
    The patch was build-tested only.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
[Davide Ciminaghi <ciminaghi@gnudd.com>: only registers prefixed]
Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---

The patch is quite big, but what it actually does is just renaming the pl330
registers. What follows is the output of

git diff --word-diff 6c57c3ff~..6c57c3ff

This format should allow better readability for reviewing.
Note that 'index' and '@@' strings at the beginning of lines
have been escaped by adding a leading '#' to avoid errors while actually
applying the patch.


diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
#index f7edb6f..939eec6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
#@@ -69,7 +69,7 @@ enum pl330_reqtype {
};

/* Register and Bit field Definitions */
#define [-DS-]{+PL330_DS+}		0x0
#define DS_ST_STOP		0x0
#define DS_ST_EXEC		0x1
#define DS_ST_CMISS		0x2
#@@ -83,33 +83,33 @@ enum pl330_reqtype {
#define DS_ST_FLTCMP		0xe
#define DS_ST_FAULT		0xf

#define [-DPC-]{+PL330_DPC+}		0x4
#define [-INTEN-]{+PL330_INTEN+}		0x20
#define [-ES-]{+PL330_ES+}		0x24
#define [-INTSTATUS-]{+PL330_INTSTATUS+}		0x28
#define [-INTCLR-]{+PL330_INTCLR+}		0x2c
#define [-FSM-]{+PL330_FSM+}		0x30
#define [-FSC-]{+PL330_FSC+}		0x34
#define [-FTM-]{+PL330_FTM+}		0x38

#define _FTC			0x40
#define [-FTC(n)-]{+PL330_FTC(n)+}		(_FTC + (n)*0x4)

#define _CS			0x100
#define [-CS(n)-]{+PL330_CS(n)+}		(_CS + (n)*0x8)
#define CS_CNS			(1 << 21)

#define _CPC			0x104
#define [-CPC(n)-]{+PL330_CPC(n)+}		(_CPC + (n)*0x8)

#define _SA			0x400
#define [-SA(n)-]{+PL330_SA(n)+}		(_SA + (n)*0x20)

#define _DA			0x404
#define [-DA(n)-]{+PL330_DA(n)+}		(_DA + (n)*0x20)

#define _CC			0x408
#define [-CC(n)-]{+PL330_CC(n)+}		(_CC + (n)*0x20)

#define CC_SRCINC		(1 << 0)
#define CC_DSTINC		(1 << 14)
#@@ -130,24 +130,24 @@ enum pl330_reqtype {
#define CC_SWAP_SHFT		28

#define _LC0			0x40c
#define [-LC0(n)-]{+PL330_LC0(n)+}		(_LC0 + (n)*0x20)

#define _LC1			0x410
#define [-LC1(n)-]{+PL330_LC1(n)+}		(_LC1 + (n)*0x20)

#define [-DBGSTATUS-]{+PL330_DBGSTATUS+}		0xd00
#define DBG_BUSY		(1 << 0)

#define [-DBGCMD-]{+PL330_DBGCMD+}		0xd04
#define [-DBGINST0-]{+PL330_DBGINST0+}		0xd08
#define [-DBGINST1-]{+PL330_DBGINST1+}		0xd0c

#define [-CR0-]{+PL330_CR0+}		0xe00
#define [-CR1-]{+PL330_CR1+}		0xe04
#define [-CR2-]{+PL330_CR2+}		0xe08
#define [-CR3-]{+PL330_CR3+}		0xe0c
#define [-CR4-]{+PL330_CR4+}		0xe10
#define [-CRD-]{+PL330_CRD+}		0xe14

#define PERIPH_ID		0xfe0
#define PERIPH_REV_SHIFT	20
#@@ -1016,7 +1016,7 @@ static bool _until_dmac_idle(struct pl330_thread *thrd)

	do {
		/* Until Manager is Idle */
		if (!(readl(regs + [-DBGSTATUS)-]{+PL330_DBGSTATUS)+} & DBG_BUSY))
			break;

		cpu_relax();
#@@ -1039,10 +1039,10 @@ static inline void _execute_DBGINSN(struct pl330_thread *thrd,
		val |= (1 << 0);
		val |= (thrd->id << 8); /* Channel Number */
	}
	writel(val, regs + [-DBGINST0);-]{+PL330_DBGINST0);+}

	val = *((u32 *)&insn[2]);
	writel(val, regs + [-DBGINST1);-]{+PL330_DBGINST1);+}

	/* If timed out due to halted state-machine */
	if (_until_dmac_idle(thrd)) {
#@@ -1051,7 +1051,7 @@ static inline void _execute_DBGINSN(struct pl330_thread *thrd,
	}

	/* Get going */
	writel(0, regs + [-DBGCMD);-]{+PL330_DBGCMD);+}
}

/*
#@@ -1076,9 +1076,9 @@ static inline u32 _state(struct pl330_thread *thrd)
	u32 val;

	if (is_manager(thrd))
		val = readl(regs + [-DS)-]{+PL330_DS)+} & 0xf;
	else
		val = readl(regs + [-CS(thrd->id))-]{+PL330_CS(thrd->id))+} & 0xf;

	switch (val) {
	case DS_ST_STOP:
#@@ -1145,7 +1145,8 @@ static void _stop(struct pl330_thread *thrd)
	_emit_KILL(0, insn);

	/* Stop generating interrupts for SEV */
	writel(readl(regs + [-INTEN)-]{+PL330_INTEN)+} & ~(1 << thrd->ev),
	       regs + [-INTEN);-]{+PL330_INTEN);+}

	_execute_DBGINSN(thrd, insn, is_manager(thrd));
}
#@@ -1184,7 +1185,7 @@ static bool _trigger(struct pl330_thread *thrd)

	if (r->cfg)
		ns = r->cfg->nonsecure ? 1 : 0;
	else if (readl(regs + [-CS(thrd->id))-]{+PL330_CS(thrd->id))+} & CS_CNS)
		ns = 1;
	else
		ns = 0;
#@@ -1200,7 +1201,7 @@ static bool _trigger(struct pl330_thread *thrd)
	_emit_GO(0, insn, &go);

	/* Set to generate interrupts for SEV */
	writel(readl(regs + [-INTEN)-]{+PL330_INTEN)+} | (1 << thrd->ev), regs + [-INTEN);-]{+PL330_INTEN);+}

	/* Only manager can execute GO */
	_execute_DBGINSN(thrd, insn, true);
#@@ -1575,7 +1576,7 @@ static int pl330_submit_req(void *ch_id, struct pl330_req *r)

		ccr = _prepare_ccr(r->cfg);
	} else {
		ccr = readl(regs + [-CC(thrd->id));-]{+PL330_CC(thrd->id));+}
	}

	/* If this req doesn't have valid xfer settings */
#@@ -1652,7 +1653,7 @@ static void pl330_dotask(unsigned long data)

			_stop(thrd);

			if (readl(regs + [-FSC)-]{+PL330_FSC)+} & (1 << thrd->id))
				err = PL330_ERR_FAIL;
			else
				err = PL330_ERR_ABORT;
#@@ -1697,13 +1698,13 @@ static int pl330_update(const struct pl330_info *pi)

	spin_lock_irqsave(&pl330->lock, flags);

	val = readl(regs + [-FSM)-]{+PL330_FSM)+} & 0x1;
	if (val)
		pl330->dmac_tbd.reset_mngr = true;
	else
		pl330->dmac_tbd.reset_mngr = false;

	val = readl(regs + [-FSC)-]{+PL330_FSC)+} & ((1 << pi->pcfg.num_chan) - 1);
	pl330->dmac_tbd.reset_chan |= val;
	if (val) {
		int i = 0;
#@@ -1711,8 +1712,8 @@ static int pl330_update(const struct pl330_info *pi)
			if (val & (1 << i)) {
				dev_info(pi->dev,
					"Reset Channel-%d\t CS-%x FTC-%x\n",
						i, readl(regs + [-CS(i)),-]{+PL330_CS(i)),+}
						readl(regs + [-FTC(i)));-]{+PL330_FTC(i)));+}
				_stop(&pl330->channels[i]);
			}
			i++;
#@@ -1720,7 +1721,7 @@ static int pl330_update(const struct pl330_info *pi)
	}

	/* Check which event happened i.e, thread notified */
	val = readl(regs + [-ES);-]{+PL330_ES);+}
	if (pi->pcfg.num_events < 32
			&& val & ~((1 << pi->pcfg.num_events) - 1)) {
		pl330->dmac_tbd.reset_dmac = true;
#@@ -1732,12 +1733,12 @@ static int pl330_update(const struct pl330_info *pi)
	for (ev = 0; ev < pi->pcfg.num_events; ev++) {
		if (val & (1 << ev)) { /* Event occurred */
			struct pl330_thread *thrd;
			u32 inten = readl(regs + [-INTEN);-]{+PL330_INTEN);+}
			int active;

			/* Clear the event */
			if (inten & (1 << ev))
				writel(1 << ev, regs + [-INTCLR);-]{+PL330_INTCLR);+}

			ret = 1;

#@@ -1944,41 +1945,41 @@ static void read_dmac_config(struct pl330_info *pi)
	void __iomem *regs = pi->base;
	u32 val;

	val = readl(regs + [-CRD)-]{+PL330_CRD)+} >> CRD_DATA_WIDTH_SHIFT;
	val &= CRD_DATA_WIDTH_MASK;
	pi->pcfg.data_bus_width = 8 * (1 << val);

	val = readl(regs + [-CRD)-]{+PL330_CRD)+} >> CRD_DATA_BUFF_SHIFT;
	val &= CRD_DATA_BUFF_MASK;
	pi->pcfg.data_buf_dep = val + 1;

	val = readl(regs + [-CR0)-]{+PL330_CR0)+} >> CR0_NUM_CHANS_SHIFT;
	val &= CR0_NUM_CHANS_MASK;
	val += 1;
	pi->pcfg.num_chan = val;

	val = readl(regs + [-CR0);-]{+PL330_CR0);+}
	if (val & CR0_PERIPH_REQ_SET) {
		val = (val >> CR0_NUM_PERIPH_SHIFT) & CR0_NUM_PERIPH_MASK;
		val += 1;
		pi->pcfg.num_peri = val;
		pi->pcfg.peri_ns = readl(regs + [-CR4);-]{+PL330_CR4);+}
	} else {
		pi->pcfg.num_peri = 0;
	}

	val = readl(regs + [-CR0);-]{+PL330_CR0);+}
	if (val & CR0_BOOT_MAN_NS)
		pi->pcfg.mode |= DMAC_MODE_NS;
	else
		pi->pcfg.mode &= ~DMAC_MODE_NS;

	val = readl(regs + [-CR0)-]{+PL330_CR0)+} >> CR0_NUM_EVENTS_SHIFT;
	val &= CR0_NUM_EVENTS_MASK;
	val += 1;
	pi->pcfg.num_events = val;

	pi->pcfg.irq_ns = readl(regs + [-CR3);-]{+PL330_CR3);+}

	pi->pcfg.periph_id = get_id(pi, PERIPH_ID);
	pi->pcfg.pcell_id = get_id(pi, PCELL_ID);

And here's the actual patch:

 drivers/dma/pl330.c |  107 ++++++++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 53 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index f7edb6f..939eec6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -69,7 +69,7 @@ enum pl330_reqtype {
 };
 
 /* Register and Bit field Definitions */
-#define DS			0x0
+#define PL330_DS		0x0
 #define DS_ST_STOP		0x0
 #define DS_ST_EXEC		0x1
 #define DS_ST_CMISS		0x2
@@ -83,33 +83,33 @@ enum pl330_reqtype {
 #define DS_ST_FLTCMP		0xe
 #define DS_ST_FAULT		0xf
 
-#define DPC			0x4
-#define INTEN			0x20
-#define ES			0x24
-#define INTSTATUS		0x28
-#define INTCLR			0x2c
-#define FSM			0x30
-#define FSC			0x34
-#define FTM			0x38
+#define PL330_DPC		0x4
+#define PL330_INTEN		0x20
+#define PL330_ES		0x24
+#define PL330_INTSTATUS		0x28
+#define PL330_INTCLR		0x2c
+#define PL330_FSM		0x30
+#define PL330_FSC		0x34
+#define PL330_FTM		0x38
 
 #define _FTC			0x40
-#define FTC(n)			(_FTC + (n)*0x4)
+#define PL330_FTC(n)		(_FTC + (n)*0x4)
 
 #define _CS			0x100
-#define CS(n)			(_CS + (n)*0x8)
+#define PL330_CS(n)		(_CS + (n)*0x8)
 #define CS_CNS			(1 << 21)
 
 #define _CPC			0x104
-#define CPC(n)			(_CPC + (n)*0x8)
+#define PL330_CPC(n)		(_CPC + (n)*0x8)
 
 #define _SA			0x400
-#define SA(n)			(_SA + (n)*0x20)
+#define PL330_SA(n)		(_SA + (n)*0x20)
 
 #define _DA			0x404
-#define DA(n)			(_DA + (n)*0x20)
+#define PL330_DA(n)		(_DA + (n)*0x20)
 
 #define _CC			0x408
-#define CC(n)			(_CC + (n)*0x20)
+#define PL330_CC(n)		(_CC + (n)*0x20)
 
 #define CC_SRCINC		(1 << 0)
 #define CC_DSTINC		(1 << 14)
@@ -130,24 +130,24 @@ enum pl330_reqtype {
 #define CC_SWAP_SHFT		28
 
 #define _LC0			0x40c
-#define LC0(n)			(_LC0 + (n)*0x20)
+#define PL330_LC0(n)		(_LC0 + (n)*0x20)
 
 #define _LC1			0x410
-#define LC1(n)			(_LC1 + (n)*0x20)
+#define PL330_LC1(n)		(_LC1 + (n)*0x20)
 
-#define DBGSTATUS		0xd00
+#define PL330_DBGSTATUS		0xd00
 #define DBG_BUSY		(1 << 0)
 
-#define DBGCMD			0xd04
-#define DBGINST0		0xd08
-#define DBGINST1		0xd0c
+#define PL330_DBGCMD		0xd04
+#define PL330_DBGINST0		0xd08
+#define PL330_DBGINST1		0xd0c
 
-#define CR0			0xe00
-#define CR1			0xe04
-#define CR2			0xe08
-#define CR3			0xe0c
-#define CR4			0xe10
-#define CRD			0xe14
+#define PL330_CR0		0xe00
+#define PL330_CR1		0xe04
+#define PL330_CR2		0xe08
+#define PL330_CR3		0xe0c
+#define PL330_CR4		0xe10
+#define PL330_CRD		0xe14
 
 #define PERIPH_ID		0xfe0
 #define PERIPH_REV_SHIFT	20
@@ -1016,7 +1016,7 @@ static bool _until_dmac_idle(struct pl330_thread *thrd)
 
 	do {
 		/* Until Manager is Idle */
-		if (!(readl(regs + DBGSTATUS) & DBG_BUSY))
+		if (!(readl(regs + PL330_DBGSTATUS) & DBG_BUSY))
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
@@ -1076,9 +1076,9 @@ static inline u32 _state(struct pl330_thread *thrd)
 	u32 val;
 
 	if (is_manager(thrd))
-		val = readl(regs + DS) & 0xf;
+		val = readl(regs + PL330_DS) & 0xf;
 	else
-		val = readl(regs + CS(thrd->id)) & 0xf;
+		val = readl(regs + PL330_CS(thrd->id)) & 0xf;
 
 	switch (val) {
 	case DS_ST_STOP:
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
+	else if (readl(regs + PL330_CS(thrd->id)) & CS_CNS)
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
@@ -1720,7 +1721,7 @@ static int pl330_update(const struct pl330_info *pi)
 	}
 
 	/* Check which event happened i.e, thread notified */
-	val = readl(regs + ES);
+	val = readl(regs + PL330_ES);
 	if (pi->pcfg.num_events < 32
 			&& val & ~((1 << pi->pcfg.num_events) - 1)) {
 		pl330->dmac_tbd.reset_dmac = true;
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
 
@@ -1944,41 +1945,41 @@ static void read_dmac_config(struct pl330_info *pi)
 	void __iomem *regs = pi->base;
 	u32 val;
 
-	val = readl(regs + CRD) >> CRD_DATA_WIDTH_SHIFT;
+	val = readl(regs + PL330_CRD) >> CRD_DATA_WIDTH_SHIFT;
 	val &= CRD_DATA_WIDTH_MASK;
 	pi->pcfg.data_bus_width = 8 * (1 << val);
 
-	val = readl(regs + CRD) >> CRD_DATA_BUFF_SHIFT;
+	val = readl(regs + PL330_CRD) >> CRD_DATA_BUFF_SHIFT;
 	val &= CRD_DATA_BUFF_MASK;
 	pi->pcfg.data_buf_dep = val + 1;
 
-	val = readl(regs + CR0) >> CR0_NUM_CHANS_SHIFT;
+	val = readl(regs + PL330_CR0) >> CR0_NUM_CHANS_SHIFT;
 	val &= CR0_NUM_CHANS_MASK;
 	val += 1;
 	pi->pcfg.num_chan = val;
 
-	val = readl(regs + CR0);
+	val = readl(regs + PL330_CR0);
 	if (val & CR0_PERIPH_REQ_SET) {
 		val = (val >> CR0_NUM_PERIPH_SHIFT) & CR0_NUM_PERIPH_MASK;
 		val += 1;
 		pi->pcfg.num_peri = val;
-		pi->pcfg.peri_ns = readl(regs + CR4);
+		pi->pcfg.peri_ns = readl(regs + PL330_CR4);
 	} else {
 		pi->pcfg.num_peri = 0;
 	}
 
-	val = readl(regs + CR0);
+	val = readl(regs + PL330_CR0);
 	if (val & CR0_BOOT_MAN_NS)
 		pi->pcfg.mode |= DMAC_MODE_NS;
 	else
 		pi->pcfg.mode &= ~DMAC_MODE_NS;
 
-	val = readl(regs + CR0) >> CR0_NUM_EVENTS_SHIFT;
+	val = readl(regs + PL330_CR0) >> CR0_NUM_EVENTS_SHIFT;
 	val &= CR0_NUM_EVENTS_MASK;
 	val += 1;
 	pi->pcfg.num_events = val;
 
-	pi->pcfg.irq_ns = readl(regs + CR3);
+	pi->pcfg.irq_ns = readl(regs + PL330_CR3);
 
 	pi->pcfg.periph_id = get_id(pi, PERIPH_ID);
 	pi->pcfg.pcell_id = get_id(pi, PCELL_ID);
-- 
1.7.10.4

