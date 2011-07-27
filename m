Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1G0S6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:58:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1G0S6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:58:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=XRQezHrZRDr3FYqRhn4y97fwToY/RH/eIVd2M5Z00Uto8MjWZioX3OZg03nVqTmJU
	wr337XwA5G2t3TqDwYpbg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2 0/6] Add tracepoints to trace all system IRQs
Date: Wed, 27 Jul 2011 11:57:12 -0700
Message-Id: <1311793038-15155-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series aiming to trace all the system IRQs. The
tracepoints make it easier to understand IRQ interaction with other
system events and find out how much time is spent in kernel space versus
user space.

Patches 1-5 add tracepoints to the generic kernel IRQ handlers to
benefit all the architectures, as suggested by Frederic. Patch#6 adds
trace events to trace all platform specific interrupt vectors which do
not have any generic handlers. This patch traces x86 IRQ vectors but can
be used by other architectures to trace their vectors too.

Changelog v2-v1:
* Fix patch#3 to trace IRQ work run vector even when the irq work list
  is empty
* Fix patch#5 to use updated trace event names,
  call_function_ipi_(entry|exit) and
  call_function_single_ipi_(entry|exit)
* Rebase to 3.0
* Update changelog

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
 kernel/irq_work.c                        |    3 +
 kernel/sched.c                           |    3 +
 kernel/smp.c                             |    6 +-
 kernel/time/tick-broadcast.c             |   16 ++-
 kernel/time/tick-common.c                |    8 +-
 kernel/time/tick-sched.c                 |    4 +
 16 files changed, 478 insertions(+), 10 deletions(-)

-- 
1.7.3.1

