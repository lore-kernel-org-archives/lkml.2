Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab0EDW6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:58:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441Ab0EDW6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:58:12 -0400
X-Authority-Analysis: v=1.1 cv=Sj+DEJq9TvmrEz0yYf786F+83+V8ZKDvY/KsKt+Cs/8= c=1 sm=0 a=wjcUkYIaDT4A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=JsWJshzKhFqjkCAmQtUA:9 a=iLUp6Ha6ZuWZ2GA11Eua7sLj4_4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: How to write marker info in MMIO trace from kernel
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BE09F42.9070909@lwfinger.net>
References: <4BE06933.9080202@lwfinger.net>
	 <1272998579.9739.235.camel@gandalf.stny.rr.com>
	 <4BE09F42.9070909@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 18:58:09 -0400
Message-ID: <1273013889.22438.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 17:27 -0500, Larry Finger wrote:

> Thanks for the info. One other question - when I write only mmiotrace to
> the current_tracer, the trace_printk() stuff does not end up in the
> buffer. I can get it by using the "sysprof" tracer, but that has a lot
> of stuff I do not want. Did I miss some configuration? My list of
> available tracers is "blk kmemtrace mmiotrace wakeup_rt wakeup function
> sysprof sched_switch nop".

Ug, that's because the mmiotrace handles its own prints and ignores
anything it does not know about. Here, try this patch:

-- Steve

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 017fa37..8652f28 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -282,7 +282,7 @@ static enum print_line_t mmio_print_line(struct trace_iterator *iter)
 	case TRACE_PRINT:
 		return mmio_print_mark(iter);
 	default:
-		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
+		return TRACE_TYPE_UNHANDLED;
 	}
 }
 


