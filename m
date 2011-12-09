Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1LITmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:42:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1LITmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:42:12 -0500
Date: Fri, 9 Dec 2011 14:42:08 -0500
From: Dave Jones <davej@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: iwlagn unusable in 3.2.0rc4.
Message-ID: <20111209194208.GA15236@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've hit this hard panic four times in the last few hours. iwlagn has gotten
so bad, it's basically unusable for me now.

https://twitpic.com/7qwxp6

Intel Corporation Ultimate N WiFi Link 5300
firmware version 8.83.5.1 build 33692

Some other stuff in the logs from just before the crashes..


13:07:31 adamo kernel: [ 2066.692256] ------------[ cut here ]------------
13:07:31 adamo kernel: [ 2066.692567] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:928 iwl_tx_cmd_complete+0x366/0x3b0 [iwlwifi]()
13:07:31 adamo kernel: [ 2066.693191] Hardware name: Adamo 13   
13:07:31 adamo kernel: [ 2066.693414] wrong command queue 11 (should be 4), sequence 0x6B6B readp=252 writep=253
13:07:31 adamo kernel: [ 2066.693863] Modules linked in: ppdev parport_pc lp parport fuse nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables xts gf128mul dm_crypt arc4 iwlwifi mac80211 uvcvideo dell_wmi snd_hda_codec_hdmi sparse_keymap snd_hda_codec_idt videodev media snd_hda_intel snd_usb_audio v4l2_compat_ioctl32 snd_hda_codec snd_usbmidi_lib snd_hwdep snd_rawmidi cdc_ether cdc_acm snd_seq usbnet mii cdc_wdm snd_seq_device snd_pcm dell_laptop dcdbas microcode joydev cfg80211 snd_timer iTCO_wdt pcspkr i2c_i801 snd iTCO_vendor_support tg3 soundcore snd_page_alloc rfkill wmi sunrpc btrfs zlib_deflate libcrc32c i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
13:07:31 adamo kernel: [ 2066.698632] Pid: 0, comm: swapper/0 Not tainted 3.2.0-rc4+ #19
13:07:31 adamo kernel: [ 2066.698964] Call Trace:
13:07:31 adamo kernel: [ 2066.699139]  <IRQ>  [<ffffffff8107f5bf>] warn_slowpath_common+0x7f/0xc0
13:07:31 adamo kernel: [ 2066.699539]  [<ffffffff8107f6b6>] warn_slowpath_fmt+0x46/0x50
13:07:31 adamo kernel: [ 2066.699885]  [<ffffffffa04779b6>] iwl_tx_cmd_complete+0x366/0x3b0 [iwlwifi]
13:07:31 adamo kernel: [ 2066.700319]  [<ffffffffa0471e4e>] iwl_irq_tasklet+0x4ae/0x1ea0 [iwlwifi]
13:07:31 adamo kernel: [ 2066.700699]  [<ffffffff8168278e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
13:07:31 adamo kernel: [ 2066.701103]  [<ffffffff810873bd>] tasklet_action+0x9d/0x240
13:07:31 adamo kernel: [ 2066.701418]  [<ffffffff81088218>] __do_softirq+0xc8/0x3d0
13:07:31 adamo kernel: [ 2066.701725]  [<ffffffff8168c7fc>] call_softirq+0x1c/0x30
13:07:31 adamo kernel: [ 2066.702063]  [<ffffffff8101c385>] do_softirq+0xa5/0xe0
13:07:31 adamo kernel: [ 2066.702359]  [<ffffffff81088896>] irq_exit+0xa6/0xf0
13:07:31 adamo kernel: [ 2066.702638]  [<ffffffff8168d0d3>] do_IRQ+0x63/0xd0
13:07:31 adamo kernel: [ 2066.702912]  [<ffffffff81682eb3>] common_interrupt+0x73/0x73
13:07:31 adamo kernel: [ 2066.703255]  <EOI>  [<ffffffff81021f72>] ? native_sched_clock+0x22/0x80
13:07:31 adamo kernel: [ 2066.703652]  [<ffffffff813a0445>] ? acpi_idle_enter_bm+0x23d/0x286
13:07:31 adamo kernel: [ 2066.703997]  [<ffffffff8139f61b>] ? arch_local_irq_enable+0x8/0xd
13:07:31 adamo kernel: [ 2066.704388]  [<ffffffff810c2bbd>] ? trace_hardirqs_on+0xd/0x10
13:07:31 adamo kernel: [ 2066.704721]  [<ffffffff813a044a>] acpi_idle_enter_bm+0x242/0x286
13:07:31 adamo kernel: [ 2066.705084]  [<ffffffff815086f7>] cpuidle_idle_call+0xb7/0x600
13:07:31 adamo kernel: [ 2066.705412]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
13:07:31 adamo kernel: [ 2066.705698]  [<ffffffff81658c81>] rest_init+0xd5/0xe4
13:07:31 adamo kernel: [ 2066.705984]  [<ffffffff81658bac>] ? csum_partial_copy_generic+0x16c/0x16c
13:07:31 adamo kernel: [ 2066.706389]  [<ffffffff81f69c2a>] start_kernel+0x3e6/0x3f1
13:07:31 adamo kernel: [ 2066.706703]  [<ffffffff81f69347>] x86_64_start_reservations+0x132/0x136
13:07:31 adamo kernel: [ 2066.707241]  [<ffffffff81f69140>] ? early_idt_handlers+0x140/0x140
13:07:31 adamo kernel: [ 2066.707587]  [<ffffffff81f6944d>] x86_64_start_kernel+0x102/0x111
13:07:31 adamo kernel: [ 2066.707937] ---[ end trace f31feae70af2c408 ]---
13:07:31 adamo kernel: [ 2066.708241] iwl data: 00000000: 00 00 55 55 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ..UUkkkkkkkkkkkk
13:07:31 adamo kernel: [ 2066.708731] iwl data: 00000010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
13:07:31 adamo kernel: [ 2066.709247] ------------[ cut here ]------------
13:07:31 adamo kernel: [ 2066.709532] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:928 iwl_tx_cmd_complete+0x366/0x3b0 [iwlwifi]()
13:07:31 adamo kernel: [ 2066.710147] Hardware name: Adamo 13   
13:07:31 adamo kernel: [ 2066.710360] wrong command queue 11 (should be 4), sequence 0x6B6B readp=252 writep=253
13:07:31 adamo kernel: [ 2066.710789] Modules linked in: ppdev parport_pc lp parport fuse nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables xts gf128mul dm_crypt arc4 iwlwifi mac80211 uvcvideo dell_wmi snd_hda_codec_hdmi sparse_keymap snd_hda_codec_idt videodev media snd_hda_intel snd_usb_audio v4l2_compat_ioctl32 snd_hda_codec snd_usbmidi_lib snd_hwdep snd_rawmidi cdc_ether cdc_acm snd_seq usbnet mii cdc_wdm snd_seq_device snd_pcm dell_laptop dcdbas microcode joydev cfg80211 snd_timer iTCO_wdt pcspkr i2c_i801 snd iTCO_vendor_support tg3 soundcore snd_page_alloc rfkill wmi sunrpc btrfs zlib_deflate libcrc32c i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
13:07:31 adamo kernel: [ 2066.715663] Pid: 0, comm: swapper/0 Tainted: G        W    3.2.0-rc4+ #19
13:07:31 adamo kernel: [ 2066.716059] Call Trace:
13:07:31 adamo kernel: [ 2066.716208]  <IRQ>  [<ffffffff8107f5bf>] warn_slowpath_common+0x7f/0xc0
13:07:31 adamo kernel: [ 2066.716596]  [<ffffffff8107f6b6>] warn_slowpath_fmt+0x46/0x50
13:07:31 adamo kernel: [ 2066.716939]  [<ffffffffa04779b6>] iwl_tx_cmd_complete+0x366/0x3b0 [iwlwifi]
13:07:31 adamo kernel: [ 2066.717371]  [<ffffffffa0471e4e>] iwl_irq_tasklet+0x4ae/0x1ea0 [iwlwifi]
13:07:31 adamo kernel: [ 2066.717744]  [<ffffffff8168278e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
13:07:31 adamo kernel: [ 2066.718147]  [<ffffffff810873bd>] tasklet_action+0x9d/0x240
13:07:31 adamo kernel: [ 2066.718468]  [<ffffffff81088218>] __do_softirq+0xc8/0x3d0
13:07:31 adamo kernel: [ 2066.718774]  [<ffffffff8168c7fc>] call_softirq+0x1c/0x30
13:07:31 adamo kernel: [ 2066.719098]  [<ffffffff8101c385>] do_softirq+0xa5/0xe0
13:07:31 adamo kernel: [ 2066.719387]  [<ffffffff81088896>] irq_exit+0xa6/0xf0
13:07:31 adamo kernel: [ 2066.719667]  [<ffffffff8168d0d3>] do_IRQ+0x63/0xd0
13:07:31 adamo kernel: [ 2066.719939]  [<ffffffff81682eb3>] common_interrupt+0x73/0x73
13:07:31 adamo kernel: [ 2066.720275]  <EOI>  [<ffffffff81021f72>] ? native_sched_clock+0x22/0x80
13:07:31 adamo kernel: [ 2066.720670]  [<ffffffff813a0445>] ? acpi_idle_enter_bm+0x23d/0x286
13:07:31 adamo kernel: [ 2066.721031]  [<ffffffff8139f61b>] ? arch_local_irq_enable+0x8/0xd
13:07:31 adamo kernel: [ 2066.721377]  [<ffffffff810c2bbd>] ? trace_hardirqs_on+0xd/0x10
13:07:31 adamo kernel: [ 2066.721704]  [<ffffffff813a044a>] acpi_idle_enter_bm+0x242/0x286
13:07:31 adamo kernel: [ 2066.722065]  [<ffffffff815086f7>] cpuidle_idle_call+0xb7/0x600
13:07:31 adamo kernel: [ 2066.722401]  [<ffffffff81019235>] cpu_idle+0xd5/0x140
13:07:31 adamo kernel: [ 2066.722686]  [<ffffffff81658c81>] rest_init+0xd5/0xe4
13:07:31 adamo kernel: [ 2066.722981]  [<ffffffff81658bac>] ? csum_partial_copy_generic+0x16c/0x16c
13:07:31 adamo kernel: [ 2066.723386]  [<ffffffff81f69c2a>] start_kernel+0x3e6/0x3f1
13:07:31 adamo kernel: [ 2066.723698]  [<ffffffff81f69347>] x86_64_start_reservations+0x132/0x136
13:07:31 adamo kernel: [ 2066.724088]  [<ffffffff81f69140>] ? early_idt_handlers+0x140/0x140
13:07:31 adamo kernel: [ 2066.724438]  [<ffffffff81f6944d>] x86_64_start_kernel+0x102/0x111
13:07:31 adamo kernel: [ 2066.724777] ---[ end trace f31feae70af2c409 ]---
13:07:31 adamo kernel: [ 2066.725057] iwl data: 00000000: 00 00 55 55 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ..UUkkkkkkkkkkkk
13:07:31 adamo kernel: [ 2066.725542] iwl data: 00000010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
13:07:34 adamo kernel: [ 2070.216186] iwlwifi 0000:04:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
13:07:34 adamo kernel: [ 2070.216619] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 4
13:07:36 adamo kernel: [ 2072.217079] iwlwifi 0000:04:00.0: Error sending REPLY_QOS_PARAM: time out after 2000ms.
13:07:36 adamo kernel: [ 2072.217548] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 5
13:07:36 adamo kernel: [ 2072.217935] iwlwifi 0000:04:00.0: Failed to update QoS
13:07:38 adamo kernel: [ 2074.218151] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:07:38 adamo kernel: [ 2074.218573] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 6
13:07:38 adamo kernel: [ 2074.218969] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:07:40 adamo kernel: [ 2076.219293] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:07:40 adamo kernel: [ 2076.219715] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 7
13:07:40 adamo kernel: [ 2076.220168] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:07:42 adamo kernel: [ 2078.220139] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:07:42 adamo kernel: [ 2078.220584] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 8
13:07:42 adamo kernel: [ 2078.220972] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:07:44 adamo kernel: [ 2080.221158] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:07:44 adamo kernel: [ 2080.221597] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 9
13:07:46 adamo kernel: [ 2082.222113] iwlwifi 0000:04:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
13:07:46 adamo kernel: [ 2082.222563] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 10
13:07:46 adamo kernel: [ 2082.222976] ieee80211 phy0: failed to remove key (0, b8:c7:5d:0c:39:87) from hardware (-110)
13:07:48 adamo kernel: [ 2084.224060] iwlwifi 0000:04:00.0: Error sending REPLY_REMOVE_STA: time out after 2000ms.
13:07:48 adamo kernel: [ 2084.224458] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 11
13:07:48 adamo kernel: [ 2084.224804] iwlwifi 0000:04:00.0: Error removing station b8:c7:5d:0c:39:87
13:07:50 adamo kernel: [ 2086.235134] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:07:50 adamo kernel: [ 2086.235688] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 12
13:07:50 adamo kernel: [ 2086.236139] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:07:52 adamo kernel: [ 2088.237085] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues
13:07:54 adamo kernel: [ 2090.237150] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:07:54 adamo kernel: [ 2090.237588] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 13
13:07:54 adamo kernel: [ 2090.237980] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:07:56 adamo kernel: [ 2092.248096] iwlwifi 0000:04:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
13:07:56 adamo kernel: [ 2092.248531] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 14
13:07:56 adamo kernel: [ 2092.248931] ieee80211 phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-110)
13:07:56 adamo kernel: [ 2092.251550] cfg80211: Calling CRDA to update world regulatory domain
13:07:58 adamo kernel: [ 2094.263086] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:07:58 adamo kernel: [ 2094.263518] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 15
13:07:58 adamo kernel: [ 2094.263911] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:08:00 adamo kernel: [ 2096.264363] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
13:08:00 adamo kernel: [ 2096.264789] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 16
13:08:00 adamo kernel: [ 2096.265253] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
13:08:02 adamo kernel: [ 2098.265189] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:02 adamo kernel: [ 2098.265629] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 17
13:08:02 adamo kernel: [ 2098.267765] cfg80211: World regulatory domain updated:
13:08:02 adamo kernel: [ 2098.268090] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:08:02 adamo kernel: [ 2098.268552] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.268993] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.269454] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.269896] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.270367] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.271096] cfg80211: Calling CRDA for country: US
13:08:02 adamo kernel: [ 2098.289669] cfg80211: Regulatory domain changed to country: US
13:08:02 adamo kernel: [ 2098.289918] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:08:02 adamo kernel: [ 2098.290412] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
13:08:02 adamo kernel: [ 2098.290785] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
13:08:02 adamo kernel: [ 2098.291178] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.291551] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.291892] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:02 adamo kernel: [ 2098.292237] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
13:08:05 adamo kernel: [ 2101.270363] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:05 adamo kernel: [ 2101.270807] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 18
13:08:08 adamo kernel: [ 2104.275488] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:08 adamo kernel: [ 2104.275931] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 19
13:08:11 adamo kernel: [ 2107.280204] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:11 adamo kernel: [ 2107.280762] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 20
13:08:14 adamo kernel: [ 2110.284204] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:14 adamo kernel: [ 2110.284760] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 21
13:08:17 adamo kernel: [ 2113.287051] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:17 adamo kernel: [ 2113.287466] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 22
13:08:20 adamo kernel: [ 2116.292088] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:20 adamo kernel: [ 2116.292647] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 23
13:08:23 adamo kernel: [ 2119.296105] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:23 adamo kernel: [ 2119.296673] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 24
13:08:26 adamo kernel: [ 2122.299051] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:26 adamo kernel: [ 2122.299055] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 25
13:08:29 adamo kernel: [ 2125.302364] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: time out after 2000ms.
13:08:29 adamo kernel: [ 2125.305845] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 252 write_ptr 26
13:08:30 adamo kernel: [ 2126.312409] iwlwifi 0000:04:00.0: No space in command queue
13:08:30 adamo kernel: [ 2126.315750] iwlwifi 0000:04:00.0: Restarting adapter queue is full
13:08:30 adamo kernel: [ 2126.322938] iwlwifi 0000:04:00.0: Error sending REPLY_SCAN_CMD: enqueue_hcmd failed: -28
13:08:30 adamo kernel: [ 2126.328917] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
13:08:30 adamo kernel: [ 2126.328917] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
13:08:30 adamo kernel: [ 2126.328917] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
13:08:30 adamo kernel: [ 2126.328917] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
13:08:30 adamo kernel: [ 2126.366081] ieee80211 phy0: Hardware restart was requested
13:08:30 adamo kernel: [ 2126.367386] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:08:30 adamo kernel: [ 2126.371702] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
13:08:34 adamo kernel: [ 2130.073897] cfg80211: Calling CRDA for country: US
13:08:34 adamo kernel: [ 2130.114105] cfg80211: Regulatory domain changed to country: US
13:08:34 adamo kernel: [ 2130.115484] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:08:34 adamo kernel: [ 2130.116903] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
13:08:34 adamo kernel: [ 2130.118435] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
13:08:34 adamo kernel: [ 2130.120228] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:34 adamo kernel: [ 2130.121688] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:34 adamo kernel: [ 2130.123127] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:08:34 adamo kernel: [ 2130.124617] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
13:09:20 adamo kernel: [ 2176.382337] cfg80211: Calling CRDA to update world regulatory domain
13:09:20 adamo kernel: [ 2176.414645] sched: RT throttling activated
13:09:20 adamo kernel: [ 2176.417318] cfg80211: World regulatory domain updated:
13:09:20 adamo kernel: [ 2176.419012] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:20 adamo kernel: [ 2176.420897] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:20 adamo kernel: [ 2176.422809] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:09:20 adamo kernel: [ 2176.424570] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:09:20 adamo kernel: [ 2176.426300] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:20 adamo kernel: [ 2176.432287] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:20 adamo kernel: [ 2176.441931] cfg80211: Calling CRDA for country: US
13:09:20 adamo kernel: [ 2176.446257] iwlwifi 0000:04:00.0: PCI INT A disabled
13:09:21 adamo kernel: [ 2176.482542] cfg80211: Regulatory domain changed to country: US
13:09:21 adamo kernel: [ 2176.485181] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:21 adamo kernel: [ 2176.486895] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
13:09:21 adamo kernel: [ 2176.488573] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
13:09:21 adamo kernel: [ 2176.495642] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.497340] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.498967] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.506362] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
13:09:21 adamo kernel: [ 2176.592065] cfg80211: Calling CRDA to update world regulatory domain
13:09:21 adamo kernel: [ 2176.618982] cfg80211: World regulatory domain updated:
13:09:21 adamo kernel: [ 2176.621085] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:21 adamo kernel: [ 2176.622866] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.625175] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.627421] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.629617] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.631778] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.669861] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
13:09:21 adamo kernel: [ 2176.671119] Copyright(c) 2003-2011 Intel Corporation
13:09:21 adamo kernel: [ 2176.672535] iwlwifi 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
13:09:21 adamo kernel: [ 2176.675346] iwlwifi 0000:04:00.0: pci_resource_len = 0x00002000
13:09:21 adamo kernel: [ 2176.676645] iwlwifi 0000:04:00.0: pci_resource_base = ffffc90011560000
13:09:21 adamo kernel: [ 2176.677995] iwlwifi 0000:04:00.0: HW Revision ID = 0x0
13:09:21 adamo kernel: [ 2176.680800] iwlwifi 0000:04:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
13:09:21 adamo kernel: [ 2176.682554] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:09:21 adamo kernel: [ 2176.710393] iwlwifi 0000:04:00.0: device EEPROM VER=0x120, CALIB=0x4
13:09:21 adamo kernel: [ 2176.712016] iwlwifi 0000:04:00.0: Device SKU: 0Xf0
13:09:21 adamo kernel: [ 2176.713322] iwlwifi 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
13:09:21 adamo kernel: [ 2176.757242] iwlwifi 0000:04:00.0: loaded firmware version 8.83.5.1 build 33692
13:09:21 adamo kernel: [ 2176.787736] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:09:21 adamo kernel: [ 2176.793648] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
13:09:21 adamo kernel: [ 2176.852335] cfg80211: Calling CRDA for country: US
13:09:21 adamo kernel: [ 2176.874113] cfg80211: Regulatory domain changed to country: US
13:09:21 adamo kernel: [ 2176.875469] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:21 adamo kernel: [ 2176.877073] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
13:09:21 adamo kernel: [ 2176.878416] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
13:09:21 adamo kernel: [ 2176.879790] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.881186] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.882551] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:21 adamo kernel: [ 2176.883987] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
13:09:21 adamo kernel: [ 2176.952459] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:09:21 adamo kernel: [ 2176.958892] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
13:09:21 adamo kernel: [ 2177.014172] ADDRCONF(NETDEV_UP): wlan0: link is not ready
13:09:25 adamo kernel: [ 2180.646670] iwlwifi 0000:04:00.0: PCI INT A disabled
13:09:25 adamo kernel: [ 2180.742822] cfg80211: Calling CRDA to update world regulatory domain
13:09:25 adamo kernel: [ 2180.777143] cfg80211: World regulatory domain updated:
13:09:25 adamo kernel: [ 2180.779445] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:25 adamo kernel: [ 2180.781713] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.783461] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.785258] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.788974] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.790835] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.818477] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
13:09:25 adamo kernel: [ 2180.819995] Copyright(c) 2003-2011 Intel Corporation
13:09:25 adamo kernel: [ 2180.821731] iwlwifi 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
13:09:25 adamo kernel: [ 2180.824653] iwlwifi 0000:04:00.0: pci_resource_len = 0x00002000
13:09:25 adamo kernel: [ 2180.825956] iwlwifi 0000:04:00.0: pci_resource_base = ffffc90011560000
13:09:25 adamo kernel: [ 2180.827345] iwlwifi 0000:04:00.0: HW Revision ID = 0x0
13:09:25 adamo kernel: [ 2180.830435] iwlwifi 0000:04:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
13:09:25 adamo kernel: [ 2180.832442] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:09:25 adamo kernel: [ 2180.855826] iwlwifi 0000:04:00.0: device EEPROM VER=0x120, CALIB=0x4
13:09:25 adamo kernel: [ 2180.857122] iwlwifi 0000:04:00.0: Device SKU: 0Xf0
13:09:25 adamo kernel: [ 2180.858432] iwlwifi 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
13:09:25 adamo kernel: [ 2180.873245] iwlwifi 0000:04:00.0: loaded firmware version 8.83.5.1 build 33692
13:09:25 adamo kernel: [ 2180.916541] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:09:25 adamo kernel: [ 2180.924127] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
13:09:25 adamo kernel: [ 2180.940997] cfg80211: Calling CRDA for country: US
13:09:25 adamo kernel: [ 2180.969672] cfg80211: Regulatory domain changed to country: US
13:09:25 adamo kernel: [ 2180.972791] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:25 adamo kernel: [ 2180.974863] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
13:09:25 adamo kernel: [ 2180.978162] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
13:09:25 adamo kernel: [ 2180.981470] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.983785] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.985547] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:25 adamo kernel: [ 2180.987926] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
13:09:25 adamo kernel: [ 2181.085693] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
13:09:25 adamo kernel: [ 2181.092119] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
13:09:25 adamo kernel: [ 2181.148638] ADDRCONF(NETDEV_UP): wlan0: link is not ready
13:09:31 adamo kernel: [ 2186.580291] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
13:09:31 adamo kernel: [ 2186.583115] cfg80211: Calling CRDA for country: US
13:09:31 adamo kernel: [ 2186.599770] cfg80211: Regulatory domain changed to country: US
13:09:31 adamo kernel: [ 2186.599773] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:09:31 adamo kernel: [ 2186.599776] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
13:09:31 adamo kernel: [ 2186.599778] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
13:09:31 adamo kernel: [ 2186.599781] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:31 adamo kernel: [ 2186.599783] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:31 adamo kernel: [ 2186.599786] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
13:09:31 adamo kernel: [ 2186.599788] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
13:10:05 adamo kernel: [ 2220.866657] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0



and from another boot...


14:15:50 adamo kernel: [ 1604.362588] iwlwifi 0000:04:00.0: Received BA when not expected
14:15:51 adamo kernel: [ 1604.541554] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
14:15:51 adamo kernel: [ 1604.541883] iwlwifi 0000:04:00.0: Loaded firmware version: 8.83.5.1 build 33692
14:15:51 adamo kernel: [ 1604.542327] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
14:15:51 adamo kernel: [ 1604.542591] iwlwifi 0000:04:00.0: Status: 0x000412E4, count: 5
14:15:51 adamo kernel: [ 1604.542858] iwlwifi 0000:04:00.0: 0x0000001C | ADVANCED_SYSASSERT          
14:15:51 adamo kernel: [ 1604.543161] iwlwifi 0000:04:00.0: 0x000006E4 | uPc
14:15:51 adamo kernel: [ 1604.543406] iwlwifi 0000:04:00.0: 0x000005AA | branchlink1
14:15:51 adamo kernel: [ 1604.543675] iwlwifi 0000:04:00.0: 0x00000820 | branchlink2
14:15:51 adamo kernel: [ 1604.543906] iwlwifi 0000:04:00.0: 0x00000916 | interruptlink1
14:15:51 adamo kernel: [ 1604.544160] iwlwifi 0000:04:00.0: 0x0000E51C | interruptlink2
14:15:51 adamo kernel: [ 1604.544437] iwlwifi 0000:04:00.0: 0x00000002 | data1
14:15:51 adamo kernel: [ 1604.544680] iwlwifi 0000:04:00.0: 0x026B0000 | data2
14:15:51 adamo kernel: [ 1604.544890] iwlwifi 0000:04:00.0: 0x00000236 | line
14:15:51 adamo kernel: [ 1604.545108] iwlwifi 0000:04:00.0: 0xEA01898D | beacon time
14:15:51 adamo kernel: [ 1604.545384] iwlwifi 0000:04:00.0: 0x3BB50673 | tsf low
14:15:51 adamo kernel: [ 1604.545635] iwlwifi 0000:04:00.0: 0x00000235 | tsf hi
14:15:51 adamo kernel: [ 1604.545849] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
14:15:51 adamo kernel: [ 1604.546081] iwlwifi 0000:04:00.0: 0x5DA28653 | time gp2
14:15:51 adamo kernel: [ 1604.546334] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
14:15:51 adamo kernel: [ 1604.546590] iwlwifi 0000:04:00.0: 0x00010853 | uCode version
14:15:51 adamo kernel: [ 1604.546829] iwlwifi 0000:04:00.0: 0x00000024 | hw version
14:15:51 adamo kernel: [ 1604.547068] iwlwifi 0000:04:00.0: 0x00480302 | board version
14:15:51 adamo kernel: [ 1604.547353] iwlwifi 0000:04:00.0: 0x0B03001C | hcmd
14:15:51 adamo kernel: [ 1604.547591] iwlwifi 0000:04:00.0: CSR values:
14:15:51 adamo kernel: [ 1604.547778] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
14:15:51 adamo kernel: [ 1604.548164] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
14:15:51 adamo kernel: [ 1604.548508] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
14:15:51 adamo kernel: [ 1604.548836] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
14:15:51 adamo kernel: [ 1604.549162] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
14:15:51 adamo kernel: [ 1604.549521] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
14:15:51 adamo kernel: [ 1604.549845] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
14:15:51 adamo kernel: [ 1604.550170] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
14:15:51 adamo kernel: [ 1604.550530] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
14:15:51 adamo kernel: [ 1604.550852] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000024
14:15:51 adamo kernel: [ 1604.551177] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
14:15:51 adamo kernel: [ 1604.551519] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
14:15:51 adamo kernel: [ 1604.551844] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00060000
14:15:51 adamo kernel: [ 1604.552169] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
14:15:51 adamo kernel: [ 1604.552510] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00006efb
14:15:51 adamo kernel: [ 1604.552858] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
14:15:51 adamo kernel: [ 1604.553183] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
14:15:51 adamo kernel: [ 1604.553526] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
14:15:51 adamo kernel: [ 1604.553850] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000058
14:15:51 adamo kernel: [ 1604.554175] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X8810bc80
14:15:51 adamo kernel: [ 1604.554518] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
14:15:51 adamo kernel: [ 1604.554843] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00880300
14:15:51 adamo kernel: [ 1604.555169] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
14:15:51 adamo kernel: [ 1604.555512] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
14:15:51 adamo kernel: [ 1604.555811] iwlwifi 0000:04:00.0: FH register values:
14:15:51 adamo kernel: [ 1604.556098] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X10cbb100
14:15:51 adamo kernel: [ 1604.556499] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X010b04b0
14:15:51 adamo kernel: [ 1604.556855] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000058
14:15:51 adamo kernel: [ 1604.557244] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00819104
14:15:51 adamo kernel: [ 1604.557628] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
14:15:51 adamo kernel: [ 1604.557988] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X026b0000
14:15:51 adamo kernel: [ 1604.558376] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
14:15:51 adamo kernel: [ 1604.558760] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
14:15:51 adamo kernel: [ 1604.559175] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
14:15:51 adamo kernel: [ 1604.559595] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
14:15:51 adamo kernel: [ 1604.560003] iwlwifi 0000:04:00.0: EVT_LOGT:1570732026:0x2b110000:0227
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732027:0xc05003d4:0228
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732031:0x5d9f77ff:1586
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732037:0x5d9f7805:1587
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732068:0x5d9f7824:1587
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732076:0x5d9f782c:1587
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732083:0x5d9f7833:1587
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732088:0x00000000:0264
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732135:0x00000000:0302
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732159:0x00000000:0355
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732316:0x0b03001c:0206
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732318:0x00000001:0204
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732320:0x01102100:0209
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732345:0x00000000:0210
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732361:0x00000000:0207
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732363:0x2b110000:0227
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732364:0xc0600498:0228
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570732368:0x5d9f7950:1586
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570932291:0x000000d7:0123
14:15:51 adamo kernel: [ 1604.560136] iwlwifi 0000:04:00.0: EVT_LOGT:1570932330:0x00000000:0125
14:15:51 adamo kernel: [ 1604.577501] ieee80211 phy0: Hardware restart was requested
14:15:51 adamo kernel: [ 1604.577873] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
14:15:51 adamo kernel: [ 1604.581396] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
14:19:39 adamo kernel: [ 1832.535189] cfg80211: Calling CRDA to update world regulatory domain
14:19:39 adamo kernel: [ 1832.573862] cfg80211: World regulatory domain updated:
14:19:39 adamo kernel: [ 1832.579065] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:19:39 adamo kernel: [ 1832.580321] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.581686] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.584038] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.584982] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.587892] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.594045] cfg80211: Calling CRDA for country: US
14:19:39 adamo kernel: [ 1832.599122] iwlwifi 0000:04:00.0: PCI INT A disabled
14:19:39 adamo kernel: [ 1832.657920] cfg80211: Regulatory domain changed to country: US
14:19:39 adamo kernel: [ 1832.659407] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:19:39 adamo kernel: [ 1832.660722] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
14:19:39 adamo kernel: [ 1832.661763] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
14:19:39 adamo kernel: [ 1832.662799] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.663890] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.664927] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.666026] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
14:19:39 adamo kernel: [ 1832.739289] cfg80211: Calling CRDA to update world regulatory domain
14:19:39 adamo kernel: [ 1832.766625] cfg80211: World regulatory domain updated:
14:19:39 adamo kernel: [ 1832.768240] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:19:39 adamo kernel: [ 1832.769874] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.771481] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.773261] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.775083] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.777176] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1832.818518] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
14:19:39 adamo kernel: [ 1832.819610] Copyright(c) 2003-2011 Intel Corporation
14:19:39 adamo kernel: [ 1832.820815] iwlwifi 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
14:19:39 adamo kernel: [ 1832.823200] iwlwifi 0000:04:00.0: pci_resource_len = 0x00002000
14:19:39 adamo kernel: [ 1832.824328] iwlwifi 0000:04:00.0: pci_resource_base = ffffc90011560000
14:19:39 adamo kernel: [ 1832.825501] iwlwifi 0000:04:00.0: HW Revision ID = 0x0
14:19:39 adamo kernel: [ 1832.828153] iwlwifi 0000:04:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
14:19:39 adamo kernel: [ 1832.829820] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
14:19:39 adamo kernel: [ 1832.853131] iwlwifi 0000:04:00.0: device EEPROM VER=0x120, CALIB=0x4
14:19:39 adamo kernel: [ 1832.854443] iwlwifi 0000:04:00.0: Device SKU: 0Xf0
14:19:39 adamo kernel: [ 1832.855680] iwlwifi 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
14:19:39 adamo kernel: [ 1832.886535] iwlwifi 0000:04:00.0: loaded firmware version 8.83.5.1 build 33692
14:19:39 adamo kernel: [ 1832.928540] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
14:19:39 adamo kernel: [ 1832.934957] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
14:19:39 adamo kernel: [ 1833.050562] cfg80211: Calling CRDA for country: US
14:19:39 adamo kernel: [ 1833.076784] cfg80211: Regulatory domain changed to country: US
14:19:39 adamo kernel: [ 1833.078171] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:19:39 adamo kernel: [ 1833.079652] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
14:19:39 adamo kernel: [ 1833.081180] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
14:19:39 adamo kernel: [ 1833.082645] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1833.084191] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1833.085676] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:39 adamo kernel: [ 1833.087144] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
14:19:39 adamo kernel: [ 1833.092904] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
14:19:39 adamo kernel: [ 1833.097470] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
14:19:39 adamo kernel: [ 1833.150125] ADDRCONF(NETDEV_UP): wlan0: link is not ready
14:19:39 adamo kernel: [ 1833.180547] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
14:19:39 adamo kernel: [ 1833.189278] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
14:19:39 adamo kernel: [ 1833.245559] ADDRCONF(NETDEV_UP): wlan0: link is not ready
14:19:45 adamo kernel: [ 1838.563109] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
14:19:45 adamo kernel: [ 1838.565380] cfg80211: Calling CRDA for country: US
14:19:45 adamo kernel: [ 1838.588382] cfg80211: Regulatory domain changed to country: US
14:19:45 adamo kernel: [ 1838.589808] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:19:45 adamo kernel: [ 1838.591287] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
14:19:45 adamo kernel: [ 1838.592748] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
14:19:45 adamo kernel: [ 1838.594208] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:45 adamo kernel: [ 1838.595674] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:45 adamo kernel: [ 1838.597127] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:19:45 adamo kernel: [ 1838.598536] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
14:20:42 adamo kernel: [ 1895.599580] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0
14:22:57 adamo kernel: [ 2031.216067] iwlwifi 0000:04:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
14:22:57 adamo kernel: [ 2031.216520] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 224
14:22:59 adamo kernel: [ 2033.217064] iwlwifi 0000:04:00.0: Error sending REPLY_QOS_PARAM: time out after 2000ms.
14:22:59 adamo kernel: [ 2033.217500] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 227
14:22:59 adamo kernel: [ 2033.217897] iwlwifi 0000:04:00.0: Failed to update QoS
14:23:01 adamo kernel: [ 2035.218069] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
14:23:01 adamo kernel: [ 2035.218491] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 230
14:23:01 adamo kernel: [ 2035.218889] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
14:23:03 adamo kernel: [ 2037.219096] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
14:23:03 adamo kernel: [ 2037.219515] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 233
14:23:03 adamo kernel: [ 2037.219907] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
14:23:05 adamo kernel: [ 2039.220059] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
14:23:05 adamo kernel: [ 2039.220390] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 236
14:23:05 adamo kernel: [ 2039.220693] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
14:23:07 adamo kernel: [ 2041.230066] iwlwifi 0000:04:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
14:23:07 adamo kernel: [ 2041.230432] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 239
14:23:07 adamo kernel: [ 2041.230737] ieee80211 phy0: failed to remove key (0, b8:c7:5d:0c:39:87) from hardware (-110)
14:23:09 adamo kernel: [ 2043.231156] iwlwifi 0000:04:00.0: Error sending REPLY_REMOVE_STA: time out after 2000ms.
14:23:09 adamo kernel: [ 2043.231606] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 242
14:23:09 adamo kernel: [ 2043.232054] iwlwifi 0000:04:00.0: Error removing station b8:c7:5d:0c:39:87
14:23:11 adamo kernel: [ 2045.242046] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
14:23:11 adamo kernel: [ 2045.242398] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 245
14:23:11 adamo kernel: [ 2045.242746] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
14:23:13 adamo kernel: [ 2047.244325] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues
14:23:15 adamo kernel: [ 2049.244086] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: time out after 2000ms.
14:23:15 adamo kernel: [ 2049.244508] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 247
14:23:15 adamo kernel: [ 2049.244904] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-110)
14:23:17 adamo kernel: [ 2051.254193] iwlwifi 0000:04:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
14:23:17 adamo kernel: [ 2051.254627] iwlwifi 0000:04:00.0: Current CMD queue read_ptr 218 write_ptr 248
14:23:17 adamo kernel: [ 2051.255071] ieee80211 phy0: failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware (-110)
14:23:17 adamo kernel: [ 2051.256795] cfg80211: Calling CRDA to update world regulatory domain
14:23:17 adamo kernel: [ 2051.266960] iwlwifi 0000:04:00.0: No space in command queue
14:23:17 adamo kernel: [ 2051.267269] iwlwifi 0000:04:00.0: Restarting adapter queue is full
14:23:17 adamo kernel: [ 2051.267807] iwlwifi 0000:04:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -28
14:23:17 adamo kernel: [ 2051.268472] iwlwifi 0000:04:00.0: Error clearing ASSOC_MSK on BSS (-28)
14:23:17 adamo kernel: [ 2051.268803] iwlwifi 0000:04:00.0: Request scan called when driver not ready.
14:23:17 adamo kernel: [ 2051.270009] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 1 [0xa5a5a5a2]
14:23:17 adamo kernel: [ 2051.275794] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 3 [0xa5a5a5a2]
14:23:17 adamo kernel: [ 2051.275794] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 4 [0xa5a5a5a2]
14:23:17 adamo kernel: [ 2051.275794] iwlwifi 0000:04:00.0: Failing on timeout while stopping DMA channel 6 [0xa5a5a5a2]
14:23:17 adamo kernel: [ 2051.300474] ieee80211 phy0: Hardware restart was requested
14:23:17 adamo kernel: [ 2051.300840] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
14:23:17 adamo kernel: [ 2051.304186] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
14:23:17 adamo kernel: [ 2051.318513] cfg80211: World regulatory domain updated:
14:23:17 adamo kernel: [ 2051.318753] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:23:17 adamo kernel: [ 2051.319230] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.319606] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.319990] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.320374] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.320748] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.321195] cfg80211: Calling CRDA for country: US
14:23:17 adamo kernel: [ 2051.339073] cfg80211: Regulatory domain changed to country: US
14:23:17 adamo kernel: [ 2051.339717] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
14:23:17 adamo kernel: [ 2051.340968] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
14:23:17 adamo kernel: [ 2051.342160] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
14:23:17 adamo kernel: [ 2051.343285] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.343744] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.344110] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
14:23:17 adamo kernel: [ 2051.344482] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

