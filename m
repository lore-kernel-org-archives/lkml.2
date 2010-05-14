Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0ENNhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:37:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0ENNh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:37:29 -0400
Date: Fri, 14 May 2010 15:37:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: RTL8185 mlme.c:341 warning and failure still in 2.6.34rc7
Message-ID: <20100514133723.GA10351@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ccing Rafael because this seems to be a regression. Please add it to your list.]

When I boot my system with a RTL8185 the wireless doesn't come up at boot,
only when I manually restart it. Instead i get

I reported this a few rc*s back, but haven't heard anything back and the 
problem is still there.

For me it's a serious problem when the wireless does not come up.

This didn't happen in .33.

-Andi

wlan0: authenticate with 00:1f:3f:1d:54:46 (try 1)
wlan0: authenticated
wlan0: associate with 00:1f:3f:1d:54:46 (try 1)
wlan0: associate with 00:1f:3f:1d:54:46 (try 2)
wlan0: associate with 00:1f:3f:1d:54:46 (try 3)
wlan0: association with 00:1f:3f:1d:54:46 timed out
------------[ cut here ]------------
WARNING: at /home/lsrc/linux-2.6.34-rc7/net/wireless/mlme.c:341 cfg80211_send_assoc_timeout+0xff/0x117 [cfg80211]()
Hardware name: ...
Modules linked in:  ...
Pid: 3344, comm: phy0 Not tainted 2.6.34-rc7 #7
Call Trace:
 [<ffffffffa0072124>] ? cfg80211_send_assoc_timeout+0xff/0x117 [cfg80211]
 [<ffffffff8103a4f0>] warn_slowpath_common+0x7c/0xa9
 [<ffffffff8103a531>] warn_slowpath_null+0x14/0x16
 [<ffffffffa0072124>] cfg80211_send_assoc_timeout+0xff/0x117 [cfg80211]
 [<ffffffffa00e6393>] ieee80211_assoc_done+0x74/0xa9 [mac80211]
 [<ffffffffa00e85f0>] ieee80211_work_work+0xe4c/0xe8d [mac80211]
 [<ffffffff81033cbe>] ? finish_task_switch+0x42/0xab
 [<ffffffff810535d7>] ? prepare_to_wait+0x6e/0x7a
 [<ffffffff8104f832>] worker_thread+0x192/0x227
 [<ffffffffa00e77a4>] ? ieee80211_work_work+0x0/0xe8d [mac80211]
 [<ffffffff81053342>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8104f6a0>] ? worker_thread+0x0/0x227
 [<ffffffff81052efc>] kthread+0x82/0x8a
 [<ffffffff81003954>] kernel_thread_helper+0x4/0x10
 [<ffffffff81052e7a>] ? kthread+0x0/0x8a
 [<ffffffff81003950>] ? kernel_thread_helper+0x0/0x10
---[ end trace 4e3067114aa2fd06 ]---
wlan0: deauthenticating from 00:1f:3f:1d:54:46 by local choice (reason=3)



-- 
ak@linux.intel.com -- Speaking for myself only.
