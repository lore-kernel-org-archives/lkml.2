Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1CAP05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:26:57 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58354 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1CAP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:26:56 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/8] amd64_edac: Fix PCI config addressing types
Date: Tue,  1 Mar 2011 16:26:52 +0100
Message-Id: <1298993216-19434-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Adjust argument types to the PCI config API's types.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e6adc73..2425332 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -856,8 +856,8 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 	prep_chip_selects(pvt);
 
 	for_each_chip_select(cs, 0, pvt) {
-		u32 reg0   = DCSB0 + (cs * 4);
-		u32 reg1   = DCSB1 + (cs * 4);
+		int reg0   = DCSB0 + (cs * 4);
+		int reg1   = DCSB1 + (cs * 4);
 		u32 *base0 = &pvt->csels[0].csbases[cs];
 		u32 *base1 = &pvt->csels[1].csbases[cs];
 
@@ -874,8 +874,8 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 	}
 
 	for_each_chip_select_mask(cs, 0, pvt) {
-		u32 reg0   = DCSM0 + (cs * 4);
-		u32 reg1   = DCSM1 + (cs * 4);
+		int reg0   = DCSM0 + (cs * 4);
+		int reg1   = DCSM1 + (cs * 4);
 		u32 *mask0 = &pvt->csels[0].csmasks[cs];
 		u32 *mask1 = &pvt->csels[1].csmasks[cs];
 
@@ -947,7 +947,7 @@ static u64 get_error_address(struct mce *m)
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
-	u32 off = range << 3;
+	int off = range << 3;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
-- 
1.7.4.rc2

