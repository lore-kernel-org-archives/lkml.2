Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2JPLts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:49:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:28304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab2JPLsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:48:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="156713404"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-mm@kvack.org
Subject: [PATCHv3 4/6] mm: reuse kbasename() functionality
Date: Tue, 16 Oct 2012 14:48:12 +0300
Message-Id: <1350388094-18805-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-mm@kvack.org
---
 mm/memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5823f29..06158b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -58,6 +58,7 @@
 #include <linux/elf.h>
 #include <linux/gfp.h>
 #include <linux/migrate.h>
+#include <linux/string.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -4034,15 +4035,12 @@ void print_vma_addr(char *prefix, unsigned long ip)
 		struct file *f = vma->vm_file;
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		if (buf) {
-			char *p, *s;
+			char *p;
 
 			p = d_path(&f->f_path, buf, PAGE_SIZE);
 			if (IS_ERR(p))
 				p = "?";
-			s = strrchr(p, '/');
-			if (s)
-				p = s+1;
-			printk("%s%s[%lx+%lx]", prefix, p,
+			printk("%s%s[%lx+%lx]", prefix, kbasename(p),
 					vma->vm_start,
 					vma->vm_end - vma->vm_start);
 			free_page((unsigned long)buf);
-- 
1.7.10.4

