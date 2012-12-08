Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab2LHOuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:50:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab2LHOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:50:39 -0500
Date: Sat, 8 Dec 2012 06:50:18 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-f95e0818cbd026a8f2277895c65fcc9cc5b28cf6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1352508412-16914-13-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-13-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Check for mkstemp return value in dso-data test
Git-Commit-ID: f95e0818cbd026a8f2277895c65fcc9cc5b28cf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:50:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f95e0818cbd026a8f2277895c65fcc9cc5b28cf6
Gitweb:     http://git.kernel.org/tip/f95e0818cbd026a8f2277895c65fcc9cc5b28cf6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 10 Nov 2012 01:46:52 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:50:30 -0300

perf tests: Check for mkstemp return value in dso-data test

Adding check for mkstemp return error value in dso-data test.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-13-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dso-data.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index b5198f5..5eaffa2 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -26,6 +26,10 @@ static char *test_file(int size)
 	unsigned char *buf;
 
 	fd = mkstemp(templ);
+	if (fd < 0) {
+		perror("mkstemp failed");
+		return NULL;
+	}
 
 	buf = malloc(size);
 	if (!buf) {
