Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1CAP1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:27:09 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58379 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab1CAP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:27:05 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 7/8] amd64_edac: Fix DCT argument type
Date: Tue,  1 Mar 2011 16:26:55 +0100
Message-Id: <1298993216-19434-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Fix amd64_debug_display_dimm_sizes() arguments order per convention (pvt
is always first). Also, the now second arg denotes the DCT so adjust its
type.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1b8fa7a..cc4f887 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -768,8 +768,7 @@ static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
 	return edac_cap;
 }
 
-
-static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt);
+static void amd64_debug_display_dimm_sizes(struct amd64_pvt *, u8);
 
 static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 {
@@ -817,13 +816,13 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 
 	debugf1("  DramHoleValid: %s\n", dhar_valid(pvt) ? "yes" : "no");
 
-	amd64_debug_display_dimm_sizes(0, pvt);
+	amd64_debug_display_dimm_sizes(pvt, 0);
 
 	/* everything below this point is Fam10h and above */
 	if (boot_cpu_data.x86 == 0xf)
 		return;
 
-	amd64_debug_display_dimm_sizes(1, pvt);
+	amd64_debug_display_dimm_sizes(pvt, 1);
 
 	amd64_info("using %s syndromes.\n", ((pvt->ecc_sym_sz == 8) ? "x8" : "x4"));
 
@@ -1536,7 +1535,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
  * debug routine to display the memory sizes of all logical DIMMs and its
  * CSROWs
  */
-static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
+static void amd64_debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 {
 	int dimm, size0, size1, factor = 0;
 	u32 *dcsb = ctrl ? pvt->csels[1].csbases : pvt->csels[0].csbases;
-- 
1.7.4.rc2

