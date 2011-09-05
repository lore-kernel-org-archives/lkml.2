Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1IEVxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 17:53:12 -0400
Received: from lucidpixels.com ([72.73.18.11]:57320 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1IEVxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 17:53:08 -0400
Date: Mon, 5 Sep 2011 17:53:06 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: 3.0.0: carl9170: drivers/net/wireless/ath/carl9170/tx.c:351
 carl9170_tx_status+0x431/0x440 [carl9170]()
Message-ID: <alpine.DEB.2.02.1109051750010.23828@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Saw this on one of my Linux machines with a Linux (community supported USB 
stick):

[88927.073741] ------------[ cut here ]------------
[88927.073762] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:351 carl9170_tx_status+0x431/0x440 [carl9170]()
[88927.073769] Hardware name: X7SPA-HF
[88927.073772] Modules linked in: aes_generic carl9170 mac80211 ath cfg80211 uvcvideo i2c_i801 videodev
[88927.073791] Pid: 0, comm: kworker/0:1 Not tainted 3.0.0 #3
[88927.073796] Call Trace:
[88927.073800]  <IRQ>  [<ffffffff8103050c>] ? warn_slowpath_common+0x7c/0xc0
[88927.073821]  [<ffffffffa00ab461>] ? carl9170_tx_status+0x431/0x440 [carl9170]
[88927.073831]  [<ffffffffa00ab7e9>] ? __carl9170_tx_process_status+0x109/0x220 [carl9170]
[88927.073841]  [<ffffffff8109f5ed>] ? dma_pool_free+0x1d/0xf0
[88927.073850]  [<ffffffffa00abb7e>] ? carl9170_tx_process_status+0x3e/0x80 [carl9170]
[88927.073860]  [<ffffffffa00ac7f2>] ? carl9170_handle_command_response+0x382/0x500 [carl9170]
[88927.073870]  [<ffffffffa00acbcd>] ? __carl9170_rx+0x25d/0x820 [carl9170]
[88927.073879]  [<ffffffff813bc494>] ? ehci_work+0x2f4/0xac0
[88927.073888]  [<ffffffffa00ad213>] ? carl9170_rx_stream+0x83/0x3b0 [carl9170]
[88927.073897]  [<ffffffffa00a5228>] ? carl9170_usb_tasklet+0x98/0xc0 [carl9170]
[88927.073906]  [<ffffffff810353ea>] ? tasklet_hi_action+0x5a/0xc0
[88927.073914]  [<ffffffff81035ae0>] ? __do_softirq+0x90/0x120
[88927.073922]  [<ffffffff814def4c>] ? call_softirq+0x1c/0x26
[88927.073930]  [<ffffffff81003a8d>] ? do_softirq+0x4d/0x80
[88927.073936]  [<ffffffff8100394d>] ? do_IRQ+0x5d/0xd0
[88927.073945]  [<ffffffff814ddb53>] ? common_interrupt+0x13/0x13
[88927.073949]  <EOI>  [<ffffffff81008ed1>] ? mwait_idle+0x51/0x70
[88927.073961]  [<ffffffff8100072c>] ? cpu_idle+0x4c/0x90
[88927.073967] ---[ end trace e579a118b0825530 ]---
[90635.804554] ieee80211 phy0: invalid plcp cck rate (0).
[91309.613969] ieee80211 phy0: invalid plcp cck rate (0).

I have another host with another one of these sticks as well:

[ 6703.136920] ------------[ cut here ]------------
[ 6703.136955] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:351 carl9170_tx_status+0x398/0x3b0 [carl9170]()
[ 6703.136992] Hardware name: Latitude D630 
[ 6703.137012] Modules linked in: aes_generic carl9170 b43 ath mac80211 uvcvideo videodev cfg80211 i2c_i801 ssb
[ 6703.137092] Pid: 0, comm: swapper Not tainted 3.0.0 #4
[ 6703.137117] Call Trace:
[ 6703.137137]  [<c102f4f8>] ? warn_slowpath_common+0x78/0xb0
[ 6703.137158]  [<f829fb88>] ? carl9170_tx_status+0x398/0x3b0 [carl9170]
[ 6703.137180]  [<f829fb88>] ? carl9170_tx_status+0x398/0x3b0 [carl9170]
[ 6703.137201]  [<c102f54b>] ? warn_slowpath_null+0x1b/0x20
[ 6703.137221]  [<f829fb88>] ? carl9170_tx_status+0x398/0x3b0 [carl9170]
[ 6703.137242]  [<c1281dbf>] ? bitmap_release_region+0xf/0x20
[ 6703.137263]  [<f829fe01>] ? __carl9170_tx_process_status+0x31/0x1e0 [carl9170]
[ 6703.137295]  [<f82a0204>] ? carl9170_tx_process_status+0x44/0x80 [carl9170]
[ 6703.137317]  [<f82a0ea5>] ? carl9170_handle_command_response+0x365/0x4e0 [carl9170]
[ 6703.137349]  [<f82a1246>] ? __carl9170_rx+0x226/0x7d0 [carl9170]
[ 6703.137369]  [<c102b005>] ? load_balance+0x65/0x520
[ 6703.137389]  [<f82a185a>] ? carl9170_rx_stream+0x6a/0x360 [carl9170]
[ 6703.137411]  [<c1390d41>] ? __usb_unanchor_urb+0x51/0x60
[ 6703.137430]  [<f8299db4>] ? carl9170_usb_tasklet+0x94/0xc0 [carl9170]
[ 6703.137452]  [<c1033d68>] ? tasklet_hi_action+0x48/0xa0
[ 6703.137471]  [<c1034375>] ? __do_softirq+0x75/0x100
[ 6703.137490]  [<c1034300>] ? remote_softirq_receive+0x20/0x20
[ 6703.137509]  <IRQ>  [<c1004306>] ? do_IRQ+0x46/0xc0
[ 6703.137532]  [<c12c646a>] ? acpi_hw_read_port+0x32/0x80
[ 6703.137552]  [<c14aed29>] ? common_interrupt+0x29/0x30
[ 6703.137572]  [<c12d2ead>] ? acpi_idle_enter_bm+0x228/0x25d
[ 6703.137593]  [<c13bd757>] ? cpuidle_idle_call+0x67/0xf0
[ 6703.137612]  [<c1001535>] ? cpu_idle+0x45/0x70
[ 6703.137630]  [<c161f5fe>] ? start_kernel+0x267/0x26c
[ 6703.137648]  [<c161f147>] ? loglevel+0x14/0x14
[ 6703.137665] ---[ end trace f3fa3de4b705d3e7 ]---
[14580.577119] ieee80211 phy1: invalid plcp cck rate (0).
[16930.612982] ieee80211 phy1: invalid plcp cck rate (0).

Justin.

