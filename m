Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2E3HoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:44:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35245 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2E3HoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:44:20 -0400
Date: Wed, 30 May 2012 00:43:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-4ccyiebqju4uatm31ky7725b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Do not use _FORTIFY_SOURCE when DEBUG=1 is specified
Git-Commit-ID: a83eb3ea97efbc891b2f67e91329638cd4e21622
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:43:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a83eb3ea97efbc891b2f67e91329638cd4e21622
Gitweb:     http://git.kernel.org/tip/a83eb3ea97efbc891b2f67e91329638cd4e21622
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 May 2012 14:48:39 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 May 2012 14:48:39 -0300

perf tools: Do not use _FORTIFY_SOURCE when DEBUG=1 is specified

As:

make DEBUG=1 -C tools/perf

disables optimizations and _FORTIFY_SOURCE in recent distros requires
optimizations to be enabled, seen on a Fedora 17 system:

[acme@Fedora17 linux]$ make DEBUG=1 O=/home/acme/git/build/perf/ -C
tools/perf install
In file included from /usr/include/sys/types.h:26:0,
                 from /usr/include/libelf.h:53,
                 from /usr/include/gelf.h:53,
                 from /usr/include/elfutils/libdw.h:53,
                 from <stdin>:2:
/usr/include/features.h:314:4: error: #warning _FORTIFY_SOURCE requires
compiling with optimization (-O) [-Werror=cpp

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4ccyiebqju4uatm31ky7725b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1d3d513..0eee64c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -80,7 +80,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6
+  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
 endif
 
 ifdef PARSER_DEBUG
@@ -89,7 +89,7 @@ ifdef PARSER_DEBUG
 	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
