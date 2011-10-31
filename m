Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1JaOeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 10:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab1JaOeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 10:34:12 -0400
Date: Mon, 31 Oct 2011 10:34:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Subject: 3.1+ iwlwifi lockup
Message-ID: <20111031143408.GA17152@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got this trace, and a driver lockup that caused me to have to
unload & reload the iwlwifi module to get networking back.
hardware is..
04:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300

This is new as of 3.1+  (This kernel was Linus' tree as of last night)

	Dave

[ 2669.712377] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:927 iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]()
[ 2669.712381] Hardware name: Adamo 13   
[ 2669.712384] wrong command queue 0 (should be 4), sequence 0x0 readp=54 writep=54
[ 2669.712386] Modules linked in: nfs fscache auth_rpcgss nfs_acl ppdev parport_pc lp parport fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle tun bridge stp llc lockd bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables arc4 dell_wmi sparse_keymap uvcvideo videodev snd_usb_audio v4l2_compat_ioctl32 snd_usbmidi_lib cdc_ether snd_rawmidi cdc_wdm usbnet cdc_acm mii snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device dell_laptop iwlwifi dcdbas microcode snd_pcm mac80211 joydev i2c_i801 pcspkr snd_timer iTCO_wdt iTCO_vendor_support snd soundcore cfg80211 snd_page_alloc tg3 rfkill wmi virtio_net kvm_intel kvm uinput sunrpc ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2669.712493] Pid: 2332, comm: firefox Not tainted 3.1.0+ #9
[ 2669.712495] Call Trace:
[ 2669.712497]  <IRQ>  [<ffffffff8107d16f>] warn_slowpath_common+0x7f/0xc0
[ 2669.712509]  [<ffffffff8107d266>] warn_slowpath_fmt+0x46/0x50
[ 2669.712519]  [<ffffffffa038090e>] iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]
[ 2669.712529]  [<ffffffffa037e280>] iwl_irq_tasklet+0x210/0x8e0 [iwlwifi]
[ 2669.712535]  [<ffffffff810851fd>] tasklet_action+0x9d/0x240
[ 2669.712539]  [<ffffffff81085e28>] __do_softirq+0xc8/0x3d0
[ 2669.712544]  [<ffffffff81657f3c>] call_softirq+0x1c/0x30
[ 2669.712549]  [<ffffffff8101c735>] do_softirq+0xa5/0xe0
[ 2669.712553]  [<ffffffff810864a6>] irq_exit+0xa6/0xf0
[ 2669.712557]  [<ffffffff81658813>] do_IRQ+0x63/0xd0
[ 2669.712561]  [<ffffffff8164e5f3>] common_interrupt+0x73/0x73
[ 2669.712563]  <EOI>  [<ffffffff81655c7a>] ? sysret_check+0x2e/0x69
[ 2669.712570] ---[ end trace e86fa0935f9dc7a5 ]---
[ 2669.712573] iwl data: 00000000: 00 00 55 55 00 00 00 00 08 53 e0 00 00 00 00 00  ..UU.....S......
[ 2669.712577] iwl data: 00000010: 00 00 00 00 7e 04 19 00 05 00 04 00 94 07 02 00  ....~...........
[ 2669.712619] ------------[ cut here ]------------
[ 2669.712628] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:927 iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]()
[ 2669.712631] Hardware name: Adamo 13   
[ 2669.712634] wrong command queue 11 (should be 4), sequence 0x6B6B readp=54 writep=54
[ 2669.712636] Modules linked in: nfs fscache auth_rpcgss nfs_acl ppdev parport_pc lp parport fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle tun bridge stp llc lockd bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables arc4 dell_wmi sparse_keymap uvcvideo videodev snd_usb_audio v4l2_compat_ioctl32 snd_usbmidi_lib cdc_ether snd_rawmidi cdc_wdm usbnet cdc_acm mii snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device dell_laptop iwlwifi dcdbas microcode snd_pcm mac80211 joydev i2c_i801 pcspkr snd_timer iTCO_wdt iTCO_vendor_support snd soundcore cfg80211 snd_page_alloc tg3 rfkill wmi virtio_net kvm_intel kvm uinput sunrpc ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2669.712729] Pid: 2332, comm: firefox Tainted: G        W   3.1.0+ #9
[ 2669.712731] Call Trace:
[ 2669.712733]  <IRQ>  [<ffffffff8107d16f>] warn_slowpath_common+0x7f/0xc0
[ 2669.712743]  [<ffffffff8164de90>] ? _raw_spin_unlock_irqrestore+0x40/0x90
[ 2669.712747]  [<ffffffff8107d266>] warn_slowpath_fmt+0x46/0x50
[ 2669.712753]  [<ffffffff810c189f>] ? trace_hardirqs_on_caller+0x1f/0x1b0
[ 2669.712762]  [<ffffffffa038090e>] iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]
[ 2669.712772]  [<ffffffffa037e280>] iwl_irq_tasklet+0x210/0x8e0 [iwlwifi]
[ 2669.712777]  [<ffffffff810851fd>] tasklet_action+0x9d/0x240
[ 2669.712781]  [<ffffffff81085e28>] __do_softirq+0xc8/0x3d0
[ 2669.712785]  [<ffffffff81657f3c>] call_softirq+0x1c/0x30
[ 2669.712789]  [<ffffffff8101c735>] do_softirq+0xa5/0xe0
[ 2669.712792]  [<ffffffff810864a6>] irq_exit+0xa6/0xf0
[ 2669.712796]  [<ffffffff81658813>] do_IRQ+0x63/0xd0
[ 2669.712800]  [<ffffffff8164e5f3>] common_interrupt+0x73/0x73
[ 2669.712802]  <EOI>  [<ffffffff81655c7a>] ? sysret_check+0x2e/0x69
[ 2669.712808] ---[ end trace e86fa0935f9dc7a6 ]---
[ 2669.712811] iwl data: 00000000: 00 00 55 55 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ..UUkkkkkkkkkkkk
[ 2669.712815] iwl data: 00000010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 2669.712818] ------------[ cut here ]------------
[ 2669.712826] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:927 iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]()
[ 2669.712829] Hardware name: Adamo 13   
[ 2669.712832] wrong command queue 11 (should be 4), sequence 0x6B6B readp=54 writep=54
[ 2669.712834] Modules linked in: nfs fscache auth_rpcgss nfs_acl ppdev parport_pc lp parport fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle tun bridge stp llc lockd bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables arc4 dell_wmi sparse_keymap uvcvideo videodev snd_usb_audio v4l2_compat_ioctl32 snd_usbmidi_lib cdc_ether snd_rawmidi cdc_wdm usbnet cdc_acm mii snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device dell_laptop iwlwifi dcdbas microcode snd_pcm mac80211 joydev i2c_i801 pcspkr snd_timer iTCO_wdt iTCO_vendor_support snd soundcore cfg80211 snd_page_alloc tg3 rfkill wmi virtio_net kvm_intel kvm uinput sunrpc ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2669.712925] Pid: 2332, comm: firefox Tainted: G        W   3.1.0+ #9
[ 2669.712928] Call Trace:
[ 2669.712930]  <IRQ>  [<ffffffff8107d16f>] warn_slowpath_common+0x7f/0xc0
[ 2669.712938]  [<ffffffff8107d266>] warn_slowpath_fmt+0x46/0x50
[ 2669.712948]  [<ffffffffa038090e>] iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]
[ 2669.712958]  [<ffffffffa037e280>] iwl_irq_tasklet+0x210/0x8e0 [iwlwifi]
[ 2669.712963]  [<ffffffff810851fd>] tasklet_action+0x9d/0x240
[ 2669.712967]  [<ffffffff81085e28>] __do_softirq+0xc8/0x3d0
[ 2669.712971]  [<ffffffff81657f3c>] call_softirq+0x1c/0x30
[ 2669.712975]  [<ffffffff8101c735>] do_softirq+0xa5/0xe0
[ 2669.712979]  [<ffffffff810864a6>] irq_exit+0xa6/0xf0
[ 2669.712982]  [<ffffffff81658813>] do_IRQ+0x63/0xd0
[ 2669.712986]  [<ffffffff8164e5f3>] common_interrupt+0x73/0x73
[ 2669.712988]  <EOI>  [<ffffffff81655c7a>] ? sysret_check+0x2e/0x69
[ 2669.712994] ---[ end trace e86fa0935f9dc7a7 ]---
[ 2669.712997] iwl data: 00000000: 00 00 55 55 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ..UUkkkkkkkkkkkk
[ 2669.713018] iwl data: 00000010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 2669.713136] ------------[ cut here ]------------
[ 2669.713146] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:927 iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]()
[ 2669.713150] Hardware name: Adamo 13   
[ 2669.713153] wrong command queue 11 (should be 4), sequence 0x6B6B readp=54 writep=54
[ 2669.713157] Modules linked in: nfs fscache auth_rpcgss nfs_acl ppdev parport_pc lp parport fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle tun bridge stp llc lockd bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables arc4 dell_wmi sparse_keymap uvcvideo videodev snd_usb_audio v4l2_compat_ioctl32 snd_usbmidi_lib cdc_ether snd_rawmidi cdc_wdm usbnet cdc_acm mii snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device dell_laptop iwlwifi dcdbas microcode snd_pcm mac80211 joydev i2c_i801 pcspkr snd_timer iTCO_wdt iTCO_vendor_support snd soundcore cfg80211 snd_page_alloc tg3 rfkill wmi virtio_net kvm_intel kvm uinput sunrpc ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 2669.713292] Pid: 2332, comm: firefox Tainted: G        W   3.1.0+ #9
[ 2669.713295] Call Trace:
[ 2669.713297]  <IRQ>  [<ffffffff8107d16f>] warn_slowpath_common+0x7f/0xc0
[ 2669.713308]  [<ffffffff8107d266>] warn_slowpath_fmt+0x46/0x50
[ 2669.713319]  [<ffffffffa038090e>] iwl_tx_cmd_complete+0x2ee/0x330 [iwlwifi]
[ 2669.713331]  [<ffffffffa037e280>] iwl_irq_tasklet+0x210/0x8e0 [iwlwifi]
[ 2669.713337]  [<ffffffff810851fd>] tasklet_action+0x9d/0x240
[ 2669.713342]  [<ffffffff81085e28>] __do_softirq+0xc8/0x3d0
[ 2669.713347]  [<ffffffff81657f3c>] call_softirq+0x1c/0x30
[ 2669.713353]  [<ffffffff8101c735>] do_softirq+0xa5/0xe0
[ 2669.713357]  [<ffffffff810864a6>] irq_exit+0xa6/0xf0
[ 2669.713362]  [<ffffffff81658813>] do_IRQ+0x63/0xd0
[ 2669.713367]  [<ffffffff8164e5f3>] common_interrupt+0x73/0x73
[ 2669.713369]  <EOI>  [<ffffffff81655c7a>] ? sysret_check+0x2e/0x69
[ 2669.713377] ---[ end trace e86fa0935f9dc7a8 ]---
[ 2669.713380] iwl data: 00000000: 00 00 55 55 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ..UUkkkkkkkkkkkk
[ 2669.713385] iwl data: 00000010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 2670.784424] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
[ 2670.784431] iwlwifi 0000:04:00.0: Loaded firmware version: 8.83.5.1 build 33692
[ 2670.784556] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[ 2670.784559] iwlwifi 0000:04:00.0: Status: 0x000412E4, count: 5
[ 2670.784562] iwlwifi 0000:04:00.0: 0x00000005 | SYSASSERT                   
[ 2670.784565] iwlwifi 0000:04:00.0: 0x000024EC | uPc
[ 2670.784568] iwlwifi 0000:04:00.0: 0x000024C8 | branchlink1
[ 2670.784570] iwlwifi 0000:04:00.0: 0x000024C8 | branchlink2
[ 2670.784573] iwlwifi 0000:04:00.0: 0x00000916 | interruptlink1
[ 2670.784576] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
[ 2670.784578] iwlwifi 0000:04:00.0: 0x000000FF | data1
[ 2670.784580] iwlwifi 0000:04:00.0: 0x00000489 | data2
[ 2670.784583] iwlwifi 0000:04:00.0: 0x00000489 | line
[ 2670.784585] iwlwifi 0000:04:00.0: 0x1A41414C | beacon time
[ 2670.784588] iwlwifi 0000:04:00.0: 0x54956EB4 | tsf low
[ 2670.784591] iwlwifi 0000:04:00.0: 0x000004FB | tsf hi
[ 2670.784593] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[ 2670.784596] iwlwifi 0000:04:00.0: 0x9D4D53F1 | time gp2
[ 2670.784598] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[ 2670.784601] iwlwifi 0000:04:00.0: 0x00010853 | uCode version
[ 2670.784603] iwlwifi 0000:04:00.0: 0x00000024 | hw version
[ 2670.784606] iwlwifi 0000:04:00.0: 0x00480302 | board version
[ 2670.784609] iwlwifi 0000:04:00.0: 0x0B15001C | hcmd
[ 2670.784611] iwlwifi 0000:04:00.0: CSR values:
[ 2670.784614] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[ 2670.784641] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
[ 2670.784666] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
[ 2670.784691] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
[ 2670.784715] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
[ 2670.784740] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
[ 2670.784765] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
[ 2670.784790] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
[ 2670.784814] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
[ 2670.784839] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000024
[ 2670.784864] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
[ 2670.784889] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
[ 2670.784914] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00060000
[ 2670.784938] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
[ 2670.784963] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00007c71
[ 2670.784988] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[ 2670.785012] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[ 2670.785037] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[ 2670.785062] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000058
[ 2670.785086] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X8811a5a0
[ 2670.785111] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[ 2670.785136] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[ 2670.785161] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[ 2670.785186] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[ 2670.785188] iwlwifi 0000:04:00.0: FH register values:
[ 2670.785224] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1174de00
[ 2670.785243] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X012abbb0
[ 2670.785261] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000048
[ 2670.785280] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[ 2670.785300] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 2670.785343] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X02630000
[ 2670.785362] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 2670.785380] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 2670.785389] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[ 2670.785389] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638087993:0x00000000:0355
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088265:0x00000113:0106
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088266:0x00000000:0302
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088289:0x00000000:0355
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088453:0x00000113:0106
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088455:0x00000000:0302
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088478:0x00000000:0355
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088750:0x0b15001c:0206
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088752:0x00000001:0204
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088755:0x00000001:0214
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638088756:0x01002111:0209
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638089055:0x00000000:0210
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638089065:0x00000000:0207
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638089067:0x01002111:0211
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638089072:0x00000000:0212
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638090106:0x00000000:0215
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638090108:0x00000008:0220
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638090127:0x00000000:0301
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2638090315:0x00000000:0355
[ 2670.785389] iwlwifi 0000:04:00.0: EVT_LOGT:2639090696:0x00000000:0125
[ 2670.795643] ieee80211 phy0: Hardware restart was requested
[ 2670.795729] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
[ 2670.798779] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0

