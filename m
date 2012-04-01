Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2DANbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:31:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2DANbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACPM=kX8KrOMBej7N9A-gpMO4PQ5KnOsn1R2=GB8pUojZAuc8Q@mail.gmail.com>
References: <CACPM=kXZQzOOfPLTAXH9rddwGZ=pfAex76MFso21D9Ua=HtkYA@mail.gmail.com>
	<20120401035213.GU2450@linux.vnet.ibm.com>
	<CACPM=kWZ-dbcj5zeV=RU7Mu5oWEFLcryJ+ZduCuBdQZeURqdNw@mail.gmail.com>
	<CACPM=kX8KrOMBej7N9A-gpMO4PQ5KnOsn1R2=GB8pUojZAuc8Q@mail.gmail.com>
Date: Sun, 1 Apr 2012 15:31:00 +0200
Message-ID: <CACPM=kUbjrRb-gYKNX3+JkOgvh6nnOuqDO=NqZU4zcT_KtBFsw@mail.gmail.com>
Subject: Re: Regression introduced by 19b4a8d520a6e0176dd52aaa429261ad4fcaa545
 (p54 driver fails with WARNING) , bisected
From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. apr. 2012 14.32 skrev Bjarke Istrup Pedersen <gurligebis@gmail.com>:
> 1. apr. 2012 12.55 skrev Bjarke Istrup Pedersen <gurligebis@gmail.com>:
>> 1. apr. 2012 05.52 skrev Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>>> On Sun, Mar 25, 2012 at 01:41:23PM +0200, Bjarke Istrup Pedersen wrote:
>>>> Hey,
>>>>
>>>> I'm having a problem with the p54 driver, which seems to be caused by
>>>> the commit 19b4a8d520a6e0176dd52aaa429261ad4fcaa545 (found out by
>>>> bisecting between v3.1 and v3.2-rc1)
>>>>
>>>> I'm however unable to spot what in that commit causes the problem,
>>>> since it is a merge.
>>>>
>>>> I have attached the bisect log and the 3 warnings the kernel spit out.
>>>>
>>>> ----- BISECT LOG START -----
>>>>
>>>> git bisect start
>>>> # good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
>>>> git bisect good c3b92c8787367a8bb53d57d9789b558f1295cc96
>>>> # bad: [1ea6b8f48918282bdca0b32a34095504ee65bab5] Linux 3.2-rc1
>>>> git bisect bad 1ea6b8f48918282bdca0b32a34095504ee65bab5
>>>> # bad: [37be944a0270402f9cda291a930b0286f6dc92f5] Merge branch
>>>> 'drm-core-next' of git://people.freedesktop.org/~airlied/linux
>>>> git bisect bad 37be944a0270402f9cda291a930b0286f6dc92f5
>>>> # good: [7e0bb71e75020348bee523720a0c2f04cc72f540] Merge branch
>>>> 'pm-for-linus' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
>>>> git bisect good 7e0bb71e75020348bee523720a0c2f04cc72f540
>>>> # good: [46a971913611a23478283931460a95be962ce329] Staging: hv: move
>>>> hyperv code out of staging directory
>>>> git bisect good 46a971913611a23478283931460a95be962ce329
>>>> # bad: [8a4a8918ed6e4a361f4df19f199bbc2d0a89a46c] Merge branch
>>>> 'sched-core-for-linus' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>> git bisect bad 8a4a8918ed6e4a361f4df19f199bbc2d0a89a46c
>>>> # good: [aa77677e0a288e08073620db5d2a31df83ca4788] Merge branch
>>>> 'staging-next' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
>>>> git bisect good aa77677e0a288e08073620db5d2a31df83ca4788
>>>> # good: [c752d04066a36ae30b29795f3fa3f536292c1f8c] perf symbols:
>>>> Increase symbol KSYM_NAME_LEN size
>>>> git bisect good c752d04066a36ae30b29795f3fa3f536292c1f8c
>>>> # bad: [19b4a8d520a6e0176dd52aaa429261ad4fcaa545] Merge branch
>>>> 'core-rcu-for-linus' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>> git bisect bad 19b4a8d520a6e0176dd52aaa429261ad4fcaa545
>>>> # good: [048b718029033af117870d3da47da12995be14a3] Merge branch
>>>> 'rcu/next' of git://github.com/paulmckrcu/linux into core/rcu
>>>> git bisect good 048b718029033af117870d3da47da12995be14a3
>>>> # good: [96f8e98bfeba3efa82eca85343bc058f6eced888] locking, x86,
>>>> iommu: Annotate irq_2_ir_lock as raw
>>>> git bisect good 96f8e98bfeba3efa82eca85343bc058f6eced888
>>>> # good: [c020570138f5d9cb1fc0a853f9cf9e641178b5c5] x86, ioapic:
>>>> Consolidate the explicit EOI code
>>>> git bisect good c020570138f5d9cb1fc0a853f9cf9e641178b5c5
>>>> # good: [68cc3990a545dc0da221b4844dd8b9c06623a6c5] rtmutex: Add
>>>> missing rcu_read_unlock() in debug_rt_mutex_print_deadlock()
>>>> git bisect good 68cc3990a545dc0da221b4844dd8b9c06623a6c5
>>>> # good: [08613e4626c06ca408fc55071f6aedee36986a87] caif: Fix BUG()
>>>> with network namespaces
>>>> git bisect good 08613e4626c06ca408fc55071f6aedee36986a87
>>>> # good: [982653009b883ef1529089e3e6f1ae2fee41cbe2] Merge branch
>>>> 'core-iommu-for-linus' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>> git bisect good 982653009b883ef1529089e3e6f1ae2fee41cbe2
>>>> # good: [3cfef9524677a4ecb392d6fbffe6ebce6302f1d4] Merge branch
>>>> 'core-locking-for-linus' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>>> git bisect good 3cfef9524677a4ecb392d6fbffe6ebce6302f1d4
>>>>
>>>> Result: 19b4a8d520a6e0176dd52aaa429261ad4fcaa545 is the first bad commit
>>>>
>>>> ----- BISECT LOG END -----
>>>>
>>>> ----- KERNEL WARNINGS START -----
>>>>
>>>> ------------[ cut here ]------------
>>>> WARNING: at drivers/net/wireless/p54/main.c:348 p54_config+0x179/0x1d8()
>>>> Pid: 2529, comm: hostapd Not tainted 3.3.0 #2
>>>> Call Trace:
>>>>  [<c102511d>] ? warn_slowpath_common+0x65/0x78
>>>>  [<c11e579c>] ? p54_config+0x179/0x1d8
>>>>  [<c10251ab>] ? warn_slowpath_null+0xd/0x12
>>>>  [<c11e579c>] ? p54_config+0x179/0x1d8
>>>>  [<c12ee0ce>] ? ieee80211_hw_config+0xe7/0xef
>>>>  [<c12fc641>] ? ieee80211_do_open+0x3ab/0x46f
>>>>  [<c120b374>] ? __dev_open+0x74/0x9b
>>>>  [<c120b59b>] ? __dev_change_flags+0x8c/0x101
>>>>  [<c120b671>] ? dev_change_flags+0x10/0x3b
>>>>  [<c1256af7>] ? devinet_ioctl+0x254/0x4c4
>>>>  [<c120bf62>] ? dev_ioctl+0x543/0x586
>>>>  [<c11fd890>] ? sock_ioctl+0x163/0x185
>>>>  [<c11fd72d>] ? sock_fasync+0x5e/0x5e
>>>>  [<c108e92d>] ? do_vfs_ioctl+0x44d/0x486
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1090ce0>] ? dput+0xa1/0xa9
>>>>  [<c10842ac>] ? fput+0x126/0x13e
>>>>  [<c1094dfa>] ? mnt_add_count.clone.18+0x17/0x21
>>>>  [<c108e9aa>] ? sys_ioctl+0x44/0x66
>>>>  [<c1317431>] ? syscall_call+0x7/0xb
>>>> ---[ end trace 7c0a20dadc443bc0 ]---
>>>> ------------[ cut here ]------------
>>>> WARNING: at drivers/net/wireless/p54/main.c:351 p54_config+0x19e/0x1d8()
>>>> Pid: 2529, comm: hostapd Tainted: G        W    3.3.0 #2
>>>> Call Trace:
>>>>  [<c102511d>] ? warn_slowpath_common+0x65/0x78
>>>>  [<c11e57c1>] ? p54_config+0x19e/0x1d8
>>>>  [<c10251ab>] ? warn_slowpath_null+0xd/0x12
>>>>  [<c11e57c1>] ? p54_config+0x19e/0x1d8
>>>>  [<c12ee0ce>] ? ieee80211_hw_config+0xe7/0xef
>>>>  [<c12fc641>] ? ieee80211_do_open+0x3ab/0x46f
>>>>  [<c120b374>] ? __dev_open+0x74/0x9b
>>>>  [<c120b59b>] ? __dev_change_flags+0x8c/0x101
>>>>  [<c120b671>] ? dev_change_flags+0x10/0x3b
>>>>  [<c1256af7>] ? devinet_ioctl+0x254/0x4c4
>>>>  [<c120bf62>] ? dev_ioctl+0x543/0x586
>>>>  [<c11fd890>] ? sock_ioctl+0x163/0x185
>>>>  [<c11fd72d>] ? sock_fasync+0x5e/0x5e
>>>>  [<c108e92d>] ? do_vfs_ioctl+0x44d/0x486
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1090ce0>] ? dput+0xa1/0xa9
>>>>  [<c10842ac>] ? fput+0x126/0x13e
>>>>  [<c1094dfa>] ? mnt_add_count.clone.18+0x17/0x21
>>>>  [<c108e9aa>] ? sys_ioctl+0x44/0x66
>>>>  [<c1317431>] ? syscall_call+0x7/0xb
>>>> ---[ end trace 7c0a20dadc443bc1 ]---
>>>> wan0: no IPv6 routers present
>>>> ------------[ cut here ]------------
>>>> WARNING: at drivers/net/wireless/p54/main.c:355 p54_config+0x1c6/0x1d8()
>>>> Pid: 2529, comm: hostapd Tainted: G        W    3.3.0 #2
>>>> Call Trace:
>>>>  [<c102511d>] ? warn_slowpath_common+0x65/0x78
>>>>  [<c11e57e9>] ? p54_config+0x1c6/0x1d8
>>>>  [<c10251ab>] ? warn_slowpath_null+0xd/0x12
>>>>  [<c11e57e9>] ? p54_config+0x1c6/0x1d8
>>>>  [<c12ee0ce>] ? ieee80211_hw_config+0xe7/0xef
>>>>  [<c12fc641>] ? ieee80211_do_open+0x3ab/0x46f
>>>>  [<c120b374>] ? __dev_open+0x74/0x9b
>>>>  [<c120b59b>] ? __dev_change_flags+0x8c/0x101
>>>>  [<c120b671>] ? dev_change_flags+0x10/0x3b
>>>>  [<c1256af7>] ? devinet_ioctl+0x254/0x4c4
>>>>  [<c120bf62>] ? dev_ioctl+0x543/0x586
>>>>  [<c11fd890>] ? sock_ioctl+0x163/0x185
>>>>  [<c11fd72d>] ? sock_fasync+0x5e/0x5e
>>>>  [<c108e92d>] ? do_vfs_ioctl+0x44d/0x486
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1090ce0>] ? dput+0xa1/0xa9
>>>>  [<c10842ac>] ? fput+0x126/0x13e
>>>>  [<c1094dfa>] ? mnt_add_count.clone.18+0x17/0x21
>>>>  [<c108e9aa>] ? sys_ioctl+0x44/0x66
>>>>  [<c1317431>] ? syscall_call+0x7/0xb
>>>> ---[ end trace 7c0a20dadc443bc2 ]---
>>>> device wlan0 entered promiscuous mode
>>>> br0: port 3(wlan0) entered forwarding state
>>>> br0: port 3(wlan0) entered forwarding state
>>>> ------------[ cut here ]------------
>>>> WARNING: at drivers/net/wireless/p54/main.c:327 p54_config+0x54/0x1d8()
>>>> Pid: 2529, comm: hostapd Tainted: G        W    3.3.0 #2
>>>> Call Trace:
>>>>  [<c102511d>] ? warn_slowpath_common+0x65/0x78
>>>>  [<c11e5677>] ? p54_config+0x54/0x1d8
>>>>  [<c10251ab>] ? warn_slowpath_null+0xd/0x12
>>>>  [<c11e5677>] ? p54_config+0x54/0x1d8
>>>>  [<c12ee0ce>] ? ieee80211_hw_config+0xe7/0xef
>>>>  [<c12fe883>] ? ieee80211_set_channel+0xbd/0xea
>>>>  [<c12eadf0>] ? cfg80211_set_freq+0xb1/0xdd
>>>>  [<c12fe7c6>] ? ieee80211_scan+0x66/0x66
>>>>  [<c12e29e5>] ? __nl80211_set_channel.clone.32+0x91/0xbc
>>>>  [<c12e2c60>] ? nl80211_set_wiphy+0x23a/0x4c9
>>>>  [<c12fe16d>] ? ieee80211_set_cqm_rssi_config+0x72/0x72
>>>>  [<c115c736>] ? nla_parse+0x3d/0x96
>>>>  [<c12ddb97>] ? nl80211_pre_doit+0x1b/0xcc
>>>>  [<c121c92d>] ? genl_rcv_msg+0x1a4/0x1c0
>>>>  [<c121c789>] ? genl_rcv+0x20/0x20
>>>>  [<c121c121>] ? netlink_rcv_skb+0x2f/0x6f
>>>>  [<c121c781>] ? genl_rcv+0x18/0x20
>>>>  [<c121b766>] ? netlink_unicast+0xee/0x14c
>>>>  [<c121bc3b>] ? netlink_sendmsg+0x1d3/0x1ec
>>>>  [<c11fd910>] ? __sock_sendmsg+0x56/0x5f
>>>>  [<c11fe1db>] ? sock_sendmsg+0x77/0x8e
>>>>  [<c121a2ef>] ? netlink_unlock_table+0x23/0x25
>>>>  [<c1205afa>] ? verify_iovec+0x3d/0x74
>>>>  [<c11fe359>] ? __sys_sendmsg+0x167/0x200
>>>>  [<c11fddfe>] ? sock_sendmsg_nosec+0xd0/0xd0
>>>>  [<c1208d9a>] ? dev_name_hash.clone.85+0x1b/0x2c
>>>>  [<c1208d9a>] ? dev_name_hash.clone.85+0x1b/0x2c
>>>>  [<c120bf62>] ? dev_ioctl+0x543/0x586
>>>>  [<c11ffe31>] ? sk_prot_alloc+0x21/0xaf
>>>>  [<c1202c75>] ? spin_unlock_irqrestore.clone.45+0x11/0x1b
>>>>  [<c1090b38>] ? dentry_kill+0xe6/0xef
>>>>  [<c1084067>] ? fget_light+0x27/0x77
>>>>  [<c11ff3ad>] ? sys_sendmsg+0x2c/0x47
>>>>  [<c11ff850>] ? sys_socketcall+0x16a/0x1be
>>>>  [<c10828eb>] ? sys_close+0x57/0x8d
>>>>  [<c1317431>] ? syscall_call+0x7/0xb
>>>> ---[ end trace 7c0a20dadc443bc3 ]---
>>>>
>>>> ----- KERNEL WARNINGS END -----
>>>>
>>>> The warnings are from v3.3, but they are identical to the warnings
>>>> that commit causes.
>>>>
>>>> It seems like there are at least one other than me having this
>>>> problem: https://bugzilla.redhat.com/show_bug.cgi?id=804449
>>>>
>>>> Any help would be greatly appreciated.
>>>
>>> The merge 19b4a8d520a6e0176dd52aaa429261ad4fcaa545 is based on v3.1-rc8.
>>> If possible, could you please bisect the following sequence of commits?
>>>
>>> o       v3.1-rc8
>>> o       1f288094807861ec1e48c428d2c49ccf7aaf3767
>>> o       1eb521210a8c9823038abe4ddfe8c69e713ec17d
>>> o       ...
>>> o       e90c53d3e238dd0b7b02964370e8fece1778df96
>>> o       afe24b122eb6edb5f1cb942570ac8d766105c7fc
>>
>> I tried doing a git checkout of both
>> 1f288094807861ec1e48c428d2c49ccf7aaf3767 and
>> afe24b122eb6edb5f1cb942570ac8d766105c7fc, and both works fine.
>> What is puzzling me, is that it points out a merge that is based
>> before v3.1, which works fine.
>
> Points out a commit, sorry :)
>
> Could it be, that it has been so long since that tree has been pulled,
> that those commits are dated back end 3.1 was in rc?
> Otherwise I cannot figure out why it says it's before 3.1
>
> /Bjarke
>

Hmm, even more interesting, it seems like disabling CONFIG_PREEMPT
fixes it (most likely because CONFIG_TINY_PREEMPT_RCU and
CONFIG_PREEMPT_RCU gets disabled, and CONFIG_TINY_RCU gets enabled.

Does that explain anything on why it fails?

/Bjarke

>> That does not make sense to me.
>>
>> Best regards,
>> Bjarke
>>
>>> Or am I confused about exactly which merge commit you bisected to?
>>>
>>>                                                        Thanx, Paul
>>>
