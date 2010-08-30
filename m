Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0H3MNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:13:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39332 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530Ab0H3MNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:13:49 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH 0/5] hrtimer group events
Date: Mon, 30 Aug 2010 13:13:42 +0100
Message-Id: <cover.1283123521.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is an attempt to link perf group events with a hrtimer, so
that when the hrtimer fires all counters in the group are sampled. The
reason this functionality is needed is because some performance counters
cannot generate any form of interrupts, such as on SH or the power
consumption counters on x86.

Peter, I'm sending this as an RFC because I'm not convinced I've got
this patch series completely right. I've run it a few times on SH and
the results seem sensible, e.g. monitoring L1-dcache-load-misses has
flush_dcache_all() near the top of the list, but I just wanted to get
this out so that people could review it early before I go any
further.

One thing worth noting is that I've essentially hijacked group events so
that they only work specifically for the hrtimer case. That's probably
not right, in which case, we'll need some more flags to distinguish
hrtimer-backed group from non-hrtimer-backed group.

Matt Fleming (5):
  perf: Check if we should exclude idle thread in perf_exclude_event()
  perf: Turn the group counter values into delta values
  perf: Add hrtimer code for PMI-less hardware counters
  sh: Add support for sampling counters
  perf: Add support for PERF_SAMPLE_READ samples

 arch/sh/kernel/perf_event.c |    3 +-
 include/linux/perf_event.h  |    4 ++
 kernel/perf_event.c         |  111 +++++++++++++++++++++++++++++++++++++++++-
 tools/perf/builtin-record.c |   70 ++++++++++++++++++++++++---
 tools/perf/builtin-report.c |   19 +++++++-
 tools/perf/util/event.c     |    7 ++-
 tools/perf/util/event.h     |   15 ++++++
 7 files changed, 213 insertions(+), 16 deletions(-)

