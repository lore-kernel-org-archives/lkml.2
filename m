Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334Ab2EIX4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:56:03 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52411 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EIX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:56:00 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2] trace: power: add trace_clock_set_parent
Date: Wed,  9 May 2012 16:55:53 -0700
Message-Id: <1336607756-7947-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new trace event to be called from clk_set_parent.  Some
cpufreq drivers, including Tegra, reparent the cpu clock to a
slower clock while the main pll is relocking, tracing
clk_set_parent allows traces to show how for long the cpu is
running slower.

Uses a separate TRACE_EVENT instead of the clock event class to
allow the event to contain string names for the child and the
parent.

Signed-off-by: Colin Cross <ccross@android.com>
---
 include/trace/events/power.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index cae9a94..9271f5d 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -204,6 +204,25 @@ enum {
 	TP_ARGS(name, state, cpu_id)
 );
 
+TRACE_EVENT(clock_set_parent,
+
+	TP_PROTO(const char *name, const char *parent_name),
+
+	TP_ARGS(name, parent_name),
+
+	TP_STRUCT__entry(
+		__string(       name,           name            )
+		__string(       parent_name,    parent_name     )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__assign_str(parent_name, parent_name);
+	),
+
+	TP_printk("%s parent=%s", __get_str(name), __get_str(parent_name))
+);
+
 /*
  * The power domain events are used for power domains transitions
  */
-- 
1.7.7.3

