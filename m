Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2HNGzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 02:55:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:8522 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab2HNGzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 02:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,764,1336374000"; 
   d="scan'208";a="180731276"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Yanmin Zhang <yanmin_zhang@linux.intel.com>
	(yanmin_zhang@linux.intel.com)" <yanmin_zhang@linux.intel.com>
Subject: [PATCH] x86/fixup_irq: using the cpu_online_mask instead of
 cpu_all_mask
Thread-Topic: [PATCH] x86/fixup_irq: using the cpu_online_mask instead of
 cpu_all_mask
Thread-Index: Ac156bjmvPG2JWnwRhytXu2ohG+YvA==
Date: Tue, 14 Aug 2012 06:55:01 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A137286@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] x86/fixup_irq: using the cpu_online_mask instead of cpu_all_mask

When one CPU is going down, and this CPU is the last one in irq affinity,
current code is setting cpu_all_mask as the new affinity for that irq.

But for some system the firmware maybe send the interrupt to each CPU
in irq affinity averagely, and cpu_all_mask include all CPUs.

Here replacing cpu_all_mask with cpu_online_mask, it is more reasonable
and fittable.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7ad683d..d44f782 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -270,7 +270,7 @@ void fixup_irqs(void)
 
                if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
                        break_affinity = 1;
-                       affinity = cpu_all_mask;
+                       affinity = cpu_online_mask;
                }
 
                chip = irq_data_get_irq_chip(data);
-- 
1.7.0.4

