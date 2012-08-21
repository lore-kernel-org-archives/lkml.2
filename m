Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2HUQda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:33:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab2HUQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:33:25 -0400
Date: Tue, 21 Aug 2012 09:33:00 -0700
From: tip-bot for Ben Hutchings <ben@decadent.org.uk>
Message-ID: <tip-ed7e2c2ec59422b68b643c479a5816197620016e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ben@decadent.org.uk, tglx@linutronix.de,
        sedat.dilek@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        ben@decadent.org.uk, tglx@linutronix.de, sedat.dilek@gmail.com
In-Reply-To: <1345420039.22400.80.camel@deadeye.wl.decadent.org.uk>
References: <1345420039.22400.80.camel@deadeye.wl.decadent.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix include order for bison/
 flex-generated C files
Git-Commit-ID: ed7e2c2ec59422b68b643c479a5816197620016e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:33:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed7e2c2ec59422b68b643c479a5816197620016e
Gitweb:     http://git.kernel.org/tip/ed7e2c2ec59422b68b643c479a5816197620016e
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Mon, 20 Aug 2012 00:47:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Aug 2012 09:36:41 -0300

perf tools: Fix include order for bison/flex-generated C files

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
index 90cfecf..77e7ae3e 100644
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
