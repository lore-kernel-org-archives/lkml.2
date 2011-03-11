Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1CKJtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:49:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:46093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab1CKJtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:49:17 -0500
Date: Fri, 11 Mar 2011 09:48:59 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, dhsharp@google.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, dhsharp@google.com,
        tglx@linutronix.de
In-Reply-To: <1291421609-14665-7-git-send-email-dhsharp@google.com>
References: <1291421609-14665-7-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix event alignment: module:module_request
Message-ID: <tip-b5e3008e489f5a00c6d5db914a4c4338c9ef5e8b@git.kernel.org>
Git-Commit-ID: b5e3008e489f5a00c6d5db914a4c4338c9ef5e8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:48:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5e3008e489f5a00c6d5db914a4c4338c9ef5e8b
Gitweb:     http://git.kernel.org/tip/b5e3008e489f5a00c6d5db914a4c4338c9ef5e8b
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:20 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:20 -0500

tracing: Fix event alignment: module:module_request

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
