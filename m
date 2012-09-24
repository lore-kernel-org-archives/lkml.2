Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2IXIYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:24:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56615 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2IXIXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:23:38 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-f4-506018879588
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 5/6] perf kvm: Use perf_session_env for reading cpuid
Date: Mon, 24 Sep 2012 17:15:02 +0900
Message-Id: <1348474503-15070-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We have processed and saved cpuid information to perf_session_env
so reuse it for get_cpu_isa().

Cc: David Ahern <dsahern@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-kvm.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 819af25a9a11..b76b3aa14ffd 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -664,16 +664,9 @@ static struct perf_tool eops = {
 
 static int get_cpu_isa(struct perf_session *session)
 {
-	char *cpuid;
+	char *cpuid = session->header.env.cpuid;
 	int isa;
 
-	cpuid = perf_header__read_feature(session, HEADER_CPUID);
-
-	if (!cpuid) {
-		pr_err("read HEADER_CPUID failed.\n");
-		return -ENOTSUP;
-	}
-
 	if (strstr(cpuid, "Intel"))
 		isa = 1;
 	else if (strstr(cpuid, "AMD"))
@@ -683,7 +676,6 @@ static int get_cpu_isa(struct perf_session *session)
 		isa = -ENOTSUP;
 	}
 
-	free(cpuid);
 	return isa;
 }
 
-- 
1.7.11.4

