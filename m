Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0HTMlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:41:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:40220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab0HTMlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:41:23 -0400
Date: Fri, 20 Aug 2010 12:41:02 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1282273431.16443.32.camel@minggr.sh.intel.com>
References: <1282273431.16443.32.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockup_detector: Make callback function static
Message-ID: <tip-277b199800ac90811ac86d215063df1984f51619@git.kernel.org>
Git-Commit-ID: 277b199800ac90811ac86d215063df1984f51619
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 12:41:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  277b199800ac90811ac86d215063df1984f51619
Gitweb:     http://git.kernel.org/tip/277b199800ac90811ac86d215063df1984f51619
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 20 Aug 2010 11:03:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Aug 2010 10:09:41 +0200

lockup_detector: Make callback function static

watchdog_overflow_callback() is only used in kernel/watchdog.c.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>
LKML-Reference: <1282273431.16443.32.camel@minggr.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..b60e2a8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -202,7 +202,7 @@ static struct perf_event_attr wd_hw_attr = {
 };
 
 /* Callback function for perf event subsystem */
-void watchdog_overflow_callback(struct perf_event *event, int nmi,
+static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {
