Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1JZCu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 22:50:26 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46112 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1JZCuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 22:50:24 -0400
Date: Wed, 26 Oct 2011 11:50:14 +0900
From: Norbert Preining <preining@logic.at>
To: David Rientjes <rientjes@google.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111026025014.GB24956@gamma.logic.tuwien.ac.at>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111020045927.GB23044@gamma.logic.tuwien.ac.at> <1319119852.2111.2.camel@wwguy-ubuntu> <20111021012442.GB26758@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110231424500.17218@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On So, 23 Okt 2011, David Rientjes wrote:
> It'd be interesting to see if this problem still exists in linux-next 
> since some wireless changes went into that recently.  Please try the tree 
> at git://github.com/sfrothwell/linux-next.git

I didn't try that by now, but I tried current linux git where 
a lot of things went into, I am running on top of 7670c7010c.
With that I get:
- two different kernel bugs, the first one actually appearing several
  times
- after a short time no package goes out, but the addapter still believes
  to be associated.

Here is the dmesg output of the two kernel bugs and the following
hard reset.

BTW, that happened at the *critical* access point at the university.
At home I was before running hte same kernel without problem.
BUt it might be a suspend/resume problem, too, as I suspended the
computer and woke it up here.


[ 3279.808204] ------------[ cut here ]------------
[ 3279.808246] WARNING: at include/net/mac80211.h:3570 rate_control_send_low+0xa5/0x165 [mac80211]()
[ 3279.808254] Hardware name: VGN-Z11VN_B
[ 3279.808258] Modules linked in: rfcomm bnep vboxpci vboxnetadp vboxnetflt vboxdrv snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss iwlwifi snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq mac80211 btusb snd_timer bluetooth snd_seq_device firewire_ohci snd firewire_core sony_laptop crc16 soundcore mxm_wmi cfg80211 snd_page_alloc crc_itu_t rfkill joydev tpm_infineon
[ 3279.808379] Pid: 4956, comm: kworker/u:11 Tainted: G        W   3.1.0+ #40
[ 3279.808385] Call Trace:
[ 3279.808400]  [<ffffffff810376c1>] warn_slowpath_common+0x83/0x9b
[ 3279.808411]  [<ffffffff810376f3>] warn_slowpath_null+0x1a/0x1c
[ 3279.808438]  [<ffffffffa0158149>] rate_control_send_low+0xa5/0x165 [mac80211]
[ 3279.808459]  [<ffffffffa01b01c2>] rs_get_rate+0x146/0x254 [iwlwifi]
[ 3279.808486]  [<ffffffffa01585b1>] rate_control_get_rate+0x86/0x14c [mac80211]
[ 3279.808516]  [<ffffffffa015f632>] ieee80211_tx_h_rate_ctrl+0x1cb/0x3e4 [mac80211]
[ 3279.808546]  [<ffffffffa015fac9>] invoke_tx_handlers+0x69/0xf5 [mac80211]
[ 3279.808575]  [<ffffffffa015fcd2>] ieee80211_tx+0x7f/0xaf [mac80211]
[ 3279.808605]  [<ffffffffa0160172>] ieee80211_xmit+0x89/0x97 [mac80211]
[ 3279.808634]  [<ffffffffa0160d10>] ieee80211_tx_skb+0x57/0x5f [mac80211]
[ 3279.808659]  [<ffffffffa0152098>] ieee80211_send_nullfunc+0x5f/0x64 [mac80211]
[ 3279.808684]  [<ffffffffa01520ff>] ieee80211_mgd_probe_ap_send+0x62/0xe6 [mac80211]
[ 3279.808709]  [<ffffffffa01522fb>] ? ieee80211_recalc_ps+0x10/0x250 [mac80211]
[ 3279.808734]  [<ffffffffa0152960>] ieee80211_mgd_probe_ap+0xc9/0xd9 [mac80211]
[ 3279.808759]  [<ffffffffa0152a6b>] ieee80211_beacon_connection_loss_work+0xe2/0xed [mac80211]
[ 3279.808785]  [<ffffffffa0152989>] ? ieee80211_sta_monitor_work+0x19/0x19 [mac80211]
[ 3279.808797]  [<ffffffff8104d9cc>] process_one_work+0x17b/0x2bd
[ 3279.808807]  [<ffffffff8104c011>] ? need_to_create_worker+0x12/0x26
[ 3279.808818]  [<ffffffff8104eac7>] worker_thread+0xdb/0x15f
[ 3279.808829]  [<ffffffff8104e9ec>] ? manage_workers.isra.24+0x171/0x171
[ 3279.808839]  [<ffffffff81051ef2>] kthread+0x84/0x8c
[ 3279.808851]  [<ffffffff81401394>] kernel_thread_helper+0x4/0x10
[ 3279.808862]  [<ffffffff81051e6e>] ? kthread_worker_fn+0x148/0x148
[ 3279.808872]  [<ffffffff81401390>] ? gs_change+0xb/0xb
[ 3279.808879] ---[ end trace b7620f873182e7e3 ]---
[ 3284.284925] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[ 3284.344356] cfg80211: Calling CRDA to update world regulatory domain
[ 3284.351319] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[ 3284.445310] wlan0: authenticated
[ 3284.447486] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[ 3284.449486] wlan0: RX ReassocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=2)
[ 3284.449489] wlan0: associated
[ 3314.515741] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[ 3314.515762] ------------[ cut here ]------------
[ 3314.515800] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1101 iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]()
[ 3314.515808] Hardware name: VGN-Z11VN_B
[ 3314.515813] Modules linked in: rfcomm bnep vboxpci vboxnetadp vboxnetflt vboxdrv snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss iwlwifi snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq mac80211 btusb snd_timer bluetooth snd_seq_device firewire_ohci snd firewire_core sony_laptop crc16 soundcore mxm_wmi cfg80211 snd_page_alloc crc_itu_t rfkill joydev tpm_infineon
[ 3314.515937] Pid: 4954, comm: kworker/u:9 Tainted: G        W   3.1.0+ #40
[ 3314.515943] Call Trace:
[ 3314.515948]  <IRQ>  [<ffffffff810376c1>] warn_slowpath_common+0x83/0x9b
[ 3314.515973]  [<ffffffff810376f3>] warn_slowpath_null+0x1a/0x1c
[ 3314.515996]  [<ffffffffa01cdb0e>] iwl_trans_pcie_tx+0x180/0x661 [iwlwifi]
[ 3314.516009]  [<ffffffff810d14b3>] ? kmem_cache_alloc+0x44/0xb9
[ 3314.516030]  [<ffffffffa01b59f8>] iwlagn_tx_skb+0x862/0x901 [iwlwifi]
[ 3314.516048]  [<ffffffffa01abf8c>] iwlagn_mac_tx+0x131/0x1a2 [iwlwifi]
[ 3314.516069]  [<ffffffffa016abd6>] ? ieee80211_tx_h_fragment+0x16/0x22c [mac80211]
[ 3314.516098]  [<ffffffffa015ef24>] __ieee80211_tx+0x176/0x1cf [mac80211]
[ 3314.516117]  [<ffffffffa016ab48>] ? ieee80211_tx_h_calculate_duration+0x4c/0x65 [mac80211]
[ 3314.516147]  [<ffffffffa015fcea>] ieee80211_tx+0x97/0xaf [mac80211]
[ 3314.516178]  [<ffffffffa0160be6>] ieee80211_tx_pending+0xf0/0x1c3 [mac80211]
[ 3314.516191]  [<ffffffff8103cdd2>] tasklet_action+0x77/0xc2
[ 3314.516201]  [<ffffffff8103cf13>] __do_softirq+0xbc/0x1a5
[ 3314.516212]  [<ffffffff8103cb4f>] ? test_ti_thread_flag.constprop.16+0x9/0x16
[ 3314.516225]  [<ffffffff8140148c>] call_softirq+0x1c/0x30
[ 3314.516230]  <EOI>  [<ffffffff8100371a>] do_softirq+0x38/0x6e
[ 3314.516248]  [<ffffffff8103cbd9>] _local_bh_enable_ip.isra.12+0x7d/0xa0
[ 3314.516259]  [<ffffffff8103cc0a>] local_bh_enable_ip+0xe/0x10
[ 3314.516268]  [<ffffffff813ff657>] _raw_spin_unlock_bh+0x23/0x25
[ 3314.516291]  [<ffffffffa014ec70>] ieee80211_agg_tx_operational+0x99/0xa4 [mac80211]
[ 3314.516316]  [<ffffffffa014f7bf>] ieee80211_process_addba_resp+0xb8/0xf1 [mac80211]
[ 3314.516329]  [<ffffffff81064040>] ? arch_read_unlock+0xe/0xe
[ 3314.516355]  [<ffffffffa0156a38>] ieee80211_iface_work+0x130/0x2b5 [mac80211]
[ 3314.516381]  [<ffffffffa0156908>] ? ieee80211_teardown_sdata+0xcc/0xcc [mac80211]
[ 3314.516394]  [<ffffffff8104d9cc>] process_one_work+0x17b/0x2bd
[ 3314.516404]  [<ffffffff8104c011>] ? need_to_create_worker+0x12/0x26
[ 3314.516415]  [<ffffffff8104eac7>] worker_thread+0xdb/0x15f
[ 3314.516426]  [<ffffffff8104e9ec>] ? manage_workers.isra.24+0x171/0x171
[ 3314.516436]  [<ffffffff81051ef2>] kthread+0x84/0x8c
[ 3314.516447]  [<ffffffff81401394>] kernel_thread_helper+0x4/0x10
[ 3314.516458]  [<ffffffff81051e6e>] ? kthread_worker_fn+0x148/0x148
[ 3314.516467]  [<ffffffff81401390>] ? gs_change+0xb/0xb
[ 3314.516474] ---[ end trace b7620f873182e7e4 ]---
[ 3324.128094] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[ 3324.128105] iwlwifi 0000:06:00.0: Current read_ptr 14 write_ptr 31
[ 3324.128113] iwlwifi 0000:06:00.0: On demand firmware reload
[ 3324.128548] ieee80211 phy0: Hardware restart was requested
[ 3324.128657] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 3324.131680] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
PODE HOLE (n.)
A hole drilled in chipboard lavatory walls by homosexuals for any one
of a number of purposes.
			--- Douglas Adams, The Meaning of Liff
