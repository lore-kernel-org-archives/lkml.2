Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab1JYM1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:27:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59785 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1JYM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <20111025.063206.2273357152859701628.davem@davemloft.net>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 14:26:53 +0200
X-Google-Sender-Auth: M2KrFZs67t9DrnIYJz3HunmHICs
Message-ID: <CA+55aFzkZofnUmBOGVvmNKyA0_FApo73xZ7J=aevbHPS_0+xKQ@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:32 PM, David Miller <davem@davemloft.net> wrote:
>
> The most visible thing in here is the reorganization of the drivers
> under drivers/net.

Nope, the most visible thing are some new annoying warnings, that seem
absolutely broken.

At the very minimum, that WARN_ON(1) should be a WARN_ON_ONCE() or
something like that. Because showing it over an dover again is not
helpful.

Added the people who signed off on the changes to the affected files,
since they hopefully know why this happens and can fix it..

                      Linus

---
[   83.111504] wlan0: authenticate with 00:3a:98:27:aa:50 (try 1)
[   83.111547] ------------[ cut here ]------------
[   83.111563] WARNING: at include/net/mac80211.h:3570
rate_control_send_low+0xf5/0x230()
[   83.111568] Hardware name: 1294A58
[   83.111571] Modules linked in: iwlwifi [last unloaded: scsi_wait_scan]
[   83.111584] Pid: 955, comm: kworker/u:3 Tainted: G        W
3.1.0-02609-gc9d6329c3586 #51
[   83.111588] Call Trace:
[   83.111601]  [<ffffffff81044d3f>] warn_slowpath_common+0x7f/0xc0
[   83.111608]  [<ffffffff81044d9a>] warn_slowpath_null+0x1a/0x20
[   83.111616]  [<ffffffff817afb85>] rate_control_send_low+0xf5/0x230
[   83.111630]  [<ffffffffa0004e08>] rs_get_rate+0x58/0x1c0 [iwlwifi]
[   83.111638]  [<ffffffff817b00f6>] rate_control_get_rate+0x96/0x170
[   83.111648]  [<ffffffff817b9207>] invoke_tx_handlers+0x7e7/0x1130
[   83.111658]  [<ffffffff815bdbf1>] ? led_trigger_event+0x81/0x90
[   83.111665]  [<ffffffff817ba513>] ieee80211_tx+0x73/0xe0
[   83.111671]  [<ffffffff817ba7a8>] ieee80211_xmit+0x88/0xc0
[   83.111677]  [<ffffffff817bb5da>] ieee80211_tx_skb+0x5a/0x70
[   83.111684]  [<ffffffff817a8536>] ieee80211_send_nullfunc+0x56/0x70
[   83.111691]  [<ffffffff817a3fe1>] ieee80211_offchannel_return+0x1f1/0x200
[   83.111699]  [<ffffffff817ac192>] ieee80211_work_work+0x5a2/0x1460
[   83.111708]  [<ffffffff8167df17>] ? __kfree_skb+0x47/0xa0
[   83.111718]  [<ffffffff8105f103>] ? cwq_activate_first_delayed+0x53/0x150
[   83.111725]  [<ffffffff817abbf0>] ? free_work+0x20/0x20
[   83.111733]  [<ffffffff810619cc>] process_one_work+0x12c/0x4e0
[   83.111741]  [<ffffffff8106212e>] worker_thread+0x15e/0x340
[   83.111749]  [<ffffffff81061fd0>] ? rescuer_thread+0x210/0x210
[   83.111755]  [<ffffffff81066d3c>] kthread+0x8c/0xa0
[   83.111765]  [<ffffffff817e8d34>] kernel_thread_helper+0x4/0x10
[   83.111772]  [<ffffffff81066cb0>] ? kthread_worker_fn+0x190/0x190
[   83.111779]  [<ffffffff817e8d30>] ? gs_change+0xb/0xb
[   83.111783] ---[ end trace 95cdc4f2a378cb79 ]---
