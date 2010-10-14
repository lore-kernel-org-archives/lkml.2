Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0JNDIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 23:08:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36811 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0JNDIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 23:08:09 -0400
X-AuditID: b753bd60-a9336ba000000226-52-4cb674179d5c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 1/5] [RESEND] kprobes: Update document about irq disabled
	state in kprobe handler
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Thu, 14 Oct 2010 12:10:18 +0900
Message-ID: <20101014031018.4100.64883.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kprobes.txt about interrupts disabled state inside
kprobes handlers, because optimized probe/boosted kretprobe
run without disabling interrrupts on x86.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
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

