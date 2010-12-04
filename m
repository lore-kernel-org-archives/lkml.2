Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0LDAPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:15:39 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16973 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0LDANw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=FKEGB3Bs7Wu+DEGEz4BpDjiBiu4iw+UBt6wVVk+GEXxIhToENCS7LfzHp/S2CcoYD
	1QSlX4GhhLXXOpCXnAOGw==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 12/15] trace_output.c: adjust conditional expression formatting.
Date: Fri,  3 Dec 2010 16:13:26 -0800
Message-Id: <1291421609-14665-13-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Formatting change only to improve readability. No code changes except to
introduce intermediate variables.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/trace_output.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 02272ba..9e33b1f 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -533,20 +533,24 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
  */
 int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
-	int hardirq, softirq;
 	int ret;
-
-	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
-	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
+	int hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
+	int softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
+
+	const char irqs_off = 
+		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
+		'.';
+	const char need_resched =
+		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
+	const char hardsoft_irq =
+		(hardirq && softirq) ? 'H' :
+		hardirq ? 'h' :
+		softirq ? 's' :
+		'.';
 
 	if (!trace_seq_printf(s, "%c%c%c",
-			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
-				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
-				  'X' : '.',
-			      (entry->flags & TRACE_FLAG_NEED_RESCHED) ?
-				'N' : '.',
-			      (hardirq && softirq) ? 'H' :
-				hardirq ? 'h' : softirq ? 's' : '.'))
+			      irqs_off, need_resched, hardsoft_irq))
 		return 0;
 
 	if (entry->preempt_count)
-- 
1.7.3.1

