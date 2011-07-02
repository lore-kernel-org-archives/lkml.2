Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1GBQ3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:29:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39758 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1GBQ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:29:51 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [RFC GIT PULL] x86 entry / perf stacktrace changes
Date: Sat,  2 Jul 2011 18:29:38 +0200
Message-Id: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/stacktrace branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/stacktrace

Or may be not yet. It's still in RFC because I would like
to ensure I did not break cfi annotations. I hope Jan beulich
or others can have a look.

Sorry to mess up irq entry and perf stacktrace changes in the same
topic. But the changes happen to be very interconnected.

Several cleanups, fixes and optimizations for the x86-64
stacktraces and irq entry.

Last patch seems to add a bit of overhead in the irq entry
(one more "push") but given the changes made in previous
patches, the end result is a more optimized and more clear irq
entry.

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      x86: Save stack pointer in perf live regs savings
      x86: Fetch stack from regs when possible in dump_trace()
      x86,64: Simplify save_regs()
      x86,64: Separate arg1 from rbp handling in SAVE_REGS_IRQ
      x86: Remove useless unwinder backlink from irq regs saving
      x86: Don't use frame pointer to save old stack on irq entry


 arch/x86/include/asm/perf_event.h |    5 +++
 arch/x86/kernel/dumpstack_64.c    |   37 +++-----------------
 arch/x86/kernel/entry_64.S        |   69 ++++++++++++++++--------------------
 3 files changed, 41 insertions(+), 70 deletions(-)
