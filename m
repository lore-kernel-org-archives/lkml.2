Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0FNQKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:10:07 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44402 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab0FNQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:10:04 -0400
Date: Tue, 15 Jun 2010 01:09:10 +0900
To: linux-kernel@vger.kernel.org
Subject: iwlagn completely unusable with some AP since 2.6.31
Message-ID: <20100614160910.GA10738@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please cc)

Since AFAIR 2.6.32-rc the iwlagn driver seems to be completely hosed
with some AP. Permanently dropping connections, hanging, BUGing.
Unfortunately the only reply I get from iwl maintainers is "do git bisect"
which is a bit a pain with someting that is not stable reproducible.

It seems that since git is used *some* developers are relying on git
bisect instead of thinking what their code might do. I remember faintly
that Linus opposed the idea of kernel-debug for long time due to that
reasons, now we have it, answer is: We cannot reproduce, please bisect.

Here is a log of the most recent, I sent already many many different ones
to the ipw devel list, all without reasonable answer.

I would expect that all these warning messages and WARNINGS would at
least trigger some action like adding debug statements or whatsoever,
but alas, it didn't, and that since 32-pre.


[ 5131.444627] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[ 5131.447142] wlan0: authenticated
[ 5131.447187] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[ 5131.450903] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[ 5131.450911] wlan0: associated
[ 5187.206459] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 0
[ 5191.499485] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 0
[ 5195.340108] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 0
[ 5205.513047] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 0
[ 5209.816242] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 0
[ 5212.914687] iwlagn 0000:06:00.0: iwlagn_tx_agg_start on ra = 00:0a:79:eb:56:10 tid = 0
[ 5328.057684] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 6
[ 5463.057686] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 6
[11296.057706] iwlagn 0000:06:00.0: Fail finding valid aggregation tid: 6
[12530.400033] Monitor-Mwait will be used to enter C-2 state
[12530.401175] Monitor-Mwait will be used to enter C-3 state
[13190.324128] No probe response from AP 00:0a:79:eb:56:10 after 500ms, disconnecting.
[13190.376076] cfg80211: Calling CRDA to update world regulatory domain
[13201.736859] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[13201.739331] wlan0: authenticated
[13201.739384] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[13201.743127] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[13201.743136] wlan0: associated
[13206.311797] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
[13206.322205] cfg80211: Calling CRDA to update world regulatory domain
[13211.304596] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[13211.306947] wlan0: authenticated
[13211.306997] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[13211.310680] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[13211.310688] wlan0: associated
[13224.320636] iwlagn 0000:06:00.0: iwlagn_tx_agg_start on ra = 00:0a:79:eb:56:10 tid = 0
[13227.926481] iwlagn 0000:06:00.0: low ack count detected, restart firmware
[13227.926493] iwlagn 0000:06:00.0: On demand firmware reload
[13227.972437] iwlagn 0000:06:00.0: Stopping AGG while state not ON or starting
[13227.972449] iwlagn 0000:06:00.0: queue number out of range: 0, must be 10 to 19
[13239.312276] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
[13239.340079] cfg80211: Calling CRDA to update world regulatory domain
[13311.462143] ------------[ cut here ]------------
[13311.462183] WARNING: at net/wireless/core.c:633 wdev_cleanup_work+0x52/0xbb [cfg80211]()
[13311.462189] Hardware name: VGN-Z11VN_B
[13311.462193] Modules linked in: vboxnetadp vboxnetflt sco bnep rfcomm l2cap crc16 hso binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse vboxdrv loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq arc4 btusb sony_laptop bluetooth tpm_infineon snd_timer snd_seq_device snd firewire_ohci firewire_core crc_itu_t joydev iwlagn(-) iwlcore mac80211 cfg80211 rfkill soundcore snd_page_alloc
[13311.462294] Pid: 1052, comm: cfg80211 Not tainted 2.6.35-rc3 #29
[13311.462299] Call Trace:
[13311.462315]  [<ffffffff81033d29>] warn_slowpath_common+0x80/0x98
[13311.462325]  [<ffffffff81033d56>] warn_slowpath_null+0x15/0x17
[13311.462339]  [<ffffffffa001958e>] wdev_cleanup_work+0x52/0xbb [cfg80211]
[13311.462350]  [<ffffffff81044103>] worker_thread+0x15d/0x1f3
[13311.462364]  [<ffffffffa001953c>] ? wdev_cleanup_work+0x0/0xbb [cfg80211]
[13311.462373]  [<ffffffff810479b9>] ? autoremove_wake_function+0x0/0x34
[13311.462385]  [<ffffffff8136d181>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
[13311.462394]  [<ffffffff81043fa6>] ? worker_thread+0x0/0x1f3
[13311.462401]  [<ffffffff810475d7>] kthread+0x7a/0x82
[13311.462410]  [<ffffffff81002d94>] kernel_thread_helper+0x4/0x10
[13311.462418]  [<ffffffff8104755d>] ? kthread+0x0/0x82
[13311.462426]  [<ffffffff81002d90>] ? kernel_thread_helper+0x0/0x10
[13311.462432] ---[ end trace b1cb7d121e67bde3 ]---
[13311.521571] iwlagn 0000:06:00.0: PCI INT A disabled
[13316.830454] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[13316.830457] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[13316.830552] iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[13316.830583] iwlagn 0000:06:00.0: setting latency timer to 64
[13316.831777] iwlagn 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[13316.854135] iwlagn 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[13316.854251] iwlagn 0000:06:00.0: irq 46 for MSI/MSI-X
[13316.858767] iwlagn 0000:06:00.0: loaded firmware version 8.24.2.12
[13316.859883] phy1: Selected rate control algorithm 'iwl-agn-rs'
[13328.516652] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[13328.519137] wlan0: authenticated
[13328.519181] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[13328.522937] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[13328.522945] wlan0: associated
[13341.695599] iwlagn 0000:06:00.0: iwlagn_tx_agg_start on ra = 00:0a:79:eb:56:10 tid = 0
[13733.621786] iwlagn 0000:06:00.0: Received BA when not expected
[13733.621800] iwlagn 0000:06:00.0: Read index for DMA queue txq id (0), index 15, is out of range [0-256] 17 17.
[13734.188691] iwlagn 0000:06:00.0: Received BA when not expected
[13734.188704] iwlagn 0000:06:00.0: Read index for DMA queue txq id (0), index 16, is out of range [0-256] 18 18.

and here it continues with many many many of those two lines. The only
way to resurrect the wifi card is unloading iwlagn and reloading it.

I have no idea where to go from here, I always thought that WARNINGS and
serious errors like that (complete drop of connection in irregular
intervals, sometimes several times in few minutes, sometimesonce an
hour) would trigger some action.

Hope someone is picking that up, thanks.

Best wishes

Norbert

----------------------------------------------------------------------------
Norbert Preining                preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                   TeX Live and Debian Developer
gpg DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
----------------------------------------------------------------------------
AGGLETHORPE (n.)
A dispute between two pooves in a boutique.
			--- Douglas Adams, The Meaning of Liff
