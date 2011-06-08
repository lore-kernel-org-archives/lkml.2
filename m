Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1FHH27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:28:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58797 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1FHH24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:28:56 -0400
X-AuditID: b753bd60-a467eba0000050a4-48-4def24b302ba
X-AuditID: b753bd60-a467eba0000050a4-48-4def24b302ba
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 0/3] Support stacktrace with dynamic event
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org
Date: Wed, 08 Jun 2011 16:09:13 +0900
Message-ID: <20110608070913.17777.37689.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the stacktrace support with dynamic event tracer.

This series also includes save_stack_trace_regs() API
cleanup and an weak symbol for the arch which doesn't
support it.

Thank you,

---

Masami Hiramatsu (3):
      [BUGFIX]tracing/kprobes: Fix kprobe-tracer to support stack trace
      Add weak save_stack_trace_regs()
      [CLEANUP]x86: Swap save_stack_trace_regs parameters


 arch/x86/kernel/stacktrace.c  |    2 +-
 arch/x86/mm/kmemcheck/error.c |    2 +-
 include/linux/ftrace_event.h  |    4 ++++
 include/linux/stacktrace.h    |    4 ++--
 kernel/stacktrace.c           |   13 ++++++++++---
 kernel/trace/trace.c          |   35 ++++++++++++++++++++++++++++++-----
 kernel/trace/trace.h          |    9 +++++++++
 kernel/trace/trace_kprobe.c   |    6 ++++--
 8 files changed, 61 insertions(+), 14 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

