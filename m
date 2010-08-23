Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HWKq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:46:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53488 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab0HWKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:46:22 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/3] Generalise ARM perf-events backend for oprofile
Date: Mon, 23 Aug 2010 11:46:18 +0100
Message-Id: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.2.2.162.g5cba1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf-events backend for OProfile that Will Deacon wrote in
8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
perf-events framework as backend") is of use to more architectures
than just ARM. Move the code into drivers/oprofile/ so that SH can use
it instead of the nearly identical copy of its OProfile code.

The benefit of the backend is that it becomes necessary to only
maintain one copy of the PMU accessor functions for each architecture,
with bug fixes and new features benefiting both OProfile and perf.

Note that I haven't been able to test these patches on an ARM board to
see if I've caused any regressions. If anyone else could do that I'd
appreciate it.

This patch series is based on tip/master.

Matt Fleming (3):
  sh: Accessor functions for the sh_pmu state
  oprofile: Abstract the perf-events backend for oprofile
  sh: Use the perf-events backend for oprofile

 arch/arm/oprofile/Makefile       |    4 +
 arch/arm/oprofile/common.c       |  176 +-----------------------------------
 arch/sh/include/asm/perf_event.h |    2 +
 arch/sh/kernel/perf_event.c      |   13 +++
 arch/sh/oprofile/Makefile        |    4 +
 arch/sh/oprofile/common.c        |   95 +++----------------
 arch/sh/oprofile/op_impl.h       |   33 -------
 drivers/oprofile/oprofile_perf.c |  188 ++++++++++++++++++++++++++++++++++++++
 include/linux/oprofile.h         |   12 +++
 9 files changed, 240 insertions(+), 287 deletions(-)
 delete mode 100644 arch/sh/oprofile/op_impl.h
 create mode 100644 drivers/oprofile/oprofile_perf.c

-- 
1.7.2.1

