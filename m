Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab1JCNvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab1JCNuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:50:39 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH 0/9] perf support for x86 guest/host-only bits
Date: Mon,  3 Oct 2011 15:49:46 +0200
Message-Id: <1317649795-18259-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series consists of Joerg series named "perf support for amd
guest/host-only bits v2" [1] rebased to 3.1.0-rc7 and in addition,
support for intel cpus for the same functionality.


[1] https://lkml.org/lkml/2011/6/17/171

Gleb Natapov (4):
  perf, intel: Use GO/HO bits in perf-ctr
  KVM, VMX: add support for switching of PERF_GLOBAL_CTRL
  KVM, VMX: Add support for guest/host-only profiling
  KVM, VMX: Check for automatic switch msr table overflow.

Joerg Roedel (5):
  perf, core: Introduce attrs to count in either host or guest mode
  perf, amd: Use GO/HO bits in perf-ctr
  perf, tools: Add support for guest/host-only profiling
  perf, tools: Fix copy&paste error in perf-kvm option description
  perf, tools: Do guest-only counting in perf-kvm by default

 arch/x86/include/asm/perf_event.h      |   15 ++++
 arch/x86/kernel/cpu/perf_event.c       |   10 +++
 arch/x86/kernel/cpu/perf_event_amd.c   |   13 +++
 arch/x86/kernel/cpu/perf_event_intel.c |  111 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx.c                     |  139 +++++++++++++++++++++++++++++---
 include/linux/perf_event.h             |    5 +-
 tools/perf/builtin-kvm.c               |    5 +-
 tools/perf/util/event.c                |    8 ++
 tools/perf/util/event.h                |    2 +
 tools/perf/util/evlist.c               |    5 +-
 tools/perf/util/parse-events.c         |   15 +++-
 11 files changed, 309 insertions(+), 19 deletions(-)

-- 
1.7.5.3

