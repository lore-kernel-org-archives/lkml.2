Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2FKJNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:13:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2FKJNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:13:14 -0400
Date: Mon, 11 Jun 2012 02:13:01 -0700
From: tip-bot for Shuah Khan <shuahkhan@gmail.com>
Message-ID: <tip-e2b297fcf17fc03734e93387fb8195c782286b35@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, shuahkhan@gmail.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1339384421.3025.8.camel@lorien2>
References: <1339384421.3025.8.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Convert obsolete simple_strtoul()
  usage to kstrtoul()
Git-Commit-ID: e2b297fcf17fc03734e93387fb8195c782286b35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 11 Jun 2012 02:13:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2b297fcf17fc03734e93387fb8195c782286b35
Gitweb:     http://git.kernel.org/tip/e2b297fcf17fc03734e93387fb8195c782286b35
Author:     Shuah Khan <shuahkhan@gmail.com>
AuthorDate: Sun, 10 Jun 2012 21:13:41 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Jun 2012 10:52:12 +0200

perf/x86: Convert obsolete simple_strtoul() usage to kstrtoul()

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1339384421.3025.8.camel@lorien2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 000a474..766c76d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1640,7 +1640,12 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	unsigned long val = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
