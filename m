Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab1FJUht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:37:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab1FJUhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lbEJghJ+T0zCx4rNaC4WkiKrlWuPyYBkq9vW74rdOqR0Yj2WzLGgFkHTZqZ8SXQh0J
         es773a0BoFE2O7yuUWV37/Q03Fmfph6l/R1uG74DVO5pniJDmmpJ75gJqUePZYFaNIio
         rGiBfXZO2t5C7i6jzEBuWqQsnJetIpKk4FN0E=
MIME-Version: 1.0
Date: Fri, 10 Jun 2011 16:37:44 -0400
Message-ID: <BANLkTinC43QH_iEY29_Umt87Sn3A5GGQ3A@mail.gmail.com>
Subject: 3.0.0-rc2-git4 -- INFO: possible circular locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  330.762815] [ INFO: possible circular locking dependency detected ]
[  330.762819] 3.0.0-rc2-git4 #9
[  330.762822] -------------------------------------------------------
[  330.762825] kworker/0:0/4 is trying to acquire lock:
[  330.762828]  (&rdev->mtx){+.+.+.}, at: [<ffffffffa006f7e0>]
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.762845]
[  330.762846] but task is already holding lock:
[  330.762848]  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffffa006fd5c>]
cfg80211_rfkill_set_block+0x28/0x70 [cfg80211]
[  330.762860]
[  330.762861] which lock already depends on the new lock.
[  330.762863]
[  330.762865]
[  330.762866] the existing dependency chain (in reverse order) is:
[  330.762869]
[  330.762870] -> #1 (&rdev->devlist_mtx){+.+.+.}:
[  330.762875]        [<ffffffff81066aaa>] lock_acquire+0xda/0xff
[  330.762884]        [<ffffffff813f25ba>] __mutex_lock_common+0x47/0x31d
[  330.762891]        [<ffffffff813f298b>] mutex_lock_nested+0x3b/0x40
[  330.762896]        [<ffffffffa006f8f0>]
cfg80211_netdev_notifier_call+0x385/0x4ff [cfg80211]
[  330.762906]        [<ffffffff813f6d0e>] notifier_call_chain.isra.2+0x7c/0xb3
[  330.762912]        [<ffffffff81057893>] raw_notifier_call_chain+0x12/0x14
[  330.762918]        [<ffffffff81351a86>] call_netdevice_notifiers+0x45/0x4a
[  330.762925]        [<ffffffff81357091>] __dev_notify_flags+0x32/0x56
[  330.762930]        [<ffffffff813570f8>] dev_change_flags+0x43/0x4f
[  330.762936]        [<ffffffff81362793>] do_setlink+0x2ab/0x774
[  330.762941]        [<ffffffff81362eb3>] rtnl_setlink+0xc8/0xe8
[  330.762946]        [<ffffffff813631b2>] rtnetlink_rcv_msg+0x1e8/0x1fe
[  330.762952]        [<ffffffff8137564f>] netlink_rcv_skb+0x3e/0x8a
[  330.762958]        [<ffffffff813622e4>] rtnetlink_rcv+0x21/0x28
[  330.762963]        [<ffffffff8137514f>] netlink_unicast+0xe7/0x151
[  330.762968]        [<ffffffff81375448>] netlink_sendmsg+0x28f/0x2d0
[  330.762973]        [<ffffffff813422aa>] sock_sendmsg+0xe1/0x104
[  330.762980]        [<ffffffff81343ea5>] __sys_sendmsg+0x1d9/0x25d
[  330.762985]        [<ffffffff8134502d>] sys_sendmsg+0x3d/0x5b
[  330.762990]        [<ffffffff813f9fbb>] system_call_fastpath+0x16/0x1b
[  330.762996]
[  330.762997] -> #0 (&rdev->mtx){+.+.+.}:
[  330.763003]        [<ffffffff8106631a>] __lock_acquire+0xa5e/0xd52
[  330.763008]        [<ffffffff81066aaa>] lock_acquire+0xda/0xff
[  330.763013]        [<ffffffff813f25ba>] __mutex_lock_common+0x47/0x31d
[  330.763019]        [<ffffffff813f298b>] mutex_lock_nested+0x3b/0x40
[  330.763024]        [<ffffffffa006f7e0>]
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.763033]        [<ffffffff813f6d0e>] notifier_call_chain.isra.2+0x7c/0xb3
[  330.763039]        [<ffffffff81057893>] raw_notifier_call_chain+0x12/0x14
[  330.763044]        [<ffffffff81351a86>] call_netdevice_notifiers+0x45/0x4a
[  330.763049]        [<ffffffff81351ae5>] __dev_close_many+0x5a/0xd1
[  330.763054]        [<ffffffff81351c1a>] dev_close_many+0x7a/0xea
[  330.763059]        [<ffffffff81354abf>] dev_close+0x38/0x49
[  330.763064]        [<ffffffffa006fd7a>]
cfg80211_rfkill_set_block+0x46/0x70 [cfg80211]
[  330.763073]        [<ffffffffa001acbd>] rfkill_set_block+0x80/0xf1 [rfkill]
[  330.763081]        [<ffffffffa001ae84>]
__rfkill_switch_all+0x3c/0x62 [rfkill]
[  330.763089]        [<ffffffffa001b3db>] rfkill_switch_all+0x38/0x49 [rfkill]
[  330.763096]        [<ffffffffa001b618>]
rfkill_op_handler+0x104/0x135 [rfkill]
[  330.763104]        [<ffffffff8104e564>] process_one_work+0x1c8/0x353
[  330.763109]        [<ffffffff8104f70b>] worker_thread+0xd5/0x159
[  330.763115]        [<ffffffff81052c82>] kthread+0x9a/0xa2
[  330.763120]        [<ffffffff813fb114>] kernel_thread_helper+0x4/0x10
[  330.763126]
[  330.763127] other info that might help us debug this:
[  330.763128]
[  330.763131]  Possible unsafe locking scenario:
[  330.763132]
[  330.763134]        CPU0                    CPU1
[  330.763136]        ----                    ----
[  330.763139]   lock(&rdev->devlist_mtx);
[  330.763143]                                lock(&rdev->mtx);
[  330.763147]                                lock(&rdev->devlist_mtx);
[  330.763151]   lock(&rdev->mtx);
[  330.763155]
[  330.763156]  *** DEADLOCK ***
[  330.763157]
[  330.763160] 5 locks held by kworker/0:0/4:
[  330.763163]  #0:  (events){.+.+.+}, at: [<ffffffff8104e4c7>]
process_one_work+0x12b/0x353
[  330.763172]  #1:  ((rfkill_op_work).work){+.+...}, at:
[<ffffffff8104e4c7>] process_one_work+0x12b/0x353
[  330.763181]  #2:  (rfkill_global_mutex){+.+.+.}, at:
[<ffffffffa001b3c7>] rfkill_switch_all+0x24/0x49 [rfkill]
[  330.763191]  #3:  (rtnl_mutex){+.+.+.}, at: [<ffffffff813622c1>]
rtnl_lock+0x12/0x14
[  330.763201]  #4:  (&rdev->devlist_mtx){+.+.+.}, at:
[<ffffffffa006fd5c>] cfg80211_rfkill_set_block+0x28/0x70 [cfg80211]
[  330.763214]
[  330.763214] stack backtrace:
[  330.763218] Pid: 4, comm: kworker/0:0 Not tainted 3.0.0-rc2-git4 #9
[  330.763221] Call Trace:
[  330.763228]  [<ffffffff813eb618>] print_circular_bug+0x1f8/0x209
[  330.763234]  [<ffffffff8106631a>] __lock_acquire+0xa5e/0xd52
[  330.763245]  [<ffffffffa006f7e0>] ?
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.763251]  [<ffffffff81066aaa>] lock_acquire+0xda/0xff
[  330.763260]  [<ffffffffa006f7e0>] ?
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.763267]  [<ffffffff813f25ba>] __mutex_lock_common+0x47/0x31d
[  330.763271]  [<ffffffffa006f7e0>] ?
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.763271]  [<ffffffffa006f7e0>] ?
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.763271]  [<ffffffffa006f56b>] ? cfg80211_unlock_rdev+0x1f/0x1f [cfg80211]
[  330.763271]  [<ffffffff813f298b>] mutex_lock_nested+0x3b/0x40
[  330.763271]  [<ffffffffa006f7e0>]
cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
[  330.763271]  [<ffffffff813f6d0e>] notifier_call_chain.isra.2+0x7c/0xb3
[  330.763271]  [<ffffffff81057893>] raw_notifier_call_chain+0x12/0x14
[  330.763271]  [<ffffffff81351a86>] call_netdevice_notifiers+0x45/0x4a
[  330.763271]  [<ffffffff81351ae5>] __dev_close_many+0x5a/0xd1
[  330.763271]  [<ffffffff81351c1a>] dev_close_many+0x7a/0xea
[  330.763271]  [<ffffffff81354abf>] dev_close+0x38/0x49
[  330.763271]  [<ffffffffa006fd7a>]
cfg80211_rfkill_set_block+0x46/0x70 [cfg80211]
[  330.763271]  [<ffffffffa001acbd>] rfkill_set_block+0x80/0xf1 [rfkill]
[  330.763271]  [<ffffffffa001ae84>] __rfkill_switch_all+0x3c/0x62 [rfkill]
[  330.763271]  [<ffffffffa001b3db>] rfkill_switch_all+0x38/0x49 [rfkill]
[  330.763271]  [<ffffffffa001b618>] rfkill_op_handler+0x104/0x135 [rfkill]
[  330.763271]  [<ffffffff8104e564>] process_one_work+0x1c8/0x353
[  330.763271]  [<ffffffff8104e4c7>] ? process_one_work+0x12b/0x353
[  330.763271]  [<ffffffffa001b514>] ?
rfkill_get_global_sw_state+0x12/0x12 [rfkill]
[  330.763271]  [<ffffffff8104f70b>] worker_thread+0xd5/0x159
[  330.763271]  [<ffffffff8104f636>] ? manage_workers.isra.22+0x16a/0x16a
[  330.763271]  [<ffffffff81052c82>] kthread+0x9a/0xa2
[  330.763271]  [<ffffffff813fb114>] kernel_thread_helper+0x4/0x10
[  330.763271]  [<ffffffff81029bdb>] ? finish_task_switch+0x42/0xbb
[  330.763271]  [<ffffffff8100164b>] ? __switch_to+0xbc/0x1fb
[  330.763271]  [<ffffffff813f3e40>] ? retint_restore_args+0xe/0xe
[  330.763271]  [<ffffffff81052be8>] ? __init_kthread_worker+0x55/0x55
[  330.763271]  [<ffffffff813fb110>] ? gs_change+0xb/0xb
