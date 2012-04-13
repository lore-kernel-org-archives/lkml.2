Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2DMSGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:06:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51439 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2DMSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:06:34 -0400
Date: Fri, 13 Apr 2012 11:05:57 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-uiajpevhxo4mzrvna6remb4a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser:
  Return the current color when setting a new one
Git-Commit-ID: 087091652bf8b351432a3f3fb50996ee3582d5e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:06:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  087091652bf8b351432a3f3fb50996ee3582d5e4
Gitweb:     http://git.kernel.org/tip/087091652bf8b351432a3f3fb50996ee3582d5e4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Apr 2012 12:48:56 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 16:08:42 -0300

perf ui browser: Return the current color when setting a new one

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
