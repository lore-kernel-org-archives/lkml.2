Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935166Ab0HFBqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:46:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:54655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231Ab0HFBqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:46:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] perf ui: Shorten ui_browser->refresh_entries to refresh
Date: Thu,  5 Aug 2010 22:46:10 -0300
Message-Id: <1281059177-18747-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281059177-18747-1-git-send-email-acme@infradead.org>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index fc4a2b3..f98a240 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -280,7 +280,7 @@ struct ui_browser {
 	void		*first_visible_entry, *entries;
 	u16		top, left, width, height;
 	void		*priv;
-	unsigned int	(*refresh_entries)(struct ui_browser *self);
+	unsigned int	(*refresh)(struct ui_browser *self);
 	void		(*write)(struct ui_browser *self, void *entry, int row);
 	void		(*seek)(struct ui_browser *self,
 				off_t offset, int whence);
@@ -472,12 +472,12 @@ static int objdump_line__show(struct objdump_line *self, struct list_head *head,
 	return 0;
 }
 
-static int ui_browser__refresh_entries(struct ui_browser *self)
+static int ui_browser__refresh(struct ui_browser *self)
 {
 	int row;
 
 	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
-	row = self->refresh_entries(self);
+	row = self->refresh(self);
 	SLsmg_set_color(HE_COLORSET_NORMAL);
 	SLsmg_fill_region(self->top + row, self->left,
 			  self->height - row, self->width, ' ');
@@ -487,7 +487,7 @@ static int ui_browser__refresh_entries(struct ui_browser *self)
 
 static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 {
-	if (ui_browser__refresh_entries(self) < 0)
+	if (ui_browser__refresh(self) < 0)
 		return -1;
 
 	while (1) {
@@ -558,7 +558,7 @@ static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 		default:
 			return es->u.key;
 		}
-		if (ui_browser__refresh_entries(self) < 0)
+		if (ui_browser__refresh(self) < 0)
 			return -1;
 	}
 	return 0;
@@ -621,9 +621,9 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	ui_helpline__push("Press <- or ESC to exit");
 
 	memset(&browser, 0, sizeof(browser));
-	browser.entries		= &head;
-	browser.refresh_entries = hist_entry__annotate_browser_refresh;
-	browser.seek		= ui_browser__list_head_seek;
+	browser.entries	= &head;
+	browser.refresh = hist_entry__annotate_browser_refresh;
+	browser.seek	= ui_browser__list_head_seek;
 	browser.priv = self;
 	list_for_each_entry(pos, &head, node) {
 		size_t line_len = strlen(pos->line);
@@ -675,7 +675,7 @@ static int map__browse(struct map *self)
 	struct map_browser mb = {
 		.b = {
 			.entries = &self->dso->symbols[self->type],
-			.refresh_entries = ui_browser__rb_tree_refresh,
+			.refresh = ui_browser__rb_tree_refresh,
 			.seek	 = ui_browser__rb_tree_seek,
 			.write	 = map_browser__write,
 		},
@@ -720,7 +720,7 @@ struct hist_browser {
 static void hist_browser__reset(struct hist_browser *self);
 static int hist_browser__run(struct hist_browser *self, const char *title,
 			     struct newtExitStruct *es);
-static unsigned int hist_browser__refresh_entries(struct ui_browser *self);
+static unsigned int hist_browser__refresh(struct ui_browser *self);
 static void ui_browser__hists_seek(struct ui_browser *self,
 				   off_t offset, int whence);
 
@@ -730,7 +730,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 
 	if (self) {
 		self->hists = hists;
-		self->b.refresh_entries = hist_browser__refresh_entries;
+		self->b.refresh = hist_browser__refresh;
 		self->b.seek = ui_browser__hists_seek;
 	}
 
@@ -1338,7 +1338,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	return printed;
 }
 
-static unsigned int hist_browser__refresh_entries(struct ui_browser *self)
+static unsigned int hist_browser__refresh(struct ui_browser *self)
 {
 	unsigned row = 0;
 	struct rb_node *nd;
-- 
1.6.2.5

