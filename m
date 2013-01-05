Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3AEIhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:37:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:44979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab3AEIhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:37:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="270210029"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        alex.shi@intel.com
Subject: [PATCH V3 0/22] sched: simplified fork, enable load average into LB and power awareness scheduling
Date: Sat,  5 Jan 2013 16:37:29 +0800
Message-Id: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set base on Linus tree, includes 3 parts,
1, bug fix and fork/wake balancing clean up. patch 1~6,
the first patch remove one domain level. patch 2~6 simplified fork/wake
balancing, it can increase 10+% hackbench performance on our 4 sockets
SNB EP machine.

V3 change:
a, added the first patch to remove one domain level on x86 platform.
b, some small changes according to Namhyung Kim's comments, thanks!

2, bug fix for load average and implement it into LB, patch 7~12,
That using load average in load balancing, with a initial runnable load
value bug fix.

V3 change:
a, use rq->cfs.runnable_load_avg as cpu load not
rq->avg.load_avg_contrib, since the latter need much time to accumulate
for new forked task,
b, a build issue fixed with Namhyung Kim's reminder.

3, power awareness scheduling, patch 13~22,
The subset implement my previous power aware scheduling proposal:
https://lkml.org/lkml/2012/8/13/139
It defines 2 new power aware policy balance and powersaving, and then
try to spread or pack tasks on each of sched group level according the
different scheduler policy. That can save much power when task number in
system is no more then LCPU number.

V3 change:
a, engaged nr_running in max potential utils consideration in periodic
power balancing.
b, try exec/wake small tasks on running cpu not idle cpu.

Thanks comments on previous version. and Any more comments are appreciated!

-- Thanks Alex

