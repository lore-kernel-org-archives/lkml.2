Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0EMBXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:23:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab0EMBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:23:07 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=bghYkjrdNAMA:10 a=ygRHs6EKU7oA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=yQdBAQUQAAAA:8 a=meVymXHHAAAA:8 a=oYG1XsaldjDzz8hm-Q8A:9 a=R_w4IYhaWDGbeCOjY15bco0NVToA:4 a=jEp0ucaQiEUA:10 a=IcxpeKGZWnEA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513012302.352845720@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 12 May 2010 21:21:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 3/4] tracing: Allow mmio tracer to display trace_printk() and other events
References: <20100513012110.558313399@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Allow-mmio-tracer-to-display-trace_printk-an.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The mmio tracer has its own function to handle reading of events.
But if it encounters an event that it does not understand it ignores
it instead of telling the calling function that it is not processing
it.

If someone adds trace_printk() or enables events along with the mmio
tracer, then these events will not be displayed in the trace output.

Simple solution is to just have the mmio print return UNHANDLED to
let the caller know that it did not processes the event and the
caller can process the event further.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_mmiotrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 017fa37..592c00f 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -282,7 +282,8 @@ static enum print_line_t mmio_print_line(struct trace_iterator *iter)
 	case TRACE_PRINT:
 		return mmio_print_mark(iter);
 	default:
-		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
+		/* Not our event */
+		return TRACE_TYPE_UNHANDLED;
 	}
 }
 
-- 
1.7.0


