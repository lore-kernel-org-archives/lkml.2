Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab1LBBKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:10:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:34883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab1LBBKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="81983579"
Message-Id: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 01 Dec 2011 17:07:31 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Subject: [patch v3 0/6] nohz idle load balancing patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the -v3 of the load balancing patches that makes nohz idle
load balancing more scalabale. While the last 2 in the series are not
directly related to nohz, I clubbed them as part of this series as I noticed
them while I was working in this area and they helped the context switch
intensive workloads improve on the 8-socket system.

First RFC version of this can be found at
https://lkml.org/lkml/2011/11/1/368

Second version of this can be found at
https://lkml.org/lkml/2011/11/18/518

changes from v2:
a. Make the changelogs more descriptive.
b. nr_busy_cpus in the sched_group_power is updated when entering idle
   irrespective of whether the tick is stopped or not.
c. kick the idle load balancer for the groups sharing package resources
   and having more than one cpu busy.
d. Incroporate Mike's patch for enhancing ttwu_feature instead of disabling
   the feature by default.

thanks,
suresh

