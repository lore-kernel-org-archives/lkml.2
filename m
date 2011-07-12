Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1GLUz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:55:29 -0400
Received: from mail.candelatech.com ([208.74.158.172]:40314 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1GLUz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:55:27 -0400
Message-ID: <4E1CB4BF.2020302@candelatech.com>
Date: Tue, 12 Jul 2011 13:55:27 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: rcub1 task hung for > 180 seconds.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is same 3.0-rc7 system that had the lockdep splat I just
posted...

Is this task blockage serious?


INFO: task rcub1:11 blocked for more than 180 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcub1           D ffff880128f6b6c8     0    11      2 0x00000000
  ffff880128f73cd0 0000000000000046 ffff880100000000 0000000000012940
  ffff880128f6b3f0 ffff880128f73fd8 ffff880128f72000 0000000000012940
  ffff880128f73fd8 0000000000012940 ffff8801079e9150 ffff880128f6b3f0
Call Trace:
  [<ffffffff81481f0d>] ? sub_preempt_count+0x92/0xa6
  [<ffffffff8147e1d1>] __rt_mutex_slowlock+0x84/0xb6
  [<ffffffff8147e3c9>] rt_mutex_slowlock+0xc5/0x132
  [<ffffffff8147e4d4>] rt_mutex_lock+0x46/0x4a
  [<ffffffff810a6bed>] rcu_boost_kthread+0x125/0x169
  [<ffffffff810a6ac8>] ? rcu_initiate_boost+0x8a/0x8a
  [<ffffffff81066f80>] kthread+0x7d/0x85
  [<ffffffff81486164>] kernel_thread_helper+0x4/0x10
  [<ffffffff8147f358>] ? retint_restore_args+0x13/0x13
  [<ffffffff81066f03>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff81486160>] ? gs_change+0x13/0x13
INFO: lockdep is turned off.
INFO: task rcub1:11 blocked for more than 180 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcub1           D ffff880128f6b6c8     0    11      2 0x00000000
  ffff880128f73cd0 0000000000000046 ffff880100000000 0000000000012940
  ffff880128f6b3f0 ffff880128f73fd8 ffff880128f72000 0000000000012940
  ffff880128f73fd8 0000000000012940 ffff8801079e9150 ffff880128f6b3f0
Call Trace:
  [<ffffffff81481f0d>] ? sub_preempt_count+0x92/0xa6
  [<ffffffff8147e1d1>] __rt_mutex_slowlock+0x84/0xb6
  [<ffffffff8147e3c9>] rt_mutex_slowlock+0xc5/0x132
  [<ffffffff8147e4d4>] rt_mutex_lock+0x46/0x4a
  [<ffffffff810a6bed>] rcu_boost_kthread+0x125/0x169
  [<ffffffff810a6ac8>] ? rcu_initiate_boost+0x8a/0x8a
  [<ffffffff81066f80>] kthread+0x7d/0x85
  [<ffffffff81486164>] kernel_thread_helper+0x4/0x10
  [<ffffffff8147f358>] ? retint_restore_args+0x13/0x13
  [<ffffffff81066f03>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff81486160>] ? gs_change+0x13/0x13
INFO: lockdep is turned off.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

