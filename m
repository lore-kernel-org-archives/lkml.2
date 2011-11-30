Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab1K3CS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:18:28 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36067 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757653Ab1K3CS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:27 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/28] file: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:18 -0800
Message-Id: <6602085da94606147a643dc8516f1cf484a5e06e.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reflowed comments.  Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/file.c | \
  cut -f3- -d":" | sort | uniq -c

      1  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: space required before the open parenthesis '('
      4  WARNING: line over 80 characters

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/file.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index a88b110..7128878 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -45,8 +45,9 @@ static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 static void *alloc_fdmem(unsigned int size)
 {
 	/*
-	 * Very large allocations can stress page reclaim, so fall back to
-	 * vmalloc() if the allocation size will be considered "large" by the VM.
+	 * Very large allocations can stress page reclaim so
+	 * fall back to vmalloc() if the allocation size will
+	 * be considered "large" by the VM.
 	 */
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
 		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
@@ -78,7 +79,7 @@ static void free_fdtable_work(struct work_struct *work)
 	fdt = f->next;
 	f->next = NULL;
 	spin_unlock_bh(&f->lock);
-	while(fdt) {
+	while (fdt) {
 		struct fdtable *next = fdt->next;
 
 		__free_fdtable(fdt);
@@ -141,7 +142,7 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 	memset((char *)(nfdt->close_on_exec) + cpy, 0, set);
 }
 
-static struct fdtable * alloc_fdtable(unsigned int nr)
+static struct fdtable *alloc_fdtable(unsigned int nr)
 {
 	struct fdtable *fdt;
 	char *data;
@@ -157,9 +158,10 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	nr = roundup_pow_of_two(nr + 1);
 	nr *= (1024 / sizeof(struct file *));
 	/*
-	 * Note that this can drive nr *below* what we had passed if sysctl_nr_open
-	 * had been set lower between the check in expand_files() and here.  Deal
-	 * with that in caller, it's cheaper that way.
+	 * Note that this can drive nr *below* what we had passed
+	 * if sysctl_nr_open had been set lower between the check
+	 * in expand_files() and here.
+	 * Deal with that in caller, it's cheaper that way.
 	 *
 	 * We make sure that nr remains a multiple of BITS_PER_LONG - otherwise
 	 * bitmaps handling below becomes unpleasant, to put it mildly...
@@ -213,8 +215,9 @@ static int expand_fdtable(struct files_struct *files, int nr)
 	if (!new_fdt)
 		return -ENOMEM;
 	/*
-	 * extremely unlikely race - sysctl_nr_open decreased between the check in
-	 * caller and alloc_fdtable().  Cheaper to catch it here...
+	 * extremely unlikely race - sysctl_nr_open decreased
+	 * between the check in caller and alloc_fdtable().
+	 * Cheaper to catch it here...
 	 */
 	if (unlikely(new_fdt->max_fds <= nr)) {
 		__free_fdtable(new_fdt);
-- 
1.7.6.405.gc1be0

