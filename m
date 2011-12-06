Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab1LFKeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:34:09 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:56525
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933235Ab1LFKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:10 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVS2N5-02-F94-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/10] perf tools: Continue processing header on unknown features
Date: Tue, 6 Dec 2011 11:32:33 +0100
Message-ID: <1323167560-2282-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A feature may be unknown if perf.data is created and parsed on
different perf tool versions. This should not stop the header to be
processed, instead continue processing it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bcd05d0..95c3ab1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1105,7 +1105,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 	}
 	if (feat < HEADER_TRACE_INFO || feat >= HEADER_LAST_FEATURE) {
 		pr_warning("unknown feature %d\n", feat);
-		return -1;
+		return 0;
 	}
 	if (!feat_ops[feat].print)
 		return 0;
-- 
1.7.7


