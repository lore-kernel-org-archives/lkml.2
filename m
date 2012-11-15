Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992683Ab2KOBvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:51:23 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37511 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992614Ab2KOBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:51:17 -0500
From: David Sharp <dhsharp@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>
Subject: [PATCH 4/4] kernelshark: Full-height cursor and mark lines
Date: Wed, 14 Nov 2012 17:51:14 -0800
Message-Id: <1352944274-21699-4-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352944274-21699-1-git-send-email-dhsharp@google.com>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"width" and "height" were swapped, causing the vertical marker and cursor lines
to be drawn with the wrong height.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 trace-graph.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/trace-graph.c b/trace-graph.c
index 6f72350..60e5241 100644
--- a/trace-graph.c
+++ b/trace-graph.c
@@ -380,7 +380,7 @@ static void draw_cursor(struct graph_info *ginfo)
 	x = convert_time_to_x(ginfo, ginfo->cursor);
 
 	gdk_draw_line(ginfo->draw->window, ginfo->draw->style->mid_gc[3],
-		      x, 0, x, ginfo->draw->allocation.width);
+		      x, 0, x, ginfo->draw->allocation.height);
 }
 
 static void draw_marka(struct graph_info *ginfo)
@@ -392,7 +392,7 @@ static void draw_marka(struct graph_info *ginfo)
 
 	x = convert_time_to_x(ginfo, ginfo->marka_time);
 	gdk_draw_line(ginfo->draw->window, green,
-		      x, 0, x, ginfo->draw->allocation.width);
+		      x, 0, x, ginfo->draw->allocation.height);
 }
 
 static void draw_markb(struct graph_info *ginfo)
@@ -404,7 +404,7 @@ static void draw_markb(struct graph_info *ginfo)
 
 	x = convert_time_to_x(ginfo, ginfo->markb_time);
 	gdk_draw_line(ginfo->draw->window, red,
-		      x, 0, x, ginfo->draw->allocation.width);
+		      x, 0, x, ginfo->draw->allocation.height);
 }
 
 static void update_with_backend(struct graph_info *ginfo,
@@ -434,7 +434,7 @@ static void
 draw_line(GtkWidget *widget, gdouble x, struct graph_info *ginfo)
 {
 	gdk_draw_line(widget->window, widget->style->black_gc,
-		      x, 0, x, widget->allocation.width);
+		      x, 0, x, widget->allocation.height);
 }
 
 static void clear_line(struct graph_info *ginfo, gint x)
-- 
1.7.7.3

