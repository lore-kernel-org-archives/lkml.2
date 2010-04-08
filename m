Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab0DHW6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 18:58:14 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:40792 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762Ab0DHW6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:58:12 -0400
Date: Thu, 8 Apr 2010 15:57:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: kernelshark: stop segfaults
Message-Id: <20100408155736.3d12af4f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBE5F7F.011A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Keep kernelshark from segfaulting when there is no open trace file.
It segfaults in:
  Filter->graph events
  Filter->graph advanced event
  Filter->list CPUs

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel-shark.c |    3 +++
 trace-filter.c |    6 ++++++
 2 files changed, 9 insertions(+)

--- trace-cmd-0.7.0.orig/kernel-shark.c
+++ trace-cmd-0.7.0/kernel-shark.c
@@ -309,6 +309,9 @@ cpus_clicked (gpointer data)
 	gboolean all_cpus;
 	guint64 *cpu_mask;
 
+	if (!info->handle)
+		return;
+
 	store = TRACE_VIEW_STORE(gtk_tree_view_get_model(trace_tree));
 
 	all_cpus = trace_view_store_get_all_cpus(store);
--- trace-cmd-0.7.0.orig/trace-filter.c
+++ trace-cmd-0.7.0/trace-filter.c
@@ -717,6 +717,9 @@ void trace_adv_filter_dialog(struct trac
 	GtkWidget *view;
 	GtkWidget *event_box;
 
+	if (!handle)
+		return;
+
 	helper = g_malloc(sizeof(*helper));
 	g_assert(helper);
 
@@ -1762,6 +1765,9 @@ void trace_filter_event_filter_dialog(st
 	gchar **systems;
 	gint *event_ids;
 
+	if (!handle)
+		return;
+
 	trace_filter_convert_filter_to_names(filter, &systems, &event_ids);
 
 	filter_event_dialog(handle, filter, all_events, systems,
