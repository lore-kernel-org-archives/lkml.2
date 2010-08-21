Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0HUQJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 12:09:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58646 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0HUQJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 12:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pRTc2E1qoHpN9moqmAv0VEE21w6IzE4X1lxbLwQSNVjuJx2j1fr2v96qgf2D39UHU6
         kkm2tslmGQQ4zFSA49gbT/sSJaaznIuxVzrJdiN3vc4VrS7zb3b8s52f3kd3lGGBYUhD
         uQtD3gHznNjaKxVQcwFmhzy7vo1D3b/lUN9CE=
From: Namhyung Kim <namhyung@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] signals: annotate lock context on ptrace_stop()
Date: Sun, 22 Aug 2010 01:09:02 +0900
Message-Id: <1282406942-18700-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_stop() is called within siglock context and releases it first and
reacquires but was missing proper annotations. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c423fc5..fc505a7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1621,6 +1621,8 @@ static int sigkill_pending(struct task_struct *tsk)
  * is gone, we keep current->exit_code unless clear_code.
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
+	__releases(&current->sighand->siglock)
+	__acquires(&current->sighand->siglock)
 {
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
-- 
1.7.0.4

