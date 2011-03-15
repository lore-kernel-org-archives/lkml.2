Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1CPViY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:38:24 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52511 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607Ab1CPViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:38:14 -0400
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chris Zankel <chris@zankel.net>
Cc: tglx@linutronix.de, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 2/2] xtensa/mm: remove WANT_PAGE_VIRTUAL
Date: Tue, 15 Mar 2011 22:49:33 +0100
Message-Id: <1300225773-3548-3-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1300225773-3548-1-git-send-email-sebastian@breakpoint.cc>
References: <1300225773-3548-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not usefull: it provides page->virtual and is used with
highmem. xtensa has no support for highmem and those HIGHMEM bits which are
found by grep are partly implemented. The interesting functions like kmap()
are missing. If someone actually implements the complete HIGHMEM support he
could use HASHED_PAGE_VIRTUAL like most others do.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/xtensa/include/asm/page.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 161bb89..7a5591a 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -171,10 +171,6 @@ extern void copy_user_page(void*, void*, unsigned long, struct page*);
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
-#ifdef CONFIG_MMU
-#define WANT_PAGE_VIRTUAL
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-- 
1.7.4.1

