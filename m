Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0H0B4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:56:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48118 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0H0B4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HQlP0NcrV77HMm5C/hyb+bghqgI+pwSEX6UqTKTBRV/03PbuphPcaHCfXemyLCWaOq
         vyPxNPdukEsU1MzBg7aBHt1QWt+5BJMGCJ2czgM2DuExSEHdUAQKr2WxchB0iiZUqTW+
         eLQjw5T36HfTaqvuhAp+bnuFzc3OYXzcgpLCI=
MIME-Version: 1.0
Date: Thu, 26 Aug 2010 21:56:42 -0400
Message-ID: <AANLkTinHbEW36D5R9NSrGgfbOC0Hri3Tg-fA0iR92Udi@mail.gmail.com>
Subject: 2.6.36-rc2-git4 - INFO: possible circular locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ INFO: possible circular locking dependency detected ]
2.6.36-rc2-git4 #12
-------------------------------------------------------
kworker/0:3/3630 is trying to acquire lock:
 (rtnl_mutex){+.+.+.}, at: [<ffffffff813396c7>] rtnl_lock+0x12/0x14

but task is already holding lock:
 (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa014b129>]
rfkill_switch_all+0x24/0x49 [rfkill]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (rfkill_global_mutex){+.+.+.}:
       [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
       [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
       [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
       [<ffffffffa014b4ab>] rfkill_register+0x2b/0x29c [rfkill]
       [<ffffffffa0185ba0>] wiphy_register+0x1ae/0x270 [cfg80211]
       [<ffffffffa0206f01>] ieee80211_register_hw+0x1b4/0x3cf [mac80211]
       [<ffffffffa0292e98>] iwl_ucode_callback+0x9e9/0xae3 [iwlagn]
       [<ffffffff812d3e9d>] request_firmware_work_func+0x54/0x6f
       [<ffffffff81065d15>] kthread+0x8c/0x94
       [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10

-> #1 (cfg80211_mutex){+.+.+.}:
       [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
       [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
       [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
       [<ffffffffa018605e>] cfg80211_get_dev_from_ifindex+0x1b/0x7c [cfg80211]
       [<ffffffffa0189f36>] cfg80211_wext_giwscan+0x58/0x990 [cfg80211]
       [<ffffffff8139a3ce>] ioctl_standard_iw_point+0x1a8/0x272
       [<ffffffff8139a529>] ioctl_standard_call+0x91/0xa7
       [<ffffffff8139a687>] T.723+0xbd/0x12c
       [<ffffffff8139a727>] wext_handle_ioctl+0x31/0x6d
       [<ffffffff8133014e>] dev_ioctl+0x63d/0x67a
       [<ffffffff8131afd9>] sock_ioctl+0x48/0x21d
       [<ffffffff81102abd>] do_vfs_ioctl+0x4ba/0x509
       [<ffffffff81102b5d>] sys_ioctl+0x51/0x74
       [<ffffffff81009e02>] system_call_fastpath+0x16/0x1b

-> #0 (rtnl_mutex){+.+.+.}:
       [<ffffffff810796b0>] __lock_acquire+0xa93/0xd9a
       [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
       [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
       [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
       [<ffffffff813396c7>] rtnl_lock+0x12/0x14
       [<ffffffffa0185cb5>] cfg80211_rfkill_set_block+0x1a/0x7b [cfg80211]
       [<ffffffffa014aed0>] rfkill_set_block+0x80/0xd5 [rfkill]
       [<ffffffffa014b07e>] __rfkill_switch_all+0x3f/0x6f [rfkill]
       [<ffffffffa014b13d>] rfkill_switch_all+0x38/0x49 [rfkill]
       [<ffffffffa014b821>] rfkill_op_handler+0x105/0x136 [rfkill]
       [<ffffffff81060708>] process_one_work+0x248/0x403
       [<ffffffff81062620>] worker_thread+0x139/0x214
       [<ffffffff81065d15>] kthread+0x8c/0x94
       [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

3 locks held by kworker/0:3/3630:
 #0:  (events){+.+.+.}, at: [<ffffffff81060638>] process_one_work+0x178/0x403
 #1:  ((rfkill_op_work).work){+.+...}, at: [<ffffffff81060638>]
process_one_work+0x178/0x403
 #2:  (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa014b129>]
rfkill_switch_all+0x24/0x49 [rfkill]

stack backtrace:
Pid: 3630, comm: kworker/0:3 Not tainted 2.6.36-rc2-git4 #12
Call Trace:
 [<ffffffff81078633>] print_circular_bug+0xa8/0xb7
 [<ffffffff810796b0>] __lock_acquire+0xa93/0xd9a
 [<ffffffff810767b3>] ? __bfs+0x23/0x1d8
 [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
 [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
 [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
 [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
 [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
 [<ffffffff813396c7>] ? rtnl_lock+0x12/0x14
 [<ffffffffa014b129>] ? rfkill_switch_all+0x24/0x49 [rfkill]
 [<ffffffff81077936>] ? mark_lock+0x2d/0x233
 [<ffffffffa014b71c>] ? rfkill_op_handler+0x0/0x136 [rfkill]
 [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
 [<ffffffff813396c7>] rtnl_lock+0x12/0x14
 [<ffffffffa0185cb5>] cfg80211_rfkill_set_block+0x1a/0x7b [cfg80211]
 [<ffffffffa014aed0>] rfkill_set_block+0x80/0xd5 [rfkill]
 [<ffffffffa014b07e>] __rfkill_switch_all+0x3f/0x6f [rfkill]
 [<ffffffffa014b13d>] rfkill_switch_all+0x38/0x49 [rfkill]
 [<ffffffffa014b821>] rfkill_op_handler+0x105/0x136 [rfkill]
 [<ffffffff81060708>] process_one_work+0x248/0x403
 [<ffffffff81060638>] ? process_one_work+0x178/0x403
 [<ffffffff81062620>] worker_thread+0x139/0x214
 [<ffffffff810624e7>] ? worker_thread+0x0/0x214
 [<ffffffff81065d15>] kthread+0x8c/0x94
 [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10
 [<ffffffff813b0b14>] ? restore_args+0x0/0x30
 [<ffffffff81065c89>] ? kthread+0x0/0x94
 [<ffffffff8100ac20>] ? kernel_thread_helper+0x0/0x10
wlan0: deauthenticating from 00:1b:2f:0e:ed:ba by local choice (reason=3)
