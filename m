Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0FYN7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:59:42 -0400
Received: from [18.85.46.34] ([18.85.46.34]:57131 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab0FYN7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/6] perf ui: Introduce routine ui_browser__is_current_entry
Date: Fri, 25 Jun 2010 10:59:22 -0300
Message-Id: <1277474366-7958-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1277474366-7958-1-git-send-email-acme@infradead.org>
References: <1277474366-7958-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used in more places in the new tree widget.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index cf182ca..1e774e7 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -270,6 +270,11 @@ struct ui_browser {
 	u32		nr_entries;
 };
 
+static bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
+{
+	return (self->first_visible_entry_idx + row) == self->index;
+}
+
 static void ui_browser__refresh_dimensions(struct ui_browser *self)
 {
 	int cols, rows;
@@ -286,8 +291,8 @@ static void ui_browser__refresh_dimensions(struct ui_browser *self)
 
 static void ui_browser__reset_index(struct ui_browser *self)
 {
-        self->index = self->first_visible_entry_idx = 0;
-        self->first_visible_entry = NULL;
+	self->index = self->first_visible_entry_idx = 0;
+	self->first_visible_entry = NULL;
 }
 
 static int objdump_line__show(struct objdump_line *self, struct list_head *head,
@@ -353,7 +358,7 @@ static int ui_browser__refresh_entries(struct ui_browser *self)
 	pos = list_entry(self->first_visible_entry, struct objdump_line, node);
 
 	list_for_each_entry_from(pos, head, node) {
-		bool current_entry = (self->first_visible_entry_idx + row) == self->index;
+		bool current_entry = ui_browser__is_current_entry(self, row);
 		SLsmg_gotorc(self->top + row, self->left);
 		objdump_line__show(pos, head, self->width,
 				   he, len, current_entry);
-- 
1.6.2.5

