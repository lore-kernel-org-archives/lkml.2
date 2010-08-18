Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0HRH4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:56:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:5397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0HRH4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:56:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,226,1280732400"; 
   d="scan'208";a="597674352"
Subject: [RFC PATCH 3/3] perf: support PERF_COUNT_SW_RAPL_ENERGY in perf
 tool
From: Zhang Rui <rui.zhang@intel.com>
To: peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, robert.richter@amd.com,
        acme@redhat.com, paulus@samba.org, dzickus@redhat.com,
        gorcunov@gmail.com, fweisbec@gmail.com,
        Lin Ming <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:59:35 +0800
Message-ID: <1282118375.5181.118.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Support PERF_COUNT_SW_RAPL_ENERGY in perf tool.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 tools/perf/design.txt          |    1 +
 tools/perf/util/parse-events.c |    2 ++
 2 files changed, 3 insertions(+)

Index: linux-2.6-clean/tools/perf/design.txt
===================================================================
--- linux-2.6-clean.orig/tools/perf/design.txt	2010-08-06 22:15:03.434665132 +0800
+++ linux-2.6-clean/tools/perf/design.txt	2010-08-06 22:21:03.746180600 +0800
@@ -139,6 +139,7 @@
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ	= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS	= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS	= 8,
+	PERF_COUNT_SW_RAPL_ENERGY	= 9,
 };
 
 Counters of the type PERF_TYPE_TRACEPOINT are available when the ftrace event
Index: linux-2.6-clean/tools/perf/util/parse-events.c
===================================================================
--- linux-2.6-clean.orig/tools/perf/util/parse-events.c	2010-08-06 22:15:03.422664708 +0800
+++ linux-2.6-clean/tools/perf/util/parse-events.c	2010-08-07 00:06:27.643725050 +0800
@@ -51,6 +51,7 @@
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
   { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
   { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
+  { CSW(RAPL_ENERGY),		"energy",		""		},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
@@ -81,6 +82,7 @@
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"cpu-energy-in-Joules",
 };
 
 #define MAX_ALIASES 8


