Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1GHEbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:31:13 -0400
Received: from mail.perches.com ([173.55.12.10]:3667 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1GHEbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:31:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: brcm80211: nicpci: Neatening
Date: Thu,  7 Jul 2011 21:31:06 -0700
Message-Id: <a4f987268ba032c6ea7ad856d1b548cd6a2aace1.1310099449.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary casts of void *.
Spacing and removal of unnecessary parentheses.
80 column wrapping.
Comment neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmsmac/nicpci.c |  276 +++++++++++++-------------
 1 files changed, 138 insertions(+), 138 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 4915592..3d71c59 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -38,28 +38,36 @@
 #define SRSH_BD_OFFSET                  6	/* word 6 */
 
 /* chipcontrol */
-#define CHIPCTRL_4321_PLL_DOWN	0x800000	/* serdes PLL down override */
+#define CHIPCTRL_4321_PLL_DOWN		0x800000/* serdes PLL down override */
 
 /* MDIO control */
 #define MDIOCTL_DIVISOR_MASK		0x7f	/* clock to be used on MDIO */
 #define MDIOCTL_DIVISOR_VAL		0x2
 #define MDIOCTL_PREAM_EN		0x80	/* Enable preamble sequnce */
-#define MDIOCTL_ACCESS_DONE		0x100	/* Tranaction complete */
+#define MDIOCTL_ACCESS_DONE		0x100	/* Transaction complete */
 
 /* MDIO Data */
 #define MDIODATA_MASK			0x0000ffff	/* data 2 bytes */
 #define MDIODATA_TA			0x00020000	/* Turnaround */
-#define MDIODATA_REGADDR_SHF_OLD	18	/* Regaddr shift (rev < 10) */
-#define MDIODATA_REGADDR_MASK_OLD	0x003c0000	/* Regaddr Mask (rev < 10) */
-#define MDIODATA_DEVADDR_SHF_OLD	22	/* Physmedia devaddr shift (rev < 10) */
-#define MDIODATA_DEVADDR_MASK_OLD	0x0fc00000	/* Physmedia devaddr Mask (rev < 10) */
-#define MDIODATA_REGADDR_SHF		18	/* Regaddr shift */
+
+#define MDIODATA_REGADDR_SHF		18		/* Regaddr shift */
 #define MDIODATA_REGADDR_MASK		0x007c0000	/* Regaddr Mask */
 #define MDIODATA_DEVADDR_SHF		23	/* Physmedia devaddr shift */
-#define MDIODATA_DEVADDR_MASK		0x0f800000	/* Physmedia devaddr Mask */
-#define MDIODATA_WRITE			0x10000000	/* write Transaction */
-#define MDIODATA_READ			0x20000000	/* Read Transaction */
-#define MDIODATA_START			0x40000000	/* start of Transaction */
+#define MDIODATA_DEVADDR_MASK		0x0f800000
+						/* Physmedia devaddr Mask */
+
+/* MDIO Data for older revisions < 10 */
+#define MDIODATA_REGADDR_SHF_OLD	18	/* Regaddr shift */
+#define MDIODATA_REGADDR_MASK_OLD	0x003c0000
+						/* Regaddr Mask */
+#define MDIODATA_DEVADDR_SHF_OLD	22	/* Physmedia devaddr shift  */
+#define MDIODATA_DEVADDR_MASK_OLD	0x0fc00000
+						/* Physmedia devaddr Mask */
+
+/* Transactions flags */
+#define MDIODATA_WRITE			0x10000000
+#define MDIODATA_READ			0x20000000
+#define MDIODATA_START			0x40000000
 
 #define MDIODATA_DEV_ADDR		0x0	/* dev address for serdes */
 #define	MDIODATA_BLK_ADDR		0x1F	/* blk address for serdes */
@@ -69,21 +77,21 @@
 #define MDIODATA_DEV_TX			0x1e	/* SERDES TX Dev */
 #define MDIODATA_DEV_RX			0x1f	/* SERDES RX Dev */
 
-	/* SERDES RX registers */
+/* SERDES RX registers */
 #define SERDES_RX_CTRL			1	/* Rx cntrl */
 #define SERDES_RX_TIMER1		2	/* Rx Timer1 */
 #define SERDES_RX_CDR			6	/* CDR */
 #define SERDES_RX_CDRBW			7	/* CDR BW */
-	/* SERDES RX control register */
+/* SERDES RX control register */
 #define SERDES_RX_CTRL_FORCE		0x80	/* rxpolarity_force */
 #define SERDES_RX_CTRL_POLARITY		0x40	/* rxpolarity_value */
 
-	/* SERDES PLL registers */
+/* SERDES PLL registers */
 #define SERDES_PLL_CTRL                 1	/* PLL control reg */
 #define PLL_CTRL_FREQDET_EN             0x4000	/* bit 14 is FREQDET on */
 
 /* Linkcontrol reg offset in PCIE Cap */
-#define PCIE_CAP_LINKCTRL_OFFSET	16	/* linkctrl offset in pcie cap */
+#define PCIE_CAP_LINKCTRL_OFFSET	16	/* offset in pcie cap */
 #define PCIE_CAP_LCREG_ASPML0s		0x01	/* ASPM L0s in linkctrl */
 #define PCIE_CAP_LCREG_ASPML1		0x02	/* ASPM L1 in linkctrl */
 #define PCIE_CLKREQ_ENAB		0x100	/* CLKREQ Enab in linkctrl */
@@ -97,9 +105,12 @@
 #define PCIE_L1THRESHOLDTIME_MASK       0xFF00	/* bits 8 - 15 */
 #define PCIE_L1THRESHOLDTIME_SHIFT      8	/* PCIE_L1THRESHOLDTIME_SHIFT */
 #define PCIE_L1THRESHOLD_WARVAL         0x72	/* WAR value */
-#define PCIE_ASPMTIMER_EXTEND		0x01000000	/* > rev7: enable extend ASPM timer */
+#define PCIE_ASPMTIMER_EXTEND		0x01000000
+						/* > rev7:
+						 * enable extend ASPM timer
+						 */
 
-/* different register spaces to access thr'u pcie indirect access */
+/* different register spaces to access thru pcie indirect access */
 #define PCIE_CONFIGREGS		1	/* Access to config space */
 #define PCIE_PCIEREGS		2	/* Access to pcie registers */
 
@@ -120,27 +131,27 @@
 struct sbpciregs {
 	u32 control;		/* PCI control */
 	u32 PAD[3];
-	u32 arbcontrol;	/* PCI arbiter control */
+	u32 arbcontrol;		/* PCI arbiter control */
 	u32 clkrun;		/* Clkrun Control (>=rev11) */
 	u32 PAD[2];
-	u32 intstatus;	/* Interrupt status */
+	u32 intstatus;		/* Interrupt status */
 	u32 intmask;		/* Interrupt mask */
 	u32 sbtopcimailbox;	/* Sonics to PCI mailbox */
 	u32 PAD[9];
-	u32 bcastaddr;	/* Sonics broadcast address */
-	u32 bcastdata;	/* Sonics broadcast data */
+	u32 bcastaddr;		/* Sonics broadcast address */
+	u32 bcastdata;		/* Sonics broadcast data */
 	u32 PAD[2];
 	u32 gpioin;		/* ro: gpio input (>=rev2) */
 	u32 gpioout;		/* rw: gpio output (>=rev2) */
-	u32 gpioouten;	/* rw: gpio output enable (>= rev2) */
+	u32 gpioouten;		/* rw: gpio output enable (>= rev2) */
 	u32 gpiocontrol;	/* rw: gpio control (>= rev2) */
 	u32 PAD[36];
-	u32 sbtopci0;	/* Sonics to PCI translation 0 */
-	u32 sbtopci1;	/* Sonics to PCI translation 1 */
-	u32 sbtopci2;	/* Sonics to PCI translation 2 */
+	u32 sbtopci0;		/* Sonics to PCI translation 0 */
+	u32 sbtopci1;		/* Sonics to PCI translation 1 */
+	u32 sbtopci2;		/* Sonics to PCI translation 2 */
 	u32 PAD[189];
 	u32 pcicfg[4][64];	/* 0x400 - 0x7FF, PCI Cfg Space (>=rev8) */
-	u16 sprom[36];	/* SPROM shadow Area */
+	u16 sprom[36];		/* SPROM shadow Area */
 	u32 PAD[46];
 };
 
@@ -148,17 +159,17 @@ struct sbpciregs {
 struct sbpcieregs {
 	u32 control;		/* host mode only */
 	u32 PAD[2];
-	u32 biststatus;	/* bist Status: 0x00C */
+	u32 biststatus;		/* bist Status: 0x00C */
 	u32 gpiosel;		/* PCIE gpio sel: 0x010 */
-	u32 gpioouten;	/* PCIE gpio outen: 0x14 */
+	u32 gpioouten;		/* PCIE gpio outen: 0x14 */
 	u32 PAD[2];
-	u32 intstatus;	/* Interrupt status: 0x20 */
+	u32 intstatus;		/* Interrupt status: 0x20 */
 	u32 intmask;		/* Interrupt mask: 0x24 */
 	u32 sbtopcimailbox;	/* sb to pcie mailbox: 0x028 */
 	u32 PAD[53];
-	u32 sbtopcie0;	/* sb to pcie translation 0: 0x100 */
-	u32 sbtopcie1;	/* sb to pcie translation 1: 0x104 */
-	u32 sbtopcie2;	/* sb to pcie translation 2: 0x108 */
+	u32 sbtopcie0;		/* sb to pcie translation 0: 0x100 */
+	u32 sbtopcie1;		/* sb to pcie translation 1: 0x104 */
+	u32 sbtopcie2;		/* sb to pcie translation 2: 0x108 */
 	u32 PAD[5];
 
 	/* pcie core supports in direct access to config space */
@@ -167,16 +178,18 @@ struct sbpcieregs {
 
 	/* mdio access to serdes */
 	u32 mdiocontrol;	/* controls the mdio access: 0x128 */
-	u32 mdiodata;	/* Data to the mdio access: 0x12c */
+	u32 mdiodata;		/* Data to the mdio access: 0x12c */
 
 	/* pcie protocol phy/dllp/tlp register indirect access mechanism */
-	u32 pcieindaddr;	/* indirect access to the internal register: 0x130 */
+	u32 pcieindaddr;	/* indirect access to
+				 * the internal register: 0x130
+				 */
 	u32 pcieinddata;	/* Data to/from the internal regsiter: 0x134 */
 
 	u32 clkreqenctrl;	/* >= rev 6, Clkreq rdma control : 0x138 */
 	u32 PAD[177];
 	u32 pciecfg[4][64];	/* 0x400 - 0x7FF, PCIE Cfg Space */
-	u16 sprom[64];	/* SPROM shadow Area */
+	u16 sprom[64];		/* SPROM shadow Area */
 };
 
 struct pcicore_info {
@@ -185,9 +198,11 @@ struct pcicore_info {
 		struct sbpciregs *pciregs;
 	} regs;			/* Memory mapped register to the core */
 
-	struct si_pub *sih;		/* System interconnect handle */
+	struct si_pub *sih;	/* System interconnect handle */
 	struct pci_dev *dev;
-	u8 pciecap_lcreg_offset;	/* PCIE capability LCreg offset in the config space */
+	u8 pciecap_lcreg_offset;/* PCIE capability LCreg offset
+				 * in the config space
+				 */
 	bool pcie_pr42767;
 	u8 pcie_polarity;
 	u8 pcie_war_aspm_ovr;	/* Override ASPM/Clkreq settings */
@@ -198,8 +213,9 @@ struct pcicore_info {
 
 /* debug/trace */
 #define	PCI_ERROR(args)
-#define PCIE_PUB(sih) \
-	(((sih)->bustype == PCI_BUS) && ((sih)->buscoretype == PCIE_CORE_ID))
+#define PCIE_PUB(sih)							\
+	(((sih)->bustype == PCI_BUS) &&					\
+	 ((sih)->buscoretype == PCIE_CORE_ID))
 
 /* routines to access mdio slave device registers */
 static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk);
@@ -219,14 +235,17 @@ static void pcie_war_noplldown(struct pcicore_info *pi);
 static void pcie_war_polarity(struct pcicore_info *pi);
 static void pcie_war_pci_setup(struct pcicore_info *pi);
 
-#define PCIE_ASPM(sih)	((PCIE_PUB(sih)) && (((sih)->buscorerev >= 3) && ((sih)->buscorerev <= 5)))
+#define PCIE_ASPM(sih)							\
+	((PCIE_PUB(sih)) &&						\
+	 (((sih)->buscorerev >= 3) &&					\
+	  ((sih)->buscorerev <= 5)))
 
 
 /* delay needed between the mdio control/ mdiodata register data access */
 #define PR28829_DELAY() udelay(10)
 
-/* Initialize the PCI core. It's caller's responsibility to make sure that this is done
- * only once
+/* Initialize the PCI core.
+ * It's caller's responsibility to make sure that this is done only once
  */
 void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 {
@@ -244,23 +263,19 @@ void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 
 	if (sih->buscoretype == PCIE_CORE_ID) {
 		u8 cap_ptr;
-		pi->regs.pcieregs = (struct sbpcieregs *) regs;
+		pi->regs.pcieregs = regs;
 		cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
 						      NULL, NULL);
 		pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
 	} else
-		pi->regs.pciregs = (struct sbpciregs *) regs;
+		pi->regs.pciregs = regs;
 
 	return pi;
 }
 
 void pcicore_deinit(void *pch)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
-
-	if (pi == NULL)
-		return;
-	kfree(pi);
+	kfree(pch);
 }
 
 /* return cap_offset if requested capability exists in the PCI config space */
@@ -289,7 +304,9 @@ pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 	if (cap_ptr == 0x00)
 		goto end;
 
-	/* loop thr'u the capability list and see if the pcie capabilty exists */
+	/* loop thru the capability list
+	 * and see if the pcie capability exists
+	 */
 
 	pci_read_config_byte(dev, cap_ptr, &cap_id);
 
@@ -299,18 +316,18 @@ pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 			break;
 		pci_read_config_byte(dev, cap_ptr, &cap_id);
 	}
-	if (cap_id != req_cap_id) {
+	if (cap_id != req_cap_id)
 		goto end;
-	}
+
 	/* found the caller requested capability */
-	if ((buf != NULL) && (buflen != NULL)) {
+	if (buf != NULL && buflen != NULL) {
 		u8 cap_data;
 
 		bufsize = *buflen;
 		if (!bufsize)
 			goto end;
 		*buflen = 0;
-		/* copy the cpability data excluding cap ID and next ptr */
+		/* copy the capability data excluding cap ID and next ptr */
 		cap_data = cap_ptr + 2;
 		if ((bufsize + cap_data) > PCI_SZPCR)
 			bufsize = PCI_SZPCR - cap_data;
@@ -321,29 +338,26 @@ pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 			buf++;
 		}
 	}
- end:
+end:
 	return cap_ptr;
 }
 
 /* ***** Register Access API */
 static uint
-pcie_readreg(struct sbpcieregs *pcieregs, uint addrtype,
-	     uint offset)
+pcie_readreg(struct sbpcieregs *pcieregs, uint addrtype, uint offset)
 {
 	uint retval = 0xFFFFFFFF;
 
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
-		W_REG((&pcieregs->configaddr), offset);
+		W_REG(&pcieregs->configaddr, offset);
 		(void)R_REG((&pcieregs->configaddr));
-		retval = R_REG(&(pcieregs->configdata));
+		retval = R_REG(&pcieregs->configdata);
 		break;
 	case PCIE_PCIEREGS:
-		W_REG(&(pcieregs->pcieindaddr), offset);
-		(void)R_REG((&pcieregs->pcieindaddr));
-		retval = R_REG(&(pcieregs->pcieinddata));
-		break;
-	default:
+		W_REG(&pcieregs->pcieindaddr, offset);
+		(void)R_REG(&pcieregs->pcieindaddr);
+		retval = R_REG(&pcieregs->pcieinddata);
 		break;
 	}
 
@@ -351,8 +365,7 @@ pcie_readreg(struct sbpcieregs *pcieregs, uint addrtype,
 }
 
 static uint
-pcie_writereg(struct sbpcieregs *pcieregs, uint addrtype,
-	      uint offset, uint val)
+pcie_writereg(struct sbpcieregs *pcieregs, uint addrtype, uint offset, uint val)
 {
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
@@ -375,20 +388,17 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 	uint mdiodata, i = 0;
 	uint pcie_serdes_spinwait = 200;
 
-	mdiodata =
-	    MDIODATA_START | MDIODATA_WRITE | (MDIODATA_DEV_ADDR <<
-					       MDIODATA_DEVADDR_SHF) |
-	    (MDIODATA_BLK_ADDR << MDIODATA_REGADDR_SHF) | MDIODATA_TA | (blk <<
-									 4);
+	mdiodata = (MDIODATA_START | MDIODATA_WRITE | MDIODATA_TA |
+		    (MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
+		    (MDIODATA_BLK_ADDR << MDIODATA_REGADDR_SHF) |
+		    (blk << 4));
 	W_REG(&pcieregs->mdiodata, mdiodata);
 
 	PR28829_DELAY();
 	/* retry till the transaction is complete */
 	while (i < pcie_serdes_spinwait) {
-		if (R_REG(&(pcieregs->mdiocontrol)) &
-		    MDIOCTL_ACCESS_DONE) {
+		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE)
 			break;
-		}
 		udelay(1000);
 		i++;
 	}
@@ -411,26 +421,27 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	uint pcie_serdes_spinwait = 10;
 
 	/* enable mdio access to SERDES */
-	W_REG((&pcieregs->mdiocontrol),
-	      MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
+	W_REG(&pcieregs->mdiocontrol, MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
 
 	if (pi->sih->buscorerev >= 10) {
-		/* new serdes is slower in rw, using two layers of reg address mapping */
+		/* new serdes is slower in rw,
+		 * using two layers of reg address mapping
+		 */
 		if (!pcie_mdiosetblock(pi, physmedia))
 			return 1;
-		mdiodata = (MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
-		    (regaddr << MDIODATA_REGADDR_SHF);
+		mdiodata = ((MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
+			    (regaddr << MDIODATA_REGADDR_SHF));
 		pcie_serdes_spinwait *= 20;
 	} else {
-		mdiodata = (physmedia << MDIODATA_DEVADDR_SHF_OLD) |
-		    (regaddr << MDIODATA_REGADDR_SHF_OLD);
+		mdiodata = ((physmedia << MDIODATA_DEVADDR_SHF_OLD) |
+			    (regaddr << MDIODATA_REGADDR_SHF_OLD));
 	}
 
 	if (!write)
 		mdiodata |= (MDIODATA_START | MDIODATA_READ | MDIODATA_TA);
 	else
-		mdiodata |=
-		    (MDIODATA_START | MDIODATA_WRITE | MDIODATA_TA | *val);
+		mdiodata |= (MDIODATA_START | MDIODATA_WRITE | MDIODATA_TA |
+			     *val);
 
 	W_REG(&pcieregs->mdiodata, mdiodata);
 
@@ -438,16 +449,14 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 
 	/* retry till the transaction is complete */
 	while (i < pcie_serdes_spinwait) {
-		if (R_REG(&(pcieregs->mdiocontrol)) &
-		    MDIOCTL_ACCESS_DONE) {
+		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE) {
 			if (!write) {
 				PR28829_DELAY();
-				*val =
-				    (R_REG(&(pcieregs->mdiodata)) &
-				     MDIODATA_MASK);
+				*val = (R_REG(&pcieregs->mdiodata) &
+					MDIODATA_MASK);
 			}
 			/* Disable mdio access to SERDES */
-			W_REG((&pcieregs->mdiocontrol), 0);
+			W_REG(&pcieregs->mdiocontrol, 0);
 			return 0;
 		}
 		udelay(1000);
@@ -456,7 +465,7 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 
 	PCI_ERROR(("pcie_mdioop: timed out op: %d\n", write));
 	/* Disable mdio access to SERDES */
-	W_REG((&pcieregs->mdiocontrol), 0);
+	W_REG(&pcieregs->mdiocontrol, 0);
 	return 1;
 }
 
@@ -478,7 +487,7 @@ pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint regaddr, uint val)
 /* ***** Support functions ***** */
 static u8 pcie_clkreq(void *pch, u32 mask, u32 val)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 	u32 reg_val;
 	u8 offset;
 
@@ -533,8 +542,8 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	case SI_PCIDOWN:
 		if (sih->buscorerev == 6) {	/* turn on serdes PLL down */
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol_addr), ~0,
-				   0);
+				   offsetof(chipcregs_t, chipcontrol_addr),
+				   ~0, 0);
 			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol_data),
 				   ~0x40, 0);
@@ -545,8 +554,8 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	case SI_PCIUP:
 		if (sih->buscorerev == 6) {	/* turn off serdes PLL down */
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol_addr), ~0,
-				   0);
+				   offsetof(chipcregs_t, chipcontrol_addr),
+				   ~0, 0);
 			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol_data),
 				   ~0x40, 0x40);
@@ -554,8 +563,6 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 			pcie_clkreq((void *)pi, 1, 0);
 		}
 		break;
-	default:
-		break;
 	}
 }
 
@@ -568,17 +575,16 @@ static void pcie_war_polarity(struct pcicore_info *pi)
 	if (pi->pcie_polarity != 0)
 		return;
 
-	w = pcie_readreg(pi->regs.pcieregs, PCIE_PCIEREGS,
-			 PCIE_PLP_STATUSREG);
+	w = pcie_readreg(pi->regs.pcieregs, PCIE_PCIEREGS, PCIE_PLP_STATUSREG);
 
 	/* Detect the current polarity at attach and force that polarity and
 	 * disable changing the polarity
 	 */
 	if ((w & PCIE_PLP_POLARITYINV_STAT) == 0)
-		pi->pcie_polarity = (SERDES_RX_CTRL_FORCE);
+		pi->pcie_polarity = SERDES_RX_CTRL_FORCE;
 	else
-		pi->pcie_polarity =
-		    (SERDES_RX_CTRL_FORCE | SERDES_RX_CTRL_POLARITY);
+		pi->pcie_polarity = (SERDES_RX_CTRL_FORCE |
+				     SERDES_RX_CTRL_POLARITY);
 }
 
 /* enable ASPM and CLKREQ if srom doesn't have it */
@@ -671,7 +677,7 @@ static void pcie_war_noplldown(struct pcicore_info *pi)
 	ai_corereg(pi->sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol),
 		   CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
 
-	/*  clear srom shadow backdoor */
+	/* clear srom shadow backdoor */
 	reg16 = &pcieregs->sprom[SRSH_BD_OFFSET];
 	W_REG(reg16, 0);
 }
@@ -683,7 +689,7 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	u32 w;
 
-	if ((sih->buscorerev == 0) || (sih->buscorerev == 1)) {
+	if (sih->buscorerev == 0 || sih->buscorerev == 1) {
 		w = pcie_readreg(pcieregs, PCIE_PCIEREGS,
 				 PCIE_TLP_WORKAROUNDSREG);
 		w |= 0x8;
@@ -693,7 +699,7 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 
 	if (sih->buscorerev == 1) {
 		w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_LCREG);
-		w |= (0x40);
+		w |= 0x40;
 		pcie_writereg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_LCREG, w);
 	}
 
@@ -705,8 +711,8 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 		/* Change the L1 threshold for better performance */
 		w = pcie_readreg(pcieregs, PCIE_PCIEREGS,
 				 PCIE_DLLP_PMTHRESHREG);
-		w &= ~(PCIE_L1THRESHOLDTIME_MASK);
-		w |= (PCIE_L1THRESHOLD_WARVAL << PCIE_L1THRESHOLDTIME_SHIFT);
+		w &= ~PCIE_L1THRESHOLDTIME_MASK;
+		w |= PCIE_L1THRESHOLD_WARVAL << PCIE_L1THRESHOLDTIME_SHIFT;
 		pcie_writereg(pcieregs, PCIE_PCIEREGS,
 			      PCIE_DLLP_PMTHRESHREG, w);
 
@@ -716,7 +722,9 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 	} else if (pi->sih->buscorerev == 7)
 		pcie_war_noplldown(pi);
 
-	/* Note that the fix is actually in the SROM, that's why this is open-ended */
+	/* Note that the fix is actually in the SROM,
+	 * that's why this is open-ended
+	 */
 	if (pi->sih->buscorerev >= 6)
 		pcie_misc_config_fixup(pi);
 }
@@ -724,16 +732,15 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 /* ***** Functions called during driver state changes ***** */
 void pcicore_attach(void *pch, char *pvars, int state)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 	struct si_pub *sih = pi->sih;
 
 	/* Determine if this board needs override */
 	if (PCIE_ASPM(sih)) {
-		if ((u32) getintvar(pvars, "boardflags2") & BFL2_PCIEWAR_OVR) {
+		if ((u32)getintvar(pvars, "boardflags2") & BFL2_PCIEWAR_OVR)
 			pi->pcie_war_aspm_ovr = PCIE_ASPM_DISAB;
-		} else {
+		else
 			pi->pcie_war_aspm_ovr = PCIE_ASPM_ENAB;
-		}
 	}
 
 	/* These need to happen in this order only */
@@ -749,7 +756,7 @@ void pcicore_attach(void *pch, char *pvars, int state)
 
 void pcicore_hwup(void *pch)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
@@ -759,7 +766,7 @@ void pcicore_hwup(void *pch)
 
 void pcicore_up(void *pch, int state)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
@@ -770,10 +777,12 @@ void pcicore_up(void *pch, int state)
 	pcie_clkreq_upd(pi, state);
 }
 
-/* When the device is going to enter D3 state (or the system is going to enter S3/S4 states */
+/* When the device is going to enter D3 state
+ * (or the system is going to enter S3/S4 states)
+ */
 void pcicore_sleep(void *pch)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 	u32 w;
 
 	if (!pi || !PCIE_ASPM(pi->sih))
@@ -788,7 +797,7 @@ void pcicore_sleep(void *pch)
 
 void pcicore_down(void *pch, int state)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
@@ -799,12 +808,10 @@ void pcicore_down(void *pch, int state)
 	pcie_extendL1timer(pi, false);
 }
 
-/*
- * precondition: current core is sii->buscoretype
- */
+/* precondition: current core is sii->buscoretype */
 void pcicore_fixcfg(void *pch, void *regs)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 	struct si_info *sii = SI_INFO(pi->sih);
 	struct sbpciregs *pciregs = regs;
 	struct sbpcieregs *pcieregs = regs;
@@ -812,39 +819,32 @@ void pcicore_fixcfg(void *pch, void *regs)
 	uint pciidx;
 
 	/* check 'pi' is correct and fix it if not */
-	if (sii->pub.buscoretype == PCIE_CORE_ID) {
+	if (sii->pub.buscoretype == PCIE_CORE_ID)
 		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
-	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
+	else if (sii->pub.buscoretype == PCI_CORE_ID)
 		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
-	}
 	pciidx = ai_coreidx(&sii->pub);
 	val16 = R_REG(reg16);
-	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16) pciidx) {
-		val16 =
-		    (u16) (pciidx << SRSH_PI_SHIFT) | (val16 &
-							  ~SRSH_PI_MASK);
+	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16)pciidx) {
+		val16 = (u16)(pciidx << SRSH_PI_SHIFT) |
+			(val16 & ~SRSH_PI_MASK);
 		W_REG(reg16, val16);
 	}
 }
 
-/*
- * precondition: current core is pci core
- */
+/* precondition: current core is pci core */
 void pcicore_pci_setup(void *pch, void *regs)
 {
-	struct pcicore_info *pi = (struct pcicore_info *) pch;
+	struct pcicore_info *pi = pch;
 	struct sbpciregs *pciregs = regs;
 	u32 w;
 
-	OR_REG(&pciregs->sbtopci2,
-	       (SBTOPCI_PREF | SBTOPCI_BURST));
+	OR_REG(&pciregs->sbtopci2, SBTOPCI_PREF | SBTOPCI_BURST);
 
 	if (SI_INFO(pi->sih)->pub.buscorerev >= 11) {
-		OR_REG(&pciregs->sbtopci2,
-		       SBTOPCI_RC_READMULTI);
+		OR_REG(&pciregs->sbtopci2, SBTOPCI_RC_READMULTI);
 		w = R_REG(&pciregs->clkrun);
-		W_REG(&pciregs->clkrun,
-		      (w | PCI_CLKRUN_DSBL));
+		W_REG(&pciregs->clkrun, w | PCI_CLKRUN_DSBL);
 		w = R_REG(&pciregs->clkrun);
 	}
 }
-- 
1.7.6.131.g99019

