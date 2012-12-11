Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2LKRRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:17:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2LKRRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:17:49 -0500
Date: Tue, 11 Dec 2012 12:17:45 -0500
From: Dave Jones <davej@redhat.com>
To: linux-mm@kvack.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Print loaded modules when we encounter a bad page map.
Message-ID: <20121211171745.GA17489@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we see reports like https://bugzilla.redhat.com/show_bug.cgi?id=883576
it might be useful to know what modules had been loaded, so they can be compared
with similar reports to see if there is a common suspect.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/mm/memory.c b/mm/memory.c
index 221fc9f..7fc8c01 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/module.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -708,6 +709,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
 	if (vma->vm_file && vma->vm_file->f_op)
 		print_symbol(KERN_ALERT "vma->vm_file->f_op->mmap: %s\n",
 				(unsigned long)vma->vm_file->f_op->mmap);
+	print_modules();
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE);
 }
