Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0GZPLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:11:46 -0400
Received: from www17.your-server.de ([213.133.104.17]:36408 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0GZPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:11:45 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc6: S2R hangs + WARNING: at net/mac80211/scan.c
Date: Mon, 26 Jul 2010 17:10:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261710.38000.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config can be found here: 
https://bugzilla.kernel.org/show_bug.cgi?id=15673

1.) suspend to ram very often does not work in 2.6.35-rc6 (but sometimes it does work!).
S2R very often results in a black screen with backlight on.
a dmesg of a successful S2R cycle can be found in above bug report.

this is a regression against 2.6.34.x that did survive tens of S2R cycles.

2.) Also I found this in dmesg:

[16150.615478] ------------[ cut here ]------------
[16150.615511] WARNING: at net/mac80211/scan.c:262 ieee80211_scan_completed+0x10c/0x190 [mac80211]()
[16150.615516] Hardware name: Aspire 1810T
[16150.615520] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput arc4 ecb snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel iwlagn iwlcore snd_hda_codec 
snd_hwdep mac80211 snd_seq snd_seq_device snd_pcm snd_timer cfg80211 snd iTCO_wdt iTCO_vendor_support uvcvideo soundcore rfkill pcspkr wmi videodev v4l1_compat serio_raw joydev snd_page_alloc i2c_i801 sha256_generic aes_i586 aes_generic cbc dm_crypt [last 
unloaded: scsi_wait_scan]
[16150.615593] Pid: 870, comm: iwlagn Tainted: G          I 2.6.35-rc6 #112
[16150.615598] Call Trace:
[16150.615614]  [<c0430e42>] warn_slowpath_common+0x72/0xa0
[16150.615631]  [<f9b06eac>] ? ieee80211_scan_completed+0x10c/0x190 [mac80211]
[16150.615648]  [<f9b06eac>] ? ieee80211_scan_completed+0x10c/0x190 [mac80211]
[16150.615657]  [<c0430e92>] warn_slowpath_null+0x22/0x30
[16150.615673]  [<f9b06eac>] ieee80211_scan_completed+0x10c/0x190 [mac80211]
[16150.615694]  [<f9bc3b44>] iwl_bg_scan_completed+0xd4/0x1b0 [iwlcore]
[16150.615704]  [<c0445fd3>] worker_thread+0xf3/0x1f0
[16150.615713]  [<c042c492>] ? finish_task_switch.clone.0+0x32/0xa0
[16150.615731]  [<f9bc3a70>] ? iwl_bg_scan_completed+0x0/0x1b0 [iwlcore]
[16150.615740]  [<c0449900>] ? autoremove_wake_function+0x0/0x40
[16150.615748]  [<c0445ee0>] ? worker_thread+0x0/0x1f0
[16150.615755]  [<c0449504>] kthread+0x74/0x80
[16150.615762]  [<c0449490>] ? kthread+0x0/0x80
[16150.615770]  [<c040347e>] kernel_thread_helper+0x6/0x10
[16150.615775] ---[ end trace a7919e7f17c0a727 ]---
[16150.615779] ------------[ cut here ]------------
[16150.615797] WARNING: at net/mac80211/scan.c:265 ieee80211_scan_completed+0x181/0x190 [mac80211]()
[16150.615802] Hardware name: Aspire 1810T
[16150.615805] Modules linked in: tcp_lp fuse cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_intel kvm uinput arc4 ecb snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel iwlagn iwlcore snd_hda_codec 
snd_hwdep mac80211 snd_seq snd_seq_device snd_pcm snd_timer cfg80211 snd iTCO_wdt iTCO_vendor_support uvcvideo soundcore rfkill pcspkr wmi videodev v4l1_compat serio_raw joydev snd_page_alloc i2c_i801 sha256_generic aes_i586 aes_generic cbc dm_crypt [last 
unloaded: scsi_wait_scan]
[16150.615871] Pid: 870, comm: iwlagn Tainted: G        W I 2.6.35-rc6 #112
[16150.615875] Call Trace:
[16150.615884]  [<c0430e42>] warn_slowpath_common+0x72/0xa0
[16150.615901]  [<f9b06f21>] ? ieee80211_scan_completed+0x181/0x190 [mac80211]
[16150.615916]  [<f9b06f21>] ? ieee80211_scan_completed+0x181/0x190 [mac80211]
[16150.615925]  [<c0430e92>] warn_slowpath_null+0x22/0x30
[16150.615941]  [<f9b06f21>] ieee80211_scan_completed+0x181/0x190 [mac80211]
[16150.615959]  [<f9bc3b44>] iwl_bg_scan_completed+0xd4/0x1b0 [iwlcore]
[16150.615968]  [<c0445fd3>] worker_thread+0xf3/0x1f0
[16150.615976]  [<c042c492>] ? finish_task_switch.clone.0+0x32/0xa0
[16150.615995]  [<f9bc3a70>] ? iwl_bg_scan_completed+0x0/0x1b0 [iwlcore]
[16150.616003]  [<c0449900>] ? autoremove_wake_function+0x0/0x40
[16150.616011]  [<c0445ee0>] ? worker_thread+0x0/0x1f0
[16150.616018]  [<c0449504>] kthread+0x74/0x80
[16150.616024]  [<c0449490>] ? kthread+0x0/0x80
[16150.616031]  [<c040347e>] kernel_thread_helper+0x6/0x10
[16150.616037] ---[ end trace a7919e7f17c0a728 ]---
[17435.271312] npviewer.bin[3805]: segfault at b492e04c ip b6ffb057 sp bff1be60 error 4 in libflashplayer.so[b6c5c000+b04000]
