Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1G3ABW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 20:01:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12759 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1G3ABR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 20:01:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=mLd6iLwRRSLYvth25VRwprDZTFrXfM5odZ1ZSDMqIn4Bxt6wV3ed0N2KcD6jqagDy
	hOfXgiCbk7F21pyPV7ZxA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 0/2] Add tracepoints to trace all x86 system IRQs
Date: Fri, 29 Jul 2011 16:59:36 -0700
Message-Id: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series aiming to trace all the x86 system IRQs. The
tracepoints make it easier to understand IRQ interaction with other
system events and how do the IRQs affect the system behavior.

Patch#0 adds irq_handler_{entry,exit} tracepoints to x86 timer interrupt
handler.
Patch#1 creates a irq_vectors/ event sub system and
irq_vectors_{entry,exit} trace events. It adds tracepoints to all x86
IRQ vector handlers.

Currently the patch only adds tracepoints to x86. A similar approach can
be taken with other architectures to trace IRQ vectors in the system.

Previous iterations of this patch set:
https://lkml.org/lkml/2011/4/22/321
https://lkml.org/lkml/2011/7/14/309


Vaibhav Nagarnaik (2):
  trace,x86: Add tracepoint to x86 timer interrupt handler
  trace,x86: Add x86 irq vector entry/exit tracepoints

 arch/x86/include/asm/irq_vectors.h       |   50 ++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c              |    7 ++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ++
 arch/x86/kernel/cpu/mcheck/threshold.c   |    3 ++
 arch/x86/kernel/irq.c                    |    6 +++-
 arch/x86/kernel/irq_work.c               |    3 ++
 arch/x86/kernel/smp.c                    |    7 ++++
 arch/x86/kernel/time.c                   |   15 +++++---
 arch/x86/kernel/traps.c                  |    3 ++
 arch/x86/mm/tlb.c                        |    3 ++
 include/trace/events/irq_vectors.h       |   56 ++++++++++++++++++++++++++++++
 11 files changed, 149 insertions(+), 7 deletions(-)
 create mode 100644 include/trace/events/irq_vectors.h

-- 
1.7.3.1

