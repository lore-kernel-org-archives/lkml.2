Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2BCIVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:21:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54522 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2BCIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:21:05 -0500
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH] Fix potentially derefencing uninitialized 'r'.
Date: Fri,  3 Feb 2012 17:20:56 +0900
Message-Id: <1328257256-1296-1-git-send-email-geunsik.lim@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct memblock_region 'r' will not be initialized potentially
because of while statement's condition in __next_mem_pfn_range()function.
Initialize struct memblock_region data structure by default.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 77b5f22..867f5a2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -671,7 +671,7 @@ void __init_memblock __next_mem_pfn_range(int *idx, int nid,
 				unsigned long *out_end_pfn, int *out_nid)
 {
 	struct memblock_type *type = &memblock.memory;
-	struct memblock_region *r;
+	struct memblock_region *r = &type->regions[*idx];
 
 	while (++*idx < type->cnt) {
 		r = &type->regions[*idx];
-- 
1.7.8.1

