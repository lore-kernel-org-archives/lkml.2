Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0IZDyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 23:54:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37674 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0IZDyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 23:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Iogc5qrFNF1Gt96LtfXZfGvouICkjG409QrsKAc1/whUKhC4VC/62xd88hbH7bvp3E
         46whRLo49+F86F+rMzMo35DM9nF3wlwV7535cbqhOYRfkQfYiNv43IheTz+lwFRc6ARU
         T0BsQRHM3lSFbsgZ+Qxfqol4UIDfFJW3OQnc4=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/2] ptrace: annotate lock context change on exit_ptrace()
Date: Sun, 26 Sep 2010 12:53:51 +0900
Message-Id: <1285473231-6229-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285473231-6229-1-git-send-email-namhyung@gmail.com>
References: <1285473231-6229-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_ptrace() releases and regrabs tasklist_lock but was missing
proper annotation. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Roland McGrath <roland@redhat.com>
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
1.7.2.2

