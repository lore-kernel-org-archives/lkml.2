Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2FWGKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:10:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44570 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2FWGKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:10:37 -0400
From: Sherwin Soltani <sherwin@wybc.com>
To: greg@kroah.com
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sherwin Soltani <sherwin@wybc.com>
Subject: [PATCH] drivers: staging: android: fix binder.c printk macros
Date: Sat, 23 Jun 2012 02:09:41 -0400
Message-Id: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to pr_warn, pr_err, and pr_info macros and reformatted some
lines to bring them under the 80 column limit in the binder.c code.

Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
---
 drivers/staging/android/binder.c |   74 ++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index c283212..090d594 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -124,13 +124,13 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 #define binder_debug(mask, x...) \
 	do { \
 		if (binder_debug_mask & mask) \
-			printk(KERN_INFO x); \
+			pr_info(x); \
 	} while (0)
 
 #define binder_user_error(x...) \
 	do { \
 		if (binder_debug_mask & BINDER_DEBUG_USER_ERROR) \
-			printk(KERN_INFO x); \
+			pr_info(x); \
 		if (binder_stop_on_user_error) \
 			binder_stop_on_user_error = 2; \
 	} while (0)
@@ -418,7 +418,7 @@ repeat:
 #if 1
 	/* Sanity check */
 	if (fdt->fd[fd] != NULL) {
-		printk(KERN_WARNING "get_unused_fd: slot %d not NULL!\n", fd);
+		pr_warn("get_unused_fd: slot %d not NULL!\n", fd);
 		fdt->fd[fd] = NULL;
 	}
 #endif
@@ -644,7 +644,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		goto free_range;
 
 	if (vma == NULL) {
-		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
+		pr_err("binder: %d: binder_alloc_buf failed to "
 		       "map pages in userspace, no vma\n", proc->pid);
 		goto err_no_vma;
 	}
@@ -657,7 +657,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (*page == NULL) {
-			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
+			pr_err("binder: %d: binder_alloc_buf failed "
 			       "for page at %p\n", proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
@@ -666,7 +666,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page_array_ptr = page;
 		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
+			pr_err("binder: %d: binder_alloc_buf failed "
 			       "to map page at %p in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
@@ -675,7 +675,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 			(uintptr_t)page_addr + proc->user_buffer_offset;
 		ret = vm_insert_page(vma, user_page_addr, page[0]);
 		if (ret) {
-			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
+			pr_err("binder: %d: binder_alloc_buf failed "
 			       "to map page at %lx in userspace\n",
 			       proc->pid, user_page_addr);
 			goto err_vm_insert_page_failed;
@@ -724,7 +724,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 	size_t size;
 
 	if (proc->vma == NULL) {
-		printk(KERN_ERR "binder: %d: binder_alloc_buf, no vma\n",
+		pr_err("binder: %d: binder_alloc_buf, no vma\n",
 		       proc->pid);
 		return NULL;
 	}
@@ -762,7 +762,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		}
 	}
 	if (best_fit == NULL) {
-		printk(KERN_ERR "binder: %d: binder_alloc_buf size %zd failed, "
+		pr_err("binder: %d: binder_alloc_buf size %zd failed, "
 		       "no address space\n", proc->pid, size);
 		return NULL;
 	}
@@ -997,7 +997,7 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			    node->internal_strong_refs == 0 &&
 			    !(node == binder_context_mgr_node &&
 			    node->has_strong_ref)) {
-				printk(KERN_ERR "binder: invalid inc strong "
+				pr_err("binder: invalid inc strong "
 					"node for %d\n", node->debug_id);
 				return -EINVAL;
 			}
@@ -1013,8 +1013,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			node->local_weak_refs++;
 		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
 			if (target_list == NULL) {
-				printk(KERN_ERR "binder: invalid inc weak node "
-					"for %d\n", node->debug_id);
+				pr_err("binder: invalid inc weak node for %d\n",
+					node->debug_id);
 				return -EINVAL;
 			}
 			list_add_tail(&node->work.entry, target_list);
@@ -1276,7 +1276,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 				target_thread->return_error = error_code;
 				wake_up_interruptible(&target_thread->wait);
 			} else {
-				printk(KERN_ERR "binder: reply failed, target "
+				pr_err("binder: reply failed, target "
 					"thread, %d:%d, has error code %d "
 					"already\n", target_thread->proc->pid,
 					target_thread->pid,
@@ -1321,7 +1321,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	if (buffer->target_node)
 		binder_dec_node(buffer->target_node, 1, 0);
 
-	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
+	offp = (size_t *)(buffer->data +
+		ALIGN(buffer->data_size, sizeof(void *)));
 	if (failed_at)
 		off_end = failed_at;
 	else
@@ -1331,18 +1332,19 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			printk(KERN_ERR "binder: transaction release %d bad"
-					"offset %zd, size %zd\n", debug_id,
-					*offp, buffer->data_size);
+			pr_err("binder: transaction release %d bad"
+					"offset %zd, size %zd\n",
+					debug_id, *offp, buffer->data_size);
 			continue;
 		}
 		fp = (struct flat_binder_object *)(buffer->data + *offp);
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
-			struct binder_node *node = binder_get_node(proc, fp->binder);
+			struct binder_node *node =
+				binder_get_node(proc, fp->binder);
 			if (node == NULL) {
-				printk(KERN_ERR "binder: transaction release %d"
+				pr_err("binder: transaction release %d"
 				       " bad node %p\n", debug_id, fp->binder);
 				break;
 			}
@@ -1355,14 +1357,15 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				printk(KERN_ERR "binder: transaction release %d"
+				pr_err("binder: transaction release %d"
 				       " bad handle %ld\n", debug_id,
 				       fp->handle);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
 				     "        ref %d desc %d (node %d)\n",
-				     ref->debug_id, ref->desc, ref->node->debug_id);
+				     ref->debug_id, ref->desc,
+				     ref->node->debug_id);
 			binder_dec_ref(ref, fp->type == BINDER_TYPE_HANDLE);
 		} break;
 
@@ -1374,7 +1377,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			break;
 
 		default:
-			printk(KERN_ERR "binder: transaction release %d bad "
+			pr_err("binder: transaction release %d bad "
 			       "object type %lx\n", debug_id, fp->type);
 			break;
 		}
@@ -1925,10 +1928,10 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			break;
 		}
 		case BC_ATTEMPT_ACQUIRE:
-			printk(KERN_ERR "binder: BC_ATTEMPT_ACQUIRE not supported\n");
+			pr_err("binder: BC_ATTEMPT_ACQUIRE not supported\n");
 			return -EINVAL;
 		case BC_ACQUIRE_RESULT:
-			printk(KERN_ERR "binder: BC_ACQUIRE_RESULT not supported\n");
+			pr_err("binder: BC_ACQUIRE_RESULT not supported\n");
 			return -EINVAL;
 
 		case BC_FREE_BUFFER: {
@@ -2165,7 +2168,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 		} break;
 
 		default:
-			printk(KERN_ERR "binder: %d:%d unknown command %d\n",
+			pr_err("binder: %d:%d unknown command %d\n",
 			       proc->pid, thread->pid, cmd);
 			return -EINVAL;
 		}
@@ -2254,7 +2257,8 @@ retry:
 			if (!binder_has_proc_work(proc, thread))
 				ret = -EAGAIN;
 		} else
-			ret = wait_event_interruptible_exclusive(proc->wait, binder_has_proc_work(proc, thread));
+			ret = wait_event_interruptible_exclusive(proc->wait,
+				binder_has_proc_work(proc, thread));
 	} else {
 		if (non_block) {
 			if (!binder_has_thread_work(thread))
@@ -2635,7 +2639,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
 
-	/*printk(KERN_INFO "binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
+	/*pr_err("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
 
 	ret = wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
 	if (ret)
@@ -2701,13 +2705,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	case BINDER_SET_CONTEXT_MGR:
 		if (binder_context_mgr_node != NULL) {
-			printk(KERN_ERR "binder: BINDER_SET_CONTEXT_MGR already set\n");
+			pr_err("binder: BINDER_SET_CONTEXT_MGR already set\n");
 			ret = -EBUSY;
 			goto err;
 		}
 		if (binder_context_mgr_uid != -1) {
 			if (binder_context_mgr_uid != current->cred->euid) {
-				printk(KERN_ERR "binder: BINDER_SET_"
+				pr_err("binder: BINDER_SET_"
 				       "CONTEXT_MGR bad uid %d != %d\n",
 				       current->cred->euid,
 				       binder_context_mgr_uid);
@@ -2753,7 +2757,7 @@ err:
 	mutex_unlock(&binder_lock);
 	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
 	if (ret && ret != -ERESTARTSYS)
-		printk(KERN_INFO "binder: %d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+		pr_info("binder: %d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
 	return ret;
 }
 
@@ -2829,7 +2833,9 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			printk(KERN_INFO "binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n",
+				proc->pid, vma->vm_start,
+				vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
@@ -2861,7 +2867,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	proc->vma = vma;
 	proc->vma_vm_mm = vma->vm_mm;
 
-	/*printk(KERN_INFO "binder_mmap: %d %lx-%lx maps %p\n",
+	/*pr_info("binder_mmap: %d %lx-%lx maps %p\n",
 		 proc->pid, vma->vm_start, vma->vm_end, proc->buffer);*/
 	return 0;
 
@@ -2876,7 +2882,7 @@ err_get_vm_area_failed:
 err_already_mapped:
 	mutex_unlock(&binder_mmap_lock);
 err_bad_arg:
-	printk(KERN_ERR "binder_mmap: %d %lx-%lx %s failed %d\n",
+	pr_err("binder_mmap: %d %lx-%lx %s failed %d\n",
 	       proc->pid, vma->vm_start, vma->vm_end, failure_string, ret);
 	return ret;
 }
@@ -3031,7 +3037,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		if (t) {
 			t->buffer = NULL;
 			buffer->transaction = NULL;
-			printk(KERN_ERR "binder: release proc %d, "
+			pr_err("binder: release proc %d, "
 			       "transaction %d, not freed\n",
 			       proc->pid, t->debug_id);
 			/*BUG();*/
-- 
1.7.9.5

