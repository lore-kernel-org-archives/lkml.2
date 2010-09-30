Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0I3LAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:00:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41664 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0I3LAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:00:50 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/8] EDAC, MCE: Add HW_ERR prefix
Date: Thu, 30 Sep 2010 13:01:43 +0200
Message-Id: <1285844509-27120-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285844509-27120-1-git-send-email-bp@amd64.org>
References: <1285844509-27120-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

.. so that the user knows what she's looking at there in dmesg. Also,
fix a minor cosmetic output inconsistency.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 9014df6..564fe7c 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -133,7 +133,7 @@ static void amd_decode_dc_mce(u64 mc0_status)
 	u32 ec  = mc0_status & 0xffff;
 	u32 xec = (mc0_status >> 16) & 0xf;
 
-	pr_emerg("Data Cache Error");
+	pr_emerg(HW_ERR "Data Cache Error: ");
 
 	if (xec == 1 && TLB_ERROR(ec))
 		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
@@ -168,7 +168,7 @@ static void amd_decode_dc_mce(u64 mc0_status)
 	return;
 
 wrong_dc_mce:
-	pr_warning("Corrupted DC MCE info?\n");
+	pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
 }
 
 static void amd_decode_ic_mce(u64 mc1_status)
@@ -176,7 +176,7 @@ static void amd_decode_ic_mce(u64 mc1_status)
 	u32 ec  = mc1_status & 0xffff;
 	u32 xec = (mc1_status >> 16) & 0xf;
 
-	pr_emerg("Instruction Cache Error");
+	pr_emerg(HW_ERR "Instruction Cache Error");
 
 	if (xec == 1 && TLB_ERROR(ec))
 		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
@@ -225,7 +225,7 @@ static void amd_decode_ic_mce(u64 mc1_status)
 	return;
 
 wrong_ic_mce:
-	pr_warning("Corrupted IC MCE info?\n");
+	pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
 }
 
 static void amd_decode_bu_mce(u64 mc2_status)
@@ -233,7 +233,7 @@ static void amd_decode_bu_mce(u64 mc2_status)
 	u32 ec = mc2_status & 0xffff;
 	u32 xec = (mc2_status >> 16) & 0xf;
 
-	pr_emerg("Bus Unit Error");
+	pr_emerg(HW_ERR "Bus Unit Error");
 
 	if (xec == 0x1)
 		pr_cont(" in the write data buffers.\n");
@@ -267,7 +267,7 @@ static void amd_decode_bu_mce(u64 mc2_status)
 	return;
 
 wrong_bu_mce:
-	pr_warning("Corrupted BU MCE info?\n");
+	pr_emerg(HW_ERR "Corrupted BU MCE info?\n");
 }
 
 static void amd_decode_ls_mce(u64 mc3_status)
@@ -275,7 +275,7 @@ static void amd_decode_ls_mce(u64 mc3_status)
 	u32 ec  = mc3_status & 0xffff;
 	u32 xec = (mc3_status >> 16) & 0xf;
 
-	pr_emerg("Load Store Error");
+	pr_emerg(HW_ERR "Load Store Error");
 
 	if (xec == 0x0) {
 		u8 rrrr = (ec >> 4) & 0xf;
@@ -288,7 +288,7 @@ static void amd_decode_ls_mce(u64 mc3_status)
 	return;
 
 wrong_ls_mce:
-	pr_warning("Corrupted LS MCE info?\n");
+	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
 }
 
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
@@ -304,7 +304,7 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	if (TLB_ERROR(ec) && !report_gart_errors)
 		return;
 
-	pr_emerg("Northbridge Error, node %d", node_id);
+	pr_emerg(HW_ERR "Northbridge Error, node %d", node_id);
 
 	/*
 	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
@@ -323,7 +323,7 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 		pr_cont("\n");
 	}
 
-	pr_emerg("%s.\n", EXT_ERR_MSG(regs->nbsl));
+	pr_emerg(HW_ERR "%s.\n", EXT_ERR_MSG(regs->nbsl));
 
 	if (BUS_ERROR(ec) && nb_bus_decoder)
 		nb_bus_decoder(node_id, regs);
@@ -334,26 +334,26 @@ static void amd_decode_fr_mce(u64 mc5_status)
 {
 	/* we have only one error signature so match all fields at once. */
 	if ((mc5_status & 0xffff) == 0x0f0f)
-		pr_emerg(" FR Error: CPU Watchdog timer expire.\n");
+		pr_emerg(HW_ERR " FR Error: CPU Watchdog timer expire.\n");
 	else
-		pr_warning("Corrupted FR MCE info?\n");
+		pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
 }
 
 static inline void amd_decode_err_code(unsigned int ec)
 {
 	if (TLB_ERROR(ec)) {
-		pr_emerg("Transaction: %s, Cache Level %s\n",
+		pr_emerg(HW_ERR "Transaction: %s, Cache Level: %s\n",
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg("Transaction: %s, Type: %s, Cache Level: %s",
+		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s",
 			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg("Transaction type: %s(%s), %s, Cache Level: %s, "
+		pr_emerg(HW_ERR "Transaction type: %s(%s), %s, Cache Level: %s, "
 			 "Participating Processor: %s\n",
 			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
 			  PP_MSG(ec));
 	} else
-		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
+		pr_emerg(HW_ERR "Huh? Unknown MCE error 0x%x\n", ec);
 }
 
 static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
@@ -363,7 +363,7 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 	struct err_regs regs;
 	int node, ecc;
 
-	pr_emerg("MC%d_STATUS: ", m->bank);
+	pr_emerg(HW_ERR "MC%d_STATUS: ", m->bank);
 
 	pr_cont("%sorrected error, other errors lost: %s, "
 		 "CPU context corrupt: %s",
-- 
1.7.1

