Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0LDANy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:13:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0LDANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=CYRq4S6KXf5BoPsFHX/+4jDmTjqdsIOc567hap5yxAe4H+GsWW9AJvaKtPy4LpiKZ
	jzf+K/6fxcIUE4AwAEQ0Q==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
Date: Fri,  3 Dec 2010 16:13:21 -0800
Message-Id: <1291421609-14665-8-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 arch/x86/kvm/trace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index a6544b8..ab41fb0 100644
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
1.7.3.1

