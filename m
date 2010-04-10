Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab0DJGyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 02:54:09 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:60672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0DJGyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 02:54:07 -0400
Subject: Re: Warning in ath9k after update from 2.6.33.1 to 2.6.33.2
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4BBF6206.2070103@archlinux.org>
References: <4BBF6206.2070103@archlinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 08:54:02 +0200
Message-ID: <1270882442.4760.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 19:21 +0200, Thomas Bächler wrote:
> Since I upgraded from 2.6.33.1 to .2, I get the following warning
> sometimes, related to wireless:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0x82/0xb0()
> Hardware name: TECRA A11
> Modules linked in: ipv6 rfcomm sco bnep l2cap bridge stp llc
> cpufreq_ondemand tun ext3 jbd btusb bluetooth uvcvideo videodev
> snd_seq_dummy v4l1_compat arc4 snd_seq_oss ecb v4l2_compat_ioctl32
> snd_seq_midi_event snd_hda_codec_intelhdmi snd_seq snd_seq_device
> tpm_infineon snd_hda_codec_realtek ath9k snd_pcm_oss ath9k_common
> snd_mixer_oss snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_pcm
> snd_timer ath9k_hw snd joydev soundcore ath sdhci_pci kvm_intel
> snd_page_alloc ehci_hcd iTCO_wdt evdev sdhci iTCO_vendor_support kvm
> usbcore mmc_core e1000e psmouse tpm_tis cfg80211 tpm toshiba_acpi
> acpi_cpufreq led_class tpm_bios rfkill toshiba_bluetooth serio_raw
> pcspkr sr_mod thermal cdrom battery sg ac freq_table processor rtc_cmos
> rtc_core rtc_lib fpu aesni_intel cryptd aes_x86_64 aes_generic xts
> gf128mul dm_crypt dm_mod sd_mod ahci libata scsi_mod ext4 mbcache jbd2
> crc16 i915 drm_kms_helper drm i2c_algo_bit button i2c_core video output
> intel_agp [last unloaded: microcode]
> Pid: 2571, comm: wpa_supplicant Not tainted 2.6.33-ARCH #1
> Call Trace:
>  [<ffffffff81052a08>] warn_slowpath_common+0x78/0xb0
>  [<ffffffff81052a4f>] warn_slowpath_null+0xf/0x20
>  [<ffffffff81059682>] local_bh_enable_ip+0x82/0xb0
>  [<ffffffff8135d42f>] _raw_spin_unlock_bh+0x1f/0x30
>  [<ffffffffa04018ed>] ath_tx_node_cleanup+0x19d/0x1c0 [ath9k]
>  [<ffffffffa03fc607>] ath9k_sta_notify+0x57/0xb0 [ath9k]
>  [<ffffffffa039bbc4>] __sta_info_unlink+0x174/0x220 [mac80211]
>  [<ffffffffa039bca8>] sta_info_unlink+0x38/0x60 [mac80211]
>  [<ffffffffa03a2639>] ieee80211_set_disassoc+0x1e9/0x290 [mac80211]
>  [<ffffffffa03a2e89>] ieee80211_mgd_deauth+0x159/0x160 [mac80211]
>  [<ffffffff8104d700>] ? default_wake_function+0x0/0x10
>  [<ffffffffa03a9b69>] ieee80211_deauth+0x19/0x20 [mac80211]
>  [<ffffffffa02426de>] __cfg80211_mlme_deauth+0xee/0x130 [cfg80211]
>  [<ffffffff8135baad>] ? __mutex_lock_slowpath+0x26d/0x370
>  [<ffffffffa0246839>] __cfg80211_disconnect+0x159/0x1d0 [cfg80211]
>  [<ffffffffa0248f9c>] cfg80211_wext_siwmlme+0x8c/0xa0 [cfg80211]
>  [<ffffffff8133e6b7>] ioctl_standard_iw_point+0x207/0x3a0
>  [<ffffffffa0248f10>] ? cfg80211_wext_siwmlme+0x0/0xa0 [cfg80211]
>  [<ffffffff8133e850>] ? ioctl_standard_call+0x0/0xd0
>  [<ffffffff8133e8e9>] ioctl_standard_call+0x99/0xd0
>  [<ffffffff812b2660>] ? __dev_get_by_name+0xa0/0xc0
>  [<ffffffff8133dce7>] wext_ioctl_dispatch+0x1f7/0x210
>  [<ffffffff8133f330>] ? ioctl_private_call+0x0/0xa0
>  [<ffffffff8133de91>] wext_handle_ioctl+0x41/0x90
>  [<ffffffff812b8299>] dev_ioctl+0x679/0x850
>  [<ffffffff812a0522>] sock_ioctl+0xe2/0x290
>  [<ffffffff812a369d>] ? sys_recvfrom+0x13d/0x160
>  [<ffffffff811324c8>] vfs_ioctl+0x38/0xd0
>  [<ffffffff81132670>] do_vfs_ioctl+0x80/0x560
>  [<ffffffff81132bd1>] sys_ioctl+0x81/0xa0
>  [<ffffffff8100b1f9>] ? do_device_not_available+0x9/0x10
>  [<ffffffff81009fc2>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8dbf12cb72787a6d ]---

I think the problem is that the locking for sta_notify changed, and a
patch that was written for the new locking was backported to the old,
irq-disabled, locking.

johannes

