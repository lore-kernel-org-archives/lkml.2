Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0DZUCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:02:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0DZUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:02:44 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=LuShDQustqoA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=eH07uQBqBph4E6uLOxEA:9 a=TlTIkFOzL3LkPT0gDqGGPlbrH1gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100426200241.938003192@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 26 Apr 2010 15:50:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10][RFC] tracing: Convert TRACE_EVENT() to use the DECLARE_TRACE_DATA()
References: <20100426195024.256424113@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Convert-TRACE_EVENT-to-use-the-DECLARE_TRACE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Switch the TRACE_EVENT() macros to use DECLARE_TRACE_DATA(). This
patch is done to prove that the DATA macros work. If any regressions
were to surface, then this patch would help a git bisect to localize
the area.

Once again this patch increases the size of the kernel.

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
5793448	1333780	9351592	16478820	 fb7264	vmlinux.tracepoint
5796926	1337748	9351592	16486266	 fb8f7a	vmlinux.data

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 4649bdb..c04988a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -355,14 +355,14 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
 		assign, print, reg, unreg)			\
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+	DECLARE_TRACE_DATA(name, PARAMS(proto), PARAMS(args))
 
 #endif /* ifdef TRACE_EVENT (see note above) */
-- 
1.7.0


