Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab2K0Gf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:35:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab2K0GfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:35:17 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4 v7] AMD64 EDAC: Fix type usage in NB IDs and memory ranges
Date: Tue, 27 Nov 2012 14:32:12 +0800
Message-Id: <1353997932-8475-4-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
References: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use appropriate types for northbridge IDs and memory ranges.

v7: Refactor patches grouping changes

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h |    2 +-
 drivers/edac/amd64_edac.c     |   20 ++++++++++----------
 drivers/edac/amd64_edac.h     |    6 +++---
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 417eb24..d2e703b 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -76,7 +76,7 @@ static inline bool amd_nb_has_feature(unsigned feature)
 	return ((amd_northbridges.flags & feature) == feature);
 }
 
-static inline struct amd_northbridge *node_to_amd_nb(int node)
+static inline struct amd_northbridge *node_to_amd_nb(u16 node)
 {
 	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 62b7b17..b27412a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
  * DRAM base/limit associated with node_id
  */
 static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
-				   unsigned nid)
+				   u8 nid)
 {
 	u64 addr;
 
@@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 						u64 sys_addr)
 {
 	struct amd64_pvt *pvt;
-	unsigned node_id;
+	u8 node_id;
 	u32 intlv_en, bits;
 
 	/*
@@ -1348,7 +1348,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1399,7 +1399,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
  * checks if the csrow passed in is marked as SPARED, if so returns the new
  * spare row
  */
-static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
+static int f10_process_possible_spare(struct amd64_pvt *pvt, u16 dct, int csrow)
 {
 	int tmp_cs;
 
@@ -1424,7 +1424,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -2266,7 +2266,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
+static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
@@ -2299,7 +2299,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2337,7 +2337,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2389,7 +2389,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2428,7 +2428,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index cecd0c4..a558084 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -332,7 +332,7 @@ struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *F1, *F2, *F3;
 
-	unsigned mc_node_id;	/* MC index of this MC node */
+	u16 mc_node_id;		/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
@@ -368,7 +368,7 @@ struct amd64_pvt {
 	struct error_injection injection;
 };
 
-static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_base(struct amd64_pvt *pvt, u8 i)
 {
 	u64 addr = ((u64)pvt->ranges[i].base.lo & 0xffff0000) << 8;
 
@@ -378,7 +378,7 @@ static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
 	return (((u64)pvt->ranges[i].base.hi & 0x000000ff) << 40) | addr;
 }
 
-static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_limit(struct amd64_pvt *pvt, u8 i)
 {
 	u64 lim = (((u64)pvt->ranges[i].lim.lo & 0xffff0000) << 8) | 0x00ffffff;
 
-- 
1.7.10.4

