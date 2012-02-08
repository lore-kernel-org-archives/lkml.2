Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2BHRXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:23:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2BHRXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:23:38 -0500
Date: Wed, 8 Feb 2012 12:23:21 -0500
From: Dave Jones <davej@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: iwlagn: wrong command queue backtrace.
Message-ID: <20120208172320.GA30819@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just hit this with the iwlagn driver currently in Linus' tree.

	Dave

[ 2794.976476] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:859 iwl_tx_cmd_complete+0x35f/0x3b0 [iwlwifi]()
[ 2794.976978] Hardware name: Adamo 13   
[ 2794.977271] wrong command queue 0 (should be 4), sequence 0x0 readp=141 writep=141
[ 2794.977631] Modules linked in: nfs fscache auth_rpcgss nfs_acl fuse lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xts gf128mul dm_crypt dm_mirror dm_region_hash dm_log arc4 iwlwifi mac80211 dell_wmi sparse_keymap uvcvideo videobuf2_core dell_laptop videodev dcdbas media v4l2_compat_ioctl32 cfg80211 videobuf2_vmalloc videobuf2_memops joydev microcode pcspkr i2c_i801 snd_hda_codec_hdmi snd_hda_codec_idt iTCO_wdt iTCO_vendor_support snd_hda_intel cdc_ether tg3 usbnet mii rfkill snd_hda_codec cdc_wdm cdc_acm snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer wmi snd soundcore snd_page_alloc sunrpc i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2794.981421] Pid: 2089, comm: firefox Not tainted 3.3.0-rc2+ #25
[ 2794.981709] Call Trace:
[ 2794.981833]  <IRQ>  [<ffffffff810639ef>] warn_slowpath_common+0x7f/0xc0
[ 2794.982200]  [<ffffffffa03e35cb>] ? iwl_rx_queue_update_write_ptr+0x11b/0x420 [iwlwifi]
[ 2794.982582]  [<ffffffff81063ae6>] warn_slowpath_fmt+0x46/0x50
[ 2794.982858]  [<ffffffff8169cdae>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[ 2794.983203]  [<ffffffffa03ea13f>] iwl_tx_cmd_complete+0x35f/0x3b0 [iwlwifi]
[ 2794.983559]  [<ffffffffa03cde9d>] ? iwl_rx_dispatch+0x18d/0x280 [iwlwifi]
[ 2794.983853]  [<ffffffffa03e4416>] iwl_irq_tasklet+0x4a6/0x1ea0 [iwlwifi]
[ 2794.984155]  [<ffffffff810a5e25>] ? sched_clock_local+0x25/0x90
[ 2794.984452]  [<ffffffff8106be4d>] tasklet_action+0x9d/0x240
[ 2794.984713]  [<ffffffff8106ca78>] __do_softirq+0xc8/0x3f0
[ 2794.984988]  [<ffffffff8110fb86>] ? handle_edge_irq+0x96/0x130
[ 2794.985261]  [<ffffffff816a63ec>] call_softirq+0x1c/0x30
[ 2794.985518]  [<ffffffff8101c485>] do_softirq+0xa5/0xe0
[ 2794.985772]  [<ffffffff8106d116>] irq_exit+0xa6/0xf0
[ 2794.986025]  [<ffffffff816a6c83>] do_IRQ+0x63/0xd0
[ 2794.986252]  [<ffffffff8169d4f3>] common_interrupt+0x73/0x73
[ 2794.986528]  <EOI>  [<ffffffff816a4ed5>] ? sysret_check+0x22/0x5d
[ 2794.986821] ---[ end trace 52c6d1ba01cc035b ]---
[ 2794.987057] iwl data: 00000000: 00 00 55 55 00 e1 00 00 00 e1 00 00 00 d5 01 00  ..UU............
[ 2794.987473] iwl data: 00000010: 00 e1 00 00 00 e1 00 00 00 3c 00 00 00 d5 01 00  .........<......
[ 2794.987882] iwlwifi 0000:04:00.0: iwl_tx_queue_reclaim: Read index for DMA queue txq id (11), last_to_free 186 is out of range [0-256] 123 33.
[ 2798.210185] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_ADD_STA: time out after 2000ms.
[ 2798.210725] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 145
[ 2798.211301] HW problem - can not stop rx aggregation for tid 0
[ 2800.212108] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_QOS_PARAM: time out after 2000ms.
[ 2800.212646] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 148
[ 2800.213202] iwlwifi 0000:04:00.0: U iwlagn_update_qos Failed to update QoS
[ 2802.213077] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_RXON: time out after 2000ms.
[ 2802.213510] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 151
[ 2802.213926] iwlwifi 0000:04:00.0: U iwlagn_disable_bss Error clearing ASSOC_MSK on BSS (-110)
[ 2804.214085] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_RXON: time out after 2000ms.
[ 2804.214525] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 154
[ 2804.214942] iwlwifi 0000:04:00.0: U iwlagn_disable_bss Error clearing ASSOC_MSK on BSS (-110)
[ 2806.215153] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_RXON: time out after 2000ms.
[ 2806.215606] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 157
[ 2806.216063] iwlwifi 0000:04:00.0: U iwlagn_disable_bss Error clearing ASSOC_MSK on BSS (-110)
[ 2808.217156] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_ADD_STA: time out after 2000ms.
[ 2808.217694] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 160
[ 2808.218281] ieee80211 phy0: failed to remove key (0, b8:c7:5d:0c:39:87) from hardware (-110)
[ 2808.222447] wlan0: moving STA b8:c7:5d:0c:39:87 to state 2
[ 2808.222455] wlan0: moving STA b8:c7:5d:0c:39:87 to state 1
[ 2808.222463] wlan0: moving STA b8:c7:5d:0c:39:87 to state 0
[ 2810.222093] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_REMOVE_STA: time out after 2000ms.
[ 2810.222577] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 163
[ 2810.223085] iwlwifi 0000:04:00.0: U iwlagn_mac_sta_remove Error removing station b8:c7:5d:0c:39:87
[ 2812.234208] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_ADD_STA: time out after 2000ms.
[ 2812.234737] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 166
[ 2812.235299] ieee80211 phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-110)
[ 2814.240107] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Error sending REPLY_ADD_STA: time out after 2000ms.
[ 2814.240639] iwlwifi 0000:04:00.0: U iwl_send_cmd_sync Current CMD queue read_ptr 141 write_ptr 169
[ 2814.241203] ieee80211 phy0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-110)
[ 2814.246613] cfg80211: Calling CRDA to update world regulatory domain
[ 2814.704148] iwlwifi 0000:04:00.0: No space in command queue
[ 2814.704413] iwlwifi 0000:04:00.0: Restarting adapter queue is full
[ 2814.705084] iwlwifi 0000:04:00.0: I iwl_send_cmd_async Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -28
[ 2816.707156] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues
[ 2816.709343] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
[ 2816.709343] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
[ 2816.709343] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
[ 2816.709343] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
[ 2816.751292] iwlwifi 0000:04:00.0: Request scan called when driver not ready.
[ 2816.751686] ieee80211 phy0: Hardware restart was requested


