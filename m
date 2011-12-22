Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1LVSac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:30:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51735 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1LVSaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:30:20 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/3] perf script: look up thread using tid instead of pid
Date: Thu, 22 Dec 2011 11:30:03 -0700
Message-Id: <1324578603-12762-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1324578603-12762-1-git-send-email-dsahern@gmail.com>
References: <1324578603-12762-1-git-send-email-dsahern@gmail.com>
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
1.7.7.4

