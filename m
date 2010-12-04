Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0LDAN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:13:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0LDANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:13:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=sbhyBegJzrwOawfYDD+8nz0OQR1KvKFB80UVGMHaAPxx619iFNKsn0ci/b5+KYs23
	KHhYjNL/gpzSyvEuP+onQ==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH 13/15] small_traces: Add config option to shrink trace events.
Date: Fri,  3 Dec 2010 16:13:27 -0800
Message-Id: <1291421609-14665-14-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291421609-14665-1-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option will remove several fields from trace events to reduce the
payload size. Under heavy load, events can be produced faster than they
can possibly be written to disk or sent on the network. Shrinking the
payload size will enable fitting more traces in the ring buffer, which
therefore enables tracing for longer periods, at the cost of losing some
relatively unimportant details.

Google-Bug-Id: 3224547

Signed-off-by: David Sharp <dhsharp@google.com>
---
 kernel/trace/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index ea37e2f..9c24fe5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -403,6 +403,18 @@ config FUNCTION_PROFILER
 
 	  If in doubt, say N.
 
+config SMALL_TRACES
+	bool "Shrink trace events"
+	default n
+	help
+	  Minimize the size of trace events. Omits fields from trace event
+	  header like preempt_count, and lock_depth. Chooses smaller
+	  alternative event structures. Shrinking the payload size enables
+	  fitting more traces in the ring buffer, which enables tracing for
+	  longer periods when the buffer can not be read as fast as it is
+	  filled, at the cost of losing some details.
+
+
 config FTRACE_MCOUNT_RECORD
 	def_bool y
 	depends on DYNAMIC_FTRACE
-- 
1.7.3.1

