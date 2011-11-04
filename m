Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1KDE63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 00:58:29 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40086 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KDE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 00:58:27 -0400
Date: Fri, 4 Nov 2011 13:58:17 +0900
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
Message-ID: <20111104045817.GA25778@gamma.logic.tuwien.ac.at>
References: <1319004836.31823.57.camel@wwguy-huron> <20111020045927.GB23044@gamma.logic.tuwien.ac.at> <1319119852.2111.2.camel@wwguy-ubuntu> <20111021012442.GB26758@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com> <20111026025014.GB24956@gamma.logic.tuwien.ac.at> <1319601333.14693.19.camel@wwguy-ubuntu> <20111026040332.GF24956@gamma.logic.tuwien.ac.at> <20111102031345.GA10851@gamma.logic.tuwien.ac.at> <1320204101.31823.140.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320204101.31823.140.camel@wwguy-huron>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wey,

On Di, 01 Nov 2011, Guy, Wey-Yi wrote:
> after the firmware reloaded, is the traffic resume? or it is continuous
> without traffic?

Ok, I compiled a new kernel from todays git, and I see that there 
are kernel bugs, but after the hardware restart traffic gets through.

While suspending I have:
[ 6630.948551] WARNING: at drivers/pci/pci-driver.c:607 pci_has_legacy_pm_support.isra.8+0x53/0x59()
[ 6630.948557] Hardware name: VGN-Z11VN_B
[ 6630.948561] Modules linked in: sony_laptop rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek arc4 iwlwifi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm firewire_ohci mac80211 snd_seq_dummy snd_seq_oss snd_seq_midi firewire_core cfg80211 snd_rawmidi snd_seq_midi_event btusb snd_seq snd_timer mxm_wmi bluetooth snd_seq_device crc16 snd rfkill joydev crc_itu_t tpm_infineon soundcore snd_page_alloc
[ 6630.948655] Pid: 11390, comm: kworker/u:8 Not tainted 3.1.0+ #42
[ 6630.948660] Call Trace:
[ 6630.948674]  [<ffffffff8103843d>] warn_slowpath_common+0x83/0x9b
[ 6630.948683]  [<ffffffff8103846f>] warn_slowpath_null+0x1a/0x1c
[ 6630.948692]  [<ffffffff811aa983>] pci_has_legacy_pm_support.isra.8+0x53/0x59
[ 6630.948701]  [<ffffffff811aaf94>] pci_pm_suspend+0x34/0x104
[ 6630.948711]  [<ffffffff8127f50b>] pm_op+0x8b/0x149
[ 6630.948719]  [<ffffffff8127f72f>] __device_suspend+0x106/0x196
[ 6630.948727]  [<ffffffff8127f7de>] async_suspend+0x1f/0x5d
[ 6630.948737]  [<ffffffff81058251>] async_run_entry_fn+0x9e/0x131
[ 6630.948746]  [<ffffffff810581b3>] ? async_schedule+0x17/0x17
[ 6630.948756]  [<ffffffff8104dd60>] process_one_work+0x17b/0x2bd
[ 6630.948764]  [<ffffffff8104c3a5>] ? need_to_create_worker+0x12/0x26
[ 6630.948773]  [<ffffffff8104ee5b>] worker_thread+0xdb/0x15f
[ 6630.948780]  [<ffffffff8104ed80>] ? manage_workers.isra.24+0x171/0x171
[ 6630.948789]  [<ffffffff81052541>] kthread+0x84/0x8c
[ 6630.948800]  [<ffffffff81408a14>] kernel_thread_helper+0x4/0x10
[ 6630.948809]  [<ffffffff810524bd>] ? kthread_worker_fn+0x148/0x148
[ 6630.948817]  [<ffffffff81408a10>] ? gs_change+0xb/0xb
[ 6630.948824] ---[ end trace 9f0907b3f72ff4c6 ]---

(several of them)


Then I get some WARNINGS from iwl:
[ 6662.601340] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1101 iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]()
[ 6662.601343] Hardware name: VGN-Z11VN_B
[ 6662.601345] Modules linked in: sony_laptop rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek arc4 iwlwifi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm firewire_ohci mac80211 snd_seq_dummy snd_seq_oss snd_seq_midi firewire_core cfg80211 snd_rawmidi snd_seq_midi_event btusb snd_seq snd_timer mxm_wmi bluetooth snd_seq_device crc16 snd rfkill joydev crc_itu_t tpm_infineon soundcore snd_page_alloc
[ 6662.601386] Pid: 11391, comm: kworker/u:9 Tainted: G        W   3.1.0+ #42
[ 6662.601388] Call Trace:
[ 6662.601390]  <IRQ>  [<ffffffff8103843d>] warn_slowpath_common+0x83/0x9b
[ 6662.601399]  [<ffffffff8103846f>] warn_slowpath_null+0x1a/0x1c
[ 6662.601407]  [<ffffffffa0223b04>] iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]
[ 6662.601412]  [<ffffffff810d32a5>] ? kmem_cache_alloc+0x44/0xb9
[ 6662.601419]  [<ffffffffa020b9f4>] iwlagn_tx_skb+0x862/0x901 [iwlwifi]
[ 6662.601425]  [<ffffffffa0201f8c>] iwlagn_mac_tx+0x131/0x1a2 [iwlwifi]
[ 6662.601434]  [<ffffffffa01d8bc6>] ? ieee80211_tx_h_fragment+0x16/0x22c [mac80211]
[ 6662.601443]  [<ffffffffa01ccf14>] __ieee80211_tx+0x176/0x1cf [mac80211]
[ 6662.601449]  [<ffffffffa01d8b38>] ? ieee80211_tx_h_calculate_duration+0x4c/0x65 [mac80211]
[ 6662.601459]  [<ffffffffa01cdcda>] ieee80211_tx+0x97/0xaf [mac80211]
[ 6662.601469]  [<ffffffffa01cebd6>] ieee80211_tx_pending+0xf0/0x1c3 [mac80211]
[ 6662.601473]  [<ffffffff8103db22>] tasklet_action+0x77/0xc2
[ 6662.601477]  [<ffffffff8103dc63>] __do_softirq+0xbc/0x1a5
[ 6662.601481]  [<ffffffff81408b0c>] call_softirq+0x1c/0x30
[ 6662.601483]  <EOI>  [<ffffffff8100359e>] do_softirq+0x38/0x6e
[ 6662.601489]  [<ffffffff8103d929>] _local_bh_enable_ip.isra.12+0x7d/0xa0
[ 6662.601492]  [<ffffffff8103d95a>] local_bh_enable_ip+0xe/0x10
[ 6662.601496]  [<ffffffff81406d22>] _raw_spin_unlock_bh+0x23/0x25
[ 6662.601503]  [<ffffffffa01bcc64>] ieee80211_agg_tx_operational+0x99/0xa4 [mac80211]
[ 6662.601512]  [<ffffffffa01bd7b2>] ieee80211_process_addba_resp+0xb8/0xf2 [mac80211]
[ 6662.601516]  [<ffffffff81064740>] ? do_raw_spin_trylock+0xc/0x2a
[ 6662.601525]  [<ffffffffa01c4a26>] ieee80211_iface_work+0x130/0x2b5 [mac80211]
[ 6662.601534]  [<ffffffffa01c48f6>] ? ieee80211_teardown_sdata+0xcc/0xcc [mac80211]
[ 6662.601538]  [<ffffffff8104dd60>] process_one_work+0x17b/0x2bd
[ 6662.601541]  [<ffffffff8104c3a5>] ? need_to_create_worker+0x12/0x26
[ 6662.601545]  [<ffffffff8104ee5b>] worker_thread+0xdb/0x15f
[ 6662.601548]  [<ffffffff8104ed80>] ? manage_workers.isra.24+0x171/0x171
[ 6662.601552]  [<ffffffff81052541>] kthread+0x84/0x8c
[ 6662.601556]  [<ffffffff81408a14>] kernel_thread_helper+0x4/0x10
[ 6662.601559]  [<ffffffff810524bd>] ? kthread_worker_fn+0x148/0x148
[ 6662.601563]  [<ffffffff81408a10>] ? gs_change+0xb/0xb

Then I get the hanging queue:
[ 6672.360098] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[ 6672.360109] iwlwifi 0000:06:00.0: Current read_ptr 251 write_ptr 0
[ 6672.360117] iwlwifi 0000:06:00.0: On demand firmware reload
[ 6672.360548] ieee80211 phy0: Hardware restart was requested
[ 6672.360643] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 6672.363667] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0

After that network manager tries to connect to my univerity network,
and I get another
[ 6702.613501] WARNING: at include/net/mac80211.h:3570 rate_control_send_low+0xa5/0x165 [mac80211]()
[ 6702.613508] Hardware name: VGN-Z11VN_B
[ 6702.613513] Modules linked in: sony_laptop rfcomm bnep snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek arc4 iwlwifi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm firewire_ohci mac80211 snd_seq_dummy snd_seq_oss snd_seq_midi firewire_core cfg80211 snd_rawmidi snd_seq_midi_event btusb snd_seq snd_timer mxm_wmi bluetooth snd_seq_device crc16 snd rfkill joydev crc_itu_t tpm_infineon soundcore snd_page_alloc
[ 6702.613654] Pid: 11391, comm: kworker/u:9 Tainted: G        W   3.1.0+ #42
[ 6702.613661] Call Trace:
[ 6702.613678]  [<ffffffff8103843d>] warn_slowpath_common+0x83/0x9b
[ 6702.613689]  [<ffffffff8103846f>] warn_slowpath_null+0x1a/0x1c
[ 6702.613715]  [<ffffffffa01c6139>] rate_control_send_low+0xa5/0x165 [mac80211]
[ 6702.613735]  [<ffffffffa02061be>] rs_get_rate+0x146/0x254 [iwlwifi]
[ 6702.613763]  [<ffffffffa01c65a1>] rate_control_get_rate+0x86/0x14c [mac80211]
[ 6702.613776]  [<ffffffff81406ea7>] ? _raw_spin_unlock_irqrestore+0x25/0x30
] ieee80211_tx_h_rate_ctrl+0x1cb/0x3e4 [mac80211]
[ 6702.613834]  [<ffffffffa01d13d7>] ? ieee80211_send_probe_req+0x50/0x58 [mac80211]
[ 6702.613863]  [<ffffffffa01cdab9>] invoke_tx_handlers+0x69/0xf5 [mac80211]
[ 6702.613892]  [<ffffffffa01cdcc2>] ieee80211_tx+0x7f/0xaf [mac80211]
[ 6702.613922]  [<ffffffffa01ce162>] ieee80211_xmit+0x89/0x97 [mac80211]
[ 6702.613950]  [<ffffffffa01ced00>] ieee80211_tx_skb+0x57/0x5f [mac80211]
[ 6702.613976]  [<ffffffffa01c0088>] ieee80211_send_nullfunc+0x5f/0x64 [mac80211]
[ 6702.613999]  [<ffffffffa01bc349>] ieee80211_offchannel_return+0x94/0x1a5 [mac80211]
[ 6702.614012]  [<ffffffff8104494f>] ? mod_timer+0x90/0x99
[ 6702.614038]  [<ffffffffa01c3de0>] ieee80211_work_work+0xf9c/0x105d [mac80211]
[ 6702.614049]  [<ffffffff8100074b>] ? __unlazy_fpu.part.3+0x9/0x61
[ 6702.614059]  [<ffffffff81000d06>] ? __switch_to+0xd3/0x200
[ 6702.614070]  [<ffffffff8102b30c>] ? need_resched+0x23/0x2d
[ 6702.614096]  [<ffffffffa01c2e44>] ? free_work+0x19/0x19 [mac80211]
[ 6702.614108]  [<ffffffff8104dd60>] process_one_work+0x17b/0x2bd
[ 6702.614118]  [<ffffffff8104c3a5>] ? need_to_create_worker+0x12/0x26
[ 6702.614129]  [<ffffffff8104ee5b>] worker_thread+0xdb/0x15f
[ 6702.614138]  [<ffffffff8104ed80>] ? manage_workers.isra.24+0x171/0x171
[ 6702.614149]  [<ffffffff81052541>] kthread+0x84/0x8c
[ 6702.614160]  [<ffffffff81408a14>] kernel_thread_helper+0x4/0x10
[ 6702.614172]  [<ffffffff810524bd>] ? kthread_worker_fn+0x148/0x148
[ 6702.614181]  [<ffffffff81408a10>] ? gs_change+0xb/0xb

Networkanager[2263]: <info> (wlan0): supplicant interface state: completed -> authenticating
[ 6702.812109] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[ 6703.012130] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[ 6703.212113] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out

and another few (3) WARNING in include/net/mac80211.h:3570 rate_control_send_low+0xa5/0x165

and the final hickup:
[ 6712.366859] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[ 6712.366964] iwlwifi 0000:06:00.0: Stopping AGG while state not ON or starting for 0 on 0 (0)
wpa_supplicant[2339]: Trying to authenticate with 00:24:c4:ab:bd:e0 (SSID='XXXXXXXX' freq=2412 MHz)
wpa_supplicant[2339]: CTRL-EVENT-DISCONNECTED bssid=00:24:c4:ab:bd:e0 reason=2
[ 6712.381957] cfg80211: Calling CRDA to update world regulatory domain

After that NM succeeds and the connections seems to be stable.

I have no idea if that helps you in any way?!

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BALLYCUMBER
One of the six half-read books lying somewhere in your bed.
			--- Douglas Adams, The Meaning of Liff
