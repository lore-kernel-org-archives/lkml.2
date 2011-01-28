Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1A1EeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:34:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1A1Edr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:47 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Bu4bcTtZNPgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=sI8TU2OJmAbn52jE5VsA:9 a=CI0oqIu1JG6VqcJLs1rY7jOx9C0A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043346.245863248@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 12/12] tracing/filter: Increase the max preds to 2^14
References: <20110128042118.561146147@goodmis.org>
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


