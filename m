Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0JCN0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:26:14 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46015 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322Ab0JCN0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:26:13 -0400
Message-Id: <20101003132612.011159635@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 03 Oct 2010 08:26:05 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [Patch] alloc_large_system_hash printk overflow on 16TB boot.
References: <20101003132604.459149164@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=alloc_large_system_hash_overflow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot of a 16TB system, the following is printed:
Dentry cache hash table entries: -2147483648 (order: 22, 17179869184 bytes)

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: pv1010934/mm/page_alloc.c
===================================================================
--- pv1010934.orig/mm/page_alloc.c	2010-10-01 10:27:07.000000000 -0500
+++ pv1010934/mm/page_alloc.c	2010-10-03 07:53:13.551824924 -0500
@@ -5182,9 +5182,9 @@ void *__init alloc_large_system_hash(con
 	if (!table)
 		panic("Failed to allocate %s hash table\n", tablename);
 
-	printk(KERN_INFO "%s hash table entries: %d (order: %d, %lu bytes)\n",
+	printk(KERN_INFO "%s hash table entries: %ld (order: %d, %lu bytes)\n",
 	       tablename,
-	       (1U << log2qty),
+	       (1UL << log2qty),
 	       ilog2(size) - PAGE_SHIFT,
 	       size);
 

