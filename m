Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0FYOAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:00:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:51795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0FYN7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf kvm: Get rid of unused guest_kallsyms
Date: Fri, 25 Jun 2010 10:59:26 -0300
Message-Id: <1277474366-7958-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1277474366-7958-1-git-send-email-acme@infradead.org>
References: <1277474366-7958-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

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
-- 
1.6.2.5

