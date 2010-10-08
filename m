Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0JHHXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:23:08 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:57851 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0JHHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:23:05 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2010 03:23:05 EDT
Date: Fri, 8 Oct 2010 02:58:11 -0400
From: Jon Masters <jonathan@jonmasters.org>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Nohee Ko <noheek@broadcom.com>, Jon Masters <jcm@jonmasters.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: PROBLEM: brcm80211 hangs on 2.6.36-0.34.rc6.git3.fc15.x86_64
Message-ID: <20101008065810.GA1680@constitution.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I tried building the new brcm80211 driver from staging-next on Fedora rawhide
kernel 2.6.36-0.34.rc6.git3.fc15.x86_64. Now, of course, it's not the
staging-next kernel (I'll try that now this doesn't work) but perhaps this
report will still be of use to the Broadcom/other wireless folks.

After loading the module, the system hangs soon thereafter and does not respond
to any sysrq. I tried setting panic_on_oops and configuring kdump but I can't
get the system to panic in any case, and setting pause_on_oops doesn't give me
enough output, either. So the best I have at this time of night is the output
from a netconsole, which actually seems to work well enough (I don't see any
further output on the console itself).

This is happening on a brand new ASUS Eee PC 1015PEM netbook, which contains
the following Broadcom part:

02:00.0 0280: 14e4:4727 (rev 01)
        Subsystem: 1a3b:2047
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at fbffc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [d0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel
        Capabilities: [160] Device Serial Number XX-XX-XX-XX-XX-XX-XX-XX
        Capabilities: [16c] Power Budgeting <?>
        Kernel modules: brcm80211

The firmware files have been installed correctly also. I will poke some
more, trying a pure upstream Linus tree and next-staging next, and I am
happy to try patches sent to me and let folks know what happens.

Jon.

--- output from netconsole ---

[  366.771940] console [netcon0] enabled
[  366.774936] netconsole: network logging started
[  392.980995] wl_pci_probe: bus 2 slot 0 func 0 irq 10
[  392.984887] brcm80211 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  392.988883] brcm80211 0000:02:00.0: setting latency timer to 64
[  392.993356] PCI/DMA
[  393.122108] wlc_protection_upd: idx 2, val -1
[  393.126243] wlc_protection_upd: idx 1, val 0
[  393.130048] wlc_protection_upd: idx 12, val -1
[  393.133375] wlc_protection_upd: idx 11, val 0
[  393.137747] wlc_protection_upd: idx 14, val -1
[  393.142379] wlc_protection_upd: idx 13, val 0
[  393.146843] wlc_protection_upd: idx 15, val -1
[  393.151222] wlc_protection_upd: idx 4, val 2
[  393.155321] wl0: wlc_bmac_attach: vendor 0x14e4 device 0x4727
[  393.159746] Found chip type AI (0x13814313)
[  393.170595] Changing max_res_mask to 0xffff
[  393.174493] Changing min_res_mask to 0x200d
[  393.184581] Applying 4313 WARs
[  393.188558] wl0: wlc_bmac_corereset
[  393.192948] wl0: wlc_bmac_phy_reset
[  393.196628] wl0: wlc_bmac_core_phypll_ctl
[  393.200378] wl0: validate_chip_access
[  393.204171] wl0: wlc_setxband: bandunit 0
[  393.207939] wl0: wlc_bmac_corereset
[  393.211729] wl0: wlc_bmac_phy_reset
[  393.215377] wl0: wlc_bmac_core_phypll_ctl
[  393.219456] wl0: dma_attach: DMA64 osh ffff88007a9c9738 flags 0x0 ntxd 256 nrxd 256 rxbufsize 2048 rxextheadroom -1 nrxpost 32 rxoffset 38 dmaregstx ffffc90023788200 dmaregsrx ffffc90023788220
[  393.227474] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[  393.231906] wl0: dma_attach: DMA64 osh ffff88007a9c9738 flags 0x0 ntxd 256 nrxd 0 rxbufsize 0 rxextheadroom -1 nrxpost 0 rxoffset 0 dmaregstx ffffc90023788240 dmaregsrx (null)
[  393.240982] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[  393.246000] wl0: dma_attach: DMA64 osh ffff88007a9c9738 flags 0x0 ntxd 256 nrxd 0 rxbufsize 0 rxextheadroom -1 nrxpost 0 rxoffset 0 dmaregstx ffffc90023788280 dmaregsrx (null)
[  393.255802] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[  393.260887] wl0: dma_attach: DMA64 osh ffff88007a9c9738 flags 0x0 ntxd 256 nrxd 0 rxbufsize 0 rxextheadroom -1 nrxpost 0 rxoffset 0 dmaregstx ffffc900237882c0 dmaregsrx (null)
[  393.270665] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[  393.275879] wl0: wlc_coredisable
[  393.281137] wl0: wlc_bmac_core_phypll_ctl
[  393.286282] wl0: wlc_bmac_xtal: want 0
[  393.291265] wlc_protection_upd: idx 15, val -1
[  393.296230] wlc_bmac_copyfrom_vars, nvram vars totlen=2299
[  393.301390] wl0: wlc_stf_spatial_policy_set: val 0
[  393.306505] wl0: wlc_stf_txcore_set: Nsts 1 core_mask 1
[  393.311730] wl0: wlc_stf_txcore_set: Nsts 2 core_mask 3
[  393.316921] wl0: wlc_stf_txcore_set: Nsts 3 core_mask 7
[  393.322211] wl0: wlc_stf_txcore_set: Nsts 4 core_mask f
[  393.327403] wlc_protection_upd: idx 3, val 1
[  393.332647] wlc_protection_upd: idx 10, val 1
[  393.337935] wl0: wlc_channel_mgr_attach
[  393.343153] wlc_protection_upd: idx 3, val 1
[  393.348767] wl0: wlc_doiovar
[  393.352219] wl0: wlc_doiovar: id 1
[  393.568224] phy0: Selected rate control algorithm 'minstrel_ht'
[  393.600350]  (Compiled in . at 23:27:00 on Oct  7 2010)
[  393.605803] cfg80211: Calling CRDA for country: US
[  393.713588] cfg80211: Regulatory domain changed to country: US
[  393.718232]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  393.722941]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  393.727656]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  393.728696] wl0: wlc_up:
[  393.728821] wl0: wlc_bmac_hw_up:
[  393.728829] wl0: wlc_bmac_xtal: want 1
[  393.728931] wl0: wlc_bmac_up_prep:
[  393.728938] wl0: wlc_bmac_xtal: want 1
[  393.729119] wl0: wlc_bmac_xtal: want 0
[  393.729597] wl0: wlc_doiovar
[  393.729605] wl0: wlc_doiovar: id 3
[  393.729613] wl0: wlc_doiovar
[  393.729619] wl0: wlc_doiovar: id 3
[  393.729626] wl0: wlc_doiovar
[  393.729632] wl0: wlc_doiovar: id 2
[  393.729640] wl0: wlc_doiovar
[  393.729647] wl0: wlc_doiovar: id 2
[  393.735224] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  393.775787]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  393.777961]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  393.780242]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  393.782427]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[  393.972913] ------------[ cut here ]------------
[  393.976695] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[  393.980693] Hardware name: 1015PEM
[  393.984672] tx refused but queue active
[  393.987701] Modules linked in: arc4 ecb brcm80211 netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_realtek snd_hda_intel uvcvideo microcode snd_hda_codec mac80211 videodev snd_hwdep v4l1_compat snd_seq v4l2_compat_ioctl32 eeepc_wmi snd_seq_device sparse_keymap snd_pcm cfg80211 atl1c joydev rfkill snd_timer snd soundcore snd_page_alloc shpchp wmi ipv6 cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[  394.011827] Pid: 52, comm: kworker/u:2 Not tainted 2.6.36-0.34.rc6.git3.fc15.x86_64 #1
[  394.015619] Call Trace:
[  394.018946]  [<ffffffff810511dc>] warn_slowpath_common+0x85/0x9d
[  394.022272]  [<ffffffff81051297>] warn_slowpath_fmt+0x46/0x48
[  394.025541]  [<ffffffffa0280563>] ieee80211_tx+0x1f2/0x225 [mac80211]
[  394.030437]  [<ffffffffa0280705>] ieee80211_xmit+0x16f/0x183 [mac80211]
[  394.034881]  [<ffffffff8104ae42>] ? get_parent_ip+0x11/0x41
[  394.039746]  [<ffffffffa02817bd>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[  394.044249]  [<ffffffffa02817bd>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[  394.049202]  [<ffffffffa02817ca>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[  394.053710]  [<ffffffffa0283fec>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[  394.058858]  [<ffffffffa026e283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[  394.063561]  [<ffffffff81067bfb>] process_one_work+0x1ee/0x355
[  394.068896]  [<ffffffff81067b6d>] ? process_one_work+0x160/0x355
[  394.074173]  [<ffffffff8107db9e>] ? lock_acquired+0x1fd/0x20c
[  394.079432]  [<ffffffffa026df00>] ? ieee80211_scan_work+0x0/0x441 [mac80211]
[  394.084514]  [<ffffffff81068ce0>] worker_thread+0x104/0x19b
[  394.090828]  [<ffffffff81068bdc>] ? worker_thread+0x0/0x19b
[  394.095863]  [<ffffffff8106c63c>] kthread+0x9d/0xa5
[  394.099364]  [<ffffffff8100ab64>] kernel_thread_helper+0x4/0x10
[  394.102983]  [<ffffffff8149e850>] ? restore_args+0x0/0x30
[  394.106437]  [<ffffffff8106c59f>] ? kthread+0x0/0xa5
[  394.112118]  [<ffffffff8100ab60>] ? kernel_thread_helper+0x0/0x10
[  394.117614] ---[ end trace fb5725ec65dccb06 ]---
[  394.183446] ------------[ cut here ]------------
[  394.187555] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[  394.191822] Hardware name: 1015PEM
[  394.196254] tx refused but queue active
[  394.200583] Modules linked in: arc4 ecb brcm80211 netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_realtek snd_hda_intel uvcvideo microcode snd_hda_codec mac80211 videodev snd_hwdep v4l1_compat snd_seq v4l2_compat_ioctl32 eeepc_wmi snd_seq_device sparse_keymap snd_pcm cfg80211 atl1c joydev rfkill snd_timer snd soundcore snd_page_alloc shpchp wmi ipv6 cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[  394.239443] Pid: 52, comm: kworker/u:2 Tainted: G        W   2.6.36-0.34.rc6.git3.fc15.x86_64 #1
[  394.245500] Call Trace:
[  394.251604]  [<ffffffff810511dc>] warn_slowpath_common+0x85/0x9d
[  394.257231]  [<ffffffff81051297>] warn_slowpath_fmt+0x46/0x48
[  394.263143]  [<ffffffffa0280563>] ieee80211_tx+0x1f2/0x225 [mac80211]
[  394.268589]  [<ffffffffa0280705>] ieee80211_xmit+0x16f/0x183 [mac80211]
[  394.274316]  [<ffffffff8104ae42>] ? get_parent_ip+0x11/0x41
[  394.279961]  [<ffffffffa02817bd>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[  394.285447]  [<ffffffffa02817bd>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[  394.291381]  [<ffffffffa02817ca>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[  394.296799]  [<ffffffffa0283fec>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[  394.302638]  [<ffffffffa026e283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[  394.308380]  [<ffffffff81067bfb>] process_one_work+0x1ee/0x355
[  394.314005]  [<ffffffff81067b6d>] ? process_one_work+0x160/0x355
[  394.319681]  [<ffffffff8107db9e>] ? lock_acquired+0x1fd/0x20c
[  394.325185]  [<ffffffffa026df00>] ? ieee80211_scan_work+0x0/0x441 [mac80211]
[  394.331011]  [<ffffffff81068ce0>] worker_thread+0x104/0x19b
[  394.336679]  [<ffffffff81068bdc>] ? worker_thread+0x0/0x19b
[  394.342100]  [<ffffffff8106c63c>] kthread+0x9d/0xa5
[  394.347845]  [<ffffffff8100ab64>] kernel_thread_helper+0x4/0x10
[  394.353409]  [<ffffffff8149e850>] ? restore_args+0x0/0x30
[  394.358774]  [<ffffffff8106c59f>] ? kthread+0x0/0xa5
[  394.364528]  [<ffffffff8100ab60>] ? kernel_thread_helper+0x0/0x10
[  394.370185] ---[ end trace fb5725ec65dccb07 ]---
[  394.436596] ------------[ cut here ]------------
[  394.441966] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[  394.447790] Hardware name: 1015PEM
[  394.453188] tx refused but queue active
[  394.458810] Modules linked in: arc4 ecb brcm80211 netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_realtek snd_hda_intel uvcvideo microcode snd_hda_codec mac80211 videodev snd_hwdep v4l1_compat snd_seq v4l2_compat_ioctl32 eeepc_wmi snd_seq_device sparse_keymap snd_pcm cfg80211 atl1c joydev rfkill snd_timer snd soundcore snd_page_alloc shpchp wmi ipv6 cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[  394.497956] Pid: 52, comm: kworker/u:2 Tainted: G        W   2.6.36-0.34.rc6.git3.fc15.x86_64 #1
[  394.503916] Call Trace:
[  394.509699]  [<ffffffff810511dc>] warn_slowpath_common+0x85/0x9d
[  394.515231]  [<ffffffff81051297>] warn_slowpath_fmt+0x46/0x48
[  394.520826]  [<ffffffffa0280563>] ieee80211_tx+0x1f2/0x225 [mac80211]
[  394.526228]  [<ffffffffa0280705>] ieee80211_xmit+0x16f/0x183 [mac80211]
[  394.531645]  [<ffffffff8104ae42>] ? get_parent_ip+0x11/0x41
[  394.537029]  [<ffffffffa02817bd>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[  394.542575]  [<ffffffffa02817bd>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[  394.547913]  [<ffffffffa02817ca>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[  394.553395]  [<ffffffffa0283fec>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[  394.558713]  [<ffffffffa026e283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[  394.564177]  [<ffffffff81067bfb>] process_one_work+0x1ee/0x355
[  394.569633]  [<ffffffff81067b6d>] ? process_one_work+0x160/0x355
[  394.575097]  [<ffffffff8107db9e>] ? lock_acquired+0x1fd/0x20c
[  394.580602]  [<ffffffffa026df00>] ? ieee80211_scan_work+0x0/0x441 [mac80211]
[  394.585902]  [<ffffffff81068ce0>] worker_thread+0x104/0x19b
[  394.591438]  [<ffffffff81068bdc>] ? worker_thread+0x0/0x19b
[  394.596747]  [<ffffffff8106c63c>] kthread+0x9d/0xa5
[  394.602178]  [<ffffffff8100ab64>] kernel_thread_helper+0x4/0x10
[  394.607425]  [<ffffffff8149e850>] ? restore_args+0x0/0x30
[  394.612798]  [<ffffffff8106c59f>] ? kthread+0x0/0xa5
[  394.618105]  [<ffffffff8100ab60>] ? kernel_thread_helper+0x0/0x10
[  394.623491] ---[ end trace fb5725ec65dccb08 ]---
[  394.630148] wl0: wlc_bmac_xtal: want 1
