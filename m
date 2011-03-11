Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1CKJuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:50:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:38536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1CKJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:50:01 -0500
Date: Fri, 11 Mar 2011 09:49:45 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1291421609-14665-9-git-send-email-dhsharp@google.com>
References: <1291421609-14665-9-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix event alignment: mce:mce_record
Message-ID: <tip-ad440ad66f1617194738bf674dfe2d38978ac54d@git.kernel.org>
Git-Commit-ID: ad440ad66f1617194738bf674dfe2d38978ac54d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:49:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad440ad66f1617194738bf674dfe2d38978ac54d
Gitweb:     http://git.kernel.org/tip/ad440ad66f1617194738bf674dfe2d38978ac54d
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:22 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:28 -0500

tracing: Fix event alignment: mce:mce_record

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
 
