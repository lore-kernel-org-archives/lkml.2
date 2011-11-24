Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1KXVzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:55:42 -0500
Received: from mail2.unitix.de ([176.9.2.175]:35391 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab1KXVzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:55:40 -0500
Message-ID: <4ECEBD5A.9090307@arndnet.de>
Date: Thu, 24 Nov 2011 22:55:38 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc2: WARNING: at iwlwifi/wl-trans-pcie.c:1105
References: <4EC6DE6B.3080603@arndnet.de> <4ECB65A5.3010009@arndnet.de> <CANUX_P1RXxRuybzj0gavVOkN-a3H_qRO45S1nc3oPq1aZe5V3g@mail.gmail.com> <4ECD5CA7.4080606@arndnet.de> <CANUX_P29L-o8-KQ_G9i1b8NzJtHcmRBbDS_88-oKMVU_jiMY8Q@mail.gmail.com>
In-Reply-To: <CANUX_P29L-o8-KQ_G9i1b8NzJtHcmRBbDS_88-oKMVU_jiMY8Q@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 24.11.2011 07:23, schrieb Emmanuel Grumbach:
>>
>> I applied the QUEUE_DEBUG.patch you posted in the other thread, not sure if I'm experiencing the same problem:
> 
> Yes, it looks similar. Please enable the MAC80211_HT_DEBUG compilation flag too.
> In any case now that I more the less see what is happening, I am
> working now on another debug patch.

Here you are, 3.2.0-rc3 with enabled MAC80211_HT_DEBUG and your QUEUE_DEBUG.patch:

[  396.963871] switched off addBA timer for tid 0
[  396.963877] Aggregation is on for tid 0
[  396.964022] iwlwifi 0000:03:00.0: U iwl_trans_tx_queue_set_status Deactivate BA Queue 11 on FIFO 1
[  396.964037] iwlwifi 0000:03:00.0: Tx aggregation enabled on ra = 30:46:9a:XX:XX:XX tid = 0
[  396.964052] ------------[ cut here ]------------
[  396.964079] WARNING: at /home/arnd/Projekte/kernel/linux-2.6/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1106 iwl_trans_pcie_tx+0xb71/0xb90 [iwlwifi]()
[  396.964086] Hardware name: 4384GEG
[  396.964090] Modules linked in: iwlwifi ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ip6table_filter ip6_tables bnep rfcomm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm joydev dm_crypt arc4 qcserial usb_wwan usbserial btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_conexant binfmt_misc thinkpad_acpi snd_hda_intel snd_hda_codec snd_hwdep snd_seq_midi snd_pcm snd_rawmidi psmouse serio_raw snd_seq_midi_event snd_seq snd_timer snd_seq_device intel_ips mac80211 snd cfg80211 snd_page_alloc soundcore tpm_tis nvram mei(C) btrfs zlib_deflate libcrc32c mxm_wmi firewire_ohci wmi firewire_core crc_itu_t sdhci_pci sdhci ahci libahci i915 drm_kms_helper drm e1000e i2c_algo_bit video [last unloaded: iwlwifi]
[  396.964231] Pid: 308, comm: kworker/u:4 Tainted: G         C   3.2.0-rc3-aha+ #8
[  396.964237] Call Trace:
[  396.964241]  <IRQ>  [<ffffffff81062b7f>] warn_slowpath_common+0x7f/0xc0
[  396.964259]  [<ffffffff81062bda>] warn_slowpath_null+0x1a/0x20
[  396.964279]  [<ffffffffa0762fd1>] iwl_trans_pcie_tx+0xb71/0xb90 [iwlwifi]
[  396.964304]  [<ffffffffa026b0c8>] ? ccmp_encrypt_skb.isra.4+0x108/0x230 [mac80211]
[  396.964321]  [<ffffffffa07443e1>] ? iwlagn_tx_skb+0x161/0xb90 [iwlwifi]
[  396.964336]  [<ffffffffa074477f>] iwlagn_tx_skb+0x4ff/0xb90 [iwlwifi]
[  396.964348]  [<ffffffffa073b491>] iwlagn_mac_tx+0x121/0x1c0 [iwlwifi]
[  396.964356]  [<ffffffff8103aa39>] ? default_spin_lock_flags+0x9/0x10
[  396.964376]  [<ffffffffa0283806>] __ieee80211_tx+0x76/0x230 [mac80211]
[  396.964394]  [<ffffffffa028581c>] ieee80211_tx+0x8c/0xc0 [mac80211]
[  396.964412]  [<ffffffffa02866fd>] ieee80211_tx_pending+0x7d/0x220 [mac80211]
[  396.964420]  [<ffffffff8104a13c>] ? resched_task+0x2c/0x80
[  396.964426]  [<ffffffff81069b58>] tasklet_action+0x78/0x140
[  396.964432]  [<ffffffff8106a198>] __do_softirq+0xa8/0x210
[  396.964439]  [<ffffffff8160e5ec>] call_softirq+0x1c/0x30
[  396.964441]  <EOI>  [<ffffffff81015195>] do_softirq+0x65/0xa0
[  396.964451]  [<ffffffff8106a0e4>] local_bh_enable_ip+0x94/0xa0
[  396.964456]  [<ffffffff81604439>] _raw_spin_unlock_bh+0x19/0x20
[  396.964471]  [<ffffffffa026e9a9>] ieee80211_agg_tx_operational+0xc9/0xe0 [mac80211]
[  396.964486]  [<ffffffffa026f2a4>] ieee80211_process_addba_resp+0x114/0x150 [mac80211]
[  396.964503]  [<ffffffffa0277f6f>] ieee80211_iface_work+0x2ff/0x350 [mac80211]
[  396.964520]  [<ffffffffa0277c70>] ? ieee80211_teardown_sdata+0xe0/0xe0 [mac80211]
[  396.964527]  [<ffffffff8108021a>] process_one_work+0x11a/0x480
[  396.964533]  [<ffffffff814f2ab7>] ? __kfree_skb+0x47/0xa0
[  396.964538]  [<ffffffff81080fa4>] worker_thread+0x164/0x370
[  396.964543]  [<ffffffff81080e40>] ? manage_workers.isra.30+0x230/0x230
[  396.964548]  [<ffffffff8108571c>] kthread+0x8c/0xa0
[  396.964553]  [<ffffffff8160e4f4>] kernel_thread_helper+0x4/0x10
[  396.964558]  [<ffffffff81085690>] ? flush_kthread_worker+0xa0/0xa0
[  396.964563]  [<ffffffff8160e4f0>] ? gs_change+0x13/0x13
[  396.964566] ---[ end trace d76891b9559c3dcc ]---
[  396.964741] Stopping Tx BA session for 30:46:9a:XX:XX:XX tid 0
[  397.804618] Open BA session requested for 30:46:9a:XX:XX:XX tid 0
[  397.844951] iwlwifi 0000:03:00.0: U iwl_trans_pcie_tx_agg_alloc HW queue is NOT empty: 44 packets in HW queue
[  397.844964] activated addBA response timer on tid 0
[  397.847025] switched off addBA timer for tid 0
[  399.230074] iwlwifi 0000:03:00.0: Queue 11 stuck for 2000 ms.
[  399.230081] iwlwifi 0000:03:00.0: Current read_ptr 12 write_ptr 57
[  399.230086] iwlwifi 0000:03:00.0: On demand firmware reload
[  399.230449] ieee80211 phy1: Hardware restart was requested
[  399.230536] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[  399.237213] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1

Best regards
Arnd

