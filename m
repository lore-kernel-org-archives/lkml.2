Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab0KROht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:37:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64560 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab0KROhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=dZ33rXmC6/ydEMtm730TgEk17fG39uy/ZKLFg6fRyOEIR7FVv/sStDh2oPEen3PBMn
         jb7E8yyWOU501iQ4TqnjC2WVL/UwdFlg0JUmYNUELSjpqnjR9K0tbCriuDZgMk0adohf
         HDqrHVsoBT1bDBta6Mg3S0VNn7z6RWfnsWvLE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing/perf updates
Date: Thu, 18 Nov 2010 15:37:43 +0100
Message-Id: <1290091064-7777-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

The unprivilege flag series has been posted already. I'm just
posting the other patch of the series: a big cleanup on stacktraces.

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      tracing: New flag to allow non privileged users to use a trace event
      tracing: New macro to set up initial event flags value
      tracing: Allow raw syscall trace events for non privileged users
      tracing: Allow syscall trace events for non privileged users
      tracing: Remove useless syscall ftrace_event_call declaration

Soeren Sandmann Pedersen (1):
      x86: Eliminate bp argument from the stack tracing routines


 arch/x86/include/asm/kdebug.h     |    2 +-
 arch/x86/include/asm/stacktrace.h |   33 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   12 ++++++------
 arch/x86/kernel/dumpstack_32.c    |   25 +++++++------------------
 arch/x86/kernel/dumpstack_64.c    |   24 +++++++-----------------
 arch/x86/kernel/process.c         |    3 +--
 arch/x86/kernel/stacktrace.c      |    8 ++++----
 arch/x86/mm/kmemcheck/error.c     |    2 +-
 arch/x86/oprofile/backtrace.c     |    2 +-
 include/linux/ftrace_event.h      |   10 ++++++++++
 include/linux/stacktrace.h        |    4 +++-
 include/linux/syscalls.h          |   10 ++++------
 include/linux/tracepoint.h        |    4 ++++
 include/trace/events/syscalls.h   |    4 ++++
 include/trace/ftrace.h            |    7 +++++++
 kernel/perf_event.c               |    9 ---------
 kernel/trace/trace_event_perf.c   |   31 ++++++++++++++++++++++++++++++-
 18 files changed, 121 insertions(+), 71 deletions(-)
