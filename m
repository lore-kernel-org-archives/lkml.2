Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1CJQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:00:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CJP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:13 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=q0WDKsnlfC8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=zlmJrAhBmZA7G0T09oIA:9 a=eNCaV_lyklNciO49w4pHzqE9QNAA:4 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155910.775837173@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 07/15] tracing: Fix event alignment: mce:mce_record
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Fix-event-alignment-mce-mce_record.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-9-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/mce.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
index 7eee778..4cbbcef 100644
--- a/include/trace/events/mce.h
+++ b/include/trace/events/mce.h
@@ -17,36 +17,36 @@ TRACE_EVENT(mce_record,
 	TP_STRUCT__entry(
 		__field(	u64,		mcgcap		)
 		__field(	u64,		mcgstatus	)
-		__field(	u8,		bank		)
 		__field(	u64,		status		)
 		__field(	u64,		addr		)
 		__field(	u64,		misc		)
 		__field(	u64,		ip		)
-		__field(	u8,		cs		)
 		__field(	u64,		tsc		)
 		__field(	u64,		walltime	)
 		__field(	u32,		cpu		)
 		__field(	u32,		cpuid		)
 		__field(	u32,		apicid		)
 		__field(	u32,		socketid	)
+		__field(	u8,		cs		)
+		__field(	u8,		bank		)
 		__field(	u8,		cpuvendor	)
 	),
 
 	TP_fast_assign(
 		__entry->mcgcap		= m->mcgcap;
 		__entry->mcgstatus	= m->mcgstatus;
-		__entry->bank		= m->bank;
 		__entry->status		= m->status;
 		__entry->addr		= m->addr;
 		__entry->misc		= m->misc;
 		__entry->ip		= m->ip;
-		__entry->cs		= m->cs;
 		__entry->tsc		= m->tsc;
 		__entry->walltime	= m->time;
 		__entry->cpu		= m->extcpu;
 		__entry->cpuid		= m->cpuid;
 		__entry->apicid		= m->apicid;
 		__entry->socketid	= m->socketid;
+		__entry->cs		= m->cs;
+		__entry->bank		= m->bank;
 		__entry->cpuvendor	= m->cpuvendor;
 	),
 
-- 
1.7.2.3


