Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2GYRox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:44:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GYRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jovi Zhang <bookjovi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/19] perf tools: Make the breakpoint events sample period default to 1
Date: Wed, 25 Jul 2012 14:41:29 -0300
Message-Id: <1343238094-12481-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

There have one problem about hw_breakpoint perf event, as watched, the
events reported to userspace is not correctly, sometime one trigger
bp_event report several events, sometime bp_event cannot go through to
user.

The root cause is attr->freq is 1 passed to kernel defaultly in bp
events, this make kernel calculate event period not as expect, make
sample period to 1 will change attr->freq to 0, to fix this problem.

This patch is similar with commit f92128 about tracepoint events:
    perf: Make the trace events sample period default to 1

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/CACV3sbLF8taiCq_VYW-sgRJyupeMzg58C7ZXfMe3xZUiH_Mx6w@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a729945..74a5af4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,6 +490,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 		attr.bp_len = HW_BREAKPOINT_LEN_4;
 
 	attr.type = PERF_TYPE_BREAKPOINT;
+	attr.sample_period = 1;
 
 	return add_event(list, idx, &attr, NULL);
 }
-- 
1.7.1

