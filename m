Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2AXP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:59:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40815 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab2AXP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:59:36 -0500
MIME-Version: 1.0
Date: Tue, 24 Jan 2012 16:59:35 +0100
Message-ID: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
Subject: kernel 3.2.1: BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just in case someone is interested, I've been hit by this:

[  236.734640] BUG: scheduling while atomic: swapper/0/0/0x10000100
[  236.734645] Modules linked in: nfsd nfs lockd fscache auth_rpcgss
nfs_acl sunrpc fuse af_packet ipv6 snd_hda_codec_hdmi arc4
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep brcmsmac
mac80211 brcmutil r8169 dell_laptop snd_seq_dummy cfg80211 uas rfkill
pl2303 snd_seq_oss snd_seq_midi_event snd_seq ums_realtek mii
usbserial usb_storage sr_mod crc8 cordic iTCO_wdt iTCO_vendor_support
snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd
soundcore snd_page_alloc intel_ips i2c_i801 dcdbas sg mei(C) i915
drm_kms_helper drm i2c_algo_bit i2c_core coretemp binfmt_misc
cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq
freq_table mperf nvram joydev evdev dell_wmi sparse_keymap wmi dm_mod
video battery kvm_intel kvm ata_piix ahci libahci libata sd_mod
scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid
hid usbcore usb_common
[  236.734753] CPU 0
[  236.734755] Modules linked in: nfsd nfs lockd fscache auth_rpcgss
nfs_acl sunrpc fuse af_packet ipv6 snd_hda_codec_hdmi arc4
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep brcmsmac
mac80211 brcmutil r8169 dell_laptop snd_seq_dummy cfg80211 uas rfkill
pl2303 snd_seq_oss snd_seq_midi_event snd_seq ums_realtek mii
usbserial usb_storage sr_mod crc8 cordic iTCO_wdt iTCO_vendor_support
snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd
soundcore snd_page_alloc intel_ips i2c_i801 dcdbas sg mei(C) i915
drm_kms_helper drm i2c_algo_bit i2c_core coretemp binfmt_misc
cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq
freq_table mperf nvram joydev evdev dell_wmi sparse_keymap wmi dm_mod
video battery kvm_intel kvm ata_piix ahci libahci libata sd_mod
scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid
hid usbcore usb_common
[  236.734836]
[  236.734841] Pid: 0, comm: swapper/0 Tainted: G         C   3.2.1 #1
Dell Inc. Vostro 3500/
[  236.734848] RIP: 0010:[<ffffffff8129e4c0>]  [<ffffffff8129e4c0>]
intel_idle+0xe0/0x150
[  236.734861] RSP: 0018:ffffffff81a01e48  EFLAGS: 00000206
[  236.734864] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  236.734868] RDX: 0000000000000fd7 RSI: 0000000000000000 RDI: 00000000003de058
[  236.734871] RBP: ffffffff81a01ea8 R08: 00000000fffffffd R09: 00000000000011a5
[  236.734875] R10: 00000037321ce712 R11: 0000000000000000 R12: ffff880137c0e800
[  236.734878] R13: ffffffff81a01dd8 R14: ffffffff81099b24 R15: ffffffff81a01dc8
[  236.734883] FS:  0000000000000000(0000) GS:ffff880137c00000(0000)
knlGS:0000000000000000
[  236.734887] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  236.734890] CR2: 00007fb66bb1d000 CR3: 0000000001a05000 CR4: 00000000000006f0
[  236.734894] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  236.734897] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  236.734901] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000,
task ffffffff81a0d020)
[  236.734905] Stack:
[  236.734908]  0000000000000000 0000000000000fd7 0000000000000000
0000000000000fd7
[  236.734914]  0000000000000000 00000000003d5af1 ffffffff81a01e88
ffff880137c1a470
[  236.734920]  ffffffff81a59340 0000000000000000 0000000000000003
0000000000000000
[  236.734926] Call Trace:
[  236.734934]  [<ffffffff8136e848>] cpuidle_idle_call+0xd8/0x1b0
[  236.734942]  [<ffffffff8101302b>] cpu_idle+0xcb/0x120
[  236.734950]  [<ffffffff814412b2>] rest_init+0x72/0x80
[  236.734958]  [<ffffffff81ac7cd9>] start_kernel+0x3c5/0x3d0
[  236.734963]  [<ffffffff81ac7346>] x86_64_start_reservations+0x131/0x135
[  236.734969]  [<ffffffff81ac744d>] x86_64_start_kernel+0x103/0x112
[  236.734972] Code: c9 e8 c5 5a df ff 4c 29 f8 48 89 c7 e8 ba f9 dc
ff 49 89 c6 49 89 d7 48 89 45 a0 48 89 55 a8 48 89 45 b0 48 89 55 b8
fb 66 66 90 <66> 66 90 85 1d b7 b7 7b 00 75 0e 48 8d 75 cc bf 05 00 00
00 e8
[  236.735021] Call Trace:
[  236.735026]  [<ffffffff8136e848>] cpuidle_idle_call+0xd8/0x1b0
[  236.735031]  [<ffffffff8101302b>] cpu_idle+0xcb/0x120
[  236.735036]  [<ffffffff814412b2>] rest_init+0x72/0x80
[  236.735041]  [<ffffffff81ac7cd9>] start_kernel+0x3c5/0x3d0
[  236.735046]  [<ffffffff81ac7346>] x86_64_start_reservations+0x131/0x135
[  236.735051]  [<ffffffff81ac744d>] x86_64_start_kernel+0x103/0x112


-- 
Francis
