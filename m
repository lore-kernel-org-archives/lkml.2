Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1BHPTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:19:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:34292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab1BHPTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:19:44 -0500
Date: Tue, 8 Feb 2011 15:18:26 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, bp@amd64.org, fweisbec@gmail.com,
        tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        tzanussi@gmail.com, efault@gmx.de, peterz@infradead.org, bp@amd64.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
In-Reply-To: <20110207143218.GA31197@kryptos.osrc.amd.com>
References: <20110207143218.GA31197@kryptos.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix build error
Message-ID: <tip-a2221796256ea7b236cec6bf027c1c1de5b8ccd7@git.kernel.org>
Git-Commit-ID: a2221796256ea7b236cec6bf027c1c1de5b8ccd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 15:18:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2221796256ea7b236cec6bf027c1c1de5b8ccd7
Gitweb:     http://git.kernel.org/tip/a2221796256ea7b236cec6bf027c1c1de5b8ccd7
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Mon, 7 Feb 2011 15:32:18 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Feb 2011 12:41:55 -0200

perf annotate: Fix build error

A small fix for when NO_NEWT_SUPPORT is defined.

Add a missing "struct" to the function prototype.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20110207143218.GA31197@kryptos.osrc.amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b1253aa..bc08b36 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -82,7 +82,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int max_lines);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int symbol__tui_annotate(symbol *sym __used,
+static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used, int evidx __used)
 {
 	return 0;
