Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1AGCfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:35:22 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13352 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1AGCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:35:19 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Subject: [PATCH 0/6] MIPS: perf: Make perf work for 64-bit/Octeon counters.
Date: Thu,  6 Jan 2011 18:35:01 -0800
Message-Id: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 07 Jan 2011 02:35:19.0469 (UTC) FILETIME=[86855DD0:01CBAE13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing MIPS perf hardware counter support only handles 32-bit
wide counters.  Some CPUs (like Octeon) have the 64-bit wide variety.
This patch set allows perf to work on Octeon, and I hope not break
existing systems.  I have not tested it on non-Octeon systems, so it
would be good if someone could test that.

Summary of the patches:

1) Fix faulty Octeon interrupt controller code.

2) Add some register definitions.

3,4) Clean up existing code.

5) 64-bit perf counter support.

6) Octeon perf event bindings.

Patch 4/6 is the biggest and has the highest chance of having broken
something.

This patch set depends on a couple of others that have previously been
sent to Ralf:

http://patchwork.linux-mips.org/patch/1927/
http://patchwork.linux-mips.org/patch/1850/
http://patchwork.linux-mips.org/patch/1851/
http://patchwork.linux-mips.org/patch/1852/
http://patchwork.linux-mips.org/patch/1853/
http://patchwork.linux-mips.org/patch/1854/

David Daney (6):
  MIPS: Octeon: Enable per-CPU IRQs on all CPUs.
  MIPS: Add accessor macros for 64-bit performance counter registers.
  MIPS: perf: Cleanup formatting in arch/mips/kernel/perf_event.c
  MIPS: perf: Reorganize contents of perf support files.
  MIPS: perf: Add support for 64-bit perf counters.
  MIPS: perf: Add Octeon support for hardware perf.

 arch/mips/Kconfig                    |    2 +-
 arch/mips/cavium-octeon/octeon-irq.c |   30 +-
 arch/mips/cavium-octeon/smp.c        |   10 +
 arch/mips/include/asm/mipsregs.h     |    8 +
 arch/mips/kernel/Makefile            |    5 +-
 arch/mips/kernel/perf_event.c        |  521 +--------------
 arch/mips/kernel/perf_event_mipsxx.c | 1265 +++++++++++++++++++++++++---------
 7 files changed, 977 insertions(+), 864 deletions(-)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
-- 
1.7.2.3

