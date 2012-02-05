Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2BEE26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 23:28:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:56426 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab2BEE25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 23:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103396041"
Message-ID: <4F2E0586.2090803@intel.com>
Date: Sun, 05 Feb 2012 12:28:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Chen, Tim C" <tim.c.chen@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: a non producible kernel panic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do performance testing for rc2 kernel on our NHM EX machine( 4
sockets * 8 cores), I find a kernel panic. but never reproduced it. and
didn't find some useful info after enable lockdep, rcu debug etc.

Any ideas on this?

INFO: task umount:4280 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount          D ffff883025443198     0  4280   4235 0x00000080
 ffff883027805d28 0000000000000086 ffff883025442de0 ffff883027805fd8
 ffff883027805fd8 0000000000013100 ffff8810292eade0 ffff883025442de0
 0000000000000018 7fffffffffffffff 7fffffffffffffff ffffffff81c180c8
Call Trace:
 [<ffffffff81452caa>] schedule+0x55/0x57
 [<ffffffff81451a93>] schedule_timeout+0x2f/0xd9
 [<ffffffff8109dfe0>] ? rcu_panic+0x12/0x12
 [<ffffffff81028259>] ? physflat_send_IPI_allbutself+0x12/0x14
 [<ffffffff81024a33>] ? native_send_call_func_ipi+0x71/0x91
 [<ffffffff81452b67>] wait_for_common+0x95/0xeb
 [<ffffffff8105dfe7>] ? try_to_wake_up+0x1e0/0x1e0
 [<ffffffff8109dfe0>] ? rcu_panic+0x12/0x12
 [<ffffffff8109eb41>] ? call_rcu_bh+0x12/0x12
 [<ffffffff81452c53>] wait_for_completion+0x18/0x1a
 [<ffffffff8109ef36>] _rcu_barrier+0x96/0xa6
 [<ffffffff8109ef5d>] rcu_barrier_sched+0x17/0x19
 [<ffffffff8109ef68>] rcu_barrier+0x9/0xb
 [<ffffffff8110bac0>] deactivate_locked_super+0x32/0x52
 [<ffffffff8110c536>] deactivate_super+0x32/0x36
 [<ffffffff81120691>] mntput_no_expire+0xde/0xe7
 [<ffffffff811212f2>] sys_umount+0x2cd/0x2ff
 [<ffffffff81112699>] ? path_put+0x1a/0x1e
 [<ffffffff81459a79>] system_call_fastpath+0x16/0x1b
INFO: task umount:4280 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
umount          D ffff883025443198     0  4280   4235 0x00000080
 ffff883027805d28 0000000000000086 ffff883025442de0 ffff883027805fd8
 ffff883027805fd8 0000000000013100 ffff8810292eade0 ffff883025442de0
 0000000000000018 7fffffffffffffff 7fffffffffffffff ffffffff81c18
