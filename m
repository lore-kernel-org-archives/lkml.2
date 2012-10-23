Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2JWIoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:44:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45537 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2JWIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:44:18 -0400
From: Anmol Sarma <unmole.in@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, arve@android.com,
        swetland@google.com, unmole.in@gmail.com
Subject: [PATCH] Staging: android: binder: Strings cleanup
Date: Tue, 23 Oct 2012 14:13:37 +0530
Message-Id: <1350981818-9984-1-git-send-email-unmole.in@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed all user visible multi-line stings to single line.
Removed 'binder:' prefix on strings.

Signed-off-by: Anmol Sarma <unmole.in@gmail.com>
---
 drivers/staging/android/binder.c |  311 ++++++++++++++++----------------------
 1 file changed, 127 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7b0ba92..628494a431 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/cacheflush.h>
 #include <linux/fdtable.h>
 #include <linux/file.h>
@@ -420,12 +422,12 @@ static void binder_set_nice(long nice)
 	}
 	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
 	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
-		     "binder: %d: nice value %ld not allowed use "
+		     "%d: nice value %ld not allowed use "
 		     "%ld instead\n", current->pid, nice, min_nice);
 	set_user_nice(current, min_nice);
 	if (min_nice < 20)
 		return;
-	binder_user_error("binder: %d RLIMIT_NICE not set\n", current->pid);
+	binder_user_error("%d RLIMIT_NICE not set\n", current->pid);
 }
 
 static size_t binder_buffer_size(struct binder_proc *proc,
@@ -452,7 +454,7 @@ static void binder_insert_free_buffer(struct binder_proc *proc,
 	new_buffer_size = binder_buffer_size(proc, new_buffer);
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: add free buffer, size %zd, "
+		     "%d: add free buffer, size %zd, "
 		     "at %p\n", proc->pid, new_buffer_size, new_buffer);
 
 	while (*p) {
@@ -531,7 +533,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 	struct mm_struct *mm;
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: %s pages %p-%p\n", proc->pid,
+		     "%d: %s pages %p-%p\n", proc->pid,
 		     allocate ? "allocate" : "free", start, end);
 
 	if (end <= start)
@@ -546,7 +548,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		down_write(&mm->mmap_sem);
 		vma = proc->vma;
 		if (vma && mm != proc->vma_vm_mm) {
-			pr_err("binder: %d: vma mm and task mm mismatch\n",
+			pr_err("%d: vma mm and task mm mismatch\n",
 				proc->pid);
 			vma = NULL;
 		}
@@ -556,8 +558,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		goto free_range;
 
 	if (vma == NULL) {
-		pr_err("binder: %d: binder_alloc_buf failed to "
-		       "map pages in userspace, no vma\n", proc->pid);
+		pr_err("%d: binder_alloc_buf failed to map pages in userspace, no vma\n",
+		 proc->pid);
 		goto err_no_vma;
 	}
 
@@ -569,8 +571,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (*page == NULL) {
-			pr_err("binder: %d: binder_alloc_buf failed "
-			       "for page at %p\n", proc->pid, page_addr);
+			pr_err("%d: binder_alloc_buf failed for page at %p\n",
+			 proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
 		tmp_area.addr = page_addr;
@@ -578,8 +580,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page_array_ptr = page;
 		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			pr_err("binder: %d: binder_alloc_buf failed "
-			       "to map page at %p in kernel\n",
+			pr_err("%d: binder_alloc_buf failed to map page at %p in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
@@ -587,8 +588,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 			(uintptr_t)page_addr + proc->user_buffer_offset;
 		ret = vm_insert_page(vma, user_page_addr, page[0]);
 		if (ret) {
-			pr_err("binder: %d: binder_alloc_buf failed "
-			       "to map page at %lx in userspace\n",
+			pr_err("%d: binder_alloc_buf failed to map page at %lx in userspace\n",
 			       proc->pid, user_page_addr);
 			goto err_vm_insert_page_failed;
 		}
@@ -636,7 +636,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 	size_t size;
 
 	if (proc->vma == NULL) {
-		pr_err("binder: %d: binder_alloc_buf, no vma\n",
+		pr_err("%d: binder_alloc_buf, no vma\n",
 		       proc->pid);
 		return NULL;
 	}
@@ -645,16 +645,16 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("binder: %d: got transaction with invalid "
-			"size %zd-%zd\n", proc->pid, data_size, offsets_size);
+		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
+				  proc->pid, data_size, offsets_size);
 		return NULL;
 	}
 
 	if (is_async &&
 	    proc->free_async_space < size + sizeof(struct binder_buffer)) {
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "binder: %d: binder_alloc_buf size %zd"
-			     "failed, no async space left\n", proc->pid, size);
+			     "%d: binder_alloc_buf size %zdfailed, no async space left\n",
+			      proc->pid, size);
 		return NULL;
 	}
 
@@ -674,8 +674,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		}
 	}
 	if (best_fit == NULL) {
-		pr_err("binder: %d: binder_alloc_buf size %zd failed, "
-		       "no address space\n", proc->pid, size);
+		pr_err("%d: binder_alloc_buf size %zd failed, no address space\n",
+			proc->pid, size);
 		return NULL;
 	}
 	if (n == NULL) {
@@ -684,8 +684,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 	}
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: binder_alloc_buf size %zd got buff"
-		     "er %p size %zd\n", proc->pid, size, buffer, buffer_size);
+		     "%d: binder_alloc_buf size %zd got buffer %p size %zd\n",
+		      proc->pid, size, buffer, buffer_size);
 
 	has_page_addr =
 		(void *)(((uintptr_t)buffer->data + buffer_size) & PAGE_MASK);
@@ -713,17 +713,16 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		binder_insert_free_buffer(proc, new_buffer);
 	}
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: binder_alloc_buf size %zd got "
-		     "%p\n", proc->pid, size, buffer);
+		     "%d: binder_alloc_buf size %zd got %p\n",
+		      proc->pid, size, buffer);
 	buffer->data_size = data_size;
 	buffer->offsets_size = offsets_size;
 	buffer->async_transaction = is_async;
 	if (is_async) {
 		proc->free_async_space -= size + sizeof(struct binder_buffer);
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
-			     "binder: %d: binder_alloc_buf size %zd "
-			     "async free %zd\n", proc->pid, size,
-			     proc->free_async_space);
+			     "%d: binder_alloc_buf size %zd async free %zd\n",
+			      proc->pid, size, proc->free_async_space);
 	}
 
 	return buffer;
@@ -754,7 +753,7 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 		if (buffer_end_page(prev) == buffer_end_page(buffer))
 			free_page_end = 0;
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "binder: %d: merge free, buffer %p "
+			     "%d: merge free, buffer %p "
 			     "share page with %p\n", proc->pid, buffer, prev);
 	}
 
@@ -767,7 +766,7 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 			    buffer_start_page(buffer))
 				free_page_start = 0;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "binder: %d: merge free, buffer"
+				     "%d: merge free, buffer"
 				     " %p share page with %p\n", proc->pid,
 				     buffer, prev);
 		}
@@ -775,7 +774,7 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 	list_del(&buffer->entry);
 	if (free_page_start || free_page_end) {
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "binder: %d: merge free, buffer %p do "
+			     "%d: merge free, buffer %p do "
 			     "not share page%s%s with with %p or %p\n",
 			     proc->pid, buffer, free_page_start ? "" : " end",
 			     free_page_end ? "" : " start", prev, next);
@@ -797,7 +796,7 @@ static void binder_free_buf(struct binder_proc *proc,
 		ALIGN(buffer->offsets_size, sizeof(void *));
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: binder_free_buf %p size %zd buffer"
+		     "%d: binder_free_buf %p size %zd buffer"
 		     "_size %zd\n", proc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
@@ -810,7 +809,7 @@ static void binder_free_buf(struct binder_proc *proc,
 		proc->free_async_space += size + sizeof(struct binder_buffer);
 
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
-			     "binder: %d: binder_free_buf size %zd "
+			     "%d: binder_free_buf size %zd "
 			     "async free %zd\n", proc->pid, size,
 			     proc->free_async_space);
 	}
@@ -894,7 +893,7 @@ static struct binder_node *binder_new_node(struct binder_proc *proc,
 	INIT_LIST_HEAD(&node->work.entry);
 	INIT_LIST_HEAD(&node->async_todo);
 	binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-		     "binder: %d:%d node %d u%p c%p created\n",
+		     "%d:%d node %d u%p c%p created\n",
 		     proc->pid, current->pid, node->debug_id,
 		     node->ptr, node->cookie);
 	return node;
@@ -909,8 +908,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			    node->internal_strong_refs == 0 &&
 			    !(node == binder_context_mgr_node &&
 			    node->has_strong_ref)) {
-				pr_err("binder: invalid inc strong "
-					"node for %d\n", node->debug_id);
+				pr_err("invalid inc strong node for %d\n",
+					node->debug_id);
 				return -EINVAL;
 			}
 			node->internal_strong_refs++;
@@ -925,8 +924,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			node->local_weak_refs++;
 		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
 			if (target_list == NULL) {
-				pr_err("binder: invalid inc weak node "
-					"for %d\n", node->debug_id);
+				pr_err("invalid inc weak node for %d\n",
+					node->debug_id);
 				return -EINVAL;
 			}
 			list_add_tail(&node->work.entry, target_list);
@@ -962,12 +961,12 @@ static int binder_dec_node(struct binder_node *node, int strong, int internal)
 			if (node->proc) {
 				rb_erase(&node->rb_node, &node->proc->nodes);
 				binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-					     "binder: refless node %d deleted\n",
+					     "refless node %d deleted\n",
 					     node->debug_id);
 			} else {
 				hlist_del(&node->dead_node);
 				binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-					     "binder: dead node %d deleted\n",
+					     "dead node %d deleted\n",
 					     node->debug_id);
 			}
 			kfree(node);
@@ -1053,12 +1052,12 @@ static struct binder_ref *binder_get_ref_for_node(struct binder_proc *proc,
 		hlist_add_head(&new_ref->node_entry, &node->refs);
 
 		binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-			     "binder: %d new ref %d desc %d for "
+			     "%d new ref %d desc %d for "
 			     "node %d\n", proc->pid, new_ref->debug_id,
 			     new_ref->desc, node->debug_id);
 	} else {
 		binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-			     "binder: %d new ref %d desc %d for "
+			     "%d new ref %d desc %d for "
 			     "dead node\n", proc->pid, new_ref->debug_id,
 			      new_ref->desc);
 	}
@@ -1068,7 +1067,7 @@ static struct binder_ref *binder_get_ref_for_node(struct binder_proc *proc,
 static void binder_delete_ref(struct binder_ref *ref)
 {
 	binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-		     "binder: %d delete ref %d desc %d for "
+		     "%d delete ref %d desc %d for "
 		     "node %d\n", ref->proc->pid, ref->debug_id,
 		     ref->desc, ref->node->debug_id);
 
@@ -1080,7 +1079,7 @@ static void binder_delete_ref(struct binder_ref *ref)
 	binder_dec_node(ref->node, 0, 1);
 	if (ref->death) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
-			     "binder: %d delete ref %d desc %d "
+			     "%d delete ref %d desc %d "
 			     "has death notification\n", ref->proc->pid,
 			     ref->debug_id, ref->desc);
 		list_del(&ref->death->work.entry);
@@ -1118,8 +1117,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 {
 	if (strong) {
 		if (ref->strong == 0) {
-			binder_user_error("binder: %d invalid dec strong, "
-					  "ref %d desc %d s %d w %d\n",
+			binder_user_error("%d invalid dec strong, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1133,8 +1131,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		}
 	} else {
 		if (ref->weak == 0) {
-			binder_user_error("binder: %d invalid dec weak, "
-					  "ref %d desc %d s %d w %d\n",
+			binder_user_error("%d invalid dec weak, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1179,8 +1176,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			}
 			if (target_thread->return_error == BR_OK) {
 				binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-					     "binder: send failed reply for "
-					     "transaction %d to %d:%d\n",
+					     "send failed reply for transaction %d to %d:%d\n",
 					      t->debug_id, target_thread->proc->pid,
 					      target_thread->pid);
 
@@ -1188,9 +1184,8 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 				target_thread->return_error = error_code;
 				wake_up_interruptible(&target_thread->wait);
 			} else {
-				pr_err("binder: reply failed, target "
-					"thread, %d:%d, has error code %d "
-					"already\n", target_thread->proc->pid,
+				pr_err("reply failed, target thread, %d:%d, has error code %d already\n",
+					target_thread->proc->pid,
 					target_thread->pid,
 					target_thread->return_error);
 			}
@@ -1199,20 +1194,20 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			struct binder_transaction *next = t->from_parent;
 
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-				     "binder: send failed reply "
+				     "send failed reply "
 				     "for transaction %d, target dead\n",
 				     t->debug_id);
 
 			binder_pop_transaction(target_thread, t);
 			if (next == NULL) {
 				binder_debug(BINDER_DEBUG_DEAD_BINDER,
-					     "binder: reply failed,"
+					     "reply failed,"
 					     " no target thread at root\n");
 				return;
 			}
 			t = next;
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: reply failed, no target "
+				     "reply failed, no target "
 				     "thread -- retry %d\n", t->debug_id);
 		}
 	}
@@ -1226,7 +1221,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	int debug_id = buffer->debug_id;
 
 	binder_debug(BINDER_DEBUG_TRANSACTION,
-		     "binder: %d buffer release %d, size %zd-%zd, failed at %p\n",
+		     "%d buffer release %d, size %zd-%zd, failed at %p\n",
 		     proc->pid, buffer->debug_id,
 		     buffer->data_size, buffer->offsets_size, failed_at);
 
@@ -1243,9 +1238,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			pr_err("binder: transaction release %d bad"
-					"offset %zd, size %zd\n", debug_id,
-					*offp, buffer->data_size);
+			pr_err("transaction release %d bad offset %zd, size %zd\n",
+				debug_id, *offp, buffer->data_size);
 			continue;
 		}
 		fp = (struct flat_binder_object *)(buffer->data + *offp);
@@ -1254,8 +1248,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_node *node = binder_get_node(proc, fp->binder);
 			if (node == NULL) {
-				pr_err("binder: transaction release %d"
-				       " bad node %p\n", debug_id, fp->binder);
+				pr_err("transaction release %d bad node %p\n",
+					debug_id, fp->binder);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1267,9 +1261,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				pr_err("binder: transaction release %d"
-				       " bad handle %ld\n", debug_id,
-				       fp->handle);
+				pr_err("transaction release %d bad handle %ld\n",
+					debug_id, fp->handle);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1286,8 +1279,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			break;
 
 		default:
-			pr_err("binder: transaction release %d bad "
-			       "object type %lx\n", debug_id, fp->type);
+			pr_err("transaction release %d bad object type %lx\n",
+				debug_id, fp->type);
 			break;
 		}
 	}
@@ -1320,17 +1313,14 @@ static void binder_transaction(struct binder_proc *proc,
 	if (reply) {
 		in_reply_to = thread->transaction_stack;
 		if (in_reply_to == NULL) {
-			binder_user_error("binder: %d:%d got reply transaction "
-					  "with no transaction stack\n",
+			binder_user_error("%d:%d got reply transaction with no transaction stack\n",
 					  proc->pid, thread->pid);
 			return_error = BR_FAILED_REPLY;
 			goto err_empty_call_stack;
 		}
 		binder_set_nice(in_reply_to->saved_priority);
 		if (in_reply_to->to_thread != thread) {
-			binder_user_error("binder: %d:%d got reply transaction "
-				"with bad transaction stack,"
-				" transaction %d has target %d:%d\n",
+			binder_user_error("%d:%d got reply transaction with bad transaction stack, transaction %d has target %d:%d\n",
 				proc->pid, thread->pid, in_reply_to->debug_id,
 				in_reply_to->to_proc ?
 				in_reply_to->to_proc->pid : 0,
@@ -1347,9 +1337,7 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_dead_binder;
 		}
 		if (target_thread->transaction_stack != in_reply_to) {
-			binder_user_error("binder: %d:%d got reply transaction "
-				"with bad target transaction stack %d, "
-				"expected %d\n",
+			binder_user_error("%d:%d got reply transaction with bad target transaction stack %d, expected %d\n",
 				proc->pid, thread->pid,
 				target_thread->transaction_stack ?
 				target_thread->transaction_stack->debug_id : 0,
@@ -1365,8 +1353,7 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_ref *ref;
 			ref = binder_get_ref(proc, tr->target.handle);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d got "
-					"transaction to invalid handle\n",
+				binder_user_error("%d:%d got transaction to invalid handle\n",
 					proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;
 				goto err_invalid_target_handle;
@@ -1389,9 +1376,7 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_transaction *tmp;
 			tmp = thread->transaction_stack;
 			if (tmp->to_thread != thread) {
-				binder_user_error("binder: %d:%d got new "
-					"transaction with bad transaction stack"
-					", transaction %d has target %d:%d\n",
+				binder_user_error("%d:%d got new transaction with bad transaction stack, transaction %d has target %d:%d\n",
 					proc->pid, thread->pid, tmp->debug_id,
 					tmp->to_proc ? tmp->to_proc->pid : 0,
 					tmp->to_thread ?
@@ -1436,7 +1421,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (reply)
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d BC_REPLY %d -> %d:%d, "
+			     "%d:%d BC_REPLY %d -> %d:%d, "
 			     "data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_thread->pid,
@@ -1444,7 +1429,7 @@ static void binder_transaction(struct binder_proc *proc,
 			     tr->data_size, tr->offsets_size);
 	else
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d BC_TRANSACTION %d -> "
+			     "%d:%d BC_TRANSACTION %d -> "
 			     "%d - node %d, data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_node->debug_id,
@@ -1477,20 +1462,19 @@ static void binder_transaction(struct binder_proc *proc,
 	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
 
 	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
-		binder_user_error("binder: %d:%d got transaction with invalid "
-			"data ptr\n", proc->pid, thread->pid);
+		binder_user_error("%d:%d got transaction with invalid data ptr\n",
+				proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (copy_from_user(offp, tr->data.ptr.offsets, tr->offsets_size)) {
-		binder_user_error("binder: %d:%d got transaction with invalid "
-			"offsets ptr\n", proc->pid, thread->pid);
+		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
+				proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
-		binder_user_error("binder: %d:%d got transaction with "
-			"invalid offsets size, %zd\n",
+		binder_user_error("%d:%d got transaction with invalid offsets size, %zd\n",
 			proc->pid, thread->pid, tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
@@ -1501,8 +1485,7 @@ static void binder_transaction(struct binder_proc *proc,
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			binder_user_error("binder: %d:%d got transaction with "
-				"invalid offset, %zd\n",
+			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
 				proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
@@ -1523,8 +1506,7 @@ static void binder_transaction(struct binder_proc *proc,
 				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("binder: %d:%d sending u%p "
-					"node %d, cookie mismatch %p != %p\n",
+				binder_user_error("%d:%d sending u%p node %d, cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					fp->binder, node->debug_id,
 					fp->cookie, node->cookie);
@@ -1552,10 +1534,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d got "
-					"transaction with invalid "
-					"handle, %ld\n", proc->pid,
-					thread->pid, fp->handle);
+				binder_user_error("%d:%d got transaction with invalid handle, %ld\n",
+				 proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_failed;
 			}
@@ -1593,13 +1573,13 @@ static void binder_transaction(struct binder_proc *proc,
 
 			if (reply) {
 				if (!(in_reply_to->flags & TF_ACCEPT_FDS)) {
-					binder_user_error("binder: %d:%d got reply with fd, %ld, but target does not allow fds\n",
+					binder_user_error("%d:%d got reply with fd, %ld, but target does not allow fds\n",
 						proc->pid, thread->pid, fp->handle);
 					return_error = BR_FAILED_REPLY;
 					goto err_fd_not_allowed;
 				}
 			} else if (!target_node->accept_fds) {
-				binder_user_error("binder: %d:%d got transaction with fd, %ld, but target does not allow fds\n",
+				binder_user_error("%d:%d got transaction with fd, %ld, but target does not allow fds\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fd_not_allowed;
@@ -1607,7 +1587,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			file = fget(fp->handle);
 			if (file == NULL) {
-				binder_user_error("binder: %d:%d got transaction with invalid fd, %ld\n",
+				binder_user_error("%d:%d got transaction with invalid fd, %ld\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
@@ -1626,8 +1606,7 @@ static void binder_transaction(struct binder_proc *proc,
 		} break;
 
 		default:
-			binder_user_error("binder: %d:%d got transactio"
-				"n with invalid object type, %lx\n",
+			binder_user_error("%d:%d got transaction with invalid object type, %lx\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
@@ -1683,7 +1662,7 @@ err_dead_binder:
 err_invalid_target_handle:
 err_no_context_mgr_node:
 	binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-		     "binder: %d:%d transaction failed %d, size %zd-%zd\n",
+		     "%d:%d transaction failed %d, size %zd-%zd\n",
 		     proc->pid, thread->pid, return_error,
 		     tr->data_size, tr->offsets_size);
 
@@ -1734,18 +1713,14 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {
-					binder_user_error("binder: %d:"
-						"%d tried to acquire "
-						"reference to desc 0, "
-						"got %d instead\n",
+					binder_user_error("%d:%d tried to acquire reference to desc 0, got %d instead\n",
 						proc->pid, thread->pid,
 						ref->desc);
 				}
 			} else
 				ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d refcou"
-					"nt change on invalid ref %d\n",
+				binder_user_error("%d:%d refcount change on invalid ref %d\n",
 					proc->pid, thread->pid, target);
 				break;
 			}
@@ -1769,7 +1744,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			binder_debug(BINDER_DEBUG_USER_REFS,
-				     "binder: %d:%d %s ref %d desc %d s %d w %d for node %d\n",
+				     "%d:%d %s ref %d desc %d s %d w %d for node %d\n",
 				     proc->pid, thread->pid, debug_string, ref->debug_id,
 				     ref->desc, ref->strong, ref->weak, ref->node->debug_id);
 			break;
@@ -1788,8 +1763,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			ptr += sizeof(void *);
 			node = binder_get_node(proc, node_ptr);
 			if (node == NULL) {
-				binder_user_error("binder: %d:%d "
-					"%s u%p no match\n",
+				binder_user_error("%d:%d %s u%p no match\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" :
@@ -1798,8 +1772,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("binder: %d:%d %s u%p node %d"
-					" cookie mismatch %p != %p\n",
+				binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
@@ -1809,9 +1782,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			if (cmd == BC_ACQUIRE_DONE) {
 				if (node->pending_strong_ref == 0) {
-					binder_user_error("binder: %d:%d "
-						"BC_ACQUIRE_DONE node %d has "
-						"no pending acquire request\n",
+					binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
 					break;
@@ -1819,9 +1790,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				node->pending_strong_ref = 0;
 			} else {
 				if (node->pending_weak_ref == 0) {
-					binder_user_error("binder: %d:%d "
-						"BC_INCREFS_DONE node %d has "
-						"no pending increfs request\n",
+					binder_user_error("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
 					break;
@@ -1830,17 +1799,17 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			binder_dec_node(node, cmd == BC_ACQUIRE_DONE, 0);
 			binder_debug(BINDER_DEBUG_USER_REFS,
-				     "binder: %d:%d %s node %d ls %d lw %d\n",
+				     "%d:%d %s node %d ls %d lw %d\n",
 				     proc->pid, thread->pid,
 				     cmd == BC_INCREFS_DONE ? "BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
 				     node->debug_id, node->local_strong_refs, node->local_weak_refs);
 			break;
 		}
 		case BC_ATTEMPT_ACQUIRE:
-			pr_err("binder: BC_ATTEMPT_ACQUIRE not supported\n");
+			pr_err("BC_ATTEMPT_ACQUIRE not supported\n");
 			return -EINVAL;
 		case BC_ACQUIRE_RESULT:
-			pr_err("binder: BC_ACQUIRE_RESULT not supported\n");
+			pr_err("BC_ACQUIRE_RESULT not supported\n");
 			return -EINVAL;
 
 		case BC_FREE_BUFFER: {
@@ -1853,20 +1822,17 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
-				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p no match\n",
+				binder_user_error("%d:%d BC_FREE_BUFFER u%p no match\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
-				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p matched "
-					"unreturned buffer\n",
+				binder_user_error("%d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_FREE_BUFFER,
-				     "binder: %d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
+				     "%d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
 				     proc->pid, thread->pid, data_ptr, buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
 
@@ -1899,19 +1865,15 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 		case BC_REGISTER_LOOPER:
 			binder_debug(BINDER_DEBUG_THREADS,
-				     "binder: %d:%d BC_REGISTER_LOOPER\n",
+				     "%d:%d BC_REGISTER_LOOPER\n",
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_ENTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_REGISTER_LOOPER called "
-					"after BC_ENTER_LOOPER\n",
+				binder_user_error("%d:%d ERROR: BC_REGISTER_LOOPER called after BC_ENTER_LOOPER\n",
 					proc->pid, thread->pid);
 			} else if (proc->requested_threads == 0) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_REGISTER_LOOPER called "
-					"without request\n",
+				binder_user_error("%d:%d ERROR: BC_REGISTER_LOOPER called without request\n",
 					proc->pid, thread->pid);
 			} else {
 				proc->requested_threads--;
@@ -1921,20 +1883,18 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			break;
 		case BC_ENTER_LOOPER:
 			binder_debug(BINDER_DEBUG_THREADS,
-				     "binder: %d:%d BC_ENTER_LOOPER\n",
+				     "%d:%d BC_ENTER_LOOPER\n",
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_REGISTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_ENTER_LOOPER called after "
-					"BC_REGISTER_LOOPER\n",
+				binder_user_error("%d:%d ERROR: BC_ENTER_LOOPER called after BC_REGISTER_LOOPER\n",
 					proc->pid, thread->pid);
 			}
 			thread->looper |= BINDER_LOOPER_STATE_ENTERED;
 			break;
 		case BC_EXIT_LOOPER:
 			binder_debug(BINDER_DEBUG_THREADS,
-				     "binder: %d:%d BC_EXIT_LOOPER\n",
+				     "%d:%d BC_EXIT_LOOPER\n",
 				     proc->pid, thread->pid);
 			thread->looper |= BINDER_LOOPER_STATE_EXITED;
 			break;
@@ -1954,8 +1914,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			ptr += sizeof(void *);
 			ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d %s "
-					"invalid ref %d\n",
+				binder_user_error("%d:%d %s invalid ref %d\n",
 					proc->pid, thread->pid,
 					cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 					"BC_REQUEST_DEATH_NOTIFICATION" :
@@ -1965,7 +1924,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "binder: %d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
+				     "%d:%d %s %p ref %d desc %d s %d w %d for node %d\n",
 				     proc->pid, thread->pid,
 				     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 				     "BC_REQUEST_DEATH_NOTIFICATION" :
@@ -1975,10 +1934,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
 				if (ref->death) {
-					binder_user_error("binder: %d:%"
-						"d BC_REQUEST_DEATH_NOTI"
-						"FICATION death notific"
-						"ation already set\n",
+					binder_user_error("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
 						proc->pid, thread->pid);
 					break;
 				}
@@ -1986,8 +1942,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				if (death == NULL) {
 					thread->return_error = BR_ERROR;
 					binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-						     "binder: %d:%d "
-						     "BC_REQUEST_DEATH_NOTIFICATION failed\n",
+						     "%d:%d BC_REQUEST_DEATH_NOTIFICATION failed\n",
 						     proc->pid, thread->pid);
 					break;
 				}
@@ -2006,20 +1961,13 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 			} else {
 				if (ref->death == NULL) {
-					binder_user_error("binder: %d:%"
-						"d BC_CLEAR_DEATH_NOTIFI"
-						"CATION death notificat"
-						"ion not active\n",
+					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
 						proc->pid, thread->pid);
 					break;
 				}
 				death = ref->death;
 				if (death->cookie != cookie) {
-					binder_user_error("binder: %d:%"
-						"d BC_CLEAR_DEATH_NOTIFI"
-						"CATION death notificat"
-						"ion cookie mismatch "
-						"%p != %p\n",
+					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %p != %p\n",
 						proc->pid, thread->pid,
 						death->cookie, cookie);
 					break;
@@ -2055,11 +2003,10 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: %d:%d BC_DEAD_BINDER_DONE %p found %p\n",
+				     "%d:%d BC_DEAD_BINDER_DONE %p found %p\n",
 				     proc->pid, thread->pid, cookie, death);
 			if (death == NULL) {
-				binder_user_error("binder: %d:%d BC_DEAD"
-					"_BINDER_DONE %p not found\n",
+				binder_user_error("%d:%d BC_DEAD_BINDER_DONE %p not found\n",
 					proc->pid, thread->pid, cookie);
 				break;
 			}
@@ -2077,7 +2024,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 		} break;
 
 		default:
-			pr_err("binder: %d:%d unknown command %d\n",
+			pr_err("%d:%d unknown command %d\n",
 			       proc->pid, thread->pid, cmd);
 			return -EINVAL;
 		}
@@ -2154,9 +2101,7 @@ retry:
 	if (wait_for_proc_work) {
 		if (!(thread->looper & (BINDER_LOOPER_STATE_REGISTERED |
 					BINDER_LOOPER_STATE_ENTERED))) {
-			binder_user_error("binder: %d:%d ERROR: Thread waiting "
-				"for process work before calling BC_REGISTER_"
-				"LOOPER or BC_ENTER_LOOPER (state %x)\n",
+			binder_user_error("%d:%d ERROR: Thread waiting for process work before calling BC_REGISTER_LOOPER or BC_ENTER_LOOPER (state %x)\n",
 				proc->pid, thread->pid, thread->looper);
 			wait_event_interruptible(binder_user_error_wait,
 						 binder_stop_on_user_error < 2);
@@ -2213,7 +2158,7 @@ retry:
 
 			binder_stat_br(proc, thread, cmd);
 			binder_debug(BINDER_DEBUG_TRANSACTION_COMPLETE,
-				     "binder: %d:%d BR_TRANSACTION_COMPLETE\n",
+				     "%d:%d BR_TRANSACTION_COMPLETE\n",
 				     proc->pid, thread->pid);
 
 			list_del(&w->entry);
@@ -2260,13 +2205,13 @@ retry:
 
 				binder_stat_br(proc, thread, cmd);
 				binder_debug(BINDER_DEBUG_USER_REFS,
-					     "binder: %d:%d %s %d u%p c%p\n",
+					     "%d:%d %s %d u%p c%p\n",
 					     proc->pid, thread->pid, cmd_name, node->debug_id, node->ptr, node->cookie);
 			} else {
 				list_del_init(&w->entry);
 				if (!weak && !strong) {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "binder: %d:%d node %d u%p c%p deleted\n",
+						     "%d:%d node %d u%p c%p deleted\n",
 						     proc->pid, thread->pid, node->debug_id,
 						     node->ptr, node->cookie);
 					rb_erase(&node->rb_node, &proc->nodes);
@@ -2274,7 +2219,7 @@ retry:
 					binder_stats_deleted(BINDER_STAT_NODE);
 				} else {
 					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "binder: %d:%d node %d u%p c%p state unchanged\n",
+						     "%d:%d node %d u%p c%p state unchanged\n",
 						     proc->pid, thread->pid, node->debug_id, node->ptr,
 						     node->cookie);
 				}
@@ -2298,7 +2243,7 @@ retry:
 				return -EFAULT;
 			ptr += sizeof(void *);
 			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
-				     "binder: %d:%d %s %p\n",
+				     "%d:%d %s %p\n",
 				      proc->pid, thread->pid,
 				      cmd == BR_DEAD_BINDER ?
 				      "BR_DEAD_BINDER" :
@@ -2366,7 +2311,7 @@ retry:
 
 		binder_stat_br(proc, thread, cmd);
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d %s %d %d:%d, cmd %d"
+			     "%d:%d %s %d %d:%d, cmd %d"
 			     "size %zd-%zd ptr %p-%p\n",
 			     proc->pid, thread->pid,
 			     (cmd == BR_TRANSACTION) ? "BR_TRANSACTION" :
@@ -2400,7 +2345,7 @@ done:
 	     /*spawn a new thread if we leave this out */) {
 		proc->requested_threads++;
 		binder_debug(BINDER_DEBUG_THREADS,
-			     "binder: %d:%d BR_SPAWN_LOOPER\n",
+			     "%d:%d BR_SPAWN_LOOPER\n",
 			     proc->pid, thread->pid);
 		if (put_user(BR_SPAWN_LOOPER, (uint32_t __user *)buffer))
 			return -EFAULT;
@@ -2482,7 +2427,7 @@ static int binder_free_thread(struct binder_proc *proc,
 	while (t) {
 		active_transactions++;
 		binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
-			     "binder: release %d:%d transaction %d "
+			     "release %d:%d transaction %d "
 			     "%s, still active\n", proc->pid, thread->pid,
 			     t->debug_id,
 			     (t->to_thread == thread) ? "in" : "out");
@@ -2572,7 +2517,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "binder: %d:%d write %ld at %08lx, read %ld at %08lx\n",
+			     "%d:%d write %ld at %08lx, read %ld at %08lx\n",
 			     proc->pid, thread->pid, bwr.write_size, bwr.write_buffer,
 			     bwr.read_size, bwr.read_buffer);
 
@@ -2596,7 +2541,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "binder: %d:%d wrote %ld of %ld, read return %ld of %ld\n",
+			     "%d:%d wrote %ld of %ld, read return %ld of %ld\n",
 			     proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
 			     bwr.read_consumed, bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
@@ -2613,14 +2558,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	case BINDER_SET_CONTEXT_MGR:
 		if (binder_context_mgr_node != NULL) {
-			pr_err("binder: BINDER_SET_CONTEXT_MGR already set\n");
+			pr_err("BINDER_SET_CONTEXT_MGR already set\n");
 			ret = -EBUSY;
 			goto err;
 		}
 		if (uid_valid(binder_context_mgr_uid)) {
 			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
-				pr_err("binder: BINDER_SET_"
-				       "CONTEXT_MGR bad uid %d != %d\n",
+				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
 				       from_kuid(&init_user_ns, current->cred->euid),
 				       from_kuid(&init_user_ns, binder_context_mgr_uid));
 				ret = -EPERM;
@@ -2639,7 +2583,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_context_mgr_node->has_weak_ref = 1;
 		break;
 	case BINDER_THREAD_EXIT:
-		binder_debug(BINDER_DEBUG_THREADS, "binder: %d:%d exit\n",
+		binder_debug(BINDER_DEBUG_THREADS, "%d:%d exit\n",
 			     proc->pid, thread->pid);
 		binder_free_thread(proc, thread);
 		thread = NULL;
@@ -2665,7 +2609,7 @@ err:
 	mutex_unlock(&binder_lock);
 	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
 	if (ret && ret != -ERESTARTSYS)
-		pr_info("binder: %d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
 	return ret;
 }
 
@@ -2673,7 +2617,7 @@ static void binder_vma_open(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
-		     "binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
+		     "%d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
 		     proc->pid, vma->vm_start, vma->vm_end,
 		     (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
 		     (unsigned long)pgprot_val(vma->vm_page_prot));
@@ -2683,7 +2627,7 @@ static void binder_vma_close(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
-		     "binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
+		     "%d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
 		     proc->pid, vma->vm_start, vma->vm_end,
 		     (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
 		     (unsigned long)pgprot_val(vma->vm_page_prot));
@@ -2924,7 +2868,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: node %d now dead, "
+				     "node %d now dead, "
 				     "refs %d, death %d\n", node->debug_id,
 				     incoming_refs, death);
 		}
@@ -2946,8 +2890,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		if (t) {
 			t->buffer = NULL;
 			buffer->transaction = NULL;
-			pr_err("binder: release proc %d, "
-			       "transaction %d, not freed\n",
+			pr_err("release proc %d, transaction %d, not freed\n",
 			       proc->pid, t->debug_id);
 			/*BUG();*/
 		}
-- 
1.7.9.5

