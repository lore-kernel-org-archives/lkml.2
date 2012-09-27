Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2I0FeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:34:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2I0FeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:34:03 -0400
Date: Wed, 26 Sep 2012 22:33:43 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-2f9e97aa8b4c6220c0770a966fb99d7366679813@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, haodong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1348474503-15070-6-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Use perf_session_env for reading cpuid
Git-Commit-ID: 2f9e97aa8b4c6220c0770a966fb99d7366679813
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:33:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f9e97aa8b4c6220c0770a966fb99d7366679813
Gitweb:     http://git.kernel.org/tip/2f9e97aa8b4c6220c0770a966fb99d7366679813
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 24 Sep 2012 17:15:02 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 11:47:27 -0300

perf kvm: Use perf_session_env for reading cpuid

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
 
