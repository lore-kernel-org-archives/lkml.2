Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0JHLpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 07:45:36 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:55363 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab0JHLpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 07:45:35 -0400
Subject: Re: PROBLEM: brcm80211 hangs on 2.6.36-0.34.rc6.git3.fc15.x86_64
From: Jon Masters <jonathan@jonmasters.org>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Nohee Ko <noheek@broadcom.com>, Jon Masters <jcm@jonmasters.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101008065810.GA1680@constitution.bos.jonmasters.org>
References: <20101008065810.GA1680@constitution.bos.jonmasters.org>
Content-Type: multipart/mixed; boundary="=-dEUsbvqIEINaOIw7Gi8G"
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 08 Oct 2010 07:44:03 -0400
Message-ID: <1286538243.21485.298.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dEUsbvqIEINaOIw7Gi8G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2010-10-08 at 02:58 -0400, Jon Masters wrote:

> I tried building the new brcm80211 driver from staging-next on Fedora rawhide
> kernel 2.6.36-0.34.rc6.git3.fc15.x86_64. Now, of course, it's not the
> staging-next kernel (I'll try that now this doesn't work) but perhaps this
> report will still be of use to the Broadcom/other wireless folks.

I pulled the latest staging-next onto Linus' latest git tree and still
experience problems with the driver. It seems that the first attempt to
actually transmit results in the system locking hard. Once again, I am
attaching the output from running a netconsole (due to the box I'm on,
it's an attachment this time, sorry about that - don't trust evolution)
where the trace is basically the same as the original trace I posted.

NOTE: in both cases, the driver is loaded with "msglevel=2
phymsglevel=2" which (although not documented) suggests to enable
tracing, and does certainly yield more debugging output.

Jon.


--=-dEUsbvqIEINaOIw7Gi8G
Content-Disposition: attachment; filename="netconsole_brcm80211_2.6.32-rc7+_20101008_1.txt"
Content-Type: text/plain; name="netconsole_brcm80211_2.6.32-rc7+_20101008_1.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ 1540.841511] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[ 1540.842382] console [netcon0] enabled
[ 1540.842517] netconsole: network logging started
[ 1569.024428] brcm80211: module is from the staging directory, the quality is unknown, you have been warned.
[ 1569.069185] wl_pci_probe: bus 2 slot 0 func 0 irq 10
[ 1569.069502] brcm80211 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 1569.069728] brcm80211 0000:02:00.0: setting latency timer to 64
[ 1569.070161] PCI/DMA
[ 1569.125423] wlc_protection_upd: idx 2, val -1
[ 1569.125669] wlc_protection_upd: idx 1, val 0
[ 1569.125869] wlc_protection_upd: idx 12, val -1
[ 1569.126217] wlc_protection_upd: idx 11, val 0
[ 1569.129792] wlc_protection_upd: idx 14, val -1
[ 1569.133283] wlc_protection_upd: idx 13, val 0
[ 1569.136555] wlc_protection_upd: idx 15, val -1
[ 1569.139247] wlc_protection_upd: idx 4, val 2
[ 1569.141950] wl0: wlc_bmac_attach: vendor 0x14e4 device 0x4727
[ 1569.144863] Found chip type AI (0x13814313)
[ 1569.152103] Changing max_res_mask to 0xffff
[ 1569.154878] Changing min_res_mask to 0x200d
[ 1569.163723] Applying 4313 WARs
[ 1569.166531] wl0: wlc_bmac_corereset
[ 1569.169696] wl0: wlc_bmac_phy_reset
[ 1569.172161] wl0: wlc_bmac_core_phypll_ctl
[ 1569.174544] wl0: validate_chip_access
[ 1569.177054] wl0: wlc_setxband: bandunit 0
[ 1569.179505] wl0: wlc_bmac_corereset
[ 1569.182045] wl0: wlc_bmac_phy_reset
[ 1569.184715] wl0: wlc_bmac_core_phypll_ctl
[ 1569.187683] wl0: dma_attach: DMA64 osh ffff880058e0b540 flags 0x0 ntxd 256 nrxd 256 rxbufsize 2048 rxextheadroom -1 nrxpost 32 rxoffset 38 dmaregstx ffffc90000368200 dmaregsrx ffffc90000368220
[ 1569.192827] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[ 1569.195594] wl0: dma_attach: DMA64 osh ffff880058e0b540 flags 0x0 ntxd 256 nrxd 0 rxbufsize 0 rxextheadroom -1 nrxpost 0 rxoffset 0 dmaregstx ffffc90000368240 dmaregsrx (null)
[ 1569.201320] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[ 1569.204463] wl0: dma_attach: DMA64 osh ffff880058e0b540 flags 0x0 ntxd 256 nrxd 0 rxbufsize 0 rxextheadroom -1 nrxpost 0 rxoffset 0 dmaregstx ffffc90000368280 dmaregsrx (null)
[ 1569.210866] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[ 1569.214271] wl0: dma_attach: DMA64 osh ffff880058e0b540 flags 0x0 ntxd 256 nrxd 0 rxbufsize 0 rxextheadroom -1 nrxpost 0 rxoffset 0 dmaregstx ffffc900003682c0 dmaregsrx (null)
[ 1569.221129] ddoffsetlow 0x0 ddoffsethigh 0x80000000 dataoffsetlow 0x0 dataoffsethigh 0x80000000 addrext 1
[ 1569.224603] wl0: wlc_coredisable
[ 1569.228119] wl0: wlc_bmac_core_phypll_ctl
[ 1569.231516] wl0: wlc_bmac_xtal: want 0
[ 1569.234853] wlc_protection_upd: idx 15, val -1
[ 1569.238260] wlc_bmac_copyfrom_vars, nvram vars totlen=2299
[ 1569.241697] wl0: wlc_stf_spatial_policy_set: val 0
[ 1569.245129] wl0: wlc_stf_txcore_set: Nsts 1 core_mask 1
[ 1569.248625] wl0: wlc_stf_txcore_set: Nsts 2 core_mask 3
[ 1569.252125] wl0: wlc_stf_txcore_set: Nsts 3 core_mask 7
[ 1569.255643] wl0: wlc_stf_txcore_set: Nsts 4 core_mask f
[ 1569.259611] wlc_protection_upd: idx 3, val 1
[ 1569.263284] wlc_protection_upd: idx 10, val 1
[ 1569.266834] wl0: wlc_channel_mgr_attach
[ 1569.270263] wlc_protection_upd: idx 3, val 1
[ 1569.273945] wl0: wlc_doiovar
[ 1569.277519] wl0: wlc_doiovar: id 1
[ 1569.453938] phy0: Selected rate control algorithm 'minstrel_ht'
[ 1569.468950]  (Compiled in . at 06:38:04 on Oct  8 2010)
[ 1569.473789] cfg80211: Calling CRDA for country: US
[ 1569.566461] cfg80211: Regulatory domain changed to country: US
[ 1569.571312]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1569.575892]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[ 1569.580269]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[ 1569.584680]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1569.589365]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1569.594175]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1569.597908]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[ 1569.606377] wl0: wlc_up:
[ 1569.610564] wl0: wlc_bmac_hw_up:
[ 1569.613714] wl0: wlc_bmac_xtal: want 1
[ 1569.616787] wl0: wlc_bmac_up_prep:
[ 1569.619662] wl0: wlc_bmac_xtal: want 1
[ 1569.622470] wl0: wlc_bmac_xtal: want 0
[ 1569.625219] wl0: wlc_doiovar
[ 1569.628845] wl0: wlc_doiovar: id 3
[ 1569.631708] wl0: wlc_doiovar
[ 1569.634344] wl0: wlc_doiovar: id 3
[ 1569.636401] wl0: wlc_doiovar
[ 1569.638327] wl0: wlc_doiovar: id 2
[ 1569.640282] wl0: wlc_doiovar
[ 1569.642185] wl0: wlc_doiovar: id 2
[ 1569.645929] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1569.828326] ------------[ cut here ]------------
[ 1569.832045] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[ 1569.835868] Hardware name: 1015PEM
[ 1569.839821] tx refused but queue active
[ 1569.843886] Modules linked in: arc4 ecb brcm80211(C) netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq uvcvideo cfg80211 snd_seq_device snd_pcm videodev v4l1_compat snd_timer v4l2_compat_ioctl32 microcode atl1c eeepc_wmi snd rfkill sparse_keymap joydev soundcore shpchp snd_page_alloc wmi ipv6 aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[ 1569.871134] Pid: 54, comm: kworker/u:4 Tainted: G         C  2.6.36-rc7+ #2
[ 1569.874559] Call Trace:
[ 1569.877949]  [<ffffffff81050fa4>] warn_slowpath_common+0x85/0x9d
[ 1569.881449]  [<ffffffff8105105f>] warn_slowpath_fmt+0x46/0x48
[ 1569.885278]  [<ffffffffa039856f>] ieee80211_tx+0x1f2/0x225 [mac80211]
[ 1569.889121]  [<ffffffffa0398711>] ieee80211_xmit+0x16f/0x183 [mac80211]
[ 1569.892626]  [<ffffffff8104acba>] ? get_parent_ip+0x11/0x42
[ 1569.892687]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1569.892738]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1569.892789]  [<ffffffffa03997d6>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[ 1569.892843]  [<ffffffffa039bff8>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[ 1569.892886]  [<ffffffffa0386283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[ 1569.892902]  [<ffffffff810805f6>] ? lock_release+0x19a/0x1a6
[ 1569.892918]  [<ffffffff8106840f>] process_one_work+0x1ee/0x355
[ 1569.892932]  [<ffffffff81068381>] ? process_one_work+0x160/0x355
[ 1569.892946]  [<ffffffff8107e366>] ? lock_acquired+0x1fd/0x20c
[ 1569.892989]  [<ffffffffa0385f00>] ? ieee80211_scan_work+0x0/0x441 [mac80211]
[ 1569.893061]  [<ffffffff810694e7>] worker_thread+0x104/0x19b
[ 1569.893078]  [<ffffffff810693e3>] ? worker_thread+0x0/0x19b
[ 1569.893092]  [<ffffffff8106ce04>] kthread+0x9d/0xa5
[ 1569.893108]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
[ 1569.893124]  [<ffffffff8148edd0>] ? restore_args+0x0/0x30
[ 1569.893136]  [<ffffffff8106cd67>] ? kthread+0x0/0xa5
[ 1569.893148]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
[ 1569.893158] ---[ end trace 23d9e636f74a4cab ]---
[ 1569.962252] ------------[ cut here ]------------
[ 1569.966338] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[ 1569.970441] Hardware name: 1015PEM
[ 1569.974408] tx refused but queue active
[ 1569.978687] Modules linked in: arc4 ecb brcm80211(C) netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq uvcvideo cfg80211 snd_seq_device snd_pcm videodev v4l1_compat snd_timer v4l2_compat_ioctl32 microcode atl1c eeepc_wmi snd rfkill sparse_keymap joydev soundcore shpchp snd_page_alloc wmi ipv6 aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[ 1570.008530] Pid: 54, comm: kworker/u:4 Tainted: G        WC  2.6.36-rc7+ #2
[ 1570.013294] Call Trace:
[ 1570.017818]  [<ffffffff81050fa4>] warn_slowpath_common+0x85/0x9d
[ 1570.022353]  [<ffffffff8105105f>] warn_slowpath_fmt+0x46/0x48
[ 1570.026841]  [<ffffffffa039856f>] ieee80211_tx+0x1f2/0x225 [mac80211]
[ 1570.031345]  [<ffffffffa0398711>] ieee80211_xmit+0x16f/0x183 [mac80211]
[ 1570.035791]  [<ffffffff8104acba>] ? get_parent_ip+0x11/0x42
[ 1570.040205]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1570.044582]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1570.048832]  [<ffffffffa03997d6>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[ 1570.053232]  [<ffffffffa039bff8>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[ 1570.057696]  [<ffffffffa0386283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[ 1570.062010]  [<ffffffff810805f6>] ? lock_release+0x19a/0x1a6
[ 1570.066352]  [<ffffffff8106840f>] process_one_work+0x1ee/0x355
[ 1570.069928]  [<ffffffff81068381>] ? process_one_work+0x160/0x355
[ 1570.073578]  [<ffffffff8107e366>] ? lock_acquired+0x1fd/0x20c
[ 1570.077594]  [<ffffffffa0385f00>] ? ieee80211_scan_work+0x0/0x441 [mac80211]
[ 1570.082092]  [<ffffffff810694e7>] worker_thread+0x104/0x19b
[ 1570.086353]  [<ffffffff810693e3>] ? worker_thread+0x0/0x19b
[ 1570.089878]  [<ffffffff8106ce04>] kthread+0x9d/0xa5
[ 1570.093433]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
[ 1570.097458]  [<ffffffff8148edd0>] ? restore_args+0x0/0x30
[ 1570.101578]  [<ffffffff8106cd67>] ? kthread+0x0/0xa5
[ 1570.105776]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
[ 1570.110100] ---[ end trace 23d9e636f74a4cac ]---
[ 1570.174404] ------------[ cut here ]------------
[ 1570.179676] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[ 1570.185213] Hardware name: 1015PEM
[ 1570.190549] tx refused but queue active
[ 1570.195810] Modules linked in: arc4 ecb brcm80211(C) netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq uvcvideo cfg80211 snd_seq_device snd_pcm videodev v4l1_compat snd_timer v4l2_compat_ioctl32 microcode atl1c eeepc_wmi snd rfkill sparse_keymap joydev soundcore shpchp snd_page_alloc wmi ipv6 aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[ 1570.231248] Pid: 54, comm: kworker/u:4 Tainted: G        WC  2.6.36-rc7+ #2
[ 1570.237880] Call Trace:
[ 1570.243222]  [<ffffffff81050fa4>] warn_slowpath_common+0x85/0x9d
[ 1570.248740]  [<ffffffff8105105f>] warn_slowpath_fmt+0x46/0x48
[ 1570.254182]  [<ffffffffa039856f>] ieee80211_tx+0x1f2/0x225 [mac80211]
[ 1570.259630]  [<ffffffffa0398711>] ieee80211_xmit+0x16f/0x183 [mac80211]
[ 1570.264836]  [<ffffffff8104acba>] ? get_parent_ip+0x11/0x42
[ 1570.270349]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1570.275678]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1570.281167]  [<ffffffffa03997d6>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[ 1570.286376]  [<ffffffffa039bff8>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[ 1570.291924]  [<ffffffffa0386283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[ 1570.291958]  [<ffffffff810805f6>] ? lock_release+0x19a/0x1a6
[ 1570.291978]  [<ffffffff8106840f>] process_one_work+0x1ee/0x355
[ 1570.291993]  [<ffffffff81068381>] ? process_one_work+0x160/0x355
[ 1570.292064]  [<ffffffff8107e366>] ? lock_acquired+0x1fd/0x20c
[ 1570.292121]  [<ffffffffa0385f00>] ? ieee80211_scan_work+0x0/0x441 [mac80211]
[ 1570.292140]  [<ffffffff810694e7>] worker_thread+0x104/0x19b
[ 1570.292154]  [<ffffffff810693e3>] ? worker_thread+0x0/0x19b
[ 1570.292169]  [<ffffffff8106ce04>] kthread+0x9d/0xa5
[ 1570.292188]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
[ 1570.292207]  [<ffffffff8148edd0>] ? restore_args+0x0/0x30
[ 1570.292222]  [<ffffffff8106cd67>] ? kthread+0x0/0xa5
[ 1570.292237]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
[ 1570.292247] ---[ end trace 23d9e636f74a4cad ]---
[ 1570.360037] ------------[ cut here ]------------
[ 1570.364515] WARNING: at net/mac80211/tx.c:1464 ieee80211_tx+0x1f2/0x225 [mac80211]()
[ 1570.368911] Hardware name: 1015PEM
[ 1570.373271] tx refused but queue active
[ 1570.377036] Modules linked in: arc4 ecb brcm80211(C) netconsole configfs sco bnep l2cap bluetooth cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables uinput mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq uvcvideo cfg80211 snd_seq_device snd_pcm videodev v4l1_compat snd_timer v4l2_compat_ioctl32 microcode atl1c eeepc_wmi snd rfkill sparse_keymap joydev soundcore shpchp snd_page_alloc wmi ipv6 aes_x86_64 aes_generic xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
[ 1570.411263] Pid: 54, comm: kworker/u:4 Tainted: G        WC  2.6.36-rc7+ #2
[ 1570.416747] Call Trace:
[ 1570.421989]  [<ffffffff81050fa4>] warn_slowpath_common+0x85/0x9d
[ 1570.427189]  [<ffffffff8105105f>] warn_slowpath_fmt+0x46/0x48
[ 1570.432336]  [<ffffffff81051019>] ? warn_slowpath_fmt+0x0/0x48
[ 1570.437492]  [<ffffffffa039856f>] ieee80211_tx+0x1f2/0x225 [mac80211]
[ 1570.442740]  [<ffffffffa0398711>] ieee80211_xmit+0x16f/0x183 [mac80211]
[ 1570.447842]  [<ffffffff8104acba>] ? get_parent_ip+0x11/0x42
[ 1570.453071]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1570.459163]  [<ffffffffa03997c9>] ? ieee80211_tx_skb+0x42/0x59 [mac80211]
[ 1570.465152]  [<ffffffffa03997d6>] ieee80211_tx_skb+0x4f/0x59 [mac80211]
[ 1570.469527]  [<ffffffffa039bff8>] ieee80211_send_probe_req+0xd4/0xeb [mac80211]
[ 1570.473869]  [<ffffffffa0386283>] ieee80211_scan_work+0x383/0x441 [mac80211]
[ 1570.477634]  [<ffffffff810805f6>] ? lock_release+0x19a/0x1a6
[ 1570.481967]  [<ffffffff8106840f>] process_one_work+0x1ee/0x355
[ 1570.485507]  [<ffffffff81068381>] ? process_one_work+0x160/0x355
[ 1570.490593]  [<ffffffff8107e366>] ? lock_acquired+0x1fd/0x20c

--=-dEUsbvqIEINaOIw7Gi8G--

