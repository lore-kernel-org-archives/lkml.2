Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1BHCAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:00:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab1BHB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:35 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=qKnNxKNKqJsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=sI8TU2OJmAbn52jE5VsA:9 a=CI0oqIu1JG6VqcJLs1rY7jOx9C0A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015934.040383726@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 12/14] tracing/filter: Increase the max preds to 2^14
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-filter-Increase-the-max-preds-to-2-14.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Now that the filter logic does not require to save the pred results
on the stack, we can increase the max number of preds we allow.
As the preds are index by a short value, and we use the MSBs as flags
we can increase the max preds to 2^14 (16384) which should be way
more than enough.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fbff872..856e73c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,7 +680,14 @@ struct event_subsystem {
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
 #define FILTER_PRED_FOLD	(1 << 15)
 
-#define MAX_FILTER_PRED		32
+/*
+ * The max preds is the size of unsigned short with
+ * two flags at the MSBs. One bit is used for both the IS_RIGHT
+ * and FOLD flags. The other is reserved.
+ *
+ * 2^14 preds is way more than enough.
+ */
+#define MAX_FILTER_PRED		16384
 
 struct filter_pred;
 struct regex;
-- 
1.7.2.3


