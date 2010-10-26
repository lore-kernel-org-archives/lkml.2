Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab0JZVWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:22:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16634 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab0JZVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:22:21 -0400
Date: Tue, 26 Oct 2010 14:19:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] docbook: add idr/ida to kernel-api docbook
Message-Id: <20101026141908.7a1e0e60.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add idr/ida to kernel-api docbook.
Fix typos and kernel-doc notation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/DocBook/kernel-api.tmpl |    6 ++
 include/linux/idr.h                   |    1 
 lib/idr.c                             |   49 ++++++++++++------------
 3 files changed, 32 insertions(+), 24 deletions(-)

--- lnx-2636-g6-docs.orig/Documentation/DocBook/kernel-api.tmpl
+++ lnx-2636-g6-docs/Documentation/DocBook/kernel-api.tmpl
@@ -93,6 +93,12 @@ X!Ilib/string.c
 !Elib/crc32.c
 !Elib/crc-ccitt.c
      </sect1>
+
+     <sect1 id="idr"><title>idr/ida Functions</title>
+!Pinclude/linux/idr.h idr sync
+!Plib/idr.c IDA description
+!Elib/idr.c
+     </sect1>
   </chapter>
 
   <chapter id="mm">
--- lnx-2636-g6-docs.orig/include/linux/idr.h
+++ lnx-2636-g6-docs/include/linux/idr.h
@@ -81,6 +81,7 @@ struct idr {
 #define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
 
 /**
+ * DOC: idr sync
  * idr synchronization (stolen from radix-tree.h)
  *
  * idr_find() is able to be called locklessly, using RCU. The caller must
--- lnx-2636-g6-docs.orig/lib/idr.c
+++ lnx-2636-g6-docs/lib/idr.c
@@ -106,7 +106,7 @@ static void idr_mark_full(struct idr_lay
 }
 
 /**
- * idr_pre_get - reserver resources for idr allocation
+ * idr_pre_get - reserve resources for idr allocation
  * @idp:	idr handle
  * @gfp_mask:	memory allocation flags
  *
@@ -114,8 +114,8 @@ static void idr_mark_full(struct idr_lay
  * idr_get_new* functions. It preallocates enough memory to satisfy
  * the worst possible allocation.
  *
- * If the system is REALLY out of memory this function returns 0,
- * otherwise 1.
+ * If the system is REALLY out of memory this function returns %0,
+ * otherwise %1.
  */
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
@@ -290,11 +290,11 @@ static int idr_get_new_above_int(struct 
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
+ * If memory is required, it will return %-EAGAIN, you should unlock
  * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * return %-ENOSPC.
  *
- * @id returns a value in the range @starting_id ... 0x7fffffff
+ * @id returns a value in the range @starting_id ... %0x7fffffff
  */
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
@@ -321,11 +321,11 @@ EXPORT_SYMBOL(idr_get_new_above);
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
+ * If memory is required, it will return %-EAGAIN, you should unlock
  * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * return %-ENOSPC.
  *
- * @id returns a value in the range 0 ... 0x7fffffff
+ * @id returns a value in the range %0 ... %0x7fffffff
  */
 int idr_get_new(struct idr *idp, void *ptr, int *id)
 {
@@ -388,7 +388,7 @@ static void sub_remove(struct idr *idp, 
 }
 
 /**
- * idr_remove - remove the given id and free it's slot
+ * idr_remove - remove the given id and free its slot
  * @idp: idr handle
  * @id: unique key
  */
@@ -437,7 +437,7 @@ EXPORT_SYMBOL(idr_remove);
  * function will remove all id mappings and leave all idp_layers
  * unused.
  *
- * A typical clean-up sequence for objects stored in an idr tree, will
+ * A typical clean-up sequence for objects stored in an idr tree will
  * use idr_for_each() to free all objects, if necessay, then
  * idr_remove_all() to remove all ids, and idr_destroy() to free
  * up the cached idr_layers.
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(idr_find);
  * not allowed.
  *
  * We check the return of @fn each time. If it returns anything other
- * than 0, we break out and return that value.
+ * than %0, we break out and return that value.
  *
  * The caller must serialize idr_for_each() vs idr_get_new() and idr_remove().
  */
@@ -637,8 +637,8 @@ EXPORT_SYMBOL(idr_get_next);
  * @id: lookup key
  *
  * Replace the pointer registered with an id and return the old value.
- * A -ENOENT return indicates that @id was not found.
- * A -EINVAL return indicates that @id was not within valid constraints.
+ * A %-ENOENT return indicates that @id was not found.
+ * A %-EINVAL return indicates that @id was not within valid constraints.
  *
  * The caller must serialize with writers.
  */
@@ -696,10 +696,11 @@ void idr_init(struct idr *idp)
 EXPORT_SYMBOL(idr_init);
 
 
-/*
+/**
+ * DOC: IDA description
  * IDA - IDR based ID allocator
  *
- * this is id allocator without id -> pointer translation.  Memory
+ * This is id allocator without id -> pointer translation.  Memory
  * usage is much lower than full blown idr because each id only
  * occupies a bit.  ida uses a custom leaf node which contains
  * IDA_BITMAP_BITS slots.
@@ -732,8 +733,8 @@ static void free_bitmap(struct ida *ida,
  * following function.  It preallocates enough memory to satisfy the
  * worst possible allocation.
  *
- * If the system is REALLY out of memory this function returns 0,
- * otherwise 1.
+ * If the system is REALLY out of memory this function returns %0,
+ * otherwise %1.
  */
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
 {
@@ -765,11 +766,11 @@ EXPORT_SYMBOL(ida_pre_get);
  * Allocate new ID above or equal to @ida.  It should be called with
  * any required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
+ * If memory is required, it will return %-EAGAIN, you should unlock
  * and go back to the ida_pre_get() call.  If the ida is full, it will
- * return -ENOSPC.
+ * return %-ENOSPC.
  *
- * @p_id returns a value in the range @starting_id ... 0x7fffffff.
+ * @p_id returns a value in the range @starting_id ... %0x7fffffff.
  */
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
@@ -851,11 +852,11 @@ EXPORT_SYMBOL(ida_get_new_above);
  *
  * Allocate new ID.  It should be called with any required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
+ * If memory is required, it will return %-EAGAIN, you should unlock
  * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * return %-ENOSPC.
  *
- * @id returns a value in the range 0 ... 0x7fffffff.
+ * @id returns a value in the range %0 ... %0x7fffffff.
  */
 int ida_get_new(struct ida *ida, int *p_id)
 {
