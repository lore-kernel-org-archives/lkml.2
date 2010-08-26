Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0HZTJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:09:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47503 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab0HZTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:09:21 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org
Subject: [PATCH V2 0/4] Generalise ARM perf-events backend for oprofile
Date: Thu, 26 Aug 2010 20:09:15 +0100
Message-Id: <cover.1282848651.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
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
appreciate it. Though, I have been able to compile this version of the
series.

This patch series is based on tip/master.

Changes from v1:
 - Prefix the new functons with "oprofile_" instead of "op_".
 - Fix ARM compilation errors
 - Move all the oprofile-perf logic into oprofile_perf.c
 - Include cleanup patch from Will

Matt Fleming (3):
  sh: Accessor functions for the sh_pmu state
  oprofile: Abstract the perf-events backend
  sh: Use the perf-events backend for oprofile

Will Deacon (1):
  oprofile: Handle initialisation failure more gracefully

 arch/arm/oprofile/Makefile       |    4 +
 arch/arm/oprofile/common.c       |  228 ++++----------------------------------
 arch/sh/include/asm/perf_event.h |    2 +
 arch/sh/kernel/perf_event.c      |   13 ++
 arch/sh/oprofile/Makefile        |    2 +-
 arch/sh/oprofile/common.c        |   96 +++-------------
 arch/sh/oprofile/op_impl.h       |   33 ------
 drivers/oprofile/oprofile_perf.c |  209 ++++++++++++++++++++++++++++++++++
 include/linux/oprofile.h         |   12 ++
 9 files changed, 283 insertions(+), 316 deletions(-)
 delete mode 100644 arch/sh/oprofile/op_impl.h
 create mode 100644 drivers/oprofile/oprofile_perf.c

