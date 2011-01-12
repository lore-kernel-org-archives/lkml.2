Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1ALKw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:52:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:48104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab1ALKwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:52:55 -0500
Date: Wed, 12 Jan 2011 10:52:11 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        kirr@mns.spb.ru, acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        tzanussi@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, kirr@mns.spb.ru,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Fix annotate segv
Message-ID: <tip-cc841580aa58ad7498b23e282859d07f8b721e24@git.kernel.org>
Git-Commit-ID: cc841580aa58ad7498b23e282859d07f8b721e24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 Jan 2011 10:52:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc841580aa58ad7498b23e282859d07f8b721e24
Gitweb:     http://git.kernel.org/tip/cc841580aa58ad7498b23e282859d07f8b721e24
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Jan 2011 15:16:52 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Jan 2011 16:56:16 -0200

perf top: Fix annotate segv

Before we had sym_counter, it was initialized to zero and we used that
as an index in the global attrs variable, now we have a list of evsel
entries, and sym_counter became sym_evsel, that remained initialized to
zero (NULL): b00m.

Fix it by initializing it to the first entry in the evsel list.

Bug-introduced: 69aad6f
Reported-by: Kirill Smelkov <kirr@mns.spb.ru>
Tested-by: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4b995ee..568b195 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1473,6 +1473,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
+	sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
+
 	symbol_conf.priv_size = (sizeof(struct sym_entry) +
 				 (nr_counters + 1) * sizeof(unsigned long));
 
