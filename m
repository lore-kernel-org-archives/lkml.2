Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0HBHyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:54:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0HBHyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:54:13 -0400
Date: Mon, 2 Aug 2010 07:53:33 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tui: Make CTRL+Z suspend perf
Message-ID: <tip-73ae8f85fda49410a59d7b532ce69a0b811ef6d5@git.kernel.org>
Git-Commit-ID: 73ae8f85fda49410a59d7b532ce69a0b811ef6d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:53:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73ae8f85fda49410a59d7b532ce69a0b811ef6d5
Gitweb:     http://git.kernel.org/tip/73ae8f85fda49410a59d7b532ce69a0b811ef6d5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 30 Jul 2010 10:06:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 30 Jul 2010 10:06:06 -0300

perf tui: Make CTRL+Z suspend perf

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
