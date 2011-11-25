Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1KYMV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:21:56 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58572 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1KYMVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:21:54 -0500
Date: Fri, 25 Nov 2011 21:21:43 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111125122143.GA30404@gamma.logic.tuwien.ac.at>
References: <CANUX_P1RjcRD2tW1A6YYSEV9+aUZyTEro7tZXJWRoxk6gx-2jA@mail.gmail.com> <CANUX_P2aFn84uSqgZA2gTBN7E4+0jGmJQTkx4eug4Ls0hK0==Q@mail.gmail.com> <20111122072730.GA32225@gamma.logic.tuwien.ac.at> <CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com> <2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at> <CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com> <20111122124357.GA32440@gamma.logic.tuwien.ac.at> <CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com> <20111123015503.GC23203@gamma.logic.tuwien.ac.at> <CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

On Do, 24 Nov 2011, Emmanuel Grumbach wrote:
> Please apply the patch attached on top of the one I previously sent.
> Let me know I you have trouble with patch.

The patch you sent was not against kernel git, but I moved the
debug statement from iwl-mac80211.c to iwl-agn.c (where I guess is
the right place) and applied the rest of the patch.

> Please also enable the MAC80211_HT_DEBUG compilation flag
> I also the (HT + TXQUEUES) debug flag of the driver: modprobe iwlwifi
> debug=0x84000000

Also activated.

Here my very very small theory, but that is just guessing: Could it
be related to the time being adjusted by ntp or something? I have the
feeling it works for a bit, then hangs. In this little bit it might
be that ntp updates the time of the laptop. That would explain why 
on a full normal reboot it most of the times work, but when the laptop
sleeps for long time, or is turned of for long time, then it is
getting problems. But this is surely just a stupid theory.

Here we go with the debug output


[ 4592.437269] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 4592.441080] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 4592.482332] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 0
[ 4592.482346] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[ 4592.482349] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 1
[ 4592.482362] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[ 4592.482365] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 2
[ 4592.482377] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[ 4592.482380] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 3
[ 4592.482392] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[ 4592.482395] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 4
[ 4592.482407] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[ 4592.482410] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 5
[ 4592.482412] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 6
[ 4592.482415] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 7
[ 4592.482417] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 8
[ 4592.482419] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 9
[ 4592.482422] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 10
[ 4600.139699] wlan0: authenticate with 00:0a:79:eb:56:10 (try 1)
[ 4600.142190] wlan0: authenticated
[ 4600.148081] wlan0: associate with 00:0a:79:eb:56:10 (try 1)
[ 4600.153962] wlan0: RX AssocResp from 00:0a:79:eb:56:10 (capab=0x411 status=0 aid=2)
[ 4600.153972] wlan0: associated
[ 4601.280512] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4601.280525] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Rx
[ 4616.622380] iwlwifi 0000:06:00.0: I rs_tl_turn_on_agg_for_tid Starting Tx agg: STA: 00:0a:79:eb:56:10 tid: 0
[ 4616.652083] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4616.652087] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Tx
[ 4616.652090] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start TX AGG request on ra = 00:0a:79:eb:56:10 tid = 0
[ 4616.652238] iwlwifi 0000:06:00.0: U iwlagn_txq_ctx_activate_free Activate txq 11
[ 4616.652241] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is empty
[ 4616.652244] iwlwifi 0000:06:00.0: U iwl_start_tx_ba_trans_ready Telling mac start BA ready tid: 0
[ 4617.652070] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4617.652075] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action stop Tx
[ 4617.652077] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action Stop Tx agg for tid 0
[ 4617.652081] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_disable HW queue is empty
[ 4617.652139] iwlwifi 0000:06:00.0: U iwl_trans_pcie_txq_agg_disable Disable AGG txq_id 11
[ 4617.652192] iwlwifi 0000:06:00.0: U iwl_txq_ctx_deactivate Deactivate txq 11
[ 4617.652210] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[ 4617.652213] iwlwifi 0000:06:00.0: U iwl_stop_tx_ba_trans_ready Telling mac stop BA ready tid: 0
[ 4621.013744] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4621.013760] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_setup Setup AGG for tid 0
[ 4621.013916] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate BA Queue 11 on FIFO 1
[ 4621.013925] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action priv->agg_tids_count = 1
[ 4621.013937] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
[ 4621.013954] ------------[ cut here ]------------
[ 4621.013991] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1106 iwl_trans_pcie_tx+0x180/0x668 [iwlwifi]()
[ 4621.013999] Hardware name: VGN-Z11VN_B
[ 4621.014004] Modules linked in: usb_storage rfcomm bnep vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) snd_hrtimer binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse loop uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm iwlwifi mac80211 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event btusb sony_laptop(O) bluetooth snd_seq snd_timer snd_seq_device snd soundcore cfg80211 firewire_ohci firewire_core mxm_wmi joydev rfkill tpm_infineon snd_page_alloc crc16 crc_itu_t
[ 4621.014134] Pid: 6169, comm: kworker/u:44 Tainted: G        W  O 3.2.0-rc3+ #2
[ 4621.014140] Call Trace:
[ 4621.014145]  <IRQ>  [<ffffffff8103849d>] warn_slowpath_common+0x83/0x9b
[ 4621.014171]  [<ffffffff810384cf>] warn_slowpath_null+0x1a/0x1c
[ 4621.014194]  [<ffffffffa0204f4d>] iwl_trans_pcie_tx+0x180/0x668 [iwlwifi]
[ 4621.014208]  [<ffffffff810d3861>] ? kmem_cache_alloc+0x44/0xb9
[ 4621.014229]  [<ffffffffa01eca7d>] iwlagn_tx_skb+0x87b/0x91b [iwlwifi]
[ 4621.014247]  [<ffffffffa01e2fea>] iwlagn_mac_tx+0x131/0x1a2 [iwlwifi]
[ 4621.014268]  [<ffffffffa01c1cc6>] ? ieee80211_tx_h_fragment+0x16/0x22c [mac80211]
[ 4621.014296]  [<ffffffffa01b6000>] __ieee80211_tx+0x176/0x1cf [mac80211]
[ 4621.014314]  [<ffffffffa01c1c38>] ? ieee80211_tx_h_calculate_duration+0x4c/0x65 [mac80211]
[ 4621.014344]  [<ffffffffa01b6dc6>] ieee80211_tx+0x97/0xaf [mac80211]
[ 4621.014374]  [<ffffffffa01b7cc2>] ieee80211_tx_pending+0xf0/0x1c3 [mac80211]
[ 4621.014386]  [<ffffffff8103dc16>] tasklet_action+0x77/0xc2
[ 4621.014395]  [<ffffffff8103dd57>] __do_softirq+0xbc/0x1a5
[ 4621.014408]  [<ffffffff8140b24c>] call_softirq+0x1c/0x30
[ 4621.014413]  <EOI>  [<ffffffff8100359e>] do_softirq+0x38/0x6e
[ 4621.014430]  [<ffffffff8103da1d>] _local_bh_enable_ip.isra.12+0x7d/0xa0
[ 4621.014439]  [<ffffffff8103da4e>] local_bh_enable_ip+0xe/0x10
[ 4621.014448]  [<ffffffff81409462>] _raw_spin_unlock_bh+0x23/0x25
[ 4621.014471]  [<ffffffffa01a5c6c>] ieee80211_agg_tx_operational+0x99/0xa4 [mac80211]
[ 4621.014496]  [<ffffffffa01a67bd>] ieee80211_process_addba_resp+0xb8/0xf3 [mac80211]
[ 4621.014508]  [<ffffffff81064840>] ? do_raw_spin_trylock+0x18/0x2a
[ 4621.014534]  [<ffffffffa01adada>] ieee80211_iface_work+0x130/0x2b5 [mac80211]
[ 4621.014560]  [<ffffffffa01ad9aa>] ? ieee80211_teardown_sdata+0xcc/0xcc [mac80211]
[ 4621.014572]  [<ffffffff8104de54>] process_one_work+0x17b/0x2bd
[ 4621.014583]  [<ffffffff8104c499>] ? need_to_create_worker+0x12/0x26
[ 4621.014593]  [<ffffffff8104ef4f>] worker_thread+0xdb/0x15f
[ 4621.014602]  [<ffffffff8104ee74>] ? manage_workers.isra.24+0x171/0x171
[ 4621.014612]  [<ffffffff81052639>] kthread+0x84/0x8c
[ 4621.014622]  [<ffffffff8140b154>] kernel_thread_helper+0x4/0x10
[ 4621.014633]  [<ffffffff810525b5>] ? kthread_worker_fn+0x148/0x148
[ 4621.014642]  [<ffffffff8140b150>] ? gs_change+0xb/0xb
[ 4621.014649] ---[ end trace 81df68812429b16c ]---
[ 4622.112804] iwlwifi 0000:06:00.0: I rs_tl_turn_on_agg_for_tid Starting Tx agg: STA: 00:0a:79:eb:56:10 tid: 0
[ 4622.124104] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4622.124116] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Tx
[ 4622.124126] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start TX AGG request on ra = 00:0a:79:eb:56:10 tid = 0
[ 4622.124304] iwlwifi 0000:06:00.0: U iwlagn_txq_ctx_activate_free Activate txq 11
[ 4622.124315] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 21 packets in HW queue
[ 4630.040070] iwlwifi 0000:06:00.0: Queue 11 stuck for 10000 ms.
[ 4630.040081] iwlwifi 0000:06:00.0: Current SW read_ptr 242 write_ptr 8
[ 4630.040136] iwlwifi 0000:06:00.0: Current HW read_ptr 242 write_ptr 8
[ 4630.040144] iwlwifi 0000:06:00.0: On demand firmware reload
[ 4630.040587] ieee80211 phy0: Hardware restart was requested
[ 4630.040698] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
[ 4630.043703] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 4630.086602] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 0
[ 4630.086624] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
[ 4630.086634] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 1
[ 4630.086653] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
[ 4630.086662] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 2
[ 4630.086681] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
[ 4630.086690] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 3
[ 4630.086709] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
[ 4630.086717] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 4
[ 4630.086736] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
[ 4630.086745] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 5
[ 4630.086752] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 6
[ 4630.086759] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 7
[ 4630.086767] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 8
[ 4630.086774] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 9
[ 4630.086781] iwlwifi 0000:06:00.0: U iwl_txq_ctx_activate Activate txq 10
[ 4630.157921] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4630.157933] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action stop Tx
[ 4630.157942] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action Stop Tx agg for tid 0
[ 4630.157951] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_disable AGG stop before setup done
[ 4630.157992] iwlwifi 0000:06:00.0: U iwl_trans_pcie_txq_agg_disable Disable AGG txq_id 11
[ 4630.158073] iwlwifi 0000:06:00.0: U iwl_txq_ctx_deactivate Deactivate txq 11
[ 4630.158113] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
[ 4630.158123] iwlwifi 0000:06:00.0: U iwl_stop_tx_ba_trans_ready Telling mac stop BA ready tid: 0
[ 4630.158136] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action priv->agg_tids_count = 0
[ 4630.158148] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4630.158157] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action stop Rx
[ 4630.196845] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4630.196857] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Rx
[ 4632.759183] iwlwifi 0000:06:00.0: I rs_tl_turn_on_agg_for_tid Starting Tx agg: STA: 00:0a:79:eb:56:10 tid: 0
[ 4632.812124] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 0
[ 4632.812136] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Tx
[ 4632.812145] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start TX AGG request on ra = 00:0a:79:eb:56:10 tid = 0
[ 4632.812326] iwlwifi 0000:06:00.0: U iwlagn_txq_ctx_activate_free Activate txq 11
[ 4632.812337] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 21 packets in HW queue
[ 4634.916847] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 6
[ 4634.916860] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Rx
[ 4644.716439] iwlwifi 0000:06:00.0: I rs_tl_turn_on_agg_for_tid Starting Tx agg: STA: 00:0a:79:eb:56:10 tid: 6
[ 4644.764120] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 6
[ 4644.764132] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action start Tx
[ 4644.764142] iwlwifi 0000:06:00.0: U iwlagn_tx_agg_start TX AGG request on ra = 00:0a:79:eb:56:10 tid = 6
[ 4644.764306] iwlwifi 0000:06:00.0: U iwlagn_txq_ctx_activate_free Activate txq 12
[ 4644.764315] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is empty
[ 4644.764325] iwlwifi 0000:06:00.0: U iwl_start_tx_ba_trans_ready Telling mac start BA ready tid: 6
[ 4644.766328] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action A-MPDU action on addr 00:0a:79:eb:56:10 tid 6
[ 4644.766339] iwlwifi 0000:06:00.0: U iwl_trans_pcie_tx_agg_setup Setup AGG for tid 6
[ 4644.766494] iwlwifi 0000:06:00.0: U iwl_trans_tx_queue_set_status Activate BA Queue 12 on FIFO 3
[ 4644.766503] iwlwifi 0000:06:00.0: U iwlagn_mac_ampdu_action priv->agg_tids_count = 1
[ 4644.766549] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
[ 4703.713625] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_compressed_ba agg frames sent:2, acked:2


Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BRISBANE
A perfectly reasonable explanation (Such as the one offered by a
person with a gurgling cough which has nothing to do with the fact
that they smoke fifty cigarettes a day.)
			--- Douglas Adams, The Meaning of Liff
