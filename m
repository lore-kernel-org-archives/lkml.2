Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2HUTCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:02:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45109 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2HUTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120818085843.54b231ed@notabene.brown>
References: <CAEhu1-4gv=uAu7K=O6DqeXr05frD4_Yp+0VnRuF_n8mnbaqF6w@mail.gmail.com>
	<20120818085843.54b231ed@notabene.brown>
Date: Tue, 21 Aug 2012 15:02:19 -0400
Message-ID: <CAEhu1-7v1d4D9oYDnn+yYo2wqDxKEsXjd5QEf8SrRKMjrL+8mw@mail.gmail.com>
Subject: Re: mdraid6 problem post 3.5.0
From: John Drescher <drescherjm@gmail.com>
To: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A digital-photo of the debug messages might be useful if you can catch that.
> Setting up a network console to capture messages isn't too hard if you have
> another machine with a wired network connection.
> See Documentation/networking/netconsole.txt
> If you can set that us, then alt-sysrq-T might provide useful info.

I am beginning to think this is more related to the lsi sas card
driver instead of the raid.

[  177.204225] netpoll: netconsole: local port 6665
[  177.204273] netpoll: netconsole: local IP 0.0.0.0
[  177.204317] netpoll: netconsole: interface 'eth0'
[  177.204362] netpoll: netconsole: remote port 30000
[  177.204408] netpoll: netconsole: remote IP 192.168.1.31
[  177.204454] netpoll: netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[  177.204504] netpoll: netconsole: local IP 192.168.2.91
[  177.204574] console [netcon0] enabled
[  177.204617] netconsole: network logging started
[  225.513474] mptbase: ioc1: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00) cb_idx mptbase_reply
[  229.989660] sd 1:0:5:0: [sdm] Synchronizing SCSI cache
[  229.989752] sd 1:0:5:0: [sdm]
[  229.989798] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  229.991170] md/raid:md1: Disk failure on sdm2, disabling device.
[  229.991170] md/raid:md1: Operation continuing on 11 devices.
[  229.991190] md/raid1:md0: Disk failure on sdm1, disabling device.
[  229.991190] md/raid1:md0: Operation continuing on 9 devices.
[  259.940462] md: ioctl lock interrupted, reason -4, cmd -2142762735
[  259.940472] md: ioctl lock interrupted, reason -4, cmd -2142762735
[  289.859335] INFO: rcu_sched self-detected stall on CPU { 2}
(t=18001 jiffies)
[  289.859627] Pid: 2182, comm: kworker/u:5 Not tainted
3.5.1-gentoo-testserver-ipmi #1
[  289.859776] Call Trace:
[  289.859864]  <IRQ>  [<ffffffff810a6d82>] __rcu_pending+0x192/0x4c0
[  289.860003]  [<ffffffff810a7aa8>] rcu_check_callbacks+0x98/0xe0
[  289.860104]  [<ffffffff81040913>] update_process_times+0x43/0x80
[  289.860204]  [<ffffffff8107b4c8>] tick_sched_timer+0x58/0x150
[  289.860302]  [<ffffffff81053b98>] __run_hrtimer.isra.32+0x58/0x100
[  289.860401]  [<ffffffff81054283>] hrtimer_interrupt+0xf3/0x230
[  289.860500]  [<ffffffff8101ee04>] smp_apic_timer_interrupt+0x64/0xa0
[  289.860601]  [<ffffffff81599107>] apic_timer_interrupt+0x67/0x70
[  289.860697]  <EOI>  [<ffffffff815921a9>] ?
_raw_spin_unlock_irqrestore+0x9/0x10
[  289.860883]  [<ffffffff813f4a3f>] scsi_remove_target+0xcf/0x1d0
[  289.860982]  [<ffffffff813fe895>] sas_rphy_remove+0x55/0x60
[  289.861077]  [<ffffffff813fe8b1>] sas_rphy_delete+0x11/0x20
[  289.861173]  [<ffffffff813fe8e5>] sas_port_delete+0x25/0x160
[  289.861268]  [<ffffffff81431183>] mptsas_del_end_device+0x183/0x270
[  289.861365]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  289.861463]  [<ffffffff8143562c>] mptsas_hotplug_work+0x1ec/0x920
[  289.861561]  [<ffffffff810f00d7>] ? kfree+0x17/0xb0
[  289.861655]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  289.861755]  [<ffffffff81436e00>] mptsas_firmware_event_work+0xba0/0xf80
[  289.861854]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  289.861953]  [<ffffffff81048af3>] ? cwq_activate_first_delayed+0x33/0xa0
[  289.862051]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  289.862150]  [<ffffffff8104aaa2>] process_one_work+0x102/0x390
[  289.862244]  [<ffffffff8104b150>] ? manage_workers.isra.33+0x1d0/0x220
[  289.862341]  [<ffffffff8104b2fe>] worker_thread+0x15e/0x350
[  289.862436]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  289.862534]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  289.862631]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  289.862680] INFO: Stall ended before state dump start
[  289.862677] INFO: rcu_sched detected stalls on CPUs/tasks: { 2}
(detected by 7, t=18002 jiffies)
[  289.862820]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  289.863111]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  359.873632] INFO: task md0_raid1:4853 blocked for more than 120 seconds.
[  359.873733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  359.873879] md0_raid1       D ffff880221e61690     0  4853      2 0x00000000
[  359.874048]  ffff88022278dae0 0000000000000046 ffff88022278d9f0
ffff88022278dfd8
[  359.874333]  ffff88022278dfd8 0000000000004000 ffff8802244d43b0
ffff880221e61690
[  359.874619]  ffffffff81b2853c 000000000000001c ffff88022278da70
ffffffff8132beb0
[  359.874907] Call Trace:
[  359.875000]  [<ffffffff8132beb0>] ? sprintf+0x40/0x50
[  359.875099]  [<ffffffff8106167c>] ? dequeue_task_fair+0x1ec/0x2a0
[  359.875199]  [<ffffffff810334a1>] ? print_prefix+0xd1/0x120
[  359.875296]  [<ffffffff81033a3c>] ? msg_print_text+0xac/0x1a0
[  359.875394]  [<ffffffff815912e4>] schedule+0x24/0x70
[  359.875491]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  359.875589]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  359.875686]  [<ffffffff81591176>] wait_for_common+0xc6/0x160
[  359.875785]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  359.875884]  [<ffffffff810a6b80>] ? call_rcu_bh+0x20/0x20
[  359.875980]  [<ffffffff815912b8>] wait_for_completion+0x18/0x20
[  359.876078]  [<ffffffff8104d158>] wait_rcu_gp+0x48/0x50
[  359.876175]  [<ffffffff8104d160>] ? wait_rcu_gp+0x50/0x50
[  359.876273]  [<ffffffff810a5eb9>] synchronize_sched+0x29/0x30
[  359.876371]  [<ffffffff81476181>] raid1_remove_disk+0xe1/0x170
[  359.876470]  [<ffffffff81496bd7>] md_check_recovery+0x4b7/0x700
[  359.876567]  [<ffffffff81477175>] raid1d+0x35/0x1010
[  359.876661]  [<ffffffff815912e4>] ? schedule+0x24/0x70
[  359.876755]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  359.876850]  [<ffffffff814908ee>] md_thread+0x10e/0x140
[  359.876950]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  359.877049]  [<ffffffff814907e0>] ? md_register_thread+0x100/0x100
[  359.877148]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  359.877246]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  359.877248]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  359.877249]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  359.877250] INFO: task md1_raid6:4873 blocked for more than 120 seconds.
[  359.877251] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  359.877254]  ffff880220fa5b20 0000000000000046 0000000000000000
ffff880220fa5fd8
[  359.877255]  ffff880220fa5fd8 0000000000004000 ffffffff81a13440
ffff880222550000
[  359.877256]  ffffffff81b2876c 0000000000000017 ffff880220fa5ab0
ffffffff8132beb0
[  359.877258] Call Trace:
[  359.877258]  [<ffffffff8132beb0>] ? sprintf+0x40/0x50
[  359.877259]  [<ffffffff8106167c>] ? dequeue_task_fair+0x1ec/0x2a0
[  359.877261]  [<ffffffff810334a1>] ? print_prefix+0xd1/0x120
[  359.877262]  [<ffffffff81033a3c>] ? msg_print_text+0xac/0x1a0
[  359.877263]  [<ffffffff815912e4>] schedule+0x24/0x70
[  359.877264]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  359.877265]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  359.877267]  [<ffffffff81591176>] wait_for_common+0xc6/0x160
[  359.877268]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  359.877269]  [<ffffffff810a6b80>] ? call_rcu_bh+0x20/0x20
[  359.877270]  [<ffffffff815912b8>] wait_for_completion+0x18/0x20
[  359.877272]  [<ffffffff8104d158>] wait_rcu_gp+0x48/0x50
[  359.877273]  [<ffffffff8104d160>] ? wait_rcu_gp+0x50/0x50
[  359.877274]  [<ffffffff810a5eb9>] synchronize_sched+0x29/0x30
[  359.877275]  [<ffffffff81483c58>] raid5_remove_disk+0x118/0x190
[  359.877277]  [<ffffffff81496bd7>] md_check_recovery+0x4b7/0x700
[  359.877278]  [<ffffffff8148b2ea>] raid5d+0x2a/0x5f0
[  359.877279]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  359.877281]  [<ffffffff814908ee>] md_thread+0x10e/0x140
[  359.877282]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  359.877283]  [<ffffffff814907e0>] ? md_register_thread+0x100/0x100
[  359.877285]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  359.877286]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  359.877288]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  359.877289]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  359.877252] md1_raid6       D ffff880222550000     0  4873      2 0x00000000
[  469.467957] INFO: rcu_sched self-detected stall on CPU { 2}
(t=72006 jiffies)
[  469.468250] Pid: 2182, comm: kworker/u:5 Not tainted
3.5.1-gentoo-testserver-ipmi #1
[  469.468401] Call Trace:
[  469.468489]  <IRQ>  [<ffffffff810a6d82>] __rcu_pending+0x192/0x4c0
[  469.468625]  [<ffffffff810a7aa8>] rcu_check_callbacks+0x98/0xe0
[  469.468721]  [<ffffffff81040913>] update_process_times+0x43/0x80
[  469.468816]  [<ffffffff8107b4c8>] tick_sched_timer+0x58/0x150
[  469.468911]  [<ffffffff81053b98>] __run_hrtimer.isra.32+0x58/0x100
[  469.469007]  [<ffffffff81054283>] hrtimer_interrupt+0xf3/0x230
[  469.469104]  [<ffffffff8101ee04>] smp_apic_timer_interrupt+0x64/0xa0
[  469.469201]  [<ffffffff81599107>] apic_timer_interrupt+0x67/0x70
[  469.469298]  <EOI>  [<ffffffff813e8a42>] ? scsi_is_host_device+0x12/0x20
[  469.469435]  [<ffffffff813f4a65>] ? scsi_remove_target+0xf5/0x1d0
[  469.469534]  [<ffffffff813fe895>] sas_rphy_remove+0x55/0x60
[  469.469632]  [<ffffffff813fe8b1>] sas_rphy_delete+0x11/0x20
[  469.469730]  [<ffffffff813fe8e5>] sas_port_delete+0x25/0x160
[  469.469827]  [<ffffffff81431183>] mptsas_del_end_device+0x183/0x270
[  469.469925]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  469.470020]  [<ffffffff8143562c>] mptsas_hotplug_work+0x1ec/0x920
[  469.470116]  [<ffffffff810f00d7>] ? kfree+0x17/0xb0
[  469.470209]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  469.470307]  [<ffffffff81436e00>] mptsas_firmware_event_work+0xba0/0xf80
[  469.470405]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  469.470501]  [<ffffffff81048af3>] ? cwq_activate_first_delayed+0x33/0xa0
[  469.470601]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  469.470701]  [<ffffffff8104aaa2>] process_one_work+0x102/0x390
[  469.470799]  [<ffffffff8104b150>] ? manage_workers.isra.33+0x1d0/0x220
[  469.470900]  [<ffffffff8104b2fe>] worker_thread+0x15e/0x350
[  469.470997]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  469.471097]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  469.471300] INFO: Stall ended before state dump start
[  469.471297] INFO: rcu_sched detected stalls on CPUs/tasks: { 2}
(detected by 7, t=72007 jiffies)
[  469.472300]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  469.472582]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  469.472682]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  479.604951] INFO: task md0_raid1:4853 blocked for more than 120 seconds.
[  479.605051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.605197] md0_raid1       D ffff880221e61690     0  4853      2 0x00000000
[  479.605366]  ffff88022278dae0 0000000000000046 ffff88022278d9f0
ffff88022278dfd8
[  479.605652]  ffff88022278dfd8 0000000000004000 ffff8802244d43b0
ffff880221e61690
[  479.605936]  ffffffff81b2853c 000000000000001c ffff88022278da70
ffffffff8132beb0
[  479.606218] Call Trace:
[  479.606307]  [<ffffffff8132beb0>] ? sprintf+0x40/0x50
[  479.606401]  [<ffffffff8106167c>] ? dequeue_task_fair+0x1ec/0x2a0
[  479.606497]  [<ffffffff810334a1>] ? print_prefix+0xd1/0x120
[  479.606592]  [<ffffffff81033a3c>] ? msg_print_text+0xac/0x1a0
[  479.606689]  [<ffffffff815912e4>] schedule+0x24/0x70
[  479.606783]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  479.606880]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  479.606977]  [<ffffffff81591176>] wait_for_common+0xc6/0x160
[  479.607073]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  479.607170]  [<ffffffff810a6b80>] ? call_rcu_bh+0x20/0x20
[  479.607263]  [<ffffffff815912b8>] wait_for_completion+0x18/0x20
[  479.607358]  [<ffffffff8104d158>] wait_rcu_gp+0x48/0x50
[  479.607452]  [<ffffffff8104d160>] ? wait_rcu_gp+0x50/0x50
[  479.607548]  [<ffffffff810a5eb9>] synchronize_sched+0x29/0x30
[  479.607646]  [<ffffffff81476181>] raid1_remove_disk+0xe1/0x170
[  479.607743]  [<ffffffff81496bd7>] md_check_recovery+0x4b7/0x700
[  479.607843]  [<ffffffff81477175>] raid1d+0x35/0x1010
[  479.607940]  [<ffffffff815912e4>] ? schedule+0x24/0x70
[  479.608036]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  479.608134]  [<ffffffff814908ee>] md_thread+0x10e/0x140
[  479.608231]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.608332]  [<ffffffff814907e0>] ? md_register_thread+0x100/0x100
[  479.608429]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  479.608523]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  479.608619]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  479.608718]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  479.608811] INFO: task md1_raid6:4873 blocked for more than 120 seconds.
[  479.608908] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.609059] md1_raid6       D ffff880222550000     0  4873      2 0x00000000
[  479.609230]  ffff880220fa5b20 0000000000000046 0000000000000000
ffff880220fa5fd8
[  479.609521]  ffff880220fa5fd8 0000000000004000 ffffffff81a13440
ffff880222550000
[  479.609809]  ffffffff81b2876c 0000000000000017 ffff880220fa5ab0
ffffffff8132beb0
[  479.610093] Call Trace:
[  479.610181]  [<ffffffff8132beb0>] ? sprintf+0x40/0x50
[  479.610276]  [<ffffffff8106167c>] ? dequeue_task_fair+0x1ec/0x2a0
[  479.610373]  [<ffffffff810334a1>] ? print_prefix+0xd1/0x120
[  479.610468]  [<ffffffff81033a3c>] ? msg_print_text+0xac/0x1a0
[  479.610566]  [<ffffffff815912e4>] schedule+0x24/0x70
[  479.610662]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  479.610759]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  479.610859]  [<ffffffff81591176>] wait_for_common+0xc6/0x160
[  479.610957]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  479.611053]  [<ffffffff810a6b80>] ? call_rcu_bh+0x20/0x20
[  479.611150]  [<ffffffff815912b8>] wait_for_completion+0x18/0x20
[  479.611247]  [<ffffffff8104d158>] wait_rcu_gp+0x48/0x50
[  479.611344]  [<ffffffff8104d160>] ? wait_rcu_gp+0x50/0x50
[  479.611441]  [<ffffffff810a5eb9>] synchronize_sched+0x29/0x30
[  479.611537]  [<ffffffff81483c58>] raid5_remove_disk+0x118/0x190
[  479.611636]  [<ffffffff81496bd7>] md_check_recovery+0x4b7/0x700
[  479.611732]  [<ffffffff8148b2ea>] raid5d+0x2a/0x5f0
[  479.611827]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  479.611926]  [<ffffffff814908ee>] md_thread+0x10e/0x140
[  479.612023]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.612122]  [<ffffffff814907e0>] ? md_register_thread+0x100/0x100
[  479.612221]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  479.612318]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  479.612417]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  479.612516]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  479.612610] INFO: task btrfs-transacti:4897 blocked for more than
120 seconds.
[  479.612758] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.612909] btrfs-transacti D ffff88022282e400     0  4897      2 0x00000000
[  479.613080]  ffff88021f769660 0000000000000046 ffff88021f769598
ffff88021f769fd8
[  479.613370]  ffff88021f769fd8 0000000000004000 ffff8802245043b0
ffff88022122c3b0
[  479.613659]  0000000000000000 0000000000000000 ffffea000878cd80
ffffea00087549c0
[  479.613946] Call Trace:
[  479.614034]  [<ffffffff815912e4>] schedule+0x24/0x70
[  479.614126]  [<ffffffff814950d5>] md_write_start+0xb5/0x1a0
[  479.614220]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.614315]  [<ffffffff81488432>] make_request+0x32/0x3e0
[  479.614410]  [<ffffffff812aca86>] ? __btrfs_map_block+0x216/0x640
[  479.614507]  [<ffffffff811284a0>] ? bvec_alloc_bs+0x60/0x110
[  479.614600]  [<ffffffff81128099>] ? __bio_add_page.part.29+0xf9/0x200
[  479.614696]  [<ffffffff8148fa56>] md_make_request+0xc6/0x200
[  479.614792]  [<ffffffff81306277>] ? generic_make_request_checks+0x17/0x1f0
[  479.614888]  [<ffffffff811281f3>] ? bio_add_page+0x53/0x60
[  479.614983]  [<ffffffff812a7d10>] ? submit_extent_page.isra.45+0x1b0/0x200
[  479.615080]  [<ffffffff8130740f>] generic_make_request+0xbf/0x100
[  479.615175]  [<ffffffff813074c3>] submit_bio+0x73/0xf0
[  479.615268]  [<ffffffff812a87fd>] ? __extent_writepage+0x3ad/0x6f0
[  479.615364]  [<ffffffff810f0fbf>] ? __kmalloc+0x11f/0x190
[  479.615459]  [<ffffffff812e0535>] btrfsic_submit_bio+0x95/0x330
[  479.615553]  [<ffffffff810b903b>] ? find_get_pages_tag+0xcb/0x170
[  479.615651]  [<ffffffff812b1e55>] btrfs_map_bio+0x165/0x200
[  479.615749]  [<ffffffff81287c28>] btrfs_submit_bio_hook+0x78/0x140
[  479.615849]  [<ffffffff812a41c5>] submit_one_bio+0x65/0xa0
[  479.615947]  [<ffffffff812a46a4>] flush_epd_write_bio+0x34/0x50
[  479.616046]  [<ffffffff812a918c>] extent_writepages+0x4c/0x60
[  479.616144]  [<ffffffff81289b30>] ? btrfs_writepage+0x70/0x70
[  479.616242]  [<ffffffff810f0006>] ? kmem_cache_free+0x16/0x90
[  479.616340]  [<ffffffff81288fc3>] btrfs_writepages+0x23/0x30
[  479.616436]  [<ffffffff810c2fbb>] do_writepages+0x1b/0x30
[  479.616530]  [<ffffffff810ba3e1>] __filemap_fdatawrite_range+0x51/0x60
[  479.616626]  [<ffffffff810bb32e>] filemap_fdatawrite_range+0xe/0x10
[  479.616722]  [<ffffffff812a3909>] btrfs_wait_ordered_range+0x49/0x120
[  479.616822]  [<ffffffff812c2d7b>] __btrfs_write_out_cache+0x84b/0xa40
[  479.616922]  [<ffffffff812bb916>] ? btrfs_set_lock_blocking_rw+0x86/0xf0
[  479.617022]  [<ffffffff812c3021>] btrfs_write_out_cache+0xb1/0xf0
[  479.617122]  [<ffffffff812a9a92>] ? free_extent_buffer+0x32/0x90
[  479.617222]  [<ffffffff812751e1>] btrfs_write_dirty_block_groups+0x4d1/0x5b0
[  479.617322]  [<ffffffff8158c44f>] commit_cowonly_roots+0x10d/0x1de
[  479.617422]  [<ffffffff81285b52>] btrfs_commit_transaction+0x5c2/0xa00
[  479.617523]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.617622]  [<ffffffff8128641b>] ? start_transaction+0x8b/0x2a0
[  479.617718]  [<ffffffff8127e3dd>] transaction_kthread+0x23d/0x2b0
[  479.617814]  [<ffffffff8127e1a0>] ? cleaner_kthread+0x1c0/0x1c0
[  479.617909]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  479.618004]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  479.618101]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  479.618200]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  479.618298] INFO: task syslog-ng:5897 blocked for more than 120 seconds.
[  479.618398] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.618549] syslog-ng       D ffff880222db1920     0  5897   5595 0x00000000
[  479.618717]  ffff880220087a98 0000000000000086 ffff8802200879a8
ffff880220087fd8
[  479.619006]  ffff880220087fd8 0000000000004000 ffff880224510000
ffff88022216c3b0
[  479.619294]  ffff880220087b28 ffffffff81062175 0000000000000005
0000000000000000
[  479.619579] Call Trace:
[  479.619668]  [<ffffffff81062175>] ? find_busiest_group+0x165/0xb90
[  479.619763]  [<ffffffff815912e4>] schedule+0x24/0x70
[  479.619860]  [<ffffffff81284f6d>] wait_current_trans.isra.31+0x8d/0xf0
[  479.619960]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.620059]  [<ffffffff81286578>] start_transaction+0x1e8/0x2a0
[  479.620155]  [<ffffffff81286680>] btrfs_join_transaction+0x10/0x20
[  479.620254]  [<ffffffff81290f80>] btrfs_dirty_inode+0x50/0xd0
[  479.620351]  [<ffffffff81291215>] btrfs_update_time+0x55/0x90
[  479.620450]  [<ffffffff81039d31>] ? current_fs_time+0x11/0x50
[  479.620547]  [<ffffffff8111204e>] update_time+0x1e/0xb0
[  479.620643]  [<ffffffff8111549d>] ? mnt_clone_write+0xd/0x30
[  479.620739]  [<ffffffff81112174>] file_update_time+0x94/0xf0
[  479.620837]  [<ffffffff812954c8>] btrfs_file_aio_write+0x1b8/0x4b0
[  479.620936]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  479.621034]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  479.621132]  [<ffffffff81329f14>] ? timerqueue_del+0x34/0x90
[  479.621230]  [<ffffffff81295310>] ? __btrfs_buffered_write+0x320/0x320
[  479.621330]  [<ffffffff810fa633>] do_sync_readv_writev+0xd3/0x110
[  479.621428]  [<ffffffff810fa76a>] ? rw_copy_check_uvector+0x7a/0x130
[  479.621526]  [<ffffffff810fa8e8>] do_readv_writev+0xc8/0x1c0
[  479.621625]  [<ffffffff810f9bbb>] ? generic_file_llseek+0x1b/0x20
[  479.621722]  [<ffffffff81293d94>] ? btrfs_file_llseek+0x64/0x390
[  479.621817]  [<ffffffff810faa17>] vfs_writev+0x37/0x50
[  479.621910]  [<ffffffff810fab85>] sys_writev+0x45/0xc0
[  479.622006]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  479.622104] INFO: task flush-btrfs-1:5697 blocked for more than 120 seconds.
[  479.622201] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.622350] flush-btrfs-1   D ffff880222db1920     0  5697      2 0x00000000
[  479.622522]  ffff8802210bb710 0000000000000046 ffff8802210bb650
ffff8802210bbfd8
[  479.622810]  ffff8802210bbfd8 0000000000004000 ffff880224510000
ffff8802211f0000
[  479.623098]  0000000000000000 0000000000000000 ffff8802210bb720
ffff880220952120
[  479.624389] Call Trace:
[  479.624476]  [<ffffffff810b91bf>] ? find_get_pages_contig+0xdf/0x160
[  479.624573]  [<ffffffff810b9422>] ? unlock_page+0x22/0x30
[  479.624667]  [<ffffffff812a67cb>] ? extent_clear_unlock_delalloc+0x21b/0x240
[  479.624765]  [<ffffffff815912e4>] schedule+0x24/0x70
[  479.624858]  [<ffffffff81284f6d>] wait_current_trans.isra.31+0x8d/0xf0
[  479.624956]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.625052]  [<ffffffff81286578>] start_transaction+0x1e8/0x2a0
[  479.625147]  [<ffffffff81286680>] btrfs_join_transaction+0x10/0x20
[  479.625243]  [<ffffffff8128c8b3>] cow_file_range+0x83/0x490
[  479.625339]  [<ffffffff812a434d>] ? next_state+0xd/0x30
[  479.625434]  [<ffffffff812a559f>] ? __set_extent_bit+0x15f/0x4d0
[  479.625531]  [<ffffffff8128d96c>] run_delalloc_range+0x34c/0x370
[  479.625628]  [<ffffffff812a89fd>] __extent_writepage+0x5ad/0x6f0
[  479.625726]  [<ffffffff812a7a40>] ? end_extent_writepage+0x70/0x70
[  479.625825]  [<ffffffff812a8dfa>]
extent_write_cache_pages.isra.37.constprop.51+0x2ba/0x410
[  479.625972]  [<ffffffff81059fe7>] ? walk_tg_tree_from+0x67/0xd0
[  479.626066]  [<ffffffff812a9181>] extent_writepages+0x41/0x60
[  479.626164]  [<ffffffff81289b30>] ? btrfs_writepage+0x70/0x70
[  479.626261]  [<ffffffff81288fc3>] btrfs_writepages+0x23/0x30
[  479.626356]  [<ffffffff810c2fbb>] do_writepages+0x1b/0x30
[  479.626453]  [<ffffffff8111cefa>] __writeback_single_inode.isra.28+0x3a/0x110
[  479.626553]  [<ffffffff8111d7bb>] writeback_sb_inodes+0x19b/0x350
[  479.626649]  [<ffffffff8111da06>] __writeback_inodes_wb+0x96/0xc0
[  479.626748]  [<ffffffff8111dbfb>] wb_writeback+0x1cb/0x1e0
[  479.626843]  [<ffffffff8111dca7>] wb_check_old_data_flush+0x97/0xa0
[  479.626941]  [<ffffffff8111e028>] wb_do_writeback+0xc8/0x140
[  479.627037]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  479.627137]  [<ffffffff8111e112>] bdi_writeback_thread+0x72/0x140
[  479.627235]  [<ffffffff8111e0a0>] ? wb_do_writeback+0x140/0x140
[  479.627333]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  479.627429]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  479.627528]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  479.627629]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.815528] SysRq : Show State
[  522.815657]   task                        PC stack   pid father
[  522.815754] init            S ffff88022225ae00     0     1      0 0x00000000
[  522.815924]  ffff8802244d98f8 0000000000000086 0000000000000000
ffff8802244d9fd8
[  522.816207]  ffff8802244d9fd8 0000000000004000 ffff8802245043b0
ffff8802244d0000
[  522.816492]  ffff8802244d9920 ffff88022fccd590 000000000000d540
00000000004c4b3f
[  522.816777] Call Trace:
[  522.816871]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  522.816964]  [<ffffffff81053772>] ? enqueue_hrtimer+0x22/0x50
[  522.817059]  [<ffffffff81053f70>] ? __hrtimer_start_range_ns+0x120/0x300
[  522.817156]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.817249]  [<ffffffff8159020c>] schedule_hrtimeout_range_clock+0xfc/0x140
[  522.817345]  [<ffffffff81053860>] ? update_rmtp+0x70/0x70
[  522.817439]  [<ffffffff8105417f>] ? hrtimer_start_range_ns+0xf/0x20
[  522.817534]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  522.817630]  [<ffffffff8110b824>] poll_schedule_timeout+0x44/0x60
[  522.817725]  [<ffffffff8110c179>] do_select+0x569/0x680
[  522.817818]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  522.817911]  [<ffffffff8132a302>] ? put_dec+0x72/0x90
[  522.818004]  [<ffffffff8132ae04>] ? number.isra.2+0x304/0x330
[  522.818098]  [<ffffffff81105fdb>] ? lookup_fast+0xcb/0x310
[  522.818192]  [<ffffffff81104d2d>] ? inode_permission+0x2d/0xe0
[  522.818358]  [<ffffffff81106287>] ? link_path_walk+0x67/0x8d0
[  522.818452]  [<ffffffff81105f4f>] ? lookup_fast+0x3f/0x310
[  522.818548]  [<ffffffff81104197>] ? complete_walk+0x77/0xf0
[  522.818645]  [<ffffffff81106c38>] ? path_lookupat+0x68/0x710
[  522.818743]  [<ffffffff8110c49d>] core_sys_select+0x20d/0x320
[  522.818842]  [<ffffffff810fe2c1>] ? cp_new_stat+0x111/0x130
[  522.818941]  [<ffffffff81074388>] ? ktime_get_ts+0xa8/0xe0
[  522.819037]  [<ffffffff8110c66b>] sys_select+0xbb/0x100
[  522.819132]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  522.819230] kthreadd        S 0000000000000000     0     2      0 0x00000000
[  522.819399]  ffff8802244dbef0 0000000000000046 0000000000800711
ffff8802244dbfd8
[  522.819690]  ffff8802244dbfd8 0000000000004000 ffff880224501690
ffff8802244d1690
[  522.819979]  0000000000000000 ffff880220195d68 ffff880220195d28
ffff8802244d1690
[  522.820267] Call Trace:
[  522.820357]  [<ffffffff81009edc>] ? kernel_thread+0x6c/0x70
[  522.820452]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.820549]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.820646]  [<ffffffff81050295>] kthreadd+0x135/0x140
[  522.820744]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.820843]  [<ffffffff81050160>] ? tsk_fork_get_node+0x10/0x10
[  522.820941]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.821037] ksoftirqd/0     S 0000000000000000     0     3      2 0x00000000
[  522.821208]  ffff8802244f1e80 0000000000000046 ffff8801ea438560
ffff8802244f1fd8
[  522.821497]  ffff8802244f1fd8 0000000000004000 ffffffff81a13440
ffff8802244d2d20
[  522.821784]  0000000000000000 ffff88022286fc28 ffff880222fbf800
0000000000000100
[  522.822067] Call Trace:
[  522.822155]  [<ffffffff813e7b60>] ? scsi_finish_command+0xd0/0x130
[  522.822254]  [<ffffffff813f019b>] ? scsi_softirq_done+0x12b/0x140
[  522.822352]  [<ffffffff8130d54b>] ? blk_done_softirq+0x6b/0x80
[  522.822450]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.822548]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.822648]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.822747]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.822844]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.822940]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.823038]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.823138]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.823230] kworker/0:0     S ffff8802244d43b0     0     4      2 0x00000000
[  522.823397]  ffff8802244f3e60 0000000000000046 0000000100010816
ffff8802244f3fd8
[  522.823759]  ffff8802244f3fd8 0000000000004000 ffffffff81a13440
ffff8802244d43b0
[  522.824044]  ffff8802244f3db0 ffffffff8105575d 000000010003c800
ffff88022680d980
[  522.824333] Call Trace:
[  522.824424]  [<ffffffff8105575d>] ? up+0x2d/0x50
[  522.824520]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  522.824618]  [<ffffffff813756a0>] ? poke_blanked_console+0xd0/0xd0
[  522.824716]  [<ffffffff81375725>] ? console_callback+0x85/0x130
[  522.824814]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.824911]  [<ffffffff8104b16e>] ? manage_workers.isra.33+0x1ee/0x220
[  522.825010]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.825103]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.825198]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.825294]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.825388]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.825486]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.825586]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.825682] migration/0     S 0000000000000000     0     6      2 0x00000000
[  522.825850]  ffff8802244fbdf0 0000000000000046 ffff880221930000
ffff8802244fbfd8
[  522.826134]  ffff8802244fbfd8 0000000000004000 ffffffff81a13440
ffff880224500000
[  522.826419]  0000000000000006 ffff88022fd90f00 ffff8802244fbd30
ffffffff8105fb44
[  522.826704] Call Trace:
[  522.826796]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.826895]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.826995]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.827092]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.827190]  [<ffffffff810a5bb0>] ? rcu_adopt_orphan_cbs+0x120/0x120
[  522.827288]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.827381]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.827477]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.827573]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.827668]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.827764]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.827858]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.827955]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.828055]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.828150] migration/1     S ffff88022fc50f00     0     7      2 0x00000000
[  522.828320]  ffff88022451bdf0 0000000000000046 ffff880222e0ce00
ffff88022451bfd8
[  522.828612]  ffff88022451bfd8 0000000000004000 ffff880222cd9690
ffff8802245143b0
[  522.828902]  0000000000000006 ffff88022fd90f00 ffff88022451bd30
ffffffff8105fb44
[  522.829263] Call Trace:
[  522.829351]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.829446]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.829542]  [<ffffffff8106120b>] ? active_load_balance_cpu_stop+0x17b/0x240
[  522.829642]  [<ffffffff81061090>] ? can_migrate_task+0x100/0x100
[  522.829740]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.829835]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.829934]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.830034]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.830132]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.830232]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.830330]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.830430]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.830530]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.830622] ksoftirqd/1     S 0000000000000000     0     9      2 0x00000000
[  522.830789]  ffff88022451fe80 0000000000000046 ffff8802218ead20
ffff88022451ffd8
[  522.831077]  ffff88022451ffd8 0000000000004000 ffff880224501690
ffff880224528000
[  522.831358]  ffff88022451fdc0 ffffffff810f007c ffff880222bbb800
0000000000000286
[  522.831639] Call Trace:
[  522.831727]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  522.831821]  [<ffffffff810a7101>] ? __rcu_process_callbacks+0x51/0x3f0
[  522.831918]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.832010]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.833095]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.833189]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.833284]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.833377]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.833474]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.833571]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.833664] migration/2     R  running task        0    10      2 0x00000000
[  522.833830]  ffff880224525df0 0000000000000046 ffff8801e94f2800
ffff880224525fd8
[  522.834112]  ffff880224525fd8 0000000000004000 ffff880224502d20
ffff880224529690
[  522.834398]  0000000000000007 ffff88022fdd0f00 ffff880224525d30
ffffffff8105fb44
[  522.834683] Call Trace:
[  522.834773]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.834873]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.834972]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.835066]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.835161]  [<ffffffff810a5bb0>] ? rcu_adopt_orphan_cbs+0x120/0x120
[  522.835257]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.835351]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.835447]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.835545]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.835642]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.835740]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.835835]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.835932]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.836031]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.836125] kworker/2:0     S ffff88022452ad20     0    11      2 0x00000000
[  522.836296]  ffff880224527e60 0000000000000046 ffff880224527da0
ffff880224527fd8
[  522.836586]  ffff880224527fd8 0000000000004000 ffff880223190000
ffff88022452ad20
[  522.836876]  ffff880226802180 ffff880223f30300 ffff880222ff0000
ffff880222ed9170
[  522.837166] Call Trace:
[  522.837257]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  522.837355]  [<ffffffff8130bae4>] ? ioc_release_fn+0x84/0xc0
[  522.837452]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.837549]  [<ffffffff8104b150>] ? manage_workers.isra.33+0x1d0/0x220
[  522.837646]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.837739]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.837835]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.837933]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.838028]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.838127]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.838227]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.838324] ksoftirqd/2     S 0000000000000000     0    12      2 0x00000000
[  522.838495]  ffff88022453de80 0000000000000046 ffff8801ea4cf020
ffff88022453dfd8
[  522.838785]  ffff88022453dfd8 0000000000004000 ffff880224502d20
ffff88022452c3b0
[  522.839073]  0000000000000000 ffff88022286fc28 ffff880222fbf800
0000000000000100
[  522.839356] Call Trace:
[  522.839445]  [<ffffffff813e7b60>] ? scsi_finish_command+0xd0/0x130
[  522.839543]  [<ffffffff813f019b>] ? scsi_softirq_done+0x12b/0x140
[  522.839640]  [<ffffffff8130d54b>] ? blk_done_softirq+0x6b/0x80
[  522.839738]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.839835]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.839936]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.840035]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.840134]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.840302]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.840401]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.840498]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.840592] migration/3     S 0000000000000000     0    13      2 0x00000000
[  522.840760]  ffff88022453fdf0 0000000000000046 ffff8801e94f1200
ffff88022453ffd8
[  522.841044]  ffff88022453ffd8 0000000000004000 ffff880222012d20
ffff88022452da40
[  522.841330]  0000000000000004 ffff88022fd10f00 ffff88022453fd30
ffffffff8105fb44
[  522.841615] Call Trace:
[  522.841706]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.841804]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.841901]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.841996]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.842095]  [<ffffffff810a5bb0>] ? rcu_adopt_orphan_cbs+0x120/0x120
[  522.842194]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.842291]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.842386]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.842485]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.843862]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.843962]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.844060]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.844159]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.844259]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.844353] ksoftirqd/3     S 0000000000000000     0    15      2 0x00000000
[  522.844520]  ffff880224547e80 0000000000000046 ffff880221a0da40
ffff880224547fd8[  522.849636]  [<ffffffff810a7101>] ?
__rcu_process_callbacks+0x51/0x3f0
[  522.849736]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.855040]  ffff880224555fd8 0000000000004000 ffff880224505a40
ffff88022454ad20
[  522.855330]  0000000000000005 ffff88022fd50f00 ffff880224555d30
ffffffff8105fb44
[  522.859828] Call Trace:
[  522.859915]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.860010]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.860104]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.860197]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.860292]  [<ffffffff810a5bb0>] ? rcu_adopt_orphan_cbs+0x120/0x120
[  522.860387]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.860479]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.860574]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.860669]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.860763]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.860858]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.860950]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.861045]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.861142]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.861234] kworker/4:0     S ffff88022454c3b0     0    17      2 0x00000000
[  522.861403]  ffff880224557e60 0000000000000046 ffff880224557d90
ffff880224557fd8
[  522.861693]  ffff880224557fd8 0000000000000046 ffff8802268056c0
ffff88022455dfd8
[  522.864189]  ffff88022455dfd8 0000000000004000 ffff880224505a40
ffff88022454da40
[  522.864475]  ffff88022455ddc0 ffffffff810f0005 ffff88021f0cf390
0000000000000286
[  522.864760] Call Trace:
[  522.864850]  [<ffffffff810f0005>] ? kmem_cache_free+0x15/0x90
[  522.864947]  [<ffffffff810a7101>] ? __rcu_process_callbacks+0x51/0x3f0
[  522.865046]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.865142]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.865242]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.865340]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.865438]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.865535]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.865633]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.865731]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.865824] migration/5     S 0000000000000000     0    19      2 0x00000000
[  522.865992]  ffff88022455fdf0 0000000000000046 ffff880222e0d000
ffff88022455ffd8
[  522.866278]  ffff88022455ffd8 0000000000004000 ffff8802218543b0
ffff880224560000
[  522.866567]  0000000000000006 ffff88022fd90f00 ffff88022455fd30
ffffffff8105fb44
[  522.866860] Call Trace:
[  522.866952]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.867051]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.867150]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.867248]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.868354]  [<ffffffff810a5bb0>] ? rcu_adopt_orphan_cbs+0x120/0x120
[  522.868451]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.868545]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.868642]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.868741]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.868839]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.868939]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.869034]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.869130]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.869228]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.869321] ksoftirqd/5     S 0000000000000000     0    21      2 0x00000000
[  522.869488]  ffff88022456be80 0000000000000046 ffff8802268056c0
ffff88022456bfd8
[  522.869771]  ffff88022456bfd8 0000000000004000 ffff880224510000
ffff880224562d20
[  522.870056]  ffff88022fd4d9e0 ffff88022246ec30 ffff88022456bde0
0000000000000286
[  522.870341] Call Trace:
[  522.870430]  [<ffffffff810a7101>] ? __rcu_process_callbacks+0x51/0x3f0
[  522.870527]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.870622]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.870723]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.870820]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.870919]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.871014]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.871111]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.871209]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.871301] migration/6     S ffff880220061e68     0    22      2 0x00000000
[  522.871468]  ffff880224571df0 0000000000000046 ffff880222012d20
ffff880224571fd8
[  522.871754]  ffff880224571fd8 0000000000004000 ffff880224511690
ffff8802245643b0
[  522.872043]  0000000000000007 ffff88022fdd0f00 ffff880224571d30
ffffffff8105fb44
[  522.872336] Call Trace:
[  522.872428]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.872527]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.872626]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.872724]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.872821]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.872916]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.873010]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.873106]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.873203]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.873301]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.873401]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.873497]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.873597]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.873697]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.873794] ksoftirqd/6     S 0000000000000000     0    24      2 0x00000000
[  522.873963]  ffff88022457de80 0000000000000046 ffff8802268056c0
ffff88022457dfd8
[  522.874246]  ffff88022457dfd8 0000000000004000 ffff880224511690
ffff880224580000
[  522.874529]  ffff88022457ddc0 ffffffff810f0155 ffff880224093a00
0000000000000286
[  522.874812] Call Trace:
[  522.874899]  [<ffffffff810f0155>] ? kfree+0x95/0xb0
[  522.874992]  [<ffffffff810a7101>] ? __rcu_process_callbacks+0x51/0x3f0
[  522.875088]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.875180]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.875275]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.875370]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.875464]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.875558]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.875657]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.875757]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.875853] migration/7     S ffff880220085e68     0    25      2 0x00000000
[  522.876021]  ffff88022457fdf0 0000000000000046 ffff8801e94f1400
ffff88022457ffd8
[  522.876310]  ffff88022457ffd8 0000000000004000 ffff880224512d20
ffff880224581690
[  522.876600]  0000000000000004 ffff88022fd10f00 ffff88022457fd30
ffffffff8105fb44
[  522.876891] Call Trace:
[  522.876981]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.877078]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.877175]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.877269]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.877362]  [<ffffffff8105a840>] ? __migrate_task+0x150/0x150
[  522.877457]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.877553]  [<ffffffff810944e5>] cpu_stopper_thread+0xf5/0x170
[  522.877650]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.877748]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.877846]  [<ffffffff810943f0>] ? cpu_stop_signal_done+0x30/0x30
[  522.879848]  [<ffffffff8104bd46>] ? schedule_delayed_work+0x16/0x20
[  522.879948]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.880046]  [<ffffffff8104b150>] ? manage_workers.isra.33+0x1d0/0x220
[  522.880142]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.880235]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.880330]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.880428]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.880524]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.880621]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.880722]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.880819] ksoftirqd/7     S 0000000000000000     0    27      2 0x00000000
[  522.880991]  ffff88022459be80 0000000000000046 ffff8802268056c0
ffff88022459bfd8
[  522.881279]  ffff88022459bfd8 0000000000004000 ffff880221c59690
ffff8802245843b0
[  522.881567]  ffff88022459bdc0 ffffffff810f007c ffff8802264c3150
0000000000000286
[  522.881858] Call Trace:
[  522.881948]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  522.882044]  [<ffffffff810a7101>] ? __rcu_process_callbacks+0x51/0x3f0
[  522.882142]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.882238]  [<ffffffff81591579>] schedule_preempt_disabled+0x9/0x10
[  522.882338]  [<ffffffff8103abfd>] run_ksoftirqd+0x10d/0x160
[  522.882436]  [<ffffffff8103aaf0>] ? __do_softirq+0x120/0x120
[  522.882533]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.882630]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.882729]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.882829]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.882923] cpuset          S ffff8802244b7378     0    28      2 0x00000000
[  522.883092]  ffff8802245a5e40 0000000000000046 ffff88022fc10f60
ffff8802245a5fd8
[  522.883380]  ffff8802245a5fd8 0000000000004000 ffff880224511690
ffff8802245a8000
[  522.883672]  ffff8802245a5d90 ffffffff8105f61c ffff8802245a8048
ffff88022fd90f60
[  522.883964] Call Trace:
[  522.884057]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.884155]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.884253]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.884350]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.884446]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.884539]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.884633]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.884729]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.884825]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.884922]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.885022]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.885119] khelper         S ffff8802244b7438     0    29      2 0x00000000
[  522.885290]  ffff8802245cde40 0000000000000046 ffff88022fc10f60
ffff8802245cdfd8
[  522.885582]  ffff8802245cdfd8 0000000000004000 ffff880224511690
ffff8802245a9690
[  522.885874]  ffff8802245cdd90 ffffffff8105f61c ffff8802245a96d8
ffff88022fd90f60
[  522.886159] Call Trace:
[  522.886247]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.886343]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.886438]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.886534]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.886631]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.886727]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.886825]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.886925]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.887022]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.887121]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.887222]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.887318] kdevtmpfs       S 0000000000000000     0    30      2 0x00000000
[  522.887485]  ffff8802245cfe90 0000000000000046 ffff8802245cfda0
ffff8802245cffd8
[  522.887773]  ffff8802245cffd8 0000000000004000 ffff8802245043b0
ffff8802245aad20
[  522.888058]  ffff880222012d20 0000000000000082 ffff8802245cfe10
ffffffff8105cc5e
[  522.888341] Call Trace:
[  522.888428]  [<ffffffff8105cc5e>] ? try_to_wake_up+0x24e/0x2c0
[  522.888522]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.888617]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.888711]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.888805]  [<ffffffff813d0c2a>] devtmpfsd+0x12a/0x130
[  522.889874]  [<ffffffff813d0b00>] ? handle_create.isra.2+0x230/0x230
[  522.889971]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.890064]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.890160]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.890258]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.890352] netns           S ffff8802244bc2b8     0    31      2 0x00000000
[  522.890519]  ffff880224607e40 0000000000000046 ffff88022fc10f60
ffff880224607fd8
[  522.890804]  ffff880224607fd8 0000000000004000 ffff880224511690
ffff8802245ac3b0
[  522.891090]  ffff880224607d90 ffffffff8105f61c ffff8802245ac3f8
ffff88022fd90f60
[  522.891374] Call Trace:
[  522.891463]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.891562]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.891659]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.891756]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.891853]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.891948]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.892044]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.892142]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.892237]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.892335]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.892433]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.892528] sync_supers     S 0000000000000000     0   186      2 0x00000000
[  522.892697]  ffff880224161ea0 0000000000000046 0000000000010f00
ffff880224161fd8
[  522.892984]  ffff880224161fd8 0000000000004000 ffffffff81a13440
ffff880224629690
[  522.893269]  ffff880224161de0 ffff880224161fd8 ffff880224161fd8
0000000000004000
[  522.893559] Call Trace:
[  522.893649]  [<ffffffff8105cc5e>] ? try_to_wake_up+0x24e/0x2c0
[  522.893747]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.893847]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.893946]  [<ffffffff810cefc0>] ? bdi_sched_wait+0x10/0x10
[  522.894045]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.895660] Call Trace:
[  522.895752]  [<ffffffff810589e6>] ? task_rq_lock+0x56/0xa0
[  522.895853]  [<ffffffff810589e6>] ? task_rq_lock+0x56/0xa0
[  522.895947]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  522.896044]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  522.896141]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.896234]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  522.896331]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  522.896430]  [<ffffffff810cfea1>] bdi_forker_thread+0x1f1/0x480
[  522.896527]  [<ffffffff810cfcb0>] ? bdi_clear_pending+0x20/0x20
[  522.896627]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.896724]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.896822]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.896923]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.897020] kblockd         S ffff880224708d38     0   190      2 0x00000000
[  522.897190]  ffff880224169e40 0000000000000046 ffff88022fc10f60
ffff880224169fd8
[  522.897481]  ffff880224169fd8 0000000000004000 ffff880224512d20
ffff88022462c3b0
[  522.897769]  ffff880224169d90 ffffffff8105f61c ffff88022462c3f8
ffff88022fdd0f60
[  522.898054] Call Trace:
[  522.898143]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.898241]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.898338]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.898435]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.898530]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.898624]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.898720]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.898817]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.898912]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.899008]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.899108]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.899204] khubd           S 0000000000000006     0   362      2 0x00000000
[  522.899373]  ffff8802247fbdb0 0000000000000046 ffff8802247fbcc0
ffff8802247fbfd8
[  522.899665]  ffff8802247fbfd8 0000000000004000 ffff880224501690
ffff88022462da40
[  522.899956]  ffff8802247fbcf0 ffffffff81a402c0 0000000000000000
ffff880222244e10
[  522.900244] Call Trace:
[  522.900332]  [<ffffffff813d36dd>] ? device_pm_init+0x4d/0x90
[  522.900427]  [<ffffffff813ca079>] ? device_register+0x19/0x20
[  522.900523]  [<ffffffff8144c924>] ? usb_create_ep_devs+0x94/0xf0
[  522.900619]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.900715]  [<ffffffff81441774>] hub_thread+0xdc4/0x1240
[  522.900812]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  522.900910]  [<ffffffff814409b0>] ? usb_new_device+0x1e0/0x1e0
[  522.901009]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.901107]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.901206]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.901307]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.901403] md              S ffff8802241c7138     0   369      2 0x00000000
[  522.901574]  ffff8802247b9e40 0000000000000046 ffff88022fc10f60
ffff8802247b9fd8
[  522.901860]  ffff8802247b9fd8 0000000000004000 ffff880224512d20
ffff880224740000
[  522.902145]  ffff8802247b9d90 ffffffff8105f61c ffff880224740048
ffff88022fdd0f60
[  522.902433] Call Trace:
[  522.902520]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.902614]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.902709]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.902801]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.902895]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.902988]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.903082]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.903177]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.903270]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.903365]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.903462]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.903554] khungtaskd      S 000000000000038a     0   511      2 0x00000000
[  522.903720]  ffff880222ca5dd0 0000000000000046 0000000000000002
ffff880222ca5fd8
[  522.904002]  ffff880222ca5fd8 0000000000004000 ffff880224512d20
ffff880224742d20
[  522.904294]  0000000000000000 ffff8802210bb5f0 000000000000b760
ffffffff81600180
[  522.904586] Call Trace:
[  522.904678]  [<ffffffff8100425f>] ? dump_trace+0x16f/0x2a0
[  522.904775]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.904871]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  522.904968]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  522.905067]  [<ffffffff8158f849>] schedule_timeout_interruptible+0x19/0x20
[  522.905167]  [<ffffffff8109feca>] watchdog+0x4a/0x220
[  522.905262]  [<ffffffff8109fe80>] ? hung_task_panic+0x20/0x20
[  522.905361]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.905458]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.905557]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.905657]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.905752] kswapd0         S 0000000000000000     0   516      2 0x00000000
[  522.905922]  ffff880222cbbe30 0000000000000046 0000000000000000
ffff880222cbbfd8
[  522.906209]  ffff880222cbbfd8 0000000000004000 ffff880224512d20
ffff8802247443b0
[  522.906495]  00000000fffea120 0000000000000286 ffff880222cbbd90
ffffffff8104013d
[  522.906786] Call Trace:
[  522.906878]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  522.906977]  [<ffffffff810401a2>] ? del_timer_sync+0x32/0x50
[  522.907077]  [<ffffffff810cecc7>] ? set_pgdat_percpu_threshold+0x97/0xc0
[  522.907178]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.907274]  [<ffffffff810c86a5>] kswapd+0x295/0x2f0
[  522.907370]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  522.907467]  [<ffffffff810c8410>] ? balance_pgdat+0x690/0x690
[  522.907564]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.907657]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.907754]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.907852]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.907946] fsnotify_mark   S ffff880222df7e38     0   581      2 0x00000000
[  522.908116]  ffff880222df7e50 0000000000000046 ffffffff81b6b200
ffff880222df7fd8
[  522.908407]  ffff880222df7fd8 0000000000004000 ffffffff81a13440
ffff880224745a40
[  522.908699]  ffffffff81b6b208 0000000081059afe ffff88022fdd0f00
ffffffff81b6b200
[  522.908991] Call Trace:
[  522.909082]  [<ffffffff81054f04>] ? srcu_reschedule+0x84/0xc0
[  522.909178]  [<ffffffff810553af>] ? __synchronize_srcu+0xcf/0x100
[  522.909275]  [<ffffffff81054f40>] ? srcu_reschedule+0xc0/0xc0
[  522.909369]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.909464]  [<ffffffff81132742>] fsnotify_mark_destroy+0x112/0x150
[  522.909563]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  522.909660]  [<ffffffff81132630>] ? fsnotify_put_mark+0x30/0x30
[  522.909757]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.909853]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.909952]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.910054]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.910152] cifsiod         S ffff880222e5a4f8     0   598      2 0x00000000
[  522.910323]  ffff880222e77e40 0000000000000046 ffff88022fc10f60
ffff880222e77fd8
[  522.911620]  ffff880222e77fd8 0000000000004000 ffff880224512d20
ffff880222e80000
[  522.911910]  ffff880222e77d90 ffffffff8105f61c ffff880222e80048
ffff88022fdd0f60
[  522.912197] Call Trace:
[  522.912285]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.912380]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.912476]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.912571]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.912667]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.912760]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.912855]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
 ffff88022fc10f60 ffff880222ee9fd8 0000000000000046 ffff88022fc10f60
ffff880222eebfd8
[  522.915987]  ffff880222eebfd8 0000000000004000 ffff880224512d20
ffff880222e82d20
[  522.916273]  ffff880222eebd90 ffffffff8105f61c ffff880222e82d68
ffff88022fdd0f60
[  522.916559] Call Trace:
[  522.916649]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.916744]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.916839]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.916932]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.917026]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.917118]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.917211]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.917307]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.917400]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.917495]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.917592]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.917684] xfslogd         S ffff880222e664f8     0   616      2 0x00000000
[  522.917850]  ffff880222eefe40 0000000000000046 ffff88022fc10f60
ffff880222eeffd8
[  522.918134]  ffff880222eeffd8 0000000000004000 ffff880224512d20
ffff880222e843b0
[  522.918424]  ffff880222eefd90 ffffffff8105f61c ffff880222e843f8
ffff88022fdd0f60
[  522.918716] Call Trace:
[  522.918808]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.918906]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.919004]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.919098]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.919192]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.919285]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.919380]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.919479]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.919573]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.919671]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.919773]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.919870] crypto          S ffff880222ef7438     0   627      2 0x00000000
[  522.920040]  ffff880222f2fe40 0000000000000046 ffff88022fc10f60
ffff880222f2ffd8
[  522.920328]  ffff880222f2ffd8 0000000000004000 ffff880224512d20
ffff880222e85a40
[  522.920620]  ffff880222f2fd90 ffffffff8105f61c ffff880222e85a88
ffff88022fdd0f60
[  522.920909] Call Trace:
[  522.921001]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.921098]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.921196]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.921294]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.921392]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.921489]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.921587]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.921685]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.921781]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.921877]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.921974]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.922066] iscsi_eh        S ffff880222806438     0   782      2 0x00000000
[  522.922234]  ffff8802228a1e40 0000000000000046 ffff88022fc10f60
ffff8802228a1fd8
[  522.922524]  ffff8802228a1fd8 0000000000004000 ffff880224511690
ffff880222899690
[  522.922818]  ffff8802228a1d90 ffffffff8105f61c ffff8802228996d8
ffff88022fd90f60
[  522.923112] Call Trace:
[  522.923203]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.923301]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.923399]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.923495]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.923589]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.923682]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.923777]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.923875]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.923970]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.924067]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.924169]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.924265] mpt_poll_0      S ffff880222806f78     0   792      2 0x00000000
[  522.924436]  ffff8802228c9e40 0000000000000046 ffff88022fc10f60
ffff8802228c9fd8
[  522.924728]  ffff8802228c9fd8 0000000000004000 ffff880224511690
ffff8802228c1690
[  522.925018]  ffff8802228c9d90 ffffffff8105f61c ffff8802228c16d8
ffff88022fd90f60
[  522.925301] Call Trace:
[  522.925389]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.925484]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.925580]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.925674]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.925773]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.925870]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.925968]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.926068]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.926165]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.926264]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.926365]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.926461] mpt/0           S ffff88022280b078     0   793      2 0x00000000
[  522.926632]  ffff8802228e9e40 0000000000000046 ffff88022fc10f60
ffff8802228e9fd8
[  522.926919]  ffff8802228e9fd8 0000000000004000 ffff880224511690
ffff8802228c2d20
[  522.927204]  ffff8802228e9d90 ffffffff8105f61c ffff8802228c2d68
ffff88022fd90f60
[  522.927496] Call Trace:
[  522.927587]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.927684]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.927781]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.927877]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.927972]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.928065]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.928160]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.928259]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.928356]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.928455]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.928556]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.928651] kworker/7:1     S ffff8802228c43b0     0   794      2 0x00000000
[  522.928823]  ffff8802228a3e60 0000000000000046 ffff8802228a3d90
ffff8802228a3fd8
[  522.929115]  ffff8802228a3fd8 0000000000004000 ffff880224512d20
ffff8802228c43b0
[  522.929402]  ffff88022fdce220 00000001000106d3 ffff8802228a3da0
ffffffff81040613
[  522.929688] Call Trace:
[  522.929777]  [<ffffffff81040613>] ? add_timer+0x13/0x20
[  522.929874]  [<ffffffff81049d9e>] ? queue_delayed_work_on+0xae/0x130
[  522.929972]  [<ffffffff810cef70>] ? refresh_cpu_vm_stats+0x100/0x100
[  522.930069]  [<ffffffff8104bd1c>] ? queue_delayed_work+0x1c/0x30
[  522.930167]  [<ffffffff8104bd46>] ? schedule_delayed_work+0x16/0x20
[  522.930267]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.930366]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.930462]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.930560]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.930661]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.930756]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.930851]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70

[  522.931774]  ffff88022fd8e220[  522.933911]  [<ffffffff8104b3d3>]
worker_thread+0x233/0x350
[  522.934006]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.934104]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.934200]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.934297]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.934395]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.934489] kworker/4:1     S ffff8802245ada40     0   797      2 0x00000000
[  522.934658]  ffff880222eb3e60 0000000000000046 ffff880222eb3d90
ffff880222eb3fd8
[  522.934944]  ffff880222eb3fd8 0000000000004000 ffff880224505a40
ffff8802245ada40
[  522.935227]  ffff88022fd0e220 00000001000106dc ffff880222eb3da0
ffffffff81040613
[  522.935512] Call Trace:
[  522.935601]  [<ffffffff81040613>] ? add_timer+0x13/0x20
[  522.935696]  [<ffffffff81049d9e>] ? queue_delayed_work_on+0xae/0x130
[  522.935795]  [<ffffffff810cef70>] ? refresh_cpu_vm_stats+0x100/0x100
[  522.935892]  [<ffffffff8104bd1c>] ? queue_delayed_work+0x1c/0x30
[  522.935989]  [<ffffffff8104bd46>] ? schedule_delayed_work+0x16/0x20
[  522.936086]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.936181]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.936277]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.936374]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.936474]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.936568]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.936664]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.936763]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.936858] kworker/3:1     S ffff880222f643b0     0   798      2 0x00000000
[  522.937029]  ffff880222df5e60 0000000000000046 ffff880222df5d90
ffff880222df5fd8
[  522.937320]  ffff880222df5fd8 0000000000004000 ffff8802245043b0
ffff880222f643b0
[  522.937610]  ffff88022fcce220 00000001000106df ffff880222df5da0
ffffffff81040613
[  522.937896] Call Trace:
[  522.937984]  [<ffffffff81040613>] ? add_timer+0x13/0x20
[  522.938080]  [<ffffffff81049d9e>] ? queue_delayed_work_on+0xae/0x130
[  522.938179]  [<ffffffff810cef70>] ? refresh_cpu_vm_stats+0x100/0x100
[  522.938278]  [<ffffffff8104bd1c>] ? queue_delayed_work+0x1c/0x30
[  522.938376]  [<ffffffff8104bd46>] ? schedule_delayed_work+0x16/0x20
[  522.938475]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.938573]  [<ffffffff8104b16e>] ? manage_workers.isra.33+0x1ee/0x220
[  522.938673]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.938768]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.938865]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.938965]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.939059]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.939154]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.939251]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.939346] kworker/2:1     R  running task        0   799      2 0x00000000
[  522.939517]  ffff88022417be60 0000000000000046 ffff88022417bd60
ffff88022417bfd8
[  522.939804]  ffff88022417bfd8 0000000000004000 ffff880224502d20
ffff880222f60000
[  522.940096]  ffffffff810c4ad0 ffff88022253f8f8 0000000000000286
ffff88022253f8f0
[  522.940390] Call Trace:
[  522.940483]  [<ffffffff810c4ad0>] ? __pagevec_release+0x30/0x30
[  522.940581]  [<ffffffff81048d20>] ? do_work_for_cpu+0x30/0x30
[  522.940676]  [<ffffffff8105888d>] ? complete+0x4d/0x60
[  522.940771]  [<ffffffff810c4a91>] ? lru_add_drain+0x11/0x20
[  522.940866]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.940964]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.941060]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.941156]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.941256]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.941354]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.941453]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.941554]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.941650] kworker/1:1     S ffff880222cd9690     0   800      2 0x00000000
[  522.941821]  ffff880222d11e60 0000000000000046 ffff880222d11d90
ffff880222d11fd8
[  522.942111]  ffff880222d11fd8 0000000000004000 ffff880224501690
ffff880222cd9690
[  522.942399]  ffff88022fc4e220 00000001000106e5 ffff880222d11da0
ffffffff81040613
[  522.942689] Call Trace:
[  522.942779]  [<ffffffff81040613>] ? add_timer+0x13/0x20
[  522.942876]  [<ffffffff81049d9e>] ? queue_delayed_work_on+0xae/0x130
[  522.942975]  [<ffffffff810cef70>] ? refresh_cpu_vm_stats+0x100/0x100
[  522.943074]  [<ffffffff8104bd1c>] ? queue_delayed_work+0x1c/0x30
[  522.943173]  [<ffffffff8104bd46>] ? schedule_delayed_work+0x16/0x20
[  522.943271]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.943369]  [<ffffffff8104b16e>] ? manage_workers.isra.33+0x1ee/0x220
[  522.943469]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.943565]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.943663]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.943762]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.943857]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.943955]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.944055]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.944151] scsi_eh_0       S 0000000000000000     0   801      2 0x00000000
[  522.944322]  ffff880222e15e30 0000000000000046 0000000000000000
ffff880222e15fd8
[  522.944612]  ffff880222e15fd8 0000000000004000 ffff880224512d20
ffff880222cdad20
[  522.944902]  0000000000000007 0000000000000000 ffff880222e15db0
ffffffff81063550
[  522.945187] Call Trace:
[  522.945274]  [<ffffffff81063550>] ? idle_balance+0xe0/0x130
[  522.945368]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  522.945461]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.945556]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.945648]  [<ffffffff813ed68f>] scsi_error_handler+0x5f/0x6a0
[  522.945742]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.945837]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.945932]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.946025]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.946119]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.946216]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.946307] mpt_poll_1      S ffff880222e6f438     0   877      2 0x00000000
[  522.946474]  ffff88022402be40 0000000000000046 ffff88022fc10f60
ffff88022402bfd8
[  522.946757]  ffff88022402bfd8 0000000000004000 ffff880224512d20
ffff880222cdc3b0
[  522.947044]  ffff88022402bd90 ffffffff8105f61c ffff880222cdc3f8
ffff88022fdd0f60
[  522.947335] Call Trace:
[  522.947428]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.947526]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.947625]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.947723]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.947821]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.947914]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.948009]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.948106]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.948203]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.948301]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.948401]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.948497] mpt/1           S ffff880222e6f4f8     0   878      2 0x00000000
[  522.948668]  ffff880222851e40 0000000000000046 ffff88022fc10f60
ffff880222851fd8
[  522.948960]  ffff880222851fd8 0000000000004000 ffff880224512d20
ffff880222cdda40
[  522.949252]  ffff880222851d90 ffffffff8105f61c ffff880222cdda88
ffff88022fdd0f60
[  522.949541] Call Trace:
[  522.949631]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.949727]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
 ffff8802228ebdb0 ffffffff81063550
[  522.951740] Call Trace:
[  522.951831]  [<ffffffff81063550>] ? idle_balance+0xe0/0x130
[  522.951930]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  522.952027]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.952125]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.952218]  [<ffffffff813ed68f>] scsi_error_handler+0x5f/0x6a0
[  522.952315]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.952410]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.952506]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.952599]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.952697]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.952796]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.952891] kpsmoused       S ffff880222d40678     0   959      2 0x00000000
[  522.953062]  ffff880222a75e40 0000000000000046 ffff88022fcd0f60
ffff880222a75fd8
[  522.953352]  ffff880222a75fd8 0000000000004000 ffff880224512d20
ffff880222a61690
[  522.953640]  ffff880222a75d90 ffffffff8105f61c ffff880222a616d8
ffff88022fdd0f60
[  522.954933] Call Trace:
[  522.955020]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.955114]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.955209]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.955304]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.955398]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.955491]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.955585]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.955682]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.955776]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.955873]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.955974]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.956066] kworker/3:2     S ffff880222a62d20     0   961      2 0x00000000
[  522.956235]  ffff880222a81e60 0000000000000046 0000000000000004
ffff880222a81fd8
[  522.956527]  ffff880222a81fd8 0000000000004000 ffff8802245043b0
ffff880222a62d20
[  522.956815]  ffff880222a81d90 ffffffff810a6b92 ffff880222a81dc0
ffffffff8130ba3e
[  522.957100] Call Trace:
[  522.957189]  [<ffffffff810a6b92>] ? call_rcu_sched+0x12/0x20
[  522.957286]  [<ffffffff8130ba3e>] ? ioc_destroy_icq+0xbe/0xe0
[  522.957383]  [<ffffffff810f0005>] ? kmem_cache_free+0x15/0x90
[  522.957481]  [<ffffffff8130bae4>] ? ioc_release_fn+0x84/0xc0
[  522.957578]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.957676]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.957771]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.957867]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.957965]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.958059]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.958158]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.958259]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.958355] deferwq         S ffff880222d4f678     0  1004      2 0x00000000
[  522.958525]  ffff880222f89e40 0000000000000046 ffff88022fcd0f60
ffff880222f89fd8
[  522.958819]  ffff880222f89fd8 0000000000004000 ffff880224512d20
ffff880222a643b0
[  522.959108]  ffff880222f89d90 ffffffff8105f61c ffff880222a643f8
ffff88022fdd0f60
[  522.959398] Call Trace:
[  522.959485]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.959579]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.959673]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.959767]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.959861]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.959953]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.960048]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.960143]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.960236]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.960331]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.960427]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.960519] ata_sff         S ffff880224793378     0  1753      2 0x00000000
[  522.960686]  ffff88022269de40 0000000000000046 ffff88022fc10f60
ffff88022269dfd8
[  522.960969]  ffff88022269dfd8 0000000000004000 ffff880224505a40
ffff8802224f9690
[  522.961257]  ffff88022269dd90 ffffffff8105f61c ffff8802224f96d8
ffff88022fd10f60
[  522.961548] Call Trace:
[  522.961640]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.961739]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.961838]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.961935]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.962033]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.962129]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.962223]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.962320]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.962415]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.962512]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.962612]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.962706] scsi_eh_2       S 0000000000000000     0  2161      2 0x00000000
[  522.962877]  ffff880222b63e30 0000000000000046 ffff880222b63d70
ffff880222b63fd8
[  522.963170]  ffff880222b63fd8 0000000000004000 ffffffff81a13440
ffff880222199690
[  522.963461]  0000000000000082 0000000000000003 0000000000000000
0000000000000082
[  522.963748] Call Trace:
[  522.963839]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.963948]  [<ffffffffa0012105>] ?
ata_scsi_port_error_handler+0x845/0x8f0 [libata]
[  522.964097]  [<ffffffff813e7878>] ? __scsi_iterate_devices+0x68/0xa0
[  522.964194]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.964290]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.964386]  [<ffffffff813ed68f>] scsi_error_handler+0x5f/0x6a0
[  522.964485]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.964584]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.964683]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.964779]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.964877]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.964978]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.965073] scsi_eh_3       S 0000000000000000     0  2164      2 0x00000000
[  522.965241]  ffff8802224ade30 0000000000000046 ffff8802224add70
ffff8802224adfd8
[  522.965530]  ffff8802224adfd8 0000000000004000 ffff880224502d20
ffff88022219ad20
[  522.965821]  0000000000000082 0000000000000003 0000000000000000
0000000000000082
[  522.966114] Call Trace:
[  522.966206]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.968168]  0000000000000082 0000000000000003 0000000000000000
0000000000000082
[  522.968452] Call Trace:
[  522.968542]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.968639]  [<ffffffffa0012105>] ?
ata_scsi_port_error_handler+0x845/0x8f0 [libata]
[  522.968791]  [<ffffffff813e7878>] ? __scsi_iterate_devices+0x68/0xa0
[  522.968890]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.968989]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.969085]  [<ffffffff813ed68f>] scsi_error_handler+0x5f/0x6a0
[  522.969183]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.969283]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.969379]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.969472]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.969567]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.969665]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.969759] scsi_eh_5       S 0000000000000000     0  2170      2 0x00000000
[  522.969926]  ffff8802226a5e30 0000000000000046 ffff8802226a5d70
ffff8802226a5fd8
[  522.970216]  ffff8802226a5fd8 0000000000004000 ffff880224501690
ffff880222fada40
[  522.970506]  0000000000000082 0000000000000003 0000000000000000
0000000000000082
[  522.970796] Call Trace:
[  522.970887]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.970987]  [<ffffffffa0012105>] ?
ata_scsi_port_error_handler+0x845/0x8f0 [libata]
[  522.971139]  [<ffffffff813e7878>] ? __scsi_iterate_devices+0x68/0xa0
[  522.971236]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.971334]  [<ffffffff815912e4>] schedule+0x24/0x70
 0000000000000003 0000000000000000 0000000000000082
[  522.973148] Call Trace:
[  522.973240]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.973340]  [<ffffffffa0012105>] ?
ata_scsi_port_error_handler+0x845/0x8f0 [libata]
[  522.973492]  [<ffffffff813e7878>] ? __scsi_iterate_devices+0x68/0xa0
[  522.973590]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.973688]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.973781]  [<ffffffff813ed68f>] scsi_error_handler+0x5f/0x6a0
[  522.973875]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.973972]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.974066]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.974159]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.974254]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.974350]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.974442] scsi_eh_7       S 0000000000000000     0  2176      2 0x00000000
[  522.974609]  ffff880222787e30 0000000000000046 ffff880222787d70
ffff880222787fd8
[  522.974892]  ffff880222787fd8 0000000000004000 ffff8802245043b0
ffff880222fac3b0
[  522.976187]  0000000000000082 0000000000000003 0000000000000000
0000000000000082
[  522.976471] Call Trace:
[  522.976560]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.976658]  [<ffffffffa0012105>] ?
ata_scsi_port_error_handler+0x845/0x8f0 [libata]
[  522.976808]  [<ffffffff813e7878>] ? __scsi_iterate_devices+0x68/0xa0
[  522.976906]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.977005]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.977100]  [<ffffffff813ed68f>] scsi_error_handler+0x5f/0x6a0
[  522.977197]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.977295]  [<ffffffff813ed630>] ? scsi_eh_get_sense+0x200/0x200
[  522.977395]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.977491]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.977586]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.977684]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.977777] kworker/u:2     S ffff880222faad20     0  2179      2 0x00000000
[  522.977944]  ffff880222065e60 0000000000000046 0000000000000246
ffff880222065fd8
[  522.978229]  ffff880222065fd8 0000000000004000 ffff880224501690
ffff880222faad20
[  522.978517]  ffff880222065e10 ffffffff81428f4e 0000000000000001
ffff8802220143b0
[  522.978806] Call Trace:
[  522.978897]  [<ffffffff81428f4e>] ? mpt_fault_reset_work+0x8e/0x450
[  522.978993]  [<ffffffff810f0155>] ? kfree+0x95/0xb0
[  522.979088]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  522.979186]  [<ffffffff8104b16e>] ? manage_workers.isra.33+0x1ee/0x220
[  522.979287]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.979383]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  522.979477]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.979572]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.979665]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.979764]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.979864]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.979960] kworker/u:5     R  running task        0  2182      2 0x00000008
[  522.980128]  ffff8802226557e8 ffff880222b2ac00 ffff88022253f620
0000000000000086
[  522.980414]  ffff88022253ffd8 0000000000000086 000000000000004f
ffff88022253f5f8
[  522.980699]  ffffffff8132a302 ffffffffffffffff ffffffff81b2f8c7
ffff88022253f6b0
[  522.980984] Call Trace:
[  522.981076]  [<ffffffff8132a302>] ? put_dec+0x72/0x90
[  522.981171]  [<ffffffff8132ae04>] ? number.isra.2+0x304/0x330
[  522.981272]  [<ffffffffa05507c7>] ? e1000_xmit_frame+0x9a7/0xdc0 [e1000e]
[  522.981373]  [<ffffffff813405c0>] ? map_single+0x60/0x60
[  522.981471]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  522.981570]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.981665]  [<ffffffff8105a245>] ? check_preempt_curr+0x75/0xa0
[  522.981761]  [<ffffffff8105a282>] ? ttwu_do_wakeup+0x12/0x90
[  522.981856]  [<ffffffff8105a501>] ? ttwu_do_activate.constprop.66+0x61/0x70
[  522.981953]  [<ffffffff8105cc5e>] ? try_to_wake_up+0x24e/0x2c0
[  522.982048]  [<ffffffff8105ccdd>] ? default_wake_function+0xd/0x10
[  522.982145]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.982240]  [<ffffffff8132a302>] ? put_dec+0x72/0x90
[  522.982336]  [<ffffffff8113660b>] ? ep_poll_callback+0x10b/0x150
[  522.982434]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  522.982532]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  522.982629]  [<ffffffff8131c817>] ? cfq_rb_erase+0x27/0x60
[  522.982727]  [<ffffffff8131c92b>] ? cfq_del_cfqq_rr+0xdb/0xf0
[  522.982825]  [<ffffffff8104a13c>] ? wait_on_work+0xbc/0x180
[  522.982923]  [<ffffffff8131f7fe>] ? cfq_dispatch_requests+0x91e/0xaa0
[  522.983022]  [<ffffffff8104bc26>] ? __cancel_work_timer+0x86/0x140
[  522.983121]  [<ffffffff813f22e7>] ? scsi_target_reap+0x77/0xf0
[  522.983217]  [<ffffffff813f4b19>] ? scsi_remove_target+0x1a9/0x1d0
[  522.983313]  [<ffffffff813fe895>] ? sas_rphy_remove+0x55/0x60
[  522.983407]  [<ffffffff813fe8b1>] ? sas_rphy_delete+0x11/0x20
[  522.983503]  [<ffffffff813fe8e5>] ? sas_port_delete+0x25/0x160
[  522.983599]  [<ffffffff81431183>] ? mptsas_del_end_device+0x183/0x270
[  522.983696]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  522.983795]  [<ffffffff8143562c>] ? mptsas_hotplug_work+0x1ec/0x920
[  522.983893]  [<ffffffff810f00d7>] ? kfree+0x17/0xb0
[  522.983990]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  522.984090]  [<ffffffff81436e00>] ? mptsas_firmware_event_work+0xba0/0xf80
[  522.984190]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  522.984289]  [<ffffffff81048af3>] ? cwq_activate_first_delayed+0x33/0xa0
[  522.984389]  [<ffffffff81436260>] ? mptsas_expander_add+0x140/0x140
[  522.984484]  [<ffffffff8104aaa2>] ? process_one_work+0x102/0x390
[  522.984580]  [<ffffffff8104b150>] ? manage_workers.isra.33+0x1d0/0x220
[  522.984677]  [<ffffffff8104b2fe>] ? worker_thread+0x15e/0x350
[  522.984772]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  522.984869]  [<ffffffff8104fefe>] ? kthread+0x8e/0xa0
[  522.984964]  [<ffffffff81599954>] ? kernel_thread_helper+0x4/0x10
[  522.985063]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.985164]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.985261] kworker/u:8     S ffff88022218c3b0     0  2363      2 0x00000000
[  522.985432]  ffff88022213fe60 0000000000000046 0000000000000000
ffff88022213ffd8
[  522.987461]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.987555] rpciod          S ffff8802211665b8     0  4209      2 0x00000000
[  522.987726]  ffff880221017e40 0000000000000046 ffff88022fd10f60
ffff880221017fd8
[  522.988020]  ffff880221017fd8 0000000000004000 ffff880224512d20
ffff88022122ad20
[  522.988303]  ffff880221017d90 ffffffff8105f61c ffff88022122ad68
ffff88022fdd0f60
[  522.988586] Call Trace:
[  522.988673]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.988767]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.988861]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.988954]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.989048]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.989141]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.989234]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.989330]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.989423]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.989518]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.989617]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.989713] nfsiod          S ffff8802220fd4f8     0  4263      2 0x00000000
[  522.989885]  ffff88022136de40 0000000000000046 ffff88022fd10f60
ffff88022136dfd8
[  522.990177]  ffff88022136dfd8 0000000000004000 ffff880224512d20
ffff880221e65a40
[  522.990462]  ffff88022136dd90 ffffffff8105f61c ffff880221e65a88
ffff88022fdd0f60
[  522.990746] Call Trace:
[  522.990834]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  522.990929]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  522.991025]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  522.991123]  [<ffffffff81059df7>] ? set_user_nice+0xd7/0x190
[  522.991219]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.991315]  [<ffffffff8104af5d>] rescuer_thread+0x1ed/0x210
[  522.991412]  [<ffffffff8104ad70>] ? process_scheduled_works+0x40/0x40
[  522.991511]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.991607]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.991704]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.991804]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.991899] md0_raid1       D ffff880221e61690     0  4853      2 0x00000000
[  522.992065]  ffff88022278dae0 0000000000000046 ffff88022278d9f0
ffff88022278dfd8
[  522.992351]  ffff88022278dfd8 0000000000004000 ffff8802244d43b0
ffff880221e61690
[  522.992641]  ffffffff81b2853c 000000000000001c ffff88022278da70
ffffffff8132beb0
[  522.992931] Call Trace:
[  522.993019]  [<ffffffff8132beb0>] ? sprintf+0x40/0x50
[  522.993116]  [<ffffffff8106167c>] ? dequeue_task_fair+0x1ec/0x2a0
[  522.993214]  [<ffffffff810334a1>] ? print_prefix+0xd1/0x120
[  522.993309]  [<ffffffff81033a3c>] ? msg_print_text+0xac/0x1a0
[  522.993403]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.993498]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  522.993596]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  522.993694]  [<ffffffff81591176>] wait_for_common+0xc6/0x160
[  522.993791]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  522.993889]  [<ffffffff810a6b80>] ? call_rcu_bh+0x20/0x20
[  522.993987]  [<ffffffff815912b8>] wait_for_completion+0x18/0x20
[  522.994085]  [<ffffffff8104d158>] wait_rcu_gp+0x48/0x50
[  522.994182]  [<ffffffff8104d160>] ? wait_rcu_gp+0x50/0x50
[  522.994278]  [<ffffffff810a5eb9>] synchronize_sched+0x29/0x30
[  522.994376]  [<ffffffff81476181>] raid1_remove_disk+0xe1/0x170
[  522.994472]  [<ffffffff81496bd7>] md_check_recovery+0x4b7/0x700
[  522.994568]  [<ffffffff81477175>] raid1d+0x35/0x1010
[  522.994662]  [<ffffffff815912e4>] ? schedule+0x24/0x70
[  522.994757]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  522.994855]  [<ffffffff814908ee>] md_thread+0x10e/0x140
[  522.994951]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  522.995050]  [<ffffffff814907e0>] ? md_register_thread+0x100/0x100
[  522.995150]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.995248]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.995347]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.995449]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  522.995543] md1_raid6       D ffff880222550000     0  4873      2 0x00000000
[  522.995713]  ffff880220fa5b20 0000000000000046 0000000000000000
ffff880220fa5fd8
[  522.997015]  ffff880220fa5fd8 0000000000004000 ffffffff81a13440
ffff880222550000
[  522.997300]  ffffffff81b2876c 0000000000000017 ffff880220fa5ab0
ffffffff8132beb0
[  522.997589] Call Trace:
[  522.997678]  [<ffffffff8132beb0>] ? sprintf+0x40/0x50
[  522.997774]  [<ffffffff8106167c>] ? dequeue_task_fair+0x1ec/0x2a0
[  522.997871]  [<ffffffff810334a1>] ? print_prefix+0xd1/0x120
[  522.997967]  [<ffffffff81033a3c>] ? msg_print_text+0xac/0x1a0
[  522.998063]  [<ffffffff815912e4>] schedule+0x24/0x70
[  522.998159]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  522.998255]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  522.998351]  [<ffffffff81591176>] wait_for_common+0xc6/0x160
[  522.998448]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  522.998546]  [<ffffffff810a6b80>] ? call_rcu_bh+0x20/0x20
[  522.998644]  [<ffffffff815912b8>] wait_for_completion+0x18/0x20
[  522.998738]  [<ffffffff8104d158>] wait_rcu_gp+0x48/0x50
[  522.998833]  [<ffffffff8104d160>] ? wait_rcu_gp+0x50/0x50
[  522.998927]  [<ffffffff810a5eb9>] synchronize_sched+0x29/0x30
[  522.999025]  [<ffffffff81483c58>] raid5_remove_disk+0x118/0x190
[  522.999123]  [<ffffffff81496bd7>] md_check_recovery+0x4b7/0x700
[  522.999220]  [<ffffffff8148b2ea>] raid5d+0x2a/0x5f0
[  522.999316]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  522.999414]  [<ffffffff814908ee>] md_thread+0x10e/0x140
[  522.999510]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  522.999610]  [<ffffffff814907e0>] ? md_register_thread+0x100/0x100
[  522.999707]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  522.999801]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  522.999897]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  522.999998]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.000093] btrfs-worker-1  S ffff880220193e98     0  4883      2 0x00000000
[  523.000262]  ffff880220193d90 0000000000000046 ffff8802268049e0
ffff880220193fd8
[  523.000551]  ffff880220193fd8 0000000000004000 ffff880224501690
ffff880221d5ad20
[  523.000841]  ffff8802268049e0 ffff880220193ce8 0000000000000002
ffff880222746900
[  523.001126] Call Trace:
[  523.001217]  [<ffffffff811285fa>] ? bio_alloc_bioset+0xaa/0xf0
[  523.001311]  [<ffffffff812adcf3>] ? schedule_bio.isra.54+0x53/0x110
[  523.001407]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.001503]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.001599]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.001693]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.001789]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.001889]  [<ffffffff812b5483>] worker_loop+0x493/0x530
 ffff880220195fd8
[  523.003758]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.003854]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.003952]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.004047]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.004144]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.004242]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.004340]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.004437]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.004536]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.004632]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.004731]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.004832]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.004927] btrfs-submit-1  S ffff880220197e98     0  4885      2 0x00000000
[  523.005096]  ffff880220197d90 0000000000000046 ffff880220197c90
ffff880220197fd8
[  523.005387]  ffff880220197fd8 0000000000004000 ffffffff81a13440
ffff880221d5da40
[  523.005672]  ffff880220197d20 ffffffff81308eff 7302000800000000
0079746972756365
[  523.005957] Call Trace:
[  523.006046]  [<ffffffff81308eff>] ? blk_flush_plug_list+0x9f/0x210
[  523.006142]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.006242]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.006342]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.006439]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.006537]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.006634]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.006730]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.006826]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.006921]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.007013]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.007109]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.007206]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.007299] btrfs-delalloc- S ffff8802201a1e98     0  4886      2 0x00000000
[  523.007466]  ffff8802201a1d90 0000000000000046 ffff8802201a1d7c
ffff8802201a1fd8
[  523.007759]  ffff8802201a1fd8 0000000000004000 ffff880224505a40
ffff880221d58000
[  523.008053]  ffff88022fd0d6f0 0000000000000000 0000000000000000
0000000000000000
[  523.008344] Call Trace:
[  523.008434]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.008531]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.008628]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.008723]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.008820]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.008919]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.009015]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.009114]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.009212]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.009308]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.009406]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.009507]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.009602] btrfs-fixup-1   S ffff8802201a3e98     0  4887      2 0x00000000
[  523.009774]  ffff8802201a3d90 0000000000000046 ffff8802201a3d7c
ffff8802201a3fd8
[  523.010064]  ffff8802201a3fd8 0000000000004000 ffff880224512d20
ffff8802218f8000
[  523.010355]  ffff88022fdcd6f0 20275e272065736f 27206f7400000000
6f706d6f630a27be
[  523.010646] Call Trace:
[  523.010738]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.010837]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.010937]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.011033]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.011129]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.011228]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.011323]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.011417]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.011514]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.011610]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.011708]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.011809]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.011905] btrfs-endio-1   S ffff8802201a5e98     0  4888      2 0x00000000
[  523.012075]  ffff8802201a5d90 0000000000000046 ffff880226802240
ffff8802201a5fd8
[  523.012367]  ffff8802201a5fd8 0000000000004000 ffffffff81a13440
ffff8802218f9690
[  523.012658]  ffff88022470cf00 ffff880222655540 ffff8802201a5cd0
ffffffff810bbb12
[  523.012945] Call Trace:
[  523.013033]  [<ffffffff810bbb12>] ? mempool_free_slab+0x12/0x20
[  523.013128]  [<ffffffff810bbb9f>] ? mempool_free+0x4f/0xa0
[  523.013225]  [<ffffffff81128418>] ? bio_free+0x48/0x50
[  523.013319]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.013417]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.013517]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.013613]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.013711]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.013810]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.013907]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.014006]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.014101]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.014197]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.014294]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.014387] btrfs-endio-met S ffff8802201a7e98     0  4889      2 0x00000000
[  523.014555]  ffff8802201a7d90 0000000000000046 ffff880226802240
ffff8802201a7fd8
[  523.014844]  ffff8802201a7fd8 0000000000004000 ffffffff81a13440
ffff8802218fad20
[  523.015134]  ffff88022470cf00 ffff8802221c4000 ffff8802201a7cd0
ffffffff810bbb12
[  523.015425] Call Trace:
[  523.015517]  [<ffffffff810bbb12>] ? mempool_free_slab+0x12/0x20
[  523.015616]  [<ffffffff810bbb9f>] ? mempool_free+0x4f/0xa0
[  523.015714]  [<ffffffff81128418>] ? bio_free+0x48/0x50
[  523.015810]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.015909]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.016006]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.016100]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.016194]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.016292]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.016390]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.016489]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.016581]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.016676]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.016773]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.016864] btrfs-endio-met S[  523.018582]  0000000000000000
0000000000000000[  523.019628]  [<ffffffff81057d58>] ?
__wake_up_common+0x58/0x90
[  523.019724]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.019820]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.019915]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.020014]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.020114]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.020208] btrfs-endio-wri S ffff8802201abe98     0  4891      2 0x00000000
[  523.020375]  ffff8802201abd90 0000000000000046 ffff8802201abca0
ffff8802201abfd8
[  523.020661]  ffff8802201abfd8 0000000000004000 ffff880224512d20
ffff8802218fc3b0
[  523.020947]  ffff8802201abd00 ffffffff812a534b ffff8802201abce0
ffffffff810f0005
[  523.021233] Call Trace:
[  523.021322]  [<ffffffff812a534b>] ? clear_state_bit+0xcb/0x170
[  523.021417]  [<ffffffff810f0005>] ? kmem_cache_free+0x15/0x90
[  523.021513]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.021610]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.021706]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.021803]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.021901]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.022002]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.022098]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.022194]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.022289]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.022386]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.022483]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.022576] btrfs-freespace S ffff8802201ade98     0  4892      2 0x00000000
[  523.022744]  ffff8802201add90 0000000000000046 0000000000000000
ffff8802201adfd8
[  523.023031]  ffff8802201adfd8 0000000000004000 ffff880224512d20
ffff8802227943b0
[  523.023322]  ffff8802201adcd0 ffffffff810506d1 ffff8802201adce0
ffff880223762140
[  523.023614] Call Trace:
[  523.023707]  [<ffffffff810506d1>] ? autoremove_wake_function+0x11/0x40
[  523.023807]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.023905]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.024002]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.024098]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.024191]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.024288]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.024386]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.024483]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.024580]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.024681]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.024777]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.024876]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.024976]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.025072] btrfs-delayed-m S ffff8802201afe98     0  4893      2 0x00000000
[  523.025242]  ffff8802201afd90 0000000000000046 742e0a5d6e7e5b5c
ffff8802201affd8
[  523.025534]  ffff8802201affd8 0000000000004000 ffff8802245043b0
ffff880222795a40
[  523.025827]  206e6972742e0a5d 3432726168635b5c 0a5d6f5e5b5c5d34
5b5c206e6972742e
[  523.026118] Call Trace:
[  523.026209]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  523.026308]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.026407]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.026506]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.026602]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.026699]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.026797]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.026891]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.026985]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.027081]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.027178]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.027277]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.027377]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.027472] btrfs-cache-1   S ffff8802201b1e98     0  4894      2 0x00000000
[  523.027644]  ffff8802201b1d90 0000000000000046 ffff88021d90e2a0
ffff8802201b1fd8
[  523.027936]  ffff8802201b1fd8 0000000000004000 ffff880224512d20
ffff880222792d20
[  523.028227]  ffff8802201b1d20 ffffffff812a5b1d 0000000000000010
ffff88021d90e2a0
[  523.028515] Call Trace:
[  523.028603]  [<ffffffff812a5b1d>] ? clear_extent_bit+0x20d/0x370
[  523.028699]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.028797]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.028895]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.028990]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.029089]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.029190]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.029287]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.029387]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.029486]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.029582]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.029679]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.029776]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.029869] btrfs-readahead S ffff8802201b3e98     0  4895      2 0x00000000
[  523.030037]  ffff8802201b3d90 0000000000000046 1b5e461e1b5e461d
ffff8802201b3fd8
[  523.030323]  ffff8802201b3fd8 0000000000004000 ffff8802245043b0
ffff880222790000
[  523.030612]  1b5e462a1b5e4629 1b5e462c1b5e462b 1b5e462e1b5e462d
1b5e46301b5e462f
[  523.030899] Call Trace:
[  523.030987]  [<ffffffff8105f61c>] ? update_curr+0xec/0x140
[  523.031080]  [<ffffffff81040093>] ? lock_timer_base.isra.34+0x33/0x70
[  523.031175]  [<ffffffff8104013d>] ? try_to_del_timer_sync+0x6d/0xa0
[  523.031270]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.031362]  [<ffffffff8158f73d>] schedule_timeout+0x12d/0x1e0
[  523.031456]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.031552]  [<ffffffff812b5483>] worker_loop+0x493/0x530
[  523.031645]  [<ffffffff81057d58>] ? __wake_up_common+0x58/0x90
[  523.031739]  [<ffffffff812b4ff0>] ? btrfs_queue_worker+0x300/0x300
[  523.031834]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.031926]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.032021]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.032117]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.032209] btrfs-cleaner   S 0000000000000000     0  4896      2 0x00000000
[  523.032376]  ffff88021f767e70 0000000000000046 ffff88021f767db0
ffff88021f767fd8
[  523.032666]  ffff88021f767fd8 0000000000004000 ffffffff81a13440
ffff880222791690
[  523.032956]  ffff88021f767dd0 ffffffff8105896e ffff880220d09a00
0000000000000000
[  523.033249] Call Trace:
[  523.033342]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  523.033440]  [<ffffffff81294edb>] ? btrfs_run_defrag_inodes+0x20b/0x220
[  523.033540]  [<ffffffff812869f1>] ? btrfs_clean_old_snapshots+0x31/0x140
[  523.033641]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.033737]  [<ffffffff8127e16d>] cleaner_kthread+0x18d/0x1c0
[  523.033834]  [<ffffffff8127dfe0>] ? btrfs_alloc_root+0x40/0x40
[  523.033932]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.034028]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.034124]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.034221]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.034313] btrfs-transacti D ffff88022282e400     0  4897      2 0x00000000
[  523.034482]  ffff88021f769660 0000000000000046 ffff88021f769598
ffff88021f769fd8
[  523.034773]  ffff88021f769fd8 0000000000004000 ffff8802245043b0
ffff88022122c3b0
[  523.035065]  0000000000000000 0000000000000000 ffffea000878cd80
ffffea00087549c0
[  523.035356] Call Trace:
[  523.035447]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.035544]  [<ffffffff814950d5>] md_write_start+0xb5/0x1a0
[  523.035640]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  523.036519]  [<ffffffff8130740f>] generic_make_request+0xbf/0x100
[  523.036618]  [<ffffffff813074c3>] submit_bio+0x73/0xf0
[  523.037884]  [<ffffffff810c2fbb>] do_writepages+0x1b/0x30
[  523.037981]  [<ffffffff810ba3e1>] __filemap_fdatawrite_range+0x51/0x60
[  523.038080]  [<ffffffff810bb32e>] filemap_fdatawrite_range+0xe/0x10
[  523.039191]  [<ffffffff812a3909>] btrfs_wait_ordered_range+0x49/0x120
[  523.039291]  [<ffffffff812c2d7b>] __btrfs_write_out_cache+0x84b/0xa40
[  523.039391]  [<ffffffff812bb916>] ? btrfs_set_lock_blocking_rw+0x86/0xf0
[  523.039491]  [<ffffffff812c3021>] btrfs_write_out_cache+0xb1/0xf0
[  523.039589]  [<ffffffff812a9a92>] ? free_extent_buffer+0x32/0x90
[  523.039688]  [<ffffffff812751e1>] btrfs_write_dirty_block_groups+0x4d1/0x5b0
[  523.039788]  [<ffffffff8158c44f>] commit_cowonly_roots+0x10d/0x1de
[  523.039886]  [<ffffffff81285b52>] btrfs_commit_transaction+0x5c2/0xa00
[  523.039982]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  523.040078]  [<ffffffff8128641b>] ? start_transaction+0x8b/0x2a0
[  523.040174]  [<ffffffff8127e3dd>] transaction_kthread+0x23d/0x2b0
[  523.040268]  [<ffffffff8127e1a0>] ? cleaner_kthread+0x1c0/0x1c0
[  523.040363]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.040457]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.040552]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.040650]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.040742] systemd-udevd   S 0000000000000000     0  5022      1 0x00000000
[  523.040912]  ffff88021f785d88 0000000000000086 0000000000000000
ffff88021f785fd8
[  523.041200]  ffff88021f785fd8 0000000000004000 ffff880224501690
ffff8802211f43b0
[  523.041490]  ffff88021f785cd8 ffffffff81110690 ffff88021f785d08
ffff88021f785d28
[  523.041782] Call Trace:
[  523.041873]  [<ffffffff81110690>] ? d_lookup+0x30/0x50
[  523.041967]  [<ffffffff811106f8>] ? d_hash_and_lookup+0x48/0x50
[  523.042063]  [<ffffffff81158bcd>] ? proc_flush_task+0xdd/0x1c0
[  523.042158]  [<ffffffff810f0005>] ? kmem_cache_free+0x15/0x90
[  523.042253]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.042347]  [<ffffffff81590235>] schedule_hrtimeout_range_clock+0x125/0x140
[  523.042445]  [<ffffffff811360e4>] ? ep_scan_ready_list.isra.11+0x1a4/0x1b0
[  523.042544]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.042641]  [<ffffffff81136471>] ep_poll+0x361/0x3f0
[  523.042739]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.042838]  [<ffffffff811371fd>] sys_epoll_wait+0xbd/0xd0
[  523.042938]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.043037] kworker/5:4     S ffff8802213f2d20     0  5048      2 0x00000000
[  523.043207]  ffff880221e83e60 0000000000000046 ffff880221e83d90
ffff880221e83fd8
[  523.043497]  ffff880221e83fd8 0000000000004000 ffff880222a30000
ffff8802213f2d20
[  523.043782]  ffff880226802180 ffff880223f30840 ffff8802228341d0
ffff880222ed9020
[  523.044071] Call Trace:
[  523.044161]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  523.044257]  [<ffffffff8130bae4>] ? ioc_release_fn+0x84/0xc0
[  523.044355]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  523.044455]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.044552]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  523.044650]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  523.044749]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.044845]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.044944]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.045044]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.045135] kworker/5:9     S ffff880222a30000     0  5053      2 0x00000000
[  523.045301]  ffff880222ae3e60 0000000000000046 ffff880222ae3d90
ffff880222ae3fd8
[  523.045584]  ffff880222ae3fd8 0000000000004000 ffff880224510000
ffff880222a30000
[  523.045865]  ffff88022fd4e220 00000001000106d9 ffff880222ae3da0
ffffffff81040613
[  523.046149] Call Trace:
[  523.046237]  [<ffffffff81040613>] ? add_timer+0x13/0x20
[  523.046330]  [<ffffffff81049d9e>] ? queue_delayed_work_on+0xae/0x130
[  523.046426]  [<ffffffff810cef70>] ? refresh_cpu_vm_stats+0x100/0x100
 ffff88022120da40
[  523.048333]  ffff880226802180 ffff880221db3a20 ffff880222ff41d0
ffff88022181dcd0
[  523.048621] Call Trace:
[  523.048712]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  523.048810]  [<ffffffff8130bae4>] ? ioc_release_fn+0x84/0xc0
[  523.048908]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  523.049006]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.049103]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  523.049202]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  523.049299]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.049392]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.049487]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.049586]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.049678] kworker/2:2     S ffff880223190000     0  5102      2 0x00000000
[  523.049846]  ffff880221871e60 0000000000000046 ffff880221871d60
ffff880221871fd8
[  523.050134]  ffff880221871fd8 0000000000004000 ffff880224502d20
ffff880223190000
[  523.050426]  ffff880226802180 ffff8802232f1a20 ffff880224078000
ffff880221ecdd40
[  523.050713] Call Trace:
[  523.050804]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  523.050902]  [<ffffffff8130bae4>] ? ioc_release_fn+0x84/0xc0
[  523.050999]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  523.051098]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.051192]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  523.051286]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  523.051383]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.051477]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.051577]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.051678]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.051774] kworker/6:2     S ffff88022317da40     0  5106      2 0x00000000
[  523.051941]  ffff880223f67e60 0000000000000046 0000000000000004
ffff880223f67fd8
[  523.052226]  ffff880223f67fd8 0000000000004000 ffff880224511690
ffff88022317da40
[  523.052510]  ffff88022fd90f00 0000000000000000 0000000000010f00
0000000000000000
[  523.052797] Call Trace:
[  523.052890]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  523.052988]  [<ffffffff8105cc5e>] ? try_to_wake_up+0x24e/0x2c0
[  523.053087]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.053184]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  523.053283]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  523.053383]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.053481]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.053579]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.053679]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.053772] kworker/1:2     S ffff8802232e0000     0  5108      2 0x00000000
[  523.053941]  ffff8802232e9e60 0000000000000046 0000000000000006
ffff8802232e9fd8
[  523.054226]  ffff8802232e9fd8 0000000000004000 ffff880224501690
ffff8802232e0000
[  523.054513]  ffff880226802180 ffff880222ee7d80 ffff880222ff6db0
ffff880223522db0
[  523.054805] Call Trace:
[  523.054896]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  523.054994]  [<ffffffff8130bae4>] ? ioc_release_fn+0x84/0xc0
[  523.055092]  [<ffffffff8104ab1a>] ? process_one_work+0x17a/0x390
[  523.055191]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.055287]  [<ffffffff8104b3d3>] worker_thread+0x233/0x350
[  523.055381]  [<ffffffff8104b1a0>] ? manage_workers.isra.33+0x220/0x220
[  523.055478]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.055572]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.055669]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.055767]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.055862] kvm-irqfd-clean S ffff8802228f87f8     0  5131      2 0x00000000
[  523.056033]  ffff88021dd2be40 0000000000000046 ffff88022fd50f60
ffff88021dd2bfd8
[  523.056326]  ffff88021dd2bfd8 0000000000004000[  523.058525]
ffff88021f7f5fd8 0000000000004000 ffff8802245043b0 ffff880221391690
[  523.058813]  ffff88021f7f5d38 ffffffff8111217f 0000000000000001
0000000000000000
[  523.059104] Call Trace:
[  523.059195]  [<ffffffff8111217f>] ? file_update_time+0x9f/0xf0
[  523.059293]  [<ffffffff811028dc>] ? pipe_write+0x2fc/0x5a0
[  523.059387]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.059479]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.059573]  [<ffffffff810f97fa>] ? do_sync_write+0xda/0x120
[  523.059667]  [<ffffffff8104108a>] ? recalc_sigpending+0x1a/0x50
[  523.060735]  [<ffffffff8104142a>] ? dequeue_signal+0xca/0x170
[  523.060828]  [<ffffffff8158f849>] schedule_timeout_interruptible+0x19/0x20
[  523.060929]  [<ffffffff810444fa>] do_sigtimedwait+0x11a/0x180
[  523.061028]  [<ffffffff810445e3>] sys_rt_sigtimedwait+0x83/0xe0
[  523.061125]  [<ffffffff8111604f>] ? mntput+0x1f/0x30
[  523.061220]  [<ffffffff810fb6a9>] ? fput+0x1a9/0x250
[  523.061314]  [<ffffffff810f80a1>] ? filp_close+0x61/0x90
[  523.061411]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.061506] automount       S ffff880222169690     0  5574      1 0x00000000
[  523.061676]  ffff8802232a7c18 0000000000000082 ffff8802232a7cb0
ffff8802232a7fd8
[  523.061962]  ffff8802232a7fd8 0000000000004000 ffff880224511690
ffff880222169690
[  523.062248]  ffff8802232a7d28 ffff88022fd8d5d0 000000000000d540
000000000000c350
[  523.062532] Call Trace:
[  523.062620]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  523.062717]  [<ffffffff81053772>] ? enqueue_hrtimer+0x22/0x50
[  523.062814]  [<ffffffff81053f70>] ? __hrtimer_start_range_ns+0x120/0x300
[  523.062915]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.063010]  [<ffffffff8107c0ee>] futex_wait_queue_me+0xbe/0x100
[  523.063109]  [<ffffffff8107cb7c>] futex_wait+0x17c/0x270
[  523.063205]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  523.063303]  [<ffffffff81053860>] ? update_rmtp+0x70/0x70
[  523.063399]  [<ffffffff8105417f>] ? hrtimer_start_range_ns+0xf/0x20
[  523.063497]  [<ffffffff8107e934>] do_futex+0x344/0xad0
[  523.063593]  [<ffffffff8107f1c5>] sys_futex+0x105/0x1a0
[  523.063686]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.063782] automount       S ffff88022216da40     0  5575      1 0x00000000
[  523.063950]  ffff88022264dc18 0000000000000082 ffff88022264dcb0
ffff88022264dfd8
[  523.064238]  ffff88022264dfd8 0000000000004000 ffff880224512d20
ffff88022216da40
[  523.064528]  0000000000000000 ffff88022264db48 ffff88022264dc28
ffffffff810bf853
[  523.064818] Call Trace:
[  523.064911]  [<ffffffff810bf853>] ? get_page_from_freelist+0x2e3/0x590
[  523.065010]  [<ffffffff8107c6be>] ? get_futex_key+0x7e/0x250
[  523.065108]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.065202]  [<ffffffff8107c0ee>] futex_wait_queue_me+0xbe/0x100
[  523.065298]  [<ffffffff8107cb7c>] futex_wait+0x17c/0x270
[  523.065393]  [<ffffffff810f4d6c>] ?
__mem_cgroup_commit_charge.constprop.57+0x14c/0x2b0
[  523.065543]  [<ffffffff8107cdb8>] ? futex_wake+0x108/0x130
[  523.065639]  [<ffffffff810f0965>] ? kmem_cache_alloc+0xb5/0xd0
[  523.065736]  [<ffffffff81321a56>] ? cpumask_next_and+0x36/0x50
[  523.065836]  [<ffffffff8106070d>] ? select_task_rq_fair+0x85d/0x990
[  523.065937]  [<ffffffff8107e934>] do_futex+0x344/0xad0
[  523.066034]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  523.066134]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  523.066234]  [<ffffffff81059b75>] ? enqueue_task+0x65/0x80
[  523.066332]  [<ffffffff8105a245>] ? check_preempt_curr+0x75/0xa0
[  523.066428]  [<ffffffff8105ce01>] ? wake_up_new_task+0xf1/0x130
[  523.066523]  [<ffffffff810325d9>] ? do_fork+0xf9/0x2e0
[  523.066617]  [<ffffffff8107f1c5>] sys_futex+0x105/0x1a0
[  523.066712]  [<ffffffff8100a543>] ? sys_clone+0x23/0x30
[  523.066806]  [<ffffffff81598973>] ? stub_clone+0x13/0x20
[  523.066902]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.066999] automount       S ffff880221ebde1c     0  5578      1 0x00000000
[  523.067170]  ffff880221ebda48 0000000000000082 0000000000000000
ffff880221ebdfd8
[  523.067461]  ffff880221ebdfd8 0000000000004000 ffff880224502d20[
523.069870]  [<ffffffff8105cc5e>] ? try_to_wake_up+0x24e/0x2c0
[  523.069968]  [<ffffffff8105cd0b>] ? wake_up_state+0xb/0x10
[  523.070065]  [<ffffffff8107c1c6>] ? wake_futex+0x36/0x60
[  523.070162]  [<ffffffff8107ed64>] ? do_futex+0x774/0xad0
[  523.070257]  [<ffffffff8107f1c5>] ? sys_futex+0x105/0x1a0
[  523.070353]  [<ffffffff8110ce46>] sys_poll+0x66/0x100
[  523.070448]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.070543] syslog-ng       S ffff880221258000     0  5595      1 0x00000000
[  523.070710]  ffff8802230efe58 0000000000000082 ffff8802230efde8
ffff8802230effd8
[  523.070998]  ffff8802230effd8 0000000000004000 ffff880224502d20
ffff880221258000
[  523.071287]  ffff8802228cf3c0 ffff8802230efe48 ffff8802230eff28
ffff880224669000
[  523.071579] Call Trace:
[  523.071672]  [<ffffffff81108896>] ? path_openat+0x106/0x400
[  523.071769]  [<ffffffff810d7838>] ? handle_mm_fault+0x148/0x210
[  523.071868]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.071965]  [<ffffffff81037ba4>] do_wait+0x1d4/0x200
[  523.072060]  [<ffffffff810390cb>] sys_wait4+0x9b/0xf0
[  523.072153]  [<ffffffff81036a10>] ? task_stopped_code+0x50/0x50
[  523.072248]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.072342] syslog-ng       S 0000000001c9c37f     0  5596   5595 0x00000000
[  523.072512]  ffff8802242cbd88 0000000000000086 ffff880200000003
ffff8802242cbfd8
[  523.072800]  ffff8802242cbfd8 0000000000004000 ffff8802245043b0
ffff880224585a40
[  523.073091]  ffff8802242cbdb0 ffff88022fccd590 000000000000d540
0000000001c9c37f
[  523.073383] Call Trace:
[  523.073474]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  523.073572]  [<ffffffff81053772>] ? enqueue_hrtimer+0x22/0x50
[  523.073667]  [<ffffffff81053f70>] ? __hrtimer_start_range_ns+0x120/0x300
[  523.073763]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.073856]  [<ffffffff8159020c>] schedule_hrtimeout_range_clock+0xfc/0x140
[  523.073953]  [<ffffffff81053860>] ? update_rmtp+0x70/0x70
[  523.074047]  [<ffffffff8105417f>] ? hrtimer_start_range_ns+0xf/0x20
[  523.074142]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.074238]  [<ffffffff81136471>] ep_poll+0x361/0x3f0
[  523.074330]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.074425]  [<ffffffff811371fd>] sys_epoll_wait+0xbd/0xd0
[  523.074519]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.074613] syslog-ng       D ffff880222db1920     0  5897   5595 0x00000000
[  523.074779]  ffff880220087a98 0000000000000086 ffff8802200879a8
ffff880220087fd8
[  523.075062]  ffff880220087fd8 0000000000004000 ffff880224510000
ffff88022216c3b0
[  523.075346]  ffff880220087b28 ffffffff81062175 0000000000000005
0000000000000000
[  523.075633] Call Trace:
[  523.075723]  [<ffffffff81062175>] ? find_busiest_group+0x165/0xb90
[  523.075823]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.075920]  [<ffffffff81284f6d>] wait_current_trans.isra.31+0x8d/0xf0
[  523.076020]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  523.076119]  [<ffffffff81286578>] start_transaction+0x1e8/0x2a0
[  523.076216]  [<ffffffff81286680>] btrfs_join_transaction+0x10/0x20
[  523.076315]  [<ffffffff81290f80>] btrfs_dirty_inode+0x50/0xd0
[  523.076412]  [<ffffffff81291215>] btrfs_update_time+0x55/0x90
[  523.076507]  [<ffffffff81039d31>] ? current_fs_time+0x11/0x50
[  523.076602]  [<ffffffff8111204e>] update_time+0x1e/0xb0
[  523.076696]  [<ffffffff8111549d>] ? mnt_clone_write+0xd/0x30
[  523.076792]  [<ffffffff81112174>] file_update_time+0x94/0xf0
[  523.076888]  [<ffffffff812954c8>] btrfs_file_aio_write+0x1b8/0x4b0
[  523.076986]  [<ffffffff81590b0c>] ? __schedule+0x40c/0x920
[  523.077085]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  523.077183]  [<ffffffff81329f14>] ? timerqueue_del+0x34/0x90
[  523.078321]  ffff8802210bb710[  523.079195] Call Trace:
[  523.079285]  [<ffffffff810b91bf>] ? find_get_pages_contig+0xdf/0x160
[  523.079383]  [<ffffffff810b9422>] ? unlock_page+0x22/0x30
[  523.079481]  [<ffffffff812a67cb>] ? extent_clear_unlock_delalloc+0x21b/0x240
[  523.079581]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.079676]  [<ffffffff81284f6d>] wait_current_trans.isra.31+0x8d/0xf0
[  523.079774]  [<ffffffff810506c0>] ? abort_exclusive_wait+0xb0/0xb0
[  523.079872]  [<ffffffff81286578>] start_transaction+0x1e8/0x2a0
[  523.079969]  [<ffffffff81286680>] btrfs_join_transaction+0x10/0x20
[  523.080068]  [<ffffffff8128c8b3>] cow_file_range+0x83/0x490
[  523.080167]  [<ffffffff812a434d>] ? next_state+0xd/0x30
[  523.080264]  [<ffffffff812a559f>] ? __set_extent_bit+0x15f/0x4d0
[  523.080362]  [<ffffffff8128d96c>] run_delalloc_range+0x34c/0x370
[  523.080460]  [<ffffffff812a89fd>] __extent_writepage+0x5ad/0x6f0
[  523.081559]  [<ffffffff812a7a40>] ? end_extent_writepage+0x70/0x70
[  523.081655]  [<ffffffff812a8dfa>]
extent_write_cache_pages.isra.37.constprop.51+0x2ba/0x410
[  523.081801]  [<ffffffff81059fe7>] ? walk_tg_tree_from+0x67/0xd0
[  523.081898]  [<ffffffff812a9181>] extent_writepages+0x41/0x60
[  523.081995]  [<ffffffff81289b30>] ? btrfs_writepage+0x70/0x70
[  523.082092]  [<ffffffff81288fc3>] btrfs_writepages+0x23/0x30
[  523.082189]  [<ffffffff810c2fbb>] do_writepages+0x1b/0x30
[  523.082286]  [<ffffffff8111cefa>] __writeback_single_inode.isra.28+0x3a/0x110
[  523.082386]  [<ffffffff8111d7bb>] writeback_sb_inodes+0x19b/0x350
[  523.082483]  [<ffffffff8111da06>] __writeback_inodes_wb+0x96/0xc0
[  523.082577]  [<ffffffff8111dbfb>] wb_writeback+0x1cb/0x1e0
[  523.082672]  [<ffffffff8111dca7>] wb_check_old_data_flush+0x97/0xa0
[  523.082769]  [<ffffffff8111e028>] wb_do_writeback+0xc8/0x140
[  523.082864]  [<ffffffff8103fd50>] ? init_timer_deferrable_key+0x20/0x20
[  523.082962]  [<ffffffff8111e112>] bdi_writeback_thread+0x72/0x140
[  523.083057]  [<ffffffff8111e0a0>] ? wb_do_writeback+0x140/0x140
[  523.083152]  [<ffffffff8104fefe>] kthread+0x8e/0xa0
[  523.083245]  [<ffffffff81599954>] kernel_thread_helper+0x4/0x10
[  523.083340]  [<ffffffff8104fe70>] ? kthread_freezable_should_stop+0x70/0x70
[  523.083440]  [<ffffffff81599950>] ? gs_change+0xb/0xb
[  523.083535] dhcpcd          S ffff880221cfde1c     0  5699      1 0x00000000
[  523.083706]  ffff880221cfda48 0000000000000082 ffff880226804578
ffff880221cfdfd8
[  523.083998]  ffff880221cfdfd8 0000000000004000 ffffffff81a13440
ffff880221932d20
[  523.084287]  ffff880221cfda70 ffff88022fc0d590 000000000000d540
0000000005f5e100
[  523.084571] Call Trace:
[  523.084660]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  523.084756]  [<ffffffff81053772>] ? enqueue_hrtimer+0x22/0x50
[  523.084853]  [<ffffffff81053f70>] ? __hrtimer_start_range_ns+0x120/0x300
[  523.084952]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.085049]  [<ffffffff8159020c>] schedule_hrtimeout_range_clock+0xfc/0x140
[  523.085148]  [<ffffffff81053860>] ? update_rmtp+0x70/0x70
[  523.085245]  [<ffffffff8105417f>] ? hrtimer_start_range_ns+0xf/0x20
[  523.085344]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.086021]  [<ffffffff8158f785>] ? schedule_timeout+0x175/0x1e0
[  523.086118]  [<ffffffff814cc3d2>] ? sock_sendmsg+0xe2/0x120
[  523.086216]  [<ffffffff81591181>] ? wait_for_common+0xd1/0x160
[  523.086315]  [<ffffffff810502d2>] ? bit_waitqueue+0x12/0xa0
[  523.087377] rpcbind         S ffff88022328fe24     0  5717      1 0x00000000
[  523.087547]  ffff88022328fa48 0000000000000086 ffff88022125ad20
ffff88022328ffd8
[  523.087841]  ffff88022328ffd8 0000000000004000 ffff8802245043b0
ffff88022125ad20
[  523.088124]  ffff88022328fa70 ffff88022fccd590 000000000000d540
0000000001c9c37f
[  523.088407] Call Trace:
[  523.088494]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  523.088588]  [<ffffffff81053772>] ? enqueue_hrtimer+0x22/0x50
[  523.088682]  [<ffffffff81053f70>] ? __hrtimer_start_range_ns+0x120/0x300
[  523.088778]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.088870]  [<ffffffff8159020c>] schedule_hrtimeout_range_clock+0xfc/0x140
[  523.088967]  [<ffffffff81053860>] ? update_rmtp+0x70/0x70
[  523.089060]  [<ffffffff8105417f>] ? hrtimer_start_range_ns+0xf/0x20
[  523.089155]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.089250]  [<ffffffff8110b824>] poll_schedule_timeout+0x44/0x60
[  523.089345]  [<ffffffff8110cc1f>] do_sys_poll+0x35f/0x4c0
[  523.089443]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.089540]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.089636]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.089729]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.089824]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.089919]  [<ffffffff814cceb2>] ? sock_aio_read.part.25+0x122/0x160
[  523.090017]  [<ffffffff810502d2>] ? bit_waitqueue+0x12/0xa0
[  523.090114]  [<ffffffff810f0005>] ? kmem_cache_free+0x15/0x90
[  523.090210]  [<ffffffff814ca71e>] ? sock_destroy_inode+0x2e/0x40
[  523.090309]  [<ffffffff8110e526>] ? __d_free+0x46/0x70
[  523.090406]  [<ffffffff8110ed55>] ? d_free+0x55/0x60
[  523.090502]  [<ffffffff8110ee35>] ? d_kill+0xd5/0x130
[  523.090597]  [<ffffffff81115f21>] ? mntput_no_expire+0x41/0x150
[  523.090694]  [<ffffffff81074388>] ? ktime_get_ts+0xa8/0xe0
[  523.090792]  [<ffffffff8110bbfa>] ? poll_select_set_timeout+0x7a/0x90
[  523.090891]  [<ffffffff8110ce46>] sys_poll+0x66/0x100
[  523.090987]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.091084] rpc.statd       S ffff8802230fd300     0  5734      1 0x00000000
[  523.091254]  ffff8802236938f8 0000000000000086 ffff8802236938d8
ffff880223693fd8
[  523.091543]  ffff880223693fd8 0000000000004000 ffff8802245043b0
ffff8802211f2d20
[  523.091834]  ffff880200000041 0000000000010f00 0000000000000000
0000000000000000
[  523.092124] Call Trace:
[  523.092214]  [<ffffffff810bfc79>] ? __alloc_pages_nodemask+0x179/0x750
[  523.092313]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.092409]  [<ffffffff81590235>] schedule_hrtimeout_range_clock+0x125/0x140
[  523.092508]  [<ffffffff810505f8>] ? add_wait_queue+0x48/0x60
[  523.092603]  [<ffffffff810505f8>] ? add_wait_queue+0x48/0x60
[  523.092698]  [<ffffffff8110b980>] ? __pollwait+0x70/0xf0
[  523.092793]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.092893]  [<ffffffff8110b824>] poll_schedule_timeout+0x44/0x60
[  523.092990]  [<ffffffff8110c179>] do_select+0x569/0x680
[  523.093087]  [<ffffffff81053d34>] ? hrtimer_try_to_cancel+0x44/0x90
[  523.094443]  [<ffffffff81595834>] ? do_page_fault+0x1c4/0x4b0
[  523.094541]  [<ffffffff81115f21>] ? mntput_no_expire+0x41/0x150

[  523.095577]  0000000000000041 0000000000000000 0000000000000000
0000000000000000
[  523.095865] Call Trace:
[  523.095957]  [<ffffffff81321a56>] ? cpumask_next_and+0x36/0x50
[  523.096055]  [<ffffffff81321a56>] ? cpumask_next_and+0x36/0x50
[  523.096154]  [<ffffffff81062175>] ? find_busiest_group+0x165/0xb90
[  523.096253]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.096349]  [<ffffffff81590235>] schedule_hrtimeout_range_clock+0x125/0x140
[  523.096450]  [<ffffffff812a50ca>] ? merge_state+0x6a/0x150
[  523.096548]  [<ffffffff810505f8>] ? add_wait_queue+0x48/0x60
[  523.096645]  [<ffffffff8110b980>] ? __pollwait+0x70/0xf0
[  523.096742]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.096840]  [<ffffffff8110b824>] poll_schedule_timeout+0x44/0x60
[  523.096936]  [<ffffffff8110c179>] do_select+0x569/0x680
[  523.097032]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.097129]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.097226]  [<ffffffff810bfc79>] ? __alloc_pages_nodemask+0x179/0x750
[  523.097326]  [<ffffffff810f4d6c>] ?
__mem_cgroup_commit_charge.constprop.57+0x14c/0x2b0
[  523.097478]  [<ffffffff81321aed>] ? cpumask_any_but+0x2d/0x40
[  523.097575]  [<ffffffff810c484f>] ? lru_cache_add_lru+0x1f/0x40
[  523.097672]  [<ffffffff810df0cd>] ? page_add_new_anon_rmap+0x7d/0x90
[  523.097771]  [<ffffffff810d4588>] ? do_wp_page+0x298/0x750
[  523.097869]  [<ffffffff8110c49d>] core_sys_select+0x20d/0x320
[  523.097966]  [<ffffffff810f007c>] ? kmem_cache_free+0x8c/0x90
[  523.098064]  [<ffffffff8110e526>] ? __d_free+0x46/0x70
[  523.098161]  [<ffffffff8110ed55>] ? d_free+0x55/0x60
[  523.098258]  [<ffffffff8110ee35>] ? d_kill+0xd5/0x130
[  523.098354]  [<ffffffff81115f21>] ? mntput_no_expire+0x41/0x150
[  523.098452]  [<ffffffff8110c66b>] sys_select+0xbb/0x100
[  523.098549]  [<ffffffff810f80a1>] ? filp_close+0x61/0x90
[  523.098647]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.098745] cron            S 0000000000000000     0  5805      1 0x00000000
[  523.098915]  ffff8802235fbe58 0000000000000086 ffff8802235fbde8
ffff8802235fbfd8
[  523.099203]  ffff8802235fbfd8 0000000000004000 ffff880224510000
ffff880221d59690
[  523.099487]  ffff8802235fbec0 ffff88022fd4d590 000000000000d540
000000000000c350
[  523.099773] Call Trace:
[  523.099863]  [<ffffffff81329fe4>] ? timerqueue_add+0x74/0xc0
[  523.099959]  [<ffffffff81053772>] ? enqueue_hrtimer+0x22/0x50
[  523.100056]  [<ffffffff81053f70>] ? __hrtimer_start_range_ns+0x120/0x300
[  523.100157]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.100254]  [<ffffffff8159006c>] do_nanosleep+0x9c/0xd0
[  523.100350]  [<ffffffff81054714>] hrtimer_nanosleep+0xa4/0x150
[  523.100449]  [<ffffffff81053860>] ? update_rmtp+0x70/0x70
[  523.100545]  [<ffffffff8105417f>] ? hrtimer_start_range_ns+0xf/0x20
[  523.101651]  [<ffffffff8105481c>] sys_nanosleep+0x5c/0x80
[  523.101745]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.101839] agetty          S 7fffffffffffffff     0  5822      1 0x00000000
[  523.102007]  ffff8801ea405d18 0000000000000082 00000000000054be
ffff8801ea405fd8
[  523.102290]  ffff8801ea405fd8 0000000000004000 ffff880224510000
ffff880221d743b0
[  523.102573]  ffff8801ea405c48 ffffffff8105fb44 ffff8801ea405c88
ffffffff81061928
[  523.102856] Call Trace:
[  523.102943]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  523.103038]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  523.103132]  [<ffffffff8105a245>] ? check_preempt_curr+0x75/0xa0
[  523.103227]  [<ffffffff8105a282>] ? ttwu_do_wakeup+0x12/0x90
[  523.103320]  [<ffffffff8105a501>] ? ttwu_do_activate.constprop.66+0x61/0x70
[  523.103417]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.103509]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.103603]  [<ffffffff8104a056>] ? flush_work+0x16/0x40
[  523.103698]  [<ffffffff81363b36>] n_tty_read+0x436/0x890
[  523.105780]  [<ffffffff8105a282>] ? ttwu_do_wakeup+0x12/0x90
[  523.105877]  [<ffffffff8105a501>] ? ttwu_do_activate.constprop.66+0x61/0x70
[  523.105979]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.106073]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.106169]  [<ffffffff8104a056>] ? flush_work+0x16/0x40
[  523.106263]  [<ffffffff81363b36>] n_tty_read+0x436/0x890
[  523.106357]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.106452]  [<ffffffff8135def4>] tty_read+0x94/0xf0
[  523.106545]  [<ffffffff810fa207>] vfs_read+0xa7/0x180
[  523.106639]  [<ffffffff810fa325>] sys_read+0x45/0x90
[  523.106734]  [<ffffffff815930a9>] ? do_device_not_available+0x9/0x10
[  523.106834]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.106930] agetty          S 7fffffffffffffff     0  5824      1 0x00000000
[  523.107101]  ffff8801ea409d18 0000000000000082 ffff8801ea409c58
ffff8801ea409fd8
[  523.107387]  ffff8801ea409fd8 0000000000004000 ffff880224512d20
ffff880221d75a40
[  523.107678]  0000000000000246 0000000000000000 0000000000000000
ffffffff81a1a9d0
[  523.107966] Call Trace:
[  523.108055]  [<ffffffff8105575d>] ? up+0x2d/0x50
[  523.108147]  [<ffffffff81595bb5>] ? atomic_notifier_call_chain+0x15/0x20
[  523.108246]  [<ffffffff81372129>] ? notify_update+0x29/0x30
[  523.108344]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.108440]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.108540]  [<ffffffff8104a056>] ? flush_work+0x16/0x40
[  523.108637]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  523.108735]  [<ffffffff81363b36>] n_tty_read+0x436/0x890
[  523.108831]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.108926]  [<ffffffff8135def4>] tty_read+0x94/0xf0
[  523.109018]  [<ffffffff810fa207>] vfs_read+0xa7/0x180
[  523.109111]  [<ffffffff810fa325>] sys_read+0x45/0x90
[  523.109208]  [<ffffffff815930a9>] ? do_device_not_available+0x9/0x10
[  523.109307]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.109405] agetty          S 7fffffffffffffff     0  5825      1 0x00000000
[  523.109576]  ffff8801ea40bd18 0000000000000082 ffff8801ea40bc38
ffff8801ea40bfd8
[  523.109867]  ffff8801ea40bfd8 0000000000004000 ffff880224505a40
ffff880222f65a40
[  523.110154]  ffff8801ea40bc68 ffffffff81290e3c ffff8801ea40bc68
ffffffff81110314
[  523.110442] Call Trace:
[  523.110531]  [<ffffffff81290e3c>] ? btrfs_lookup+0x1c/0x50
[  523.110625]  [<ffffffff81110314>] ? d_alloc+0x24/0x70
[  523.110719]  [<ffffffff8105575d>] ? up+0x2d/0x50
[  523.110812]  [<ffffffff81595bb5>] ? atomic_notifier_call_chain+0x15/0x20
[  523.110911]  [<ffffffff81372129>] ? notify_update+0x29/0x30
[  523.111007]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.111103]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.111202]  [<ffffffff8104a056>] ? flush_work+0x16/0x40
[  523.111300]  [<ffffffff81034b09>] ? console_unlock+0x349/0x3c0
[  523.111399]  [<ffffffff81363b36>] n_tty_read+0x436/0x890
[  523.111496]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.111595]  [<ffffffff8135def4>] tty_read+0x94/0xf0
[  523.111691]  [<ffffffff810fa207>] vfs_read+0xa7/0x180
[  523.111784]  [<ffffffff810fa325>] sys_read+0x45/0x90
[  523.111877]  [<ffffffff815930a9>] ? do_device_not_available+0x9/0x10
[  523.111973]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.112068] agetty          S 7fffffffffffffff     0  5826      1 0x00000000
[  523.112238]  ffff8801ea40dd18 0000000000000086 000000000000091a
ffff8801ea40dfd8
[  523.112527]  ffff8801ea40dfd8 0000000000004000 ffff880224502d20
ffff880222f61690
[  523.112820]  ffff8801ea40dc48 ffffffff8105fb44 ffff8801ea40dc88
ffffffff81061928
[  523.113110] Call Trace:
[  523.113200]  [<ffffffff8105fb44>] ? __enqueue_entity+0x74/0x80
[  523.113297]  [<ffffffff81061928>] ? enqueue_task_fair+0x1f8/0x410
[  523.113395]  [<ffffffff8105a245>] ? check_preempt_curr+0x75/0xa0
[  523.113493]  [<ffffffff8105a282>] ? ttwu_do_wakeup+0x12/0x90
[  523.113589]  [<ffffffff8105a501>] ? ttwu_do_activate.constprop.66+0x61/0x70
[  523.113688]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.114361]  [<ffffffff810fa325>] sys_read+0x45/0x90
[  523.114454]  [<ffffffff815930a9>] ? do_device_not_available+0x9/0x10
[  523.115397]  ffff88010000000a ffffffff81106287 000000000000000a
ffff8801ea497d18
[  523.115688] Call Trace:
[  523.115778]  [<ffffffff81106287>] ? link_path_walk+0x67/0x8d0
[  523.115873]  [<ffffffff8105575d>] ? up+0x2d/0x50
[  523.115968]  [<ffffffff81595bb5>] ? atomic_notifier_call_chain+0x15/0x20
[  523.116067]  [<ffffffff81372129>] ? notify_update+0x29/0x30
[  523.116162]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.116255]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.116351]  [<ffffffff8104a056>] ? flush_work+0x16/0x40
[  523.116443]  [<ffffffff81363b36>] n_tty_read+0x436/0x890
[  523.116536]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.116630]  [<ffffffff8135def4>] tty_read+0x94/0xf0
[  523.116722]  [<ffffffff810fa207>] vfs_read+0xa7/0x180
[  523.116814]  [<ffffffff810fa325>] sys_read+0x45/0x90
[  523.116906]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.117000] sshd            S ffff880221f92c00     0  5867   5789 0x00000000
[  523.117166]  ffff8801ea40f8f8 0000000000000086 ffff8801ea40f878
ffff8801ea40ffd8
[  523.117449]  ffff8801ea40ffd8 0000000000004000 ffffffff81a13440
ffff8802211f1690
[  523.117732]  0000000000000009 ffff880222ad2900 ffff8801ea40f8c8
ffffffffa05507c7
[  523.118018] Call Trace:
[  523.118109]  [<ffffffffa05507c7>] ? e1000_xmit_frame+0x9a7/0xdc0 [e1000e]
[  523.118207]  [<ffffffff813405c0>] ? map_single+0x60/0x60
[  523.118305]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.118402]  [<ffffffff81590235>] schedule_hrtimeout_range_clock+0x125/0x140
[  523.118504]  [<ffffffff8105896e>] ? __wake_up+0x4e/0x70
[  523.118601]  [<ffffffff813658ff>] ? put_ldisc+0x3f/0xa0
[  523.118700]  [<ffffffff8159025e>] schedule_hrtimeout_range+0xe/0x10
[  523.118799]  [<ffffffff8110b824>] poll_schedule_timeout+0x44/0x60
[  523.118896]  [<ffffffff8110c179>] do_select+0x569/0x680
[  523.118991]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.119085]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.119179]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.119275]  [<ffffffff8110ba00>] ? __pollwait+0xf0/0xf0
[  523.119372]  [<ffffffff814cf770>] ? release_sock+0xe0/0x110
[  523.119470]  [<ffffffff8151f4d2>] ? tcp_sendmsg+0x7c2/0xe40
[  523.119568]  [<ffffffff815430a3>] ? inet_sendmsg+0x43/0xb0
[  523.119665]  [<ffffffff814cd065>] ? sock_aio_write+0x145/0x180
[  523.119763]  [<ffffffff8110c49d>] core_sys_select+0x20d/0x320
[  523.119861]  [<ffffffff810f97fa>] ? do_sync_write+0xda/0x120
[  523.119960]  [<ffffffff814d167c>] ? sock_getsockopt+0xfc/0x620
[  523.120057]  [<ffffffff8110c66b>] sys_select+0xbb/0x100
[  523.120153]  [<ffffffff814ce256>] ? sys_getsockopt+0xa6/0xb0
[  523.120250]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.120348] bash            S 7fffffffffffffff     0  5875   5867 0x00000000
[  523.120517]  ffff8801ea509d18 0000000000000082 ffff8801ea509c18
ffff8801ea509fd8
[  523.120803]  ffff8801ea509fd8 0000000000004000 ffff8802244d43b0
ffff8802224fda40
[  523.121090]  000005002309500a ffff88022fc10f00 ffff8802224fda40
ffff8802224fe00a
[  523.121384] Call Trace:
[  523.121472]  [<ffffffff8105a254>] ? check_preempt_curr+0x84/0xa0
[  523.121568]  [<ffffffff8105a282>] ? ttwu_do_wakeup+0x12/0x90
[  523.121666]  [<ffffffff8105cc5e>] ? try_to_wake_up+0x24e/0x2c0
[  523.122763]  [<ffffffff815912e4>] schedule+0x24/0x70
[  523.122855]  [<ffffffff8158f785>] schedule_timeout+0x175/0x1e0
[  523.122950]  [<ffffffff8104a056>] ? flush_work+0x16/0x40
[  523.123044]  [<ffffffff81363b36>] n_tty_read+0x436/0x890
[  523.123139]  [<ffffffff8105ccd0>] ? try_to_wake_up+0x2c0/0x2c0
[  523.123235]  [<ffffffff8135def4>] tty_read+0x94/0xf0
[  523.123329]  [<ffffffff810fa207>] vfs_read+0xa7/0x180
[  523.123424]  [<ffffffff810fa325>] sys_read+0x45/0x90
[  523.123519]  [<ffffffff810440b3>] ? sys_rt_sigprocmask+0xa3/0xd0
[  523.123616]  [<ffffffff815986a2>] system_call_fastpath+0x16/0x1b
[  523.123712] Sched Debug Version: v0.10, 3.5.1-gentoo-testserver-ipmi #1
[  523.123808] ktime                                   : 524207.601015
[  523.123903] sched_clk                               : 523123.711782
[  523.123998] cpu_clk                                 : 523123.711802
[  523.124092] jiffies                                 : 4295034558
[  523.124186] sched_clock_stable                      : 1
[  523.124279]
[  523.124363] sysctl_sched
[  523.124451]   .sysctl_sched_latency                    : 24.000000
[  523.124546]   .sysctl_sched_min_granularity            : 3.000000
[  523.124643]   .sysctl_sched_wakeup_granularity         : 4.000000
[  523.124741]   .sysctl_sched_child_runs_first           : 0
[  523.124837]   .sysctl_sched_features                   : 24119
[  523.124935]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[  523.125033]
[  523.125033] cpu#0, 3192.921 MHz
[  523.125176]   .nr_running                    : 1
[  523.125268]   .load                          : 1024
[  523.125361]   .nr_switches                   : 40287
[  523.125453]   .nr_load_updates               : 157160
[  523.126495]   .sched_count                   : 44938
[  523.126591]   .sched_goidle                  : 16650
[  523.126686]   .avg_idle                      : 1000000
[  523.127970]   .load_avg                      : 0.000000
[  523.128065]   .load_period                   : 0.000000
[  523.128162]   .load_contrib                  : 0
[  523.128258]   .load_tg                       : 0
[  523.128354]
[  523.128354] runnable tasks:
[  523.128354]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.128354] ----------------------------------------------------------------------------------------------------------
[  523.128734]      kworker/0:0     4      1408.823605      2310   120
     1408.823605       252.519281    522450.687703 /
[  523.129034]
[  523.129034] cpu#1, 3192.921 MHz
[  523.129179]   .nr_running                    : 0
[  523.129274]   .load                          : 0
[  523.129369]   .nr_switches                   : 24226
[  523.129465]   .nr_load_updates               : 157248
[  523.129561]   .nr_uninterruptible            : -27
[  523.129656]   .next_balance                  : 4295.034561
[  523.129751]   .curr->pid                     : 0
[  523.129844]   .clock                         : 523129.383067
[  523.129937]   .cpu_load[0]                   : 0
[  523.130029]   .cpu_load[1]                   : 0
[  523.130120]   .cpu_load[2]                   : 0
[  523.130214]   .cpu_load[3]                   : 0
[  523.130308]   .cpu_load[4]                   : 0
[  523.130402]   .yld_count                     : 0
[  523.130498]   .sched_count                   : 24272
[  523.130595]   .sched_goidle                  : 11819
[  523.130686]   .avg_idle                      : 1000000
[  523.130779]   .ttwu_count                    : 6441
[  523.130870]   .ttwu_local                    : 3991
[  523.130961]
[  523.130961] cfs_rq[1]:/
[  523.131097]   .exec_clock                    : 447.749127
[  523.131189]   .MIN_vruntime                  : 0.000001
[  523.131281]   .min_vruntime                  : 472.170542
[  523.131373]   .max_vruntime                  : 0.000001
[  523.131466]   .spread                        : 0.000000
[  523.131559]   .spread0                       : -936.653063
[  523.131651]   .nr_spread_over                : 18
[  523.131742]   .nr_running                    : 0
[  523.131833]   .load                          : 0
[  523.131924]   .load_avg                      : 0.000000
[  523.132016]   .load_period                   : 0.000000
[  523.132107]   .load_contrib                  : 0
[  523.132202]   .load_tg                       : 0
[  523.132296]
[  523.132296] runnable tasks:
[  523.132296]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.132296] ----------------------------------------------------------------------------------------------------------
[  523.132675]
[  523.132675] cpu#2, 3192.921 MHz
[  523.132819]   .nr_running                    : 3
[  523.132911]   .load                          : 2048
[  523.133003]   .nr_switches                   : 11291
[  523.133096]   .nr_load_updates               : 157245
[  523.133189]   .nr_uninterruptible            : -15
[  523.133282]   .next_balance                  : 4295.034583
[  523.133376]   .curr->pid                     : 2182
[  523.133470]   .clock                         : 230913.251804
[  523.133566]   .cpu_load[0]                   : 2048
[  523.133662]   .cpu_load[1]                   : 2048
[  523.133758]   .cpu_load[2]                   : 2048
[  523.133854]   .cpu_load[3]                   : 2048
[  523.135126]   .spread                        : 0.000000
[  523.135221]   .spread0                       : -284.864198
[  523.135316]   .nr_spread_over                : 11
[  523.135410]   .nr_running                    : 2
[  523.135503]   .load                          : 2048
[  523.135594]   .load_avg                      : 0.000000
[  523.135687]   .load_period                   : 0.000000
[  523.135780]   .load_contrib                  : 0
[  523.135872]   .load_tg                       : 0
[  523.135964]
[  523.135964] runnable tasks:
[  523.135964]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.135964] ----------------------------------------------------------------------------------------------------------
[  523.136352]      migration/2    10         0.000000         9     0
        0.000000         0.000865         0.000000 /
[  523.136649]      kworker/2:1   799      1111.959407       311   120
     1111.959407         2.731132    228484.762431 /
[  523.136942] R    kworker/u:5  2182      1123.959407       322   120
     1123.959407       932.723527    206327.249166 /
[  523.137238]
[  523.137238] cpu#3, 3192.921 MHz
[  523.137378]   .nr_running                    : 0
[  523.137472]   .load                          : 0
[  523.137566]   .nr_switches                   : 13208
[  523.137661]   .nr_load_updates               : 157243
[  523.137758]   .nr_uninterruptible            : -19
[  523.137852]   .next_balance                  : 4295.034563
[  523.137947]   .curr->pid                     : 0
[  523.138039]   .clock                         : 523136.036135
[  523.138135]   .cpu_load[0]                   : 0
[  523.138228]   .cpu_load[1]                   : 0
[  523.138322]   .cpu_load[2]                   : 0
[  523.138415]   .cpu_load[3]                   : 0
[  523.138507]   .cpu_load[4]                   : 0
[  523.138600]   .yld_count                     : 0
[  523.138695]   .sched_count                   : 13221
[  523.138791]   .sched_goidle                  : 6505
[  523.138887]   .avg_idle                      : 1000000
[  523.138981]   .ttwu_count                    : 6019
[  523.139073]   .ttwu_local                    : 4248
[  523.139166]
[  523.139166] cfs_rq[3]:/
[  523.140310]   .exec_clock                    : 257.667101
[  523.140402]   .MIN_vruntime                  : 0.000001
[  523.140495]   .min_vruntime                  : 359.188644
[  523.140591]   .max_vruntime                  : 0.000001
[  523.140687]   .spread                        : 0.000000
[  523.140782]   .spread0                       : -1049.634961
[  523.140877]   .nr_spread_over                : 155
[  523.140969]   .nr_running                    : 0
[  523.141063]   .load                          : 0
[  523.141156]   .load_avg                      : 0.000000
[  523.141248]   .load_period                   : 0.000000
[  523.141341]   .load_contrib                  : 0
[  523.141433]   .load_tg                       : 0
[  523.141524]
[  523.141524] runnable tasks:
[  523.141524]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.141524] ----------------------------------------------------------------------------------------------------------
[  523.141898]
[  523.141898] cpu#4, 3192.921 MHz
[  523.142043]   .nr_running                    : 0
[  523.142136]   .load                          : 0
[  523.142229]   .nr_switches                   : 10307
[  523.142322]   .nr_load_updates               : 157240
[  523.142416]   .nr_uninterruptible            : 21
[  523.142508]   .next_balance                  : 4295.034563
[  523.142602]   .curr->pid                     : 0
[  523.142694]   .clock                         : 523142.683111
[  523.142789]   .cpu_load[0]                   : 0
[  523.142880]   .cpu_load[1]                   : 0
[  523.142972]   .cpu_load[2]                   : 0
[  523.143067]   .cpu_load[3]                   : 0
[  523.144436]   .spread0                       : 10662.064973
[  523.144532]   .nr_spread_over                : 683
[  523.144626]   .nr_running                    : 0
[  523.144719]   .load                          : 0
[  523.144812]   .load_avg                      : 0.000000
[  523.144904]   .load_period                   : 0.000000
[  523.144997]   .load_contrib                  : 0
[  523.145088]   .load_tg                       : 0
[  523.145179]
[  523.145179] runnable tasks:
[  523.145179]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.145179] ----------------------------------------------------------------------------------------------------------
[  523.145545]
[  523.145545] cpu#5, 3192.921 MHz
[  523.145681]   .nr_running                    : 0
[  523.145772]   .load                          : 0
[  523.145863]   .nr_switches                   : 9443
[  523.145955]   .nr_load_updates               : 157237
[  523.146047]   .nr_uninterruptible            : 7
[  523.146137]   .next_balance                  : 4295.034565
[  523.146230]   .curr->pid                     : 0
[  523.146321]   .clock                         : 523146.012025
[  523.146414]   .cpu_load[0]                   : 0
[  523.146508]   .cpu_load[1]                   : 0
[  523.146603]   .cpu_load[2]                   : 0
[  523.146696]   .cpu_load[3]                   : 0
[  523.146789]   .cpu_load[4]                   : 0
[  523.146882]   .yld_count                     : 0
[  523.146974]   .sched_count                   : 9456
[  523.147066]   .sched_goidle                  : 4164
[  523.147158]   .avg_idle                      : 1000000
[  523.147252]   .ttwu_count                    : 3994
[  523.147345]   .ttwu_local                    : 2346
[  523.147438]
[  523.147438] cfs_rq[5]:/
[  523.147581]   .exec_clock                    : 341.583821
[  523.147677]   .MIN_vruntime                  : 0.000001
[  523.147774]   .min_vruntime                  : 12292.675549
[  523.147871]   .max_vruntime                  : 0.000001
[  523.147967]   .spread                        : 0.000000
[  523.148063]   .spread0                       : 10883.851944
[  523.148156]   .nr_spread_over                : 701
[  523.148247]   .nr_running                    : 0
[  523.148339]   .load                          : 0
[  523.148431]   .load_avg                      : 0.000000
[  523.148525]   .load_period                   : 0.000000
[  523.148619]   .load_contrib                  : 0
[  523.148714]   .load_tg                       : 0
[  523.148810]
[  523.148810] runnable tasks:
[  523.148810]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.148810] ----------------------------------------------------------------------------------------------------------
[  523.149195]
[  523.149195] cpu#6, 3192.921 MHz
[  523.149339]   .nr_running                    : 0
[  523.149431]   .load                          : 0
[  523.149523]   .nr_switches                   : 11384
[  523.149616]   .nr_load_updates               : 157235
[  523.149711]   .nr_uninterruptible            : 33
[  523.149806]   .next_balance                  : 4295.034566
[  523.149901]   .curr->pid                     : 0
[  523.149993]   .clock                         : 523149.334535
[  523.150087]   .cpu_load[0]                   : 0
[  523.150179]   .cpu_load[1]                   : 0
[  523.150273]   .cpu_load[2]                   : 0
[  523.150367]   .cpu_load[3]                   : 0
[  523.150462]   .cpu_load[4]                   : 0
[  523.150555]   .yld_count                     : 0
[  523.150650]   .sched_count                   : 11388
[  523.150745]   .sched_goidle                  : 5112
[  523.150840]   .avg_idle                      : 1000000
[  523.150936]   .ttwu_count                    : 4838
[  523.151032]   .ttwu_local                    : 2175
[  523.151128]
[  523.151128] cfs_rq[6]:/
[  523.151267]   .exec_clock                    : 346.323007
[  523.151362]   .MIN_vruntime                  : 0.000001
[  523.152406]   .load_tg                       : 0
[  523.152499]
[  523.152499] runnable tasks:
[  523.152499]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.152499] ----------------------------------------------------------------------------------------------------------
[  523.152876]
[  523.152876] cpu#7, 3192.921 MHz
[  523.154052]   .cpu_load[3]                   : 0
[  523.154145]   .cpu_load[4]                   : 0
[  523.154240]   .yld_count                     : 0
[  523.154334]   .sched_count                   : 16221
[  523.154430]   .sched_goidle                  : 4979
[  523.154526]   .avg_idle                      : 1000000
[  523.154622]   .ttwu_count                    : 8416
[  523.154718]   .ttwu_local                    : 6214
[  523.154811]
[  523.154811] cfs_rq[7]:/
[  523.154946]   .exec_clock                    : 641.434975
[  523.155039]   .MIN_vruntime                  : 0.000001
[  523.155132]   .min_vruntime                  : 13083.088383
[  523.155226]   .max_vruntime                  : 0.000001
[  523.155321]   .spread                        : 0.000000
[  523.155417]   .spread0                       : 11674.264778
[  523.155514]   .nr_spread_over                : 696
[  523.155609]   .nr_running                    : 0
[  523.155703]   .load                          : 0
[  523.155796]   .load_avg                      : 0.000000
[  523.155891]   .load_period                   : 0.000000
[  523.156985]   .load_contrib                  : 0
[  523.157079]   .load_tg                       : 0
[  523.157171]
[  523.157171] runnable tasks:
[  523.157171]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  523.157171] ----------------------------------------------------------------------------------------------------------
[  523.157553]



-- 
John M. Drescher
