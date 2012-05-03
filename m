Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2ECQfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:35:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2ECQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:35:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf ui browser: Introduce routine to draw vertical line
Date: Thu,  3 May 2012 13:35:33 -0300
Message-Id: <1336062935-19964-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336062935-19964-1-git-send-email-acme@infradead.org>
References: <1336062935-19964-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-umb4jlu0ee8r2rc3x4jkahgk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c |    9 +++++++++
 tools/perf/ui/browser.h |    2 ++
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index f4b2530..b075e09 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -593,6 +593,15 @@ unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
 	return row;
 }
 
+void __ui_browser__vline(struct ui_browser *browser, unsigned int column,
+			 u16 start, u16 end)
+{
+	SLsmg_set_char_set(1);
+	ui_browser__gotorc(browser, start, column);
+	SLsmg_draw_vline(end - start + 1);
+	SLsmg_set_char_set(0);
+}
+
 void ui_browser__write_graph(struct ui_browser *browser __used, int graph)
 {
 	SLsmg_set_char_set(1);
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 059764b..511e24d 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -49,6 +49,8 @@ int ui_browser__refresh(struct ui_browser *self);
 int ui_browser__run(struct ui_browser *browser, int delay_secs);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 void ui_browser__handle_resize(struct ui_browser *browser);
+void __ui_browser__vline(struct ui_browser *browser, unsigned int column,
+			 u16 start, u16 end);
 
 int ui_browser__warning(struct ui_browser *browser, int timeout,
 			const char *format, ...);
-- 
1.7.9.2.358.g22243

