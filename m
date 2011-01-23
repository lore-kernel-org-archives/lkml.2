Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1AWSCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:02:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:56023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1AWSCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:02:42 -0500
Date: Sun, 23 Jan 2011 18:02:12 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        eric.dumazet@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, tzanussi@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix build when using gcc 3.4.6
Message-ID: <tip-5c7a66822c8b619966d9367594054778608fc5d1@git.kernel.org>
Git-Commit-ID: 5c7a66822c8b619966d9367594054778608fc5d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 Jan 2011 18:02:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c7a66822c8b619966d9367594054778608fc5d1
Gitweb:     http://git.kernel.org/tip/5c7a66822c8b619966d9367594054778608fc5d1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 22 Jan 2011 19:12:38 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:15:39 -0200

perf tools: Fix build when using gcc 3.4.6

[acme@localhost linux]$ make O=~acme/git/build/perf -C tools/perf
make: Entering directory `/home/acme/git/linux/tools/perf'
Makefile:526: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
Makefile:582: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
    CC /home/acme/git/build/perf/builtin-annotate.o
In file included from builtin-annotate.c:23:
util/parse-events.h:26: warning: declaration of 'evsel_list' shadows a global declaration
util/parse-events.h:12: warning: shadowed declaration is here
make: *** [/home/acme/git/build/perf/builtin-annotate.o] Error 1
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@localhost linux]$ gcc --version | head -1
gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-11)
[acme@localhost linux]$

Fix it by renaming the parameter to evlist.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b82cafb..458e3ec 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -23,7 +23,7 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
-extern bool have_tracepoints(struct list_head *evsel_list);
+extern bool have_tracepoints(struct list_head *evlist);
 
 extern int			nr_counters;
 
