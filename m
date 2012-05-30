Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2E3Hwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:52:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2E3Hwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:52:43 -0400
Date: Wed, 30 May 2012 00:52:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-7rhhf6m0a72p2wja4tgv1itg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf config: Allow '_'
  in config file variable names
Git-Commit-ID: 8dc7c651dd7d95b548adef8cd56908392d3ba432
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:52:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dc7c651dd7d95b548adef8cd56908392d3ba432
Gitweb:     http://git.kernel.org/tip/8dc7c651dd7d95b548adef8cd56908392d3ba432
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 29 May 2012 21:59:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 May 2012 21:59:02 -0300

perf config: Allow '_' in config file variable names

For annotate I want to be able to have variables that are the same as
the ones representing feature toggles.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7rhhf6m0a72p2wja4tgv1itg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 0deac6a..6faa3a1 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -120,7 +120,7 @@ static char *parse_value(void)
 
 static inline int iskeychar(int c)
 {
-	return isalnum(c) || c == '-';
+	return isalnum(c) || c == '-' || c == '_';
 }
 
 static int get_value(config_fn_t fn, void *data, char *name, unsigned int len)
