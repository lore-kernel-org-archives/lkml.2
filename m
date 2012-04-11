Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2DKVFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:05:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab2DKVFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter@infradead.org, "Zijlstra <a.p.zijlstra"@chello.nl,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/13] perf tools: Move GTK+ bits to tools/perf/ui/gtk directory
Date: Wed, 11 Apr 2012 18:05:22 -0300
Message-Id: <1334178325-19148-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Move those files to new directory in order to be prepared to
further UI work. Makefile and header file pathes are adjusted
accordingly. Also fix a build breakage if NO_GTK2=1 is given.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/1333523765-12092-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                   |    4 ++--
 tools/perf/{util => ui}/gtk/browser.c |    0
 tools/perf/{util => ui}/gtk/gtk.h     |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/perf/{util => ui}/gtk/browser.c (100%)
 rename tools/perf/{util => ui}/gtk/gtk.h (100%)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index af6ccf8..e98e14c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -493,7 +493,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
@@ -502,7 +502,7 @@ else
 	else
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
-		LIB_OBJS += $(OUTPUT)util/gtk/browser.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
 	endif
 endif
 
diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/ui/gtk/browser.c
similarity index 100%
rename from tools/perf/util/gtk/browser.c
rename to tools/perf/ui/gtk/browser.c
diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
similarity index 100%
rename from tools/perf/util/gtk/gtk.h
rename to tools/perf/ui/gtk/gtk.h
-- 
1.7.9.2.358.g22243

