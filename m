Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1LGJGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:06:25 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31884 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab1LGJDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:03:11 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVTT53-02-6S8-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v2 1/7] perf tools: Continue processing header on unknown features
Date: Wed, 7 Dec 2011 10:02:51 +0100
Message-ID: <1323248577-11268-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-1-git-send-email-robert.richter@amd.com>
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
index 9272f3a..47a7826 100644
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


