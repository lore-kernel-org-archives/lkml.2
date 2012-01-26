Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2AZWTi (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 26 Jan 2012 17:19:38 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:59594 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab2AZWTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:19:36 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 27 Jan 2012 02:19:34 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f21d1760afcd0.53137187@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > thanks , i am just looking at this tough to recreate warning and its
 > being reported by few users recently. please let us if you some more
 > information

Another data point:

3.2.1 + fix + sign catcher

Similar warnings overflowing my /var/log partition...

Note: ath9k per se worked; after reloading ath9k module situation returned 
to normal. 


Jan 27 00:15:56 401a0bf1 kernel: [241491.957493] ------------[ cut here ]-
-----------
Jan 27 00:15:56 401a0bf1 kernel: [241491.957502] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()
Jan 27 00:15:56 401a0bf1 kernel: [241491.957504] Hardware name: N53Jn
Jan 27 00:15:56 401a0bf1 kernel: [241491.957505] Modules linked in: ath9k 
ath5k xhci_hcd nls_iso8859_1 nls_cp437 vfat fat isofs nls_utf8 udf 
crc_itu_t nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs cryptd aes_x86_64 
aes_generic af_packet snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo 
videodev v4l2_compat_ioctl32 cdc_phonet phonet bsd_comp ppp_deflate 
ppp_async crc_ccitt ppp_generic slhc cdc_acm rtc_cmos configs kvm_intel 
kvm atl1c ide_cd_mod ide_core pktcdvd pata_atiixp ipip tunnel4 ftdi_sio 
usbserial arc4 mac80211 ath9k_common ath9k_hw ath cfg80211 rfkill 8139too 
mii fuse thermal ac tun usb_storage usb_libusual cpufreq_conservative 
speedstep_lib cpufreq_powersave cpufreq_performance loop ipv6 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc battery 
power_supply coretemp cpufreq_ondemand acpi_cpufreq freq_table processor 
mperf fbcon tileblit font bitblit softcursor i915 drm_kms_helper drm 
intel_agp i2c_algo_bit button intel_gtt agpgart vi
Jan 27 00:15:56 401a0bf1 kernel: eo thermal_sys hwmon ext4 jbd2 crc16 
sr_mod cdrom ahci libahci xtkbd ohci_hcd uhci_hcd ehci_hcd usbhid hid 
usbcore usb_common btrfs zlib_deflate libcrc32c crc32c ext3 jbd mbcache 
synaptics_i2c i2c_core sermouse psmouse evdev pcips2 sd_mod crc_t10dif 
libata scsi_mod dm_mod unix [last unloaded: xhci_hcd]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957597] Pid: 20646, comm: 
kworker/u:1 Tainted: G        W    3.2.1 #1
Jan 27 00:15:56 401a0bf1 kernel: [241491.957599] Call Trace:
Jan 27 00:15:56 401a0bf1 kernel: [241491.957606]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan 27 00:15:56 401a0bf1 kernel: [241491.957606]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan 27 00:15:56 401a0bf1 kernel: [241491.957608]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan 27 00:15:56 401a0bf1 kernel: [241491.957608]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan 27 00:15:56 401a0bf1 kernel: [241491.957611]  
[ath9k:ath_rc_get_highest_rix.clone.18+0x159/0x200] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957611]  [<ffffffffa0782769>] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957614]  
[ath9k:ath_get_rate+0x86/0x480] ath_get_rate+0x86/0x480 [ath9k]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957614]  [<ffffffffa0782896>] 
ath_get_rate+0x86/0x480 [ath9k]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957624]  
[mac80211:rate_control_get_rate+0x86/0x160] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957624]  [<ffffffffa053ea26>] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957629]  
[mac80211:invoke_tx_handlers+0x7fa/0x1170] invoke_tx_handlers+0x7fa/0x1170 
[mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957629]  [<ffffffffa054849a>] 
invoke_tx_handlers+0x7fa/0x1170 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957635]  
[mac80211:ieee80211_tx+0x5b/0xb0] ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957635]  [<ffffffffa0548f6b>] 
ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957639]  [__alloc_skb+0x82/0x160] 
? __alloc_skb+0x82/0x160
Jan 27 00:15:56 401a0bf1 kernel: [241491.957639]  [<ffffffff812ac842>] ? 
__alloc_skb+0x82/0x160
Jan 27 00:15:56 401a0bf1 kernel: [241491.957644]  
[mac80211:ieee80211_xmit+0x87/0xb0] ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957644]  [<ffffffffa0549047>] 
ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957649]  
[mac80211:ieee80211_tx_skb+0x56/0x70] ieee80211_tx_skb+0x56/0x70 
[mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957649]  [<ffffffffa0549e06>] 
ieee80211_tx_skb+0x56/0x70 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957654]  
[mac80211:ieee80211_send_nullfunc+0x51/0x70] 
ieee80211_send_nullfunc+0x51/0x70 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957654]  [<ffffffffa0536f11>] 
ieee80211_send_nullfunc+0x51/0x70 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957659]  
[mac80211:ieee80211_rx_mgmt_beacon+0x4b3/0x660] 
ieee80211_rx_mgmt_beacon+0x4b3/0x660 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957659]  [<ffffffffa0537f63>] 
ieee80211_rx_mgmt_beacon+0x4b3/0x660 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957664]  
[mac80211:ieee80211_sta_rx_queued_mgmt+0x27f/0x3b0] 
ieee80211_sta_rx_queued_mgmt+0x27f/0x3b0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957664]  [<ffffffffa05393cf>] 
ieee80211_sta_rx_queued_mgmt+0x27f/0x3b0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957669]  
[mac80211:ieee80211_iface_work+0x22b/0x330] 
ieee80211_iface_work+0x22b/0x330 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957669]  [<ffffffffa053ca2b>] 
ieee80211_iface_work+0x22b/0x330 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957675]  
[mac80211:ieee80211_iface_work+0x0/0x330] ? 
ieee80211_teardown_sdata+0xd0/0xd0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957675]  [<ffffffffa053c800>] ? 
ieee80211_teardown_sdata+0xd0/0xd0 [mac80211]
Jan 27 00:15:56 401a0bf1 kernel: [241491.957679]  
[process_one_work+0x111/0x390] process_one_work+0x111/0x390
Jan 27 00:15:56 401a0bf1 kernel: [241491.957679]  [<ffffffff81062eb1>] 
process_one_work+0x111/0x390
Jan 27 00:15:56 401a0bf1 kernel: [241491.957682]  
[worker_thread+0x162/0x340] worker_thread+0x162/0x340
Jan 27 00:15:56 401a0bf1 kernel: [241491.957682]  [<ffffffff81063d12>] 
worker_thread+0x162/0x340
Jan 27 00:15:56 401a0bf1 kernel: [241491.957685]  
[worker_thread+0x0/0x340] ? manage_workers.clone.26+0x240/0x240
Jan 27 00:15:56 401a0bf1 kernel: [241491.957685]  [<ffffffff81063bb0>] ? 
manage_workers.clone.26+0x240/0x240
Jan 27 00:15:56 401a0bf1 kernel: [241491.957688]  [kthread+0x96/0xa0] 
kthread+0x96/0xa0
Jan 27 00:15:56 401a0bf1 kernel: [241491.957688]  [<ffffffff81068936>] 
kthread+0x96/0xa0
Jan 27 00:15:56 401a0bf1 kernel: [241491.957692]  
[kernel_thread_helper+0x4/0x10] kernel_thread_helper+0x4/0x10
Jan 27 00:15:56 401a0bf1 kernel: [241491.957692]  [<ffffffff8135ef34>] 
kernel_thread_helper+0x4/0x10
Jan 27 00:15:56 401a0bf1 kernel: [241491.957694]  [kthread+0x0/0xa0] ? 
kthread_worker_fn+0x190/0x190
Jan 27 00:15:56 401a0bf1 kernel: [241491.957694]  [<ffffffff810688a0>] ? 
kthread_worker_fn+0x190/0x190
Jan 27 00:15:56 401a0bf1 kernel: [241491.957697]  
[kernel_thread_helper+0x0/0x10] ? gs_change+0x13/0x13
Jan 27 00:15:56 401a0bf1 kernel: [241491.957697]  [<ffffffff8135ef30>] ? 
gs_change+0x13/0x13
Jan 27 00:15:56 401a0bf1 kernel: [241491.957698] ---[ end trace 
078f024285127110 ]---



