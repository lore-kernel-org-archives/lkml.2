Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1EZIgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:36:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:34268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab1EZIg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,272,1304319600"; 
   d="scan'208";a="5200428"
Subject: [PATCH 3/3] show energy consumption info in perf tool
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, ming.m.lin@intel.com,
        acme@redhat.com, "Brown, Len" <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 16:34:15 +0800
Message-ID: <1306398855.2207.156.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce four new perf software events
PERF_COUNT_SW_PKG_ENERGY
PERF_COUNT_SW_CORE_ENERGY
PERF_COUNT_SW_UNCORE_ENERGY
and
PERF_COUNT_SW_DRAM_ENERGY

To use it, users can run
perf stat -e pkg-energy foo
to get the package energy consumption when running foo.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 tools/perf/design.txt          |    4 ++++
 tools/perf/util/parse-events.c |    8 ++++++++
 2 files changed, 12 insertions(+)

Index: linux-2.6/tools/perf/design.txt
===================================================================
--- linux-2.6.orig/tools/perf/design.txt
+++ linux-2.6/tools/perf/design.txt
@@ -139,6 +139,10 @@ enum sw_event_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ	= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS	= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS	= 8,
+	PERF_COUNT_SW_PKG_ENERGY	= 9,
+	PERF_COUNT_SW_CORE_ENERGY	= 10,
+	PERF_COUNT_SW_UNCORE_ENERGY	= 11,
+	PERF_COUNT_SW_DRAM_ENERGY	= 12,
 };
 
 Counters of the type PERF_TYPE_TRACEPOINT are available when the ftrace event
Index: linux-2.6/tools/perf/util/parse-events.c
===================================================================
--- linux-2.6.orig/tools/perf/util/parse-events.c
+++ linux-2.6/tools/perf/util/parse-events.c
@@ -50,6 +50,10 @@ static struct event_symbol event_symbols
   { CSW(CPU_MIGRATIONS),		"cpu-migrations",		"migrations"		},
   { CSW(ALIGNMENT_FAULTS),		"alignment-faults",		""			},
   { CSW(EMULATION_FAULTS),		"emulation-faults",		""			},
+  { CSW(PKG_ENERGY),			"pkg-energy",			""			},
+  { CSW(CORE_ENERGY),			"core-energy",			""			},
+  { CSW(UNCORE_ENERGY),			"uncore-energy",		""			},
+  { CSW(DRAM_ENERGY),			"dram-energy",			""			},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
@@ -82,6 +86,10 @@ static const char *sw_event_names[PERF_C
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"package-energy-consumption",
+	"core-energy-consumption",
+	"uncore-energy-consumption",
+	"dram-energy-consumption",
 };
 
 #define MAX_ALIASES 8


