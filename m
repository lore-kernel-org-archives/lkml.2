Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1JOSgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:36:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37097 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1JOSgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:36:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf tools: Reset hists number of entries before collapsing
Date: Sat, 15 Oct 2011 20:36:12 +0200
Message-Id: <1318703773-6846-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318703773-6846-1-git-send-email-fweisbec@gmail.com>
References: <1318703773-6846-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we collapse entries, we re-compute their total numbers
and period but we forget to reset the total number of entries
before.

Fix this so that the browser sees the correct number of entries.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/hist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index bac6520..cef40d8 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -344,6 +344,7 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 
 	root = hists__get_rotate_entries_in(hists);
 	next = rb_first(root);
+	hists->nr_entries = 0;
 	hists->stats.total_period = 0;
 
 	while (next) {
-- 
1.7.5.4

