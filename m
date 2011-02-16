Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1BPWSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:18:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20378 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1BPWSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:18:49 -0500
Date: Wed, 16 Feb 2011 14:17:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Subject: [PATCH] docbook: add fs/eventfd.c kernel-doc
Message-Id: <20110216141755.a570694f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0202.4D5C4D46.01D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add fs/eventfd.c to filesystems docbook.
Make typo corrections in fs/eventfd.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 Documentation/DocBook/filesystems.tmpl |    5 +++++
 fs/eventfd.c                           |   12 ++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

--- lnx-2638-rc3.orig/Documentation/DocBook/filesystems.tmpl
+++ lnx-2638-rc3/Documentation/DocBook/filesystems.tmpl
@@ -82,6 +82,11 @@
      </sect1>
   </chapter>
 
+  <chapter id="fs_events">
+     <title>Events based on file descriptors</title>
+!Efs/eventfd.c
+  </chapter>
+
   <chapter id="sysfs">
      <title>The Filesystem for Exporting Kernel Objects</title>
 !Efs/sysfs/file.c
--- lnx-2638-rc3.orig/fs/eventfd.c
+++ lnx-2638-rc3/fs/eventfd.c
@@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(eventfd_ctx_get);
  * @ctx: [in] Pointer to eventfd context.
  *
  * The eventfd context reference must have been previously acquired either
- * with eventfd_ctx_get() or eventfd_ctx_fdget()).
+ * with eventfd_ctx_get() or eventfd_ctx_fdget().
  */
 void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
@@ -146,9 +146,9 @@ static void eventfd_ctx_do_read(struct e
  * eventfd_ctx_remove_wait_queue - Read the current counter and removes wait queue.
  * @ctx: [in] Pointer to eventfd context.
  * @wait: [in] Wait queue to be removed.
- * @cnt: [out] Pointer to the 64bit conter value.
+ * @cnt: [out] Pointer to the 64-bit counter value.
  *
- * Returns zero if successful, or the following error codes:
+ * Returns %0 if successful, or the following error codes:
  *
  * -EAGAIN      : The operation would have blocked.
  *
@@ -175,11 +175,11 @@ EXPORT_SYMBOL_GPL(eventfd_ctx_remove_wai
  * eventfd_ctx_read - Reads the eventfd counter or wait if it is zero.
  * @ctx: [in] Pointer to eventfd context.
  * @no_wait: [in] Different from zero if the operation should not block.
- * @cnt: [out] Pointer to the 64bit conter value.
+ * @cnt: [out] Pointer to the 64-bit counter value.
  *
- * Returns zero if successful, or the following error codes:
+ * Returns %0 if successful, or the following error codes:
  *
- * -EAGAIN      : The operation would have blocked but @no_wait was nonzero.
+ * -EAGAIN      : The operation would have blocked but @no_wait was non-zero.
  * -ERESTARTSYS : A signal interrupted the wait operation.
  *
  * If @no_wait is zero, the function might sleep until the eventfd internal
---
