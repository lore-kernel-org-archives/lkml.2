Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0ERDbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:31:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:48510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0ERDbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:31:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf tui: Fix build problem with slang <= 2.0.6
Date: Tue, 18 May 2010 00:30:49 -0300
Message-Id: <1274153449-479-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274153449-479-1-git-send-email-acme@infradead.org>
References: <1274153449-479-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks the
build if it isn't defined. Use the equivalent one that glibc has on
features.h.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index ccb7c5b..9338d06 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1,7 +1,15 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #undef _GNU_SOURCE
-
+/*
+ * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
+ * the build if it isn't defined. Use the equivalent one that glibc
+ * has on features.h.
+ */
+#include <features.h>
+#ifndef HAVE_LONG_LONG
+#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
+#endif
 #include <slang.h>
 #include <stdlib.h>
 #include <newt.h>
-- 
1.6.2.5

