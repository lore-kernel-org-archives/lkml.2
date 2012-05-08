Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2EHPJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:09:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2EHPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:09:17 -0400
Date: Tue, 8 May 2012 08:08:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-umb4jlu0ee8r2rc3x4jkahgk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser:
  Introduce routine to draw vertical line
Git-Commit-ID: 4656cca11b07a13785aa8574ed4db6c540e48ed8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:08:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4656cca11b07a13785aa8574ed4db6c540e48ed8
Gitweb:     http://git.kernel.org/tip/4656cca11b07a13785aa8574ed4db6c540e48ed8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 3 May 2012 13:07:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 3 May 2012 13:07:05 -0300

perf ui browser: Introduce routine to draw vertical line

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
 2 files changed, 11 insertions(+), 0 deletions(-)

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
