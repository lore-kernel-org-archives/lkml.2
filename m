Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1FGW1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:27:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:16433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab1FGW1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:27:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="13205405"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, dan.j.williams@intel.com
Subject: [PATCH 5/5] Avoid section type conflict in dma/ioat/dma_v3.c
Date: Tue,  7 Jun 2011 15:26:33 -0700
Message-Id: <1307485593-27196-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

const __read_mostly is not legal and causes section type conflicts.
That's because the read.mostly section is not read only.
Simply drop the const for the read mostly fields.

Cc: dan.j.williams@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/dma/ioat/dma_v3.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index d845dc4..e1e052a 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -73,10 +73,10 @@
 /* provide a lookup table for setting the source address in the base or
  * extended descriptor of an xor or pq descriptor
  */
-static const u8 xor_idx_to_desc __read_mostly = 0xd0;
-static const u8 xor_idx_to_field[] __read_mostly = { 1, 4, 5, 6, 7, 0, 1, 2 };
-static const u8 pq_idx_to_desc __read_mostly = 0xf8;
-static const u8 pq_idx_to_field[] __read_mostly = { 1, 4, 5, 0, 1, 2, 4, 5 };
+static u8 xor_idx_to_desc __read_mostly = 0xd0;
+static u8 xor_idx_to_field[] __read_mostly = { 1, 4, 5, 6, 7, 0, 1, 2 };
+static u8 pq_idx_to_desc __read_mostly = 0xf8;
+static u8 pq_idx_to_field[] __read_mostly = { 1, 4, 5, 0, 1, 2, 4, 5 };
 
 static dma_addr_t xor_get_src(struct ioat_raw_descriptor *descs[2], int idx)
 {
-- 
1.7.4.4

