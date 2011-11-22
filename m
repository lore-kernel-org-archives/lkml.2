Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1KVAYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:24:18 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53774 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1KVAYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:24:17 -0500
Date: Tue, 22 Nov 2011 09:24:09 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111122002409.GA6936@gamma.logic.tuwien.ac.at>
References: <20111107123812.GB23508@gamma.logic.tuwien.ac.at> <1320709047.31823.188.camel@wwguy-huron> <20111108043233.GA21171@gamma.logic.tuwien.ac.at> <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com> <20111109051152.GA16006@gamma.logic.tuwien.ac.at> <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com> <20111121030640.GI32505@gamma.logic.tuwien.ac.at> <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com> <20111121232454.GC840@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121232454.GC840@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 22 Nov 2011, Norbert Preining wrote:
> On Mo, 21 Nov 2011, Emmanuel Grumbach wrote:
> > iwlwifi: add debug information on queue stop / wake
> > 
> > and run with debug flags 0x80000000 (bit 31)
> > This will print a message each time a queue is stopped / started.
> 
> I have these patches in addition to current git:

BTW, I just rebuild my kernel from current git, where there were some
fixes from Johannes Berg for mac80211 etc:
Johannes Berg (7):
      nl80211: fix HT capability attribute validation
      cfg80211: allow setting TXQ parameters only in AP mode
      cfg80211: fix cmp_ies
      cfg80211: fix missing kernel-doc
      mac80211: fix NULL dereference in radiotap code
      mac80211: fix bug in ieee80211_build_probe_req
      mac80211: fix race between connection monitor & suspend

But it did NOT help. Even after reboot I got a hanging queue, in addition
I got some more BUGs in ext3 code (ouch) and the usual in iwl-trans-pcie.c:1105:
[   57.555697] wlan0: associated
[   78.009471] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[   78.009494] ------------[ cut here ]------------
[   78.009536] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1105 iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]()
[   78.009545] Hardware name: VGN-Z11VN_B
[   78.009550] Modules linked in: rfcomm bnep bluetooth crc16 snd_hrtimer vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop(+) uinput snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mxm_wmi snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device iwlwifi firewire_ohci joydev snd firewire_core crc_itu_t mac80211 sony_laptop(O) cfg80211 soundcore snd_page_alloc rfkill tpm_infineon
[   78.009674] Pid: 717, comm: kworker/u:3 Tainted: G      D    O 3.2.0-rc2+ #47
[   78.009681] Call Trace:
[   78.009686]  <IRQ>  [<ffffffff810384c5>] warn_slowpath_common+0x83/0x9b
[   78.009712]  [<ffffffff810384f7>] warn_slowpath_null+0x1a/0x1c
[   78.009736]  [<ffffffffa00f9ae3>] iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]
[   78.009750]  [<ffffffff810d38e5>] ? kmem_cache_alloc+0x44/0xb9
[   78.009772]  [<ffffffffa00e1a1d>] iwlagn_tx_skb+0x87b/0x91b [iwlwifi]
[   78.009791]  [<ffffffffa00d7f8c>] iwlagn_mac_tx+0x131/0x1a2 [iwlwifi]
[   78.009814]  [<ffffffffa007bc56>] ? ieee80211_tx_h_fragment+0x16/0x22c [mac80211]
[   78.009826]  [<ffffffff811a3884>] ? is_swiotlb_buffer+0x29/0x38
[   78.009856]  [<ffffffffa006ff94>] __ieee80211_tx+0x176/0x1cf [mac80211]
[   78.009876]  [<ffffffffa007bbc8>] ? ieee80211_tx_h_calculate_duration+0x4c/0x65 [mac80211]
[   78.009906]  [<ffffffffa0070d5a>] ieee80211_tx+0x97/0xaf [mac80211]
[   78.009938]  [<ffffffffa0071c56>] ieee80211_tx_pending+0xf0/0x1c3 [mac80211]
[   78.009950]  [<ffffffff8103dc3e>] tasklet_action+0x77/0xc2
[   78.009959]  [<ffffffff8103dd7f>] __do_softirq+0xbc/0x1a5
[   78.009972]  [<ffffffff8140b00c>] call_softirq+0x1c/0x30
[   78.009978]  <EOI>  [<ffffffff8100359e>] do_softirq+0x38/0x6e
[   78.009995]  [<ffffffff8103da45>] _local_bh_enable_ip.isra.12+0x7d/0xa0
[   78.010004]  [<ffffffff8103da76>] local_bh_enable_ip+0xe/0x10
[   78.010014]  [<ffffffff8140921a>] _raw_spin_unlock_bh+0x23/0x25
[   78.010039]  [<ffffffffa005fc64>] ieee80211_agg_tx_operational+0x99/0xa4 [mac80211]
[   78.010065]  [<ffffffffa00607b2>] ieee80211_process_addba_resp+0xb8/0xf2 [mac80211]
[   78.010077]  [<ffffffff81064840>] ? do_raw_spin_lock+0x16/0x22
[   78.010104]  [<ffffffffa0067a82>] ieee80211_iface_work+0x130/0x2b5 [mac80211]
[   78.010132]  [<ffffffffa0067952>] ? ieee80211_teardown_sdata+0xcc/0xcc [mac80211]
[   78.010145]  [<ffffffff8104de7c>] process_one_work+0x17b/0x2bd
[   78.010154]  [<ffffffff8104c4c1>] ? need_to_create_worker+0x12/0x26
[   78.010165]  [<ffffffff8104ef77>] worker_thread+0xdb/0x15f
[   78.010174]  [<ffffffff8104ee9c>] ? manage_workers.isra.24+0x171/0x171
[   78.010184]  [<ffffffff8105265d>] kthread+0x84/0x8c
[   78.010195]  [<ffffffff8140af14>] kernel_thread_helper+0x4/0x10
[   78.010206]  [<ffffffff810525d9>] ? kthread_worker_fn+0x148/0x148
[   78.010215]  [<ffffffff8140af10>] ? gs_change+0xb/0xb
[   78.010222] ---[ end trace 1999568f54f9a3c3 ]---

Followed by a stuck queue:
[   87.480094] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[   87.480106] iwlwifi 0000:06:00.0: Current SW read_ptr 21 write_ptr 72
[   87.480161] iwlwifi 0000:06:00.0: Current HW read_ptr 21 write_ptr 72
[   87.480169] iwlwifi 0000:06:00.0: On demand firmware reload
[   87.480644] ieee80211 phy0: Hardware restart was requested
[   87.480763] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[   87.483792] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0

at which point nothing works anymore. rmmod and modprobe iwlwifi
gets back the connection:
[  417.209410] wlan0: deauthenticating from 00:0a:79:eb:56:10 by local choice (reason=3)
[  417.220286] iwlwifi 0000:06:00.0: Stopping AGG while state not ON or starting for 0 on 0 (0)
[  417.304463] cfg80211: Calling CRDA for country: JP
[  417.372535] iwlwifi 0000:06:00.0: PCI INT A disabled
[  421.388543] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[  421.388547] Copyright(c) 2003-2011 Intel Corporation
[  421.388720] iwlwifi 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  421.388753] iwlwifi 0000:06:00.0: setting latency timer to 64
[  421.389058] iwlwifi 0000:06:00.0: pci_resource_len = 0x00002000
[  421.389061] iwlwifi 0000:06:00.0: pci_resource_base = ffffc900041b8000
[  421.389063] iwlwifi 0000:06:00.0: HW Revision ID = 0x0
[  421.389210] iwlwifi 0000:06:00.0: irq 46 for MSI/MSI-X
[  421.389286] iwlwifi 0000:06:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[  421.389381] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  421.411615] iwlwifi 0000:06:00.0: device EEPROM VER=0x11e, CALIB=0x4
[  421.411619] iwlwifi 0000:06:00.0: Device SKU: 0Xf0
[  421.411629] iwlwifi 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  421.417401] iwlwifi 0000:06:00.0: loaded firmware version 8.83.5.1 build 33692 (EXP)
[  421.417563] Registered led device: phy1-led
[  421.417859] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
[  421.431467] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  421.435641] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  421.553374] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[  421.556448] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[  429.248438] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[  429.255782] wlan0: authenticated
[  429.257063] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[  429.262801] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=1)
[  429.262806] wlan0: associated

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HODNET (n.)
The wooden safety platform supported by scaffolding round a building
under construction from which the builders (at almost no personal
risk) can drop pieces of cement on passers-by.
			--- Douglas Adams, The Meaning of Liff
