Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0FHDut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:50:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2757 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab0FHDuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:46 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] arch/cris: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:33 -0700
Message-Id: <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And separate declaration from allocation
Still no error checking on failure, but it probably doesn't matter.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/cris/arch-v32/mm/intmem.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/cris/arch-v32/mm/intmem.c b/arch/cris/arch-v32/mm/intmem.c
index 9e8b69c..1b17d92 100644
--- a/arch/cris/arch-v32/mm/intmem.c
+++ b/arch/cris/arch-v32/mm/intmem.c
@@ -33,8 +33,8 @@ static void crisv32_intmem_init(void)
 {
 	static int initiated = 0;
 	if (!initiated) {
-		struct intmem_allocation* alloc =
-		  (struct intmem_allocation*)kmalloc(sizeof *alloc, GFP_KERNEL);
+		struct intmem_allocation* alloc;
+		alloc = kmalloc(sizeof *alloc, GFP_KERNEL);
 		INIT_LIST_HEAD(&intmem_allocations);
 		intmem_virtual = ioremap(MEM_INTMEM_START + RESERVED_SIZE,
 					 MEM_INTMEM_SIZE - RESERVED_SIZE);
@@ -62,9 +62,8 @@ void* crisv32_intmem_alloc(unsigned size, unsigned align)
 		if (allocation->status == STATUS_FREE &&
 		    allocation->size >= size + alignment) {
 			if (allocation->size > size + alignment) {
-				struct intmem_allocation* alloc =
-					(struct intmem_allocation*)
-					kmalloc(sizeof *alloc, GFP_ATOMIC);
+				struct intmem_allocation* alloc;
+				alloc = kmalloc(sizeof *alloc, GFP_ATOMIC);
 				alloc->status = STATUS_FREE;
 				alloc->size = allocation->size - size -
 					alignment;
@@ -74,9 +73,7 @@ void* crisv32_intmem_alloc(unsigned size, unsigned align)
 
 				if (alignment) {
 					struct intmem_allocation *tmp;
-					tmp = (struct intmem_allocation *)
-						kmalloc(sizeof *tmp,
-							GFP_ATOMIC);
+					tmp = kmalloc(sizeof *tmp, GFP_ATOMIC);
 					tmp->offset = allocation->offset;
 					tmp->size = alignment;
 					tmp->status = STATUS_FREE;
-- 
1.7.1.244.gbdc4

