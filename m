Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1KXGYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:24:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55813 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1KXGYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:24:01 -0500
MIME-Version: 1.0
In-Reply-To: <4ECD5CA7.4080606@arndnet.de>
References: <4EC6DE6B.3080603@arndnet.de>
	<4ECB65A5.3010009@arndnet.de>
	<CANUX_P1RXxRuybzj0gavVOkN-a3H_qRO45S1nc3oPq1aZe5V3g@mail.gmail.com>
	<4ECD5CA7.4080606@arndnet.de>
Date: Thu, 24 Nov 2011 08:23:59 +0200
Message-ID: <CANUX_P29L-o8-KQ_G9i1b8NzJtHcmRBbDS_88-oKMVU_jiMY8Q@mail.gmail.com>
Subject: Re: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I applied the QUEUE_DEBUG.patch you posted in the other thread, not sure if I'm experiencing the same problem:

Yes, it looks similar. Please enable the MAC80211_HT_DEBUG compilation flag too.
In any case now that I more the less see what is happening, I am
working now on another debug patch.

>
>
> [38275.502526] iwlwifi 0000:03:00.0: Tx aggregation enabled on ra = 30:46:9a:XX:XX:XX tid = 0
> [38283.406370] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_disable HW queue is empty
> [38283.406460] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38290.363252] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is empty
> [38291.358619] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_disable HW queue is empty
> [38291.358713] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38296.788459] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate BA Queue 11 on FIFO 1
> [38296.788475] iwlwifi 0000:03:00.0: Tx aggregation enabled on ra = 30:46:9a:XX:XX:XX tid = 0
> [38296.788489] ------------[ cut here ]------------
> [38296.788518] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1106 iwl_trans_pcie_tx+0xb71/0xb90 [iwlwifi]()
> [38296.788526] Hardware name: 4384GEG
> [38296.788529] Modules linked in: iwlwifi ip6table_filter ip6_tables bnep rfcomm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm joydev dm_crypt snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm arc4 snd_seq_midi snd_rawmidi binfmt_misc snd_seq_midi_event psmouse qcserial usb_wwan serio_raw snd_seq usbserial intel_ips btusb snd_timer snd_seq_device bluetooth mac80211 tpm_tis thinkpad_acpi cfg80211 nvram snd mei(C) soundcore snd_page_alloc btrfs zlib_deflate libcrc32c mxm_wmi e1000e ahci libahci sdhci_pci sdhci firewire_ohci i915 firewire_core drm_kms_helper crc_itu_t drm i2c_algo_bit wmi video [last unloaded: iwlwifi]
> [38296.788663] Pid: 6243, comm: kworker/u:23 Tainted: G        WC   3.2.0-rc2-aha+ #7
> [38296.788668] Call Trace:
> [38296.788672]  <IRQ>  [<ffffffff81062b9f>] warn_slowpath_common+0x7f/0xc0
> [38296.788690]  [<ffffffff81062bfa>] warn_slowpath_null+0x1a/0x20
> [38296.788712]  [<ffffffffa0580fd1>] iwl_trans_pcie_tx+0xb71/0xb90 [iwlwifi]
> [38296.788724]  [<ffffffff814f2b1d>] ? consume_skb+0x3d/0xb0
> [38296.788749]  [<ffffffffa028a0c8>] ? ccmp_encrypt_skb.isra.4+0x108/0x230 [mac80211]
> [38296.788759]  [<ffffffff8105a592>] ? default_wake_function+0x12/0x20
> [38296.788767]  [<ffffffff81086100>] ? remove_wait_queue+0x60/0x70
> [38296.788784]  [<ffffffffa05623e1>] ? iwlagn_tx_skb+0x161/0xb90 [iwlwifi]
> [38296.788802]  [<ffffffffa056277f>] iwlagn_tx_skb+0x4ff/0xb90 [iwlwifi]
> [38296.788815]  [<ffffffffa0559491>] iwlagn_mac_tx+0x121/0x1c0 [iwlwifi]
> [38296.788824]  [<ffffffff8103aa39>] ? default_spin_lock_flags+0x9/0x10
> [38296.788849]  [<ffffffffa02a2506>] __ieee80211_tx+0x76/0x230 [mac80211]
> [38296.788873]  [<ffffffffa02a451c>] ieee80211_tx+0x8c/0xc0 [mac80211]
> [38296.788896]  [<ffffffffa02a53fd>] ieee80211_tx_pending+0x7d/0x220 [mac80211]
> [38296.788905]  [<ffffffff8106a20d>] ? __do_softirq+0xfd/0x210
> [38296.788913]  [<ffffffff81069b78>] tasklet_action+0x78/0x140
> [38296.788920]  [<ffffffff8106a1b8>] __do_softirq+0xa8/0x210
> [38296.788930]  [<ffffffff8160e5ac>] call_softirq+0x1c/0x30
> [38296.788934]  <EOI>  [<ffffffff81015195>] do_softirq+0x65/0xa0
> [38296.788950]  [<ffffffff8106a104>] local_bh_enable_ip+0x94/0xa0
> [38296.788958]  [<ffffffff816043f9>] _raw_spin_unlock_bh+0x19/0x20
> [38296.788980]  [<ffffffffa028d8a9>] ieee80211_agg_tx_operational+0xb9/0xd0 [mac80211]
> [38296.789002]  [<ffffffffa0296a78>] ? ieee80211_iface_work+0xd8/0x350 [mac80211]
> [38296.789023]  [<ffffffffa028e0fe>] ieee80211_process_addba_resp+0x11e/0x120 [mac80211]
> [38296.789045]  [<ffffffffa0296c9f>] ieee80211_iface_work+0x2ff/0x350 [mac80211]
> [38296.789068]  [<ffffffffa02969a0>] ? ieee80211_teardown_sdata+0xe0/0xe0 [mac80211]
> [38296.789078]  [<ffffffff8108023a>] process_one_work+0x11a/0x480
> [38296.789085]  [<ffffffff81080fc4>] worker_thread+0x164/0x370
> [38296.789093]  [<ffffffff81080e60>] ? manage_workers.isra.30+0x230/0x230
> [38296.789099]  [<ffffffff8108573c>] kthread+0x8c/0xa0
> [38296.789105]  [<ffffffff8160e4b4>] kernel_thread_helper+0x4/0x10
> [38296.789111]  [<ffffffff810856b0>] ? flush_kthread_worker+0xa0/0xa0
> [38296.789119]  [<ffffffff8160e4b0>] ? gs_change+0x13/0x13
> [38296.789123] ---[ end trace 201230ed6208edbf ]---
> [38298.939515] iwlwifi 0000:03:00.0: Queue 11 stuck for 2000 ms.
> [38298.939523] iwlwifi 0000:03:00.0: Current read_ptr 197 write_ptr 2
> [38298.939528] iwlwifi 0000:03:00.0: On demand firmware reload
> [38298.939926] ieee80211 phy3: Hardware restart was requested
> [38298.940032] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [38298.940167] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
> [38299.006160] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 0 on FIFO 3
> [38299.006180] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 1 on FIFO 2
> [38299.006197] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 2 on FIFO 1
> [38299.006214] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 3 on FIFO 0
> [38299.006230] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Activate AC/CMD Queue 4 on FIFO 7
> [38301.596322] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38306.705156] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38306.820030] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38311.921881] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38312.027099] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 70 packets in HW queue
> [38317.138756] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38317.235476] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 140 packets in HW queue
> [38322.424187] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38322.767875] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38327.939631] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38328.086516] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38333.251181] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38333.540666] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38338.766575] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38338.969220] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38344.282421] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38344.409610] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38349.593755] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38349.680482] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38354.905092] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38355.233118] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38360.420658] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38361.314785] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 60 packets in HW queue
> [38376.705700] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38377.554487] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38382.687399] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38383.068691] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38388.203087] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38388.297090] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38393.514383] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38393.609374] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 69 packets in HW queue
> [38398.825772] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38399.038167] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38404.138245] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38404.794215] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38410.061196] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38411.198133] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38416.393938] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38416.527477] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 110 packets in HW queue
> [38421.705324] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38421.797204] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 87 packets in HW queue
> [38427.016619] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38429.109294] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38434.211841] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38435.229973] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 59 packets in HW queue
> [38473.797319] wlan0: deauthenticated from 30:46:9a:XX:XX:XX (Reason: 7)
> [38473.797417] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 11 on FIFO 0
> [38473.819945] iwlwifi 0000:03:00.0: Stopping AGG while state not ON or starting for 0 on 0 (0)
>
> Best regards,
> Arnd
>
