Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1GNVir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:38:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25664 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab1GNVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=xlPjLSdBZSpUa4kvRKEG3LGgW+PM6pOzhR7BNWbFmu5b1nvBXRceFraN60qAg7a2f
	vyKsoe5YAt3DqPisqmXzA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 0/6] Add tracepoints to trace all system IRQs
Date: Thu, 14 Jul 2011 14:38:09 -0700
Message-Id: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series aiming to trace all the system IRQs. The
tracepoints make it easier to find out when interrupts occur and how
much time is spent in kernel space versus user space.

Patches 1-5 add tracepoints to the generic kernel IRQ handlers to
benefit all the architectures, as suggested by Frederic. Patch#6 adds
trace events to trace all platform specific interrupt vectors which do
not have any generic handlers. This patch traces x86 IRQ vectors but can
be used by other architectures to trace their vectors too.


Vaibhav Nagarnaik (6):
  trace,x86: Add tracepoint to x86 timer interrupt handler
  trace: Add tracepoints to timer interrupt handlers
  trace: Add tracepoints to IRQ work run handler
  trace: Add tracepoints to reschedule interrupt handler
  trace: Add tracepoints to call function interrupt handlers
  trace,x86: Add platform_irq_vector_{entry|exit} trace events

 arch/x86/include/asm/irq_vectors.h       |   43 ++++
 arch/x86/kernel/apic/apic.c              |    4 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +
 arch/x86/kernel/irq.c                    |    2 +
 arch/x86/kernel/time.c                   |   15 +-
 arch/x86/kernel/traps.c                  |    2 +
 arch/x86/mm/tlb.c                        |    2 +
 include/trace/events/irq.h               |  370 ++++++++++++++++++++++++++++++
 kernel/hrtimer.c                         |    6 +
 kernel/irq_work.c                        |    4 +
 kernel/sched.c                           |    4 +
 kernel/smp.c                             |    5 +
 kernel/time/tick-broadcast.c             |   16 ++-
 kernel/time/tick-common.c                |    8 +-
 kernel/time/tick-sched.c                 |    4 +
 16 files changed, 480 insertions(+), 9 deletions(-)

-- 
1.7.3.1

