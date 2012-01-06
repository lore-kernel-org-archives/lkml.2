Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab2AFUzm (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 6 Jan 2012 15:55:42 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:45875 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2AFUzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:55:40 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Sat, 07 Jan 2012 00:55:36 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f075fc8c78705.57074140@nextmail.ru>
Mime-Version: 1.0
Content-type: text/plain;
	 charset="koi8-r"
Content-transfer-encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > 2012/1/6 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
 > > š> > š> can a find a fix
 > > š> > š> for both of them
 > > š> >
 > > š> > I am building kernel with pos<0 check added...
 > > š>
 > > š> thanks! šif it does not works, i have only one more idea(a patch
 >> š> which removes some suspicious code which abuses a pointer any way that
 >> š> has to be fixed properly ). otherwise i need to recreate the issue and
 > > š> capture the stack trace completely, put debug prints. i ran an
 >> š> overnight test but was unable to recreate the issue. later today AN ši
 > > š> got a crash accidentally but only once, after that never.
 > >
 >> What is a complete stack trace? Maybe I can configure console in some way
 >and
 > > get the needed information.
 > >
 > >
 > yes, you can try netconsole
 > 
 > *connect your test machine with wifi with another machine via ethernet
 > *give IPS 192.168.2.45 for your test machine and 192.168.2.35 for the
 > machine that collects the logs
 > 
 > in the machine collecting log
 > 
 > nc -l -u 1111
 > 
 > 
 > in your test machine this script should be started
 > 
 > #!/bin/sh
 > #sudo service network-manager stop
 > sudo ifconfig eth0 192.168.2.45 netmask 255.255.255.0 up
 > sudo dmesg -n 8
 > sudo modprobe netconsole
 > netconsole=4444@192.168.2.45/eth0,1111@192.168.2.35/00:15:58:c3:bf:25
 > 
 > the last one is your mac address of  machine you collect logs

I managed to get some _weird_ effects with it. I.e, I did something right 
(emergency syncs do appear on the target computer), but most of dmesg doesn't 
manage to get across one meter of copper.

That doesn't matter, though. It does look like pos>37 check may trigger some 
adverse sign effects or something. So pos<0 check - or blind luck? - gave me 
a good disk-saveable trace...

There is more of the same later, of course. Much more. It looks the same, 
though.

Jan  6 23:33:07 401a0bf1 kernel: [ 2259.717612] netconsole: network logging 
started
Jan  7 00:21:28 401a0bf1 kernel: [ 5158.210728] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:28 401a0bf1 kernel: [ 5158.276098] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:28 401a0bf1 kernel: [ 5158.288955] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:28 401a0bf1 kernel: [ 5158.288958] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:29 401a0bf1 kernel: [ 5158.404436] ath: Chip reset failed
Jan  7 00:21:29 401a0bf1 kernel: [ 5158.404440] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:29 401a0bf1 kernel: [ 5158.867030] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:29 401a0bf1 kernel: [ 5158.932325] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:29 401a0bf1 kernel: [ 5158.945170] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:29 401a0bf1 kernel: [ 5158.945172] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:29 401a0bf1 kernel: [ 5159.060572] ath: Chip reset failed
Jan  7 00:21:29 401a0bf1 kernel: [ 5159.060576] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:30 401a0bf1 kernel: [ 5159.523536] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:30 401a0bf1 kernel: [ 5159.588735] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:30 401a0bf1 kernel: [ 5159.601586] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:30 401a0bf1 kernel: [ 5159.601588] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:30 401a0bf1 kernel: [ 5159.717074] ath: Chip reset failed
Jan  7 00:21:30 401a0bf1 kernel: [ 5159.717078] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.709373] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.774656] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.787499] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.787501] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.903039] ath: Chip reset failed
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.903041] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.968449] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.981289] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:31 401a0bf1 kernel: [ 5160.981294] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:31 401a0bf1 kernel: [ 5161.096681] ath: Chip reset failed
Jan  7 00:21:31 401a0bf1 kernel: [ 5161.096686] ath: Unable to reset channel 
(2417 MHz), reset status -22
Jan  7 00:21:31 401a0bf1 kernel: [ 5161.223178] ath: Failed to wakeup in 
500us
Jan  7 00:21:31 401a0bf1 kernel: [ 5161.239556] ath: Failed to wakeup in 
500us
Jan  7 00:21:31 401a0bf1 kernel: [ 5161.255021] ath: Failed to wakeup in 
500us
Jan  7 00:21:31 401a0bf1 kernel: [ 5161.255111] cfg80211: Calling CRDA for 
country: RU
Jan  7 00:21:32 401a0bf1 kernel: [ 5161.400675] ath: Failed to wakeup in 
500us
Jan  7 00:21:32 401a0bf1 kernel: [ 5161.411484] ath: Failed to wakeup in 
500us
Jan  7 00:21:32 401a0bf1 kernel: [ 5161.527195] ath: Chip reset failed
Jan  7 00:21:32 401a0bf1 kernel: [ 5161.527199] ath: Unable to reset channel 
(2417 MHz), reset status -22
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.022122] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.087365] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.100217] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.100219] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.215756] ath: Chip reset failed
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.215759] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:32 401a0bf1 kernel: [ 5162.280986] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.293810] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.293814] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.409170] ath: Chip reset failed
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.409175] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.409228] ath: Unable to set channel
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.474544] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.487419] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.487422] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.602974] ath: Chip reset failed
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.602979] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603031] ath: Unable to set channel
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603045] ------------[ cut here ]-----
-------
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603058] WARNING: at 
drivers/net/wireless/ath/ath9k/main.c:195 ath_update_survey_stats+0x233/0x260 
[ath9k]()
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603060] Hardware name: N53Jn
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603061] Modules linked in: netconsole 
af_packet snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev 
v4l2_compat_ioctl32 cdc_phonet phonet bsd_comp ppp_deflate ppp_async 
crc_ccitt ppp_generic slhc cdc_acm rtc_cmos configs kvm_intel kvm atl1c 
ide_cd_mod ide_core pktcdvd pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 
ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 rfkill 8139too mii fuse 
thermal ac tun usb_storage usb_libusual speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf i915 fbcon tileblit font bitblit softcursor 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd2 crc16 sr_mod cdrom ahci libahci xtkbd ohci_hcd 
uhci_hcd ehci_hcd xhci_hcd usbhid hid usbcore usb_common btrfs zlib_deflate 
libcrc32c 
Jan  7 00:21:33 401a0bf1 kernel: rc32c ext3 jbd mbcache synaptics_i2c 
i2c_core sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod 
dm_mod unix [last unloaded: ath5k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603129] Pid: 777, comm: kworker/u:0 
Not tainted 3.2.0 #1
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603131] Call Trace:
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603138]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603138]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603141]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603141]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603144]  
[ath9k:ath_update_survey_stats+0x233/0x260] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603144]  [<ffffffffa055e453>] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603147]  
[ath9k:ath9k_config+0x115/0x780] ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603147]  [<ffffffffa0560a45>] 
ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603152]  [queue_work+0x1a/0x20] ? 
queue_work+0x1a/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603152]  [<ffffffff81061dba>] ? 
queue_work+0x1a/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603154]  
[queue_delayed_work+0x25/0x30] ? queue_delayed_work+0x25/0x30
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603154]  [<ffffffff81061e65>] ? 
queue_delayed_work+0x25/0x30
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603161]  
[mac80211:ieee80211_queue_delayed_work+0x46/0x60] ? 
ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603161]  [<ffffffffa053d3f6>] ? 
ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603165]  
[ath9k:ath9k_flush+0x155/0x1d0] ? ath9k_flush+0x155/0x1d0 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603165]  [<ffffffffa055f7b5>] ? 
ath9k_flush+0x155/0x1d0 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603168]  
[mac80211:ieee80211_hw_config+0xe2/0x160] ieee80211_hw_config+0xe2/0x160 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603168]  [<ffffffffa051e272>] 
ieee80211_hw_config+0xe2/0x160 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603173]  
[mac80211:ieee80211_scan_work+0x243/0x5c0] ieee80211_scan_work+0x243/0x5c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603173]  [<ffffffffa0523a03>] 
ieee80211_scan_work+0x243/0x5c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603178]  
[mac80211:ieee80211_scan_work+0x0/0x5c0] ? ieee80211_scan_rx+0x1c0/0x1c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603178]  [<ffffffffa05237c0>] ? 
ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603180]  
[process_one_work+0x111/0x390] process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603180]  [<ffffffff81062eb1>] 
process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603183]  [worker_thread+0x162/0x340] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603183]  [<ffffffff81063d12>] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603185]  [worker_thread+0x0/0x340] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603185]  [<ffffffff81063bb0>] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603188]  [kthread+0x96/0xa0] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603188]  [<ffffffff81068936>] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603193]  
[kernel_thread_helper+0x4/0x10] kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603193]  [<ffffffff8135eef4>] 
kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603195]  [kthread+0x0/0xa0] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603195]  [<ffffffff810688a0>] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603197]  
[kernel_thread_helper+0x0/0x10] ? gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603197]  [<ffffffff8135eef0>] ? 
gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603199] ---[ end trace 
852186af63bdb712 ]---
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603200] 
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.603201] pos is 1810403901 index out 
of bounds!!! in ath_update_survey_stats
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.668425] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.681273] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.681275] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796837] ath: Chip reset failed
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796839] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796863] ath: Unable to set channel
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796873] ------------[ cut here ]-----
-------
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796889] WARNING: at 
drivers/net/wireless/ath/ath9k/main.c:195 ath_update_survey_stats+0x233/0x260 
[ath9k]()
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796892] Hardware name: N53Jn
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796893] Modules linked in: netconsole 
af_packet snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev 
v4l2_compat_ioctl32 cdc_phonet phonet bsd_comp ppp_deflate ppp_async 
crc_ccitt ppp_generic slhc cdc_acm rtc_cmos configs kvm_intel kvm atl1c 
ide_cd_mod ide_core pktcdvd pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 
ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 rfkill 8139too mii fuse 
thermal ac tun usb_storage usb_libusual speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf i915 fbcon tileblit font bitblit softcursor 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd2 crc16 sr_mod cdrom ahci libahci xtkbd ohci_hcd 
uhci_hcd ehci_hcd xhci_hcd usbhid hid usbcore usb_common btrfs zlib_deflate 
libcrc32c 
Jan  7 00:21:33 401a0bf1 kernel: rc32c ext3 jbd mbcache synaptics_i2c 
i2c_core sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod 
dm_mod unix [last unloaded: ath5k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796970] Pid: 777, comm: kworker/u:0 
Tainted: G        W    3.2.0 #1
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796972] Call Trace:
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796981]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796981]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796984]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796984]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796988]  
[ath9k:ath_update_survey_stats+0x233/0x260] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796988]  [<ffffffffa055e453>] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796992]  
[ath9k:ath9k_config+0x115/0x780] ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.796992]  [<ffffffffa0560a45>] 
ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797000]  
[mac80211:ieee80211_hw_config+0xe2/0x160] ieee80211_hw_config+0xe2/0x160 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797000]  [<ffffffffa051e272>] 
ieee80211_hw_config+0xe2/0x160 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797007]  
[mac80211:ieee80211_scan_work+0x243/0x5c0] ieee80211_scan_work+0x243/0x5c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797007]  [<ffffffffa0523a03>] 
ieee80211_scan_work+0x243/0x5c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797014]  
[mac80211:ieee80211_scan_work+0x0/0x5c0] ? ieee80211_scan_rx+0x1c0/0x1c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797014]  [<ffffffffa05237c0>] ? 
ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797019]  
[process_one_work+0x111/0x390] process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797019]  [<ffffffff81062eb1>] 
process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797023]  [worker_thread+0x162/0x340] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797023]  [<ffffffff81063d12>] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797026]  [worker_thread+0x0/0x340] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797026]  [<ffffffff81063bb0>] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797030]  [kthread+0x96/0xa0] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797030]  [<ffffffff81068936>] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797036]  
[kernel_thread_helper+0x4/0x10] kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797036]  [<ffffffff8135eef4>] 
kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797039]  [kthread+0x0/0xa0] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797039]  [<ffffffff810688a0>] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797042]  
[kernel_thread_helper+0x0/0x10] ? gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797042]  [<ffffffff8135eef0>] ? 
gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797044] ---[ end trace 
852186af63bdb713 ]---
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797046] 
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.797047] pos is 1810403901 index out 
of bounds!!! in ath_update_survey_stats
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.862420] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.875272] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.875274] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.990646] ath: Chip reset failed
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.990651] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.990758] ath: Unable to set channel
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991392] ------------[ cut here ]-----
-------
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991408] WARNING: at 
drivers/net/wireless/ath/ath9k/main.c:195 ath_update_survey_stats+0x233/0x260 
[ath9k]()
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991411] Hardware name: N53Jn
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991412] Modules linked in: netconsole 
af_packet snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev 
v4l2_compat_ioctl32 cdc_phonet phonet bsd_comp ppp_deflate ppp_async 
crc_ccitt ppp_generic slhc cdc_acm rtc_cmos configs kvm_intel kvm atl1c 
ide_cd_mod ide_core pktcdvd pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 
ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 rfkill 8139too mii fuse 
thermal ac tun usb_storage usb_libusual speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf i915 fbcon tileblit font bitblit softcursor 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd2 crc16 sr_mod cdrom ahci libahci xtkbd ohci_hcd 
uhci_hcd ehci_hcd xhci_hcd usbhid hid usbcore usb_common btrfs zlib_deflate 
libcrc32c 
Jan  7 00:21:33 401a0bf1 kernel: rc32c ext3 jbd mbcache synaptics_i2c 
i2c_core sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod 
dm_mod unix [last unloaded: ath5k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991511] Pid: 777, comm: kworker/u:0 
Tainted: G        W    3.2.0 #1
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991513] Call Trace:
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991521]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991521]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991525]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991525]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991530]  
[ath9k:ath_update_survey_stats+0x233/0x260] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991530]  [<ffffffffa055e453>] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991535]  
[ath9k:ath9k_config+0x115/0x780] ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991535]  [<ffffffffa0560a45>] 
ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991544]  
[mac80211:ieee80211_hw_config+0xe2/0x160] ieee80211_hw_config+0xe2/0x160 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991544]  [<ffffffffa051e272>] 
ieee80211_hw_config+0xe2/0x160 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991551]  
[mac80211:ieee80211_scan_work+0x243/0x5c0] ieee80211_scan_work+0x243/0x5c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991551]  [<ffffffffa0523a03>] 
ieee80211_scan_work+0x243/0x5c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991558]  
[mac80211:ieee80211_scan_work+0x0/0x5c0] ? ieee80211_scan_rx+0x1c0/0x1c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991558]  [<ffffffffa05237c0>] ? 
ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991563]  
[process_one_work+0x111/0x390] process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991563]  [<ffffffff81062eb1>] 
process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991568]  [worker_thread+0x162/0x340] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991568]  [<ffffffff81063d12>] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991571]  [worker_thread+0x0/0x340] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991571]  [<ffffffff81063bb0>] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991575]  [kthread+0x96/0xa0] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991575]  [<ffffffff81068936>] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991581]  
[kernel_thread_helper+0x4/0x10] kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991581]  [<ffffffff8135eef4>] 
kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991585]  [kthread+0x0/0xa0] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991585]  [<ffffffff810688a0>] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991588]  
[kernel_thread_helper+0x0/0x10] ? gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991588]  [<ffffffff8135eef0>] ? 
gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991591] ---[ end trace 
852186af63bdb714 ]---
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991592] 
Jan  7 00:21:33 401a0bf1 kernel: [ 5162.991593] pos is 1810403901 index out 
of bounds!!! in ath_update_survey_stats
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.056922] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.069872] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.069875] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185503] ath: Chip reset failed
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185507] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185579] ath: Unable to set channel
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185584] ------------[ cut here ]-----
-------
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185597] WARNING: at 
drivers/net/wireless/ath/ath9k/main.c:195 ath_update_survey_stats+0x233/0x260 
[ath9k]()
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185599] Hardware name: N53Jn
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185600] Modules linked in: netconsole 
af_packet snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev 
v4l2_compat_ioctl32 cdc_phonet phonet bsd_comp ppp_deflate ppp_async 
crc_ccitt ppp_generic slhc cdc_acm rtc_cmos configs kvm_intel kvm atl1c 
ide_cd_mod ide_core pktcdvd pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 
ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 rfkill 8139too mii fuse 
thermal ac tun usb_storage usb_libusual speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf i915 fbcon tileblit font bitblit softcursor 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd2 crc16 sr_mod cdrom ahci libahci xtkbd ohci_hcd 
uhci_hcd ehci_hcd xhci_hcd usbhid hid usbcore usb_common btrfs zlib_deflate 
libcrc32c 
Jan  7 00:21:33 401a0bf1 kernel: rc32c ext3 jbd mbcache synaptics_i2c 
i2c_core sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod 
dm_mod unix [last unloaded: ath5k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185664] Pid: 777, comm: kworker/u:0 
Tainted: G        W    3.2.0 #1
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185666] Call Trace:
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185673]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185673]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185675]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185675]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185678]  
[ath9k:ath_update_survey_stats+0x233/0x260] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185678]  [<ffffffffa055e453>] 
ath_update_survey_stats+0x233/0x260 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185682]  
[ath9k:ath9k_config+0x115/0x780] ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185682]  [<ffffffffa0560a45>] 
ath9k_config+0x115/0x780 [ath9k]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185688]  
[mac80211:ieee80211_hw_config+0xe2/0x160] ieee80211_hw_config+0xe2/0x160 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185688]  [<ffffffffa051e272>] 
ieee80211_hw_config+0xe2/0x160 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185693]  
[mac80211:ieee80211_scan_work+0x243/0x5c0] ieee80211_scan_work+0x243/0x5c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185693]  [<ffffffffa0523a03>] 
ieee80211_scan_work+0x243/0x5c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185697]  
[mac80211:ieee80211_scan_work+0x0/0x5c0] ? ieee80211_scan_rx+0x1c0/0x1c0 
[mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185697]  [<ffffffffa05237c0>] ? 
ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185702]  
[process_one_work+0x111/0x390] process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185702]  [<ffffffff81062eb1>] 
process_one_work+0x111/0x390
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185705]  [worker_thread+0x162/0x340] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185705]  [<ffffffff81063d12>] 
worker_thread+0x162/0x340
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185707]  [worker_thread+0x0/0x340] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185707]  [<ffffffff81063bb0>] ? 
manage_workers.clone.26+0x240/0x240
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185710]  [kthread+0x96/0xa0] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185710]  [<ffffffff81068936>] 
kthread+0x96/0xa0
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185715]  
[kernel_thread_helper+0x4/0x10] kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185715]  [<ffffffff8135eef4>] 
kernel_thread_helper+0x4/0x10
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185717]  [kthread+0x0/0xa0] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185717]  [<ffffffff810688a0>] ? 
kthread_worker_fn+0x190/0x190
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185719]  
[kernel_thread_helper+0x0/0x10] ? gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185719]  [<ffffffff8135eef0>] ? 
gs_change+0x13/0x13
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185721] ---[ end trace 
852186af63bdb715 ]---
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185722] 
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.185723] pos is 1810403901 index out 
of bounds!!! in ath_update_survey_stats
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.251027] ath: Failed to stop TX DMA, 
queues=0x10f!
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.263892] ath: DMA failed to stop in 10 
ms AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jan  7 00:21:33 401a0bf1 kernel: [ 5163.263894] ath: Could not stop RX, we 
could be confusing the DMA engine when we start RX up
Jan  7 00:21:34 401a0bf1 kernel: [ 5163.379438] ath: Chip reset failed
Jan  7 00:21:34 401a0bf1 kernel: [ 5163.379441] ath: Unable to reset channel, 
reset status -22
Jan  7 00:21:34 401a0bf1 kernel: [ 5163.379510] ath: Unable to set channel
Jan  7 00:21:34 401a0bf1 kernel: [ 5163.379519] ------------[ cut here ]-----
-------



