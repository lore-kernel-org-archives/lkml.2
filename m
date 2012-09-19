Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2ISREn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:04:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2ISREk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:04:40 -0400
Date: Wed, 19 Sep 2012 10:04:07 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-1e6dd8adc78d4a153db253d051fd4ef6c49c9019@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20120905123126.GC6128@elgon.mountain>
References: <20120905123126.GC6128@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix off by one test in perf_reg_value()
Git-Commit-ID: 1e6dd8adc78d4a153db253d051fd4ef6c49c9019
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 10:04:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e6dd8adc78d4a153db253d051fd4ef6c49c9019
Gitweb:     http://git.kernel.org/tip/1e6dd8adc78d4a153db253d051fd4ef6c49c9019
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Wed, 5 Sep 2012 15:31:26 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Sep 2012 17:08:40 +0200

perf: Fix off by one test in perf_reg_value()

The test should be >= ARRAY_SIZE() instead of > ARRAY_SIZE().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/20120905123126.GC6128@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/perf_regs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index c5a3e5c..e309cc5 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -57,7 +57,7 @@ static unsigned int pt_regs_offset[PERF_REG_X86_MAX] = {
 
 u64 perf_reg_value(struct pt_regs *regs, int idx)
 {
-	if (WARN_ON_ONCE(idx > ARRAY_SIZE(pt_regs_offset)))
+	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(pt_regs_offset)))
 		return 0;
 
 	return regs_get_register(regs, pt_regs_offset[idx]);
