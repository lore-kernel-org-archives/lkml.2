Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0KHXTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:19:25 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18975 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0KHXTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:19:24 -0500
Date: Tue, 9 Nov 2010 00:07:57 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 01/17][trivial] powerpc: Remove unnecessary casts of void
 ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082307330.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from arch/powerpc/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pgtable_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index a87ead0..d1833ed 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -78,7 +78,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 	/* pgdir take page or two with 4K pages and a page fraction otherwise */
 #ifndef CONFIG_PPC_4K_PAGES
-	ret = (pgd_t *)kzalloc(1 << PGDIR_ORDER, GFP_KERNEL);
+	ret = kzalloc(1 << PGDIR_ORDER, GFP_KERNEL);
 #else
 	ret = (pgd_t *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 			PGDIR_ORDER - PAGE_SHIFT);



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

