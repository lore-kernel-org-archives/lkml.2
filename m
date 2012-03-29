Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab2C2Qsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:48:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836Ab2C2Qsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:48:47 -0400
Date: Thu, 29 Mar 2012 09:48:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
Message-ID: <20120329164842.GE28941@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cb129820f1e6ccf309510f4eb28df45cb0742005 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 29 Mar 2012 09:45:58 -0700

pcpu_dump_alloc_info() was printing continued lines without KERN_CONT.
Use it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kay Sievers <kay.sievers@vrfy.org>
---
Committed to percpu/for-3.4-fixes.

Thanks.

 mm/percpu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f47af91..f921fdf 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1132,20 +1132,20 @@ static void pcpu_dump_alloc_info(const char *lvl,
 		for (alloc_end += gi->nr_units / upa;
 		     alloc < alloc_end; alloc++) {
 			if (!(alloc % apl)) {
-				printk("\n");
+				printk(KERN_CONT "\n");
 				printk("%spcpu-alloc: ", lvl);
 			}
-			printk("[%0*d] ", group_width, group);
+			printk(KERN_CONT "[%0*d] ", group_width, group);
 
 			for (unit_end += upa; unit < unit_end; unit++)
 				if (gi->cpu_map[unit] != NR_CPUS)
-					printk("%0*d ", cpu_width,
+					printk(KERN_CONT "%0*d ", cpu_width,
 					       gi->cpu_map[unit]);
 				else
-					printk("%s ", empty_str);
+					printk(KERN_CONT "%s ", empty_str);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 /**
-- 
1.7.7.3

