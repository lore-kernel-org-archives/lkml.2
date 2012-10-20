Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2JTWdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:33:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58969 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2JTWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:33:31 -0400
From: "Ken O'Brien" <kernel@kenobrien.org>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        dhowells@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH 1/2] staging: android: checkpatch.pl fixes
Date: Sat, 20 Oct 2012 23:33:19 +0100
Message-Id: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all instances of strings spanning multiple lines from checkpatch.pl.

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/android/binder.c | 148 +++++++++++++++++++--------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7b0ba92..8607628 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -556,7 +556,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		goto free_range;
 
 	if (vma == NULL) {
-		pr_err("binder: %d: binder_alloc_buf failed to "
+		pr_err("binder: %d: binder_alloc_buf failed to " \
 		       "map pages in userspace, no vma\n", proc->pid);
 		goto err_no_vma;
 	}
@@ -569,7 +569,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		BUG_ON(*page);
 		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (*page == NULL) {
-			pr_err("binder: %d: binder_alloc_buf failed "
+			pr_err("binder: %d: binder_alloc_buf failed " \
 			       "for page at %p\n", proc->pid, page_addr);
 			goto err_alloc_page_failed;
 		}
@@ -578,7 +578,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page_array_ptr = page;
 		ret = map_vm_area(&tmp_area, PAGE_KERNEL, &page_array_ptr);
 		if (ret) {
-			pr_err("binder: %d: binder_alloc_buf failed "
+			pr_err("binder: %d: binder_alloc_buf failed " \
 			       "to map page at %p in kernel\n",
 			       proc->pid, page_addr);
 			goto err_map_kernel_failed;
@@ -587,7 +587,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 			(uintptr_t)page_addr + proc->user_buffer_offset;
 		ret = vm_insert_page(vma, user_page_addr, page[0]);
 		if (ret) {
-			pr_err("binder: %d: binder_alloc_buf failed "
+			pr_err("binder: %d: binder_alloc_buf failed " \
 			       "to map page at %lx in userspace\n",
 			       proc->pid, user_page_addr);
 			goto err_vm_insert_page_failed;
@@ -645,7 +645,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("binder: %d: got transaction with invalid "
+		binder_user_error("binder: %d: got transaction with invalid " \
 			"size %zd-%zd\n", proc->pid, data_size, offsets_size);
 		return NULL;
 	}
@@ -674,7 +674,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		}
 	}
 	if (best_fit == NULL) {
-		pr_err("binder: %d: binder_alloc_buf size %zd failed, "
+		pr_err("binder: %d: binder_alloc_buf size %zd failed, " \
 		       "no address space\n", proc->pid, size);
 		return NULL;
 	}
@@ -909,7 +909,7 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			    node->internal_strong_refs == 0 &&
 			    !(node == binder_context_mgr_node &&
 			    node->has_strong_ref)) {
-				pr_err("binder: invalid inc strong "
+				pr_err("binder: invalid inc strong " \
 					"node for %d\n", node->debug_id);
 				return -EINVAL;
 			}
@@ -925,7 +925,7 @@ static int binder_inc_node(struct binder_node *node, int strong, int internal,
 			node->local_weak_refs++;
 		if (!node->has_weak_ref && list_empty(&node->work.entry)) {
 			if (target_list == NULL) {
-				pr_err("binder: invalid inc weak node "
+				pr_err("binder: invalid inc weak node " \
 					"for %d\n", node->debug_id);
 				return -EINVAL;
 			}
@@ -1118,7 +1118,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 {
 	if (strong) {
 		if (ref->strong == 0) {
-			binder_user_error("binder: %d invalid dec strong, "
+			binder_user_error("binder: %d invalid dec strong, " \
 					  "ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
@@ -1133,7 +1133,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		}
 	} else {
 		if (ref->weak == 0) {
-			binder_user_error("binder: %d invalid dec weak, "
+			binder_user_error("binder: %d invalid dec weak, " \
 					  "ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
@@ -1179,7 +1179,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			}
 			if (target_thread->return_error == BR_OK) {
 				binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-					     "binder: send failed reply for "
+					     "binder: send failed reply for " \
 					     "transaction %d to %d:%d\n",
 					      t->debug_id, target_thread->proc->pid,
 					      target_thread->pid);
@@ -1188,7 +1188,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 				target_thread->return_error = error_code;
 				wake_up_interruptible(&target_thread->wait);
 			} else {
-				pr_err("binder: reply failed, target "
+				pr_err("binder: reply failed, target " \
 					"thread, %d:%d, has error code %d "
 					"already\n", target_thread->proc->pid,
 					target_thread->pid,
@@ -1199,20 +1199,20 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			struct binder_transaction *next = t->from_parent;
 
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-				     "binder: send failed reply "
+				     "binder: send failed reply " \
 				     "for transaction %d, target dead\n",
 				     t->debug_id);
 
 			binder_pop_transaction(target_thread, t);
 			if (next == NULL) {
 				binder_debug(BINDER_DEBUG_DEAD_BINDER,
-					     "binder: reply failed,"
+					     "binder: reply failed," \
 					     " no target thread at root\n");
 				return;
 			}
 			t = next;
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "binder: reply failed, no target "
+				     "binder: reply failed, no target " \
 				     "thread -- retry %d\n", t->debug_id);
 		}
 	}
@@ -1243,7 +1243,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			pr_err("binder: transaction release %d bad"
+			pr_err("binder: transaction release %d bad" \
 					"offset %zd, size %zd\n", debug_id,
 					*offp, buffer->data_size);
 			continue;
@@ -1254,7 +1254,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_node *node = binder_get_node(proc, fp->binder);
 			if (node == NULL) {
-				pr_err("binder: transaction release %d"
+				pr_err("binder: transaction release %d" \
 				       " bad node %p\n", debug_id, fp->binder);
 				break;
 			}
@@ -1267,7 +1267,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				pr_err("binder: transaction release %d"
+				pr_err("binder: transaction release %d" \
 				       " bad handle %ld\n", debug_id,
 				       fp->handle);
 				break;
@@ -1286,7 +1286,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			break;
 
 		default:
-			pr_err("binder: transaction release %d bad "
+			pr_err("binder: transaction release %d bad " \
 			       "object type %lx\n", debug_id, fp->type);
 			break;
 		}
@@ -1320,7 +1320,7 @@ static void binder_transaction(struct binder_proc *proc,
 	if (reply) {
 		in_reply_to = thread->transaction_stack;
 		if (in_reply_to == NULL) {
-			binder_user_error("binder: %d:%d got reply transaction "
+			binder_user_error("binder: %d:%d got reply transaction " \
 					  "with no transaction stack\n",
 					  proc->pid, thread->pid);
 			return_error = BR_FAILED_REPLY;
@@ -1328,8 +1328,8 @@ static void binder_transaction(struct binder_proc *proc,
 		}
 		binder_set_nice(in_reply_to->saved_priority);
 		if (in_reply_to->to_thread != thread) {
-			binder_user_error("binder: %d:%d got reply transaction "
-				"with bad transaction stack,"
+			binder_user_error("binder: %d:%d got reply transaction " \
+				"with bad transaction stack," \
 				" transaction %d has target %d:%d\n",
 				proc->pid, thread->pid, in_reply_to->debug_id,
 				in_reply_to->to_proc ?
@@ -1347,8 +1347,8 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_dead_binder;
 		}
 		if (target_thread->transaction_stack != in_reply_to) {
-			binder_user_error("binder: %d:%d got reply transaction "
-				"with bad target transaction stack %d, "
+			binder_user_error("binder: %d:%d got reply transaction " \
+				"with bad target transaction stack %d, " \
 				"expected %d\n",
 				proc->pid, thread->pid,
 				target_thread->transaction_stack ?
@@ -1365,7 +1365,7 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_ref *ref;
 			ref = binder_get_ref(proc, tr->target.handle);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d got "
+				binder_user_error("binder: %d:%d got " \
 					"transaction to invalid handle\n",
 					proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;
@@ -1389,8 +1389,8 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_transaction *tmp;
 			tmp = thread->transaction_stack;
 			if (tmp->to_thread != thread) {
-				binder_user_error("binder: %d:%d got new "
-					"transaction with bad transaction stack"
+				binder_user_error("binder: %d:%d got new " \
+					"transaction with bad transaction stack" \
 					", transaction %d has target %d:%d\n",
 					proc->pid, thread->pid, tmp->debug_id,
 					tmp->to_proc ? tmp->to_proc->pid : 0,
@@ -1436,7 +1436,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (reply)
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d BC_REPLY %d -> %d:%d, "
+			     "binder: %d:%d BC_REPLY %d -> %d:%d, " \
 			     "data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_thread->pid,
@@ -1444,7 +1444,7 @@ static void binder_transaction(struct binder_proc *proc,
 			     tr->data_size, tr->offsets_size);
 	else
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d BC_TRANSACTION %d -> "
+			     "binder: %d:%d BC_TRANSACTION %d -> " \
 			     "%d - node %d, data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_node->debug_id,
@@ -1477,19 +1477,19 @@ static void binder_transaction(struct binder_proc *proc,
 	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
 
 	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
-		binder_user_error("binder: %d:%d got transaction with invalid "
+		binder_user_error("binder: %d:%d got transaction with invalid " \
 			"data ptr\n", proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (copy_from_user(offp, tr->data.ptr.offsets, tr->offsets_size)) {
-		binder_user_error("binder: %d:%d got transaction with invalid "
+		binder_user_error("binder: %d:%d got transaction with invalid " \
 			"offsets ptr\n", proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
-		binder_user_error("binder: %d:%d got transaction with "
+		binder_user_error("binder: %d:%d got transaction with " \
 			"invalid offsets size, %zd\n",
 			proc->pid, thread->pid, tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
@@ -1501,7 +1501,7 @@ static void binder_transaction(struct binder_proc *proc,
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(void *))) {
-			binder_user_error("binder: %d:%d got transaction with "
+			binder_user_error("binder: %d:%d got transaction with " \
 				"invalid offset, %zd\n",
 				proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
@@ -1523,7 +1523,7 @@ static void binder_transaction(struct binder_proc *proc,
 				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("binder: %d:%d sending u%p "
+				binder_user_error("binder: %d:%d sending u%p " \
 					"node %d, cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					fp->binder, node->debug_id,
@@ -1552,8 +1552,8 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d got "
-					"transaction with invalid "
+				binder_user_error("binder: %d:%d got " \
+					"transaction with invalid " \
 					"handle, %ld\n", proc->pid,
 					thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
@@ -1626,7 +1626,7 @@ static void binder_transaction(struct binder_proc *proc,
 		} break;
 
 		default:
-			binder_user_error("binder: %d:%d got transactio"
+			binder_user_error("binder: %d:%d got transactio" \
 				"n with invalid object type, %lx\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
@@ -1734,9 +1734,9 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {
-					binder_user_error("binder: %d:"
-						"%d tried to acquire "
-						"reference to desc 0, "
+					binder_user_error("binder: %d:" \
+						"%d tried to acquire " \
+						"reference to desc 0, " \
 						"got %d instead\n",
 						proc->pid, thread->pid,
 						ref->desc);
@@ -1744,7 +1744,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			} else
 				ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d refcou"
+				binder_user_error("binder: %d:%d refcou" \
 					"nt change on invalid ref %d\n",
 					proc->pid, thread->pid, target);
 				break;
@@ -1788,7 +1788,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			ptr += sizeof(void *);
 			node = binder_get_node(proc, node_ptr);
 			if (node == NULL) {
-				binder_user_error("binder: %d:%d "
+				binder_user_error("binder: %d:%d " \
 					"%s u%p no match\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
@@ -1798,7 +1798,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("binder: %d:%d %s u%p node %d"
+				binder_user_error("binder: %d:%d %s u%p node %d" \
 					" cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
@@ -1809,8 +1809,8 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			if (cmd == BC_ACQUIRE_DONE) {
 				if (node->pending_strong_ref == 0) {
-					binder_user_error("binder: %d:%d "
-						"BC_ACQUIRE_DONE node %d has "
+					binder_user_error("binder: %d:%d " \
+						"BC_ACQUIRE_DONE node %d has " \
 						"no pending acquire request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
@@ -1819,8 +1819,8 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				node->pending_strong_ref = 0;
 			} else {
 				if (node->pending_weak_ref == 0) {
-					binder_user_error("binder: %d:%d "
-						"BC_INCREFS_DONE node %d has "
+					binder_user_error("binder: %d:%d " \
+						"BC_INCREFS_DONE node %d has " \
 						"no pending increfs request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
@@ -1853,14 +1853,14 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
-				binder_user_error("binder: %d:%d "
+				binder_user_error("binder: %d:%d " \
 					"BC_FREE_BUFFER u%p no match\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
-				binder_user_error("binder: %d:%d "
-					"BC_FREE_BUFFER u%p matched "
+				binder_user_error("binder: %d:%d " \
+					"BC_FREE_BUFFER u%p matched " \
 					"unreturned buffer\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
@@ -1903,14 +1903,14 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_ENTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_REGISTER_LOOPER called "
+				binder_user_error("binder: %d:%d ERROR:" \
+					" BC_REGISTER_LOOPER called " \
 					"after BC_ENTER_LOOPER\n",
 					proc->pid, thread->pid);
 			} else if (proc->requested_threads == 0) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_REGISTER_LOOPER called "
+				binder_user_error("binder: %d:%d ERROR:" \
+					" BC_REGISTER_LOOPER called " \
 					"without request\n",
 					proc->pid, thread->pid);
 			} else {
@@ -1925,8 +1925,8 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_REGISTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("binder: %d:%d ERROR:"
-					" BC_ENTER_LOOPER called after "
+				binder_user_error("binder: %d:%d ERROR:" \
+					" BC_ENTER_LOOPER called after " \
 					"BC_REGISTER_LOOPER\n",
 					proc->pid, thread->pid);
 			}
@@ -1954,7 +1954,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			ptr += sizeof(void *);
 			ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("binder: %d:%d %s "
+				binder_user_error("binder: %d:%d %s " \
 					"invalid ref %d\n",
 					proc->pid, thread->pid,
 					cmd == BC_REQUEST_DEATH_NOTIFICATION ?
@@ -1975,9 +1975,9 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
 				if (ref->death) {
-					binder_user_error("binder: %d:%"
-						"d BC_REQUEST_DEATH_NOTI"
-						"FICATION death notific"
+					binder_user_error("binder: %d:%" \
+						"d BC_REQUEST_DEATH_NOTI" \
+						"FICATION death notific" \
 						"ation already set\n",
 						proc->pid, thread->pid);
 					break;
@@ -1986,7 +1986,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				if (death == NULL) {
 					thread->return_error = BR_ERROR;
 					binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-						     "binder: %d:%d "
+						     "binder: %d:%d " \
 						     "BC_REQUEST_DEATH_NOTIFICATION failed\n",
 						     proc->pid, thread->pid);
 					break;
@@ -2006,19 +2006,19 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 			} else {
 				if (ref->death == NULL) {
-					binder_user_error("binder: %d:%"
-						"d BC_CLEAR_DEATH_NOTIFI"
-						"CATION death notificat"
+					binder_user_error("binder: %d:%" \
+						"d BC_CLEAR_DEATH_NOTIFI" \
+						"CATION death notificat" \
 						"ion not active\n",
 						proc->pid, thread->pid);
 					break;
 				}
 				death = ref->death;
 				if (death->cookie != cookie) {
-					binder_user_error("binder: %d:%"
-						"d BC_CLEAR_DEATH_NOTIFI"
-						"CATION death notificat"
-						"ion cookie mismatch "
+					binder_user_error("binder: %d:%" \
+						"d BC_CLEAR_DEATH_NOTIFI" \
+						"CATION death notificat" \
+						"ion cookie mismatch " \
 						"%p != %p\n",
 						proc->pid, thread->pid,
 						death->cookie, cookie);
@@ -2058,7 +2058,7 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     "binder: %d:%d BC_DEAD_BINDER_DONE %p found %p\n",
 				     proc->pid, thread->pid, cookie, death);
 			if (death == NULL) {
-				binder_user_error("binder: %d:%d BC_DEAD"
+				binder_user_error("binder: %d:%d BC_DEAD" \
 					"_BINDER_DONE %p not found\n",
 					proc->pid, thread->pid, cookie);
 				break;
@@ -2154,8 +2154,8 @@ retry:
 	if (wait_for_proc_work) {
 		if (!(thread->looper & (BINDER_LOOPER_STATE_REGISTERED |
 					BINDER_LOOPER_STATE_ENTERED))) {
-			binder_user_error("binder: %d:%d ERROR: Thread waiting "
-				"for process work before calling BC_REGISTER_"
+			binder_user_error("binder: %d:%d ERROR: Thread waiting " \
+				"for process work before calling BC_REGISTER_" \
 				"LOOPER or BC_ENTER_LOOPER (state %x)\n",
 				proc->pid, thread->pid, thread->looper);
 			wait_event_interruptible(binder_user_error_wait,
@@ -2366,7 +2366,7 @@ retry:
 
 		binder_stat_br(proc, thread, cmd);
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "binder: %d:%d %s %d %d:%d, cmd %d"
+			     "binder: %d:%d %s %d %d:%d, cmd %d" \
 			     "size %zd-%zd ptr %p-%p\n",
 			     proc->pid, thread->pid,
 			     (cmd == BR_TRANSACTION) ? "BR_TRANSACTION" :
@@ -2619,7 +2619,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 		if (uid_valid(binder_context_mgr_uid)) {
 			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
-				pr_err("binder: BINDER_SET_"
+				pr_err("binder: BINDER_SET_" \
 				       "CONTEXT_MGR bad uid %d != %d\n",
 				       from_kuid(&init_user_ns, current->cred->euid),
 				       from_kuid(&init_user_ns, binder_context_mgr_uid));
@@ -2946,7 +2946,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 		if (t) {
 			t->buffer = NULL;
 			buffer->transaction = NULL;
-			pr_err("binder: release proc %d, "
+			pr_err("binder: release proc %d, " \
 			       "transaction %d, not freed\n",
 			       proc->pid, t->debug_id);
 			/*BUG();*/
-- 
1.7.12.4

