Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2DOIhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 04:37:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2DOIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 04:37:07 -0400
Date: Sun, 15 Apr 2012 01:35:39 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-f755397211745e26a4cc693a195982de6c454edd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        penberg@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120410103513.GA9229@quad>
References: <20120410103513.GA9229@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: fix NO_GTK2 Makefile config error
Git-Commit-ID: f755397211745e26a4cc693a195982de6c454edd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Apr 2012 01:35:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f755397211745e26a4cc693a195982de6c454edd
Gitweb:     http://git.kernel.org/tip/f755397211745e26a4cc693a195982de6c454edd
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 10 Apr 2012 12:35:13 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 12 Apr 2012 15:48:15 -0300

perf tools: fix NO_GTK2 Makefile config error

In case the user specified NO_GTK2 on the make cmdline, compilation
would fail with undefined symbol because the Makefile would not set the
correct cpp variable: NO_GTK2 vs. NO_GTK2_SUPPORT.

This patch renames the variable to the correct name.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120410103513.GA9229@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..a20d0c5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -527,7 +527,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
