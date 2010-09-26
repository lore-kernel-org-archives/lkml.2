Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab0IZS3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:29:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50380 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab0IZS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:29:03 -0400
Date: Sun, 26 Sep 2010 19:29:02 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] mn10300: get rid of set_fs(USER_DS) in sigframe setup
Cc: dhowells@redhat.com, torvalds@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1OzvyA-0002pg-84@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It really has no business being there; short of a serious kernel bug
we should already have USER_DS at that point.  It shouldn't have been
done on x86 either...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/kernel/signal.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 5a2c004..ae36480 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -333,8 +333,6 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->d0 = sig;
 	regs->d1 = (unsigned long) &frame->sc;
 
-	set_fs(USER_DS);
-
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
@@ -416,8 +414,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->d0 = sig;
 	regs->d1 = (long) &frame->info;
 
-	set_fs(USER_DS);
-
 	/* the tracer may want to single-step inside the handler */
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
-- 
1.5.6.5

