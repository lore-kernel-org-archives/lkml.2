Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GZPH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:07:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2GZPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:07:57 -0400
Date: Thu, 26 Jul 2012 08:07:33 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-6956dc568f34107f1d02b24f87efe7250803fc87@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1342765190-21540-1-git-send-email-alex.shi@intel.com>
References: <1342765190-21540-1-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa: Add SD_PERFER_SIBLING to CPU domain
Git-Commit-ID: 6956dc568f34107f1d02b24f87efe7250803fc87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6956dc568f34107f1d02b24f87efe7250803fc87
Gitweb:     http://git.kernel.org/tip/6956dc568f34107f1d02b24f87efe7250803fc87
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Fri, 20 Jul 2012 14:19:50 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 11:46:58 +0200

sched/numa: Add SD_PERFER_SIBLING to CPU domain

Commit 8e7fbcbc22c ("sched: Remove stale power aware scheduling remnants
and dysfunctional knobs") removed SD_PERFER_SIBLING from the CPU domain.

On NUMA machines this causes that load_balance() doesn't perfer LCPU in
 same physical CPU package.

It causes some actual performance regressions on our NUMA machines from
Core2 to NHM and SNB.

Adding this domain flag again recovers the performance drop.

This change doesn't have any bad impact on any of my benchmarks:
 specjbb, kbuild, fio, hackbench .. etc, on all my machines.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1342765190-21540-1-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/topology.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index e91cd43..fec12d6 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -164,6 +164,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
