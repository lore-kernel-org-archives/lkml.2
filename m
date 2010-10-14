Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0JNHkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:40:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:37608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0JNHkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:40:45 -0400
Date: Thu, 14 Oct 2010 07:39:58 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com,
        rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014031018.4100.64883.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031018.4100.64883.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Update document about irq disabled state in kprobe handler
Message-ID: <tip-0f55a2f3d496133dd22f1e4e49fb7301da87c7bb@git.kernel.org>
Git-Commit-ID: 0f55a2f3d496133dd22f1e4e49fb7301da87c7bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:39:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f55a2f3d496133dd22f1e4e49fb7301da87c7bb
Gitweb:     http://git.kernel.org/tip/0f55a2f3d496133dd22f1e4e49fb7301da87c7bb
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Oct 2010 12:10:18 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 08:55:27 +0200

kprobes: Update document about irq disabled state in kprobe handler

Update kprobes.txt about interrupts disabled state inside
kprobes handlers, because optimized probe/boosted kretprobe
run without disabling interrrupts on x86.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101014031018.4100.64883.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kprobes.txt |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 1762b81..741fe66 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -542,9 +542,11 @@ Kprobes does not use mutexes or allocate memory except during
 registration and unregistration.
 
 Probe handlers are run with preemption disabled.  Depending on the
-architecture, handlers may also run with interrupts disabled.  In any
-case, your handler should not yield the CPU (e.g., by attempting to
-acquire a semaphore).
+architecture and optimization state, handlers may also run with
+interrupts disabled (e.g., kretprobe handlers and optimized kprobe
+handlers run without interrupt disabled on x86/x86-64).  In any case,
+your handler should not yield the CPU (e.g., by attempting to acquire
+a semaphore).
 
 Since a return probe is implemented by replacing the return
 address with the trampoline's address, stack backtraces and calls
