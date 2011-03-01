Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1CAP1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:27:49 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58376 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab1CAP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:27:04 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/8] amd64_edac: Fix ranges signedness
Date: Tue,  1 Mar 2011 16:26:54 +0100
Message-Id: <1298993216-19434-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The dram ranges make sense only as an unsigned type.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9719f4a..1b8fa7a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1226,7 +1226,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1380,7 +1380,7 @@ static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 }
 
 /* For a given @dram_range, check if @sys_addr falls within it. */
-static int f1x_match_to_this_node(struct amd64_pvt *pvt, int range,
+static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
 	int cs_found = -EINVAL;
@@ -1468,7 +1468,8 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, int range,
 static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
 				       int *node, int *chan_sel)
 {
-	int range, cs_found = -EINVAL;
+	int cs_found = -EINVAL;
+	unsigned range;
 
 	for (range = 0; range < DRAM_RANGES; range++) {
 
@@ -1941,7 +1942,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u64 msr_val;
 	u32 tmp;
-	int range;
+	unsigned range;
 
 	/*
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
-- 
1.7.4.rc2

