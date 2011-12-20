Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1LTTSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:18:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50561 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1LTTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/10] perf evsel: Fix uninitialized memory access to struct perf_sample
Date: Tue, 20 Dec 2011 17:18:03 -0200
Message-Id: <1324408691-28296-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Memory in struct perf_sample is not fully initialized during parsing.
Depending on sampling data some parts may left unchanged. Zero out
struct perf_sample first to avoid access to uninitialized memory.

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1323966762-8574-2-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 60ad028..667f3b7 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -460,7 +460,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		u32 val32[2];
 	} u;
 
-
+	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 
-- 
1.7.8.rc0.35.gee6df

