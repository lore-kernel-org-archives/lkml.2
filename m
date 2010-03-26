Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0CZBwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:52:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44324 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0CZBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=c7M4XVhih0rLCXHvGn1+F13X4tdc8A7QpIGmwYX5V/axEIAJsM5bEJA4HE7/S1uxFu
         9IQ3ojdvU0iduA11AkEnKt9t1YN3P2hOxHCdvCDXwXkWcihAeb40bp/lK6+3SPSd2o+S
         WWZijBhDQ0jWjMxqQuHDDOza8QP3ojrit+rAA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Archs <linux-arch@vger.kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/7] perf updates and fixes
Date: Fri, 26 Mar 2010 02:52:35 +0100
Message-Id: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The series is not yet mergeable because it would break PowerPc
(hot regs snapshot API has been changed, and I don't know how
to update PowerPc for that).

But if you're fine with the ideas, I can integrate the necessary
changes to fix this, and also separate fixes and updates.

Thanks.

Frederic Weisbecker (7):
  perf: Drop the frame reliablity check
  perf: Fetch hot regs from the template caller
  x86: Unify dumpstack.h and stacktrace.h
  perf: Move perf_arch_fetch_caller_regs into a macro
  perf: Make perf_fetch_caller_regs rewind to the first caller only
  perf: Use hot regs with software sched/migrate events
  perf: Correctly align perf event tracing buffer

 arch/x86/include/asm/perf_event.h |   10 ++++++-
 arch/x86/include/asm/stacktrace.h |   45 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c  |   18 +------------
 arch/x86/kernel/dumpstack.c       |    1 -
 arch/x86/kernel/dumpstack.h       |   47 ----------------------------------
 arch/x86/kernel/dumpstack_32.c    |    2 -
 arch/x86/kernel/dumpstack_64.c    |    2 -
 arch/x86/kernel/stacktrace.c      |    7 +++--
 include/linux/perf_event.h        |   51 ++++++++++++++----------------------
 include/trace/ftrace.h            |   23 ++++++++--------
 kernel/perf_event.c               |   10 +------
 kernel/trace/trace_event_perf.c   |   13 ++++++---
 12 files changed, 101 insertions(+), 128 deletions(-)
 delete mode 100644 arch/x86/kernel/dumpstack.h

