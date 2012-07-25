Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2GYTbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:31:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2GYTbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:31:14 -0400
Date: Wed, 25 Jul 2012 12:30:56 -0700
From: "tip-bot for Kirill A. Shutemov" <kirill@shutemov.name>
Message-ID: <tip-043d1a5c14e95212dbf48251051804ede1ed1862@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de,
        kirill@shutemov.name
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, tglx@linutronix.de, kirill@shutemov.name
In-Reply-To: <20120723210407.GA25186@shutemov.name>
References: <20120723210407.GA25186@shutemov.name>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build error with bison 2.6
Git-Commit-ID: 043d1a5c14e95212dbf48251051804ede1ed1862
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  043d1a5c14e95212dbf48251051804ede1ed1862
Gitweb:     http://git.kernel.org/tip/043d1a5c14e95212dbf48251051804ede1ed1862
Author:     Kirill A. Shutemov <kirill@shutemov.name>
AuthorDate: Tue, 24 Jul 2012 00:04:07 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:49:19 -0300

perf tools: Fix build error with bison 2.6

Bison 2.6 started to generate parse_events_parse() declaration in header. In
this case we have redundant redeclaration:

util/parse-events.c:29:5: error: redundant redeclaration of ‘parse_events_parse’ [-Werror=redundant-decls]
In file included from util/parse-events.c:14:0:
util/parse-events-bison.h:99:5: note: previous declaration of ‘parse_events_parse’ was here
cc1: all warnings being treated as errors

Let's disable -Wredundant-decls for util/parse-events.c since it includes
header we can't control.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120723210407.GA25186@shutemov.name
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e8f0579..77f124f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -804,6 +804,9 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
+
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
