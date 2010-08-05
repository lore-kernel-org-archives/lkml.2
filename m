Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab0HELJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:09:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0HELJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:09:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/2] apic: tracing IPI events
Date: Thu,  5 Aug 2010 13:09:36 +0200
Message-Id: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm adding tracing of IPIs to the APIC code by hooking
following apic callbacks:

        void (*send_IPI_mask)(const struct cpumask *mask, int vector);
        void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
                                         int vector);
        void (*send_IPI_allbutself)(int vector);
        void (*send_IPI_all)(int vector);
        void (*send_IPI_self)(int vector);


attached patches:
- 1/2 apic: adding apic_send_IPI_* methods for apic's IPI callbacks
- 2/2 apic,trace: IPI sent trace event.

I'm not sure this is the best way, maybe some more
general approach might be better.

please let me know what you think

wbr,
jirka
---
 arch/x86/include/asm/apic.h             |   16 +++++++++-
 arch/x86/include/asm/apic_trace.h       |   53 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/ipi.h              |    4 +-
 arch/x86/kernel/apic/apic.c             |   48 +++++++++++++++++++++++++++-
 arch/x86/kernel/apic/apic_flat_64.c     |    4 +-
 arch/x86/kernel/apic/hw_nmi.c           |    2 +-
 arch/x86/kernel/apic/io_apic.c          |    9 +++--
 arch/x86/kernel/apic/nmi.c              |    2 +-
 arch/x86/kernel/apic/probe_64.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c        |    2 +-
 arch/x86/kernel/cpu/perf_event.c        |    2 +-
 arch/x86/kernel/kgdb.c                  |    2 +-
 arch/x86/kernel/reboot.c                |    2 +-
 arch/x86/kernel/smp.c                   |   12 +++---
 arch/x86/mm/tlb.c                       |    2 +-
 16 files changed, 139 insertions(+), 25 deletions(-)
