Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1CAP1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:27:05 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58373 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab1CAP1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:27:01 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/8] amd64_edac: Drop local variable
Date: Tue,  1 Mar 2011 16:26:53 +0100
Message-Id: <1298993216-19434-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Use the macro directly instead

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2425332..9719f4a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1233,7 +1233,6 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
 	u64 chan_off;
 	u64 dram_base		= get_dram_base(pvt, range);
 	u64 hole_off		= f10_dhar_offset(pvt);
-	u32 hole_valid		= dhar_valid(pvt);
 	u64 dct_sel_base_off	= (pvt->dct_sel_hi & 0xFFFFFC00) << 16;
 
 	if (hi_rng) {
@@ -1250,7 +1249,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
 		 */
 		if ((!(dct_sel_base_addr >> 16) ||
 		     dct_sel_base_addr < dhar_base(pvt)) &&
-		    hole_valid &&
+		    dhar_valid(pvt) &&
 		    (sys_addr >= BIT_64(32)))
 			chan_off = hole_off;
 		else
@@ -1265,7 +1264,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
 		 * else
 		 *	remove dram base to normalize to DCT address
 		 */
-		if (hole_valid && (sys_addr >= BIT_64(32)))
+		if (dhar_valid(pvt) && (sys_addr >= BIT_64(32)))
 			chan_off = hole_off;
 		else
 			chan_off = dram_base;
-- 
1.7.4.rc2

