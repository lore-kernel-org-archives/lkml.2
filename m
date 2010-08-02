Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0HBBK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:10:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:51000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0HBBJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/19] perf tui: Make CTRL+Z suspend perf
Date: Sun,  1 Aug 2010 22:08:51 -0300
Message-Id: <1280711334-30000-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 28f74eb..91de99b 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -11,6 +11,7 @@
 #define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
 #endif
 #include <slang.h>
+#include <signal.h>
 #include <stdlib.h>
 #include <newt.h>
 #include <sys/ttydefaults.h>
@@ -891,6 +892,13 @@ static struct newtPercentTreeColors {
 	"blue",	     "lightgray",
 };
 
+static void newt_suspend(void *d __used)
+{
+	newtSuspend();
+	raise(SIGTSTP);
+	newtResume();
+}
+
 void setup_browser(void)
 {
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
@@ -904,6 +912,7 @@ void setup_browser(void)
 	use_browser = 1;
 	newtInit();
 	newtCls();
+	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__puts(" ");
 	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
 	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
-- 
1.6.2.5

