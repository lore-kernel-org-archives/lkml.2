Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2HSC6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:58:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:30195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab2HSC51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422069"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 44/74] lto: Mark functions used by the vsyscall init code visible
Date: Sat, 18 Aug 2012 19:56:40 -0700
Message-Id: <1345345030-22211-45-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The vsyscall code is compiled without LTO. This also includes
its init function. The function which are called by it have
to be visible, otherwise they could be optimized away

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/char/random.c |    2 +-
 include/linux/mm.h    |    1 +
 mm/vmalloc.c          |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b86eae9..33c8fe5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1450,7 +1450,7 @@ late_initcall(random_int_secret_init);
  * depleting entropy is too high
  */
 static DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash);
-unsigned int get_random_int(void)
+__visible unsigned int get_random_int(void)
 {
 	__u32 *hash;
 	unsigned int ret;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 311be90..d3ca155 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1413,6 +1413,7 @@ extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+__visible
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2bb90b1..286ea0c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1558,7 +1558,7 @@ EXPORT_SYMBOL(vunmap);
  *	Maps @count pages from @pages into contiguous kernel virtual
  *	space.
  */
-void *vmap(struct page **pages, unsigned int count,
+__visible void *vmap(struct page **pages, unsigned int count,
 		unsigned long flags, pgprot_t prot)
 {
 	struct vm_struct *area;
-- 
1.7.7.6

