Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2GNLkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 07:40:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57651 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2GNLkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 07:40:10 -0400
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 19:40:09 +0800
Message-ID: <CACV3sbLF8taiCq_VYW-sgRJyupeMzg58C7ZXfMe3xZUiH_Mx6w@mail.gmail.com>
Subject: [PATCH] perf: make the breakpoint events sample period default to 1
From: Jovi Zhang <bookjovi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cb06e8f21d3875f4ffef46a7627dca88b2c74836 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Sun, 15 Jul 2012 03:03:10 +0800
Subject: [PATCH] perf: make the breakpoint events sample period default to 1

There have one problem about hw_breakpoint perf event, as watched,
the events reported to userspace is not correctly, sometime one
trigger bp_event report several events, sometime bp_event cannot
go through to user.

The root cause is attr->freq is 1 passed to kernel defaultly in
bp events, this make kernel calculate event period not as expect,
make sample period to 1 will change attr->freq to 0, to fix this problem.

This patch is similar with commit f92128 about tracepoint events:
    perf: Make the trace events sample period default to 1

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 tools/perf/util/parse-events.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05dbc8b..631aec6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -592,6 +592,7 @@ int parse_events_add_breakpoint(struct list_head
**list, int *idx,
 		attr.bp_len = HW_BREAKPOINT_LEN_4;

 	attr.type = PERF_TYPE_BREAKPOINT;
+	attr.sample_period = 1;

 	snprintf(name, MAX_NAME_LEN, "mem:%p:%s", ptr, type ? type : "rw");
 	return add_event(list, idx, &attr, name);
-- 
1.7.9.7
