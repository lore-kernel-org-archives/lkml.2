Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2DMSCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:02:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2DMSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:02:48 -0400
Date: Fri, 13 Apr 2012 11:01:51 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-9nfecmgghgl5747rjxqpc28f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, eric.dumazet@gmail.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Add intel_idle to the skip list
Git-Commit-ID: 4bea8b5cf8c6e875fa43e617cd52858a07ae8ea8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:01:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bea8b5cf8c6e875fa43e617cd52858a07ae8ea8
Gitweb:     http://git.kernel.org/tip/4bea8b5cf8c6e875fa43e617cd52858a07ae8ea8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Apr 2012 11:16:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Apr 2012 18:48:01 -0300

perf top: Add intel_idle to the skip list

TODO: Accrue the cycles in the skip_list to an idle total, and show this
on the 'top' UI, as suggested by Steven.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-9nfecmgghgl5747rjxqpc28f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63ae..fab0a1c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -615,6 +615,7 @@ process_hotkey:
 
 /* Tag samples to be skipped. */
 static const char *skip_symbols[] = {
+	"intel_idle",
 	"default_idle",
 	"native_safe_halt",
 	"cpu_idle",
