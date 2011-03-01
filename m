Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1CAP07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:26:59 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58365 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab1CAP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:26:58 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/8] amd64_edac: Fix DRAM base macros
Date: Tue,  1 Mar 2011 16:26:51 +0100
Message-Id: <1298993216-19434-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Return unsigned u8 values only.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    3 +--
 drivers/edac/amd64_edac.h |    8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8d9def5..e6adc73 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -621,7 +621,6 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 	BUG_ON(node_id > 7);
 
 	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
-
 	if (intlv_shift == 0) {
 		debugf1("    InputAddr 0x%lx translates to DramAddr of "
 			"same value\n",	(unsigned long)input_addr);
@@ -1192,7 +1191,7 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
 static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 				bool hi_range_sel, u8 intlv_en)
 {
-	u32 dct_sel_high = (pvt->dct_sel_lo >> 1) & 1;
+	u8 dct_sel_high = (pvt->dct_sel_lo >> 1) & 1;
 
 	if (dct_ganging_enabled(pvt))
 		return 0;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6220bae..11be36a 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -180,10 +180,10 @@
 #define DRAM_BASE_LO			0x40
 #define DRAM_LIMIT_LO			0x44
 
-#define dram_intlv_en(pvt, i)		((pvt->ranges[i].base.lo >> 8) & 0x7)
-#define dram_rw(pvt, i)			(pvt->ranges[i].base.lo & 0x3)
-#define dram_intlv_sel(pvt, i)		((pvt->ranges[i].lim.lo >> 8) & 0x7)
-#define dram_dst_node(pvt, i)		(pvt->ranges[i].lim.lo & 0x7)
+#define dram_intlv_en(pvt, i)		((u8)((pvt->ranges[i].base.lo >> 8) & 0x7))
+#define dram_rw(pvt, i)			((u8)(pvt->ranges[i].base.lo & 0x3))
+#define dram_intlv_sel(pvt, i)		((u8)((pvt->ranges[i].lim.lo >> 8) & 0x7))
+#define dram_dst_node(pvt, i)		((u8)(pvt->ranges[i].lim.lo & 0x7))
 
 #define DHAR				0xf0
 #define dhar_valid(pvt)			((pvt)->dhar & BIT(0))
-- 
1.7.4.rc2

