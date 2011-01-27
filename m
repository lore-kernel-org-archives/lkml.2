Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1A0M5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:57:43 -0500
Received: from nm26-vm1.bullet.mail.ac4.yahoo.com ([98.139.52.243]:40486 "HELO
	nm26-vm1.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752243Ab1A0M5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:57:40 -0500
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 07:57:40 EST
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 624553.46540.bm@omp1052.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=rr+wjGnquo6C9q3SlZbgYIG0Kj9GCWFLoyYGqfDMLbWQnvbxXoRjgpnoJP6L0OG6FAsx6bfyW5Q9yujWmO0P8qrmIjhS5IndGT39zPScP1X7QnYDq1bknNPkOb43iESiXwJEf96Z5vSP5scxPnpYfd4CBDaSMVWg2M1MeEbH/fA=;
Message-ID: <513567.89196.qm@web55903.mail.re3.yahoo.com>
X-YMail-OSG: Uqj0j.kVM1lHPCn6Czw8vzhCru9cWp8lpmJOvw72Cu6aYKO
 2Wvlv2icX9kmVeOYe8ZBgpEear0L0ia2oxX7m66Py6xwUZRhjijdH6EBTHY3
 JeoQjI3rH7xDZ9igNMOPW2pAFzYRcKIXuNhFfkLoLRs2mSNrAGdX.kQbyx6Z
 LIgKJ8GkvjTp.4DVbpdbY7KtBCLx0Xf1w8MzegLKKRVUnPs8Ly3DBdIGaOwi
 S.EfZtLJMEE8_w_cVOBcN.iPJD0RLyCdlj1Z5XFkSLAk2rPu3ng8nX71vI3i
 KCixIyneJiJHBwIloDDNCGAf.Y2wJZb.VO_5xgUGrcYM2vU1Xanf8suIW2WT
 u5YZkKFam.DpbO6S4cvLvqmF_ZZaDDFL8PYv8.a5OBVR5t09T3h7sC82TPlI
 oCaag9aisqOU-
X-Mailer: YahooMailRC/555 YahooMailWebService/0.8.107.285259
Date: Thu, 27 Jan 2011 04:51:10 -0800 (PST)
From: Eugene Markow <ejmarkow@yahoo.com>
Subject: Syslog-NG Fails as of Kernel 2.6.38-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following appears in dmesg from kernels 2.6.38-rc1 to 2.6.38-rc2-git5 (Not 
an issue in 2.6.37 stable):

----------
WARNING: at kernel/printk.c:430 do_syslog+0xeb/0x5e0()
Hardware name: Compaq Presario CQ50 Notebook PC
Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated and 
denied).
Modules linked in: ntfs arc4 ecb joydev snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device asix usbnet snd_hda_codec_hdmi snd_hda_codec_conexant snd_pcm_oss 
snd_mixer_oss snd_hda_intel ath5k ath snd_hda_codec mac80211 snd_hwdep hp_wmi 
sparse_keymap snd_pcm cfg80211 snd_timer coretemp snd soundcore uhci_hcd 
ehci_hcd psmouse snd_page_alloc rfkill fuse battery r8169 wmi usbcore evdev 
processor sg iTCO_wdt mii thermal iTCO_vendor_support serio_raw ac pcspkr 
i2c_i801 i915 drm_kms_helper drm i2c_algo_bit button i2c_core video intel_agp 
intel_gtt rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom 
ahci libahci libata scsi_mod
Pid: 2753, comm: syslog-ng Tainted: G        W   2.6.38-rc2-git5-ARCHMOD #1
Call Trace:
 [<ffffffff8103c6eb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8116ef10>] ? kmsg_release+0x0/0x20
 [<ffffffff8103c7e5>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff8103d95b>] ? do_syslog+0xeb/0x5e0
 [<ffffffff8111825c>] ? do_lookup+0xdc/0x2c0
 [<ffffffff8116ef10>] ? kmsg_release+0x0/0x20
 [<ffffffff8116ef30>] ? kmsg_open+0x0/0x20
 [<ffffffff811639cd>] ? proc_reg_open+0xad/0x1e0
 [<ffffffff81163920>] ? proc_reg_open+0x0/0x1e0
 [<ffffffff811097c5>] ? __dentry_open+0x115/0x370
 [<ffffffff8111555c>] ? path_get+0xc/0x40
 [<ffffffff81119bd0>] ? finish_open+0xe0/0x1a0
 [<ffffffff81119391>] ? do_path_lookup+0x81/0x160
 [<ffffffff8111a2f1>] ? do_filp_open+0x271/0x790
 [<ffffffff81124c8d>] ? __destroy_inode+0x1d/0x90
 [<ffffffff8110f9e0>] ? cp_new_stat+0xe0/0x100
 [<ffffffff81127466>] ? alloc_fd+0x46/0x150
 [<ffffffff8110aa84>] ? do_sys_open+0x64/0x110
 [<ffffffff81002d8f>] ? system_call_fastpath+0x16/0x1b
---[ end trace a7919e7f17c0a727 ]---
----------

Furthermore, during the bootup process, I'm getting:


----------
::Starting Syslg-NG            [BUSY]
Error opening file for reading: filename '/proc/kmsg', error='Operation not 
permitted (1)'
Error initializing source driver: source='src', id='src#2'
Error initializing message pipline;
                    [FAIL]
----------

System info:

Linux Galicja 2.6.38-rc2-git5-ARCHMOD #1 PREEMPT Wed Jan 26 21:45:43 CET 2011 
x86_64 Genuine Intel(R) CPU 575 @ 2.00GHz GenuineIntel GNU/Linux
 
Gnu C                     4.5.2
Gnu make               3.81
binutils                    2.21.0.20101217
util-linux                  2.18
mount                     support
module-init-tools      3.12
e2fsprogs                1.41.14
jfsutils                    1.1.14
reiserfsprogs           3.6.21
xfsprogs                 3.1.4
pcmciautils             017
PPP                       2.4.5
Linux C Library        2.12.2
Dynamic linker (ldd) 2.12.2
Linux C++ Library    6.0.14
Procps                    3.2.8
Net-tools                 1.60
Kbd                        1.15.2
Sh-utils                   8.9
wireless-tools          29
Modules Loaded         ipv6 xt_HL iptable_mangle ipt_REJECT ipt_LOG xt_limit 
xt_tcpudp xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables ntfs 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 joydev 
snd_hda_codec_hdmi ecb asix usbnet snd_hda_codec_conexant snd_pcm_oss 
snd_mixer_oss ath5k snd_hda_intel ath snd_hda_codec snd_hwdep mac80211 snd_pcm 
snd_timer cfg80211 snd hp_wmi soundcore sparse_keymap uhci_hcd ehci_hcd 
snd_page_alloc coretemp iTCO_wdt battery fuse wmi processor thermal ac rfkill 
psmouse usbcore iTCO_vendor_support sg r8169 mii evdev pcspkr i2c_i801 serio_raw 
i915 drm_kms_helper drm i2c_algo_bit button i2c_core video intel_agp intel_gtt 
rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sr_mod sd_mod cdrom ahci 
libahci libata scsi_mod


I wish to be personally CC'ed the answers/comments posted to the list in 
response to my posting.

Thanks,

Eugene Markow


      
