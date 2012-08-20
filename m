Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2HTQaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:30:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56358 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab2HTQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/24] perf tools: Fix include order for bison/flex-generated C files
Date: Mon, 20 Aug 2012 13:26:23 -0300
Message-Id: <1345479985-18669-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

When we use a separate output directory, we add util/ to the include
path for the generated C files.  However, this is currently added to the
end of the path, behind /usr/include/slang and /usr/include/gtk-2.0 if
use of the respective libraries is enabled.  Thus the '#include
"../perf.h"' in util/parse-events.l can actually include
/usr/include/perf.h if it exists.

Move '-Iutil/' ahead of all the other preprocessor options.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Link: http://lkml.kernel.org/r/1345420039.22400.80.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 90cfecf..77e7ae3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -841,10 +841,10 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -w $<
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -w $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -w $<
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
-- 
1.7.1

