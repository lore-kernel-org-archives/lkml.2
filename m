Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab0HEMfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:35:16 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40318 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab0HEMfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:35:12 -0400
X-AuditID: b753bd60-a98ddba000000a18-f7-4c5aaffecc9f
Message-ID: <4C5AAFF9.4030103@hitachi.com>
Date: Thu, 05 Aug 2010 21:35:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] kprobes: Update document about irq disabled state in
 kprobe handler
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kprobes.txt about interrupts disabled state inside
kprobes handlers, because optimized probe/boosted kretprobe
run without disabling interrrupts on x86.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
---

 Documentation/kprobes.txt |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 6653017..4189f01 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -541,9 +541,11 @@ Kprobes does not use mutexes or allocate memory except during
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


