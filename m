Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1LUKZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:25:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1LUKZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:25:20 -0500
Date: Wed, 21 Dec 2011 02:25:00 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-f1ac18af219835fd5b8e19c14d2dd75c55f78737@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323559734-3488-5-git-send-email-eranian@google.com>
References: <1323559734-3488-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add support for PERF_HW_COUNT_REF_CPU_CYCLES
Git-Commit-ID: f1ac18af219835fd5b8e19c14d2dd75c55f78737
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 02:25:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1ac18af219835fd5b8e19c14d2dd75c55f78737
Gitweb:     http://git.kernel.org/tip/f1ac18af219835fd5b8e19c14d2dd75c55f78737
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sun, 11 Dec 2011 00:28:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:26:41 +0100

perf: Add support for PERF_HW_COUNT_REF_CPU_CYCLES

Add new generic hw event: ref-cycles, which maps to
PERF_HW_COUNT_REF_CPUCYCLES:

 $ perf stat -e ref-cycles ls

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323559734-3488-5-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
