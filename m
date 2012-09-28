Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2I1IRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:17:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42113 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2I1IRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:17:09 -0400
X-AuditID: b753bd60-99054ba000002f78-66-50655d0229ee
X-AuditID: b753bd60-99054ba000002f78-66-50655d0229ee
Subject: [PATCH -tip  0/3] Move kprobes files under the kprobes directory
To: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Fri, 28 Sep 2012 17:15:09 +0900
Message-ID: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a series of patches to split ftrace-based kprobe part
from arch/x86/kernel/kprobes.c and to move kprobes related
files under arch/x86/kernel/kprobes/, according to Ingo's
suggestion.
https://lkml.org/lkml/2012/9/20/122

Thank you,

---

Masami Hiramatsu (3):
      ftrace: Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig
      kprobes/x86: Move ftrace-based kprobe code into kprobes-ftrace.c
      kprobes/x86: Move kprobes stuff under arch/x86/kernel/kprobes/


 arch/Kconfig                     |   12 
 arch/x86/Kconfig                 |    2 
 arch/x86/include/asm/ftrace.h    |    1 
 arch/x86/kernel/Makefile         |    3 
 arch/x86/kernel/kprobes-common.h |  102 ---
 arch/x86/kernel/kprobes-opt.c    |  512 -----------------
 arch/x86/kernel/kprobes.c        | 1130 --------------------------------------
 arch/x86/kernel/kprobes/Makefile |    7 
 arch/x86/kernel/kprobes/common.h |  113 ++++
 arch/x86/kernel/kprobes/core.c   | 1064 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes/ftrace.c |   93 +++
 arch/x86/kernel/kprobes/opt.c    |  512 +++++++++++++++++
 include/linux/ftrace.h           |    6 
 include/linux/kprobes.h          |   12 
 kernel/kprobes.c                 |    8 
 kernel/trace/Kconfig             |    8 
 kernel/trace/ftrace.c            |    6 
 kernel/trace/trace_selftest.c    |    2 
 18 files changed, 1824 insertions(+), 1769 deletions(-)
 delete mode 100644 arch/x86/kernel/kprobes-common.h
 delete mode 100644 arch/x86/kernel/kprobes-opt.c
 delete mode 100644 arch/x86/kernel/kprobes.c
 create mode 100644 arch/x86/kernel/kprobes/Makefile
 create mode 100644 arch/x86/kernel/kprobes/common.h
 create mode 100644 arch/x86/kernel/kprobes/core.c
 create mode 100644 arch/x86/kernel/kprobes/ftrace.c
 create mode 100644 arch/x86/kernel/kprobes/opt.c

-- 
Masami Hiramatsu
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

