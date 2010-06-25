Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0FYCRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 22:17:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63595 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab0FYCRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 22:17:08 -0400
Message-ID: <4C241140.9090008@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 10:15:28 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
CC: mingo@elte.hu, linux kernel mailing list <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl
Subject: [PATCH 1/3] perf kvm: Get rid of unused guest_kallsyms
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

guest_kallsyms is redundant here, remove it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 tools/perf/builtin-record.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index dc3435e..abaf0f8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -439,8 +439,6 @@ static void atexit_header(void)
 static void event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
-	char *guest_kallsyms;
-	char path[PATH_MAX];
 	struct perf_session *psession = data;
 
 	if (machine__is_host(machine))
@@ -460,13 +458,6 @@ static void event__synthesize_guest_os(struct machine *machine, void *data)
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
1.6.5.2


