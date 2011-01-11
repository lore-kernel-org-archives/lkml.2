Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1AKUKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:10:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37649 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1AKUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=r3DCidrRFbtHyAZabmIRIiz4RAqNUFDfqAOm/cdvbinE+a7FRkd1q8T6VfxS/QEn+g
         OL5BLdKMZlaPB2B0vTOdcz3AkBXdlDMrZlaeAuGNKftFLesVQ67uFCQI7fsRCCwWCnTA
         l+OctcxQTUYUiW1oqnWWZAGU3JZio3OyQ5KIQ=
MIME-Version: 1.0
Date: Tue, 11 Jan 2011 15:10:17 -0500
Message-ID: <AANLkTin4n+OQMSTdbsMBrKxhe494Uq2Db-0Fg65ao2iL@mail.gmail.com>
Subject: 2.6.37-git5 -- INFO: possible irq lock inversion dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ INFO: possible irq lock inversion dependency detected ]
2.6.37-git5 #1
---------------------------------------------------------
dbus-daemon/1512 just changed the state of lock:
 (&(&list->lock)->rlock#7){+.-...}, at: [<ffffffffa01d4ecc>]
ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&(&priv->lock)->rlock){-.-...}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
1 lock held by dbus-daemon/1512:
 #0:  (rcu_read_lock){.+.+..}, at: [<ffffffffa01d46c7>]
rcu_read_lock+0x0/0x35 [mac80211]

the shortest dependencies between 2nd lock and 1st lock:
  -> (&(&priv->lock)->rlock){-.-...} ops: 569 {
     IN-HARDIRQ-W at:
                            [<ffffffff8105c263>] __lock_acquire+0x2f5/0xdcd
                            [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                            [<ffffffff813561aa>]
_raw_spin_lock_irqsave+0x44/0x57
                            [<ffffffffa00a84cc>] iwl_isr_ict+0x37/0x1df [iwlagn]
                            [<ffffffff8107a746>] handle_IRQ_event+0x26/0xb4
                            [<ffffffff8107c78e>] handle_edge_irq+0xf7/0x143
                            [<ffffffff810045e7>] handle_irq+0x83/0x8b
                            [<ffffffff810042b6>] do_IRQ+0x48/0x9f
                            [<ffffffff81356d93>] ret_from_intr+0x0/0xf
                            [<ffffffff811a3621>] __raw_spin_lock_init+0x31/0x51
                            [<ffffffff810d5bdd>] inode_init_once+0xa7/0x117
                            [<ffffffff8112fa99>] init_once+0x5e/0x62
                            [<ffffffff810ba827>] setup_object.clone.35+0x3b/0x40
                            [<ffffffff810ba963>] new_slab+0x137/0x193
                            [<ffffffff810bb547>]
__slab_alloc.clone.56+0x154/0x22f
                            [<ffffffff810bb67a>] kmem_cache_alloc+0x58/0xab
                            [<ffffffff8112f2d6>] ext4_alloc_inode+0x1b/0x14b
                            [<ffffffff810d5f5b>] alloc_inode+0x18/0x73
                            [<ffffffff810d6b37>] iget_locked+0x47/0xee
                            [<ffffffff81124792>] ext4_iget+0x27/0x6c0
                            [<ffffffff8112c322>] ext4_lookup+0x92/0xe7
                            [<ffffffff810ca748>] d_alloc_and_lookup+0x40/0x68
                            [<ffffffff810caaf9>] do_lookup+0x181/0x1e0
                            [<ffffffff810cbf01>] link_path_walk+0x247/0x444
                            [<ffffffff810cbc1f>] do_follow_link+0x1ac/0x247
                            [<ffffffff810cbf71>] link_path_walk+0x2b7/0x444
                            [<ffffffff810cc325>] do_path_lookup+0x4b/0xf3
                            [<ffffffff810cc777>] user_path_at+0x4f/0x93
                            [<ffffffff810c0994>] sys_faccessat+0x9b/0x15d
                            [<ffffffff810c0a69>] sys_access+0x13/0x15
                            [<ffffffff8100217b>] system_call_fastpath+0x16/0x1b
     IN-SOFTIRQ-W at:
                            [<ffffffff8105c287>] __lock_acquire+0x319/0xdcd
                            [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                            [<ffffffff813561aa>]
_raw_spin_lock_irqsave+0x44/0x57
                            [<ffffffffa0099ccb>]
iwl_irq_tasklet+0x1d/0x342 [iwlagn]
                            [<ffffffff81038c56>] tasklet_action+0x85/0xd8
                            [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
                            [<ffffffff8100304c>] call_softirq+0x1c/0x28
                            [<ffffffff81004627>] do_softirq+0x38/0x81
                            [<ffffffff81039458>] irq_exit+0x44/0x92
                            [<ffffffff810042f6>] do_IRQ+0x88/0x9f
                            [<ffffffff81356d93>] ret_from_intr+0x0/0xf
                            [<ffffffff811a3621>] __raw_spin_lock_init+0x31/0x51
                            [<ffffffff810d5bdd>] inode_init_once+0xa7/0x117
                            [<ffffffff8112fa99>] init_once+0x5e/0x62
                            [<ffffffff810ba827>] setup_object.clone.35+0x3b/0x40
                            [<ffffffff810ba963>] new_slab+0x137/0x193
                            [<ffffffff810bb547>]
__slab_alloc.clone.56+0x154/0x22f
                            [<ffffffff810bb67a>] kmem_cache_alloc+0x58/0xab
                            [<ffffffff8112f2d6>] ext4_alloc_inode+0x1b/0x14b
                            [<ffffffff810d5f5b>] alloc_inode+0x18/0x73
                            [<ffffffff810d6b37>] iget_locked+0x47/0xee
                            [<ffffffff81124792>] ext4_iget+0x27/0x6c0
                            [<ffffffff8112c322>] ext4_lookup+0x92/0xe7
                            [<ffffffff810ca748>] d_alloc_and_lookup+0x40/0x68
                            [<ffffffff810caaf9>] do_lookup+0x181/0x1e0
                            [<ffffffff810cbf01>] link_path_walk+0x247/0x444
                            [<ffffffff810cbc1f>] do_follow_link+0x1ac/0x247
                            [<ffffffff810cbf71>] link_path_walk+0x2b7/0x444
                            [<ffffffff810cc325>] do_path_lookup+0x4b/0xf3
                            [<ffffffff810cc777>] user_path_at+0x4f/0x93
                            [<ffffffff810c0994>] sys_faccessat+0x9b/0x15d
                            [<ffffffff810c0a69>] sys_access+0x13/0x15
                            [<ffffffff8100217b>] system_call_fastpath+0x16/0x1b
     INITIAL USE at:
                           [<ffffffff8105c365>] __lock_acquire+0x3f7/0xdcd
                           [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                           [<ffffffff813561aa>] _raw_spin_lock_irqsave+0x44/0x57
                           [<ffffffffa009897e>]
iwl_pci_probe+0x706/0xe2c [iwlagn]
                           [<ffffffff811b2f9e>] local_pci_probe+0x3f/0x70
                           [<ffffffff811b3528>] pci_device_probe+0x65/0x96
                           [<ffffffff8124dca8>] driver_probe_device+0xbc/0x157
                           [<ffffffff8124dd8d>] __driver_attach+0x4a/0x6b
                           [<ffffffff8124cef6>] bus_for_each_dev+0x57/0x83
                           [<ffffffff8124d999>] driver_attach+0x19/0x1b
                           [<ffffffff8124d5dc>] bus_add_driver+0xae/0x204
                           [<ffffffff8124dfca>] driver_register+0x96/0x103
                           [<ffffffff811b375a>] __pci_register_driver+0x61/0xcd
                           [<ffffffffa007105c>]
uvc_clock_param_set+0xc/0x70 [uvcvideo]
                           [<ffffffff81000336>] do_one_initcall+0x7a/0x130
                           [<ffffffff810667f3>] sys_init_module+0xa1/0x1e1
                           [<ffffffff8100217b>] system_call_fastpath+0x16/0x1b
   }
   ... key      at: [<ffffffffa00afe50>]
__key.39196+0x0/0xffffffffffff9796 [iwlagn]
   ... acquired at:
   [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
   [<ffffffff813560b1>] _raw_spin_lock+0x36/0x45
   [<ffffffffa009f8c9>] iwlagn_tx_skb+0x139/0x9e2 [iwlagn]
   [<ffffffffa0096479>] iwlagn_mac_tx+0x15/0x27 [iwlagn]
   [<ffffffffa01d83c6>] __ieee80211_tx+0x140/0x1d5 [mac80211]
   [<ffffffffa01d99f0>] ieee80211_tx+0xc4/0x208 [mac80211]
   [<ffffffffa01d9cd3>] ieee80211_xmit+0x19f/0x1b3 [mac80211]
   [<ffffffffa01dae7c>] ieee80211_tx_skb+0x4a/0x52 [mac80211]
   [<ffffffffa01dccbb>] ieee80211_send_auth+0x17f/0x18e [mac80211]
   [<ffffffffa01cdf2e>] ieee80211_work_work+0x5a0/0xef3 [mac80211]
   [<ffffffff81046c05>] process_one_work+0x1b4/0x2f2
   [<ffffffff81048012>] worker_thread+0xff/0x19f
   [<ffffffff8104b83b>] kthread+0x9d/0xa5
   [<ffffffff81002f54>] kernel_thread_helper+0x4/0x10

 -> (&(&priv->sta_lock)->rlock){..-...} ops: 39 {
    IN-SOFTIRQ-W at:
                          [<ffffffff8105c287>] __lock_acquire+0x319/0xdcd
                          [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                          [<ffffffff813561aa>] _raw_spin_lock_irqsave+0x44/0x57
                          [<ffffffffa00a2de6>]
iwlagn_rx_reply_tx+0x596/0x5ba [iwlagn]
                          [<ffffffffa0099821>]
iwl_rx_handle+0x17e/0x2ed [iwlagn]
                          [<ffffffffa0099f14>]
iwl_irq_tasklet+0x266/0x342 [iwlagn]
                          [<ffffffff81038c56>] tasklet_action+0x85/0xd8
                          [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
                          [<ffffffff8100304c>] call_softirq+0x1c/0x28
                          [<ffffffff81004627>] do_softirq+0x38/0x81
                          [<ffffffff81039458>] irq_exit+0x44/0x92
                          [<ffffffff810042f6>] do_IRQ+0x88/0x9f
                          [<ffffffff81356d93>] ret_from_intr+0x0/0xf
    INITIAL USE at:
                         [<ffffffff8105c365>] __lock_acquire+0x3f7/0xdcd
                         [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                         [<ffffffff813561aa>] _raw_spin_lock_irqsave+0x44/0x57
                         [<ffffffffa00a64f4>]
iwlagn_alloc_bcast_station+0x27/0xfa [iwlagn]
                         [<ffffffffa0097c15>] __iwl_up+0xa2/0x2e8 [iwlagn]
                         [<ffffffffa0097fd5>]
iwlagn_mac_start+0x2e/0x159 [iwlagn]
                         [<ffffffffa01d05b4>]
ieee80211_do_open+0xd4/0x454 [mac80211]
                         [<ffffffffa01d0987>] ieee80211_open+0x53/0x58
[mac80211]
                         [<ffffffff812cfd25>] __dev_open+0x96/0xcd
                         [<ffffffff812cff55>] __dev_change_flags+0xa8/0x12c
                         [<ffffffff812d0050>] dev_change_flags+0x1c/0x51
                         [<ffffffff812da953>] do_setlink+0x2b0/0x676
                         [<ffffffff812db2a3>] rtnl_setlink+0xca/0xea
                         [<ffffffff812db583>] rtnetlink_rcv_msg+0x1e9/0x1ff
                         [<ffffffff812e9bca>] netlink_rcv_skb+0x40/0x8b
                         [<ffffffff812daf9f>] rtnetlink_rcv+0x21/0x28
                         [<ffffffff812e96bb>] netlink_unicast+0xe6/0x150
                         [<ffffffff812e99d2>] netlink_sendmsg+0x2ad/0x2cb
                         [<ffffffff812bbfdf>] __sock_sendmsg+0x66/0x72
                         [<ffffffff812bc6fd>] sock_sendmsg+0x9c/0xb1
                         [<ffffffff812be049>] sys_sendmsg+0x245/0x2c3
                         [<ffffffff8100217b>] system_call_fastpath+0x16/0x1b
  }
  ... key      at: [<ffffffffa00afe78>]
__key.39154+0x0/0xffffffffffff976e [iwlagn]
  ... acquired at:
   [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
   [<ffffffff813561aa>] _raw_spin_lock_irqsave+0x44/0x57
   [<ffffffff812c2c00>] skb_queue_tail+0x1f/0x48
   [<ffffffffa01c2c96>] ieee80211_tx_status_irqsafe+0x37/0x8d [mac80211]
   [<ffffffffa00a0c4f>] iwlagn_tx_queue_reclaim+0x13b/0x1d8 [iwlagn]
   [<ffffffffa00a2d20>] iwlagn_rx_reply_tx+0x4d0/0x5ba [iwlagn]
   [<ffffffffa0099821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
   [<ffffffffa0099f14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
   [<ffffffff81038c56>] tasklet_action+0x85/0xd8
   [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
   [<ffffffff8100304c>] call_softirq+0x1c/0x28
   [<ffffffff81004627>] do_softirq+0x38/0x81
   [<ffffffff81039458>] irq_exit+0x44/0x92
   [<ffffffff810042f6>] do_IRQ+0x88/0x9f
   [<ffffffff81356d93>] ret_from_intr+0x0/0xf

-> (&(&list->lock)->rlock#7){+.-...} ops: 3 {
   HARDIRQ-ON-W at:
                        [<ffffffff8105c2e4>] __lock_acquire+0x376/0xdcd
                        [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                        [<ffffffff813560b1>] _raw_spin_lock+0x36/0x45
                        [<ffffffffa01d4ecc>]
ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
                        [<ffffffffa01d7146>]
ieee80211_prepare_and_rx_handle+0x7cd/0x80a [mac80211]
                        [<ffffffffa01d796f>] ieee80211_rx+0x785/0x7af [mac80211]
                        [<ffffffffa00a2730>]
iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
                        [<ffffffffa0099821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                        [<ffffffffa0099f14>]
iwl_irq_tasklet+0x266/0x342 [iwlagn]
                        [<ffffffff81038c56>] tasklet_action+0x85/0xd8
                        [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
                        [<ffffffff8100304c>] call_softirq+0x1c/0x28
                        [<ffffffff81004627>] do_softirq+0x38/0x81
                        [<ffffffff81039458>] irq_exit+0x44/0x92
                        [<ffffffff810042f6>] do_IRQ+0x88/0x9f
                        [<ffffffff81356d93>] ret_from_intr+0x0/0xf
   IN-SOFTIRQ-W at:
                        [<ffffffff8105c287>] __lock_acquire+0x319/0xdcd
                        [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                        [<ffffffff813561aa>] _raw_spin_lock_irqsave+0x44/0x57
                        [<ffffffff812c2c00>] skb_queue_tail+0x1f/0x48
                        [<ffffffffa01c2c96>]
ieee80211_tx_status_irqsafe+0x37/0x8d [mac80211]
                        [<ffffffffa00a0c4f>]
iwlagn_tx_queue_reclaim+0x13b/0x1d8 [iwlagn]
                        [<ffffffffa00a2d20>]
iwlagn_rx_reply_tx+0x4d0/0x5ba [iwlagn]
                        [<ffffffffa0099821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                        [<ffffffffa0099f14>]
iwl_irq_tasklet+0x266/0x342 [iwlagn]
                        [<ffffffff81038c56>] tasklet_action+0x85/0xd8
                        [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
                        [<ffffffff8100304c>] call_softirq+0x1c/0x28
                        [<ffffffff81004627>] do_softirq+0x38/0x81
                        [<ffffffff81039458>] irq_exit+0x44/0x92
                        [<ffffffff810042f6>] do_IRQ+0x88/0x9f
                        [<ffffffff81356d93>] ret_from_intr+0x0/0xf
   INITIAL USE at:
                       [<ffffffff8105c365>] __lock_acquire+0x3f7/0xdcd
                       [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
                       [<ffffffff813561aa>] _raw_spin_lock_irqsave+0x44/0x57
                       [<ffffffff812c2c00>] skb_queue_tail+0x1f/0x48
                       [<ffffffffa01c2c96>]
ieee80211_tx_status_irqsafe+0x37/0x8d [mac80211]
                       [<ffffffffa00a0c4f>]
iwlagn_tx_queue_reclaim+0x13b/0x1d8 [iwlagn]
                       [<ffffffffa00a2d20>]
iwlagn_rx_reply_tx+0x4d0/0x5ba [iwlagn]
                       [<ffffffffa0099821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                       [<ffffffffa0099f14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
                       [<ffffffff81038c56>] tasklet_action+0x85/0xd8
                       [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
                       [<ffffffff8100304c>] call_softirq+0x1c/0x28
                       [<ffffffff81004627>] do_softirq+0x38/0x81
                       [<ffffffff81039458>] irq_exit+0x44/0x92
                       [<ffffffff810042f6>] do_IRQ+0x88/0x9f
                       [<ffffffff81356d93>] ret_from_intr+0x0/0xf
 }
 ... key      at: [<ffffffffa01e7b50>]
__key.17454+0x0/0xffffffffffffc7e0 [mac80211]
 ... acquired at:
   [<ffffffff8105a488>] check_usage_backwards+0x6a/0x75
   [<ffffffff8105ad3d>] mark_lock+0xff/0x210
   [<ffffffff8105c2e4>] __lock_acquire+0x376/0xdcd
   [<ffffffff8105d1b7>] lock_acquire+0x8a/0xa2
   [<ffffffff813560b1>] _raw_spin_lock+0x36/0x45
   [<ffffffffa01d4ecc>] ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
   [<ffffffffa01d7146>] ieee80211_prepare_and_rx_handle+0x7cd/0x80a [mac80211]
   [<ffffffffa01d796f>] ieee80211_rx+0x785/0x7af [mac80211]
   [<ffffffffa00a2730>] iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
   [<ffffffffa0099821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
   [<ffffffffa0099f14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
   [<ffffffff81038c56>] tasklet_action+0x85/0xd8
   [<ffffffff8103930d>] __do_softirq+0xb8/0x15a
   [<ffffffff8100304c>] call_softirq+0x1c/0x28
   [<ffffffff81004627>] do_softirq+0x38/0x81
   [<ffffffff81039458>] irq_exit+0x44/0x92
   [<ffffffff810042f6>] do_IRQ+0x88/0x9f
   [<ffffffff81356d93>] ret_from_intr+0x0/0xf


stack backtrace:
Pid: 1512, comm: dbus-daemon Not tainted 2.6.37-git5 #1
Call Trace:
 <IRQ>  [<ffffffff8105a395>] ? print_irq_inversion_bug+0x11d/0x12e
 [<ffffffff8105a41e>] ? check_usage_backwards+0x0/0x75
 [<ffffffff8105a41e>] ? check_usage_backwards+0x0/0x75
 [<ffffffff8105a488>] ? check_usage_backwards+0x6a/0x75
 [<ffffffff8105aad9>] ? valid_state+0x2b/0x190
 [<ffffffff8105ad3d>] ? mark_lock+0xff/0x210
 [<ffffffff8105c2e4>] ? __lock_acquire+0x376/0xdcd
 [<ffffffff8101ff66>] ? static_protections+0x59/0x11f
 [<ffffffff8105ac6b>] ? mark_lock+0x2d/0x210
 [<ffffffff8105d1b7>] ? lock_acquire+0x8a/0xa2
 [<ffffffffa01d4ecc>] ? ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
 [<ffffffff813560b1>] ? _raw_spin_lock+0x36/0x45
 [<ffffffffa01d4ecc>] ? ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
 [<ffffffff81093fe0>] ? __free_pages_ok+0xa3/0x110
 [<ffffffffa01d4ecc>] ? ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
 [<ffffffff8105ac6b>] ? mark_lock+0x2d/0x210
 [<ffffffff8105ae9e>] ? mark_held_locks+0x50/0x72
 [<ffffffff813566a4>] ? _raw_spin_unlock_irqrestore+0x3a/0x69
 [<ffffffff8105afff>] ? trace_hardirqs_on_caller+0x13f/0x172
 [<ffffffff813566c5>] ? _raw_spin_unlock_irqrestore+0x5b/0x69
 [<ffffffffa01d7146>] ? ieee80211_prepare_and_rx_handle+0x7cd/0x80a [mac80211]
 [<ffffffffa01d796f>] ? ieee80211_rx+0x785/0x7af [mac80211]
 [<ffffffffa00a2730>] ? iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
 [<ffffffffa0099821>] ? iwl_rx_handle+0x17e/0x2ed [iwlagn]
 [<ffffffffa0099f14>] ? iwl_irq_tasklet+0x266/0x342 [iwlagn]
 [<ffffffff81038c56>] ? tasklet_action+0x85/0xd8
 [<ffffffff8103930d>] ? __do_softirq+0xb8/0x15a
 [<ffffffff8100304c>] ? call_softirq+0x1c/0x28
 [<ffffffff81004627>] ? do_softirq+0x38/0x81
 [<ffffffff81039458>] ? irq_exit+0x44/0x92
 [<ffffffff810042f6>] ? do_IRQ+0x88/0x9f
 [<ffffffff81356d93>] ? ret_from_intr+0x0/0xf
 <EOI>
