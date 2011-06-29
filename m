Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1F2PnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:43:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab1F2PnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:43:01 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] Preparatory perf patches for KVM PMU support
Date: Wed, 29 Jun 2011 18:42:34 +0300
Message-Id: <1309362157-6596-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches pave the way for KVM in-guest performance
monitoring.  One is a perf API improvement, another fixes the constraints
for the version 1 architectural PMU (which we will emulate), and the third
adds an export that KVM will use.

Please consider for merging; this will make further work on the KVM PMU
easier.

Avi Kivity (3):
  perf: add context field to perf_event
  x86, perf: add constraints for architectural PMU v1
  perf: export perf_event_refresh() to modules

 arch/arm/kernel/ptrace.c                |    3 ++-
 arch/powerpc/kernel/ptrace.c            |    2 +-
 arch/sh/kernel/ptrace_32.c              |    3 ++-
 arch/x86/kernel/cpu/perf_event_intel.c  |   23 ++++++++++++++++++-----
 arch/x86/kernel/kgdb.c                  |    2 +-
 arch/x86/kernel/ptrace.c                |    3 ++-
 drivers/oprofile/oprofile_perf.c        |    2 +-
 include/linux/hw_breakpoint.h           |   10 ++++++++--
 include/linux/perf_event.h              |    9 ++++++++-
 kernel/events/core.c                    |   24 +++++++++++++++++-------
 kernel/events/hw_breakpoint.c           |   10 +++++++---
 kernel/watchdog.c                       |    2 +-
 samples/hw_breakpoint/data_breakpoint.c |    2 +-
 13 files changed, 69 insertions(+), 26 deletions(-)

-- 
1.7.5.3

