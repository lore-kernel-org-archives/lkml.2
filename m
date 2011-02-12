Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1BLAIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 19:08:35 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:31180 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1BLAId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 19:08:33 -0500
X-RZG-AUTH: :P3sFZ06tad9qOe2NDrhqdOeMNB4Goe3+s2qB2hKb89B1UGCShCpD3WPONQ==
X-RZG-CLASS-ID: mo00
Message-ID: <4D55CF70.7070009@mibtec.de>
Date: Sat, 12 Feb 2011 01:08:16 +0100
From: Sascha Warner <swarner@mibtec.de>
Organization: MIS
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: linux-next-20110211 ntpd issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while testing linux-next 20110211 i saw how my memory filled, about 1 
MB/s went into use by the Kernel somehow. Seeing the below, i tried 
killing my ntpd which stopped the mem eating. I have applied fixes to 
zcache and epoll. This machine is a Q6600.

[   30.896025] eth0: no IPv6 routers present
[   83.968025]  P2489 P2488
[   83.968029] INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 
P2489 P2488} (detected by 2, t=15002 jiffies)
[   83.968036] ntpd            S ffff88013fccc330     0  2489   2488 
0x00000000
[   83.968042]  ffff88013ba0ba58 0000000000000086 ffff88013ba0ba48 
ffffffff00000000
[   83.968048]  0000000000011280 ffff88013fccc0a0 0000000000011280 
ffff88013ba0bfd8
[   83.968053]  0000000000011280 ffff88013ba0bfd8 ffff88013fccc338 
ffff88013ba0a000
[   83.968058] Call Trace:
[   83.968067]  [<ffffffff814d2f49>] 
schedule_hrtimeout_range_clock+0xa9/0x130
[   83.968073]  [<ffffffff8105d830>] ? hrtimer_wakeup+0x0/0x30
[   83.968078]  [<ffffffff810eb5af>] ? __pollwait+0x6f/0xf0
[   83.968082]  [<ffffffff814d2fde>] schedule_hrtimeout_range+0xe/0x10
[   83.968086]  [<ffffffff810eb474>] poll_schedule_timeout+0x44/0x60
[   83.968090]  [<ffffffff810ec897>] do_sys_poll+0x367/0x4f0
[   83.968094]  [<ffffffff810eb540>] ? __pollwait+0x0/0xf0
[   83.968098]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[   83.968102]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[   83.968106]  [<ffffffff81491805>] ? inet_recvmsg+0x95/0xc0
[   83.968111]  [<ffffffff81429008>] ? sock_recvmsg+0xf8/0x130
[   83.968115]  [<ffffffff81429184>] ? sock_sendmsg+0xe4/0x110
[   83.968120]  [<ffffffff810b543c>] ? handle_pte_fault+0x53c/0x940
[   83.968124]  [<ffffffff810b2bae>] ? __pte_alloc+0xde/0x130
[   83.968128]  [<ffffffff810b6bc2>] ? handle_mm_fault+0x192/0x2e0
[   83.968132]  [<ffffffff8142b53f>] ? sys_recvfrom+0xbf/0x120
[   83.968136]  [<ffffffff81490c91>] ? inet_dgram_connect+0x31/0x80
[   83.968141]  [<ffffffff810638dc>] ? ktime_get_ts+0xac/0xe0
[   83.968145]  [<ffffffff810eb822>] ? poll_select_set_timeout+0x82/0x90
[   83.968149]  [<ffffffff810ecaf7>] sys_poll+0x77/0x100
[   83.968153]  [<ffffffff81002dbb>] system_call_fastpath+0x16/0x1b
[   83.968157] ntpd            S ffff88013ffc0e50     0  2488      1 
0x00000000
[   83.968162]  ffff88013ba09a58 0000000000000086 0000000000000001 
0000000000000001
[   83.968167]  0000000000011280 ffff88013ffc0bc0 0000000000011280 
ffff88013ba09fd8
[   83.968172]  0000000000011280 ffff88013ba09fd8 ffff88013ffc0e58 
ffff88013ba08000
[   83.968177] Call Trace:
[   83.968182]  [<ffffffff8102f8e5>] ? check_preempt_curr+0x75/0xa0
[   83.968186]  [<ffffffff814d2fad>] 
schedule_hrtimeout_range_clock+0x10d/0x130
[   83.968190]  [<ffffffff8105a479>] ? add_wait_queue+0x49/0x60
[   83.968194]  [<ffffffff810eb5af>] ? __pollwait+0x6f/0xf0
[   83.968198]  [<ffffffff814d2fde>] schedule_hrtimeout_range+0xe/0x10
[   83.968202]  [<ffffffff810eb474>] poll_schedule_timeout+0x44/0x60
[   83.968206]  [<ffffffff810ec897>] do_sys_poll+0x367/0x4f0
[   83.968210]  [<ffffffff810eb540>] ? __pollwait+0x0/0xf0
[   83.968213]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[   83.968227]  [<ffffffff81428525>] ? sock_aio_write+0x135/0x150
[   83.968230]  [<ffffffff814283f0>] ? sock_aio_write+0x0/0x150
[   83.968237]  [<ffffffff810da8ab>] ? do_sync_readv_writev+0xcb/0x110
[   83.968240]  [<ffffffff8110e4d2>] ? fsnotify+0x1b2/0x2c0
[   83.968242]  [<ffffffff810b2bae>] ? __pte_alloc+0xde/0x130
[   83.968245]  [<ffffffff810dac20>] ? do_readv_writev+0x190/0x1d0
[   83.968248]  [<ffffffff810f6354>] ? mnt_get_count+0x44/0x60
[   83.968251]  [<ffffffff810f59b3>] ? 
vfsmount_lock_global_unlock_online+0x43/0x80
[   83.968254]  [<ffffffff810f68d6>] ? mntput_no_expire+0xa6/0xe0
[   83.968256]  [<ffffffff810f692a>] ? mntput+0x1a/0x30
[   83.968259]  [<ffffffff810dbacf>] ? fput+0x15f/0x200
[   83.968262]  [<ffffffff810ecaf7>] sys_poll+0x77/0x100
[   83.968265]  [<ffffffff81002dbb>] system_call_fastpath+0x16/0x1b
[   83.968267] ntpd            S ffff88013fccc330     0  2489   2488 
0x00000000
[   83.968270]  ffff88013ba0ba58 0000000000000086 ffff88013ba0ba48 
ffffffff00000000
[   83.968273]  0000000000011280 ffff88013fccc0a0 0000000000011280 
ffff88013ba0bfd8
[   83.968277]  0000000000011280 ffff88013ba0bfd8 ffff88013fccc338 
ffff88013ba0a000
[   83.968280] Call Trace:
[   83.968283]  [<ffffffff814d2f49>] 
schedule_hrtimeout_range_clock+0xa9/0x130
[   83.968286]  [<ffffffff8105d830>] ? hrtimer_wakeup+0x0/0x30
[   83.968288]  [<ffffffff810eb5af>] ? __pollwait+0x6f/0xf0
[   83.968291]  [<ffffffff814d2fde>] schedule_hrtimeout_range+0xe/0x10
[   83.968293]  [<ffffffff810eb474>] poll_schedule_timeout+0x44/0x60
[   83.968296]  [<ffffffff810ec897>] do_sys_poll+0x367/0x4f0
[   83.968299]  [<ffffffff810eb540>] ? __pollwait+0x0/0xf0
[   83.968301]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[   83.968304]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[   83.968307]  [<ffffffff81491805>] ? inet_recvmsg+0x95/0xc0
[   83.968309]  [<ffffffff81429008>] ? sock_recvmsg+0xf8/0x130
[   83.968312]  [<ffffffff81429184>] ? sock_sendmsg+0xe4/0x110
[   83.968315]  [<ffffffff810b543c>] ? handle_pte_fault+0x53c/0x940
[   83.968317]  [<ffffffff810b2bae>] ? __pte_alloc+0xde/0x130
[   83.968320]  [<ffffffff810b6bc2>] ? handle_mm_fault+0x192/0x2e0
[   83.968323]  [<ffffffff8142b53f>] ? sys_recvfrom+0xbf/0x120
[   83.968325]  [<ffffffff81490c91>] ? inet_dgram_connect+0x31/0x80
[   83.968328]  [<ffffffff810638dc>] ? ktime_get_ts+0xac/0xe0
[   83.968331]  [<ffffffff810eb822>] ? poll_select_set_timeout+0x82/0x90
[   83.968334]  [<ffffffff810ecaf7>] sys_poll+0x77/0x100
[   83.968336]  [<ffffffff81002dbb>] system_call_fastpath+0x16/0x1b
[   83.968338] ntpd            S ffff88013ffc0e50     0  2488      1 
0x00000000
[   83.968341]  ffff88013ba09a58 0000000000000086 0000000000000001 
0000000000000001
[   83.968344]  0000000000011280 ffff88013ffc0bc0 0000000000011280 
ffff88013ba09fd8
[   83.968348]  0000000000011280 ffff88013ba09fd8 ffff88013ffc0e58 
ffff88013ba08000
[   83.968351] Call Trace:
[   83.968354]  [<ffffffff8102f8e5>] ? check_preempt_curr+0x75/0xa0
[   83.968357]  [<ffffffff814d2fad>] 
schedule_hrtimeout_range_clock+0x10d/0x130
[   83.968359]  [<ffffffff8105a479>] ? add_wait_queue+0x49/0x60
[   83.968362]  [<ffffffff810eb5af>] ? __pollwait+0x6f/0xf0
[   83.968364]  [<ffffffff814d2fde>] schedule_hrtimeout_range+0xe/0x10
[   83.968367]  [<ffffffff810eb474>] poll_schedule_timeout+0x44/0x60
[   83.968370]  [<ffffffff810ec897>] do_sys_poll+0x367/0x4f0
[   83.968372]  [<ffffffff810eb540>] ? __pollwait+0x0/0xf0
[   83.968375]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[   83.968378]  [<ffffffff81428525>] ? sock_aio_write+0x135/0x150
[   83.968381]  [<ffffffff814283f0>] ? sock_aio_write+0x0/0x150
[   83.968384]  [<ffffffff810da8ab>] ? do_sync_readv_writev+0xcb/0x110
[   83.968386]  [<ffffffff8110e4d2>] ? fsnotify+0x1b2/0x2c0
[   83.968389]  [<ffffffff810b2bae>] ? __pte_alloc+0xde/0x130
[   83.968392]  [<ffffffff810dac20>] ? do_readv_writev+0x190/0x1d0
[   83.968394]  [<ffffffff810f6354>] ? mnt_get_count+0x44/0x60
[   83.968397]  [<ffffffff810f59b3>] ? 
vfsmount_lock_global_unlock_online+0x43/0x80
[   83.968400]  [<ffffffff810f68d6>] ? mntput_no_expire+0xa6/0xe0
[   83.968402]  [<ffffffff810f692a>] ? mntput+0x1a/0x30
[   83.968405]  [<ffffffff810dbacf>] ? fput+0x15f/0x200
[   83.968407]  [<ffffffff810ecaf7>] sys_poll+0x77/0x100
[   83.968410]  [<ffffffff81002dbb>] system_call_fastpath+0x16/0x1b
[  465.795998]  P2844
[  465.796000] INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 
P2844} (detected by 2, t=15002 jiffies)
[  465.796001] links           S ffff88013543ec50     0  2844   2687 
0x00000000
[  465.796001]  ffff88013b93b908 0000000000000086 ffff88013b93b8f8 
ffffffff00000000
[  465.796001]  0000000000011280 ffff88013543e9c0 0000000000011280 
ffff88013b93bfd8
[  465.796001]  0000000000011280 ffff88013b93bfd8 ffff88013543ec58 
ffff88013b93a000
[  465.796001] Call Trace:
[  465.796001]  [<ffffffff814d2f49>] 
schedule_hrtimeout_range_clock+0xa9/0x130
[  465.796001]  [<ffffffff8105d830>] ? hrtimer_wakeup+0x0/0x30
[  465.796001]  [<ffffffff810eb5af>] ? __pollwait+0x6f/0xf0
[  465.796001]  [<ffffffff814d2fde>] schedule_hrtimeout_range+0xe/0x10
[  465.796001]  [<ffffffff810eb474>] poll_schedule_timeout+0x44/0x60
[  465.796001]  [<ffffffff810ebdaa>] do_select+0x57a/0x6e0
[  465.796001]  [<ffffffff81463daa>] ? ip_finish_output+0x12a/0x360
[  465.796001]  [<ffffffff810eb540>] ? __pollwait+0x0/0xf0
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff814641e8>] ? ip_queue_xmit+0x168/0x3e0
[  465.796001]  [<ffffffff8102f8f4>] ? check_preempt_curr+0x84/0xa0
[  465.796001]  [<ffffffff8103859c>] ? try_to_wake_up+0x1bc/0x2d0
[  465.796001]  [<ffffffff8104aac6>] ? lock_timer_base.clone.28+0x36/0x70
[  465.796001]  [<ffffffff810386bd>] ? default_wake_function+0xd/0x10
[  465.796001]  [<ffffffff8102f679>] ? __wake_up_common+0x59/0x90
[  465.796001]  [<ffffffff810ec0c7>] core_sys_select+0x1b7/0x300
[  465.796001]  [<ffffffff8102fbae>] ? __wake_up+0x4e/0x70
[  465.796001]  [<ffffffff8110e4d2>] ? fsnotify+0x1b2/0x2c0
[  465.796001]  [<ffffffff8122acd2>] ? put_ldisc+0x42/0xb0
[  465.796001]  [<ffffffff810638dc>] ? ktime_get_ts+0xac/0xe0
[  465.796001]  [<ffffffff810ec252>] sys_select+0x42/0x100
[  465.796001]  [<ffffffff81002dbb>] system_call_fastpath+0x16/0x1b
[  465.796001] links           S ffff88013543ec50     0  2844   2687 
0x00000000
[  465.796001]  ffff88013b93b908 0000000000000086 ffff88013b93b8f8 
ffffffff00000000
[  465.796001]  0000000000011280 ffff88013543e9c0 0000000000011280 
ffff88013b93bfd8
[  465.796001]  0000000000011280 ffff88013b93bfd8 ffff88013543ec58 
ffff88013b93a000
[  465.796001] Call Trace:
[  465.796001]  [<ffffffff814d2f49>] 
schedule_hrtimeout_range_clock+0xa9/0x130
[  465.796001]  [<ffffffff8105d830>] ? hrtimer_wakeup+0x0/0x30
[  465.796001]  [<ffffffff810eb5af>] ? __pollwait+0x6f/0xf0
[  465.796001]  [<ffffffff814d2fde>] schedule_hrtimeout_range+0xe/0x10
[  465.796001]  [<ffffffff810eb474>] poll_schedule_timeout+0x44/0x60
[  465.796001]  [<ffffffff810ebdaa>] do_select+0x57a/0x6e0
[  465.796001]  [<ffffffff81463daa>] ? ip_finish_output+0x12a/0x360
[  465.796001]  [<ffffffff810eb540>] ? __pollwait+0x0/0xf0
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff810eb630>] ? pollwake+0x0/0x60
[  465.796001]  [<ffffffff814641e8>] ? ip_queue_xmit+0x168/0x3e0
[  465.796001]  [<ffffffff8102f8f4>] ? check_preempt_curr+0x84/0xa0
[  465.796001]  [<ffffffff8103859c>] ? try_to_wake_up+0x1bc/0x2d0
[  465.796001]  [<ffffffff8104aac6>] ? lock_timer_base.clone.28+0x36/0x70
[  465.796001]  [<ffffffff810386bd>] ? default_wake_function+0xd/0x10
[  465.796001]  [<ffffffff8102f679>] ? __wake_up_common+0x59/0x90
[  465.796001]  [<ffffffff810ec0c7>] core_sys_select+0x1b7/0x300
[  465.796001]  [<ffffffff8102fbae>] ? __wake_up+0x4e/0x70
[  465.796001]  [<ffffffff8110e4d2>] ? fsnotify+0x1b2/0x2c0
[  465.796001]  [<ffffffff8122acd2>] ? put_ldisc+0x42/0xb0
[  465.796001]  [<ffffffff810638dc>] ? ktime_get_ts+0xac/0xe0
[  465.796001]  [<ffffffff810ec252>] sys_select+0x42/0x100
[  465.796001]  [<ffffffff81002dbb>] system_call_fastpath+0x16/0x1b
[  680.055998]  P0
[  680.056000] INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 
P0} (detected by 2, t=15002 jiffies)
[  680.056001] swapper         R  running task        0     0      0 
0x00000000
[  680.056001]  ffffffff8169fef8 ffff8800bfc11c40 0000000000011c40 
0000000000000000
[  680.056001]  ffffffff8169fe88 ffffffff810036ce ffffffff8169fef8 
0000000000000000
[  680.056001]  0000000000000001 0000000000000000 00000000ffffffff 
0000000000000000
[  680.056001] Call Trace:
[  680.056001]  [<ffffffff810036ce>] ? apic_timer_interrupt+0xe/0x20
[  680.056001]  [<ffffffff8105f73c>] ? 
__atomic_notifier_call_chain+0x4c/0x70
[  680.056001]  [<ffffffff8105f771>] ? atomic_notifier_call_chain+0x11/0x20
[  680.056001]  [<ffffffff810011c0>] ? enter_idle+0x20/0x30
[  680.056001]  [<ffffffff81001256>] cpu_idle+0x56/0xa0
[  680.056001]  [<ffffffff814b457f>] rest_init+0x8f/0xa0
[  680.056001]  [<ffffffff8172094b>] start_kernel+0x2e5/0x2f0
[  680.056001]  [<ffffffff817200ff>] x86_64_start_reservations+0xfc/0x100
[  680.056001]  [<ffffffff817201f8>] x86_64_start_kernel+0xf5/0xfc
[  680.056001] swapper         R  running task        0     0      0 
0x00000000
[  680.056001]  ffffffff8169fef8 ffff8800bfc11c40 0000000000011c40 
0000000000000000
[  680.056001]  ffffffff8169fe88 ffffffff810036ce ffffffff8169fef8 
0000000000000000
[  680.056001]  0000000000000001 0000000000000000 00000000ffffffff 
0000000000000000
[  680.056001] Call Trace:
[  680.056001]  [<ffffffff810036ce>] ? apic_timer_interrupt+0xe/0x20
[  680.056001]  [<ffffffff8105f73c>] ? 
__atomic_notifier_call_chain+0x4c/0x70
[  680.056001]  [<ffffffff8105f771>] ? atomic_notifier_call_chain+0x11/0x20
[  680.056001]  [<ffffffff810011c0>] ? enter_idle+0x20/0x30
[  680.056001]  [<ffffffff81001256>] cpu_idle+0x56/0xa0
[  680.056001]  [<ffffffff814b457f>] rest_init+0x8f/0xa0
[  680.056001]  [<ffffffff8172094b>] start_kernel+0x2e5/0x2f0
[  680.056001]  [<ffffffff817200ff>] x86_64_start_reservations+0xfc/0x100
[  680.056001]  [<ffffffff817201f8>] x86_64_start_kernel+0xf5/0xfc

Kind regards,
Sascha Warner
