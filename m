Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab2HPTyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:54:39 -0400
Received: from [213.199.154.206] ([213.199.154.206]:55525 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933230Ab2HPTyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz936eIzz1202hzzz2dh668h839hd24he5bhf0ah1155h)
X-WSS-ID: 0M8V5X0-01-68S-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/8] perf tools: Various updates
Date: Thu, 16 Aug 2012 21:10:16 +0200
Message-ID: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains various perf tools updates. Most patches deal
with event naming. If the event name is unknown it is named like the
command line string of it. This is esp. valueable for pmu events like
for AMD IBS:

     $ perf report | grep '^#.*event'
     # event : name = ibs_op/cnt_ctl=1/GH, type = 7, config = 0x80000, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 0, precise_ip = 0, id = { 
     # event : name = ibs_fetch/config=0/, type = 6, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, id = { 57, 
     # Samples: 20K of event 'ibs_op/cnt_ctl=1/GH'
     # Samples: 4K of event 'ibs_fetch/config=0/'

Another patch stores the pmu/type mapping in the header of perf.data.
Now the pmu types are known and event can be attributed to a certain
dynamically allocated pmu:

     # pmu mappings: ibs_op = 7, ibs_fetch = 6, cpu = 4, breakpoint = 5, tracepoint = 2, software = 1

This is usefull for analysing the perf.data file on a system where the
pmu mappings are no longer available, e.g. on a remote system or if
the pmu has been unregistered.

Patches base on commit 0c21f736e0a37c50f66ab248d2a52f711b28a4e4
(acme/perf/core):

  perf evlist: Introduce evsel list accessors (2012-08-15 10:14:18 -0300)

-Robert

Robert Richter (8):
  perf tools: Fix type for evsel->ids and add size check for ids
  perf tools: Report number of pmu type of unknown events
  perf tools: Rename some variables for better understanding
  perf tools: Rename global variable 'events' in util/header.c
  perf tools: Catch event names from command line
  perf tools: Refactor print_event_desc()
  perf report: Update event names from header description
  perf tools: Add pmu mappings to header information

 tools/perf/util/evsel.c        |    3 +-
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/header.c       |  357 ++++++++++++++++++++++++++++++----------
 tools/perf/util/header.h       |    3 +-
 tools/perf/util/parse-events.c |   12 ++
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.l |   50 +++++-
 tools/perf/util/parse-events.y |   20 ++-
 tools/perf/util/pmu.c          |   50 ++++++-
 tools/perf/util/pmu.h          |    2 +
 10 files changed, 396 insertions(+), 104 deletions(-)

-- 
1.7.8.6


