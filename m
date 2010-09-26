Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0IZDyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 23:54:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37674 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0IZDyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 23:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C4Opcj4J2zGKy24ryJK6CbXvKlurwZomuxabz7QpRfb7pUUdCi21tMaCeD9cucRWFL
         p01xEtsuTY746R8YTUUjAsxaZAAZdXyPIQXLPMr9h86yGw3zq9JjYcGlzCSqf/LMI8PR
         zoiNqqP7Zl1ikm2enGT5U+S4uey+fHvFksqlE=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/2] signals: annotate lock context change on ptrace_stop()
Date: Sun, 26 Sep 2010 12:53:50 +0900
Message-Id: <1285473231-6229-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_stop() releases and regrabs current->sighand->siglock but
was missing proper annotation. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index e4e8cfe..dce5c78 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1618,6 +1618,8 @@ static int sigkill_pending(struct task_struct *tsk)
  * is gone, we keep current->exit_code unless clear_code.
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
+	__releases(&current->sighand->siglock)
+	__acquires(&current->sighand->siglock)
 {
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
-- 
1.7.2.2

