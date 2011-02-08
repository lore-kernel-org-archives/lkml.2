Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1BHPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:16:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:43441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab1BHPQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:16:06 -0500
Date: Tue, 8 Feb 2011 15:15:47 GMT
From: tip-bot for Michael Witten <mfwitten@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
In-Reply-To: <1296890359-22659-1-git-send-email-mfwitten@gmail.com>
References: <1296890359-22659-1-git-send-email-mfwitten@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Makefile: Use $(QUIET_GEN) for perf.so
Message-ID: <tip-9c56dfeb784a586713f467e2028a127a2a58a238@git.kernel.org>
Git-Commit-ID: 9c56dfeb784a586713f467e2028a127a2a58a238
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 15:15:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c56dfeb784a586713f467e2028a127a2a58a238
Gitweb:     http://git.kernel.org/tip/9c56dfeb784a586713f467e2028a127a2a58a238
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Thu, 3 Feb 2011 22:10:55 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Feb 2011 08:38:03 -0200

perf tools: Makefile: Use $(QUIET_GEN) for perf.so

So that we get this:

    CC /home/acme/git/build/perf/bench/mem-memcpy-x86-64-asm.o
    GEN perf-archive
*   GEN /home/acme/git/build/perf/python/perf.so
    CC /home/acme/git/build/perf/builtin-annotate.o

Instead of silently building the python binding.

LKML-Reference: <1296890359-22659-1-git-send-email-mfwitten@gmail.com>
Signed-off-by: Michael Witten <mfwitten@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index be3eb1d..94f73ab 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -326,7 +326,7 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	@python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
 						--build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
