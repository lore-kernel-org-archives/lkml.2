Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2JHTC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:02:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2JHTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:02:55 -0400
From: Anmol Sarma <unmole.in@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, arve@android.com,
        Anmol Sarma <unmole.in@gmail.com>
Subject: [PATCH] Staging: android: binder: Fixed multi-line strings
Date: Tue,  9 Oct 2012 00:31:03 +0530
Message-Id: <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed all user visible multi-line stings to single line.

Signed-off-by: Anmol Sarma <unmole.in@gmail.com>
---
 drivers/staging/android/binder.c |  264 ++++++++++++++------------------------
 1 file changed, 99 insertions(+), 165 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7b0ba92..b9e6cd4 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -556,8 +556,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		goto free_range;
 
 	if (vma == NULL) {
-		pr_err("binder: %d: binder_alloc_buf failed to "
-		       "map pages in userspace, no vma\n", proc->pid);
+		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
+			proc->pid);
 		goto err_no_vma;
 	}
 
@@ -569,8 +569,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (*page == NULL) {
-			pr_err("binder: %d: binder_alloc_buf failed "
-			       "for page at %p\n", proc->pid, page_addr);
+			pr_err("binder: %d: binder_alloc_buf failed for page at %p\n",
+				proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
 		tmp_area.addr = page_addr;
@@ -578,8 +578,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page_array_ptr = page;
 		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			pr_err("binder: %d: binder_alloc_buf failed "
-			       "to map page at %p in kernel\n",
+			pr_err("binder: %d: binder_alloc_buf failed to map page at %p in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
 		}
@@ -587,8 +586,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 			(uintptr_t)page_addr + proc->user_buffer_offset;
 		ret = vm_insert_page(vma, user_page_addr, page[0]);
 		if (ret) {
-			pr_err("binder: %d: binder_alloc_buf failed "
-			       "to map page at %lx in userspace\n",
+			pr_err("binder: %d: binder_alloc_buf failed to map page at %lx in userspace\n",
 			       proc->pid, user_page_addr);
 			goto err_vm_insert_page_failed;
 		}
@@ -645,16 +643,16 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("binder: %d: got transaction with invalid "
-			"size %zd-%zd\n", proc->pid, data_size, offsets_size);
+		binder_user_error("binder: %d: got transaction with invalid size %zd-%zd\n",
+		 proc->pid, data_size, offsets_size);
 		return NULL;
 	}
 
 	if (is_async &&
 	    proc->free_async_space < size + sizeof(struct binder_buffer)) {
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "binder: %d: binder_alloc_buf size %zd"
-			     "failed, no async space left\n", proc->pid, size);
+			     "binder: %d: binder_alloc_buf size %zdfailed, no async space left\n",
+			      proc->pid, size);
 		return NULL;
 	}
 
@@ -674,8 +672,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		}
 	}
 	if (best_fit == NULL) {
-		pr_err("binder: %d: binder_alloc_buf size %zd failed, "
-		       "no address space\n", proc->pid, size);
+		pr_err("binder: %d: binder_alloc_buf size %zd failed, no address space\n",
+			proc->pid, size);
 		return NULL;
 	}
 	if (n == NULL) {
@@ -684,8 +682,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 	}
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: binder_alloc_buf size %zd got buff"
-		     "er %p size %zd\n", proc->pid, size, buffer, buffer_size);
+		     "binder: %d: binder_alloc_buf size %zd got buffer %p size %zd\n",
+		      proc->pid, size, buffer, buffer_size);
 
 	has_page_addr =
 		(void *)(((uintptr_t)buffer->data + buffer_size) & PAGE_MASK);
@@ -713,16 +711,16 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		binder_insert_free_buffer(proc, new_buffer);
 	}
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: binder_alloc_buf size %zd got "
-		     "%p\n", proc->pid, size, buffer);
+		     "binder: %d: binder_alloc_buf size %zd got %p\n",
+		      proc->pid, size, buffer);
 	buffer->data_size = data_size;
 	buffer->offsets_size = offsets_size;
 	buffer->async_transaction = is_async;
 	if (is_async) {
 		proc->free_async_space -= size + sizeof(struct binder_buffer);
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
-			     "binder: %d: binder_alloc_buf size %zd "
-			     "async free %zd\n", proc->pid, size,
+			     "binder: %d: binder_alloc_buf size %zd async free %zd\n",
+			     proc->pid, size,
 			     proc->free_async_space);
 	}
 
@@ -754,8 +752,8 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 		if (buffer_end_page(prev) == buffer_end_page(buffer))
 			free_page_end = 0;
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "binder: %d: merge free, buffer %p "
-			     "share page with %p\n", proc->pid, buffer, prev);
+			     "binder: %d: merge free, buffer %p share page with %p\n",
+			      proc->pid, buffer, prev);
 	}
 
 	if (!list_is_last(&buffer->entry, &proc->buffers)) {
@@ -767,16 +765,15 @@ static void binder_delete_free_buffer(struct binder_proc *proc,
 			    buffer_start_page(buffer))
 				free_page_start = 0;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "binder: %d: merge free, buffer"
-				     " %p share page with %p\n", proc->pid,
+				     "binder: %d: merge free, buffer %p share page with %p\n",
+				      proc->pid,
 				     buffer, prev);
 		}
 	}
 	list_del(&buffer->entry);
 	if (free_page_start || free_page_end) {
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-			     "binder: %d: merge free, buffer %p do "
-			     "not share page%s%s with with %p or %p\n",
+			     "binder: %d: merge free, buffer %p do not share page%s%s with with %p or %p\n",
 			     proc->pid, buffer, free_page_start ? "" : " end",
 			     free_page_end ? "" : " start", prev, next);
 		binder_update_page_range(proc, 0, free_page_start ?
@@ -797,8 +794,8 @@ static void binder_free_buf(struct binder_proc *proc,
 		ALIGN(buffer->offsets_size, sizeof(void *));
 
 	binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-		     "binder: %d: binder_free_buf %p size %zd buffer"
-		     "_size %zd\n", proc->pid, buffer, size, buffer_size);
+		     "binder: %d: binder_free_buf %p size %zd buffer_size %zd\n",
+		      proc->pid, buffer, size, buffer_size);
 
 	BUG_ON(buffer->free);
 	BUG_ON(size > buffer_size);
@@ -810,8 +807,8 @@ static void binder_free_buf(struct binder_proc *proc,
 		proc->free_async_space += size + sizeof(struct binder_buffer);
 
 		binder_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
-			     "binder: %d: binder_free_buf size %zd "
-			     "async free %zd\n", proc->pid, size,
+			     "binder: %d: binder_free_buf size %zd async free %zd\n",
+			     proc->pid, size,
 			     proc->free_async_space);
 	}
 
@@ -909,8 +906,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			    node->internal_strong_refs == 0 &&
 			    !(node == binder_context_mgr_node &&
 			    node->has_strong_ref)) {
-				pr_err("binder: invalid inc strong "
-					"node for %d\n", node->debug_id);
+				pr_err("binder: invalid inc strong node for %d\n",
+				node->debug_id);
 				return -EINVAL;
 			}
 			node->internal_strong_refs++;
@@ -925,8 +922,8 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			node->local_weak_refs++;
 		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
 			if (target_list == NULL) {
-				pr_err("binder: invalid inc weak node "
-					"for %d\n", node->debug_id);
+				pr_err("binder: invalid inc weak node for %d\n",
+				node->debug_id);
 				return -EINVAL;
 			}
 			list_add_tail(&node->work.entry, target_list);
@@ -1053,13 +1050,13 @@ static struct binder_ref *binder_get_ref_for_node(struct binder_proc *proc,
 		hlist_add_head(&new_ref->node_entry, &node->refs);
 
 		binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-			     "binder: %d new ref %d desc %d for "
-			     "node %d\n", proc->pid, new_ref->debug_id,
+			     "binder: %d new ref %d desc %d for node %d\n",
+			     proc->pid, new_ref->debug_id,
 			     new_ref->desc, node->debug_id);
 	} else {
 		binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-			     "binder: %d new ref %d desc %d for "
-			     "dead node\n", proc->pid, new_ref->debug_id,
+			     "binder: %d new ref %d desc %d for dead node\n",
+			      proc->pid, new_ref->debug_id,
 			      new_ref->desc);
 	}
 	return new_ref;
@@ -1068,8 +1065,8 @@ static struct binder_ref *binder_get_ref_for_node(struct binder_proc *proc,
 static void binder_delete_ref(struct binder_ref *ref)
 {
 	binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-		     "binder: %d delete ref %d desc %d for "
-		     "node %d\n", ref->proc->pid, ref->debug_id,
+		     "binder: %d delete ref %d desc %d for node %d\n",
+		     ref->proc->pid, ref->debug_id,
 		     ref->desc, ref->node->debug_id);
 
 	rb_erase(&ref->rb_node_desc, &ref->proc->refs_by_desc);
@@ -1080,8 +1077,8 @@ static void binder_delete_ref(struct binder_ref *ref)
 	binder_dec_node(ref->node, 0, 1);
 	if (ref->death) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
-			     "binder: %d delete ref %d desc %d "
-			     "has death notification\n", ref->proc->pid,
+			     "binder: %d delete ref %d desc %d has death notification\n",
+			     ref->proc->pid,
 			     ref->debug_id, ref->desc);
 		list_del(&ref->death->work.entry);
 		kfree(ref->death);
@@ -1118,8 +1115,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 {
 	if (strong) {
 		if (ref->strong == 0) {
-			binder_user_error("binder: %d invalid dec strong, "
-					  "ref %d desc %d s %d w %d\n",
+			binder_user_error("binder: %d invalid dec strong, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1133,8 +1129,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		}
 	} else {
 		if (ref->weak == 0) {
-			binder_user_error("binder: %d invalid dec weak, "
-					  "ref %d desc %d s %d w %d\n",
+			binder_user_error("binder: %d invalid dec weak, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1179,8 +1174,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			}
 			if (target_thread->return_error == BR_OK) {
 				binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-					     "binder: send failed reply for "
-					     "transaction %d to %d:%d\n",
+					     "binder: send failed reply for transaction %d to %d:%d\n",
 					      t->debug_id, target_thread->proc->pid,
 					      target_thread->pid);
 
@@ -1188,9 +1182,8 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 				target_thread->return_error = error_code;
 				wake_up_interruptible(&target_thread->wait);
 			} else {
-				pr_err("binder: reply failed, target "
-					"thread, %d:%d, has error code %d "
-					"already\n", target_thread->proc->pid,
+				pr_err("binder: reply failed, target thread, %d:%d, has error code %d already\n",
+					target_thread->proc->pid,
 					target_thread->pid,
 					target_thread->return_error);
 			}
@@ -1199,21 +1192,19 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			struct binder_transaction *next = t->from_parent;
 
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-				     "binder: send failed reply "
-				     "for transaction %d, target dead\n",
+				     "binder: send failed reply for transaction %d, target dead\n",
 				     t->debug_id);
 
 			binder_pop_transaction(target_thread, t);
 			if (next == NULL) {
 				binder_debug(BINDER_DEBUG_DEAD_BINDER,
-					     "binder: reply failed,"
-					     " no target thread at root\n");
+					     "binder: reply failed, no target thread at root\n");
 				return;
 			}
 			t = next;
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: reply failed, no target "
-				     "thread -- retry %d\n", t->debug_id);
+				     "binder: reply failed, no target thread -- retry %d\n",
+				      t->debug_id);
 		}
 	}
 }
@@ -1243,8 +1234,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			pr_err("binder: transaction release %d bad"
-					"offset %zd, size %zd\n", debug_id,
+			pr_err("binder: transaction release %d bad offset %zd, size %zd\n",
+				debug_id,
 					*offp, buffer->data_size);
 			continue;
 		}
@@ -1254,8 +1245,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_node *node = binder_get_node(proc, fp->binder);
 			if (node == NULL) {
-				pr_err("binder: transaction release %d"
-				       " bad node %p\n", debug_id, fp->binder);
+				pr_err("binder: transaction release %d bad node %p\n",
+					debug_id, fp->binder);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
@@ -1267,8 +1258,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				pr_err("binder: transaction release %d"
-				       " bad handle %ld\n", debug_id,
+				pr_err("binder: transaction release %d bad handle %ld\n",
+					debug_id,
 				       fp->handle);
 				break;
 			}
@@ -1286,8 +1277,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			break;
 
 		default:
-			pr_err("binder: transaction release %d bad "
-			       "object type %lx\n", debug_id, fp->type);
+			pr_err("binder: transaction release %d bad object type %lx\n",
+				debug_id, fp->type);
 			break;
 		}
 	}
@@ -1320,17 +1311,14 @@ static void binder_transaction(struct binder_proc *proc,
 	if (reply) {
 		in_reply_to = thread->transaction_stack;
 		if (in_reply_to == NULL) {
-			binder_user_error("binder: %d:%d got reply transaction "
-					  "with no transaction stack\n",
+			binder_user_error("binder: %d:%d got reply transaction with no transaction stack\n",
 					  proc->pid, thread->pid);
 			return_error = BR_FAILED_REPLY;
 			goto err_empty_call_stack;
 		}
 		binder_set_nice(in_reply_to->saved_priority);
 		if (in_reply_to->to_thread != thread) {
-			binder_user_error("binder: %d:%d got reply transaction "
-				"with bad transaction stack,"
-				" transaction %d has target %d:%d\n",
+			binder_user_error("binder: %d:%d got reply transaction with bad transaction stack, transaction %d has target %d:%d\n",
 				proc->pid, thread->pid, in_reply_to->debug_id,
 				in_reply_to->to_proc ?
 				in_reply_to->to_proc->pid : 0,
@@ -1347,9 +1335,7 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_dead_binder;
 		}
 		if (target_thread->transaction_stack != in_reply_to) {
-			binder_user_error("binder: %d:%d got reply transaction "
-				"with bad target transaction stack %d, "
-				"expected %d\n",
+			binder_user_error("binder: %d:%d got reply transaction with bad target transaction stack %d, expected %d\n",
 				proc->pid, thread->pid,
 				target_thread->transaction_stack ?
 				target_thread->transaction_stack->debug_id : 0,
@@ -1365,8 +1351,7 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_ref *ref;
 			ref = binder_get_ref(proc, tr->target.handle);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d got "
-					"transaction to invalid handle\n",
+				binder_user_error("binder: %d:%d got transaction to invalid handle\n",
 					proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;
 				goto err_invalid_target_handle;
@@ -1389,9 +1374,7 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_transaction *tmp;
 			tmp = thread->transaction_stack;
 			if (tmp->to_thread != thread) {
-				binder_user_error("binder: %d:%d got new "
-					"transaction with bad transaction stack"
-					", transaction %d has target %d:%d\n",
+				binder_user_error("binder: %d:%d got new transaction with bad transaction stack, transaction %d has target %d:%d\n",
 					proc->pid, thread->pid, tmp->debug_id,
 					tmp->to_proc ? tmp->to_proc->pid : 0,
 					tmp->to_thread ?
@@ -1436,16 +1419,14 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (reply)
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d BC_REPLY %d -> %d:%d, "
-			     "data %p-%p size %zd-%zd\n",
+			     "binder: %d:%d BC_REPLY %d -> %d:%d, data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_thread->pid,
 			     tr->data.ptr.buffer, tr->data.ptr.offsets,
 			     tr->data_size, tr->offsets_size);
 	else
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d BC_TRANSACTION %d -> "
-			     "%d - node %d, data %p-%p size %zd-%zd\n",
+			     "binder: %d:%d BC_TRANSACTION %d -> %d - node %d, data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_node->debug_id,
 			     tr->data.ptr.buffer, tr->data.ptr.offsets,
@@ -1477,20 +1458,17 @@ static void binder_transaction(struct binder_proc *proc,
 	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
 
 	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
-		binder_user_error("binder: %d:%d got transaction with invalid "
-			"data ptr\n", proc->pid, thread->pid);
+		binder_user_error("binder: %d:%d got transaction with invalid data ptr\n", proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (copy_from_user(offp, tr->data.ptr.offsets, tr->offsets_size)) {
-		binder_user_error("binder: %d:%d got transaction with invalid "
-			"offsets ptr\n", proc->pid, thread->pid);
+		binder_user_error("binder: %d:%d got transaction with invalid offsets ptr\n", proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
-		binder_user_error("binder: %d:%d got transaction with "
-			"invalid offsets size, %zd\n",
+		binder_user_error("binder: %d:%d got transaction with invalid offsets size, %zd\n",
 			proc->pid, thread->pid, tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
@@ -1501,8 +1479,7 @@ static void binder_transaction(struct binder_proc *proc,
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			binder_user_error("binder: %d:%d got transaction with "
-				"invalid offset, %zd\n",
+			binder_user_error("binder: %d:%d got transaction with invalid offset, %zd\n",
 				proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
@@ -1523,8 +1500,7 @@ static void binder_transaction(struct binder_proc *proc,
 				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("binder: %d:%d sending u%p "
-					"node %d, cookie mismatch %p != %p\n",
+				binder_user_error("binder: %d:%d sending u%p node %d, cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					fp->binder, node->debug_id,
 					fp->cookie, node->cookie);
@@ -1552,9 +1528,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d got "
-					"transaction with invalid "
-					"handle, %ld\n", proc->pid,
+				binder_user_error("binder: %d:%d got transaction with invalid handle, %ld\n",
+					proc->pid,
 					thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_failed;
@@ -1626,8 +1601,7 @@ static void binder_transaction(struct binder_proc *proc,
 		} break;
 
 		default:
-			binder_user_error("binder: %d:%d got transactio"
-				"n with invalid object type, %lx\n",
+			binder_user_error("binder: %d:%d got transaction with invalid object type, %lx\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
@@ -1734,18 +1708,14 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {
-					binder_user_error("binder: %d:"
-						"%d tried to acquire "
-						"reference to desc 0, "
-						"got %d instead\n",
+					binder_user_error("binder: %d:%d tried to acquire reference to desc 0, got %d instead\n",
 						proc->pid, thread->pid,
 						ref->desc);
 				}
 			} else
 				ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d refcou"
-					"nt change on invalid ref %d\n",
+				binder_user_error("binder: %d:%d refcount change on invalid ref %d\n",
 					proc->pid, thread->pid, target);
 				break;
 			}
@@ -1788,8 +1758,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			ptr += sizeof(void *);
 			node = binder_get_node(proc, node_ptr);
 			if (node == NULL) {
-				binder_user_error("binder: %d:%d "
-					"%s u%p no match\n",
+				binder_user_error("binder: %d:%d %s u%p no match\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" :
@@ -1798,8 +1767,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("binder: %d:%d %s u%p node %d"
-					" cookie mismatch %p != %p\n",
+				binder_user_error("binder: %d:%d %s u%p node %d cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
@@ -1809,9 +1777,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			if (cmd == BC_ACQUIRE_DONE) {
 				if (node->pending_strong_ref == 0) {
-					binder_user_error("binder: %d:%d "
-						"BC_ACQUIRE_DONE node %d has "
-						"no pending acquire request\n",
+					binder_user_error("binder: %d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
 					break;
@@ -1819,9 +1785,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				node->pending_strong_ref = 0;
 			} else {
 				if (node->pending_weak_ref == 0) {
-					binder_user_error("binder: %d:%d "
-						"BC_INCREFS_DONE node %d has "
-						"no pending increfs request\n",
+					binder_user_error("binder: %d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
 					break;
@@ -1853,15 +1817,12 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
-				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p no match\n",
+				binder_user_error("binder: %d:%d BC_FREE_BUFFER u%p no match\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
-				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p matched "
-					"unreturned buffer\n",
+				binder_user_error("binder: %d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
@@ -1903,15 +1864,11 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_ENTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_REGISTER_LOOPER called "
-					"after BC_ENTER_LOOPER\n",
+				binder_user_error("binder: %d:%d ERROR: BC_REGISTER_LOOPER called after BC_ENTER_LOOPER\n",
 					proc->pid, thread->pid);
 			} else if (proc->requested_threads == 0) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_REGISTER_LOOPER called "
-					"without request\n",
+				binder_user_error("binder: %d:%d ERROR: BC_REGISTER_LOOPER called without request\n",
 					proc->pid, thread->pid);
 			} else {
 				proc->requested_threads--;
@@ -1925,9 +1882,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_REGISTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_ENTER_LOOPER called after "
-					"BC_REGISTER_LOOPER\n",
+				binder_user_error("binder: %d:%d ERROR: BC_ENTER_LOOPER called after BC_REGISTER_LOOPER\n",
 					proc->pid, thread->pid);
 			}
 			thread->looper |= BINDER_LOOPER_STATE_ENTERED;
@@ -1954,8 +1909,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			ptr += sizeof(void *);
 			ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d %s "
-					"invalid ref %d\n",
+				binder_user_error("binder: %d:%d %s invalid ref %d\n",
 					proc->pid, thread->pid,
 					cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 					"BC_REQUEST_DEATH_NOTIFICATION" :
@@ -1975,10 +1929,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
 				if (ref->death) {
-					binder_user_error("binder: %d:%"
-						"d BC_REQUEST_DEATH_NOTI"
-						"FICATION death notific"
-						"ation already set\n",
+					binder_user_error("binder: %d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
 						proc->pid, thread->pid);
 					break;
 				}
@@ -1986,8 +1937,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				if (death == NULL) {
 					thread->return_error = BR_ERROR;
 					binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-						     "binder: %d:%d "
-						     "BC_REQUEST_DEATH_NOTIFICATION failed\n",
+						     "binder: %d:%d BC_REQUEST_DEATH_NOTIFICATION failed\n",
 						     proc->pid, thread->pid);
 					break;
 				}
@@ -2006,20 +1956,13 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 			} else {
 				if (ref->death == NULL) {
-					binder_user_error("binder: %d:%"
-						"d BC_CLEAR_DEATH_NOTIFI"
-						"CATION death notificat"
-						"ion not active\n",
+					binder_user_error("binder: %d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
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
+					binder_user_error("binder: %d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %p != %p\n",
 						proc->pid, thread->pid,
 						death->cookie, cookie);
 					break;
@@ -2058,8 +2001,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     "binder: %d:%d BC_DEAD_BINDER_DONE %p found %p\n",
 				     proc->pid, thread->pid, cookie, death);
 			if (death == NULL) {
-				binder_user_error("binder: %d:%d BC_DEAD"
-					"_BINDER_DONE %p not found\n",
+				binder_user_error("binder: %d:%d BC_DEAD_BINDER_DONE %p not found\n",
 					proc->pid, thread->pid, cookie);
 				break;
 			}
@@ -2154,9 +2096,7 @@ retry:
 	if (wait_for_proc_work) {
 		if (!(thread->looper & (BINDER_LOOPER_STATE_REGISTERED |
 					BINDER_LOOPER_STATE_ENTERED))) {
-			binder_user_error("binder: %d:%d ERROR: Thread waiting "
-				"for process work before calling BC_REGISTER_"
-				"LOOPER or BC_ENTER_LOOPER (state %x)\n",
+			binder_user_error("binder: %d:%d ERROR: Thread waiting for process work before calling BC_REGISTER_LOOPER or BC_ENTER_LOOPER (state %x)\n",
 				proc->pid, thread->pid, thread->looper);
 			wait_event_interruptible(binder_user_error_wait,
 						 binder_stop_on_user_error < 2);
@@ -2366,8 +2306,7 @@ retry:
 
 		binder_stat_br(proc, thread, cmd);
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d %s %d %d:%d, cmd %d"
-			     "size %zd-%zd ptr %p-%p\n",
+			     "binder: %d:%d %s %d %d:%d, cmd %d size %zd-%zd ptr %p-%p\n",
 			     proc->pid, thread->pid,
 			     (cmd == BR_TRANSACTION) ? "BR_TRANSACTION" :
 			     "BR_REPLY",
@@ -2482,8 +2421,7 @@ static int binder_free_thread(struct binder_proc *proc,
 	while (t) {
 		active_transactions++;
 		binder_debug(BINDER_DEBUG_DEAD_TRANSACTION,
-			     "binder: release %d:%d transaction %d "
-			     "%s, still active\n", proc->pid, thread->pid,
+			     "binder: release %d:%d transaction %d %s, still active\n", proc->pid, thread->pid,
 			     t->debug_id,
 			     (t->to_thread == thread) ? "in" : "out");
 
@@ -2619,8 +2557,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		if (uid_valid(binder_context_mgr_uid)) {
 			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
-				pr_err("binder: BINDER_SET_"
-				       "CONTEXT_MGR bad uid %d != %d\n",
+				pr_err("binder: BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
 				       from_kuid(&init_user_ns, current->cred->euid),
 				       from_kuid(&init_user_ns, binder_context_mgr_uid));
 				ret = -EPERM;
@@ -2744,7 +2681,8 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n",
+			 proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
@@ -2924,8 +2862,8 @@ static void binder_deferred_release(struct binder_proc *proc)
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: node %d now dead, "
-				     "refs %d, death %d\n", node->debug_id,
+				     "binder: node %d now dead, refs %d, death %d\n",
+				      node->debug_id,
 				     incoming_refs, death);
 		}
 	}
@@ -2946,8 +2884,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		if (t) {
 			t->buffer = NULL;
 			buffer->transaction = NULL;
-			pr_err("binder: release proc %d, "
-			       "transaction %d, not freed\n",
+			pr_err("binder: release proc %d, transaction %d, not freed\n",
 			       proc->pid, t->debug_id);
 			/*BUG();*/
 		}
@@ -2964,8 +2901,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 			if (proc->pages[i]) {
 				void *page_addr = proc->buffer + i * PAGE_SIZE;
 				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-					     "binder_release: %d: "
-					     "page %d at %p not freed\n",
+					     "binder_release: %d: page %d at %p not freed\n",
 					     proc->pid, i,
 					     page_addr);
 				unmap_kernel_range((unsigned long)page_addr,
@@ -2981,9 +2917,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 	put_task_struct(proc->tsk);
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
-		     "binder_release: %d threads %d, nodes %d (ref %d), "
-		     "refs %d, active transactions %d, buffers %d, "
-		     "pages %d\n",
+		     "binder_release: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d, buffers %d, pages %d\n",
 		     proc->pid, threads, nodes, incoming_refs, outgoing_refs,
 		     active_transactions, buffers, page_count);
 
-- 
1.7.9.5

