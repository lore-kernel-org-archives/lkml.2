Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0HVKWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 06:22:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55630 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0HVKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 06:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OPm82rbhZ0/EQYE06J4sr5hktl4E7R+aG9qz4Uo80cK9GNAb12EvX3n4lR+/je0Fak
         z51EEM2WH+OL9W/RSdYYAgK3QKEEJrCYTGCqhzoTWfFjyBIfgGf3CVyfPjCV2yFARxAF
         YZabcs7Jq8lztSuEJO4bVE18beX02/izE7/lM=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ptrace: annotate lock context change on exit_ptrace()
Date: Sun, 22 Aug 2010 19:22:14 +0900
Message-Id: <1282472536-7430-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_ptrace() is called within tasklist_lock context and releases it and
reacquires but was missing proper annotations. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/ptrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f34d798..4afd9b8 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -329,6 +329,8 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
  * and reacquire the lock.
  */
 void exit_ptrace(struct task_struct *tracer)
+	__releases(&tasklist_lock)
+	__acquires(&tasklist_lock)
 {
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
-- 
1.7.0.4

