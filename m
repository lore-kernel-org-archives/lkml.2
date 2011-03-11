Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1CKJtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:49:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:46106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab1CKJtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:49:41 -0500
Date: Fri, 11 Mar 2011 09:49:23 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de,
        avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de,
        avi@redhat.com
In-Reply-To: <1291421609-14665-8-git-send-email-dhsharp@google.com>
References: <1291421609-14665-8-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix event alignment: kvm:kvm_hv_hypercall
Message-ID: <tip-d5bf2ff07230a4a1b73ecb22363f77c02e1d85ab@git.kernel.org>
Git-Commit-ID: d5bf2ff07230a4a1b73ecb22363f77c02e1d85ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:49:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5bf2ff07230a4a1b73ecb22363f77c02e1d85ab
Gitweb:     http://git.kernel.org/tip/d5bf2ff07230a4a1b73ecb22363f77c02e1d85ab
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:21 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:24 -0500

tracing: Fix event alignment: kvm:kvm_hv_hypercall

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
