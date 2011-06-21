Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1FUMnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:43:23 -0400
Received: from que31.charter.net ([209.225.8.23]:55235 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab1FUMnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:43:21 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=p9YancsnzTcA:10 a=M2ucYd19FVAA:10 a=0xc6OLWX_2kA:10
 a=8nJEP1OIZ-IA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=BaxlDtvfJKhHEwORVX0A:9
 a=f2smfljXPhBpAo5iEnwA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E008DD0.2090809@gregd.org>
Date: Tue, 21 Jun 2011 07:25:52 -0500
From: Greg Dietsche <greg@gregd.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: 3.0 rc3 bug & warning fs/inode.c && fs/fs-writeback.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from the just missed rc4 department:
I recieved this BUG last night on my laptop and it was shortly followed 
by a warning from the kernel. I doubt that I can reproduce this. It 
happened under a light load. I was doing some emailing using thunderbird 
(er.... icedove.....). let me know if there's anything I can do to help 
debug or if there's more info I can get that would help you figure out 
what went wrong.

Thanks,
Greg


Kernel failure message 1:
------------[ cut here ]------------
kernel BUG at fs/inode.c:1368!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: aes_x86_64 aes_generic cpufreq_stats 
cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf 
cpufreq_conservative binfmt_misc uinput usbhid hid fuse btusb bluetooth 
loop firewire_sbp2 joydev snd_hda_codec_idt arc4 snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm dell_wmi sparse_keymap snd_seq snd_timer 
snd_seq_device iwl4965 iwl_legacy uvcvideo dell_laptop dcdbas videodev 
v4l2_compat_ioctl32 tpm_tis tpm tpm_bios mac80211 cfg80211 psmouse 
i2c_i801 pcspkr snd serio_raw wmi i2c_core rfkill evdev ac battery video 
button soundcore snd_page_alloc processor sg sr_mod cdrom sd_mod 
crc_t10dif ata_generic uhci_hcd ahci libahci ata_piix libata thermal 
thermal_sys firewire_ohci ehci_hcd tg3 sdhci_pci sdhci mmc_core 
firewire_core crc_itu_t libphy scsi_mod usbcore [last unloaded: 
scsi_wait_scan]

Pid: 3697, comm: rm Not tainted 3.0.0-rc3greg-laptop #3 Dell Inc. 
Inspiron 1420                   /0JX269
RIP: 0010:[<ffffffff810bd865>]  [<ffffffff810bd865>] iput+0x16/0x148
RSP: 0018:ffff880037cb9e88  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88008e90b698 RCX: 0000000000000025
RDX: 000000010062d640 RSI: ffffffff8110eeb3 RDI: ffff88008e90b698
RBP: ffff88010cb3c780 R08: ffffffff814143e0 R09: ffff88011ab19480
R10: ffff88011ab19480 R11: ffffffff814143e0 R12: ffff88008e90b698
R13: 0000000000000001 R14: ffff88008e8d2780 R15: ffff88011a3390d0
FS:  00007f0474e3a700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f047499a060 CR3: 0000000037d8f000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 3697, threadinfo ffff880037cb8000, task ffff88009b5434e0)
Stack:
  ffff88008e8d2780 ffff88010cb3c780 ffff88008e90b698 ffffffff810bb184
  ffff8800d3399240 ffff88008e8d2780 ffff88008e8d27dc ffff88008e90b698
  ffff88008e90b698 ffffffff810bb8bb 0000000040000010 ffff88011a3390c0
Call Trace:
  [<ffffffff810bb184>] ? dentry_kill+0x12e/0x149
  [<ffffffff810bb8bb>] ? dput+0xd9/0xe6
  [<ffffffff810ac0c6>] ? fput+0x1c4/0x1eb
  [<ffffffff810a94d5>] ? filp_close+0x64/0x6c
  [<ffffffff810a956e>] ? sys_close+0x91/0xc4
  [<ffffffff812d207b>] ? system_call_fastpath+0x16/0x1b
Code: c7 70 d8 62 81 e8 ee f9 f8 ff 48 83 c4 18 5b 5d 41 5c 41 5d c3 41 
54 48 85 ff 55 53 48 89 fb 0f 84 33 01 00 00 f6 47 28 40 74 04 <0f> 0b 
eb fe 48 8d 77 20 48 8d bf b8 00 00 00 e8 ff 15 0a 00 85
RIP  [<ffffffff810bd865>] iput+0x16/0x148
  RSP <ffff880037cb9e88>
---[ end trace c02e3e4da21ea82e ]---


...a short while later...


Kernel failure message 1:
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:356 writeback_single_inode+0x65/0x1a7()
Hardware name: Inspiron 1420
Modules linked in: aes_x86_64 aes_generic cpufreq_stats 
cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf 
cpufreq_conservative binfmt_misc uinput usbhid hid fuse btusb bluetooth 
loop firewire_sbp2 joydev snd_hda_codec_idt arc4 snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm dell_wmi sparse_keymap snd_seq snd_timer 
snd_seq_device iwl4965 iwl_legacy uvcvideo dell_laptop dcdbas videodev 
v4l2_compat_ioctl32 tpm_tis tpm tpm_bios mac80211 cfg80211 psmouse 
i2c_i801 pcspkr snd serio_raw wmi i2c_core rfkill evdev ac battery video 
button soundcore snd_page_alloc processor sg sr_mod cdrom sd_mod 
crc_t10dif ata_generic uhci_hcd ahci libahci ata_piix libata thermal 
thermal_sys firewire_ohci ehci_hcd tg3 sdhci_pci sdhci mmc_core 
firewire_core crc_itu_t libphy scsi_mod usbcore [last unloaded: 
scsi_wait_scan]
Pid: 3250, comm: flush-8:0 Tainted: G      D     3.0.0-rc3greg-laptop #3
Call Trace:
  [<ffffffff81033c84>] ? warn_slowpath_common+0x78/0x8c
  [<ffffffff810c575b>] ? writeback_single_inode+0x65/0x1a7
  [<ffffffff810c5cf8>] ? writeback_sb_inodes+0xc0/0x137
  [<ffffffff810c6276>] ? writeback_inodes_wb+0xfa/0x10c
  [<ffffffff810c6453>] ? wb_writeback+0x1cb/0x259
  [<ffffffff810c6612>] ? wb_do_writeback+0x131/0x1c0
  [<ffffffff810c6731>] ? bdi_writeback_thread+0x90/0x16b
  [<ffffffff810c66a1>] ? wb_do_writeback+0x1c0/0x1c0
  [<ffffffff810c66a1>] ? wb_do_writeback+0x1c0/0x1c0
  [<ffffffff81049850>] ? kthread+0x7a/0x82
  [<ffffffff812d2d14>] ? kernel_thread_helper+0x4/0x10
  [<ffffffff810497d6>] ? kthread_worker_fn+0x139/0x139
  [<ffffffff812d2d10>] ? gs_change+0xb/0xb
---[ end trace c02e3e4da21ea82f ]---


Kernel failure message 2:
------------[ cut here ]------------
kernel BUG at fs/inode.c:1368!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: aes_x86_64 aes_generic cpufreq_stats 
cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf 
cpufreq_conservative binfmt_misc uinput usbhid hid fuse btusb bluetooth 
loop firewire_sbp2 joydev snd_hda_codec_idt arc4 snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm dell_wmi sparse_keymap snd_seq snd_timer 
snd_seq_device iwl4965 iwl_legacy uvcvideo dell_laptop dcdbas videodev 
v4l2_compat_ioctl32 tpm_tis tpm tpm_bios mac80211 cfg80211 psmouse 
i2c_i801 pcspkr snd serio_raw wmi i2c_core rfkill evdev ac battery video 
button soundcore snd_page_alloc processor sg sr_mod cdrom sd_mod 
crc_t10dif ata_generic uhci_hcd ahci libahci ata_piix libata thermal 
thermal_sys firewire_ohci ehci_hcd tg3 sdhci_pci sdhci mmc_core 
firewire_core crc_itu_t libphy scsi_mod usbcore [last unloaded: 
scsi_wait_scan]

Pid: 3697, comm: rm Not tainted 3.0.0-rc3greg-laptop #3 Dell Inc. 
Inspiron 1420                   /0JX269
RIP: 0010:[<ffffffff810bd865>]  [<ffffffff810bd865>] iput+0x16/0x148
RSP: 0018:ffff880037cb9e88  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88008e90b698 RCX: 0000000000000025
RDX: 000000010062d640 RSI: ffffffff8110eeb3 RDI: ffff88008e90b698
RBP: ffff88010cb3c780 R08: ffffffff814143e0 R09: ffff88011ab19480
R10: ffff88011ab19480 R11: ffffffff814143e0 R12: ffff88008e90b698
R13: 0000000000000001 R14: ffff88008e8d2780 R15: ffff88011a3390d0
FS:  00007f0474e3a700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f047499a060 CR3: 0000000037d8f000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 3697, threadinfo ffff880037cb8000, task ffff88009b5434e0)
Stack:
  ffff88008e8d2780 ffff88010cb3c780 ffff88008e90b698 ffffffff810bb184
  ffff8800d3399240 ffff88008e8d2780 ffff88008e8d27dc ffff88008e90b698
  ffff88008e90b698 ffffffff810bb8bb 0000000040000010 ffff88011a3390c0
Call Trace:
  [<ffffffff810bb184>] ? dentry_kill+0x12e/0x149
  [<ffffffff810bb8bb>] ? dput+0xd9/0xe6
  [<ffffffff810ac0c6>] ? fput+0x1c4/0x1eb
  [<ffffffff810a94d5>] ? filp_close+0x64/0x6c
  [<ffffffff810a956e>] ? sys_close+0x91/0xc4
  [<ffffffff812d207b>] ? system_call_fastpath+0x16/0x1b
Code: c7 70 d8 62 81 e8 ee f9 f8 ff 48 83 c4 18 5b 5d 41 5c 41 5d c3 41 
54 48 85 ff 55 53 48 89 fb 0f 84 33 01 00 00 f6 47 28 40 74 04 <0f> 0b 
eb fe 48 8d 77 20 48 8d bf b8 00 00 00 e8 ff 15 0a 00 85
RIP  [<ffffffff810bd865>] iput+0x16/0x148
  RSP <ffff880037cb9e88>
---[ end trace c02e3e4da21ea82e ]---


