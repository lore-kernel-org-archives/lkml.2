Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab2ERQlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640Ab2ERQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH EDAC v26 63/66] edac: Convert debugfX to edac_dbg(X,
Date: Fri, 18 May 2012 13:32:50 -0300
Message-Id: <1337358773-6919-64-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Use a more common debugging style.

Remove __FILE__ uses, add missing newlines,
coalesce formats and align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c        |  270 +++++++++++++++++++-------------------
 drivers/edac/amd64_edac_inj.c    |    6 +-
 drivers/edac/amd76x_edac.c       |   14 +-
 drivers/edac/cpc925_edac.c       |   22 ++--
 drivers/edac/e752x_edac.c        |   39 +++---
 drivers/edac/e7xxx_edac.c        |   35 +++---
 drivers/edac/edac_core.h         |   10 +-
 drivers/edac/edac_device.c       |   47 +++----
 drivers/edac/edac_device_sysfs.c |   70 +++++------
 drivers/edac/edac_mc.c           |  121 +++++++++---------
 drivers/edac/edac_mc_sysfs.c     |   37 +++---
 drivers/edac/edac_module.c       |    2 +-
 drivers/edac/edac_pci.c          |   26 ++--
 drivers/edac/edac_pci_sysfs.c    |   48 ++++----
 drivers/edac/i3000_edac.c        |   25 ++--
 drivers/edac/i3200_edac.c        |   26 ++--
 drivers/edac/i5000_edac.c        |  163 ++++++++++++------------
 drivers/edac/i5100_edac.c        |    4 +-
 drivers/edac/i5400_edac.c        |  165 ++++++++++++------------
 drivers/edac/i7300_edac.c        |  151 +++++++++++-----------
 drivers/edac/i7core_edac.c       |  144 ++++++++++-----------
 drivers/edac/i82443bxgx_edac.c   |   35 +++---
 drivers/edac/i82860_edac.c       |   23 ++--
 drivers/edac/i82875p_edac.c      |   27 ++--
 drivers/edac/i82975x_edac.c      |   29 ++--
 drivers/edac/mpc85xx_edac.c      |   22 ++--
 drivers/edac/mv64x60_edac.c      |   26 ++--
 drivers/edac/r82600_edac.c       |   30 ++--
 drivers/edac/sb_edac.c           |  240 +++++++++++++++++-----------------
 drivers/edac/x38_edac.c          |   26 ++--
 30 files changed, 921 insertions(+), 962 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9fbced7..b475295 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -321,8 +321,8 @@ found:
 	return edac_mc_find((int)node_id);
 
 err_no_match:
-	debugf2("sys_addr 0x%lx doesn't match any node\n",
-		(unsigned long)sys_addr);
+	edac_dbg(2, "sys_addr 0x%lx doesn't match any node\n",
+		 (unsigned long)sys_addr);
 
 	return NULL;
 }
@@ -393,15 +393,15 @@ static int input_addr_to_csrow(struct mem_ctl_info *mci, u64 input_addr)
 		mask = ~mask;
 
 		if ((input_addr & mask) == (base & mask)) {
-			debugf2("InputAddr 0x%lx matches csrow %d (node %d)\n",
-				(unsigned long)input_addr, csrow,
-				pvt->mc_node_id);
+			edac_dbg(2, "InputAddr 0x%lx matches csrow %d (node %d)\n",
+				 (unsigned long)input_addr, csrow,
+				 pvt->mc_node_id);
 
 			return csrow;
 		}
 	}
-	debugf2("no matching csrow for InputAddr 0x%lx (MC node %d)\n",
-		(unsigned long)input_addr, pvt->mc_node_id);
+	edac_dbg(2, "no matching csrow for InputAddr 0x%lx (MC node %d)\n",
+		 (unsigned long)input_addr, pvt->mc_node_id);
 
 	return -1;
 }
@@ -430,20 +430,20 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 
 	/* only revE and later have the DRAM Hole Address Register */
 	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_E) {
-		debugf1("  revision %d for node %d does not support DHAR\n",
-			pvt->ext_model, pvt->mc_node_id);
+		edac_dbg(1, "  revision %d for node %d does not support DHAR\n",
+			 pvt->ext_model, pvt->mc_node_id);
 		return 1;
 	}
 
 	/* valid for Fam10h and above */
 	if (boot_cpu_data.x86 >= 0x10 && !dhar_mem_hoist_valid(pvt)) {
-		debugf1("  Dram Memory Hoisting is DISABLED on this system\n");
+		edac_dbg(1, "  Dram Memory Hoisting is DISABLED on this system\n");
 		return 1;
 	}
 
 	if (!dhar_valid(pvt)) {
-		debugf1("  Dram Memory Hoisting is DISABLED on this node %d\n",
-			pvt->mc_node_id);
+		edac_dbg(1, "  Dram Memory Hoisting is DISABLED on this node %d\n",
+			 pvt->mc_node_id);
 		return 1;
 	}
 
@@ -475,9 +475,9 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	else
 		*hole_offset = k8_dhar_offset(pvt);
 
-	debugf1("  DHAR info for node %d base 0x%lx offset 0x%lx size 0x%lx\n",
-		pvt->mc_node_id, (unsigned long)*hole_base,
-		(unsigned long)*hole_offset, (unsigned long)*hole_size);
+	edac_dbg(1, "  DHAR info for node %d base 0x%lx offset 0x%lx size 0x%lx\n",
+		 pvt->mc_node_id, (unsigned long)*hole_base,
+		 (unsigned long)*hole_offset, (unsigned long)*hole_size);
 
 	return 0;
 }
@@ -528,10 +528,9 @@ static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
 			/* use DHAR to translate SysAddr to DramAddr */
 			dram_addr = sys_addr - hole_offset;
 
-			debugf2("using DHAR to translate SysAddr 0x%lx to "
-				"DramAddr 0x%lx\n",
-				(unsigned long)sys_addr,
-				(unsigned long)dram_addr);
+			edac_dbg(2, "using DHAR to translate SysAddr 0x%lx to DramAddr 0x%lx\n",
+				 (unsigned long)sys_addr,
+				 (unsigned long)dram_addr);
 
 			return dram_addr;
 		}
@@ -548,9 +547,8 @@ static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
 	 */
 	dram_addr = (sys_addr & GENMASK(0, 39)) - dram_base;
 
-	debugf2("using DRAM Base register to translate SysAddr 0x%lx to "
-		"DramAddr 0x%lx\n", (unsigned long)sys_addr,
-		(unsigned long)dram_addr);
+	edac_dbg(2, "using DRAM Base register to translate SysAddr 0x%lx to DramAddr 0x%lx\n",
+		 (unsigned long)sys_addr, (unsigned long)dram_addr);
 	return dram_addr;
 }
 
@@ -586,9 +584,9 @@ static u64 dram_addr_to_input_addr(struct mem_ctl_info *mci, u64 dram_addr)
 	input_addr = ((dram_addr >> intlv_shift) & GENMASK(12, 35)) +
 		      (dram_addr & 0xfff);
 
-	debugf2("  Intlv Shift=%d DramAddr=0x%lx maps to InputAddr=0x%lx\n",
-		intlv_shift, (unsigned long)dram_addr,
-		(unsigned long)input_addr);
+	edac_dbg(2, "  Intlv Shift=%d DramAddr=0x%lx maps to InputAddr=0x%lx\n",
+		 intlv_shift, (unsigned long)dram_addr,
+		 (unsigned long)input_addr);
 
 	return input_addr;
 }
@@ -604,8 +602,8 @@ static u64 sys_addr_to_input_addr(struct mem_ctl_info *mci, u64 sys_addr)
 	input_addr =
 	    dram_addr_to_input_addr(mci, sys_addr_to_dram_addr(mci, sys_addr));
 
-	debugf2("SysAdddr 0x%lx translates to InputAddr 0x%lx\n",
-		(unsigned long)sys_addr, (unsigned long)input_addr);
+	edac_dbg(2, "SysAdddr 0x%lx translates to InputAddr 0x%lx\n",
+		 (unsigned long)sys_addr, (unsigned long)input_addr);
 
 	return input_addr;
 }
@@ -637,8 +635,8 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 
 	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
 	if (intlv_shift == 0) {
-		debugf1("    InputAddr 0x%lx translates to DramAddr of "
-			"same value\n",	(unsigned long)input_addr);
+		edac_dbg(1, "    InputAddr 0x%lx translates to DramAddr of same value\n",
+			 (unsigned long)input_addr);
 
 		return input_addr;
 	}
@@ -649,9 +647,9 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 	intlv_sel = dram_intlv_sel(pvt, node_id) & ((1 << intlv_shift) - 1);
 	dram_addr = bits + (intlv_sel << 12);
 
-	debugf1("InputAddr 0x%lx translates to DramAddr 0x%lx "
-		"(%d node interleave bits)\n", (unsigned long)input_addr,
-		(unsigned long)dram_addr, intlv_shift);
+	edac_dbg(1, "InputAddr 0x%lx translates to DramAddr 0x%lx (%d node interleave bits)\n",
+		 (unsigned long)input_addr,
+		 (unsigned long)dram_addr, intlv_shift);
 
 	return dram_addr;
 }
@@ -673,9 +671,9 @@ static u64 dram_addr_to_sys_addr(struct mem_ctl_info *mci, u64 dram_addr)
 		    (dram_addr < (hole_base + hole_size))) {
 			sys_addr = dram_addr + hole_offset;
 
-			debugf1("using DHAR to translate DramAddr 0x%lx to "
-				"SysAddr 0x%lx\n", (unsigned long)dram_addr,
-				(unsigned long)sys_addr);
+			edac_dbg(1, "using DHAR to translate DramAddr 0x%lx to SysAddr 0x%lx\n",
+				 (unsigned long)dram_addr,
+				 (unsigned long)sys_addr);
 
 			return sys_addr;
 		}
@@ -697,9 +695,9 @@ static u64 dram_addr_to_sys_addr(struct mem_ctl_info *mci, u64 dram_addr)
 	 */
 	sys_addr |= ~((sys_addr & (1ull << 39)) - 1);
 
-	debugf1("    Node %d, DramAddr 0x%lx to SysAddr 0x%lx\n",
-		pvt->mc_node_id, (unsigned long)dram_addr,
-		(unsigned long)sys_addr);
+	edac_dbg(1, "    Node %d, DramAddr 0x%lx to SysAddr 0x%lx\n",
+		 pvt->mc_node_id, (unsigned long)dram_addr,
+		 (unsigned long)sys_addr);
 
 	return sys_addr;
 }
@@ -768,49 +766,48 @@ static void amd64_debug_display_dimm_sizes(struct amd64_pvt *, u8);
 
 static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 {
-	debugf1("F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
+	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
 
-	debugf1("  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
-		(dclr & BIT(16)) ?  "un" : "",
-		(dclr & BIT(19)) ? "yes" : "no");
+	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
+		 (dclr & BIT(16)) ?  "un" : "",
+		 (dclr & BIT(19)) ? "yes" : "no");
 
-	debugf1("  PAR/ERR parity: %s\n",
-		(dclr & BIT(8)) ?  "enabled" : "disabled");
+	edac_dbg(1, "  PAR/ERR parity: %s\n",
+		 (dclr & BIT(8)) ?  "enabled" : "disabled");
 
 	if (boot_cpu_data.x86 == 0x10)
-		debugf1("  DCT 128bit mode width: %s\n",
-			(dclr & BIT(11)) ?  "128b" : "64b");
+		edac_dbg(1, "  DCT 128bit mode width: %s\n",
+			 (dclr & BIT(11)) ?  "128b" : "64b");
 
-	debugf1("  x4 logical DIMMs present: L0: %s L1: %s L2: %s L3: %s\n",
-		(dclr & BIT(12)) ?  "yes" : "no",
-		(dclr & BIT(13)) ?  "yes" : "no",
-		(dclr & BIT(14)) ?  "yes" : "no",
-		(dclr & BIT(15)) ?  "yes" : "no");
+	edac_dbg(1, "  x4 logical DIMMs present: L0: %s L1: %s L2: %s L3: %s\n",
+		 (dclr & BIT(12)) ?  "yes" : "no",
+		 (dclr & BIT(13)) ?  "yes" : "no",
+		 (dclr & BIT(14)) ?  "yes" : "no",
+		 (dclr & BIT(15)) ?  "yes" : "no");
 }
 
 /* Display and decode various NB registers for debug purposes. */
 static void dump_misc_regs(struct amd64_pvt *pvt)
 {
-	debugf1("F3xE8 (NB Cap): 0x%08x\n", pvt->nbcap);
+	edac_dbg(1, "F3xE8 (NB Cap): 0x%08x\n", pvt->nbcap);
 
-	debugf1("  NB two channel DRAM capable: %s\n",
-		(pvt->nbcap & NBCAP_DCT_DUAL) ? "yes" : "no");
+	edac_dbg(1, "  NB two channel DRAM capable: %s\n",
+		 (pvt->nbcap & NBCAP_DCT_DUAL) ? "yes" : "no");
 
-	debugf1("  ECC capable: %s, ChipKill ECC capable: %s\n",
-		(pvt->nbcap & NBCAP_SECDED) ? "yes" : "no",
-		(pvt->nbcap & NBCAP_CHIPKILL) ? "yes" : "no");
+	edac_dbg(1, "  ECC capable: %s, ChipKill ECC capable: %s\n",
+		 (pvt->nbcap & NBCAP_SECDED) ? "yes" : "no",
+		 (pvt->nbcap & NBCAP_CHIPKILL) ? "yes" : "no");
 
 	amd64_dump_dramcfg_low(pvt->dclr0, 0);
 
-	debugf1("F3xB0 (Online Spare): 0x%08x\n", pvt->online_spare);
+	edac_dbg(1, "F3xB0 (Online Spare): 0x%08x\n", pvt->online_spare);
 
-	debugf1("F1xF0 (DRAM Hole Address): 0x%08x, base: 0x%08x, "
-			"offset: 0x%08x\n",
-			pvt->dhar, dhar_base(pvt),
-			(boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt)
-						   : f10_dhar_offset(pvt));
+	edac_dbg(1, "F1xF0 (DRAM Hole Address): 0x%08x, base: 0x%08x, offset: 0x%08x\n",
+		 pvt->dhar, dhar_base(pvt),
+		 (boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt)
+		 : f10_dhar_offset(pvt));
 
-	debugf1("  DramHoleValid: %s\n", dhar_valid(pvt) ? "yes" : "no");
+	edac_dbg(1, "  DramHoleValid: %s\n", dhar_valid(pvt) ? "yes" : "no");
 
 	amd64_debug_display_dimm_sizes(pvt, 0);
 
@@ -857,15 +854,15 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 		u32 *base1 = &pvt->csels[1].csbases[cs];
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg0, base0))
-			debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
-				cs, *base0, reg0);
+			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
+				 cs, *base0, reg0);
 
 		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
 			continue;
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
-			debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
-				cs, *base1, reg1);
+			edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
+				 cs, *base1, reg1);
 	}
 
 	for_each_chip_select_mask(cs, 0, pvt) {
@@ -875,15 +872,15 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 		u32 *mask1 = &pvt->csels[1].csmasks[cs];
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg0, mask0))
-			debugf0("    DCSM0[%d]=0x%08x reg: F2x%x\n",
-				cs, *mask0, reg0);
+			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
+				 cs, *mask0, reg0);
 
 		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
 			continue;
 
 		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
-			debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
-				cs, *mask1, reg1);
+			edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
+				 cs, *mask1, reg1);
 	}
 }
 
@@ -1193,7 +1190,7 @@ static int f1x_early_channel_count(struct amd64_pvt *pvt)
 	 * Need to check DCT0[0] and DCT1[0] to see if only one of them has
 	 * their CSEnable bit on. If so, then SINGLE DIMM case.
 	 */
-	debugf0("Data width is not 128 bits - need more decoding\n");
+	edac_dbg(0, "Data width is not 128 bits - need more decoding\n");
 
 	/*
 	 * Check DRAM Bank Address Mapping values for each DIMM to see if there
@@ -1272,25 +1269,24 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
 		return;
 
 	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
-		debugf0("F2x110 (DCTSelLow): 0x%08x, High range addrs at: 0x%x\n",
-			pvt->dct_sel_lo, dct_sel_baseaddr(pvt));
+		edac_dbg(0, "F2x110 (DCTSelLow): 0x%08x, High range addrs at: 0x%x\n",
+			 pvt->dct_sel_lo, dct_sel_baseaddr(pvt));
 
-		debugf0("  DCTs operate in %s mode.\n",
-			(dct_ganging_enabled(pvt) ? "ganged" : "unganged"));
+		edac_dbg(0, "  DCTs operate in %s mode\n",
+			 (dct_ganging_enabled(pvt) ? "ganged" : "unganged"));
 
 		if (!dct_ganging_enabled(pvt))
-			debugf0("  Address range split per DCT: %s\n",
-				(dct_high_range_enabled(pvt) ? "yes" : "no"));
+			edac_dbg(0, "  Address range split per DCT: %s\n",
+				 (dct_high_range_enabled(pvt) ? "yes" : "no"));
 
-		debugf0("  data interleave for ECC: %s, "
-			"DRAM cleared since last warm reset: %s\n",
-			(dct_data_intlv_enabled(pvt) ? "enabled" : "disabled"),
-			(dct_memory_cleared(pvt) ? "yes" : "no"));
+		edac_dbg(0, "  data interleave for ECC: %s, DRAM cleared since last warm reset: %s\n",
+			 (dct_data_intlv_enabled(pvt) ? "enabled" : "disabled"),
+			 (dct_memory_cleared(pvt) ? "yes" : "no"));
 
-		debugf0("  channel interleave: %s, "
-			"interleave bits selector: 0x%x\n",
-			(dct_interleave_enabled(pvt) ? "enabled" : "disabled"),
-			dct_sel_interleave_addr(pvt));
+		edac_dbg(0, "  channel interleave: %s, "
+			 "interleave bits selector: 0x%x\n",
+			 (dct_interleave_enabled(pvt) ? "enabled" : "disabled"),
+			 dct_sel_interleave_addr(pvt));
 	}
 
 	amd64_read_dct_pci_cfg(pvt, DCT_SEL_HI, &pvt->dct_sel_hi);
@@ -1428,7 +1424,7 @@ static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
 
 	pvt = mci->pvt_info;
 
-	debugf1("input addr: 0x%llx, DCT: %d\n", in_addr, dct);
+	edac_dbg(1, "input addr: 0x%llx, DCT: %d\n", in_addr, dct);
 
 	for_each_chip_select(csrow, dct, pvt) {
 		if (!csrow_enabled(csrow, dct, pvt))
@@ -1436,19 +1432,18 @@ static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
 
 		get_cs_base_and_mask(pvt, csrow, dct, &cs_base, &cs_mask);
 
-		debugf1("    CSROW=%d CSBase=0x%llx CSMask=0x%llx\n",
-			csrow, cs_base, cs_mask);
+		edac_dbg(1, "    CSROW=%d CSBase=0x%llx CSMask=0x%llx\n",
+			 csrow, cs_base, cs_mask);
 
 		cs_mask = ~cs_mask;
 
-		debugf1("    (InputAddr & ~CSMask)=0x%llx "
-			"(CSBase & ~CSMask)=0x%llx\n",
-			(in_addr & cs_mask), (cs_base & cs_mask));
+		edac_dbg(1, "    (InputAddr & ~CSMask)=0x%llx (CSBase & ~CSMask)=0x%llx\n",
+			 (in_addr & cs_mask), (cs_base & cs_mask));
 
 		if ((in_addr & cs_mask) == (cs_base & cs_mask)) {
 			cs_found = f10_process_possible_spare(pvt, dct, csrow);
 
-			debugf1(" MATCH csrow=%d\n", cs_found);
+			edac_dbg(1, " MATCH csrow=%d\n", cs_found);
 			break;
 		}
 	}
@@ -1505,8 +1500,8 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	u8 intlv_en   = dram_intlv_en(pvt, range);
 	u32 intlv_sel = dram_intlv_sel(pvt, range);
 
-	debugf1("(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
-		range, sys_addr, get_dram_limit(pvt, range));
+	edac_dbg(1, "(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
+		 range, sys_addr, get_dram_limit(pvt, range));
 
 	if (dhar_valid(pvt) &&
 	    dhar_base(pvt) <= sys_addr &&
@@ -1562,7 +1557,7 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 				     (chan_addr & 0xfff);
 	}
 
-	debugf1("   Normalized DCT addr: 0x%llx\n", chan_addr);
+	edac_dbg(1, "   Normalized DCT addr: 0x%llx\n", chan_addr);
 
 	cs_found = f1x_lookup_addr_in_dct(chan_addr, node_id, channel);
 
@@ -1664,7 +1659,8 @@ static void amd64_debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 	dcsb = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->csels[1].csbases
 						   : pvt->csels[0].csbases;
 
-	debugf1("F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n", ctrl, dbam);
+	edac_dbg(1, "F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n",
+		 ctrl, dbam);
 
 	edac_printk(KERN_DEBUG, EDAC_MC, "DCT%d chip selects:\n", ctrl);
 
@@ -1840,7 +1836,7 @@ static int decode_syndrome(u16 syndrome, u16 *vectors, unsigned num_vecs,
 		}
 	}
 
-	debugf0("syndrome(%x) not found\n", syndrome);
+	edac_dbg(0, "syndrome(%x) not found\n", syndrome);
 	return -1;
 }
 
@@ -2047,9 +2043,9 @@ static int reserve_mc_sibling_devs(struct amd64_pvt *pvt, u16 f1_id, u16 f3_id)
 
 		return -ENODEV;
 	}
-	debugf1("F1: %s\n", pci_name(pvt->F1));
-	debugf1("F2: %s\n", pci_name(pvt->F2));
-	debugf1("F3: %s\n", pci_name(pvt->F3));
+	edac_dbg(1, "F1: %s\n", pci_name(pvt->F1));
+	edac_dbg(1, "F2: %s\n", pci_name(pvt->F2));
+	edac_dbg(1, "F3: %s\n", pci_name(pvt->F3));
 
 	return 0;
 }
@@ -2076,15 +2072,15 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	 * those are Read-As-Zero
 	 */
 	rdmsrl(MSR_K8_TOP_MEM1, pvt->top_mem);
-	debugf0("  TOP_MEM:  0x%016llx\n", pvt->top_mem);
+	edac_dbg(0, "  TOP_MEM:  0x%016llx\n", pvt->top_mem);
 
 	/* check first whether TOP_MEM2 is enabled */
 	rdmsrl(MSR_K8_SYSCFG, msr_val);
 	if (msr_val & (1U << 21)) {
 		rdmsrl(MSR_K8_TOP_MEM2, pvt->top_mem2);
-		debugf0("  TOP_MEM2: 0x%016llx\n", pvt->top_mem2);
+		edac_dbg(0, "  TOP_MEM2: 0x%016llx\n", pvt->top_mem2);
 	} else
-		debugf0("  TOP_MEM2 disabled.\n");
+		edac_dbg(0, "  TOP_MEM2 disabled\n");
 
 	amd64_read_pci_cfg(pvt->F3, NBCAP, &pvt->nbcap);
 
@@ -2100,17 +2096,17 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 		if (!rw)
 			continue;
 
-		debugf1("  DRAM range[%d], base: 0x%016llx; limit: 0x%016llx\n",
-			range,
-			get_dram_base(pvt, range),
-			get_dram_limit(pvt, range));
+		edac_dbg(1, "  DRAM range[%d], base: 0x%016llx; limit: 0x%016llx\n",
+			 range,
+			 get_dram_base(pvt, range),
+			 get_dram_limit(pvt, range));
 
-		debugf1("   IntlvEn=%s; Range access: %s%s IntlvSel=%d DstNode=%d\n",
-			dram_intlv_en(pvt, range) ? "Enabled" : "Disabled",
-			(rw & 0x1) ? "R" : "-",
-			(rw & 0x2) ? "W" : "-",
-			dram_intlv_sel(pvt, range),
-			dram_dst_node(pvt, range));
+		edac_dbg(1, "   IntlvEn=%s; Range access: %s%s IntlvSel=%d DstNode=%d\n",
+			 dram_intlv_en(pvt, range) ? "Enabled" : "Disabled",
+			 (rw & 0x1) ? "R" : "-",
+			 (rw & 0x2) ? "W" : "-",
+			 dram_intlv_sel(pvt, range),
+			 dram_dst_node(pvt, range));
 	}
 
 	read_dct_base_mask(pvt);
@@ -2191,9 +2187,9 @@ static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
 
 	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
 
-	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
-	debugf0("    nr_pages/channel= %u  channel-count = %d\n",
-		nr_pages, pvt->channel_count);
+	edac_dbg(0, "  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
+	edac_dbg(0, "    nr_pages/channel= %u  channel-count = %d\n",
+		 nr_pages, pvt->channel_count);
 
 	return nr_pages;
 }
@@ -2218,22 +2214,19 @@ static int init_csrows(struct mem_ctl_info *mci)
 
 	pvt->nbcfg = val;
 
-	debugf0("node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
-		pvt->mc_node_id, val,
-		!!(val & NBCFG_CHIPKILL), !!(val & NBCFG_ECC_ENABLE));
+	edac_dbg(0, "node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
+		 pvt->mc_node_id, val,
+		 !!(val & NBCFG_CHIPKILL), !!(val & NBCFG_ECC_ENABLE));
 
 	for_each_chip_select(i, 0, pvt) {
 		csrow = mci->csrows[i];
 
 		if (!csrow_enabled(i, 0, pvt) && !csrow_enabled(i, 1, pvt)) {
-			debugf1("----CSROW %d EMPTY for node %d\n", i,
-				pvt->mc_node_id);
+			edac_dbg(1, "----CSROW %d VALID for MC node %d\n",
+				 i, pvt->mc_node_id);
 			continue;
 		}
 
-		debugf1("----CSROW %d VALID for MC node %d\n",
-			i, pvt->mc_node_id);
-
 		empty = 0;
 		if (csrow_enabled(i, 0, pvt))
 			nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
@@ -2245,8 +2238,9 @@ static int init_csrows(struct mem_ctl_info *mci)
 
 		mtype = amd64_determine_memory_type(pvt, i);
 
-		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
-		debugf1("    nr_pages: %u\n", nr_pages * pvt->channel_count);
+		edac_dbg(1, "  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
+		edac_dbg(1, "    nr_pages: %u\n",
+			 nr_pages * pvt->channel_count);
 
 		/*
 		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
@@ -2298,9 +2292,9 @@ static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
 		struct msr *reg = per_cpu_ptr(msrs, cpu);
 		nbe = reg->l & MSR_MCGCTL_NBE;
 
-		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
-			cpu, reg->q,
-			(nbe ? "enabled" : "disabled"));
+		edac_dbg(0, "core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
+			 cpu, reg->q,
+			 (nbe ? "enabled" : "disabled"));
 
 		if (!nbe)
 			goto out;
@@ -2371,8 +2365,8 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 
 	amd64_read_pci_cfg(F3, NBCFG, &value);
 
-	debugf0("1: node %d, NBCFG=0x%08x[DramEccEn: %d]\n",
-		nid, value, !!(value & NBCFG_ECC_ENABLE));
+	edac_dbg(0, "1: node %d, NBCFG=0x%08x[DramEccEn: %d]\n",
+		 nid, value, !!(value & NBCFG_ECC_ENABLE));
 
 	if (!(value & NBCFG_ECC_ENABLE)) {
 		amd64_warn("DRAM ECC disabled on this node, enabling...\n");
@@ -2396,8 +2390,8 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 		s->flags.nb_ecc_prev = 1;
 	}
 
-	debugf0("2: node %d, NBCFG=0x%08x[DramEccEn: %d]\n",
-		nid, value, !!(value & NBCFG_ECC_ENABLE));
+	edac_dbg(0, "2: node %d, NBCFG=0x%08x[DramEccEn: %d]\n",
+		 nid, value, !!(value & NBCFG_ECC_ENABLE));
 
 	return ret;
 }
@@ -2615,11 +2609,11 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 
 	ret = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf1("failed edac_mc_add_mc()\n");
+		edac_dbg(1, "failed edac_mc_add_mc()\n");
 		goto err_add_mc;
 	}
 	if (set_mc_sysfs_attrs(mci)) {
-		debugf1("failed edac_mc_add_mc()\n");
+		edac_dbg(1, "failed edac_mc_add_mc()\n");
 		goto err_add_sysfs;
 	}
 
@@ -2660,7 +2654,7 @@ static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 
 	ret = pci_enable_device(pdev);
 	if (ret < 0) {
-		debugf0("ret=%d\n", ret);
+		edac_dbg(0, "ret=%d\n", ret);
 		return -EIO;
 	}
 
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index ef1ff4e..53d972e 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -142,7 +142,8 @@ static ssize_t amd64_inject_read_store(struct device *dev,
 		/* Issue 'word' and 'bit' along with the READ request */
 		amd64_write_pci_cfg(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
-		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
+		edac_dbg(0, "section=0x%x word_bits=0x%x\n",
+			 section, word_bits);
 
 		return count;
 	}
@@ -177,7 +178,8 @@ static ssize_t amd64_inject_write_store(struct device *dev,
 		/* Issue 'word' and 'bit' along with the READ request */
 		amd64_write_pci_cfg(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
-		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
+		edac_dbg(0, "section=0x%x word_bits=0x%x\n",
+			 section, word_bits);
 
 		return count;
 	}
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 601db57..c974da7 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -180,7 +180,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 static void amd76x_check(struct mem_ctl_info *mci)
 {
 	struct amd76x_error_info info;
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	amd76x_get_error_info(mci, &info);
 	amd76x_process_error_info(mci, &info, 1);
 }
@@ -241,7 +241,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 ems_mode;
 	struct amd76x_error_info discard;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
 
@@ -256,7 +256,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("mci = %p\n", mci);
+	edac_dbg(0, "mci = %p\n", mci);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -276,7 +276,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -292,7 +292,7 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	return 0;
 
 fail:
@@ -304,7 +304,7 @@ fail:
 static int __devinit amd76x_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* don't need to call pci_enable_device() */
 	return amd76x_probe1(pdev, ent->driver_data);
@@ -322,7 +322,7 @@ static void __devexit amd76x_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (amd76x_pci)
 		edac_pci_release_generic_ctl(amd76x_pci);
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index fa39a78..a7ea398 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -316,12 +316,12 @@ static void get_total_mem(struct cpc925_mc_pdata *pdata)
 		reg += aw;
 		size = of_read_number(reg, sw);
 		reg += sw;
-		debugf1("start 0x%lx, size 0x%lx\n", start, size);
+		edac_dbg(1, "start 0x%lx, size 0x%lx\n", start, size);
 		pdata->total_mem += size;
 	} while (reg < reg_end);
 
 	of_node_put(np);
-	debugf0("total_mem 0x%lx\n", pdata->total_mem);
+	edac_dbg(0, "total_mem 0x%lx\n", pdata->total_mem);
 }
 
 static void cpc925_init_csrows(struct mem_ctl_info *mci)
@@ -511,7 +511,7 @@ static void cpc925_mc_get_pfn(struct mem_ctl_info *mci, u32 mear,
 	*offset = pa & (PAGE_SIZE - 1);
 	*pfn = pa >> PAGE_SHIFT;
 
-	debugf0("ECC physical address 0x%lx\n", pa);
+	edac_dbg(0, "ECC physical address 0x%lx\n", pa);
 }
 
 static int cpc925_mc_find_channel(struct mem_ctl_info *mci, u16 syndrome)
@@ -851,8 +851,8 @@ static void cpc925_add_edac_devices(void __iomem *vbase)
 			goto err2;
 		}
 
-		debugf0("Successfully added edac device for %s\n",
-			dev_info->ctl_name);
+		edac_dbg(0, "Successfully added edac device for %s\n",
+			 dev_info->ctl_name);
 
 		continue;
 
@@ -883,8 +883,8 @@ static void cpc925_del_edac_devices(void)
 		if (dev_info->exit)
 			dev_info->exit(dev_info);
 
-		debugf0("Successfully deleted edac device for %s\n",
-			dev_info->ctl_name);
+		edac_dbg(0, "Successfully deleted edac device for %s\n",
+			 dev_info->ctl_name);
 	}
 }
 
@@ -899,7 +899,7 @@ static int cpc925_get_sdram_scrub_rate(struct mem_ctl_info *mci)
 	mscr = __raw_readl(pdata->vbase + REG_MSCR_OFFSET);
 	si = (mscr & MSCR_SI_MASK) >> MSCR_SI_SHIFT;
 
-	debugf0("Mem Scrub Ctrl Register 0x%x\n", mscr);
+	edac_dbg(0, "Mem Scrub Ctrl Register 0x%x\n", mscr);
 
 	if (((mscr & MSCR_SCRUB_MOD_MASK) != MSCR_BACKGR_SCRUB) ||
 	    (si == 0)) {
@@ -927,7 +927,7 @@ static int cpc925_mc_get_channels(void __iomem *vbase)
 	    ((mbcr & MBCR_64BITBUS_MASK) == 0))
 		dual = 1;
 
-	debugf0("%s channel\n", (dual > 0) ? "Dual" : "Single");
+	edac_dbg(0, "%s channel\n", (dual > 0) ? "Dual" : "Single");
 
 	return dual;
 }
@@ -942,7 +942,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	struct resource *r;
 	int res = 0, nr_channels;
 
-	debugf0("%s platform device found!\n", pdev->name);
+	edac_dbg(0, "%s platform device found!\n", pdev->name);
 
 	if (!devres_open_group(&pdev->dev, cpc925_probe, GFP_KERNEL)) {
 		res = -ENOMEM;
@@ -1024,7 +1024,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	cpc925_add_edac_devices(vbase);
 
 	/* get this far and it's successful */
-	debugf0("success\n");
+	edac_dbg(0, "success\n");
 
 	res = 0;
 	goto out;
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 39c8997..675ba3c 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -309,7 +309,7 @@ static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
 	u32 remap;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	if (page < pvt->tolm)
 		return page;
@@ -335,7 +335,7 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	int i;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	/* convert the addr to 4k page */
 	page = sec1_add >> (PAGE_SHIFT - 4);
@@ -394,7 +394,7 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 	int row;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	if (error_one & 0x0202) {
 		error_2b = ded_add;
@@ -453,7 +453,7 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 	if (!handle_error)
 		return;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
 			     -1, -1, -1,
 			     "e752x UE log memory write", "", NULL);
@@ -982,7 +982,7 @@ static void e752x_check(struct mem_ctl_info *mci)
 {
 	struct e752x_error_info info;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	e752x_get_error_info(mci, &info);
 	e752x_process_error_info(mci, &info, 1);
 }
@@ -1102,8 +1102,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		pci_read_config_byte(pdev, E752X_DRB + index, &value);
 		/* convert a 128 or 64 MiB DRB to a page size. */
 		cumul_size = value << (25 + drc_drbg - PAGE_SHIFT);
-		debugf3("(%d) cumul_size 0x%x\n", index,
-			cumul_size);
+		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
 
@@ -1129,7 +1128,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		for (i = 0; i < csrow->nr_channels; i++) {
 			struct dimm_info *dimm = csrow->channels[i]->dimm;
 
-			debugf3("Initializing rank at (%i,%i)\n", index, i);
+			edac_dbg(3, "Initializing rank at (%i,%i)\n", index, i);
 			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
 			dimm->mtype = MEM_RDDR;	/* only one type supported */
@@ -1270,8 +1269,8 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	int drc_chan;		/* Number of channels 0=1chan,1=2chan */
 	struct e752x_error_info discard;
 
-	debugf0("mci\n");
-	debugf0("Starting Probe1\n");
+	edac_dbg(0, "mci\n");
+	edac_dbg(0, "Starting Probe1\n");
 
 	/* check to see if device 0 function 1 is enabled; if it isn't, we
 	 * assume the BIOS has reserved it for a reason and is expecting
@@ -1301,7 +1300,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	/* 3100 IMCH supports SECDEC only */
 	mci->edac_ctl_cap = (dev_idx == I3100) ? EDAC_FLAG_SECDED :
@@ -1311,7 +1310,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->mod_ver = E752X_REVISION;
 	mci->pdev = &pdev->dev;
 
-	debugf3("init pvt\n");
+	edac_dbg(3, "init pvt\n");
 	pvt = (struct e752x_pvt *)mci->pvt_info;
 	pvt->dev_info = &e752x_devs[dev_idx];
 	pvt->mc_symmetric = ((ddrcsr & 0x10) != 0);
@@ -1321,7 +1320,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENODEV;
 	}
 
-	debugf3("more mci init\n");
+	edac_dbg(3, "more mci init\n");
 	mci->ctl_name = pvt->dev_info->ctl_name;
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e752x_check;
@@ -1343,7 +1342,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 		mci->edac_cap = EDAC_FLAG_SECDED; /* the only mode supported */
 	else
 		mci->edac_cap |= EDAC_FLAG_NONE;
-	debugf3("tolm, remapbase, remaplimit\n");
+	edac_dbg(3, "tolm, remapbase, remaplimit\n");
 
 	/* load the top of low memory, remap base, and remap limit vars */
 	pci_read_config_word(pdev, E752X_TOLM, &pci_data);
@@ -1360,7 +1359,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -1378,7 +1377,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	return 0;
 
 fail:
@@ -1394,7 +1393,7 @@ fail:
 static int __devinit e752x_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* wake up and enable device */
 	if (pci_enable_device(pdev) < 0)
@@ -1408,7 +1407,7 @@ static void __devexit e752x_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct e752x_pvt *pvt;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (e752x_pci)
 		edac_pci_release_generic_ctl(e752x_pci);
@@ -1454,7 +1453,7 @@ static int __init e752x_init(void)
 {
 	int pci_rc;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -1465,7 +1464,7 @@ static int __init e752x_init(void)
 
 static void __exit e752x_exit(void)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	pci_unregister_driver(&e752x_driver);
 }
 
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 691d706..3ce661e 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -166,7 +166,7 @@ static const struct e7xxx_dev_info e7xxx_devs[] = {
 /* FIXME - is this valid for both SECDED and S4ECD4ED? */
 static inline int e7xxx_find_channel(u16 syndrome)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	if ((syndrome & 0xff00) == 0)
 		return 0;
@@ -186,7 +186,7 @@ static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
 	u32 remap;
 	struct e7xxx_pvt *pvt = (struct e7xxx_pvt *)mci->pvt_info;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	if ((page < pvt->tolm) ||
 		((page >= 0x100000) && (page < pvt->remapbase)))
@@ -208,7 +208,7 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	int row;
 	int channel;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	/* read the error address */
 	error_1b = info->dram_celog_add;
 	/* FIXME - should use PAGE_SHIFT */
@@ -225,7 +225,7 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
 			     "e7xxx CE log register overflow", "", NULL);
 }
@@ -235,7 +235,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	u32 error_2b, block_page;
 	int row;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	/* read the error address */
 	error_2b = info->dram_uelog_add;
 	/* FIXME - should use PAGE_SHIFT */
@@ -248,7 +248,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
 			     "e7xxx UE log register overflow", "", NULL);
@@ -334,7 +334,7 @@ static void e7xxx_check(struct mem_ctl_info *mci)
 {
 	struct e7xxx_error_info info;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 	e7xxx_get_error_info(mci, &info);
 	e7xxx_process_error_info(mci, &info, 1);
 }
@@ -383,8 +383,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		pci_read_config_byte(pdev, E7XXX_DRB + index, &value);
 		/* convert a 64 or 32 MiB DRB to a page size. */
 		cumul_size = value << (25 + drc_drbg - PAGE_SHIFT);
-		debugf3("(%d) cumul_size 0x%x\n", index,
-			cumul_size);
+		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
 
@@ -430,7 +429,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	int drc_chan;
 	struct e7xxx_error_info discard;
 
-	debugf0("mci\n");
+	edac_dbg(0, "mci\n");
 
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
@@ -453,7 +452,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED |
 		EDAC_FLAG_S4ECD4ED;
@@ -461,7 +460,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E7XXX_REVISION;
 	mci->pdev = &pdev->dev;
-	debugf3("init pvt\n");
+	edac_dbg(3, "init pvt\n");
 	pvt = (struct e7xxx_pvt *)mci->pvt_info;
 	pvt->dev_info = &e7xxx_devs[dev_idx];
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
@@ -474,14 +473,14 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail0;
 	}
 
-	debugf3("more mci init\n");
+	edac_dbg(3, "more mci init\n");
 	mci->ctl_name = pvt->dev_info->ctl_name;
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e7xxx_check;
 	mci->ctl_page_to_phys = ctl_page_to_phys;
 	e7xxx_init_csrows(mci, pdev, dev_idx, drc);
 	mci->edac_cap |= EDAC_FLAG_NONE;
-	debugf3("tolm, remapbase, remaplimit\n");
+	edac_dbg(3, "tolm, remapbase, remaplimit\n");
 	/* load the top of low memory, remap base, and remap limit vars */
 	pci_read_config_word(pdev, E7XXX_TOLM, &pci_data);
 	pvt->tolm = ((u32) pci_data) << 4;
@@ -500,7 +499,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail1;
 	}
 
@@ -516,7 +515,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	return 0;
 
 fail1:
@@ -532,7 +531,7 @@ fail0:
 static int __devinit e7xxx_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* wake up and enable device */
 	return pci_enable_device(pdev) ?
@@ -544,7 +543,7 @@ static void __devexit e7xxx_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct e7xxx_pvt *pvt;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (e7xxx_pci)
 		edac_pci_release_generic_ctl(e7xxx_pci);
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 47d3684..76fc29a 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -71,7 +71,7 @@ extern const char *edac_mem_types[];
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
 
-#define edac_debug_printk(level, fmt, ...)				\
+#define edac_dbg(level, fmt, ...)					\
 do {									\
 	if (level <= edac_debug_level)					\
 		edac_printk(KERN_DEBUG, EDAC_DEBUG,			\
@@ -80,7 +80,7 @@ do {									\
 
 #else				/* !CONFIG_EDAC_DEBUG */
 
-#define edac_debug_printk(level, fmt, ...)				\
+#define edac_dbg(level, fmt, ...)					\
 do {									\
 	if (0)								\
 		edac_printk(KERN_DEBUG, EDAC_DEBUG,			\
@@ -89,12 +89,6 @@ do {									\
 
 #endif				/* !CONFIG_EDAC_DEBUG */
 
-#define debugf0(fmt, ...) edac_debug_printk(0, fmt, ##__VA_ARGS__)
-#define debugf1(fmt, ...) edac_debug_printk(1, fmt, ##__VA_ARGS__)
-#define debugf2(fmt, ...) edac_debug_printk(2, fmt, ##__VA_ARGS__)
-#define debugf3(fmt, ...) edac_debug_printk(3, fmt, ##__VA_ARGS__)
-#define debugf4(fmt, ...) edac_debug_printk(4, fmt, ##__VA_ARGS__)
-
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
 
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index ed46949..9523e76 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -40,12 +40,13 @@ static LIST_HEAD(edac_device_list);
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
 {
-	debugf3("\tedac_dev = %p dev_idx=%d \n", edac_dev, edac_dev->dev_idx);
-	debugf4("\tedac_dev->edac_check = %p\n", edac_dev->edac_check);
-	debugf3("\tdev = %p\n", edac_dev->dev);
-	debugf3("\tmod_name:ctl_name = %s:%s\n",
-		edac_dev->mod_name, edac_dev->ctl_name);
-	debugf3("\tpvt_info = %p\n\n", edac_dev->pvt_info);
+	edac_dbg(3, "\tedac_dev = %p dev_idx=%d\n",
+		 edac_dev, edac_dev->dev_idx);
+	edac_dbg(4, "\tedac_dev->edac_check = %p\n", edac_dev->edac_check);
+	edac_dbg(3, "\tdev = %p\n", edac_dev->dev);
+	edac_dbg(3, "\tmod_name:ctl_name = %s:%s\n",
+		 edac_dev->mod_name, edac_dev->ctl_name);
+	edac_dbg(3, "\tpvt_info = %p\n\n", edac_dev->pvt_info);
 }
 #endif				/* CONFIG_EDAC_DEBUG */
 
@@ -82,8 +83,7 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	void *pvt, *p;
 	int err;
 
-	debugf4("instances=%d blocks=%d\n",
-		nr_instances, nr_blocks);
+	edac_dbg(4, "instances=%d blocks=%d\n", nr_instances, nr_blocks);
 
 	/* Calculate the size of memory we need to allocate AND
 	 * determine the offsets of the various item arrays
@@ -156,8 +156,8 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 	/* Name of this edac device */
 	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s",edac_device_name);
 
-	debugf4("edac_dev=%p next after end=%p\n",
-		dev_ctl, pvt + sz_private );
+	edac_dbg(4, "edac_dev=%p next after end=%p\n",
+		 dev_ctl, pvt + sz_private);
 
 	/* Initialize every Instance */
 	for (instance = 0; instance < nr_instances; instance++) {
@@ -178,10 +178,8 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 			snprintf(blk->name, sizeof(blk->name),
 				 "%s%d", edac_block_name, block+offset_value);
 
-			debugf4("instance=%d inst_p=%p block=#%d "
-				"block_p=%p name='%s'\n",
-				instance, inst, block,
-				blk, blk->name);
+			edac_dbg(4, "instance=%d inst_p=%p block=#%d block_p=%p name='%s'\n",
+				 instance, inst, block, blk, blk->name);
 
 			/* if there are NO attributes OR no attribute pointer
 			 * then continue on to next block iteration
@@ -194,8 +192,8 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 			attrib_p = &dev_attrib[block*nr_instances*nr_attrib];
 			blk->block_attributes = attrib_p;
 
-			debugf4("THIS BLOCK_ATTRIB=%p\n",
-				blk->block_attributes);
+			edac_dbg(4, "THIS BLOCK_ATTRIB=%p\n",
+				 blk->block_attributes);
 
 			/* Initialize every user specified attribute in this
 			 * block with the data the caller passed in
@@ -214,11 +212,10 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 
 				attrib->block = blk;	/* up link */
 
-				debugf4("alloc-attrib=%p attrib_name='%s' "
-					"attrib-spec=%p spec-name=%s\n",
-					attrib, attrib->attr.name,
-					&attrib_spec[attr],
-					attrib_spec[attr].attr.name
+				edac_dbg(4, "alloc-attrib=%p attrib_name='%s' attrib-spec=%p spec-name=%s\n",
+					 attrib, attrib->attr.name,
+					 &attrib_spec[attr],
+					 attrib_spec[attr].attr.name
 					);
 			}
 		}
@@ -273,7 +270,7 @@ static struct edac_device_ctl_info *find_edac_device_by_dev(struct device *dev)
 	struct edac_device_ctl_info *edac_dev;
 	struct list_head *item;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	list_for_each(item, &edac_device_list) {
 		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
@@ -408,7 +405,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
 void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 				unsigned msec)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* take the arg 'msec' and set it into the control structure
 	 * to used in the time period calculation
@@ -496,7 +493,7 @@ EXPORT_SYMBOL_GPL(edac_device_alloc_index);
  */
 int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
@@ -570,7 +567,7 @@ struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
 {
 	struct edac_device_ctl_info *edac_dev;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	mutex_lock(&device_ctls_mutex);
 
diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 1cee83e..fb68a06 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -202,7 +202,7 @@ static void edac_device_ctrl_master_release(struct kobject *kobj)
 {
 	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
 
-	debugf4("control index=%d\n", edac_dev->dev_idx);
+	edac_dbg(4, "control index=%d\n", edac_dev->dev_idx);
 
 	/* decrement the EDAC CORE module ref count */
 	module_put(edac_dev->owner);
@@ -233,12 +233,12 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 	struct bus_type *edac_subsys;
 	int err;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	/* get the /sys/devices/system/edac reference */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("no edac_subsys error\n");
+		edac_dbg(1, "no edac_subsys error\n");
 		err = -ENODEV;
 		goto err_out;
 	}
@@ -264,8 +264,8 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 				   &edac_subsys->dev_root->kobj,
 				   "%s", edac_dev->name);
 	if (err) {
-		debugf1("Failed to register '.../edac/%s'\n",
-			edac_dev->name);
+		edac_dbg(1, "Failed to register '.../edac/%s'\n",
+			 edac_dev->name);
 		goto err_kobj_reg;
 	}
 	kobject_uevent(&edac_dev->kobj, KOBJ_ADD);
@@ -274,8 +274,7 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 	 * edac_device_unregister_sysfs_main_kobj() must be used
 	 */
 
-	debugf4("Registered '.../edac/%s' kobject\n",
-		edac_dev->name);
+	edac_dbg(4, "Registered '.../edac/%s' kobject\n", edac_dev->name);
 
 	return 0;
 
@@ -296,9 +295,8 @@ err_out:
  */
 void edac_device_unregister_sysfs_main_kobj(struct edac_device_ctl_info *dev)
 {
-	debugf0("\n");
-	debugf4("name of kobject is: %s\n",
-		kobject_name(&dev->kobj));
+	edac_dbg(0, "\n");
+	edac_dbg(4, "name of kobject is: %s\n", kobject_name(&dev->kobj));
 
 	/*
 	 * Unregister the edac device's kobject and
@@ -336,7 +334,7 @@ static void edac_device_ctrl_instance_release(struct kobject *kobj)
 {
 	struct edac_device_instance *instance;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	/* map from this kobj to the main control struct
 	 * and then dec the main kobj count
@@ -442,7 +440,7 @@ static void edac_device_ctrl_block_release(struct kobject *kobj)
 {
 	struct edac_device_block *block;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	/* get the container of the kobj */
 	block = to_block(kobj);
@@ -524,10 +522,10 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 	struct edac_dev_sysfs_block_attribute *sysfs_attrib;
 	struct kobject *main_kobj;
 
-	debugf4("Instance '%s' inst_p=%p  block '%s'  block_p=%p\n",
-		instance->name, instance, block->name, block);
-	debugf4("block kobj=%p  block kobj->parent=%p\n",
-		&block->kobj, &block->kobj.parent);
+	edac_dbg(4, "Instance '%s' inst_p=%p  block '%s'  block_p=%p\n",
+		 instance->name, instance, block->name, block);
+	edac_dbg(4, "block kobj=%p  block kobj->parent=%p\n",
+		 &block->kobj, &block->kobj.parent);
 
 	/* init this block's kobject */
 	memset(&block->kobj, 0, sizeof(struct kobject));
@@ -546,8 +544,7 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 				   &instance->kobj,
 				   "%s", block->name);
 	if (err) {
-		debugf1("Failed to register instance '%s'\n",
-			block->name);
+		edac_dbg(1, "Failed to register instance '%s'\n", block->name);
 		kobject_put(main_kobj);
 		err = -ENODEV;
 		goto err_out;
@@ -560,10 +557,9 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 	if (sysfs_attrib && block->nr_attribs) {
 		for (i = 0; i < block->nr_attribs; i++, sysfs_attrib++) {
 
-			debugf4("creating block attrib='%s' "
-				"attrib->%p to kobj=%p\n",
-				sysfs_attrib->attr.name,
-				sysfs_attrib, &block->kobj);
+			edac_dbg(4, "creating block attrib='%s' attrib->%p to kobj=%p\n",
+				 sysfs_attrib->attr.name,
+				 sysfs_attrib, &block->kobj);
 
 			/* Create each block_attribute file */
 			err = sysfs_create_file(&block->kobj,
@@ -646,14 +642,14 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 	err = kobject_init_and_add(&instance->kobj, &ktype_instance_ctrl,
 				   &edac_dev->kobj, "%s", instance->name);
 	if (err != 0) {
-		debugf2("Failed to register instance '%s'\n",
-			instance->name);
+		edac_dbg(2, "Failed to register instance '%s'\n",
+			 instance->name);
 		kobject_put(main_kobj);
 		goto err_out;
 	}
 
-	debugf4("now register '%d' blocks for instance %d\n",
-		instance->nr_blocks, idx);
+	edac_dbg(4, "now register '%d' blocks for instance %d\n",
+		 instance->nr_blocks, idx);
 
 	/* register all blocks of this instance */
 	for (i = 0; i < instance->nr_blocks; i++) {
@@ -669,8 +665,8 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 	}
 	kobject_uevent(&instance->kobj, KOBJ_ADD);
 
-	debugf4("Registered instance %d '%s' kobject\n",
-		idx, instance->name);
+	edac_dbg(4, "Registered instance %d '%s' kobject\n",
+		 idx, instance->name);
 
 	return 0;
 
@@ -714,7 +710,7 @@ static int edac_device_create_instances(struct edac_device_ctl_info *edac_dev)
 	int i, j;
 	int err;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* iterate over creation of the instances */
 	for (i = 0; i < edac_dev->nr_instances; i++) {
@@ -816,12 +812,12 @@ int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 	int err;
 	struct kobject *edac_kobj = &edac_dev->kobj;
 
-	debugf0("idx=%d\n", edac_dev->dev_idx);
+	edac_dbg(0, "idx=%d\n", edac_dev->dev_idx);
 
 	/*  go create any main attributes callers wants */
 	err = edac_device_add_main_sysfs_attributes(edac_dev);
 	if (err) {
-		debugf0("failed to add sysfs attribs\n");
+		edac_dbg(0, "failed to add sysfs attribs\n");
 		goto err_out;
 	}
 
@@ -831,8 +827,7 @@ int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 	err = sysfs_create_link(edac_kobj,
 				&edac_dev->dev->kobj, EDAC_DEVICE_SYMLINK);
 	if (err) {
-		debugf0("sysfs_create_link() returned err= %d\n",
-			err);
+		edac_dbg(0, "sysfs_create_link() returned err= %d\n", err);
 		goto err_remove_main_attribs;
 	}
 
@@ -842,14 +837,13 @@ int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev)
 	 */
 	err = edac_device_create_instances(edac_dev);
 	if (err) {
-		debugf0("edac_device_create_instances() "
-			"returned err= %d\n", err);
+		edac_dbg(0, "edac_device_create_instances() returned err= %d\n",
+			 err);
 		goto err_remove_link;
 	}
 
 
-	debugf4("create-instances done, idx=%d\n",
-		edac_dev->dev_idx);
+	edac_dbg(4, "create-instances done, idx=%d\n", edac_dev->dev_idx);
 
 	return 0;
 
@@ -872,7 +866,7 @@ err_out:
  */
 void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* remove any main attributes for this device */
 	edac_device_remove_main_sysfs_attributes(edac_dev);
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 8d7c380..080716b 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -45,56 +45,57 @@ static LIST_HEAD(mc_devices);
 
 static void edac_mc_dump_channel(struct rank_info *chan)
 {
-	debugf4("\tchannel = %p\n", chan);
-	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
-	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
-	debugf4("\tchannel->dimm = %p\n", chan->dimm);
+	edac_dbg(4, "\tchannel = %p\n", chan);
+	edac_dbg(4, "\tchannel->chan_idx = %d\n", chan->chan_idx);
+	edac_dbg(4, "\tchannel->csrow = %p\n", chan->csrow);
+	edac_dbg(4, "\tchannel->dimm = %p\n", chan->dimm);
 }
 
 static void edac_mc_dump_dimm(struct dimm_info *dimm)
 {
 	int i;
 
-	debugf4("\tdimm = %p\n", dimm);
-	debugf4("\tdimm->label = '%s'\n", dimm->label);
-	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
-	debugf4("\tdimm location ");
+	edac_dbg(4, "\tdimm = %p\n", dimm);
+	edac_dbg(4, "\tdimm->label = '%s'\n", dimm->label);
+	edac_dbg(4, "\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	edac_dbg(4, "\tdimm location ");
 	for (i = 0; i < dimm->mci->n_layers; i++) {
 		printk(KERN_CONT "%d", dimm->location[i]);
 		if (i < dimm->mci->n_layers - 1)
 			printk(KERN_CONT ".");
 	}
 	printk(KERN_CONT "\n");
-	debugf4("\tdimm->grain = %d\n", dimm->grain);
-	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	edac_dbg(4, "\tdimm->grain = %d\n", dimm->grain);
+	edac_dbg(4, "\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
 
 static void edac_mc_dump_csrow(struct csrow_info *csrow)
 {
-	debugf4("\tcsrow = %p\n", csrow);
-	debugf4("\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
-	debugf4("\tcsrow->first_page = 0x%lx\n", csrow->first_page);
-	debugf4("\tcsrow->last_page = 0x%lx\n", csrow->last_page);
-	debugf4("\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);
-	debugf4("\tcsrow->nr_channels = %d\n", csrow->nr_channels);
-	debugf4("\tcsrow->channels = %p\n", csrow->channels);
-	debugf4("\tcsrow->mci = %p\n\n", csrow->mci);
+	edac_dbg(4, "\tcsrow = %p\n", csrow);
+	edac_dbg(4, "\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
+	edac_dbg(4, "\tcsrow->first_page = 0x%lx\n", csrow->first_page);
+	edac_dbg(4, "\tcsrow->last_page = 0x%lx\n", csrow->last_page);
+	edac_dbg(4, "\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);
+	edac_dbg(4, "\tcsrow->nr_channels = %d\n", csrow->nr_channels);
+	edac_dbg(4, "\tcsrow->channels = %p\n", csrow->channels);
+	edac_dbg(4, "\tcsrow->mci = %p\n", csrow->mci);
 }
 
 static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 {
-	debugf3("\tmci = %p\n", mci);
-	debugf3("\tmci->mtype_cap = %lx\n", mci->mtype_cap);
-	debugf3("\tmci->edac_ctl_cap = %lx\n", mci->edac_ctl_cap);
-	debugf3("\tmci->edac_cap = %lx\n", mci->edac_cap);
-	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
-	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
-		mci->nr_csrows, mci->csrows);
-	debugf3("\tmci->nr_dimms = %d, dimms = %p\n",
-		mci->tot_dimms, mci->dimms);
-	debugf3("\tdev = %p\n", mci->pdev);
-	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
-	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
+	edac_dbg(3, "\tmci = %p\n", mci);
+	edac_dbg(3, "\tmci->mtype_cap = %lx\n", mci->mtype_cap);
+	edac_dbg(3, "\tmci->edac_ctl_cap = %lx\n", mci->edac_ctl_cap);
+	edac_dbg(3, "\tmci->edac_cap = %lx\n", mci->edac_cap);
+	edac_dbg(4, "\tmci->edac_check = %p\n", mci->edac_check);
+	edac_dbg(3, "\tmci->nr_csrows = %d, csrows = %p\n",
+		 mci->nr_csrows, mci->csrows);
+	edac_dbg(3, "\tmci->nr_dimms = %d, dimms = %p\n",
+		 mci->tot_dimms, mci->dimms);
+	edac_dbg(3, "\tdev = %p\n", mci->pdev);
+	edac_dbg(3, "\tmod_name:ctl_name = %s:%s\n",
+		 mci->mod_name, mci->ctl_name);
+	edac_dbg(3, "\tpvt_info = %p\n\n", mci->pvt_info);
 }
 
 #endif				/* CONFIG_EDAC_DEBUG */
@@ -245,21 +246,21 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	layer = edac_align_ptr(&ptr, sizeof(*layer), n_layers);
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
-		debugf4("errcount layer %d size %d\n", i, count);
+		edac_dbg(4, "errcount layer %d size %d\n", i, count);
 		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		tot_errcount += 2 * count;
 	}
 
-	debugf4("allocating %d error counters\n", tot_errcount);
+	edac_dbg(4, "allocating %d error counters\n", tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	debugf1("allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
-		size,
-		tot_dimms,
-		per_rank ? "ranks" : "dimms",
-		tot_csrows * tot_channels);
+	edac_dbg(1, "allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
+		 size,
+		 tot_dimms,
+		 per_rank ? "ranks" : "dimms",
+		 tot_csrows * tot_channels);
 
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
@@ -325,8 +326,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	debugf4("initializing %d %s\n", tot_dimms,
-		per_rank ? "ranks" : "dimms");
+	edac_dbg(4, "initializing %d %s\n",
+		 tot_dimms, per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = mci->csrows[row]->channels[chn];
 		off = EDAC_DIMM_OFF(layer, n_layers, pos[0], pos[1], pos[2]);
@@ -339,9 +340,9 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		debugf2("%d: %s%i (%d:%d:%d): row %d, chan %d\n", i,
-			per_rank ? "rank" : "dimm", off,
-			pos[0], pos[1], pos[2], row, chn);
+		edac_dbg(2, "%d: %s%i (%d:%d:%d): row %d, chan %d\n",
+			 i, per_rank ? "rank" : "dimm", off,
+			 pos[0], pos[1], pos[2], row, chn);
 
 		/*
 		 * Copy DIMM location and initialize it.
@@ -426,7 +427,7 @@ EXPORT_SYMBOL_GPL(edac_mc_alloc);
  */
 void edac_mc_free(struct mem_ctl_info *mci)
 {
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	/* the mci instance is freed here, when the sysfs object is dropped */
 	edac_unregister_sysfs(mci);
@@ -446,7 +447,7 @@ struct mem_ctl_info *find_mci_by_dev(struct device *dev)
 	struct mem_ctl_info *mci;
 	struct list_head *item;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
@@ -514,7 +515,7 @@ static void edac_mc_workq_function(struct work_struct *work_req)
  */
 static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* if this instance is not in the POLL state, then simply return */
 	if (mci->op_state != OP_RUNNING_POLL)
@@ -541,7 +542,7 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
 
 	status = cancel_delayed_work(&mci->work);
 	if (status == 0) {
-		debugf0("not canceled, flush the queue\n");
+		edac_dbg(0, "not canceled, flush the queue\n");
 
 		/* workq instance might be running, wait for it */
 		flush_workqueue(edac_workqueue);
@@ -688,7 +689,7 @@ EXPORT_SYMBOL(edac_mc_find);
 /* FIXME - should a warning be printed if no error detection? correction? */
 int edac_mc_add_mc(struct mem_ctl_info *mci)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
@@ -759,7 +760,7 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	mutex_lock(&mem_ctls_mutex);
 
@@ -797,7 +798,7 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 	void *virt_addr;
 	unsigned long flags = 0;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	/* ECC error page was not in our memory. Ignore it. */
 	if (!pfn_valid(page))
@@ -827,7 +828,7 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 	struct csrow_info **csrows = mci->csrows;
 	int row, i, j, n;
 
-	debugf1("MC%d: 0x%lx\n", mci->mc_idx, page);
+	edac_dbg(1, "MC%d: 0x%lx\n", mci->mc_idx, page);
 	row = -1;
 
 	for (i = 0; i < mci->nr_csrows; i++) {
@@ -840,10 +841,10 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 		if (n == 0)
 			continue;
 
-		debugf3("MC%d: first(0x%lx) page(0x%lx) last(0x%lx) "
-			"mask(0x%lx)\n", mci->mc_idx,
-			csrow->first_page, page, csrow->last_page,
-			csrow->page_mask);
+		edac_dbg(3, "MC%d: first(0x%lx) page(0x%lx) last(0x%lx) mask(0x%lx)\n",
+			 mci->mc_idx,
+			 csrow->first_page, page, csrow->last_page,
+			 csrow->page_mask);
 
 		if ((page >= csrow->first_page) &&
 		    (page <= csrow->last_page) &&
@@ -1045,7 +1046,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	u32 grain;
 	bool enable_per_layer_report = false;
 
-	debugf3("MC%d\n", mci->mc_idx);
+	edac_dbg(3, "MC%d\n", mci->mc_idx);
 
 	/*
 	 * Check if the event report is consistent and if the memory
@@ -1123,10 +1124,9 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * get csrow/channel of the DIMM, in order to allow
 			 * incrementing the compat API counters
 			 */
-			debugf4("%s csrows map: (%d,%d)\n",
-				mci->mem_is_per_rank ? "rank" : "dimm",
-				dimm->csrow, dimm->cschannel);
-
+			edac_dbg(4, "%s csrows map: (%d,%d)\n",
+				 mci->mem_is_per_rank ? "rank" : "dimm",
+				 dimm->csrow, dimm->cschannel);
 			if (row == -1)
 				row = dimm->csrow;
 			else if (row >= 0 && row != dimm->csrow)
@@ -1142,8 +1142,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (!enable_per_layer_report) {
 		strcpy(label, "any memory");
 	} else {
-		debugf4("csrow/channel to increment: (%d,%d)\n",
-			row, chan);
+		edac_dbg(4, "csrow/channel to increment: (%d,%d)\n", row, chan);
 		if (p == label)
 			strcpy(label, "unknown memory");
 		if (type == HW_EVENT_ERR_CORRECTED) {
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index f72de8b..eace646 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -287,7 +287,7 @@ static void csrow_attr_release(struct device *dev)
 {
 	struct csrow_info *csrow = container_of(dev, struct csrow_info, dev);
 
-	debugf1("Releasing csrow device %s\n", dev_name(dev));
+	edac_dbg(1, "Releasing csrow device %s\n", dev_name(dev));
 	kfree(csrow);
 }
 
@@ -376,7 +376,8 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 	dev_set_name(&csrow->dev, "csrow%d", index);
 	dev_set_drvdata(&csrow->dev, csrow);
 
-	debugf0("creating (virtual) csrow node %s\n", dev_name(&csrow->dev));
+	edac_dbg(0, "creating (virtual) csrow node %s\n",
+		 dev_name(&csrow->dev));
 
 	err = device_add(&csrow->dev);
 	if (err < 0)
@@ -460,8 +461,8 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
 			if (!csrow->channels[chan]->dimm->nr_pages)
 				continue;
-			debugf1("Removing csrow %d channel %d sysfs nodes\n",
-				i, chan);
+			edac_dbg(1, "Removing csrow %d channel %d sysfs nodes\n",
+				 i, chan);
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_dimm_attr[chan]);
 			device_remove_file(&csrow->dev,
@@ -591,7 +592,7 @@ static void dimm_attr_release(struct device *dev)
 {
 	struct dimm_info *dimm = container_of(dev, struct dimm_info, dev);
 
-	debugf1("Releasing dimm device %s\n", dev_name(dev));
+	edac_dbg(1, "Releasing dimm device %s\n", dev_name(dev));
 	kfree(dimm);
 }
 
@@ -622,7 +623,7 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 
 	err =  device_add(&dimm->dev);
 
-	debugf0("creating rank/dimm device %s\n", dev_name(&dimm->dev));
+	edac_dbg(0, "creating rank/dimm device %s\n", dev_name(&dimm->dev));
 
 	return err;
 }
@@ -897,7 +898,7 @@ static void mci_attr_release(struct device *dev)
 {
 	struct mem_ctl_info *mci = container_of(dev, struct mem_ctl_info, dev);
 
-	debugf1("Releasing csrow device %s\n", dev_name(dev));
+	edac_dbg(1, "Releasing csrow device %s\n", dev_name(dev));
 	kfree(mci);
 }
 
@@ -964,7 +965,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	mci->bus.name = kasprintf(GFP_KERNEL, "mc%d", mci->mc_idx);
 	if (!mci->bus.name)
 		return -ENOMEM;
-	debugf0("creating bus %s\n",mci->bus.name);
+	edac_dbg(0, "creating bus %s\n", mci->bus.name);
 	err = bus_register(&mci->bus);
 	if (err < 0)
 		return err;
@@ -979,7 +980,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	dev_set_drvdata(&mci->dev, mci);
 	pm_runtime_forbid(&mci->dev);
 
-	debugf0("creating device %s\n", dev_name(&mci->dev));
+	edac_dbg(0, "creating device %s\n", dev_name(&mci->dev));
 	err = device_add(&mci->dev);
 	if (err < 0) {
 		bus_unregister(&mci->bus);
@@ -996,8 +997,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		if (dimm->nr_pages == 0)
 			continue;
 #ifdef CONFIG_EDAC_DEBUG
-		debugf1("creating dimm%d, located at ",
-			i);
+		edac_dbg(1, "creating dimm%d, located at ", i);
 		if (edac_debug_level >= 1) {
 			int lay;
 			for (lay = 0; lay < mci->n_layers; lay++)
@@ -1009,8 +1009,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 #endif
 		err = edac_create_dimm_object(mci, dimm, i);
 		if (err) {
-			debugf1("failure: create dimm %d obj\n",
-				i);
+			edac_dbg(1, "failure: create dimm %d obj\n", i);
 			goto fail;
 		}
 	}
@@ -1048,7 +1047,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 {
 	int i;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 #ifdef CONFIG_EDAC_DEBUG
 	debugfs_remove(mci->debugfs);
@@ -1061,7 +1060,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
-		debugf0("removing device %s\n", dev_name(&dimm->dev));
+		edac_dbg(0, "removing device %s\n", dev_name(&dimm->dev));
 		put_device(&dimm->dev);
 		device_del(&dimm->dev);
 	}
@@ -1069,7 +1068,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 void edac_unregister_sysfs(struct mem_ctl_info *mci)
 {
-	debugf1("Unregistering device %s\n", dev_name(&mci->dev));
+	edac_dbg(1, "Unregistering device %s\n", dev_name(&mci->dev));
 	put_device(&mci->dev);
 	device_del(&mci->dev);
 	bus_unregister(&mci->bus);
@@ -1083,7 +1082,7 @@ static void mc_attr_release(struct device *dev)
 	 * parent device, used to create the /sys/devices/mc sysfs node.
 	 * So, there are no attributes on it.
 	 */
-	debugf1("Releasing device %s\n", dev_name(dev));
+	edac_dbg(1, "Releasing device %s\n", dev_name(dev));
 	kfree(dev);
 }
 
@@ -1101,7 +1100,7 @@ int __init edac_mc_sysfs_init(void)
 	/* get the /sys/devices/system/edac subsys reference */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("no edac_subsys\n");
+		edac_dbg(1, "no edac_subsys\n");
 		return -EINVAL;
 	}
 
@@ -1116,7 +1115,7 @@ int __init edac_mc_sysfs_init(void)
 	if (err < 0)
 		return err;
 
-	debugf0("device %s created\n", dev_name(mci_pdev));
+	edac_dbg(0, "device %s created\n", dev_name(mci_pdev));
 
 	return 0;
 }
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 9de2484..cbba80d 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -113,7 +113,7 @@ error:
  */
 static void __exit edac_exit(void)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* tear down the various subsystems */
 	edac_workqueue_teardown();
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 51dd4e0..ee87ef9 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -45,7 +45,7 @@ struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
 	void *p = NULL, *pvt;
 	unsigned int size;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	pci = edac_align_ptr(&p, sizeof(*pci), 1);
 	pvt = edac_align_ptr(&p, 1, sz_pvt);
@@ -80,7 +80,7 @@ EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
  */
 void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci)
 {
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	edac_pci_remove_sysfs(pci);
 }
@@ -97,7 +97,7 @@ static struct edac_pci_ctl_info *find_edac_pci_by_dev(struct device *dev)
 	struct edac_pci_ctl_info *pci;
 	struct list_head *item;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	list_for_each(item, &edac_pci_list) {
 		pci = list_entry(item, struct edac_pci_ctl_info, link);
@@ -122,7 +122,7 @@ static int add_edac_pci_to_global_list(struct edac_pci_ctl_info *pci)
 	struct list_head *item, *insert_before;
 	struct edac_pci_ctl_info *rover;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	insert_before = &edac_pci_list;
 
@@ -226,7 +226,7 @@ static void edac_pci_workq_function(struct work_struct *work_req)
 	int msec;
 	unsigned long delay;
 
-	debugf3("checking\n");
+	edac_dbg(3, "checking\n");
 
 	mutex_lock(&edac_pci_ctls_mutex);
 
@@ -261,7 +261,7 @@ static void edac_pci_workq_function(struct work_struct *work_req)
 static void edac_pci_workq_setup(struct edac_pci_ctl_info *pci,
 				 unsigned int msec)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
 	queue_delayed_work(edac_workqueue, &pci->work,
@@ -276,7 +276,7 @@ static void edac_pci_workq_teardown(struct edac_pci_ctl_info *pci)
 {
 	int status;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	status = cancel_delayed_work(&pci->work);
 	if (status == 0)
@@ -293,7 +293,7 @@ static void edac_pci_workq_teardown(struct edac_pci_ctl_info *pci)
 void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
 				 unsigned long value)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	edac_pci_workq_teardown(pci);
 
@@ -333,7 +333,7 @@ EXPORT_SYMBOL_GPL(edac_pci_alloc_index);
  */
 int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	pci->pci_idx = edac_idx;
 	pci->start_time = jiffies;
@@ -393,7 +393,7 @@ struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev)
 {
 	struct edac_pci_ctl_info *pci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	mutex_lock(&edac_pci_ctls_mutex);
 
@@ -430,7 +430,7 @@ EXPORT_SYMBOL_GPL(edac_pci_del_device);
  */
 static void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
-	debugf4("\n");
+	edac_dbg(4, "\n");
 	edac_pci_do_parity_check();
 }
 
@@ -475,7 +475,7 @@ struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev,
 	pdata->edac_idx = edac_pci_idx++;
 
 	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
-		debugf3("failed edac_pci_add_device()\n");
+		edac_dbg(3, "failed edac_pci_add_device()\n");
 		edac_pci_free_ctl_info(pci);
 		return NULL;
 	}
@@ -491,7 +491,7 @@ EXPORT_SYMBOL_GPL(edac_pci_create_generic_ctl);
  */
 void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci)
 {
-	debugf0("pci mod=%s\n", pci->mod_name);
+	edac_dbg(0, "pci mod=%s\n", pci->mod_name);
 
 	edac_pci_del_device(pci->dev);
 	edac_pci_free_ctl_info(pci);
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 6678216..e164c55 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -78,7 +78,7 @@ static void edac_pci_instance_release(struct kobject *kobj)
 {
 	struct edac_pci_ctl_info *pci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* Form pointer to containing struct, the pci control struct */
 	pci = to_instance(kobj);
@@ -161,7 +161,7 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 	struct kobject *main_kobj;
 	int err;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* First bump the ref count on the top main kobj, which will
 	 * track the number of PCI instances we have, and thus nest
@@ -177,14 +177,13 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 	err = kobject_init_and_add(&pci->kobj, &ktype_pci_instance,
 				   edac_pci_top_main_kobj, "pci%d", idx);
 	if (err != 0) {
-		debugf2("failed to register instance pci%d\n",
-			idx);
+		edac_dbg(2, "failed to register instance pci%d\n", idx);
 		kobject_put(edac_pci_top_main_kobj);
 		goto error_out;
 	}
 
 	kobject_uevent(&pci->kobj, KOBJ_ADD);
-	debugf1("Register instance 'pci%d' kobject\n", idx);
+	edac_dbg(1, "Register instance 'pci%d' kobject\n", idx);
 
 	return 0;
 
@@ -201,7 +200,7 @@ error_out:
 static void edac_pci_unregister_sysfs_instance_kobj(
 			struct edac_pci_ctl_info *pci)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* Unregister the instance kobject and allow its release
 	 * function release the main reference count and then
@@ -317,7 +316,7 @@ static struct edac_pci_dev_attribute *edac_pci_attr[] = {
  */
 static void edac_pci_release_main_kobj(struct kobject *kobj)
 {
-	debugf0("here to module_put(THIS_MODULE)\n");
+	edac_dbg(0, "here to module_put(THIS_MODULE)\n");
 
 	kfree(kobj);
 
@@ -345,7 +344,7 @@ static int edac_pci_main_kobj_setup(void)
 	int err;
 	struct bus_type *edac_subsys;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* check and count if we have already created the main kobject */
 	if (atomic_inc_return(&edac_pci_sysfs_refcount) != 1)
@@ -356,7 +355,7 @@ static int edac_pci_main_kobj_setup(void)
 	 */
 	edac_subsys = edac_get_sysfs_subsys();
 	if (edac_subsys == NULL) {
-		debugf1("no edac_subsys\n");
+		edac_dbg(1, "no edac_subsys\n");
 		err = -ENODEV;
 		goto decrement_count_fail;
 	}
@@ -366,14 +365,14 @@ static int edac_pci_main_kobj_setup(void)
 	 * level main kobj for EDAC PCI
 	 */
 	if (!try_module_get(THIS_MODULE)) {
-		debugf1("try_module_get() failed\n");
+		edac_dbg(1, "try_module_get() failed\n");
 		err = -ENODEV;
 		goto mod_get_fail;
 	}
 
 	edac_pci_top_main_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
 	if (!edac_pci_top_main_kobj) {
-		debugf1("Failed to allocate\n");
+		edac_dbg(1, "Failed to allocate\n");
 		err = -ENOMEM;
 		goto kzalloc_fail;
 	}
@@ -383,7 +382,7 @@ static int edac_pci_main_kobj_setup(void)
 				   &ktype_edac_pci_main_kobj,
 				   &edac_subsys->dev_root->kobj, "pci");
 	if (err) {
-		debugf1("Failed to register '.../edac/pci'\n");
+		edac_dbg(1, "Failed to register '.../edac/pci'\n");
 		goto kobject_init_and_add_fail;
 	}
 
@@ -392,7 +391,7 @@ static int edac_pci_main_kobj_setup(void)
 	 * must be used, for resources to be cleaned up properly
 	 */
 	kobject_uevent(edac_pci_top_main_kobj, KOBJ_ADD);
-	debugf1("Registered '.../edac/pci' kobject\n");
+	edac_dbg(1, "Registered '.../edac/pci' kobject\n");
 
 	return 0;
 
@@ -421,14 +420,14 @@ decrement_count_fail:
  */
 static void edac_pci_main_kobj_teardown(void)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* Decrement the count and only if no more controller instances
 	 * are connected perform the unregisteration of the top level
 	 * main kobj
 	 */
 	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0) {
-		debugf0("called kobject_put on main kobj\n");
+		edac_dbg(0, "called kobject_put on main kobj\n");
 		kobject_put(edac_pci_top_main_kobj);
 	}
 	edac_put_sysfs_subsys();
@@ -445,7 +444,7 @@ int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci)
 	int err;
 	struct kobject *edac_kobj = &pci->kobj;
 
-	debugf0("idx=%d\n", pci->pci_idx);
+	edac_dbg(0, "idx=%d\n", pci->pci_idx);
 
 	/* create the top main EDAC PCI kobject, IF needed */
 	err = edac_pci_main_kobj_setup();
@@ -459,8 +458,7 @@ int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci)
 
 	err = sysfs_create_link(edac_kobj, &pci->dev->kobj, EDAC_PCI_SYMLINK);
 	if (err) {
-		debugf0("sysfs_create_link() returned err= %d\n",
-			err);
+		edac_dbg(0, "sysfs_create_link() returned err= %d\n", err);
 		goto symlink_fail;
 	}
 
@@ -483,7 +481,7 @@ unregister_cleanup:
  */
 void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci)
 {
-	debugf0("index=%d\n", pci->pci_idx);
+	edac_dbg(0, "index=%d\n", pci->pci_idx);
 
 	/* Remove the symlink */
 	sysfs_remove_link(&pci->kobj, EDAC_PCI_SYMLINK);
@@ -495,7 +493,7 @@ void edac_pci_remove_sysfs(struct edac_pci_ctl_info *pci)
 	 * if this 'pci' is the last instance.
 	 * If it is, the main kobject will be unregistered as a result
 	 */
-	debugf0("calling edac_pci_main_kobj_teardown()\n");
+	edac_dbg(0, "calling edac_pci_main_kobj_teardown()\n");
 	edac_pci_main_kobj_teardown();
 }
 
@@ -571,7 +569,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 
 	local_irq_restore(flags);
 
-	debugf4("PCI STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
+	edac_dbg(4, "PCI STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
 
 	/* check the status reg for errors on boards NOT marked as broken
 	 * if broken, we cannot trust any of the status bits
@@ -602,13 +600,15 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 	}
 
 
-	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev_name(&dev->dev));
+	edac_dbg(4, "PCI HEADER TYPE= 0x%02x %s\n",
+		 header_type, dev_name(&dev->dev));
 
 	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
 		/* On bridges, need to examine secondary status register  */
 		status = get_pci_parity_status(dev, 1);
 
-		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
+		edac_dbg(4, "PCI SEC_STATUS= 0x%04x %s\n",
+			 status, dev_name(&dev->dev));
 
 		/* check the secondary status reg for errors,
 		 * on NOT broken boards
@@ -670,7 +670,7 @@ void edac_pci_do_parity_check(void)
 {
 	int before_count;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	/* if policy has PCI check off, leave now */
 	if (!check_pci_errors)
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 67975ba..399aec3 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -275,7 +275,7 @@ static void i3000_check(struct mem_ctl_info *mci)
 {
 	struct i3000_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	i3000_get_error_info(mci, &info);
 	i3000_process_error_info(mci, &info, 1);
 }
@@ -322,7 +322,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	unsigned long mchbar;
 	void __iomem *window;
 
-	debugf0("MC:\n");
+	edac_dbg(0, "MC:\n");
 
 	pci_read_config_dword(pdev, I3000_MCHBAR, (u32 *) & mchbar);
 	mchbar &= I3000_MCHBAR_MASK;
@@ -366,7 +366,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("MC: init mci\n");
+	edac_dbg(3, "MC: init mci\n");
 
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
@@ -399,8 +399,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 		cumul_size = value << (I3000_DRB_SHIFT - PAGE_SHIFT);
 		if (interleaved)
 			cumul_size <<= 1;
-		debugf3("MC: (%d) cumul_size 0x%x\n",
-			i, cumul_size);
+		edac_dbg(3, "MC: (%d) cumul_size 0x%x\n", i, cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;
 
@@ -429,7 +428,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf3("MC: failed edac_mc_add_mc()\n");
+		edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -445,7 +444,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("MC: success\n");
+	edac_dbg(3, "MC: success\n");
 	return 0;
 
 fail:
@@ -461,7 +460,7 @@ static int __devinit i3000_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC:\n");
+	edac_dbg(0, "MC:\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -477,7 +476,7 @@ static void __devexit i3000_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (i3000_pci)
 		edac_pci_release_generic_ctl(i3000_pci);
@@ -511,7 +510,7 @@ static int __init i3000_init(void)
 {
 	int pci_rc;
 
-	debugf3("MC:\n");
+	edac_dbg(3, "MC:\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -525,14 +524,14 @@ static int __init i3000_init(void)
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					PCI_DEVICE_ID_INTEL_3000_HB, NULL);
 		if (!mci_pdev) {
-			debugf0("i3000 pci_get_device fail\n");
+			edac_dbg(0, "i3000 pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
 
 		pci_rc = i3000_init_one(mci_pdev, i3000_pci_tbl);
 		if (pci_rc < 0) {
-			debugf0("i3000 init fail\n");
+			edac_dbg(0, "i3000 init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -552,7 +551,7 @@ fail0:
 
 static void __exit i3000_exit(void)
 {
-	debugf3("MC:\n");
+	edac_dbg(3, "MC:\n");
 
 	pci_unregister_driver(&i3000_driver);
 	if (!i3000_registered) {
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 9698ca3..dfd843a 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -110,10 +110,10 @@ static int how_many_channels(struct pci_dev *pdev)
 
 	pci_read_config_byte(pdev, I3200_CAPID0 + 8, &capid0_8b);
 	if (capid0_8b & 0x20) { /* check DCD: Dual Channel Disable */
-		debugf0("In single channel mode.\n");
+		edac_dbg(0, "In single channel mode\n");
 		return 1;
 	} else {
-		debugf0("In dual channel mode.\n");
+		edac_dbg(0, "In dual channel mode\n");
 		return 2;
 	}
 }
@@ -245,7 +245,7 @@ static void i3200_check(struct mem_ctl_info *mci)
 {
 	struct i3200_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	i3200_get_and_clear_error_info(mci, &info);
 	i3200_process_error_info(mci, &info);
 }
@@ -332,7 +332,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	void __iomem *window;
 	struct i3200_priv *priv;
 
-	debugf0("MC:\n");
+	edac_dbg(0, "MC:\n");
 
 	window = i3200_map_mchbar(pdev);
 	if (!window)
@@ -352,7 +352,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("MC: init mci\n");
+	edac_dbg(3, "MC: init mci\n");
 
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
@@ -403,12 +403,12 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf3("MC: failed edac_mc_add_mc()\n");
+		edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
 	/* get this far and it's successful */
-	debugf3("MC: success\n");
+	edac_dbg(3, "MC: success\n");
 	return 0;
 
 fail:
@@ -424,7 +424,7 @@ static int __devinit i3200_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC:\n");
+	edac_dbg(0, "MC:\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -441,7 +441,7 @@ static void __devexit i3200_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct i3200_priv *priv;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (!mci)
@@ -475,7 +475,7 @@ static int __init i3200_init(void)
 {
 	int pci_rc;
 
-	debugf3("MC:\n");
+	edac_dbg(3, "MC:\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -489,14 +489,14 @@ static int __init i3200_init(void)
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				PCI_DEVICE_ID_INTEL_3200_HB, NULL);
 		if (!mci_pdev) {
-			debugf0("i3200 pci_get_device fail\n");
+			edac_dbg(0, "i3200 pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
 
 		pci_rc = i3200_init_one(mci_pdev, i3200_pci_tbl);
 		if (pci_rc < 0) {
-			debugf0("i3200 init fail\n");
+			edac_dbg(0, "i3200 init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -516,7 +516,7 @@ fail0:
 
 static void __exit i3200_exit(void)
 {
-	debugf3("MC:\n");
+	edac_dbg(3, "MC:\n");
 
 	pci_unregister_driver(&i3200_driver);
 	if (!i3200_registered) {
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 0e16db6..96431a5 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -478,10 +478,9 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 	ras = NREC_RAS(info->nrecmemb);
 	cas = NREC_CAS(info->nrecmemb);
 
-	debugf0("\t\tCSROW= %d  Channel= %d "
-		"(DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
-		rank, channel, bank,
-		rdwr ? "Write" : "Read", ras, cas);
+	edac_dbg(0, "\t\tCSROW= %d  Channel= %d (DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
+		 rank, channel, bank,
+		 rdwr ? "Write" : "Read", ras, cas);
 
 	/* Only 1 bit will be on */
 	switch (allErrors) {
@@ -558,7 +557,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 	/* ONLY ONE of the possible error bits will be set, as per the docs */
 	ue_errors = allErrors & FERR_NF_UNCORRECTABLE;
 	if (ue_errors) {
-		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
+		edac_dbg(0, "\tUncorrected bits= 0x%x\n", ue_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
 
@@ -574,11 +573,9 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		ras = NREC_RAS(info->nrecmemb);
 		cas = NREC_CAS(info->nrecmemb);
 
-		debugf0
-			("\t\tCSROW= %d  Channels= %d,%d  (Branch= %d "
-			"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
-			rank, channel, channel + 1, branch >> 1, bank,
-			rdwr ? "Write" : "Read", ras, cas);
+		edac_dbg(0, "\t\tCSROW= %d  Channels= %d,%d  (Branch= %d DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
+			 rank, channel, channel + 1, branch >> 1, bank,
+			 rdwr ? "Write" : "Read", ras, cas);
 
 		switch (ue_errors) {
 		case FERR_NF_M12ERR:
@@ -630,7 +627,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 	/* Check correctable errors */
 	ce_errors = allErrors & FERR_NF_CORRECTABLE;
 	if (ce_errors) {
-		debugf0("\tCorrected bits= 0x%x\n", ce_errors);
+		edac_dbg(0, "\tCorrected bits= 0x%x\n", ce_errors);
 
 		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
 
@@ -648,10 +645,9 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		ras = REC_RAS(info->recmemb);
 		cas = REC_CAS(info->recmemb);
 
-		debugf0("\t\tCSROW= %d Channel= %d  (Branch %d "
-			"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
-			rank, channel, branch >> 1, bank,
-			rdwr ? "Write" : "Read", ras, cas);
+		edac_dbg(0, "\t\tCSROW= %d Channel= %d  (Branch %d DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
+			 rank, channel, branch >> 1, bank,
+			 rdwr ? "Write" : "Read", ras, cas);
 
 		switch (ce_errors) {
 		case FERR_NF_M17ERR:
@@ -763,7 +759,7 @@ static void i5000_clear_error(struct mem_ctl_info *mci)
 static void i5000_check_error(struct mem_ctl_info *mci)
 {
 	struct i5000_error_info info;
-	debugf4("MC%d\n", mci->mc_idx);
+	edac_dbg(4, "MC%d\n", mci->mc_idx);
 	i5000_get_error_info(mci, &info);
 	i5000_process_error_info(mci, &info, 1);
 }
@@ -834,15 +830,16 @@ static int i5000_get_devices(struct mem_ctl_info *mci, int dev_idx)
 
 	pvt->fsb_error_regs = pdev;
 
-	debugf1("System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->system_address),
-		pvt->system_address->vendor, pvt->system_address->device);
-	debugf1("Branchmap, control and errors - PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->branchmap_werrors),
-		pvt->branchmap_werrors->vendor, pvt->branchmap_werrors->device);
-	debugf1("FSB Error Regs - PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->fsb_error_regs),
-		pvt->fsb_error_regs->vendor, pvt->fsb_error_regs->device);
+	edac_dbg(1, "System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->system_address),
+		 pvt->system_address->vendor, pvt->system_address->device);
+	edac_dbg(1, "Branchmap, control and errors - PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->branchmap_werrors),
+		 pvt->branchmap_werrors->vendor,
+		 pvt->branchmap_werrors->device);
+	edac_dbg(1, "FSB Error Regs - PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->fsb_error_regs),
+		 pvt->fsb_error_regs->vendor, pvt->fsb_error_regs->device);
 
 	pdev = NULL;
 	pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
@@ -965,24 +962,25 @@ static void decode_mtr(int slot_row, u16 mtr)
 
 	ans = MTR_DIMMS_PRESENT(mtr);
 
-	debugf2("\tMTR%d=0x%x:  DIMMs are %s\n", slot_row, mtr,
-		ans ? "Present" : "NOT Present");
+	edac_dbg(2, "\tMTR%d=0x%x:  DIMMs are %sPresent\n",
+		 slot_row, mtr, ans ? "" : "NOT ");
 	if (!ans)
 		return;
 
-	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
-	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
-	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n",
-		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
-		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
-		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
-		"reserved");
-	debugf2("\t\tNUMCOL: %s\n",
-		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
-		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
-		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
-		"reserved");
+	edac_dbg(2, "\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
+	edac_dbg(2, "\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
+	edac_dbg(2, "\t\tNUMRANK: %s\n",
+		 MTR_DIMM_RANK(mtr) ? "double" : "single");
+	edac_dbg(2, "\t\tNUMROW: %s\n",
+		 MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		 MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		 MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		 "reserved");
+	edac_dbg(2, "\t\tNUMCOL: %s\n",
+		 MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		 MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		 MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		 "reserved");
 }
 
 static void handle_channel(struct i5000_pvt *pvt, int slot, int channel,
@@ -1053,7 +1051,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 				"--------------------------------");
 			p += n;
 			space -= n;
-			debugf2("%s\n", mem_buffer);
+			edac_dbg(2, "%s\n", mem_buffer);
 			p = mem_buffer;
 			space = PAGE_SIZE;
 		}
@@ -1074,7 +1072,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 		}
 		p += n;
 		space -= n;
-		debugf2("%s\n", mem_buffer);
+		edac_dbg(2, "%s\n", mem_buffer);
 		p = mem_buffer;
 		space = PAGE_SIZE;
 	}
@@ -1084,7 +1082,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 		"--------------------------------");
 	p += n;
 	space -= n;
-	debugf2("%s\n", mem_buffer);
+	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
@@ -1097,7 +1095,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 		p += n;
 		space -= n;
 	}
-	debugf2("%s\n", mem_buffer);
+	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
@@ -1110,7 +1108,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 	}
 
 	/* output the last message and free buffer */
-	debugf2("%s\n", mem_buffer);
+	edac_dbg(2, "%s\n", mem_buffer);
 	kfree(mem_buffer);
 }
 
@@ -1140,17 +1138,18 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
 
-	debugf2("AMBASE= 0x%lx  MAXCH= %d  MAX-DIMM-Per-CH= %d\n",
-		(long unsigned int)pvt->ambase, pvt->maxch, pvt->maxdimmperch);
+	edac_dbg(2, "AMBASE= 0x%lx  MAXCH= %d  MAX-DIMM-Per-CH= %d\n",
+		 (long unsigned int)pvt->ambase, pvt->maxch, pvt->maxdimmperch);
 
 	/* Get the Branch Map regs */
 	pci_read_config_word(pvt->branchmap_werrors, TOLM, &pvt->tolm);
 	pvt->tolm >>= 12;
-	debugf2("\nTOLM (number of 256M regions) =%u (0x%x)\n", pvt->tolm,
-		pvt->tolm);
+	edac_dbg(2, "TOLM (number of 256M regions) =%u (0x%x)\n",
+		 pvt->tolm, pvt->tolm);
 
 	actual_tolm = pvt->tolm << 28;
-	debugf2("Actual TOLM byte addr=%u (0x%x)\n", actual_tolm, actual_tolm);
+	edac_dbg(2, "Actual TOLM byte addr=%u (0x%x)\n",
+		 actual_tolm, actual_tolm);
 
 	pci_read_config_word(pvt->branchmap_werrors, MIR0, &pvt->mir0);
 	pci_read_config_word(pvt->branchmap_werrors, MIR1, &pvt->mir1);
@@ -1160,15 +1159,18 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 	limit = (pvt->mir0 >> 4) & 0x0FFF;
 	way0 = pvt->mir0 & 0x1;
 	way1 = pvt->mir0 & 0x2;
-	debugf2("MIR0: limit= 0x%x  WAY1= %u  WAY0= %x\n", limit, way1, way0);
+	edac_dbg(2, "MIR0: limit= 0x%x  WAY1= %u  WAY0= %x\n",
+		 limit, way1, way0);
 	limit = (pvt->mir1 >> 4) & 0x0FFF;
 	way0 = pvt->mir1 & 0x1;
 	way1 = pvt->mir1 & 0x2;
-	debugf2("MIR1: limit= 0x%x  WAY1= %u  WAY0= %x\n", limit, way1, way0);
+	edac_dbg(2, "MIR1: limit= 0x%x  WAY1= %u  WAY0= %x\n",
+		 limit, way1, way0);
 	limit = (pvt->mir2 >> 4) & 0x0FFF;
 	way0 = pvt->mir2 & 0x1;
 	way1 = pvt->mir2 & 0x2;
-	debugf2("MIR2: limit= 0x%x  WAY1= %u  WAY0= %x\n", limit, way1, way0);
+	edac_dbg(2, "MIR2: limit= 0x%x  WAY1= %u  WAY0= %x\n",
+		 limit, way1, way0);
 
 	/* Get the MTR[0-3] regs */
 	for (slot_row = 0; slot_row < NUM_MTRS; slot_row++) {
@@ -1177,31 +1179,31 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 		pci_read_config_word(pvt->branch_0, where,
 				&pvt->b0_mtr[slot_row]);
 
-		debugf2("MTR%d where=0x%x B0 value=0x%x\n", slot_row, where,
-			pvt->b0_mtr[slot_row]);
+		edac_dbg(2, "MTR%d where=0x%x B0 value=0x%x\n",
+			 slot_row, where, pvt->b0_mtr[slot_row]);
 
 		if (pvt->maxch >= CHANNELS_PER_BRANCH) {
 			pci_read_config_word(pvt->branch_1, where,
 					&pvt->b1_mtr[slot_row]);
-			debugf2("MTR%d where=0x%x B1 value=0x%x\n", slot_row,
-				where, pvt->b1_mtr[slot_row]);
+			edac_dbg(2, "MTR%d where=0x%x B1 value=0x%x\n",
+				 slot_row, where, pvt->b1_mtr[slot_row]);
 		} else {
 			pvt->b1_mtr[slot_row] = 0;
 		}
 	}
 
 	/* Read and dump branch 0's MTRs */
-	debugf2("\nMemory Technology Registers:\n");
-	debugf2("   Branch 0:\n");
+	edac_dbg(2, "Memory Technology Registers:\n");
+	edac_dbg(2, "   Branch 0:\n");
 	for (slot_row = 0; slot_row < NUM_MTRS; slot_row++) {
 		decode_mtr(slot_row, pvt->b0_mtr[slot_row]);
 	}
 	pci_read_config_word(pvt->branch_0, AMB_PRESENT_0,
 			&pvt->b0_ambpresent0);
-	debugf2("\t\tAMB-Branch 0-present0 0x%x:\n", pvt->b0_ambpresent0);
+	edac_dbg(2, "\t\tAMB-Branch 0-present0 0x%x:\n", pvt->b0_ambpresent0);
 	pci_read_config_word(pvt->branch_0, AMB_PRESENT_1,
 			&pvt->b0_ambpresent1);
-	debugf2("\t\tAMB-Branch 0-present1 0x%x:\n", pvt->b0_ambpresent1);
+	edac_dbg(2, "\t\tAMB-Branch 0-present1 0x%x:\n", pvt->b0_ambpresent1);
 
 	/* Only if we have 2 branchs (4 channels) */
 	if (pvt->maxch < CHANNELS_PER_BRANCH) {
@@ -1209,18 +1211,18 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 		pvt->b1_ambpresent1 = 0;
 	} else {
 		/* Read and dump  branch 1's MTRs */
-		debugf2("   Branch 1:\n");
+		edac_dbg(2, "   Branch 1:\n");
 		for (slot_row = 0; slot_row < NUM_MTRS; slot_row++) {
 			decode_mtr(slot_row, pvt->b1_mtr[slot_row]);
 		}
 		pci_read_config_word(pvt->branch_1, AMB_PRESENT_0,
 				&pvt->b1_ambpresent0);
-		debugf2("\t\tAMB-Branch 1-present0 0x%x:\n",
-			pvt->b1_ambpresent0);
+		edac_dbg(2, "\t\tAMB-Branch 1-present0 0x%x:\n",
+			 pvt->b1_ambpresent0);
 		pci_read_config_word(pvt->branch_1, AMB_PRESENT_1,
 				&pvt->b1_ambpresent1);
-		debugf2("\t\tAMB-Branch 1-present1 0x%x:\n",
-			pvt->b1_ambpresent1);
+		edac_dbg(2, "\t\tAMB-Branch 1-present1 0x%x:\n",
+			 pvt->b1_ambpresent1);
 	}
 
 	/* Go and determine the size of each DIMM and place in an
@@ -1355,9 +1357,9 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	int num_channels;
 	int num_dimms_per_channel;
 
-	debugf0("MC: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__FILE__, pdev->bus->number,
-		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+	edac_dbg(0, "MC: pdev bus %u dev=0x%x fn=0x%x\n",
+		 pdev->bus->number,
+		 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/* We only are looking for func 0 of the set */
 	if (PCI_FUNC(pdev->devfn) != 0)
@@ -1379,8 +1381,8 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	i5000_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
 					&num_channels);
 
-	debugf0("MC: Number of Branches=2 Channels= %d  DIMMS= %d\n",
-		num_channels, num_dimms_per_channel);
+	edac_dbg(0, "MC: Number of Branches=2 Channels= %d  DIMMS= %d\n",
+		 num_channels, num_dimms_per_channel);
 
 	/* allocate a new MC control structure */
 
@@ -1397,7 +1399,7 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: %s(): mci = %p\n", __FILE__, mci);
+	edac_dbg(0, "MC: mci = %p\n", mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1429,19 +1431,16 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	/* initialize the MC control structure 'csrows' table
 	 * with the mapping and control information */
 	if (i5000_init_csrows(mci)) {
-		debugf0("MC: Setting mci->edac_cap to EDAC_FLAG_NONE\n"
-			"    because i5000_init_csrows() returned nonzero "
-			"value\n");
+		edac_dbg(0, "MC: Setting mci->edac_cap to EDAC_FLAG_NONE because i5000_init_csrows() returned nonzero value\n");
 		mci->edac_cap = EDAC_FLAG_NONE;	/* no csrows found */
 	} else {
-		debugf1("MC: Enable error reporting now\n");
+		edac_dbg(1, "MC: Enable error reporting now\n");
 		i5000_enable_error_reporting(mci);
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: %s(): failed edac_mc_add_mc()\n",
-			__FILE__);
+		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1485,7 +1484,7 @@ static int __devinit i5000_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s()\n", __FILE__);
+	edac_dbg(0, "MC:\n");
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1504,7 +1503,7 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __FILE__);
+	edac_dbg(0, "\n");
 
 	if (i5000_pci)
 		edac_pci_release_generic_ctl(i5000_pci);
@@ -1550,7 +1549,7 @@ static int __init i5000_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: %s()\n", __FILE__);
+	edac_dbg(2, "MC:\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -1566,7 +1565,7 @@ static int __init i5000_init(void)
  */
 static void __exit i5000_exit(void)
 {
-	debugf2("MC: %s()\n", __FILE__);
+	edac_dbg(2, "MC:\n");
 	pci_unregister_driver(&i5000_driver);
 }
 
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 19aa284..a9b996c 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -859,8 +859,8 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 				i5100_rank_to_slot(mci, chan, rank));
 		}
 
-		debugf2("dimm channel %d, rank %d, size %ld\n",
-			chan, rank, (long)PAGES_TO_MiB(npages));
+		edac_dbg(2, "dimm channel %d, rank %d, size %ld\n",
+			 chan, rank, (long)PAGES_TO_MiB(npages));
 	}
 }
 
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 3004b94..90fad3a 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -542,10 +542,9 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 	ras = nrec_ras(info);
 	cas = nrec_cas(info);
 
-	debugf0("\t\tDIMM= %d  Channels= %d,%d  (Branch= %d "
-		"DRAM Bank= %d Buffer ID = %d rdwr= %s ras= %d cas= %d)\n",
-		rank, channel, channel + 1, branch >> 1, bank,
-		buf_id, rdwr_str(rdwr), ras, cas);
+	edac_dbg(0, "\t\tDIMM= %d  Channels= %d,%d  (Branch= %d DRAM Bank= %d Buffer ID = %d rdwr= %s ras= %d cas= %d)\n",
+		 rank, channel, channel + 1, branch >> 1, bank,
+		 buf_id, rdwr_str(rdwr), ras, cas);
 
 	/* Only 1 bit will be on */
 	errnum = find_first_bit(&allErrors, ARRAY_SIZE(error_name));
@@ -595,7 +594,7 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 	/* Correctable errors */
 	if (allErrors & ERROR_NF_CORRECTABLE) {
-		debugf0("\tCorrected bits= 0x%lx\n", allErrors);
+		edac_dbg(0, "\tCorrected bits= 0x%lx\n", allErrors);
 
 		branch = extract_fbdchan_indx(info->ferr_nf_fbd);
 
@@ -616,10 +615,9 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 		/* Only 1 bit will be on */
 		errnum = find_first_bit(&allErrors, ARRAY_SIZE(error_name));
 
-		debugf0("\t\tDIMM= %d Channel= %d  (Branch %d "
-			"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
-			rank, channel, branch >> 1, bank,
-			rdwr_str(rdwr), ras, cas);
+		edac_dbg(0, "\t\tDIMM= %d Channel= %d  (Branch %d DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
+			 rank, channel, branch >> 1, bank,
+			 rdwr_str(rdwr), ras, cas);
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
@@ -682,7 +680,7 @@ static void i5400_clear_error(struct mem_ctl_info *mci)
 static void i5400_check_error(struct mem_ctl_info *mci)
 {
 	struct i5400_error_info info;
-	debugf4("MC%d\n", mci->mc_idx);
+	edac_dbg(4, "MC%d\n", mci->mc_idx);
 	i5400_get_error_info(mci, &info);
 	i5400_process_error_info(mci, &info);
 }
@@ -768,15 +766,16 @@ static int i5400_get_devices(struct mem_ctl_info *mci, int dev_idx)
 	}
 	pvt->fsb_error_regs = pdev;
 
-	debugf1("System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->system_address),
-		pvt->system_address->vendor, pvt->system_address->device);
-	debugf1("Branchmap, control and errors - PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->branchmap_werrors),
-		pvt->branchmap_werrors->vendor, pvt->branchmap_werrors->device);
-	debugf1("FSB Error Regs - PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->fsb_error_regs),
-		pvt->fsb_error_regs->vendor, pvt->fsb_error_regs->device);
+	edac_dbg(1, "System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->system_address),
+		 pvt->system_address->vendor, pvt->system_address->device);
+	edac_dbg(1, "Branchmap, control and errors - PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->branchmap_werrors),
+		 pvt->branchmap_werrors->vendor,
+		 pvt->branchmap_werrors->device);
+	edac_dbg(1, "FSB Error Regs - PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->fsb_error_regs),
+		 pvt->fsb_error_regs->vendor, pvt->fsb_error_regs->device);
 
 	pvt->branch_0 = pci_get_device(PCI_VENDOR_ID_INTEL,
 				       PCI_DEVICE_ID_INTEL_5400_FBD0, NULL);
@@ -864,8 +863,8 @@ static int determine_mtr(struct i5400_pvt *pvt, int dimm, int channel)
 	n = dimm;
 
 	if (n >= DIMMS_PER_CHANNEL) {
-		debugf0("ERROR: trying to access an invalid dimm: %d\n",
-			dimm);
+		edac_dbg(0, "ERROR: trying to access an invalid dimm: %d\n",
+			 dimm);
 		return 0;
 	}
 
@@ -885,28 +884,29 @@ static void decode_mtr(int slot_row, u16 mtr)
 
 	ans = MTR_DIMMS_PRESENT(mtr);
 
-	debugf2("\tMTR%d=0x%x:  DIMMs are %s\n", slot_row, mtr,
-		ans ? "Present" : "NOT Present");
+	edac_dbg(2, "\tMTR%d=0x%x:  DIMMs are %sPresent\n",
+		 slot_row, mtr, ans ? "" : "NOT ");
 	if (!ans)
 		return;
 
-	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
-
-	debugf2("\t\tELECTRICAL THROTTLING is %s\n",
-		MTR_DIMMS_ETHROTTLE(mtr) ? "enabled" : "disabled");
-
-	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
-	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n",
-		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
-		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
-		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
-		"65,536 - 16 rows");
-	debugf2("\t\tNUMCOL: %s\n",
-		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
-		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
-		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
-		"reserved");
+	edac_dbg(2, "\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
+
+	edac_dbg(2, "\t\tELECTRICAL THROTTLING is %s\n",
+		 MTR_DIMMS_ETHROTTLE(mtr) ? "enabled" : "disabled");
+
+	edac_dbg(2, "\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
+	edac_dbg(2, "\t\tNUMRANK: %s\n",
+		 MTR_DIMM_RANK(mtr) ? "double" : "single");
+	edac_dbg(2, "\t\tNUMROW: %s\n",
+		 MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		 MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		 MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		 "65,536 - 16 rows");
+	edac_dbg(2, "\t\tNUMCOL: %s\n",
+		 MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		 MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		 MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		 "reserved");
 }
 
 static void handle_channel(struct i5400_pvt *pvt, int dimm, int channel,
@@ -979,7 +979,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 					"-------------------------------");
 			p += n;
 			space -= n;
-			debugf2("%s\n", mem_buffer);
+			edac_dbg(2, "%s\n", mem_buffer);
 			p = mem_buffer;
 			space = PAGE_SIZE;
 		}
@@ -994,7 +994,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 			p += n;
 			space -= n;
 		}
-		debugf2("%s\n", mem_buffer);
+		edac_dbg(2, "%s\n", mem_buffer);
 		p = mem_buffer;
 		space = PAGE_SIZE;
 	}
@@ -1004,7 +1004,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 			"-------------------------------");
 	p += n;
 	space -= n;
-	debugf2("%s\n", mem_buffer);
+	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
@@ -1019,7 +1019,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 	}
 
 	space -= n;
-	debugf2("%s\n", mem_buffer);
+	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
@@ -1032,7 +1032,7 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 	}
 
 	/* output the last message and free buffer */
-	debugf2("%s\n", mem_buffer);
+	edac_dbg(2, "%s\n", mem_buffer);
 	kfree(mem_buffer);
 }
 
@@ -1062,18 +1062,18 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
 
-	debugf2("AMBASE= 0x%lx  MAXCH= %d  MAX-DIMM-Per-CH= %d\n",
-		(long unsigned int)pvt->ambase, pvt->maxch, pvt->maxdimmperch);
+	edac_dbg(2, "AMBASE= 0x%lx  MAXCH= %d  MAX-DIMM-Per-CH= %d\n",
+		 (long unsigned int)pvt->ambase, pvt->maxch, pvt->maxdimmperch);
 
 	/* Get the Branch Map regs */
 	pci_read_config_word(pvt->branchmap_werrors, TOLM, &pvt->tolm);
 	pvt->tolm >>= 12;
-	debugf2("\nTOLM (number of 256M regions) =%u (0x%x)\n", pvt->tolm,
-		pvt->tolm);
+	edac_dbg(2, "\nTOLM (number of 256M regions) =%u (0x%x)\n",
+		 pvt->tolm, pvt->tolm);
 
 	actual_tolm = (u32) ((1000l * pvt->tolm) >> (30 - 28));
-	debugf2("Actual TOLM byte addr=%u.%03u GB (0x%x)\n",
-		actual_tolm/1000, actual_tolm % 1000, pvt->tolm << 28);
+	edac_dbg(2, "Actual TOLM byte addr=%u.%03u GB (0x%x)\n",
+		 actual_tolm/1000, actual_tolm % 1000, pvt->tolm << 28);
 
 	pci_read_config_word(pvt->branchmap_werrors, MIR0, &pvt->mir0);
 	pci_read_config_word(pvt->branchmap_werrors, MIR1, &pvt->mir1);
@@ -1082,11 +1082,13 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	limit = (pvt->mir0 >> 4) & 0x0fff;
 	way0 = pvt->mir0 & 0x1;
 	way1 = pvt->mir0 & 0x2;
-	debugf2("MIR0: limit= 0x%x  WAY1= %u  WAY0= %x\n", limit, way1, way0);
+	edac_dbg(2, "MIR0: limit= 0x%x  WAY1= %u  WAY0= %x\n",
+		 limit, way1, way0);
 	limit = (pvt->mir1 >> 4) & 0xfff;
 	way0 = pvt->mir1 & 0x1;
 	way1 = pvt->mir1 & 0x2;
-	debugf2("MIR1: limit= 0x%x  WAY1= %u  WAY0= %x\n", limit, way1, way0);
+	edac_dbg(2, "MIR1: limit= 0x%x  WAY1= %u  WAY0= %x\n",
+		 limit, way1, way0);
 
 	/* Get the set of MTR[0-3] regs by each branch */
 	for (slot_row = 0; slot_row < DIMMS_PER_CHANNEL; slot_row++) {
@@ -1096,8 +1098,8 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 		pci_read_config_word(pvt->branch_0, where,
 				&pvt->b0_mtr[slot_row]);
 
-		debugf2("MTR%d where=0x%x B0 value=0x%x\n", slot_row, where,
-			pvt->b0_mtr[slot_row]);
+		edac_dbg(2, "MTR%d where=0x%x B0 value=0x%x\n",
+			 slot_row, where, pvt->b0_mtr[slot_row]);
 
 		if (pvt->maxch < CHANNELS_PER_BRANCH) {
 			pvt->b1_mtr[slot_row] = 0;
@@ -1107,22 +1109,22 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 		/* Branch 1 set of MTR registers */
 		pci_read_config_word(pvt->branch_1, where,
 				&pvt->b1_mtr[slot_row]);
-		debugf2("MTR%d where=0x%x B1 value=0x%x\n", slot_row, where,
-			pvt->b1_mtr[slot_row]);
+		edac_dbg(2, "MTR%d where=0x%x B1 value=0x%x\n",
+			 slot_row, where, pvt->b1_mtr[slot_row]);
 	}
 
 	/* Read and dump branch 0's MTRs */
-	debugf2("\nMemory Technology Registers:\n");
-	debugf2("   Branch 0:\n");
+	edac_dbg(2, "Memory Technology Registers:\n");
+	edac_dbg(2, "   Branch 0:\n");
 	for (slot_row = 0; slot_row < DIMMS_PER_CHANNEL; slot_row++)
 		decode_mtr(slot_row, pvt->b0_mtr[slot_row]);
 
 	pci_read_config_word(pvt->branch_0, AMBPRESENT_0,
 			&pvt->b0_ambpresent0);
-	debugf2("\t\tAMB-Branch 0-present0 0x%x:\n", pvt->b0_ambpresent0);
+	edac_dbg(2, "\t\tAMB-Branch 0-present0 0x%x:\n", pvt->b0_ambpresent0);
 	pci_read_config_word(pvt->branch_0, AMBPRESENT_1,
 			&pvt->b0_ambpresent1);
-	debugf2("\t\tAMB-Branch 0-present1 0x%x:\n", pvt->b0_ambpresent1);
+	edac_dbg(2, "\t\tAMB-Branch 0-present1 0x%x:\n", pvt->b0_ambpresent1);
 
 	/* Only if we have 2 branchs (4 channels) */
 	if (pvt->maxch < CHANNELS_PER_BRANCH) {
@@ -1130,18 +1132,18 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 		pvt->b1_ambpresent1 = 0;
 	} else {
 		/* Read and dump  branch 1's MTRs */
-		debugf2("   Branch 1:\n");
+		edac_dbg(2, "   Branch 1:\n");
 		for (slot_row = 0; slot_row < DIMMS_PER_CHANNEL; slot_row++)
 			decode_mtr(slot_row, pvt->b1_mtr[slot_row]);
 
 		pci_read_config_word(pvt->branch_1, AMBPRESENT_0,
 				&pvt->b1_ambpresent0);
-		debugf2("\t\tAMB-Branch 1-present0 0x%x:\n",
-			pvt->b1_ambpresent0);
+		edac_dbg(2, "\t\tAMB-Branch 1-present0 0x%x:\n",
+			 pvt->b1_ambpresent0);
 		pci_read_config_word(pvt->branch_1, AMBPRESENT_1,
 				&pvt->b1_ambpresent1);
-		debugf2("\t\tAMB-Branch 1-present1 0x%x:\n",
-			pvt->b1_ambpresent1);
+		edac_dbg(2, "\t\tAMB-Branch 1-present1 0x%x:\n",
+			 pvt->b1_ambpresent1);
 	}
 
 	/* Go and determine the size of each DIMM and place in an
@@ -1193,9 +1195,9 @@ static int i5400_init_dimms(struct mem_ctl_info *mci)
 
 			size_mb =  pvt->dimm_info[slot][channel].megabytes;
 
-			debugf2("dimm (branch %d channel %d slot %d): %d.%03d GB\n",
-				channel / 2, channel % 2, slot,
-				size_mb / 1000, size_mb % 1000);
+			edac_dbg(2, "dimm (branch %d channel %d slot %d): %d.%03d GB\n",
+				 channel / 2, channel % 2, slot,
+				 size_mb / 1000, size_mb % 1000);
 
 			dimm->nr_pages = size_mb << 8;
 			dimm->grain = 8;
@@ -1259,9 +1261,9 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (dev_idx >= ARRAY_SIZE(i5400_devs))
 		return -EINVAL;
 
-	debugf0("MC: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__FILE__, pdev->bus->number,
-		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+	edac_dbg(0, "MC: pdev bus %u dev=0x%x fn=0x%x\n",
+		 pdev->bus->number,
+		 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/* We only are looking for func 0 of the set */
 	if (PCI_FUNC(pdev->devfn) != 0)
@@ -1285,7 +1287,7 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: %s(): mci = %p\n", __FILE__, mci);
+	edac_dbg(0, "MC: mci = %p\n", mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1317,19 +1319,16 @@ static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
 	/* initialize the MC control structure 'dimms' table
 	 * with the mapping and control information */
 	if (i5400_init_dimms(mci)) {
-		debugf0("MC: Setting mci->edac_cap to EDAC_FLAG_NONE\n"
-			"    because i5400_init_dimms() returned nonzero "
-			"value\n");
+		edac_dbg(0, "MC: Setting mci->edac_cap to EDAC_FLAG_NONE because i5400_init_dimms() returned nonzero value\n");
 		mci->edac_cap = EDAC_FLAG_NONE;	/* no dimms found */
 	} else {
-		debugf1("MC: Enable error reporting now\n");
+		edac_dbg(1, "MC: Enable error reporting now\n");
 		i5400_enable_error_reporting(mci);
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: %s(): failed edac_mc_add_mc()\n",
-			__FILE__);
+		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1373,7 +1372,7 @@ static int __devinit i5400_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s()\n", __FILE__);
+	edac_dbg(0, "MC:\n");
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1392,7 +1391,7 @@ static void __devexit i5400_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __FILE__);
+	edac_dbg(0, "\n");
 
 	if (i5400_pci)
 		edac_pci_release_generic_ctl(i5400_pci);
@@ -1438,7 +1437,7 @@ static int __init i5400_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: %s()\n", __FILE__);
+	edac_dbg(2, "MC:\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1454,7 +1453,7 @@ static int __init i5400_init(void)
  */
 static void __exit i5400_exit(void)
 {
-	debugf2("MC: %s()\n", __FILE__);
+	edac_dbg(2, "MC:\n");
 	pci_unregister_driver(&i5400_driver);
 }
 
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 7eca688..738b891 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -596,9 +596,8 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	mtr = pvt->mtr[slot][branch];
 	ans = MTR_DIMMS_PRESENT(mtr) ? 1 : 0;
 
-	debugf2("\tMTR%d CH%d: DIMMs are %s (mtr)\n",
-		slot, channel,
-		ans ? "Present" : "NOT Present");
+	edac_dbg(2, "\tMTR%d CH%d: DIMMs are %sPresent (mtr)\n",
+		 slot, channel, ans ? "" : "NOT ");
 
 	/* Determine if there is a DIMM present in this DIMM slot */
 	if (!ans)
@@ -620,24 +619,25 @@ static int decode_mtr(struct i7300_pvt *pvt,
 
 	dinfo->megabytes = 1 << addrBits;
 
-	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
-
-	debugf2("\t\tELECTRICAL THROTTLING is %s\n",
-		MTR_DIMMS_ETHROTTLE(mtr) ? "enabled" : "disabled");
-
-	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
-	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANKS(mtr) ? "double" : "single");
-	debugf2("\t\tNUMROW: %s\n",
-		MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
-		MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
-		MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
-		"65,536 - 16 rows");
-	debugf2("\t\tNUMCOL: %s\n",
-		MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
-		MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
-		MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
-		"reserved");
-	debugf2("\t\tSIZE: %d MB\n", dinfo->megabytes);
+	edac_dbg(2, "\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
+
+	edac_dbg(2, "\t\tELECTRICAL THROTTLING is %s\n",
+		 MTR_DIMMS_ETHROTTLE(mtr) ? "enabled" : "disabled");
+
+	edac_dbg(2, "\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
+	edac_dbg(2, "\t\tNUMRANK: %s\n",
+		 MTR_DIMM_RANKS(mtr) ? "double" : "single");
+	edac_dbg(2, "\t\tNUMROW: %s\n",
+		 MTR_DIMM_ROWS(mtr) == 0 ? "8,192 - 13 rows" :
+		 MTR_DIMM_ROWS(mtr) == 1 ? "16,384 - 14 rows" :
+		 MTR_DIMM_ROWS(mtr) == 2 ? "32,768 - 15 rows" :
+		 "65,536 - 16 rows");
+	edac_dbg(2, "\t\tNUMCOL: %s\n",
+		 MTR_DIMM_COLS(mtr) == 0 ? "1,024 - 10 columns" :
+		 MTR_DIMM_COLS(mtr) == 1 ? "2,048 - 11 columns" :
+		 MTR_DIMM_COLS(mtr) == 2 ? "4,096 - 12 columns" :
+		 "reserved");
+	edac_dbg(2, "\t\tSIZE: %d MB\n", dinfo->megabytes);
 
 	/*
 	 * The type of error detection actually depends of the
@@ -653,9 +653,9 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	dimm->mtype = MEM_FB_DDR2;
 	if (IS_SINGLE_MODE(pvt->mc_settings_a)) {
 		dimm->edac_mode = EDAC_SECDED;
-		debugf2("\t\tECC code is 8-byte-over-32-byte SECDED+ code\n");
+		edac_dbg(2, "\t\tECC code is 8-byte-over-32-byte SECDED+ code\n");
 	} else {
-		debugf2("\t\tECC code is on Lockstep mode\n");
+		edac_dbg(2, "\t\tECC code is on Lockstep mode\n");
 		if (MTR_DRAM_WIDTH(mtr) == 8)
 			dimm->edac_mode = EDAC_S8ECD8ED;
 		else
@@ -664,9 +664,9 @@ static int decode_mtr(struct i7300_pvt *pvt,
 
 	/* ask what device type on this row */
 	if (MTR_DRAM_WIDTH(mtr) == 8) {
-		debugf2("\t\tScrub algorithm for x8 is on %s mode\n",
-			IS_SCRBALGO_ENHANCED(pvt->mc_settings) ?
-					    "enhanced" : "normal");
+		edac_dbg(2, "\t\tScrub algorithm for x8 is on %s mode\n",
+			 IS_SCRBALGO_ENHANCED(pvt->mc_settings) ?
+			 "enhanced" : "normal");
 
 		dimm->dtype = DEV_X8;
 	} else
@@ -700,14 +700,14 @@ static void print_dimm_size(struct i7300_pvt *pvt)
 		p += n;
 		space -= n;
 	}
-	debugf2("%s\n", pvt->tmp_prt_buffer);
+	edac_dbg(2, "%s\n", pvt->tmp_prt_buffer);
 	p = pvt->tmp_prt_buffer;
 	space = PAGE_SIZE;
 	n = snprintf(p, space, "-------------------------------"
 			       "------------------------------");
 	p += n;
 	space -= n;
-	debugf2("%s\n", pvt->tmp_prt_buffer);
+	edac_dbg(2, "%s\n", pvt->tmp_prt_buffer);
 	p = pvt->tmp_prt_buffer;
 	space = PAGE_SIZE;
 
@@ -723,7 +723,7 @@ static void print_dimm_size(struct i7300_pvt *pvt)
 			space -= n;
 		}
 
-		debugf2("%s\n", pvt->tmp_prt_buffer);
+		edac_dbg(2, "%s\n", pvt->tmp_prt_buffer);
 		p = pvt->tmp_prt_buffer;
 		space = PAGE_SIZE;
 	}
@@ -732,7 +732,7 @@ static void print_dimm_size(struct i7300_pvt *pvt)
 			       "------------------------------");
 	p += n;
 	space -= n;
-	debugf2("%s\n", pvt->tmp_prt_buffer);
+	edac_dbg(2, "%s\n", pvt->tmp_prt_buffer);
 	p = pvt->tmp_prt_buffer;
 	space = PAGE_SIZE;
 #endif
@@ -755,7 +755,7 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 
 	pvt = mci->pvt_info;
 
-	debugf2("Memory Technology Registers:\n");
+	edac_dbg(2, "Memory Technology Registers:\n");
 
 	/* Get the AMB present registers for the four channels */
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
@@ -764,15 +764,15 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 		pci_read_config_word(pvt->pci_dev_2x_0_fbd_branch[branch],
 				     AMBPRESENT_0,
 				&pvt->ambpresent[channel]);
-		debugf2("\t\tAMB-present CH%d = 0x%x:\n",
-			channel, pvt->ambpresent[channel]);
+		edac_dbg(2, "\t\tAMB-present CH%d = 0x%x:\n",
+			 channel, pvt->ambpresent[channel]);
 
 		channel = to_channel(1, branch);
 		pci_read_config_word(pvt->pci_dev_2x_0_fbd_branch[branch],
 				     AMBPRESENT_1,
 				&pvt->ambpresent[channel]);
-		debugf2("\t\tAMB-present CH%d = 0x%x:\n",
-			channel, pvt->ambpresent[channel]);
+		edac_dbg(2, "\t\tAMB-present CH%d = 0x%x:\n",
+			 channel, pvt->ambpresent[channel]);
 	}
 
 	/* Get the set of MTR[0-7] regs by each branch */
@@ -814,12 +814,11 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 static void decode_mir(int mir_no, u16 mir[MAX_MIR])
 {
 	if (mir[mir_no] & 3)
-		debugf2("MIR%d: limit= 0x%x Branch(es) that participate:"
-			" %s %s\n",
-			mir_no,
-			(mir[mir_no] >> 4) & 0xfff,
-			(mir[mir_no] & 1) ? "B0" : "",
-			(mir[mir_no] & 2) ? "B1" : "");
+		edac_dbg(2, "MIR%d: limit= 0x%x Branch(es) that participate: %s %s\n",
+			 mir_no,
+			 (mir[mir_no] >> 4) & 0xfff,
+			 (mir[mir_no] & 1) ? "B0" : "",
+			 (mir[mir_no] & 2) ? "B1" : "");
 }
 
 /**
@@ -839,17 +838,17 @@ static int i7300_get_mc_regs(struct mem_ctl_info *mci)
 	pci_read_config_dword(pvt->pci_dev_16_0_fsb_ctlr, AMBASE,
 			(u32 *) &pvt->ambase);
 
-	debugf2("AMBASE= 0x%lx\n", (long unsigned int)pvt->ambase);
+	edac_dbg(2, "AMBASE= 0x%lx\n", (long unsigned int)pvt->ambase);
 
 	/* Get the Branch Map regs */
 	pci_read_config_word(pvt->pci_dev_16_1_fsb_addr_map, TOLM, &pvt->tolm);
 	pvt->tolm >>= 12;
-	debugf2("TOLM (number of 256M regions) =%u (0x%x)\n", pvt->tolm,
-		pvt->tolm);
+	edac_dbg(2, "TOLM (number of 256M regions) =%u (0x%x)\n",
+		 pvt->tolm, pvt->tolm);
 
 	actual_tolm = (u32) ((1000l * pvt->tolm) >> (30 - 28));
-	debugf2("Actual TOLM byte addr=%u.%03u GB (0x%x)\n",
-		actual_tolm/1000, actual_tolm % 1000, pvt->tolm << 28);
+	edac_dbg(2, "Actual TOLM byte addr=%u.%03u GB (0x%x)\n",
+		 actual_tolm/1000, actual_tolm % 1000, pvt->tolm << 28);
 
 	/* Get memory controller settings */
 	pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map, MC_SETTINGS,
@@ -858,15 +857,15 @@ static int i7300_get_mc_regs(struct mem_ctl_info *mci)
 			     &pvt->mc_settings_a);
 
 	if (IS_SINGLE_MODE(pvt->mc_settings_a))
-		debugf0("Memory controller operating on single mode\n");
+		edac_dbg(0, "Memory controller operating on single mode\n");
 	else
-		debugf0("Memory controller operating on %s mode\n",
-		IS_MIRRORED(pvt->mc_settings) ? "mirrored" : "non-mirrored");
+		edac_dbg(0, "Memory controller operating on %smirrored mode\n",
+			 IS_MIRRORED(pvt->mc_settings) ? "" : "non-");
 
-	debugf0("Error detection is %s\n",
-		IS_ECC_ENABLED(pvt->mc_settings) ? "enabled" : "disabled");
-	debugf0("Retry is %s\n",
-		IS_RETRY_ENABLED(pvt->mc_settings) ? "enabled" : "disabled");
+	edac_dbg(0, "Error detection is %s\n",
+		 IS_ECC_ENABLED(pvt->mc_settings) ? "enabled" : "disabled");
+	edac_dbg(0, "Retry is %s\n",
+		 IS_RETRY_ENABLED(pvt->mc_settings) ? "enabled" : "disabled");
 
 	/* Get Memory Interleave Range registers */
 	pci_read_config_word(pvt->pci_dev_16_1_fsb_addr_map, MIR0,
@@ -960,18 +959,18 @@ static int __devinit i7300_get_devices(struct mem_ctl_info *mci)
 		}
 	}
 
-	debugf1("System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->pci_dev_16_0_fsb_ctlr),
-		pvt->pci_dev_16_0_fsb_ctlr->vendor,
-		pvt->pci_dev_16_0_fsb_ctlr->device);
-	debugf1("Branchmap, control and errors - PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->pci_dev_16_1_fsb_addr_map),
-		pvt->pci_dev_16_1_fsb_addr_map->vendor,
-		pvt->pci_dev_16_1_fsb_addr_map->device);
-	debugf1("FSB Error Regs - PCI Bus ID: %s  %x:%x\n",
-		pci_name(pvt->pci_dev_16_2_fsb_err_regs),
-		pvt->pci_dev_16_2_fsb_err_regs->vendor,
-		pvt->pci_dev_16_2_fsb_err_regs->device);
+	edac_dbg(1, "System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->pci_dev_16_0_fsb_ctlr),
+		 pvt->pci_dev_16_0_fsb_ctlr->vendor,
+		 pvt->pci_dev_16_0_fsb_ctlr->device);
+	edac_dbg(1, "Branchmap, control and errors - PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->pci_dev_16_1_fsb_addr_map),
+		 pvt->pci_dev_16_1_fsb_addr_map->vendor,
+		 pvt->pci_dev_16_1_fsb_addr_map->device);
+	edac_dbg(1, "FSB Error Regs - PCI Bus ID: %s  %x:%x\n",
+		 pci_name(pvt->pci_dev_16_2_fsb_err_regs),
+		 pvt->pci_dev_16_2_fsb_err_regs->vendor,
+		 pvt->pci_dev_16_2_fsb_err_regs->device);
 
 	pvt->pci_dev_2x_0_fbd_branch[0] = pci_get_device(PCI_VENDOR_ID_INTEL,
 					    PCI_DEVICE_ID_INTEL_I7300_MCH_FB0,
@@ -1022,9 +1021,9 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	if (rc == -EIO)
 		return rc;
 
-	debugf0("MC: pdev bus %u dev=0x%x fn=0x%x\n",
-		pdev->bus->number,
-		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+	edac_dbg(0, "MC: pdev bus %u dev=0x%x fn=0x%x\n",
+		 pdev->bus->number,
+		 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/* We only are looking for func 0 of the set */
 	if (PCI_FUNC(pdev->devfn) != 0)
@@ -1044,7 +1043,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: mci = %p\n", mci);
+	edac_dbg(0, "MC: mci = %p\n", mci);
 
 	mci->pdev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1077,18 +1076,16 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	/* initialize the MC control structure 'csrows' table
 	 * with the mapping and control information */
 	if (i7300_get_mc_regs(mci)) {
-		debugf0("MC: Setting mci->edac_cap to EDAC_FLAG_NONE\n"
-			"    because i7300_init_csrows() returned nonzero "
-			"value\n");
+		edac_dbg(0, "MC: Setting mci->edac_cap to EDAC_FLAG_NONE because i7300_init_csrows() returned nonzero value\n");
 		mci->edac_cap = EDAC_FLAG_NONE;	/* no csrows found */
 	} else {
-		debugf1("MC: Enable error reporting now\n");
+		edac_dbg(1, "MC: Enable error reporting now\n");
 		i7300_enable_error_reporting(mci);
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: failed edac_mc_add_mc()\n");
+		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1130,7 +1127,7 @@ static void __devexit i7300_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	char *tmp;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (i7300_pci)
 		edac_pci_release_generic_ctl(i7300_pci);
@@ -1177,7 +1174,7 @@ static int __init i7300_init(void)
 {
 	int pci_rc;
 
-	debugf2("\n");
+	edac_dbg(2, "\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1192,7 +1189,7 @@ static int __init i7300_init(void)
  */
 static void __exit i7300_exit(void)
 {
-	debugf2("\n");
+	edac_dbg(2, "\n");
 	pci_unregister_driver(&i7300_driver);
 }
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index f851a43..0899d7d 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -516,29 +516,28 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	pci_read_config_dword(pdev, MC_MAX_DOD, &pvt->info.max_dod);
 	pci_read_config_dword(pdev, MC_CHANNEL_MAPPER, &pvt->info.ch_map);
 
-	debugf0("QPI %d control=0x%08x status=0x%08x dod=0x%08x map=0x%08x\n",
-		pvt->i7core_dev->socket, pvt->info.mc_control, pvt->info.mc_status,
-		pvt->info.max_dod, pvt->info.ch_map);
+	edac_dbg(0, "QPI %d control=0x%08x status=0x%08x dod=0x%08x map=0x%08x\n",
+		 pvt->i7core_dev->socket, pvt->info.mc_control,
+		 pvt->info.mc_status, pvt->info.max_dod, pvt->info.ch_map);
 
 	if (ECC_ENABLED(pvt)) {
-		debugf0("ECC enabled with x%d SDCC\n", ECCx8(pvt) ? 8 : 4);
+		edac_dbg(0, "ECC enabled with x%d SDCC\n", ECCx8(pvt) ? 8 : 4);
 		if (ECCx8(pvt))
 			mode = EDAC_S8ECD8ED;
 		else
 			mode = EDAC_S4ECD4ED;
 	} else {
-		debugf0("ECC disabled\n");
+		edac_dbg(0, "ECC disabled\n");
 		mode = EDAC_NONE;
 	}
 
 	/* FIXME: need to handle the error codes */
-	debugf0("DOD Max limits: DIMMS: %d, %d-ranked, %d-banked "
-		"x%x x 0x%x\n",
-		numdimms(pvt->info.max_dod),
-		numrank(pvt->info.max_dod >> 2),
-		numbank(pvt->info.max_dod >> 4),
-		numrow(pvt->info.max_dod >> 6),
-		numcol(pvt->info.max_dod >> 9));
+	edac_dbg(0, "DOD Max limits: DIMMS: %d, %d-ranked, %d-banked x%x x 0x%x\n",
+		 numdimms(pvt->info.max_dod),
+		 numrank(pvt->info.max_dod >> 2),
+		 numbank(pvt->info.max_dod >> 4),
+		 numrow(pvt->info.max_dod >> 6),
+		 numcol(pvt->info.max_dod >> 9));
 
 	for (i = 0; i < NUM_CHANS; i++) {
 		u32 data, dimm_dod[3], value[8];
@@ -547,11 +546,11 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			continue;
 
 		if (!CH_ACTIVE(pvt, i)) {
-			debugf0("Channel %i is not active\n", i);
+			edac_dbg(0, "Channel %i is not active\n", i);
 			continue;
 		}
 		if (CH_DISABLED(pvt, i)) {
-			debugf0("Channel %i is disabled\n", i);
+			edac_dbg(0, "Channel %i is disabled\n", i);
 			continue;
 		}
 
@@ -582,15 +581,14 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		pci_read_config_dword(pvt->pci_ch[i][1],
 				MC_DOD_CH_DIMM2, &dimm_dod[2]);
 
-		debugf0("Ch%d phy rd%d, wr%d (0x%08x): "
-			"%s%s%s%cDIMMs\n",
-			i,
-			RDLCH(pvt->info.ch_map, i), WRLCH(pvt->info.ch_map, i),
-			data,
-			pvt->channel[i].is_3dimms_present ? "3DIMMS " : "",
-			pvt->channel[i].is_3dimms_present ? "SINGLE_4R " : "",
-			pvt->channel[i].has_4rank ? "HAS_4R " : "",
-			(data & REGISTERED_DIMM) ? 'R' : 'U');
+		edac_dbg(0, "Ch%d phy rd%d, wr%d (0x%08x): %s%s%s%cDIMMs\n",
+			 i,
+			 RDLCH(pvt->info.ch_map, i), WRLCH(pvt->info.ch_map, i),
+			 data,
+			 pvt->channel[i].is_3dimms_present ? "3DIMMS " : "",
+			 pvt->channel[i].is_3dimms_present ? "SINGLE_4R " : "",
+			 pvt->channel[i].has_4rank ? "HAS_4R " : "",
+			 (data & REGISTERED_DIMM) ? 'R' : 'U');
 
 		for (j = 0; j < 3; j++) {
 			u32 banks, ranks, rows, cols;
@@ -609,11 +607,10 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			/* DDR3 has 8 I/O banks */
 			size = (rows * cols * banks * ranks) >> (20 - 3);
 
-			debugf0("\tdimm %d %d Mb offset: %x, "
-				"bank: %d, rank: %d, row: %#x, col: %#x\n",
-				j, size,
-				RANKOFFSET(dimm_dod[j]),
-				banks, ranks, rows, cols);
+			edac_dbg(0, "\tdimm %d %d Mb offset: %x, bank: %d, rank: %d, row: %#x, col: %#x\n",
+				 j, size,
+				 RANKOFFSET(dimm_dod[j]),
+				 banks, ranks, rows, cols);
 
 			npages = MiB_TO_PAGES(size);
 
@@ -649,12 +646,12 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		pci_read_config_dword(pdev, MC_SAG_CH_5, &value[5]);
 		pci_read_config_dword(pdev, MC_SAG_CH_6, &value[6]);
 		pci_read_config_dword(pdev, MC_SAG_CH_7, &value[7]);
-		debugf1("\t[%i] DIVBY3\tREMOVED\tOFFSET\n", i);
+		edac_dbg(1, "\t[%i] DIVBY3\tREMOVED\tOFFSET\n", i);
 		for (j = 0; j < 8; j++)
-			debugf1("\t\t%#x\t%#x\t%#x\n",
-				(value[j] >> 27) & 0x1,
-				(value[j] >> 24) & 0x7,
-				(value[j] & ((1 << 24) - 1)));
+			edac_dbg(1, "\t\t%#x\t%#x\t%#x\n",
+				 (value[j] >> 27) & 0x1,
+				 (value[j] >> 24) & 0x7,
+				 (value[j] & ((1 << 24) - 1)));
 	}
 
 	return 0;
@@ -824,7 +821,7 @@ static ssize_t i7core_inject_store_##param(			\
 	long value;						\
 	int rc;							\
 								\
-	debugf1("\n");				\
+	edac_dbg(1, "\n");					\
 	pvt = mci->pvt_info;					\
 								\
 	if (pvt->inject.enable)					\
@@ -852,7 +849,7 @@ static ssize_t i7core_inject_show_##param(			\
 	struct i7core_pvt *pvt;					\
 								\
 	pvt = mci->pvt_info;					\
-	debugf1("pvt=%p\n", pvt);		\
+	edac_dbg(1, "pvt=%p\n", pvt);				\
 	if (pvt->inject.param < 0)				\
 		return sprintf(data, "any\n");			\
 	else							\
@@ -883,9 +880,9 @@ static int write_and_test(struct pci_dev *dev, const int where, const u32 val)
 	u32 read;
 	int count;
 
-	debugf0("setting pci %02x:%02x.%x reg=%02x value=%08x\n",
-		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn),
-		where, val);
+	edac_dbg(0, "setting pci %02x:%02x.%x reg=%02x value=%08x\n",
+		 dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn),
+		 where, val);
 
 	for (count = 0; count < 10; count++) {
 		if (count)
@@ -1020,9 +1017,8 @@ static ssize_t i7core_inject_enable_store(struct device *dev,
 	pci_write_config_dword(pvt->pci_noncore,
 			       MC_CFG_CONTROL, 8);
 
-	debugf0("Error inject addr match 0x%016llx, ecc 0x%08x,"
-		" inject 0x%08x\n",
-		mask, pvt->inject.eccmask, injectmask);
+	edac_dbg(0, "Error inject addr match 0x%016llx, ecc 0x%08x, inject 0x%08x\n",
+		 mask, pvt->inject.eccmask, injectmask);
 
 
 	return count;
@@ -1042,7 +1038,7 @@ static ssize_t i7core_inject_enable_show(struct device *dev,
 	pci_read_config_dword(pvt->pci_ch[pvt->inject.channel][0],
 			       MC_CHANNEL_ERROR_INJECT, &injectmask);
 
-	debugf0("Inject error read: 0x%018x\n", injectmask);
+	edac_dbg(0, "Inject error read: 0x%018x\n", injectmask);
 
 	if (injectmask & 0x0c)
 		pvt->inject.enable = 1;
@@ -1059,7 +1055,7 @@ static ssize_t i7core_show_counter_##param(			\
 	struct mem_ctl_info *mci = to_mci(dev);			\
 	struct i7core_pvt *pvt = mci->pvt_info;			\
 								\
-	debugf1("\n");				\
+	edac_dbg(1, "\n");					\
 	if (!pvt->ce_count_available || (pvt->is_registered))	\
 		return sprintf(data, "data unavailable\n");	\
 	return sprintf(data, "%lu\n",				\
@@ -1104,7 +1100,7 @@ static const struct attribute_group *addrmatch_groups[] = {
 
 static void addrmatch_release(struct device *device)
 {
-	debugf1("Releasing device %s\n", dev_name(device));
+	edac_dbg(1, "Releasing device %s\n", dev_name(device));
 	kfree(device);
 }
 
@@ -1135,7 +1131,7 @@ static const struct attribute_group *all_channel_counts_groups[] = {
 
 static void all_channel_counts_release(struct device *device)
 {
-	debugf1("Releasing device %s\n", dev_name(device));
+	edac_dbg(1, "Releasing device %s\n", dev_name(device));
 	kfree(device);
 }
 
@@ -1190,7 +1186,7 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 	dev_set_name(pvt->addrmatch_dev, "inject_addrmatch");
 	dev_set_drvdata(pvt->addrmatch_dev, mci);
 
-	debugf1("creating %s\n", dev_name(pvt->addrmatch_dev));
+	edac_dbg(1, "creating %s\n", dev_name(pvt->addrmatch_dev));
 
 	rc = device_add(pvt->addrmatch_dev);
 	if (rc < 0)
@@ -1212,7 +1208,7 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 		dev_set_name(pvt->chancounts_dev, "all_channel_counts");
 		dev_set_drvdata(pvt->chancounts_dev, mci);
 
-		debugf1("creating %s\n", dev_name(pvt->chancounts_dev));
+		edac_dbg(1, "creating %s\n", dev_name(pvt->chancounts_dev));
 
 		rc = device_add(pvt->chancounts_dev);
 		if (rc < 0)
@@ -1225,7 +1221,7 @@ static void i7core_delete_sysfs_devices(struct mem_ctl_info *mci)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
 
-	debugf1("\n");
+	edac_dbg(1, "\n");
 
 	device_remove_file(&mci->dev, &dev_attr_inject_section);
 	device_remove_file(&mci->dev, &dev_attr_inject_type);
@@ -1252,14 +1248,14 @@ static void i7core_put_devices(struct i7core_dev *i7core_dev)
 {
 	int i;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 	for (i = 0; i < i7core_dev->n_devs; i++) {
 		struct pci_dev *pdev = i7core_dev->pdev[i];
 		if (!pdev)
 			continue;
-		debugf0("Removing dev %02x:%02x.%d\n",
-			pdev->bus->number,
-			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+		edac_dbg(0, "Removing dev %02x:%02x.%d\n",
+			 pdev->bus->number,
+			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 		pci_dev_put(pdev);
 	}
 }
@@ -1302,12 +1298,12 @@ static unsigned i7core_pci_lastbus(void)
 
 	while ((b = pci_find_next_bus(b)) != NULL) {
 		bus = b->number;
-		debugf0("Found bus %d\n", bus);
+		edac_dbg(0, "Found bus %d\n", bus);
 		if (bus > last_bus)
 			last_bus = bus;
 	}
 
-	debugf0("Last bus %d\n", last_bus);
+	edac_dbg(0, "Last bus %d\n", last_bus);
 
 	return last_bus;
 }
@@ -1414,10 +1410,10 @@ static int i7core_get_onedevice(struct pci_dev **prev,
 		return -ENODEV;
 	}
 
-	debugf0("Detected socket %d dev %02x:%02x.%d PCI ID %04x:%04x\n",
-		socket, bus, dev_descr->dev,
-		dev_descr->func,
-		PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
+	edac_dbg(0, "Detected socket %d dev %02x:%02x.%d PCI ID %04x:%04x\n",
+		 socket, bus, dev_descr->dev,
+		 dev_descr->func,
+		 PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
 
 	/*
 	 * As stated on drivers/pci/search.c, the reference count for
@@ -1515,13 +1511,13 @@ static int mci_bind_devs(struct mem_ctl_info *mci,
 				family = "unknown";
 				pvt->enable_scrub = false;
 			}
-			debugf0("Detected a processor type %s\n", family);
+			edac_dbg(0, "Detected a processor type %s\n", family);
 		} else
 			goto error;
 
-		debugf0("Associated fn %d.%d, dev = %p, socket %d\n",
-			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
-			pdev, i7core_dev->socket);
+		edac_dbg(0, "Associated fn %d.%d, dev = %p, socket %d\n",
+			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
+			 pdev, i7core_dev->socket);
 
 		if (PCI_SLOT(pdev->devfn) == 3 &&
 			PCI_FUNC(pdev->devfn) == 2)
@@ -1618,8 +1614,8 @@ static void i7core_rdimm_check_mc_ecc_err(struct mem_ctl_info *mci)
 	pci_read_config_dword(pvt->pci_mcr[2], MC_COR_ECC_CNT_5,
 								&rcv[2][1]);
 	for (i = 0 ; i < 3; i++) {
-		debugf3("MC_COR_ECC_CNT%d = 0x%x; MC_COR_ECC_CNT%d = 0x%x\n",
-			(i * 2), rcv[i][0], (i * 2) + 1, rcv[i][1]);
+		edac_dbg(3, "MC_COR_ECC_CNT%d = 0x%x; MC_COR_ECC_CNT%d = 0x%x\n",
+			 (i * 2), rcv[i][0], (i * 2) + 1, rcv[i][1]);
 		/*if the channel has 3 dimms*/
 		if (pvt->channel[i].dimms > 2) {
 			new0 = DIMM_BOT_COR_ERR(rcv[i][0]);
@@ -1650,7 +1646,7 @@ static void i7core_udimm_check_mc_ecc_err(struct mem_ctl_info *mci)
 	int new0, new1, new2;
 
 	if (!pvt->pci_mcr[4]) {
-		debugf0("MCR registers not found\n");
+		edac_dbg(0, "MCR registers not found\n");
 		return;
 	}
 
@@ -2188,7 +2184,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	struct i7core_pvt *pvt;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
-		debugf0("MC: dev = %p\n", &i7core_dev->pdev[0]->dev);
+		edac_dbg(0, "MC: dev = %p\n", &i7core_dev->pdev[0]->dev);
 
 		i7core_printk(KERN_ERR, "Couldn't find mci handler\n");
 		return;
@@ -2196,7 +2192,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 
 	pvt = mci->pvt_info;
 
-	debugf0("MC: mci = %p, dev = %p\n", mci, &i7core_dev->pdev[0]->dev);
+	edac_dbg(0, "MC: mci = %p, dev = %p\n", mci, &i7core_dev->pdev[0]->dev);
 
 	/* Disable scrubrate setting */
 	if (pvt->enable_scrub)
@@ -2211,7 +2207,7 @@ static void i7core_unregister_mci(struct i7core_dev *i7core_dev)
 	i7core_delete_sysfs_devices(mci);
 	edac_mc_del_mc(mci->pdev);
 
-	debugf1("%s: free mci struct\n", mci->ctl_name);
+	edac_dbg(1, "%s: free mci struct\n", mci->ctl_name);
 	kfree(mci->ctl_name);
 	edac_mc_free(mci);
 	i7core_dev->mci = NULL;
@@ -2237,7 +2233,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 	if (unlikely(!mci))
 		return -ENOMEM;
 
-	debugf0("MC: mci = %p, dev = %p\n", mci, &i7core_dev->pdev[0]->dev);
+	edac_dbg(0, "MC: mci = %p, dev = %p\n", mci, &i7core_dev->pdev[0]->dev);
 
 	pvt = mci->pvt_info;
 	memset(pvt, 0, sizeof(*pvt));
@@ -2280,7 +2276,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
-		debugf0("MC: failed edac_mc_add_mc()\n");
+		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -2289,7 +2285,7 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev)
 		goto fail0;
 	}
 	if (i7core_create_sysfs_devices(mci)) {
-		debugf0("MC: failed to create sysfs nodes\n");
+		edac_dbg(0, "MC: failed to create sysfs nodes\n");
 		edac_mc_del_mc(mci->pdev);
 		rc = -EINVAL;
 		goto fail0;
@@ -2395,7 +2391,7 @@ static void __devexit i7core_remove(struct pci_dev *pdev)
 {
 	struct i7core_dev *i7core_dev;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/*
 	 * we have a trouble here: pdev value for removal will be wrong, since
@@ -2444,7 +2440,7 @@ static int __init i7core_init(void)
 {
 	int pci_rc;
 
-	debugf2("\n");
+	edac_dbg(2, "\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -2469,7 +2465,7 @@ static int __init i7core_init(void)
  */
 static void __exit i7core_exit(void)
 {
-	debugf2("\n");
+	edac_dbg(2, "\n");
 	pci_unregister_driver(&i7core_driver);
 }
 
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index c43214f..475bde1 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -178,7 +178,7 @@ static void i82443bxgx_edacmc_check(struct mem_ctl_info *mci)
 {
 	struct i82443bxgx_edacmc_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	i82443bxgx_edacmc_get_error_info(mci, &info);
 	i82443bxgx_edacmc_process_error_info(mci, &info, 1);
 }
@@ -201,14 +201,13 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 		dimm = csrow->channels[0]->dimm;
 
 		pci_read_config_byte(pdev, I82443BXGX_DRB + index, &drbar);
-		debugf1("MC%d: Row=%d DRB = %#0x\n",
-			mci->mc_idx,index, drbar);
+		edac_dbg(1, "MC%d: Row=%d DRB = %#0x\n",
+			 mci->mc_idx, index, drbar);
 		row_high_limit = ((u32) drbar << 23);
 		/* find the DRAM Chip Select Base address and mask */
-		debugf1("MC%d: Row=%d, "
-			"Boundary Address=%#0x, Last = %#0x\n",
-			mci->mc_idx, index, row_high_limit,
-			row_high_limit_last);
+		edac_dbg(1, "MC%d: Row=%d, Boundary Address=%#0x, Last = %#0x\n",
+			 mci->mc_idx, index, row_high_limit,
+			 row_high_limit_last);
 
 		/* 440GX goes to 2GB, represented with a DRB of 0. */
 		if (row_high_limit_last && !row_high_limit)
@@ -241,7 +240,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	enum mem_type mtype;
 	enum edac_type edac_mode;
 
-	debugf0("MC: %s()\n", __FILE__);
+	edac_dbg(0, "MC:\n");
 
 	/* Something is really hosed if PCI config space reads from
 	 * the MC aren't working.
@@ -259,7 +258,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: %s(): mci = %p\n", __FILE__, mci);
+	edac_dbg(0, "MC: mci = %p\n", mci);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_EDO | MEM_FLAG_SDR | MEM_FLAG_RDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -275,8 +274,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 		mtype = MEM_RDR;
 		break;
 	default:
-		debugf0("Unknown/reserved DRAM type value "
-			"in DRAMC register!\n");
+		edac_dbg(0, "Unknown/reserved DRAM type value in DRAMC register!\n");
 		mtype = -MEM_UNKNOWN;
 	}
 
@@ -305,8 +303,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 		edac_mode = EDAC_SECDED;
 		break;
 	default:
-		debugf0("Unknown/reserved ECC state "
-			"in NBXCFG register!\n");
+		edac_dbg(0, "Unknown/reserved ECC state in NBXCFG register!\n");
 		edac_mode = EDAC_UNKNOWN;
 		break;
 	}
@@ -330,7 +327,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->ctl_page_to_phys = NULL;
 
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -345,7 +342,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 			__func__);
 	}
 
-	debugf3("MC: %s(): success\n", __FILE__);
+	edac_dbg(3, "MC: success\n");
 	return 0;
 
 fail:
@@ -361,7 +358,7 @@ static int __devinit i82443bxgx_edacmc_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC: %s()\n", __FILE__);
+	edac_dbg(0, "MC:\n");
 
 	/* don't need to call pci_enable_device() */
 	rc = i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
@@ -376,7 +373,7 @@ static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("%s()\n", __FILE__);
+	edac_dbg(0, "\n");
 
 	if (i82443bxgx_pci)
 		edac_pci_release_generic_ctl(i82443bxgx_pci);
@@ -428,7 +425,7 @@ static int __init i82443bxgx_edacmc_init(void)
 			id = &i82443bxgx_pci_tbl[i];
 		}
 		if (!mci_pdev) {
-			debugf0("i82443bxgx pci_get_device fail\n");
+			edac_dbg(0, "i82443bxgx pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -436,7 +433,7 @@ static int __init i82443bxgx_edacmc_init(void)
 		pci_rc = i82443bxgx_edacmc_init_one(mci_pdev, i82443bxgx_pci_tbl);
 
 		if (pci_rc < 0) {
-			debugf0("i82443bxgx init fail\n");
+			edac_dbg(0, "i82443bxgx init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index d4ec21d..832e7dd 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -136,7 +136,7 @@ static void i82860_check(struct mem_ctl_info *mci)
 {
 	struct i82860_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	i82860_get_error_info(mci, &info);
 	i82860_process_error_info(mci, &info, 1);
 }
@@ -167,8 +167,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 		pci_read_config_word(pdev, I82860_GBA + index * 2, &value);
 		cumul_size = (value & I82860_GBA_MASK) <<
 			(I82860_GBA_SHIFT - PAGE_SHIFT);
-		debugf3("(%d) cumul_size 0x%x\n", index,
-			cumul_size);
+		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);
 
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
@@ -210,7 +209,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -229,7 +228,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
@@ -245,7 +244,7 @@ static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 
 	return 0;
 
@@ -260,7 +259,7 @@ static int __devinit i82860_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 	i82860_printk(KERN_INFO, "i82860 init one\n");
 
 	if (pci_enable_device(pdev) < 0)
@@ -278,7 +277,7 @@ static void __devexit i82860_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (i82860_pci)
 		edac_pci_release_generic_ctl(i82860_pci);
@@ -311,7 +310,7 @@ static int __init i82860_init(void)
 {
 	int pci_rc;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -324,7 +323,7 @@ static int __init i82860_init(void)
 					PCI_DEVICE_ID_INTEL_82860_0, NULL);
 
 		if (mci_pdev == NULL) {
-			debugf0("860 pci_get_device fail\n");
+			edac_dbg(0, "860 pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -332,7 +331,7 @@ static int __init i82860_init(void)
 		pci_rc = i82860_init_one(mci_pdev, i82860_pci_tbl);
 
 		if (pci_rc < 0) {
-			debugf0("860 init fail\n");
+			edac_dbg(0, "860 init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -352,7 +351,7 @@ fail0:
 
 static void __exit i82860_exit(void)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	pci_unregister_driver(&i82860_driver);
 
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 20b40a76..ae15359 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -263,7 +263,7 @@ static void i82875p_check(struct mem_ctl_info *mci)
 {
 	struct i82875p_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	i82875p_get_error_info(mci, &info);
 	i82875p_process_error_info(mci, &info, 1);
 }
@@ -371,8 +371,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 
 		value = readb(ovrfl_window + I82875P_DRB + index);
 		cumul_size = value << (I82875P_DRB_SHIFT - PAGE_SHIFT);
-		debugf3("(%d) cumul_size 0x%x\n", index,
-			cumul_size);
+		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);
 		if (cumul_size == last_cumul_size)
 			continue;	/* not populated */
 
@@ -405,7 +404,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 nr_chans;
 	struct i82875p_error_info discard;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	ovrfl_pdev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
 
@@ -425,7 +424,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail0;
 	}
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -436,7 +435,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82875p_check;
 	mci->ctl_page_to_phys = NULL;
-	debugf3("init pvt\n");
+	edac_dbg(3, "init pvt\n");
 	pvt = (struct i82875p_pvt *)mci->pvt_info;
 	pvt->ovrfl_pdev = ovrfl_pdev;
 	pvt->ovrfl_window = ovrfl_window;
@@ -447,7 +446,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail1;
 	}
 
@@ -463,7 +462,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	return 0;
 
 fail1:
@@ -484,7 +483,7 @@ static int __devinit i82875p_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 	i82875p_printk(KERN_INFO, "i82875p init one\n");
 
 	if (pci_enable_device(pdev) < 0)
@@ -503,7 +502,7 @@ static void __devexit i82875p_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct i82875p_pvt *pvt = NULL;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (i82875p_pci)
 		edac_pci_release_generic_ctl(i82875p_pci);
@@ -549,7 +548,7 @@ static int __init i82875p_init(void)
 {
 	int pci_rc;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -564,7 +563,7 @@ static int __init i82875p_init(void)
 					PCI_DEVICE_ID_INTEL_82875_0, NULL);
 
 		if (!mci_pdev) {
-			debugf0("875p pci_get_device fail\n");
+			edac_dbg(0, "875p pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -572,7 +571,7 @@ static int __init i82875p_init(void)
 		pci_rc = i82875p_init_one(mci_pdev, i82875p_pci_tbl);
 
 		if (pci_rc < 0) {
-			debugf0("875p init fail\n");
+			edac_dbg(0, "875p init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -592,7 +591,7 @@ fail0:
 
 static void __exit i82875p_exit(void)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	i82875p_remove_one(mci_pdev);
 	pci_dev_put(mci_pdev);
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 91b9e33..974d1a2 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -331,7 +331,7 @@ static void i82975x_check(struct mem_ctl_info *mci)
 {
 	struct i82975x_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	i82975x_get_error_info(mci, &info);
 	i82975x_process_error_info(mci, &info, 1);
 }
@@ -406,8 +406,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		 */
 		if (csrow->nr_channels > 1)
 			cumul_size <<= 1;
-		debugf3("(%d) cumul_size 0x%x\n", index,
-			cumul_size);
+		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);
 
 		nr_pages = cumul_size - last_cumul_size;
 		if (!nr_pages)
@@ -489,11 +488,11 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	u8 c1drb[4];
 #endif
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	pci_read_config_dword(pdev, I82975X_MCHBAR, &mchbar);
 	if (!(mchbar & 1)) {
-		debugf3("failed, MCHBAR disabled!\n");
+		edac_dbg(3, "failed, MCHBAR disabled!\n");
 		goto fail0;
 	}
 	mchbar &= 0xffffc000;	/* bits 31:14 used for 16K window */
@@ -558,7 +557,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 		goto fail1;
 	}
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -569,7 +568,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
-	debugf3("init pvt\n");
+	edac_dbg(3, "init pvt\n");
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->mch_window = mch_window;
 	i82975x_init_csrows(mci, pdev, mch_window);
@@ -578,12 +577,12 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 
 	/* finalize this instance of memory controller with edac core */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail2;
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	return 0;
 
 fail2:
@@ -601,7 +600,7 @@ static int __devinit i82975x_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -619,7 +618,7 @@ static void __devexit i82975x_remove_one(struct pci_dev *pdev)
 	struct mem_ctl_info *mci;
 	struct i82975x_pvt *pvt;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (mci  == NULL)
@@ -655,7 +654,7 @@ static int __init i82975x_init(void)
 {
 	int pci_rc;
 
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -669,7 +668,7 @@ static int __init i82975x_init(void)
 				PCI_DEVICE_ID_INTEL_82975_0, NULL);
 
 		if (!mci_pdev) {
-			debugf0("i82975x pci_get_device fail\n");
+			edac_dbg(0, "i82975x pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -677,7 +676,7 @@ static int __init i82975x_init(void)
 		pci_rc = i82975x_init_one(mci_pdev, i82975x_pci_tbl);
 
 		if (pci_rc < 0) {
-			debugf0("i82975x init fail\n");
+			edac_dbg(0, "i82975x init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -697,7 +696,7 @@ fail0:
 
 static void __exit i82975x_exit(void)
 {
-	debugf3("\n");
+	edac_dbg(3, "\n");
 
 	pci_unregister_driver(&i82975x_driver);
 
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index e01c678..64b4765 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -280,7 +280,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, ~0);
 
 	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
-		debugf3("failed edac_pci_add_device()\n");
+		edac_dbg(3, "failed edac_pci_add_device()\n");
 		goto err;
 	}
 
@@ -303,7 +303,7 @@ static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 	}
 
 	devres_remove_group(&op->dev, mpc85xx_pci_err_probe);
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	printk(KERN_INFO EDAC_MOD_STR " PCI err registered\n");
 
 	return 0;
@@ -321,7 +321,7 @@ static int mpc85xx_pci_err_remove(struct platform_device *op)
 	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
 		 orig_pci_err_cap_dr);
@@ -582,7 +582,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 	pdata->edac_idx = edac_dev_idx++;
 
 	if (edac_device_add_device(edac_dev) > 0) {
-		debugf3("failed edac_device_add_device()\n");
+		edac_dbg(3, "failed edac_device_add_device()\n");
 		goto err;
 	}
 
@@ -610,7 +610,7 @@ static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 
 	devres_remove_group(&op->dev, mpc85xx_l2_err_probe);
 
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	printk(KERN_INFO EDAC_MOD_STR " L2 err registered\n");
 
 	return 0;
@@ -628,7 +628,7 @@ static int mpc85xx_l2_err_remove(struct platform_device *op)
 	struct edac_device_ctl_info *edac_dev = dev_get_drvdata(&op->dev);
 	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINTEN, 0);
@@ -1037,7 +1037,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 		goto err;
 	}
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_RDDR2 |
 	    MEM_FLAG_DDR | MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -1063,13 +1063,13 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, ~0);
 
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto err;
 	}
 
 	if (mpc85xx_create_sysfs_attributes(mci)) {
 		edac_mc_del_mc(mci->pdev);
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto err;
 	}
 
@@ -1103,7 +1103,7 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	}
 
 	devres_remove_group(&op->dev, mpc85xx_mc_err_probe);
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	printk(KERN_INFO EDAC_MOD_STR " MC err registered\n");
 
 	return 0;
@@ -1121,7 +1121,7 @@ static int mpc85xx_mc_err_remove(struct platform_device *op)
 	struct mem_ctl_info *mci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_INT_EN, 0);
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 25851ef..f54b3cb 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -169,7 +169,7 @@ static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 		 MV64X60_PCIx_ERR_MASK_VAL);
 
 	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
-		debugf3("failed edac_pci_add_device()\n");
+		edac_dbg(3, "failed edac_pci_add_device()\n");
 		goto err;
 	}
 
@@ -194,7 +194,7 @@ static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 	devres_remove_group(&pdev->dev, mv64x60_pci_err_probe);
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 
 	return 0;
 
@@ -210,7 +210,7 @@ static int mv64x60_pci_err_remove(struct platform_device *pdev)
 {
 	struct edac_pci_ctl_info *pci = platform_get_drvdata(pdev);
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	edac_pci_del_device(&pdev->dev);
 
@@ -336,7 +336,7 @@ static int __devinit mv64x60_sram_err_probe(struct platform_device *pdev)
 	pdata->edac_idx = edac_dev_idx++;
 
 	if (edac_device_add_device(edac_dev) > 0) {
-		debugf3("failed edac_device_add_device()\n");
+		edac_dbg(3, "failed edac_device_add_device()\n");
 		goto err;
 	}
 
@@ -363,7 +363,7 @@ static int __devinit mv64x60_sram_err_probe(struct platform_device *pdev)
 	devres_remove_group(&pdev->dev, mv64x60_sram_err_probe);
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 
 	return 0;
 
@@ -379,7 +379,7 @@ static int mv64x60_sram_err_remove(struct platform_device *pdev)
 {
 	struct edac_device_ctl_info *edac_dev = platform_get_drvdata(pdev);
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(edac_dev);
@@ -531,7 +531,7 @@ static int __devinit mv64x60_cpu_err_probe(struct platform_device *pdev)
 	pdata->edac_idx = edac_dev_idx++;
 
 	if (edac_device_add_device(edac_dev) > 0) {
-		debugf3("failed edac_device_add_device()\n");
+		edac_dbg(3, "failed edac_device_add_device()\n");
 		goto err;
 	}
 
@@ -558,7 +558,7 @@ static int __devinit mv64x60_cpu_err_probe(struct platform_device *pdev)
 	devres_remove_group(&pdev->dev, mv64x60_cpu_err_probe);
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 
 	return 0;
 
@@ -574,7 +574,7 @@ static int mv64x60_cpu_err_remove(struct platform_device *pdev)
 {
 	struct edac_device_ctl_info *edac_dev = platform_get_drvdata(pdev);
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(edac_dev);
@@ -766,7 +766,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	debugf3("init mci\n");
+	edac_dbg(3, "init mci\n");
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_SECDED;
@@ -790,7 +790,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ECC_CNTL, ctl);
 
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto err;
 	}
 
@@ -815,7 +815,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	}
 
 	/* get this far and it's successful */
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 
 	return 0;
 
@@ -831,7 +831,7 @@ static int mv64x60_mc_err_remove(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	edac_mc_del_mc(&pdev->dev);
 	edac_mc_free(mci);
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 872c3b9..b68e734 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -205,7 +205,7 @@ static void r82600_check(struct mem_ctl_info *mci)
 {
 	struct r82600_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	r82600_get_error_info(mci, &info);
 	r82600_process_error_info(mci, &info, 1);
 }
@@ -236,13 +236,13 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_byte(pdev, R82600_DRBA + index, &drbar);
 
-		debugf1("Row=%d DRBA = %#0x\n", index, drbar);
+		edac_dbg(1, "Row=%d DRBA = %#0x\n", index, drbar);
 
 		row_high_limit = ((u32) drbar << 24);
 /*		row_high_limit = ((u32)drbar << 24) | 0xffffffUL; */
 
-		debugf1("Row=%d, Boundary Address=%#0x, Last = %#0x\n",
-			index, row_high_limit, row_high_limit_last);
+		edac_dbg(1, "Row=%d, Boundary Address=%#0x, Last = %#0x\n",
+			 index, row_high_limit, row_high_limit_last);
 
 		/* Empty row [p.57] */
 		if (row_high_limit == row_high_limit_last)
@@ -277,13 +277,13 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 sdram_refresh_rate;
 	struct r82600_error_info discard;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 	pci_read_config_byte(pdev, R82600_DRAMC, &dramcr);
 	pci_read_config_dword(pdev, R82600_EAP, &eapr);
 	scrub_disabled = eapr & BIT(31);
 	sdram_refresh_rate = dramcr & (BIT(0) | BIT(1));
-	debugf2("sdram refresh rate = %#0x\n", sdram_refresh_rate);
-	debugf2("DRAMC register = %#0x\n", dramcr);
+	edac_dbg(2, "sdram refresh rate = %#0x\n", sdram_refresh_rate);
+	edac_dbg(2, "DRAMC register = %#0x\n", dramcr);
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = R82600_NR_CSROWS;
 	layers[0].is_virt_csrow = true;
@@ -294,7 +294,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("mci = %p\n", mci);
+	edac_dbg(0, "mci = %p\n", mci);
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -310,8 +310,8 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 
 	if (ecc_enabled(dramcr)) {
 		if (scrub_disabled)
-			debugf3("mci = %p - Scrubbing disabled! EAP: "
-				"%#0x\n", mci, eapr);
+			edac_dbg(3, "mci = %p - Scrubbing disabled! EAP: %#0x\n",
+				 mci, eapr);
 	} else
 		mci->edac_cap = EDAC_FLAG_NONE;
 
@@ -328,14 +328,14 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
 	if (edac_mc_add_mc(mci)) {
-		debugf3("failed edac_mc_add_mc()\n");
+		edac_dbg(3, "failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
 	/* get this far and it's successful */
 
 	if (disable_hardware_scrub) {
-		debugf3("Disabling Hardware Scrub (scrub on error)\n");
+		edac_dbg(3, "Disabling Hardware Scrub (scrub on error)\n");
 		pci_write_bits32(pdev, R82600_EAP, BIT(31), BIT(31));
 	}
 
@@ -350,7 +350,7 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 			__func__);
 	}
 
-	debugf3("success\n");
+	edac_dbg(3, "success\n");
 	return 0;
 
 fail:
@@ -362,7 +362,7 @@ fail:
 static int __devinit r82600_init_one(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/* don't need to call pci_enable_device() */
 	return r82600_probe1(pdev, ent->driver_data);
@@ -372,7 +372,7 @@ static void __devexit r82600_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	if (r82600_pci)
 		edac_pci_release_generic_ctl(r82600_pci);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 96efa49..05955bf 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -381,8 +381,8 @@ static inline int numrank(u32 mtr)
 	int ranks = (1 << RANK_CNT_BITS(mtr));
 
 	if (ranks > 4) {
-		debugf0("Invalid number of ranks: %d (max = 4) raw value = %x (%04x)",
-			ranks, (unsigned int)RANK_CNT_BITS(mtr), mtr);
+		edac_dbg(0, "Invalid number of ranks: %d (max = 4) raw value = %x (%04x)\n",
+			 ranks, (unsigned int)RANK_CNT_BITS(mtr), mtr);
 		return -EINVAL;
 	}
 
@@ -394,8 +394,8 @@ static inline int numrow(u32 mtr)
 	int rows = (RANK_WIDTH_BITS(mtr) + 12);
 
 	if (rows < 13 || rows > 18) {
-		debugf0("Invalid number of rows: %d (should be between 14 and 17) raw value = %x (%04x)",
-			rows, (unsigned int)RANK_WIDTH_BITS(mtr), mtr);
+		edac_dbg(0, "Invalid number of rows: %d (should be between 14 and 17) raw value = %x (%04x)\n",
+			 rows, (unsigned int)RANK_WIDTH_BITS(mtr), mtr);
 		return -EINVAL;
 	}
 
@@ -407,8 +407,8 @@ static inline int numcol(u32 mtr)
 	int cols = (COL_WIDTH_BITS(mtr) + 10);
 
 	if (cols > 12) {
-		debugf0("Invalid number of cols: %d (max = 4) raw value = %x (%04x)",
-			cols, (unsigned int)COL_WIDTH_BITS(mtr), mtr);
+		edac_dbg(0, "Invalid number of cols: %d (max = 4) raw value = %x (%04x)\n",
+			 cols, (unsigned int)COL_WIDTH_BITS(mtr), mtr);
 		return -EINVAL;
 	}
 
@@ -475,8 +475,8 @@ static struct pci_dev *get_pdev_slot_func(u8 bus, unsigned slot,
 
 		if (PCI_SLOT(sbridge_dev->pdev[i]->devfn) == slot &&
 		    PCI_FUNC(sbridge_dev->pdev[i]->devfn) == func) {
-			debugf1("Associated %02x.%02x.%d with %p\n",
-				bus, slot, func, sbridge_dev->pdev[i]);
+			edac_dbg(1, "Associated %02x.%02x.%d with %p\n",
+				 bus, slot, func, sbridge_dev->pdev[i]);
 			return sbridge_dev->pdev[i];
 		}
 	}
@@ -523,45 +523,45 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 
 	pci_read_config_dword(pvt->pci_br, SAD_CONTROL, &reg);
 	pvt->sbridge_dev->node_id = NODE_ID(reg);
-	debugf0("mc#%d: Node ID: %d, source ID: %d\n",
-		pvt->sbridge_dev->mc,
-		pvt->sbridge_dev->node_id,
-		pvt->sbridge_dev->source_id);
+	edac_dbg(0, "mc#%d: Node ID: %d, source ID: %d\n",
+		 pvt->sbridge_dev->mc,
+		 pvt->sbridge_dev->node_id,
+		 pvt->sbridge_dev->source_id);
 
 	pci_read_config_dword(pvt->pci_ras, RASENABLES, &reg);
 	if (IS_MIRROR_ENABLED(reg)) {
-		debugf0("Memory mirror is enabled\n");
+		edac_dbg(0, "Memory mirror is enabled\n");
 		pvt->is_mirrored = true;
 	} else {
-		debugf0("Memory mirror is disabled\n");
+		edac_dbg(0, "Memory mirror is disabled\n");
 		pvt->is_mirrored = false;
 	}
 
 	pci_read_config_dword(pvt->pci_ta, MCMTR, &pvt->info.mcmtr);
 	if (IS_LOCKSTEP_ENABLED(pvt->info.mcmtr)) {
-		debugf0("Lockstep is enabled\n");
+		edac_dbg(0, "Lockstep is enabled\n");
 		mode = EDAC_S8ECD8ED;
 		pvt->is_lockstep = true;
 	} else {
-		debugf0("Lockstep is disabled\n");
+		edac_dbg(0, "Lockstep is disabled\n");
 		mode = EDAC_S4ECD4ED;
 		pvt->is_lockstep = false;
 	}
 	if (IS_CLOSE_PG(pvt->info.mcmtr)) {
-		debugf0("address map is on closed page mode\n");
+		edac_dbg(0, "address map is on closed page mode\n");
 		pvt->is_close_pg = true;
 	} else {
-		debugf0("address map is on open page mode\n");
+		edac_dbg(0, "address map is on open page mode\n");
 		pvt->is_close_pg = false;
 	}
 
 	pci_read_config_dword(pvt->pci_ta, RANK_CFG_A, &reg);
 	if (IS_RDIMM_ENABLED(reg)) {
 		/* FIXME: Can also be LRDIMM */
-		debugf0("Memory is registered\n");
+		edac_dbg(0, "Memory is registered\n");
 		mtype = MEM_RDDR3;
 	} else {
-		debugf0("Memory is unregistered\n");
+		edac_dbg(0, "Memory is unregistered\n");
 		mtype = MEM_DDR3;
 	}
 
@@ -576,7 +576,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				       i, j, 0);
 			pci_read_config_dword(pvt->pci_tad[i],
 					      mtr_regs[j], &mtr);
-			debugf4("Channel #%d  MTR%d = %x\n", i, j, mtr);
+			edac_dbg(4, "Channel #%d  MTR%d = %x\n", i, j, mtr);
 			if (IS_DIMM_PRESENT(mtr)) {
 				pvt->channel[i].dimms++;
 
@@ -588,10 +588,10 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				size = (rows * cols * banks * ranks) >> (20 - 3);
 				npages = MiB_TO_PAGES(size);
 
-				debugf0("mc#%d: channel %d, dimm %d, %d Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
-					pvt->sbridge_dev->mc, i, j,
-					size, npages,
-					banks, ranks, rows, cols);
+				edac_dbg(0, "mc#%d: channel %d, dimm %d, %d Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
+					 pvt->sbridge_dev->mc, i, j,
+					 size, npages,
+					 banks, ranks, rows, cols);
 
 				dimm->nr_pages = npages;
 				dimm->grain = 32;
@@ -629,8 +629,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	tmp_mb = (1 + pvt->tolm) >> 20;
 
 	mb = div_u64_rem(tmp_mb, 1000, &kb);
-	debugf0("TOLM: %u.%03u GB (0x%016Lx)\n",
-		mb, kb, (u64)pvt->tolm);
+	edac_dbg(0, "TOLM: %u.%03u GB (0x%016Lx)\n", mb, kb, (u64)pvt->tolm);
 
 	/* Address range is already 45:25 */
 	pci_read_config_dword(pvt->pci_sad1, TOHM,
@@ -639,8 +638,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	tmp_mb = (1 + pvt->tohm) >> 20;
 
 	mb = div_u64_rem(tmp_mb, 1000, &kb);
-	debugf0("TOHM: %u.%03u GB (0x%016Lx)",
-		mb, kb, (u64)pvt->tohm);
+	edac_dbg(0, "TOHM: %u.%03u GB (0x%016Lx)", mb, kb, (u64)pvt->tohm);
 
 	/*
 	 * Step 2) Get SAD range and SAD Interleave list
@@ -663,13 +661,13 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 
 		tmp_mb = (limit + 1) >> 20;
 		mb = div_u64_rem(tmp_mb, 1000, &kb);
-		debugf0("SAD#%d %s up to %u.%03u GB (0x%016Lx) %s reg=0x%08x\n",
-			n_sads,
-			get_dram_attr(reg),
-			mb, kb,
-			((u64)tmp_mb) << 20L,
-			INTERLEAVE_MODE(reg) ? "Interleave: 8:6" : "Interleave: [8:6]XOR[18:16]",
-			reg);
+		edac_dbg(0, "SAD#%d %s up to %u.%03u GB (0x%016Lx) Interleave: %s reg=0x%08x\n",
+			 n_sads,
+			 get_dram_attr(reg),
+			 mb, kb,
+			 ((u64)tmp_mb) << 20L,
+			 INTERLEAVE_MODE(reg) ? "8:6" : "[8:6]XOR[18:16]",
+			 reg);
 		prv = limit;
 
 		pci_read_config_dword(pvt->pci_sad0, interleave_list[n_sads],
@@ -679,8 +677,8 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			if (j > 0 && sad_interl == sad_pkg(reg, j))
 				break;
 
-			debugf0("SAD#%d, interleave #%d: %d\n",
-			n_sads, j, sad_pkg(reg, j));
+			edac_dbg(0, "SAD#%d, interleave #%d: %d\n",
+				 n_sads, j, sad_pkg(reg, j));
 		}
 	}
 
@@ -697,16 +695,16 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 		tmp_mb = (limit + 1) >> 20;
 
 		mb = div_u64_rem(tmp_mb, 1000, &kb);
-		debugf0("TAD#%d: up to %u.%03u GB (0x%016Lx), socket interleave %d, memory interleave %d, TGT: %d, %d, %d, %d, reg=0x%08x\n",
-			n_tads, mb, kb,
-			((u64)tmp_mb) << 20L,
-			(u32)TAD_SOCK(reg),
-			(u32)TAD_CH(reg),
-			(u32)TAD_TGT0(reg),
-			(u32)TAD_TGT1(reg),
-			(u32)TAD_TGT2(reg),
-			(u32)TAD_TGT3(reg),
-			reg);
+		edac_dbg(0, "TAD#%d: up to %u.%03u GB (0x%016Lx), socket interleave %d, memory interleave %d, TGT: %d, %d, %d, %d, reg=0x%08x\n",
+			 n_tads, mb, kb,
+			 ((u64)tmp_mb) << 20L,
+			 (u32)TAD_SOCK(reg),
+			 (u32)TAD_CH(reg),
+			 (u32)TAD_TGT0(reg),
+			 (u32)TAD_TGT1(reg),
+			 (u32)TAD_TGT2(reg),
+			 (u32)TAD_TGT3(reg),
+			 reg);
 		prv = limit;
 	}
 
@@ -722,11 +720,11 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 					      &reg);
 			tmp_mb = TAD_OFFSET(reg) >> 20;
 			mb = div_u64_rem(tmp_mb, 1000, &kb);
-			debugf0("TAD CH#%d, offset #%d: %u.%03u GB (0x%016Lx), reg=0x%08x\n",
-				i, j,
-				mb, kb,
-				((u64)tmp_mb) << 20L,
-				reg);
+			edac_dbg(0, "TAD CH#%d, offset #%d: %u.%03u GB (0x%016Lx), reg=0x%08x\n",
+				 i, j,
+				 mb, kb,
+				 ((u64)tmp_mb) << 20L,
+				 reg);
 		}
 	}
 
@@ -747,12 +745,12 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			tmp_mb = RIR_LIMIT(reg) >> 20;
 			rir_way = 1 << RIR_WAY(reg);
 			mb = div_u64_rem(tmp_mb, 1000, &kb);
-			debugf0("CH#%d RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d, reg=0x%08x\n",
-				i, j,
-				mb, kb,
-				((u64)tmp_mb) << 20L,
-				rir_way,
-				reg);
+			edac_dbg(0, "CH#%d RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d, reg=0x%08x\n",
+				 i, j,
+				 mb, kb,
+				 ((u64)tmp_mb) << 20L,
+				 rir_way,
+				 reg);
 
 			for (k = 0; k < rir_way; k++) {
 				pci_read_config_dword(pvt->pci_tad[i],
@@ -761,12 +759,12 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 				tmp_mb = RIR_OFFSET(reg) << 6;
 
 				mb = div_u64_rem(tmp_mb, 1000, &kb);
-				debugf0("CH#%d RIR#%d INTL#%d, offset %u.%03u GB (0x%016Lx), tgt: %d, reg=0x%08x\n",
-					i, j, k,
-					mb, kb,
-					((u64)tmp_mb) << 20L,
-					(u32)RIR_RNK_TGT(reg),
-					reg);
+				edac_dbg(0, "CH#%d RIR#%d INTL#%d, offset %u.%03u GB (0x%016Lx), tgt: %d, reg=0x%08x\n",
+					 i, j, k,
+					 mb, kb,
+					 ((u64)tmp_mb) << 20L,
+					 (u32)RIR_RNK_TGT(reg),
+					 reg);
 			}
 		}
 	}
@@ -853,16 +851,16 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		if (sad_way > 0 && sad_interl == sad_pkg(reg, sad_way))
 			break;
 		sad_interleave[sad_way] = sad_pkg(reg, sad_way);
-		debugf0("SAD interleave #%d: %d\n",
-			sad_way, sad_interleave[sad_way]);
+		edac_dbg(0, "SAD interleave #%d: %d\n",
+			 sad_way, sad_interleave[sad_way]);
 	}
-	debugf0("mc#%d: Error detected on SAD#%d: address 0x%016Lx < 0x%016Lx, Interleave [%d:6]%s\n",
-		pvt->sbridge_dev->mc,
-		n_sads,
-		addr,
-		limit,
-		sad_way + 7,
-		interleave_mode ? "" : "XOR[18:16]");
+	edac_dbg(0, "mc#%d: Error detected on SAD#%d: address 0x%016Lx < 0x%016Lx, Interleave [%d:6]%s\n",
+		 pvt->sbridge_dev->mc,
+		 n_sads,
+		 addr,
+		 limit,
+		 sad_way + 7,
+		 interleave_mode ? "" : "XOR[18:16]");
 	if (interleave_mode)
 		idx = ((addr >> 6) ^ (addr >> 16)) & 7;
 	else
@@ -884,8 +882,8 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		return -EINVAL;
 	}
 	*socket = sad_interleave[idx];
-	debugf0("SAD interleave index: %d (wayness %d) = CPU socket %d\n",
-		idx, sad_way, *socket);
+	edac_dbg(0, "SAD interleave index: %d (wayness %d) = CPU socket %d\n",
+		 idx, sad_way, *socket);
 
 	/*
 	 * Move to the proper node structure, in order to access the
@@ -972,16 +970,16 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 
 	offset = TAD_OFFSET(tad_offset);
 
-	debugf0("TAD#%d: address 0x%016Lx < 0x%016Lx, socket interleave %d, channel interleave %d (offset 0x%08Lx), index %d, base ch: %d, ch mask: 0x%02lx\n",
-		n_tads,
-		addr,
-		limit,
-		(u32)TAD_SOCK(reg),
-		ch_way,
-		offset,
-		idx,
-		base_ch,
-		*channel_mask);
+	edac_dbg(0, "TAD#%d: address 0x%016Lx < 0x%016Lx, socket interleave %d, channel interleave %d (offset 0x%08Lx), index %d, base ch: %d, ch mask: 0x%02lx\n",
+		 n_tads,
+		 addr,
+		 limit,
+		 (u32)TAD_SOCK(reg),
+		 ch_way,
+		 offset,
+		 idx,
+		 base_ch,
+		 *channel_mask);
 
 	/* Calculate channel address */
 	/* Remove the TAD offset */
@@ -1017,11 +1015,11 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 
 		limit = RIR_LIMIT(reg);
 		mb = div_u64_rem(limit >> 20, 1000, &kb);
-		debugf0("RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d\n",
-			n_rir,
-			mb, kb,
-			limit,
-			1 << RIR_WAY(reg));
+		edac_dbg(0, "RIR#%d, limit: %u.%03u GB (0x%016Lx), way: %d\n",
+			 n_rir,
+			 mb, kb,
+			 limit,
+			 1 << RIR_WAY(reg));
 		if  (ch_addr <= limit)
 			break;
 	}
@@ -1042,12 +1040,12 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			      &reg);
 	*rank = RIR_RNK_TGT(reg);
 
-	debugf0("RIR#%d: channel address 0x%08Lx < 0x%08Lx, RIR interleave %d, index %d\n",
-		n_rir,
-		ch_addr,
-		limit,
-		rir_way,
-		idx);
+	edac_dbg(0, "RIR#%d: channel address 0x%08Lx < 0x%08Lx, RIR interleave %d, index %d\n",
+		 n_rir,
+		 ch_addr,
+		 limit,
+		 rir_way,
+		 idx);
 
 	return 0;
 }
@@ -1064,14 +1062,14 @@ static void sbridge_put_devices(struct sbridge_dev *sbridge_dev)
 {
 	int i;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 	for (i = 0; i < sbridge_dev->n_devs; i++) {
 		struct pci_dev *pdev = sbridge_dev->pdev[i];
 		if (!pdev)
 			continue;
-		debugf0("Removing dev %02x:%02x.%d\n",
-			pdev->bus->number,
-			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+		edac_dbg(0, "Removing dev %02x:%02x.%d\n",
+			 pdev->bus->number,
+			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 		pci_dev_put(pdev);
 	}
 }
@@ -1177,10 +1175,9 @@ static int sbridge_get_onedevice(struct pci_dev **prev,
 		return -ENODEV;
 	}
 
-	debugf0("Detected dev %02x:%d.%d PCI ID %04x:%04x\n",
-		bus, dev_descr->dev,
-		dev_descr->func,
-		PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
+	edac_dbg(0, "Detected dev %02x:%d.%d PCI ID %04x:%04x\n",
+		 bus, dev_descr->dev, dev_descr->func,
+		 PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
 
 	/*
 	 * As stated on drivers/pci/search.c, the reference count for
@@ -1297,10 +1294,10 @@ static int mci_bind_devs(struct mem_ctl_info *mci,
 			goto error;
 		}
 
-		debugf0("Associated PCI %02x.%02d.%d with dev = %p\n",
-			sbridge_dev->bus,
-			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
-			pdev);
+		edac_dbg(0, "Associated PCI %02x.%02d.%d with dev = %p\n",
+			 sbridge_dev->bus,
+			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
+			 pdev);
 	}
 
 	/* Check if everything were registered */
@@ -1445,7 +1442,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 		 channel_mask,
 		 rank);
 
-	debugf0("%s", msg);
+	edac_dbg(0, "%s\n", msg);
 
 	/* FIXME: need support for channel mask */
 
@@ -1592,7 +1589,7 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 	struct sbridge_pvt *pvt;
 
 	if (unlikely(!mci || !mci->pvt_info)) {
-		debugf0("MC: dev = %p\n", &sbridge_dev->pdev[0]->dev);
+		edac_dbg(0, "MC: dev = %p\n", &sbridge_dev->pdev[0]->dev);
 
 		sbridge_printk(KERN_ERR, "Couldn't find mci handler\n");
 		return;
@@ -1600,15 +1597,15 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
 
 	pvt = mci->pvt_info;
 
-	debugf0("MC: mci = %p, dev = %p\n",
-		mci, &sbridge_dev->pdev[0]->dev);
+	edac_dbg(0, "MC: mci = %p, dev = %p\n",
+		 mci, &sbridge_dev->pdev[0]->dev);
 
 	mce_unregister_decode_chain(&sbridge_mce_dec);
 
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->pdev);
 
-	debugf1("%s: free mci struct\n", mci->ctl_name);
+	edac_dbg(1, "%s: free mci struct\n", mci->ctl_name);
 	kfree(mci->ctl_name);
 	edac_mc_free(mci);
 	sbridge_dev->mci = NULL;
@@ -1639,8 +1636,8 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	if (unlikely(!mci))
 		return -ENOMEM;
 
-	debugf0("MC: mci = %p, dev = %p\n",
-		mci, &sbridge_dev->pdev[0]->dev);
+	edac_dbg(0, "MC: mci = %p, dev = %p\n",
+		 mci, &sbridge_dev->pdev[0]->dev);
 
 	pvt = mci->pvt_info;
 	memset(pvt, 0, sizeof(*pvt));
@@ -1675,7 +1672,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (unlikely(edac_mc_add_mc(mci))) {
-		debugf0("MC: failed edac_mc_add_mc()\n");
+		edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
 		rc = -EINVAL;
 		goto fail0;
 	}
@@ -1723,7 +1720,8 @@ static int __devinit sbridge_probe(struct pci_dev *pdev,
 	mc = 0;
 
 	list_for_each_entry(sbridge_dev, &sbridge_edac_list, list) {
-		debugf0("Registering MC#%d (%d of %d)\n", mc, mc + 1, num_mc);
+		edac_dbg(0, "Registering MC#%d (%d of %d)\n",
+			 mc, mc + 1, num_mc);
 		sbridge_dev->mc = mc++;
 		rc = sbridge_register_mci(sbridge_dev);
 		if (unlikely(rc < 0))
@@ -1753,7 +1751,7 @@ static void __devexit sbridge_remove(struct pci_dev *pdev)
 {
 	struct sbridge_dev *sbridge_dev;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	/*
 	 * we have a trouble here: pdev value for removal will be wrong, since
@@ -1802,7 +1800,7 @@ static int __init sbridge_init(void)
 {
 	int pci_rc;
 
-	debugf2("\n");
+	edac_dbg(2, "\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1824,7 +1822,7 @@ static int __init sbridge_init(void)
  */
 static void __exit sbridge_exit(void)
 {
-	debugf2("\n");
+	edac_dbg(2, "\n");
 	pci_unregister_driver(&sbridge_driver);
 }
 
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 70c7454..0e1581a 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -103,10 +103,10 @@ static int how_many_channel(struct pci_dev *pdev)
 
 	pci_read_config_byte(pdev, X38_CAPID0 + 8, &capid0_8b);
 	if (capid0_8b & 0x20) {	/* check DCD: Dual Channel Disable */
-		debugf0("In single channel mode.\n");
+		edac_dbg(0, "In single channel mode\n");
 		x38_channel_num = 1;
 	} else {
-		debugf0("In dual channel mode.\n");
+		edac_dbg(0, "In dual channel mode\n");
 		x38_channel_num = 2;
 	}
 
@@ -243,7 +243,7 @@ static void x38_check(struct mem_ctl_info *mci)
 {
 	struct x38_error_info info;
 
-	debugf1("MC%d\n", mci->mc_idx);
+	edac_dbg(1, "MC%d\n", mci->mc_idx);
 	x38_get_and_clear_error_info(mci, &info);
 	x38_process_error_info(mci, &info);
 }
@@ -331,7 +331,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	bool stacked;
 	void __iomem *window;
 
-	debugf0("MC:\n");
+	edac_dbg(0, "MC:\n");
 
 	window = x38_map_mchbar(pdev);
 	if (!window)
@@ -352,7 +352,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	if (!mci)
 		return -ENOMEM;
 
-	debugf3("MC: init mci\n");
+	edac_dbg(3, "MC: init mci\n");
 
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
@@ -402,12 +402,12 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
-		debugf3("MC: failed edac_mc_add_mc()\n");
+		edac_dbg(3, "MC: failed edac_mc_add_mc()\n");
 		goto fail;
 	}
 
 	/* get this far and it's successful */
-	debugf3("MC: success\n");
+	edac_dbg(3, "MC: success\n");
 	return 0;
 
 fail:
@@ -423,7 +423,7 @@ static int __devinit x38_init_one(struct pci_dev *pdev,
 {
 	int rc;
 
-	debugf0("MC:\n");
+	edac_dbg(0, "MC:\n");
 
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;
@@ -439,7 +439,7 @@ static void __devexit x38_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
-	debugf0("\n");
+	edac_dbg(0, "\n");
 
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (!mci)
@@ -472,7 +472,7 @@ static int __init x38_init(void)
 {
 	int pci_rc;
 
-	debugf3("MC:\n");
+	edac_dbg(3, "MC:\n");
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -486,14 +486,14 @@ static int __init x38_init(void)
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					PCI_DEVICE_ID_INTEL_X38_HB, NULL);
 		if (!mci_pdev) {
-			debugf0("x38 pci_get_device fail\n");
+			edac_dbg(0, "x38 pci_get_device fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
 
 		pci_rc = x38_init_one(mci_pdev, x38_pci_tbl);
 		if (pci_rc < 0) {
-			debugf0("x38 init fail\n");
+			edac_dbg(0, "x38 init fail\n");
 			pci_rc = -ENODEV;
 			goto fail1;
 		}
@@ -513,7 +513,7 @@ fail0:
 
 static void __exit x38_exit(void)
 {
-	debugf3("MC:\n");
+	edac_dbg(3, "MC:\n");
 
 	pci_unregister_driver(&x38_driver);
 	if (!x38_registered) {
-- 
1.7.8

