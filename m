Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2DGUzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:55:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51990 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DGUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:54:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/8] perf ui browser: Return the current color when setting a new one
Date: Sat,  7 Apr 2012 17:54:02 -0300
Message-Id: <1333832049-2399-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333832049-2399-1-git-send-email-acme@infradead.org>
References: <1333832049-2399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Tools that want to change parts of the line to a different color and
then restore the previous one will use this, starting with the annotate
browser that will change the color of addresses if not on the current
entry, i.e. the selected one.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-uiajpevhxo4mzrvna6remb4a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c |    5 ++++-
 tools/perf/util/ui/browser.h |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 5568291..076a5ff 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -27,9 +27,12 @@ static int ui_browser__percent_color(struct ui_browser *browser,
 	return HE_COLORSET_NORMAL;
 }
 
-void ui_browser__set_color(struct ui_browser *self __used, int color)
+int ui_browser__set_color(struct ui_browser *browser, int color)
 {
+	int ret = browser->current_color;
+	browser->current_color = color;
 	SLsmg_set_color(color);
+	return ret;
 }
 
 void ui_browser__set_percent_color(struct ui_browser *self,
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 6ee82f6..65b2592 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -15,6 +15,7 @@ struct ui_browser {
 	u64	      index, top_idx;
 	void	      *top, *entries;
 	u16	      y, x, width, height;
+	int	      current_color;
 	void	      *priv;
 	const char    *title;
 	char	      *helpline;
@@ -27,7 +28,7 @@ struct ui_browser {
 	bool	      use_navkeypressed;
 };
 
-void ui_browser__set_color(struct ui_browser *self, int color);
+int  ui_browser__set_color(struct ui_browser *browser, int color);
 void ui_browser__set_percent_color(struct ui_browser *self,
 				   double percent, bool current);
 bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row);
-- 
1.7.9.2.358.g22243

