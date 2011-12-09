Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1LIRoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:44:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LIRn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:43:57 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/3] perf script: look up thread using tid instead of pid
Date: Fri,  9 Dec 2011 10:43:39 -0700
Message-Id: <1323452619-10374-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
References: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the thread name to be dispalyed when dumping
events:
           myapp 25118 [000] 450385.538815: context-switches ...
    myapp:worker 25119 [000] 450385.538894: context-switches ...

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-script.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ea71c5e..d71b745 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -443,7 +443,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 				struct machine *machine)
 {
 	struct addr_location al;
-	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
+	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
-- 
1.7.7.3

