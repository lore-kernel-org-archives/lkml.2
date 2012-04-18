Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2DRRZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:25:15 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33678 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2DRRZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:25:13 -0400
From: anirudh bhat <abhat38@gmail.com>
To: arve@android.com, dhowells@redhat.com, chris+android@zenthought.org,
        hpa@zytor.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        anirudh bhat <abhat38@gmail.com>
Subject: [PATCH 2/2] staging:android:fix line over 80 characters issue in binders.c this patch fixes line over 80 characters warning that was found using checkpatch.pl tool Signed-off-by:Anirudh Bhat <abhat38@gmail.com>
Date: Wed, 18 Apr 2012 22:54:54 +0530
Message-Id: <1334769894-6008-1-git-send-email-abhat38@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/android/binder.c |   59 +++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index c283212..ae341e0 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -644,8 +644,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		goto free_range;
 
 	if (vma == NULL) {
-		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
-		       "map pages in userspace, no vma\n", proc->pid);
+		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
+			proc->pid);
 		goto err_no_vma;
 	}
 
@@ -657,8 +657,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (*page == NULL) {
-			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
-			       "for page at %p\n", proc->pid, page_addr);
+			printk(KERN_ERR "binder: %d: binder_alloc_buf failed for page at %p\n",
+				proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
 		tmp_area.addr = page_addr;
@@ -666,18 +666,16 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page_array_ptr = page;
 		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
-			       "to map page at %p in kernel\n",
-			       proc->pid, page_addr);
+			printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map page at %p in kernel\n",
+				proc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
 		user_page_addr =
 			(uintptr_t)page_addr + proc->user_buffer_offset;
 		ret = vm_insert_page(vma, user_page_addr, page[0]);
 		if (ret) {
-			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
-			       "to map page at %lx in userspace\n",
-			       proc->pid, user_page_addr);
+			printk(KERN_ERR "binder: %d: binder_alloc_buf failed to map page at %lx in userspace\n",
+				proc->pid, user_page_addr);
 			goto err_vm_insert_page_failed;
 		}
 		/* vm_insert_page does not seem to increment the refcount */
@@ -733,8 +731,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("binder: %d: got transaction with invalid "
-			"size %zd-%zd\n", proc->pid, data_size, offsets_size);
+		binder_user_error("binder:%d:transaction with invalid size %zd-%zd\n",
+					proc->pid, data_size, offsets_size);
 		return NULL;
 	}
 
@@ -762,8 +760,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		}
 	}
 	if (best_fit == NULL) {
-		printk(KERN_ERR "binder: %d: binder_alloc_buf size %zd failed, "
-		       "no address space\n", proc->pid, size);
+		printk(KERN_ERR "binder: %d: binder_alloc_buf size %zd failed,no address space\n",
+			proc->pid, size);
 		return NULL;
 	}
 	if (n == NULL) {
@@ -997,8 +995,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			    node->internal_strong_refs == 0 &&
 			    !(node == binder_context_mgr_node &&
 			    node->has_strong_ref)) {
-				printk(KERN_ERR "binder: invalid inc strong "
-					"node for %d\n", node->debug_id);
+				printk(KERN_ERR "binder:invalid inc strong node for %d\n",
+					node->debug_id);
 				return -EINVAL;
 			}
 			node->internal_strong_refs++;
@@ -1013,8 +1011,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			node->local_weak_refs++;
 		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
 			if (target_list == NULL) {
-				printk(KERN_ERR "binder: invalid inc weak node "
-					"for %d\n", node->debug_id);
+				printk(KERN_ERR "binder: invalid inc weak node for %d\n",
+					node->debug_id);
 				return -EINVAL;
 			}
 			list_add_tail(&node->work.entry, target_list);
@@ -1206,10 +1204,11 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 {
 	if (strong) {
 		if (ref->strong == 0) {
-			binder_user_error("binder: %d invalid dec strong, "
-					  "ref %d desc %d s %d w %d\n",
-					  ref->proc->pid, ref->debug_id,
-					  ref->desc, ref->strong, ref->weak);
+			binder_user_error("binder:%d invalid dec strong,ref %d desc %d s %d w %d\n",
+						ref->proc->pid, ref->debug_id,
+						ref->desc,
+						ref->strong,
+						ref->weak);
 			return -EINVAL;
 		}
 		ref->strong--;
@@ -1221,10 +1220,12 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		}
 	} else {
 		if (ref->weak == 0) {
-			binder_user_error("binder: %d invalid dec weak, "
-					  "ref %d desc %d s %d w %d\n",
-					  ref->proc->pid, ref->debug_id,
-					  ref->desc, ref->strong, ref->weak);
+			binder_user_error("binder: %d invalid dec weak,ref %d desc %d s %d w %d\n",
+						ref->proc->pid,
+						ref->debug_id,
+						ref->desc,
+						ref->strong,
+						ref->weak);
 			return -EINVAL;
 		}
 		ref->weak--;
@@ -3303,7 +3304,7 @@ static void print_binder_proc(struct seq_file *m,
 		m->count = start_pos;
 }
 
-static const char *binder_return_strings[] = {
+static const char *const binder_return_strings[] = {
 	"BR_ERROR",
 	"BR_OK",
 	"BR_TRANSACTION",
@@ -3324,7 +3325,7 @@ static const char *binder_return_strings[] = {
 	"BR_FAILED_REPLY"
 };
 
-static const char *binder_command_strings[] = {
+static const char *const binder_command_strings[] = {
 	"BC_TRANSACTION",
 	"BC_REPLY",
 	"BC_ACQUIRE_RESULT",
@@ -3344,7 +3345,7 @@ static const char *binder_command_strings[] = {
 	"BC_DEAD_BINDER_DONE"
 };
 
-static const char *binder_objstat_strings[] = {
+static const char *const binder_objstat_strings[] = {
 	"proc",
 	"thread",
 	"node",
-- 
1.7.9.5

