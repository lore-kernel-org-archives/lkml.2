Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1CJQBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:01:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1CJP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:12 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=I4FjwvzCYasA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=VtFHLKlEj5LlF0lGLJIA:9 a=Cma_vJlcnSr_fupT8t5fQLpGoA0A:4 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155910.528219453@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Avi Kivity <avi@redhat.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 06/15] tracing: Fix event alignment: kvm:kvm_hv_hypercall
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-event-alignment-kvm-kvm_hv_hypercall.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

Acked-by: Avi Kivity <avi@redhat.com>
Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-8-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/trace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 1357d7c..db93276 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -62,21 +62,21 @@ TRACE_EVENT(kvm_hv_hypercall,
 	TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
 
 	TP_STRUCT__entry(
-		__field(	__u16, 		code		)
-		__field(	bool,		fast		)
 		__field(	__u16,		rep_cnt		)
 		__field(	__u16,		rep_idx		)
 		__field(	__u64,		ingpa		)
 		__field(	__u64,		outgpa		)
+		__field(	__u16, 		code		)
+		__field(	bool,		fast		)
 	),
 
 	TP_fast_assign(
-		__entry->code		= code;
-		__entry->fast		= fast;
 		__entry->rep_cnt	= rep_cnt;
 		__entry->rep_idx	= rep_idx;
 		__entry->ingpa		= ingpa;
 		__entry->outgpa		= outgpa;
+		__entry->code		= code;
+		__entry->fast		= fast;
 	),
 
 	TP_printk("code 0x%x %s cnt 0x%x idx 0x%x in 0x%llx out 0x%llx",
-- 
1.7.2.3


