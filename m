Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2IXQEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:04:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58785 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2IXQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/30] perf kvm: Use perf_session_env for reading cpuid
Date: Mon, 24 Sep 2012 12:59:29 -0300
Message-Id: <1348502384-14442-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We have processed and saved cpuid information to perf_session_env so
reuse it for get_cpu_isa().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1348474503-15070-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 3eb53e3..a28c9ca 100644
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
1.7.1

