Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1A3Vmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 16:42:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55020 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1A3Vmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 16:42:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a/ROmX2q9Xgo6MrXmPaABofg7NXG2UDDdZjkZq1722UiP2GzQDSHb6aZVjisBuSd+m
         E0OqQcnXxXZv+oC5Iyf/hj9mzQgk/k/9HKXKsBzJCNSv6wDn3+u8BUCMG9YrbStf2jAt
         CMdIWhd/FTF+WYSd9RqvjFt1hJmdzfd+pvafQ=
From: Daniel Baluta <daniel.baluta@gmail.com>
To: viro@zeniv.linux.org.uk, trivial@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Baluta <daniel.baluta@gmail.com>
Subject: [PATCH] fs/eventpoll.c: fix spelling
Date: Sun, 30 Jan 2011 23:42:29 +0200
Message-Id: <1296423749-6814-1-git-send-email-daniel.baluta@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventpoll.c has wonderful comments but some annoying typos
sneaked in:
	* toepoll_ctl -> to epoll_ctl
	* rapresent -> represents
	* sructure -> structure
	* machanism -> mechanism
	* trasfering -> transferring

Signed-off-by: Daniel Baluta <daniel.baluta@gmail.com>
---
 fs/eventpoll.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index cc8a9b7..68bfc0b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -62,7 +62,7 @@
  * This mutex is acquired by ep_free() during the epoll file
  * cleanup path and it is also acquired by eventpoll_release_file()
  * if a file has been pushed inside an epoll set and it is then
- * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
+ * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
@@ -145,11 +145,11 @@ struct epitem {
 
 /*
  * This structure is stored inside the "private_data" member of the file
- * structure and rapresent the main data sructure for the eventpoll
+ * structure and represents the main data structure for the eventpoll
  * interface.
  */
 struct eventpoll {
-	/* Protect the this structure access */
+	/* Protect the access to this structure */
 	spinlock_t lock;
 
 	/*
@@ -783,7 +783,7 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
 
 /*
  * This is the callback that is passed to the wait queue wakeup
- * machanism. It is called by the stored file descriptors when they
+ * mechanism. It is called by the stored file descriptors when they
  * have events to report.
  */
 static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key)
@@ -814,9 +814,9 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 		goto out_unlock;
 
 	/*
-	 * If we are trasfering events to userspace, we can hold no locks
+	 * If we are transferring events to userspace, we can hold no locks
 	 * (because we're accessing user memory, and because of linux f_op->poll()
-	 * semantics). All the events that happens during that period of time are
+	 * semantics). All the events that happen during that period of time are
 	 * chained in ep->ovflist and requeued later on.
 	 */
 	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
-- 
1.7.1

