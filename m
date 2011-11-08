Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1KHEct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:32:49 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60608 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1KHEcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:32:43 -0500
Date: Tue, 8 Nov 2011 13:32:33 +0900
From: Norbert Preining <preining@logic.at>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111108043233.GA21171@gamma.logic.tuwien.ac.at>
References: <20111021012442.GB26758@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com> <20111026025014.GB24956@gamma.logic.tuwien.ac.at> <1319601333.14693.19.camel@wwguy-ubuntu> <20111026040332.GF24956@gamma.logic.tuwien.ac.at> <20111102031345.GA10851@gamma.logic.tuwien.ac.at> <1320204101.31823.140.camel@wwguy-huron> <20111104045817.GA25778@gamma.logic.tuwien.ac.at> <20111107123812.GB23508@gamma.logic.tuwien.ac.at> <1320709047.31823.188.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320709047.31823.188.camel@wwguy-huron>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wey,

On Mo, 07 Nov 2011, Guy, Wey-Yi wrote:
> Could you please try with this patch?

new tests with 3.2.0-rc1, plus the patch you send. Starting from
cold state, so no suspend but hard off.

In short, this is the output of your patch:
[  215.872090] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[  215.872101] iwlwifi 0000:06:00.0: Current SW read_ptr 105 write_ptr 115
[  215.872156] iwlwifi 0000:06:00.0: Current HW read_ptr 105 write_ptr 115
[  215.872164] iwlwifi 0000:06:00.0: On demand firmware reload


And here is the rest. As before, first work for short time, then WARNING
and hang, needs full reset with force_reset, finally works.

[   41.881266] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   41.882703] Copyright(c) 2003-2011 Intel Corporation
[   41.884190] iwlwifi 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   41.885578] iwlwifi 0000:06:00.0: setting latency timer to 64
[   41.885652] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
[   41.887041] iwlwifi 0000:06:00.0: pci_resource_base = ffffc9001496c000
[   41.888403] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
[   41.889885] iwlwifi 0000:06:00.0: irq 46 for MSI/MSI-X
[   41.889963] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   41.891401] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   41.914539] iwlwifi 0000:06:00.0: device EEPROM VER=0x11e, CALIB=0x4
[   41.915880] iwlwifi 0000:06:00.0: Device SKU: 0Xf0
[   41.917237] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   41.922968] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692 (EXP)
[   41.924485] Registered led device: phy0-led
[   41.969919] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[...]
[   47.917692] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   47.923032] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[   48.036928] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   48.041410] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[...]
[   55.646391] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[   55.844660] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[   56.044092] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[   56.244096] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[   64.277546] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[   64.476076] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[   64.676108] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[   64.876109] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[   72.841928] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[   73.040056] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
[   73.040718] wlan0: authenticated
[   73.047334] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[   73.244070] wlan0: associate with 00:24:c4:ab:bd:ef (try 2)
[   73.246336] wlan0: RX AssocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=3)
[   73.246339] wlan0: associated

Up to here it probably worked, but I cannot guarantee, that was while
gnome3 was working its way through tons of initialization.

[   81.628826] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[  106.547117] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[  106.744017] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[  106.944087] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[  107.148023] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[  118.254103] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[  118.265841] cfg80211: Calling CRDA for country: JP
[  118.276060] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[  118.476081] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[  118.676032] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[  118.876024] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[  126.839944] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[  126.840763] wlan0: authenticated
[  126.841851] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[  126.844961] wlan0: RX ReassocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=3)
[  126.844965] wlan0: associated
[  136.116943] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[  146.550560] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[  146.748058] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[  146.948062] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[  147.148052] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[  158.039627] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[  158.081078] cfg80211: Calling CRDA to update world regulatory domain
[  158.085453] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[  158.088031] wlan0: authenticated
[  158.092327] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[  158.094338] wlan0: RX ReassocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=3)
[  158.094341] wlan0: associated
[  206.605041] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[  206.605062] ------------[ cut here ]------------
[  206.605101] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1105 iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]()
[  206.605110] Hardware name: VGN-Z11VN_B
[  206.605114] Modules linked in: rfcomm bnep vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm iwlwifi snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event mac80211 snd_seq sony_laptop(O) snd_timer snd_seq_device snd cfg80211 btusb bluetooth mxm_wmi firewire_ohci rfkill crc16 joydev soundcore snd_page_alloc firewire_core crc_itu_t tpm_infineon
[  206.605244] Pid: 717, comm: kworker/u:4 Tainted: G           O 3.2.0-rc1+ #44
[  206.605250] Call Trace:
[  206.605255]  <IRQ>  [<ffffffff81038475>] warn_slowpath_common+0x83/0x9b
[  206.605281]  [<ffffffff810384a7>] warn_slowpath_null+0x1a/0x1c
[  206.605305]  [<ffffffffa01fdaf7>] iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]
[  206.605328]  [<ffffffffa01e72b2>] ? iwlagn_temperature+0x1a/0x1c [iwlwifi]
[  206.605341]  [<ffffffff810d381d>] ? kmem_cache_alloc+0x44/0xb9
[  206.605362]  [<ffffffffa01e5a1d>] iwlagn_tx_skb+0x87b/0x91b [iwlwifi]
[  206.605376]  [<ffffffff81408758>] ? _raw_spin_unlock_irqrestore+0x2e/0x30
[  206.605393]  [<ffffffffa01dbf8c>] iwlagn_mac_tx+0x131/0x1a2 [iwlwifi]
[  206.605419]  [<ffffffffa019cc56>] ? ieee80211_tx_h_fragment+0x16/0x22c [mac80211]
[  206.605444]  [<ffffffffa01feb13>] ? iwl_rx_queue_update_write_ptr+0x138/0x141 [iwlwifi]
[  206.605474]  [<ffffffffa0190f94>] __ieee80211_tx+0x176/0x1cf [mac80211]
[  206.605494]  [<ffffffffa019cbc8>] ? ieee80211_tx_h_calculate_duration+0x4c/0x65 [mac80211]
[  206.605524]  [<ffffffffa0191d5a>] ieee80211_tx+0x97/0xaf [mac80211]
[  206.605556]  [<ffffffffa0192c56>] ieee80211_tx_pending+0xf0/0x1c3 [mac80211]
[  206.605568]  [<ffffffff8103dbee>] tasklet_action+0x77/0xc2
[  206.605578]  [<ffffffff8103dd2f>] __do_softirq+0xbc/0x1a5
[  206.605590]  [<ffffffff8140a3cc>] call_softirq+0x1c/0x30
[  206.605596]  <EOI>  [<ffffffff8100359e>] do_softirq+0x38/0x6e
[  206.605613]  [<ffffffff8103d9f5>] _local_bh_enable_ip.isra.12+0x7d/0xa0
[  206.605623]  [<ffffffff8103da26>] local_bh_enable_ip+0xe/0x10
[  206.605632]  [<ffffffff814085ca>] _raw_spin_unlock_bh+0x23/0x25
[  206.605657]  [<ffffffffa0180c64>] ieee80211_agg_tx_operational+0x99/0xa4 [mac80211]
[  206.605683]  [<ffffffffa01817b2>] ieee80211_process_addba_resp+0xb8/0xf2 [mac80211]
[  206.605697]  [<ffffffff81064840>] ? in_lock_functions+0x1a/0x1d
[  206.605724]  [<ffffffffa0188a82>] ieee80211_iface_work+0x130/0x2b5 [mac80211]
[  206.605751]  [<ffffffffa0188952>] ? ieee80211_teardown_sdata+0xcc/0xcc [mac80211]
[  206.605764]  [<ffffffff8104de2c>] process_one_work+0x17b/0x2bd
[  206.605774]  [<ffffffff8104c471>] ? need_to_create_worker+0x12/0x26
[  206.605785]  [<ffffffff8104ef27>] worker_thread+0xdb/0x15f
[  206.605795]  [<ffffffff8104ee4c>] ? manage_workers.isra.24+0x171/0x171
[  206.605806]  [<ffffffff8105260d>] kthread+0x84/0x8c
[  206.605817]  [<ffffffff8140a2d4>] kernel_thread_helper+0x4/0x10
[  206.605829]  [<ffffffff81052589>] ? kthread_worker_fn+0x148/0x148
[  206.605839]  [<ffffffff8140a2d0>] ? gs_change+0xb/0xb
[  206.605847] ---[ end trace b36eae6e58c8ed31 ]---
[  206.614587] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[  206.812155] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[  207.012096] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[  207.212105] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out

Here comes the output of the patch you sent:

[  215.872090] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[  215.872101] iwlwifi 0000:06:00.0: Current SW read_ptr 105 write_ptr 115
[  215.872156] iwlwifi 0000:06:00.0: Current HW read_ptr 105 write_ptr 115
[  215.872164] iwlwifi 0000:06:00.0: On demand firmware reload

echo 1 onto /sys/kernel/debug/...../force_reset

[  215.872600] ieee80211 phy0: Hardware restart was requested
[  215.872815] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  215.875847] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  215.927777] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[  215.960954] cfg80211: Calling CRDA to update world regulatory domain
[  215.972261] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[  216.172107] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[  216.372070] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[  216.572123] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[  221.368107] usb 8-2: USB disconnect, device number 2
[  224.604953] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[  224.605664] wlan0: authenticated
[  224.606873] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[  224.608866] wlan0: RX ReassocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=3)
[  224.608869] wlan0: associated
[  329.901051] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 6
[  332.477994] iwlwifi 0000:06:00.0: On demand firmware reload
[  332.478449] ieee80211 phy0: Hardware restart was requested
[  332.478532] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  332.481587] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  416.866720] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[  416.932995] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 6

from here on it started to work.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BOOK	What to do if you find yourself stuck in a crack in the ground
	underneath a giant boulder you can't move, with no hope of
	rescue. Consider how lucky you are that life has been good to
	you so far. Alternatively, if life hasn't been good to you so
	far, which given your current circumstances seems more likely,
	consider how lucky you are that it won't be troubling you much
	longer.
                 --- Comforting advice for Ford and Arthur in this current
                 --- situation, Fit the Eighth.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
