Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2JOHEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:04:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:39903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2JOHEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:04:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="226919117"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Tang, Guifang" <guifang.tang@intel.com>, "Zuo, Alex" <alex.zuo@intel.com>
Subject: RE: Fix memory leak in cpufreq stats.
Thread-Topic: Fix memory leak in cpufreq stats.
Thread-Index: Ac2qf44L6sEdIyqARSu/TKndOmxt0QAI6r8w
Date: Mon, 15 Oct 2012 07:04:07 +0000
Message-ID: <EE928378561BF1449699C96571234A740FE67925@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
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

+alex

-----Original Message-----
From: Tu, Xiaobing 
Sent: Monday, October 15, 2012 10:48 AM
To: 'davej@redhat.com'; 'akpm@linux-foundation.org'; 'mingo@elte.hu'; 'rusty@rustcorp.com.au'; 'a.p.zijlstra@chello.nl'; 'linux-kernel@vger.kernel.org'; 'rostedt@goodmis.org'
Cc: Tang, Guifang; Tu, Xiaobing
Subject: Fix memory leak in cpufreq stats.


Fix memory leak in cpufreq stats.

When system enter sleep, non-boot CPUs will be disable.
Cpufreq stats sysfs is created when the CPU is up, but it is not freed when the CPU going down. This will cause memory leak.
signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
signed-off-by: guifang tang <guifang.tang@intel.com>

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c index b40ee14..3998316 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -328,6 +328,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
                cpufreq_update_policy(cpu);
                break;
        case CPU_DOWN_PREPARE:
+       case CPU_DOWN_PREPARE_FROZEN:
                cpufreq_stats_free_sysfs(cpu);
                break;
        case CPU_DEAD:

Br
XiaoBing Tu
PSI@System Integration Shanghai


