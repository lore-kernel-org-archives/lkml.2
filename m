Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1AZHTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:19:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:55905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1AZHTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:19:20 -0500
Date: Wed, 26 Jan 2011 07:19:02 GMT
From: tip-bot for Han Pingtian <phan@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, phan@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, phan@redhat.com, tglx@linutronix.de
In-Reply-To: <20110114230050.GA7011@localhost>
References: <20110114230050.GA7011@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: check if cpu_map__new() return NULL
Message-ID: <tip-98d77b78504a423fca911a26a17bee00ef2fdda2@git.kernel.org>
Git-Commit-ID: 98d77b78504a423fca911a26a17bee00ef2fdda2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:19:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98d77b78504a423fca911a26a17bee00ef2fdda2
Gitweb:     http://git.kernel.org/tip/98d77b78504a423fca911a26a17bee00ef2fdda2
Author:     Han Pingtian <phan@redhat.com>
AuthorDate: Sat, 15 Jan 2011 07:00:50 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:30 -0200

perf test: check if cpu_map__new() return NULL

It looks like we should check if cpus is NULL after

	cpus = cpu_map__new(NULL);

in test__open_syscall_event_on_all_cpus().

LKML-Reference: <20110114230050.GA7011@localhost>
Signed-off-by: Han Pingtian <phan@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 7cc6b20..5a50e47 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -347,9 +347,9 @@ static int test__open_syscall_event_on_all_cpus(void)
 	}
 
 	cpus = cpu_map__new(NULL);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
+		goto out_thread_map_delete;
 	}
 
 
