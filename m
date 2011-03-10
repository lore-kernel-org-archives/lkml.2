Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1CJQBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:01:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1CJP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:12 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=uxY7kPvFn-sA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=Z8b-4RKmbEtiI3BVAwMA:9 a=sU11pY4sIj7ziRjR4yqKBdHK33kA:4 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155910.266266338@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH 05/15] tracing: Fix event alignment: module:module_request
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Fix-event-alignment-module-module_request.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-7-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/module.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index c6bae36..21a546d 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -108,14 +108,14 @@ TRACE_EVENT(module_request,
 	TP_ARGS(name, wait, ip),
 
 	TP_STRUCT__entry(
-		__field(	bool,		wait		)
 		__field(	unsigned long,	ip		)
+		__field(	bool,		wait		)
 		__string(	name,		name		)
 	),
 
 	TP_fast_assign(
-		__entry->wait	= wait;
 		__entry->ip	= ip;
+		__entry->wait	= wait;
 		__assign_str(name, name);
 	),
 
@@ -129,4 +129,3 @@ TRACE_EVENT(module_request,
 
 /* This part must be outside protection */
 #include <trace/define_trace.h>
-
-- 
1.7.2.3


