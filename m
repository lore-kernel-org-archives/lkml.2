Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1EYJLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:11:06 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53100 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1EYJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:11:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/4] m68knommu: Make empty_zero_page "void *", like on m68k
Date: Wed, 25 May 2011 11:10:59 +0200
Message-Id: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to get rid of the casts.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/init_no.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
index 7cbd7bd..fdbe679 100644
--- a/arch/m68k/mm/init_no.c
+++ b/arch/m68k/mm/init_no.c
@@ -42,7 +42,7 @@
  * ZERO_PAGE is a special page that is used for zero-initialized
  * data and COW.
  */
-unsigned long empty_zero_page;
+void *empty_zero_page;
 
 extern unsigned long memory_start;
 extern unsigned long memory_end;
@@ -62,8 +62,8 @@ void __init paging_init(void)
 	unsigned long end_mem   = memory_end & PAGE_MASK;
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 
-	empty_zero_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
-	memset((void *)empty_zero_page, 0, PAGE_SIZE);
+	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
+	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	/*
 	 * Set up SFC/DFC registers (user data space).
-- 
1.7.0.4

