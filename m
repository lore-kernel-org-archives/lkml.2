Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935362Ab0HFFZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:25:44 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52889 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab0HFFPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:32 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 01/43] memblock: Fix memblock_is_region_reserved() to return a boolean
Date: Fri,  6 Aug 2010 15:14:42 +1000
Message-Id: <1281071724-28740-2-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers expect a boolean result which is true if the region
overlaps a reserved region. However, the implementation actually
returns -1 if there is no overlap, and a region index (0 based)
if there is.

Make it behave as callers (and common sense) expect.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 3024eb3..43840b3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -504,7 +504,7 @@ int __init memblock_is_reserved(u64 addr)
 
 int memblock_is_region_reserved(u64 base, u64 size)
 {
-	return memblock_overlaps_region(&memblock.reserved, base, size);
+	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
 /*
-- 
1.7.0.4

