Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992659Ab2KOBsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:48:53 -0500
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57858 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992580Ab2KOBsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:48:18 -0500
From: David Sharp <dhsharp@google.com>
To: Steven Rostedt <rostedt@goodmis.net>, linux-kernel@vger.kernel.org
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 3/4] kernel-shark: Don't check for system name for sched events
Date: Wed, 14 Nov 2012 17:48:07 -0800
Message-Id: <1352944088-21333-3-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352944088-21333-1-git-send-email-dhsharp@google.com>
References: <1352944088-21333-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

The sched tracepoint names are unique and so there is no need to check
for the subsystem name while looking up the event ID.

This helps kernel shark display the graphs correctly for trace.dat files
generated from trace collection mechanisms that don't record the subsystem.

Google-Bug-Id: 6333917
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: David Sharp <dhsharp@google.com>
---
 trace-graph.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/trace-graph.c b/trace-graph.c
index 4d81219..6f72350 100644
--- a/trace-graph.c
+++ b/trace-graph.c
@@ -1016,7 +1016,7 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 		found = FALSE;
 
 		event = pevent_find_event_by_name(ginfo->pevent,
-						  "sched", "sched_wakeup");
+						  NULL, "sched_wakeup");
 		if (event) {
 			found = TRUE;
 			ginfo->event_wakeup_id = event->id;
@@ -1026,7 +1026,7 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 
 
 		event = pevent_find_event_by_name(ginfo->pevent,
-						  "sched", "sched_wakeup_new");
+						  NULL, "sched_wakeup_new");
 		if (event) {
 			found = TRUE;
 			ginfo->event_wakeup_new_id = event->id;
@@ -1086,7 +1086,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 
 	if (ginfo->event_sched_switch_id < 0) {
 		event = pevent_find_event_by_name(ginfo->pevent,
-						  "sched", "sched_switch");
+						  NULL, "sched_switch");
 		if (!event)
 			return 0;
 
-- 
1.7.7.3

