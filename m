Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1A1VFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:05:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:49956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab1A1VFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:05:39 -0500
Date: Fri, 28 Jan 2011 21:05:21 GMT
From: tip-bot for Han Pingtian <phan@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, phan@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, phan@redhat.com, tglx@linutronix.de
In-Reply-To: <20110124233900.GA3443@epc900.nay.redhat.com>
References: <20110124233900.GA3443@epc900.nay.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Fix return values checking
Message-ID: <tip-54489c189b1a0c10eaf21c6d2c5916b50442c871@git.kernel.org>
Git-Commit-ID: 54489c189b1a0c10eaf21c6d2c5916b50442c871
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 21:05:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54489c189b1a0c10eaf21c6d2c5916b50442c871
Gitweb:     http://git.kernel.org/tip/54489c189b1a0c10eaf21c6d2c5916b50442c871
Author:     Han Pingtian <phan@redhat.com>
AuthorDate: Tue, 25 Jan 2011 07:39:00 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Jan 2011 09:21:19 -0200

perf test: Fix return values checking

Fixing some cut'n'paste mistakes.

LKML-Reference: <20110124233900.GA3443@epc900.nay.redhat.com>
Signed-off-by: Han Pingtian <phan@redhat.com>
[ committer note: I had already removed the CPU_ALLOC calls ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 231e3e2..738830d 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -495,8 +495,8 @@ static int test__basic_mmap(void)
 	}
 
 	cpus = cpu_map__new(NULL);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
 		goto out_free_threads;
 	}
 
@@ -510,7 +510,7 @@ static int test__basic_mmap(void)
 	}
 
 	evlist = perf_evlist__new();
-	if (threads == NULL) {
+	if (evlist == NULL) {
 		pr_debug("perf_evlist__new\n");
 		goto out_free_cpus;
 	}
