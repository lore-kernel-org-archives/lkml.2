Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2DRJ13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:27:29 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60330 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2DRJ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:27:27 -0400
Message-ID: <1334741239.30072.7.camel@ThinkPad-T420>
Subject: [PATCH mm] limit the mm->map_count not greater than
 sysctl_max_map_count
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Date: Wed, 18 Apr 2012 05:27:19 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12041809-8256-0000-0000-00000208B759
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading the mmap codes, I found the checking of mm->map_count
against sysctl_max_map_count is not consistent. At some places, ">" is
used; at some other places, ">=" is used.

This patch changes ">" to ">=", so they are consistent, and makes sure
the value is not greater (one more) than sysctl_max_map_count.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mm/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index a7bf6a3..85f4816 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -987,7 +987,7 @@ unsigned long do_mmap_pgoff(struct file *file,
unsigned long addr,
                return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	/* Obtain the address to map to. we verify (or select) it and ensure
@@ -2193,7 +2193,7 @@ unsigned long do_brk(unsigned long addr, unsigned
long len)
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
-- 
1.7.6.5



