Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2DMSVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:21:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51769 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2DMSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:21:51 -0400
Date: Fri, 13 Apr 2012 11:21:27 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-e7b3ba6d8b29904c336e3e6a018bb80d1f63b1f4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, penberg@kernel.org,
        acme@ghostprotocols.net, namhyung.kim@lge.com, namhyung@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, acme@ghostprotocols.net,
        penberg@kernel.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1333523765-12092-1-git-send-email-namhyung.kim@lge.com>
References: <1333523765-12092-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move GTK+ bits to tools/perf/ui/
 gtk directory
Git-Commit-ID: e7b3ba6d8b29904c336e3e6a018bb80d1f63b1f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:21:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7b3ba6d8b29904c336e3e6a018bb80d1f63b1f4
Gitweb:     http://git.kernel.org/tip/e7b3ba6d8b29904c336e3e6a018bb80d1f63b1f4
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 4 Apr 2012 00:16:05 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 17:18:31 -0300

perf tools: Move GTK+ bits to tools/perf/ui/gtk directory

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
