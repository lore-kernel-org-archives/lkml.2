Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1HNPiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:38:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:60901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1HNPix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:38:53 -0400
Date: Sun, 14 Aug 2011 15:38:08 GMT
From: tip-bot for Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <tip-e9b52ef2228cd0bed7a4465c693a39489e2c338d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        segoon@openwall.com, peterz@infradead.org, penberg@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, segoon@openwall.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110811205537.GA22864@albatros>
References: <20110811205537.GA22864@albatros>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: fix temporary file ownership check
Git-Commit-ID: e9b52ef2228cd0bed7a4465c693a39489e2c338d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:38:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9b52ef2228cd0bed7a4465c693a39489e2c338d
Gitweb:     http://git.kernel.org/tip/e9b52ef2228cd0bed7a4465c693a39489e2c338d
Author:     Vasiliy Kulikov <segoon@openwall.com>
AuthorDate: Fri, 12 Aug 2011 00:55:37 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Aug 2011 08:28:17 -0300

perf: fix temporary file ownership check

A file in /tmp/ might be a symlink, so lstat() should be used instead of
stat().

Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110811205537.GA22864@albatros
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e142c21..469c026 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1506,7 +1506,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
 		struct stat st;
 
-		if (stat(dso->name, &st) < 0)
+		if (lstat(dso->name, &st) < 0)
 			return -1;
 
 		if (st.st_uid && (st.st_uid != geteuid())) {
