Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0LDAO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:14:56 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0LDANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=BX1V+gxOaZ/Zm59sqvLZ1W9OlUEgFv/ZZpAzLBc8G9EM2JugyFVjXNhpQJoLBwqcm
	UPV5jpQghs5GzgFPf/W5A==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 08/15] ftrace: fix event alignment: mce:mce_record
Date: Fri,  3 Dec 2010 16:13:22 -0800
Message-Id: <1291421609-14665-9-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
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
1.7.3.1

