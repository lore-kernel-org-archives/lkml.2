Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1LJX3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 18:29:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36604 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1LJX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 18:28:51 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com
Subject: [PATCH 4/4] perf: add support for PERF_HW_COUNT_REF_CPU_CYCLES
Date: Sun, 11 Dec 2011 00:28:54 +0100
Message-Id: <1323559734-3488-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323559734-3488-1-git-send-email-eranian@google.com>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add new generic hw event: ref-cycles
maps to PERF_HW_COUNT_REF_CPUCYCLES.

$ perf stat -e ref-cycles ls

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 586ab3f..531c283 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -38,6 +38,7 @@ static struct event_symbol event_symbols[] = {
   { CHW(BRANCH_INSTRUCTIONS),		"branch-instructions",		"branches"		},
   { CHW(BRANCH_MISSES),			"branch-misses",		""			},
   { CHW(BUS_CYCLES),			"bus-cycles",			""			},
+  { CHW(REF_CPU_CYCLES),		"ref-cycles",			""			},
 
   { CSW(CPU_CLOCK),			"cpu-clock",			""			},
   { CSW(TASK_CLOCK),			"task-clock",			""			},
@@ -68,6 +69,7 @@ static const char *hw_event_names[PERF_COUNT_HW_MAX] = {
 	"bus-cycles",
 	"stalled-cycles-frontend",
 	"stalled-cycles-backend",
+	"ref-cycles",
 };
 
 static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
-- 
1.7.1

