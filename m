Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0LDAQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:16:34 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16961 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0LDANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=uDVjQNcQY1sHFEYNcX/69OK6UA0vlBOqlWDJtvjZPcdXBm1g/grv4VQ5IOo2VXijw
	fxGHkDO69i1A5rsLyJU+g==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 05/15] ftrace: fix event alignment: ftrace:context_switch and ftrace:wakeup
Date: Fri,  3 Dec 2010 16:13:19 -0800
Message-Id: <1291421609-14665-6-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/trace_entries.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index e3dfeca..81ab9c3 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -109,12 +109,12 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
  */
 #define FTRACE_CTX_FIELDS					\
 	__field(	unsigned int,	prev_pid	)	\
+	__field(	unsigned int,	next_pid	)	\
+	__field(	unsigned int,	next_cpu	)       \
 	__field(	unsigned char,	prev_prio	)	\
 	__field(	unsigned char,	prev_state	)	\
-	__field(	unsigned int,	next_pid	)	\
 	__field(	unsigned char,	next_prio	)	\
-	__field(	unsigned char,	next_state	)	\
-	__field(	unsigned int,	next_cpu	)
+	__field(	unsigned char,	next_state	)
 
 FTRACE_ENTRY(context_switch, ctx_switch_entry,
 
-- 
1.7.3.1

