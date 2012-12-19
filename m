Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2LSHDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:03:01 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53497 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2LSHCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:02:49 -0500
X-AuditID: 85900ec0-d867eb900000152f-41-50d16697f2b0
Subject: [PATCH v3 -tip 1/4] tracing: add checks if tr->buffer is NULL in
 tracing_reset{_online_cpus}
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: masami.hiramatsu.pt@hitachi.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 19 Dec 2012 16:02:34 +0900
Message-ID: <20121219070234.31200.93863.stgit@liselsia>
In-Reply-To: <20121219070218.31200.64647.stgit@liselsia>
References: <20121219070218.31200.64647.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_tr->buffer could be NULL in the tracing_reset{_online_cpus}. In this
case, a NULL pointer dereference happens, so we should return immediately
from these functions.

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c705c7a..a8ce008 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -922,6 +922,9 @@ void tracing_reset(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer *buffer = tr->buffer;
 
+	if (!buffer)
+		return;
+
 	ring_buffer_record_disable(buffer);
 
 	/* Make sure all commits have finished */
@@ -936,6 +939,9 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	struct ring_buffer *buffer = tr->buffer;
 	int cpu;
 
+	if (!buffer)
+		return;
+
 	ring_buffer_record_disable(buffer);
 
 	/* Make sure all commits have finished */

