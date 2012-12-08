Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2LHPCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:02:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2LHPCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:02:15 -0500
Date: Sat, 8 Dec 2012 07:01:53 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-7da5c85dd34dd67846fec965e4bf1f761eecca05@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, penberg@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
References: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui tui: Move progress.c under ui/
 tui directory
Git-Commit-ID: 7da5c85dd34dd67846fec965e4bf1f761eecca05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 07:01:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7da5c85dd34dd67846fec965e4bf1f761eecca05
Gitweb:     http://git.kernel.org/tip/7da5c85dd34dd67846fec965e4bf1f761eecca05
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 13 Nov 2012 22:30:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:52:33 -0300

perf ui tui: Move progress.c under ui/tui directory

Current ui_progress functions are implemented for TUI only.  So move the
file under the tui directory.  This is needed for providing an UI-
agnostic wrapper.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1352813436-14173-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                | 2 +-
 tools/perf/ui/{ => tui}/progress.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9af012f..50e85c8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -617,11 +617,11 @@ ifndef NO_NEWT
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/tui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+		LIB_OBJS += $(OUTPUT)ui/tui/progress.o
 		LIB_H += ui/browser.h
 		LIB_H += ui/browsers/map.h
 		LIB_H += ui/keysyms.h
diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/tui/progress.c
similarity index 88%
rename from tools/perf/ui/progress.c
rename to tools/perf/ui/tui/progress.c
index 13aa64e..f8dc986 100644
--- a/tools/perf/ui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -1,8 +1,8 @@
 #include "../cache.h"
-#include "progress.h"
-#include "libslang.h"
-#include "ui.h"
-#include "browser.h"
+#include "../progress.h"
+#include "../libslang.h"
+#include "../ui.h"
+#include "../browser.h"
 
 void ui_progress__update(u64 curr, u64 total, const char *title)
 {
