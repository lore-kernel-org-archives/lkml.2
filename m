Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1LOQeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:34:50 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:5286 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab1LOQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:34:48 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW97AX-02-98N-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/4] perf tools: Fix uninitialized memory access to struct perf_sample
Date: Thu, 15 Dec 2011 17:32:39 +0100
Message-ID: <1323966762-8574-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
References: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory in struct perf_sample is not fully initialized during parsing.
Depending on sampling data some parts may left unchanged. Zero out
struct perf_sample first to avoid access to uninitialized memory.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4a8c8b0..ac115ba 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -457,7 +457,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		u32 val32[2];
 	} u;
 
-
+	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 
-- 
1.7.7


