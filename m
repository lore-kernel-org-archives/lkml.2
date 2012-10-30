Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab2J3MZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:25:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab2J3MZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:25:11 -0400
Date: Tue, 30 Oct 2012 05:24:44 -0700
From: tip-bot for Peter Huewe <peterhuewe@gmx.de>
Message-ID: <tip-95d18aa2b6c05351181934b3bc34ce038cc7b637@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterhuewe@gmx.de, jolsa@redhat.com,
        yuanhan.liu@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterhuewe@gmx.de, jolsa@redhat.com,
        yuanhan.liu@linux.intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix sparse warnings
Git-Commit-ID: 95d18aa2b6c05351181934b3bc34ce038cc7b637
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:24:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95d18aa2b6c05351181934b3bc34ce038cc7b637
Gitweb:     http://git.kernel.org/tip/95d18aa2b6c05351181934b3bc34ce038cc7b637
Author:     Peter Huewe <peterhuewe@gmx.de>
AuthorDate: Mon, 29 Oct 2012 21:48:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:10:52 +0100

perf/x86: Fix sparse warnings

FYI, there are new sparse warnings:

 arch/x86/kernel/cpu/perf_event.c:1356:18: sparse: symbol 'events_attr' was not declared. Should it be static?

This patch makes it static and also adds the static keyword to
fix arch/x86/kernel/cpu/perf_event.c:1344:9: warning: symbol
'events_sysfs_show' was not declared.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: fengguang.wu@intel.com
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-lerdpXlnruh0yvWs2owwuizl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0a55ab2..4428fd1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1341,7 +1341,7 @@ static void __init filter_events(struct attribute **attrs)
 	}
 }
 
-ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
+static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
 	struct perf_pmu_events_attr *pmu_attr = \
@@ -1373,7 +1373,7 @@ EVENT_ATTR(ref-cycles,			REF_CPU_CYCLES		);
 
 static struct attribute *empty_attrs;
 
-struct attribute *events_attr[] = {
+static struct attribute *events_attr[] = {
 	EVENT_PTR(CPU_CYCLES),
 	EVENT_PTR(INSTRUCTIONS),
 	EVENT_PTR(CACHE_REFERENCES),
