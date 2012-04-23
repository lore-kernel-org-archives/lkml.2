Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2DWBMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 21:12:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60140 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2DWBMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 21:12:43 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-6c-4f94ac88a8d2
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Check return value of tracing_dentry_percpu()
Date: Mon, 23 Apr 2012 10:11:57 +0900
Message-Id: <1335143517-2285-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracing_dentry_percpu() failed, tracing_init_debugfs_percpu()
will try to create each cpu directories on debugfs' root directory
as d_percpu is NULL.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/trace/trace.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1e12f4..54df9a672fd9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4367,6 +4367,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
 
+	if (!d_percpu)
+		return;
+
 	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
-- 
1.7.10

