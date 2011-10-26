Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764Ab1JZRso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:48:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:54948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab1JZRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/11] perf ui: Reimplement ui_helpline using libslang
Date: Wed, 26 Oct 2011 15:48:27 -0200
Message-Id: <1319651314-29404-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just another step in stopping the use of libnewt in perf.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gh7e1v2z7pzqmok02r6zvp17@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/helpline.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index f36d2ff..600243d 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -1,20 +1,22 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
-#include <newt.h>
 
 #include "../debug.h"
 #include "helpline.h"
 #include "ui.h"
+#include "libslang.h"
 
 void ui_helpline__pop(void)
 {
-	newtPopHelpLine();
 }
 
 void ui_helpline__push(const char *msg)
 {
-	newtPushHelpLine(msg);
+	SLsmg_gotorc(SLtt_Screen_Rows - 1, 0);
+	SLsmg_set_color(0);
+	SLsmg_write_nstring((char *)msg, SLtt_Screen_Cols);
+	SLsmg_refresh();
 }
 
 void ui_helpline__vpush(const char *fmt, va_list ap)
@@ -63,7 +65,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 
 	if (ui_helpline__last_msg[backlog - 1] == '\n') {
 		ui_helpline__puts(ui_helpline__last_msg);
-		newtRefresh();
+		SLsmg_refresh();
 		backlog = 0;
 	}
 	pthread_mutex_unlock(&ui__lock);
-- 
1.6.2.5

