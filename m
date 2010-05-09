Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0EIUn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:43:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34161 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0EIUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=YjshMHVB5eOtbe7JScReY7VRk4tpwI5NY3ZtEGLgat75Dz5vIqew8OHKucytrT51Hv
         AdR/hhiyss0pSLgJ5zd1XErhDxh6PWvyerpGFv//38IYsvKj2g46eOYjj9tqeUYv9Uzd
         7dOKE1Db6MLD3fFqzHa1mYk3FC/SsGwA3p+m8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 04/10] perf: Fix perf lock bad rate
Date: Sun,  9 May 2010 22:43:32 +0200
Message-Id: <1273437818-8130-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the cast made to get the bad rate. It is made in the result
instead of the operands. We need the operands to be cast in double,
otherwise the result will always be zero.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-lock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 3b304ed..d7dde9c 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -733,8 +733,8 @@ static void print_bad_events(int bad, int total)
 		{ "acquire", "acquired", "contended", "release" };
 
 	pr_info("\n=== output for debug===\n\n");
-	pr_info("bad:%d, total:%d\n", bad, total);
-	pr_info("bad rate:%f\n", (double)(bad / total));
+	pr_info("bad: %d, total: %d\n", bad, total);
+	pr_info("bad rate: %f %%\n", (double)bad / (double)total * 100);
 	pr_info("histogram of events caused bad sequence\n");
 	for (i = 0; i < BROKEN_MAX; i++)
 		pr_info(" %10s: %d\n", name[i], bad_hist[i]);
-- 
1.6.2.3

