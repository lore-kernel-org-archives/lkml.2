Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0JEVEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:04:06 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50041 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0JEVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:04:04 -0400
Message-ID: <4CAB92C2.9060007@candelatech.com>
Date: Tue, 05 Oct 2010 14:04:02 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: suspicious rcu_dereference_check at kernel/sched.c:618
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is from a wireless-testing tree (2.6.36-rc6 + wireless hacks).

I see this fairly often, and would be happy to test patches :)

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
/home/greearb/git/linux.wireless-testing/kernel/sched.c:618 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
1 lock held by ifup/23517:
  #0:  (&rq->lock){-.-.-.}, at: [<c042f782>] task_fork_fair+0x3b/0x108

stack backtrace:
Pid: 23517, comm: ifup Not tainted 2.6.36-rc6-wl+ #5
Call Trace:
  [<c075e219>] ? printk+0xf/0x16
  [<c0455842>] lockdep_rcu_dereference+0x74/0x7d
  [<c0426854>] task_group+0x6d/0x79
  [<c042686e>] set_task_rq+0xe/0x57
  [<c042f79e>] task_fork_fair+0x57/0x108
  [<c042e965>] sched_fork+0x82/0xf9
  [<c04334b3>] copy_process+0x569/0xe8e
  [<c0433ef0>] do_fork+0x118/0x262
  [<c076302f>] ? do_page_fault+0x16a/0x2cf
  [<c044b80c>] ? up_read+0x16/0x2a
  [<c04085ae>] sys_clone+0x1b/0x20
  [<c04030a5>] ptregs_clone+0x15/0x30
  [<c0402f1c>] ? sysenter_do_call+0x12/0x38


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

