Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1LALHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:07:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50651 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1LALH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:07:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAJJYPdnaVfkYYT0Y6BseDki4JJcQ=c3UinEYZ+23bX_1xrWDpA@mail.gmail.com>
References: <CAJJYPdnaVfkYYT0Y6BseDki4JJcQ=c3UinEYZ+23bX_1xrWDpA@mail.gmail.com>
Date: Thu, 1 Dec 2011 12:07:24 +0100
Message-ID: <CAJJYPdm3WCyDAVSi2+pa-hQCAMb4k7bCmbdJcREcX4a1CWs4MQ@mail.gmail.com>
Subject: Re: Busy looping iwl3945 driver
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ahh

Seems to be related to this thread:

https://lkml.org/lkml/2011/11/29/102



2011/12/1 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
> Today I've noticed  100% CPU occupied by kworker thread - which
> appeared to be the result of some  iwl3945 driver interaction.
>
> Here are some trace of some tasks from that moment.
> It looked like when I've then even tried to run 'mc' of  'ifconfig' -
> they could not start since some device lock was kept busy.
>
> The problem was most probably caused by doing suspend when attached to
> the wireless network  and resuming in wired docking station,
> without having the previous wireless AP available.
>
> My hw -  T61, 4G, C2D, iwl3945 wifi,   X86_64 kernel 3.2.0-rc3
> Only reboot fixed this problem.
>
>
>  NetworkManager  D 0000000000000000     0   648      1 0x00000004
>  ffff8801301157e8 0000000000000046 ffffffff814d9fe4 0000000000000000
>  ffff8801301157f8 ffff88012c968000 0000000000000000 ffff880130115fd8
>  ffff880130115fd8 ffff880130115fd8 ffffffff81a0d020 ffff88012c968000
>  Call Trace:
>  [<ffffffff814d9fe4>] ? __schedule+0x994/0xb50
>  [<ffffffff814da23f>] schedule+0x3f/0x60
>  [<ffffffff814db1c2>] mutex_lock_nested+0x1b2/0x3f0
>  [<ffffffffa033984f>] ? ieee80211_ifa_changed+0x9f/0x150 [mac80211]
>  [<ffffffffa033984f>] ? ieee80211_ifa_changed+0x9f/0x150 [mac80211]
>  [<ffffffffa033984f>] ieee80211_ifa_changed+0x9f/0x150 [mac80211]
>  [<ffffffff814e17e3>] notifier_call_chain+0x93/0x100
>  [<ffffffff81082cf8>] __blocking_notifier_call_chain+0x78/0xb0
>  [<ffffffff81082d46>] blocking_notifier_call_chain+0x16/0x20
>  [<ffffffff814856b6>] __inet_del_ifa+0xb6/0x290
>  [<ffffffff8148633e>] inet_rtm_deladdr+0x10e/0x160
>  [<ffffffff81436544>] rtnetlink_rcv_msg+0x124/0x2e0
>  [<ffffffff81436420>] ? __rtnl_unlock+0x20/0x20
>  [<ffffffff81446c49>] netlink_rcv_skb+0xa9/0xd0
>  [<ffffffff81434465>] rtnetlink_rcv+0x25/0x40
>  [<ffffffff81446580>] netlink_unicast+0x2c0/0x310
>  [<ffffffff81446886>] netlink_sendmsg+0x2b6/0x310
>  [<ffffffff81410458>] ? sock_update_classid+0xb8/0x1f0
>  [<ffffffff81409cee>] sock_sendmsg+0x10e/0x1e0
>  [<ffffffff8140babd>] ? sock_recvmsg+0x18d/0x210
>  [<ffffffff8112dce3>] ? might_fault+0x53/0xb0
>  [<ffffffff8112dd2c>] ? might_fault+0x9c/0xb0
>  [<ffffffff8112dce3>] ? might_fault+0x53/0xb0
>  [<ffffffff814191c6>] ? verify_iovec+0x56/0xd0
>  [<ffffffff8140c116>] __sys_sendmsg+0x376/0x380
>  [<ffffffff81161458>] ? fget_light+0x48/0x3b0
>  [<ffffffff811614f1>] ? fget_light+0xe1/0x3b0
>  [<ffffffff81161458>] ? fget_light+0x48/0x3b0
>  [<ffffffff8118149f>] ? mntput+0x1f/0x30
>  [<ffffffff8140db19>] sys_sendmsg+0x49/0x90
>  [<ffffffff814e562b>] system_call_fastpath+0x16/0x1b
>
>
>
> avahi-daemon    D 0000000000000246     0   667      1 0x00000000
>  ffff880127df5ba8 0000000000000046 0000000000000000 0000000000000000
>  ffff880127df5bb8 ffff880128be4600 0000000000000000 ffff880127df5fd8
>  ffff880127df5fd8 ffff880127df5fd8 ffff88012ca72300 ffff880128be4600
> Call Trace:
>  [<ffffffff814da23f>] schedule+0x3f/0x60
>  [<ffffffff814db1c2>] mutex_lock_nested+0x1b2/0x3f0
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] rtnl_lock+0x17/0x20
>  [<ffffffff8148ff6f>] ip_mc_leave_group+0x2f/0x180
>  [<ffffffff8145b2f4>] do_ip_setsockopt+0x6d4/0xdb0
>  [<ffffffff81409cee>] ? sock_sendmsg+0x10e/0x1e0
>  [<ffffffff8116a1fc>] ? pipe_write+0x2ec/0x5b0
>  [<ffffffff811a1b43>] ? fsnotify+0x93/0x600
>  [<ffffffff8140d6f1>] ? sys_sendto+0x101/0x130
>  [<ffffffff8145bad6>] ip_setsockopt+0x36/0xb0
>  [<ffffffff8147dcab>] udp_setsockopt+0x1b/0x40
>  [<ffffffff8140e574>] sock_common_setsockopt+0x14/0x20
>  [<ffffffff8140d8ff>] sys_setsockopt+0x7f/0xe0
>  [<ffffffff814e562b>] system_call_fastpath+0x16/0x1b
>
>
> wpa_supplicant  D 0000000000000246     0   770      1 0x00000000
>  ffff880127c17908 0000000000000046 0000000000000000 0000000000000000
>  ffff880127c17918 ffff880127e02300 0000000000000000 ffff880127c17fd8
>  ffff880127c17fd8 ffff880127c17fd8 ffff88012ca72300 ffff880127e02300
> Call Trace:
>  [<ffffffff814da23f>] schedule+0x3f/0x60
>  [<ffffffff814db1c2>] mutex_lock_nested+0x1b2/0x3f0
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] rtnl_lock+0x17/0x20
>  [<ffffffffa02ec1d5>] nl80211_pre_doit+0xf5/0x190 [cfg80211]
>  [<ffffffff81447263>] genl_rcv_msg+0x1c3/0x250
>  [<ffffffff814470a0>] ? genl_rcv+0x40/0x40
>  [<ffffffff81446c49>] netlink_rcv_skb+0xa9/0xd0
>  [<ffffffff81447085>] genl_rcv+0x25/0x40
>  [<ffffffff81446580>] netlink_unicast+0x2c0/0x310
>  [<ffffffff81446886>] netlink_sendmsg+0x2b6/0x310
>  [<ffffffff81410458>] ? sock_update_classid+0xb8/0x1f0
>  [<ffffffff81409cee>] sock_sendmsg+0x10e/0x1e0
>  [<ffffffff8140babd>] ? sock_recvmsg+0x18d/0x210
>  [<ffffffff8112dce3>] ? might_fault+0x53/0xb0
>  [<ffffffff8112dd2c>] ? might_fault+0x9c/0xb0
>  [<ffffffff8112dce3>] ? might_fault+0x53/0xb0
>  [<ffffffff814191c6>] ? verify_iovec+0x56/0xd0
>  [<ffffffff8140c116>] __sys_sendmsg+0x376/0x380
>  [<ffffffff8106a904>] ? set_current_blocked+0x34/0x60
>  [<ffffffff8100bee1>] ? fpu_finit+0x21/0x40
>  [<ffffffff8100bf4a>] ? init_fpu+0x4a/0x180
>  [<ffffffff8100d198>] ? restore_i387_xstate+0xc8/0x1d0
>  [<ffffffff811615bf>] ? fget_light+0x1af/0x3b0
>  [<ffffffff814ddedb>] ? _raw_spin_unlock_irq+0x3b/0x60
>  [<ffffffff8140db19>] sys_sendmsg+0x49/0x90
>  [<ffffffff814e562b>] system_call_fastpath+0x16/0x1b
>
>
>
> ntpd            D 0000000000000246     0 21324      1 0x00000000
>  ffff880127adfca8 0000000000000046 0000000000000000 0000000000000000
>  ffff880127adfcb8 ffff880127f5c600 0000000000000000 ffff880127adffd8
>  ffff880127adffd8 ffff880127adffd8 ffff8800379e4600 ffff880127f5c600
> Call Trace:
>  [<ffffffff814da23f>] schedule+0x3f/0x60
>  [<ffffffff814db1c2>] mutex_lock_nested+0x1b2/0x3f0
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] rtnl_lock+0x17/0x20
>  [<ffffffff81428165>] dev_ioctl+0x3c5/0x660
>  [<ffffffff81090b80>] ? lockdep_init_map+0xf0/0x590
>  [<ffffffff814092ad>] sock_do_ioctl+0x5d/0x70
>  [<ffffffff81409339>] sock_ioctl+0x79/0x2f0
>  [<ffffffff811736f8>] do_vfs_ioctl+0x98/0x570
>  [<ffffffff814dddf5>] ? _raw_spin_unlock+0x35/0x60
>  [<ffffffff8115d7cd>] ? fd_install+0x7d/0x100
>  [<ffffffff811615bf>] ? fget_light+0x1af/0x3b0
>  [<ffffffff81173c61>] sys_ioctl+0x91/0xa0
>  [<ffffffff814e562b>] system_call_fastpath+0x16/0x1b
>
>
>
> Here I've tried  'mc'  and rmmod of iwl3945 (which had in fact open count == 0)
>
>
>
> mc              D 0000000000000000     0 12325  12174 0x00000000
>  ffff880007a77ca8 0000000000000046 ffffffff814d9fe4 0000000000000000
>  ffff880007a77cb8 ffff880037918000 0000000000000000 ffff880007a77fd8
>  ffff880007a77fd8 ffff880007a77fd8 ffffffff81a0d020 ffff880037918000
> Call Trace:
>  [<ffffffff814d9fe4>] ? __schedule+0x994/0xb50
>  [<ffffffff814da23f>] schedule+0x3f/0x60
>  [<ffffffff814db1c2>] mutex_lock_nested+0x1b2/0x3f0
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] ? rtnl_lock+0x17/0x20
>  [<ffffffff81434437>] rtnl_lock+0x17/0x20
>  [<ffffffff81428165>] dev_ioctl+0x3c5/0x660
>  [<ffffffff81090b80>] ? lockdep_init_map+0xf0/0x590
>  [<ffffffff814092ad>] sock_do_ioctl+0x5d/0x70
>  [<ffffffff81409339>] sock_ioctl+0x79/0x2f0
>  [<ffffffff811736f8>] do_vfs_ioctl+0x98/0x570
>  [<ffffffff814dddf5>] ? _raw_spin_unlock+0x35/0x60
>  [<ffffffff8115d7cd>] ? fd_install+0x7d/0x100
>  [<ffffffff811615bf>] ? fget_light+0x1af/0x3b0
>  [<ffffffff81173c61>] sys_ioctl+0x91/0xa0
>  [<ffffffff814e562b>] system_call_fastpath+0x16/0x1b
> rmmod           D 0000000000000000     0 12340  22112 0x00000000
>  ffff880051811bf8 0000000000000046 ffffffff814d9fe4 ffffffff814d5fd1
>  0000000000000001 ffff8800b0cd8000 0000000000000046 ffff880051811fd8
>  ffff880051811fd8 ffff880051811fd8 ffff880136d44600 ffff8800b0cd8000
> Call Trace:
>  [<ffffffff814d9fe4>] ? __schedule+0x994/0xb50
>  [<ffffffff814d5fd1>] ? __slab_free+0x233/0x3aa
>  [<ffffffff814da23f>] schedule+0x3f/0x60
>  [<ffffffff814dd265>] rwsem_down_failed_common+0xc5/0x160
>  [<ffffffff814dd313>] rwsem_down_write_failed+0x13/0x20
>  [<ffffffff812d2733>] call_rwsem_down_write_failed+0x13/0x20
>  [<ffffffff81082a07>] ? blocking_notifier_chain_unregister+0x27/0xe0
>  [<ffffffff814dc629>] ? down_write+0x89/0xb0
>  [<ffffffff81082a07>] ? blocking_notifier_chain_unregister+0x27/0xe0
>  [<ffffffff81082a07>] blocking_notifier_chain_unregister+0x27/0xe0
>  [<ffffffff81485cd8>] unregister_inetaddr_notifier+0x18/0x20
>  [<ffffffffa03380b6>] ieee80211_unregister_hw+0x46/0x120 [mac80211]
>  [<ffffffffa03b4779>] iwl3945_pci_remove+0x57/0x300 [iwl3945]
>  [<ffffffff814dde62>] ? _raw_spin_unlock_irqrestore+0x42/0x80
>  [<ffffffff812ee156>] pci_device_remove+0x46/0x110
>  [<ffffffff813926bc>] __device_release_driver+0x7c/0xe0
>  [<ffffffff81392fc8>] driver_detach+0xd8/0xe0
>  [<ffffffff813924f1>] bus_remove_driver+0x91/0x110
>  [<ffffffff813937b2>] driver_unregister+0x62/0xa0
>  [<ffffffff812ecf94>] pci_unregister_driver+0x44/0xc0
>  [<ffffffffa03b4a32>] iwl3945_exit+0x10/0x17 [iwl3945]
>  [<ffffffff810a169e>] sys_delete_module+0x16e/0x250
>  [<ffffffff8109647f>] ? trace_hardirqs_on_caller+0x1f/0x1b0
>  [<ffffffff814e562b>] system_call_fastpath+0x16/0x1b
>
>
>
> Here is  'pert record -a -g'
>
> # Overhead          Command               Shared Object
>                       Symbol
> # ........  ...............  ..........................
> ...........................................
> #
>    97.57%      kworker/u:3  [kernel.kallsyms]           [k] lock_timer_base
>                |
>                --- lock_timer_base
>                    try_to_del_timer_sync
>                    del_timer_sync
>                    iwl3945_send_tx_power
>                    ieee80211_bss_info_change_notify
>                    ieee80211_sta_eosp_irqsafe
>                    ieee80211_sta_eosp_irqsafe
>                    ieee80211_stop_tx_ba_cb
>                    ieee80211_stop_tx_ba_cb
>                    ieee80211_stop_tx_ba_cb
>                    ieee80211_stop_tx_ba_cb
>                    process_one_work
>                    worker_thread
>                    kthread
>                    kernel_thread_helper
>
>     0.38%      kworker/u:3  [kernel.kallsyms]           [k] ioread32
>                |
>                --- ioread32
>                   |
>                   |--37.76%-- iwl_legacy_send_bt_config
>                   |          iwl3945_rx_queue_restock
>                   |          iwl3945_irq_tasklet
>                   |          tasklet_action
>                   |          __do_softirq
>                   |          call_softirq
>                   |          do_softirq
>                   |          irq_exit
>                   |          __irqentry_text_start
>                   |          ret_from_intr
>                   |          try_to_del_timer_sync
>                   |          del_timer_sync
>                   |          iwl3945_send_tx_power
>                   |          ieee80211_bss_info_change_notify
>                   |          ieee80211_sta_eosp_irqsafe
>                   |          ieee80211_sta_eosp_irqsafe
>                   |          ieee80211_stop_tx_ba_cb
>                   |          ieee80211_stop_tx_ba_cb
>                   |          ieee80211_stop_tx_ba_cb
>                   |          ieee80211_stop_tx_ba_cb
>                   |          process_one_work
>                   |          worker_thread
>                   |          kthread
>                   |          kernel_thread_helper
>                   |
>                   |--31.13%-- iwl3945_irq_tasklet
>                   |          tasklet_action
>                   |          __do_softirq
>                   |          call_softirq
>                   |          do_softirq
>                   |          irq_exit
>                   |          |
>                   |          |--92.86%-- __irqentry_text_start
>                   |          |          ret_from_intr
>                   |          |          try_to_del_timer_sync
>                   |          |          del_timer_sync
>                   |          |          iwl3945_send_tx_power
>                   |          |          ieee80211_bss_info_change_notify
>                   |          |          ieee80211_sta_eosp_irqsafe
>                   |          |          ieee80211_sta_eosp_irqsafe
>                   |          |          ieee80211_stop_tx_ba_cb
>                   |          |          ieee80211_stop_tx_ba_cb
>                   |          |          ieee80211_stop_tx_ba_cb
>                   |          |          ieee80211_stop_tx_ba_cb
>                   |          |          process_one_work
>                   |          |          worker_thread
>                   |          |          kthread
>                   |          |          kernel_thread_helper
>                   |          |
>                   |           --7.14%-- smp_apic_timer_interrupt
>                   |                     apic_timer_interrupt
>                   |                     try_to_del_timer_sync
>                   |                     del_timer_sync
>                   |                     iwl3945_send_tx_power
>                   |                     ieee80211_bss_info_change_notify
>                   |                     ieee80211_sta_eosp_irqsafe
>                   |                     ieee80211_sta_eosp_irqsafe
>                   |                     ieee80211_stop_tx_ba_cb
>                   |                     ieee80211_stop_tx_ba_cb
>                   |                     ieee80211_stop_tx_ba_cb
>                   |                     ieee80211_stop_tx_ba_cb
>                   |                     process_one_work
>                   |                     worker_thread
>                   |                     kthread
>                   |                     kernel_thread_helper
>                   |
>                    --31.12%-- iwl_legacy_add_beacon_time
>                              handle_irq_event_percpu
>                              handle_irq_event
>                              handle_edge_irq
>                              handle_irq
>                              __irqentry_text_start
>                              ret_from_intr
>                              try_to_del_timer_sync
>                              del_timer_sync
>                              iwl3945_send_tx_power
>                              ieee80211_bss_info_change_notify
>                              ieee80211_sta_eosp_irqsafe
>                              ieee80211_sta_eosp_irqsafe
>                              ieee80211_stop_tx_ba_cb
>                              ieee80211_stop_tx_ba_cb
>                              ieee80211_stop_tx_ba_cb
>                              ieee80211_stop_tx_ba_cb
>                              process_one_work
>                              worker_thread
>                              kthread
>                              kernel_thread_helper
>
>     0.27%      kworker/u:3  [kernel.kallsyms]           [k] read_hpet
> ....
>
> Zdenek
