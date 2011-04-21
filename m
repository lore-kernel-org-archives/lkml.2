Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1DUJWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:22:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1DUJWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:22:34 -0400
Date: Thu, 21 Apr 2011 09:22:25 GMT
From: tip-bot for Michael Witten <mfwitten@gmail.com>
Message-ID: <tip-58n38o02ocuzrm9qh096hsf5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mfwitten@gmail.com, rprabhu@wnohang.net,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, mfwitten@gmail.com, rprabhu@wnohang.net,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Makefile: Clean up `python/perf.so' rule
Git-Commit-ID: 3643b133f2cb8023e8cedcbef43215a99d7df561
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 09:22:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3643b133f2cb8023e8cedcbef43215a99d7df561
Gitweb:     http://git.kernel.org/tip/3643b133f2cb8023e8cedcbef43215a99d7df561
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Sat, 9 Apr 2011 01:12:56 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Apr 2011 08:18:36 -0300

perf tools: Makefile: Clean up `python/perf.so' rule

There is no need for a subshell or an explicit `export';
as per the POSIX Shell Command Language specification:

  http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_09_01
  http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_10_02

It is only necessary to include the environment variable
assignment just before the command to be run.

Also, it is better to use single-quotes, because GNU make
might expand `$(BASIC_CFLAGS)' into something that the shell
could interpret within double-quotes.

Acked-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Link: http://lkml.kernel.org/n/tip-58n38o02ocuzrm9qh096hsf5@git.kernel.org
Signed-off-by: Michael Witten <mfwitten@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 207dee5..aaf4dd3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -165,12 +165,10 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)( \
-		export CFLAGS="$(BASIC_CFLAGS)"; \
-		python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
-			--build-temp='$(OUTPUT)python/temp' \
-	)
-
+	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' python util/setup.py \
+	  --quiet build_ext \
+	  --build-lib='$(OUTPUT)python' \
+	  --build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
 #
