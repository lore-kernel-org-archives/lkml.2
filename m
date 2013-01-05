Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3AEIhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:37:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab3AEIhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210035"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH v3 01/22] sched: set SD_PREFER_SIBLING on MC domain to reduce a domain level
Date: Sat,  5 Jan 2013 16:37:30 +0800
Message-Id: <1357375071-11793-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The domain flag SD_PREFER_SIBLING was set both on MC and CPU domain at
frist commit b5d978e0c7e79a, and was removed uncarefully when clear up
obsolete power scheduler. Then commit 6956dc568 recover the flag on CPU
domain only. It works, but it introduces a extra domain level since this
cause MC/CPU different.

So, recover the the flag in MC domain too to remove a domain level in
x86 platform.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/topology.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..386bcf4 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -132,6 +132,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
-- 
1.7.12

