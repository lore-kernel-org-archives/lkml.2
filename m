Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2ISPLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:11:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2ISPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:11:39 -0400
Date: Wed, 19 Sep 2012 08:11:16 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-bb77ac3a36f896bc6acdfcafdebfa1434f775ed4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1347415866-303-1-git-send-email-namhyung@kernel.org>
References: <1347415866-303-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Fixup for the die() removal
Git-Commit-ID: bb77ac3a36f896bc6acdfcafdebfa1434f775ed4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:11:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb77ac3a36f896bc6acdfcafdebfa1434f775ed4
Gitweb:     http://git.kernel.org/tip/bb77ac3a36f896bc6acdfcafdebfa1434f775ed4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 12 Sep 2012 11:11:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Sep 2012 15:48:27 -0300

perf test: Fixup for the die() removal

The commit 32c7f7383a09 ("perf test: Remove die() calls") replaced die()
call to pr_debug + return -1, but it should be pr_err otherwise it'll
not show up unless -v option is given.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347415866-303-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index d33143e..4aed155 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1026,15 +1026,15 @@ static int __test__rdpmc(void)
 
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 	if (fd < 0) {
-		pr_debug("Error: sys_perf_event_open() syscall returned "
-			 "with %d (%s)\n", fd, strerror(errno));
+		pr_err("Error: sys_perf_event_open() syscall returned "
+		       "with %d (%s)\n", fd, strerror(errno));
 		return -1;
 	}
 
 	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
 	if (addr == (void *)(-1)) {
-		pr_debug("Error: mmap() syscall returned with (%s)\n",
-			 strerror(errno));
+		pr_err("Error: mmap() syscall returned with (%s)\n",
+		       strerror(errno));
 		goto out_close;
 	}
 
