Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0FYP3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:29:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:51251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0FYP3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:29:44 -0400
Date: Fri, 25 Jun 2010 15:29:12 GMT
From: tip-bot for Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
       guijianfeng@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
       guijianfeng@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C241140.9090008@cn.fujitsu.com>
References: <4C241140.9090008@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Get rid of unused guest_kallsyms
Message-ID: <tip-830f4c803196eec181e209110885c4ac130f3805@git.kernel.org>
Git-Commit-ID: 830f4c803196eec181e209110885c4ac130f3805
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 15:29:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  830f4c803196eec181e209110885c4ac130f3805
Gitweb:     http://git.kernel.org/tip/830f4c803196eec181e209110885c4ac130f3805
Author:     Gui Jianfeng <guijianfeng@cn.fujitsu.com>
AuthorDate: Fri, 25 Jun 2010 10:15:28 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jun 2010 07:28:21 -0300

perf kvm: Get rid of unused guest_kallsyms

guest_kallsyms is redundant here, remove it.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
LKML-Reference: <4C241140.9090008@cn.fujitsu.com>
Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 86b1c3b..0df6408 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -445,8 +445,6 @@ static void atexit_header(void)
 static void event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
-	char *guest_kallsyms;
-	char path[PATH_MAX];
 	struct perf_session *psession = data;
 
 	if (machine__is_host(machine))
@@ -466,13 +464,6 @@ static void event__synthesize_guest_os(struct machine *machine, void *data)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
 
-	if (machine__is_default_guest(machine))
-		guest_kallsyms = (char *) symbol_conf.default_guest_kallsyms;
-	else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-		guest_kallsyms = path;
-	}
-
 	/*
 	 * We use _stext for guest kernel because guest kernel's /proc/kallsyms
 	 * have no _text sometimes.
