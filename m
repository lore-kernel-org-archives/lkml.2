Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2LSPH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:07:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab2LSPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:07:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] Revert "perf: Require exclude_guest to use PEBS - kernel side enforcement"
Date: Wed, 19 Dec 2012 16:07:20 +0100
Message-Id: <1355929642-28392-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 20b279ddb38ca42f8863cec07b4d45ec24589f13.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..6774c17 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -340,9 +340,6 @@ int x86_setup_perfctr(struct perf_event *event)
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
-
-		if (!attr->exclude_guest)
-			return -EOPNOTSUPP;
 	}
 
 	hwc->config |= config;
@@ -385,9 +382,6 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
-		if (!event->attr.exclude_guest)
-			return -EOPNOTSUPP;
-
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
-- 
1.7.11.7

