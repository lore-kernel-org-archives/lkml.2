Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2FJOkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:40:33 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57765 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2FJOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:40:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Zankel <chris@zankel.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] xtensa: Use the declarations provided by <asm/sections.h>
Date: Sun, 10 Jun 2012 16:39:58 +0200
Message-Id: <1339339198-24789-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339339198-24789-1-git-send-email-geert@linux-m68k.org>
References: <1339339198-24789-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Include <asm/sections.h>,
  - Remove the (different) extern declarations,
  - Remove the no longer needed address-of ('&') operators,
  - Use %p to format pointer differences.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/xtensa/mm/init.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index c82af58..db95517 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -26,11 +26,7 @@
 
 #include <asm/bootparam.h>
 #include <asm/page.h>
-
-/* References to section boundaries */
-
-extern char _stext, _etext, _sdata, _edata, _rodata_end;
-extern char __init_begin, __init_end;
+#include <asm/sections.h>
 
 /*
  * mem_reserve(start, end, must_exist)
@@ -197,9 +193,9 @@ void __init mem_init(void)
 			reservedpages++;
 	}
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_sdata;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
+	codesize =  (unsigned long) _etext - (unsigned long) _stext;
+	datasize =  (unsigned long) _edata - (unsigned long) _sdata;
+	initsize =  (unsigned long) __init_end - (unsigned long) __init_begin;
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
 	       "%ldk data, %ldk init %ldk highmem)\n",
@@ -237,7 +233,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 
 void free_initmem(void)
 {
-	free_reserved_mem(&__init_begin, &__init_end);
-	printk("Freeing unused kernel memory: %dk freed\n",
-	       (&__init_end - &__init_begin) >> 10);
+	free_reserved_mem(__init_begin, __init_end);
+	printk("Freeing unused kernel memory: %zuk freed\n",
+	       (__init_end - __init_begin) >> 10);
 }
-- 
1.7.0.4

