Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820Ab1IIWFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 18:05:43 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30732 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179Ab1IIWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 18:05:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1315605940!16950106!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/x86/kernel/ptrace.c: quiet sparse noise
Date: Fri, 9 Sep 2011 15:05:30 -0700
User-Agent: KMail/1.9.9
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <namhyung@gmail.com>, <akpm@linux-foundation.org>,
        <a.p.zijlstra@chello.nl>, <richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091505.30923.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ptrace_set_debugreg is only used in this file and should be
static. This quiets the following sparse warning:

warning: symbol 'ptrace_set_debugreg' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Weinberger <richard@nod.at>

---

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8252879..89a04c7 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -749,7 +749,8 @@ put:
 /*
  * Handle PTRACE_POKEUSR calls for the debug register area.
  */
-int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
+static int ptrace_set_debugreg(struct task_struct *tsk, int n,
+			       unsigned long val)
 {
 	struct thread_struct *thread = &(tsk->thread);
 	int rc = 0;
