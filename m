Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2HPTyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:54:14 -0400
Received: from [216.32.180.13] ([216.32.180.13]:53123 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932296Ab2HPTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8V5WR-01-68B-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/8] perf tools: Report number of pmu type of unknown events
Date: Thu, 16 Aug 2012 21:10:18 +0200
Message-ID: <1345144224-27280-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If detection fails and an event name is unknown, report the type
number. Example perf header output:

 # Samples: 10K of event 'unknown attr type: 7'

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/evsel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6c7dcc1..7ff3c8f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -319,7 +319,8 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 		break;
 
 	default:
-		scnprintf(bf, sizeof(bf), "%s", "unknown attr type");
+		scnprintf(bf, sizeof(bf), "unknown attr type: %d",
+			  evsel->attr.type);
 		break;
 	}
 
-- 
1.7.8.6


