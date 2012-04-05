Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2DEQ0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:26:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:14191 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab2DEQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:26:41 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LOA-01-4MY-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/4] perf tools: Use sw counter only if hw pmu is not detected
Date: Thu, 5 Apr 2012 18:26:28 +0200
Message-ID: <1333643188-26895-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu-clock-tick sw counter for cpu-cycles only if there is no hw
pmu available. This is the case if the syscall reports ENOENT. In
other cases (e.g. invalid attributes) we don't want the sw counter to
be used.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index be4e1ee..10b1f1f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -245,7 +245,7 @@ try_again:
 			 * based cpu-clock-tick sw counter, which
 			 * is always available even if no PMU support:
 			 */
-			if (attr->type == PERF_TYPE_HARDWARE
+			if (err == ENOENT && attr->type == PERF_TYPE_HARDWARE
 					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
 
 				if (verbose)
-- 
1.7.8.4


