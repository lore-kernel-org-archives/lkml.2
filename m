Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2DDSaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:30:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63846 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2DDSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:30:06 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND 2/2] perf tools: Move GTK+ bits to tools/perf/ui/gtk directory
References: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com>
	<1333003004-6391-3-git-send-email-namhyung.kim@lge.com>
	<alpine.LFD.2.02.1204022041010.1950@tux.localdomain>
Date: Wed, 04 Apr 2012 11:29:37 -0700
In-Reply-To: <alpine.LFD.2.02.1204022041010.1950@tux.localdomain> (Pekka
	Enberg's message of "Mon, 2 Apr 2012 20:41:33 +0300 (EEST)")
Message-ID: <874nsz8i5q.fsf_-_@dasan.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move those files to new directory in order to be prepared to
further UI work. Makefile and header file pathes are adjusted
accordingly. Also fix a build breakage if NO_GTK2=1 is given.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
Regenerated with git format-patch -M.

 tools/perf/Makefile                   |    4 ++--
 tools/perf/{util => ui}/gtk/browser.c |    0
 tools/perf/{util => ui}/gtk/gtk.h     |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/perf/{util => ui}/gtk/browser.c (100%)
 rename tools/perf/{util => ui}/gtk/gtk.h (100%)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e29865b..1cd1a46 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -508,7 +508,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
@@ -517,7 +517,7 @@ else
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
1.7.9.3

