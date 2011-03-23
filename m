Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CWRd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:33:59 -0400
Received: from kramwerk.de ([62.75.162.77]:37170 "EHLO mail.kramwerk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1CWRd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:33:56 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Mar 2011 13:33:55 EDT
X-No-Relay: not in my network
From: Florian Kriener <florian@kriener.org>
To: linux-kernel@vger.kernel.org
Subject: BUG: NULL pointer dereference a minute or so after resume from hibernationg
Date: Wed, 23 Mar 2011 18:26:43 +0100
User-Agent: KMail
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231826.43784.florian@kriener.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    

A minute of so after resuming from hibernation my notebook
entered Oops state.

[2.] Full description of the problem/report:

I was not infront the computer when it happend and the computer didn't
do very much. Only routine jobs. I later found out that the rsyslog
log files must have been rotated rotated and that updatedb.mlocate
was running (but see below).

[3.] Keywords (i.e., modules, networking, kernel):

dcache_readdir, hibernation

[4.] Kernel version (from /proc/version):

Linux version 2.6.38-1-amd64 (Debian 2.6.38-1) (ben@decadent.org.uk) (gcc version 4.4.5 (Debian 
4.4.5-14) ) #1 SMP Wed Mar 16 17:38:02 UTC 2011

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

Mar 23 10:50:00 nanuk rsyslogd: [origin software="rsyslogd" swVersion="5.7.8" x-pid="1225" x-
info="http://www.rsyslog.com"] rsyslogd was HUPed
Mar 23 10:50:00 nanuk kernel: [11422.925003] BUG: unable to handle kernel NULL pointer dereference 
at 0000000000000008
Mar 23 10:50:00 nanuk kernel: [11422.925045] IP: [<ffffffff8110d673>] dcache_readdir+0x1c7/0x211
Mar 23 10:50:00 nanuk kernel: [11422.925076] PGD 13301e067 PUD 133314067 PMD 0 
Mar 23 10:50:00 nanuk kernel: [11422.925104] Oops: 0002 [#1] SMP 
Mar 23 10:50:00 nanuk kernel: [11422.925125] last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/ACPI0003:00/power_supply/AC/online
Mar 23 10:50:00 nanuk kernel: [11422.925176] CPU 1 
Mar 23 10:50:00 nanuk kernel: [11422.925188] Modules linked in: btusb binfmt_misc rfcomm sco bnep 
l2cap bluetooth acpi_cpufreq mperf vboxnetadp(O) cpufreq_conservative cpufreq_userspace 
vboxnetflt(O) cpufreq_powersave cpufreq_stats vboxdrv(O) microcode parport_pc ppdev lp parport 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_LOG ip6table_filter ip6_tables ipt_REJECT 
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_LOG ipt_addrtype iptable_filter ip_tables 
x_tables zaurus ext2 snd_hda_codec_conexant arc4 ecb cdc_ether uvcvideo snd_hda_intel usbnet 
thinkpad_acpi mii videodev cdc_wdm v4l2_compat_ioctl32 cdc_acm joydev snd_hda_codec iwlagn 
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device psmouse iwlcore serio_raw mac80211 snd cfg80211 
battery i2c_i801 tpm_tis nvram soundcore ac snd_page_alloc rfkill tpm tpm_bios power_supply wmi 
evdev processor nf_conntrack_netbios_ns nf_conntrack_ftp nf_conntrack loop autofs4 ext4 mbcache 
jbd2 crc16 sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod btrf
Mar 23 10:50:00 nanuk kernel: s zlib_deflate crc32c libcrc32c sg sr_mod cdrom sd_mod crc_t10dif 
usbhid hid uhci_hcd i915 drm_kms_helper drm i2c_algo_bit ahci libahci sdhci_pci libata ehci_hcd 
sdhci scsi_mod usbcore e1000e mmc_core i2c_core thermal video thermal_sys button nls_base [last 
unloaded: scsi_wait_scan]
Mar 23 10:50:00 nanuk kernel: [11422.925969] 
Mar 23 10:50:00 nanuk kernel: [11422.925979] Pid: 6445, comm: updatedb.mlocat Tainted: G           
O 2.6.38-1-amd64 #1 LENOVO 2808D9G/2808D9G
Mar 23 10:50:00 nanuk kernel: [11422.926029] RIP: 0010:[<ffffffff8110d673>]  [<ffffffff8110d673>] 
dcache_readdir+0x1c7/0x211
Mar 23 10:50:00 nanuk kernel: [11422.926064] RSP: 0018:ffff88013bd6be88  EFLAGS: 00010246
Mar 23 10:50:00 nanuk kernel: [11422.926088] RAX: 0000000000000000 RBX: ffff880137b16180 RCX: 
ffff880137b161b8
Mar 23 10:50:00 nanuk kernel: [11422.926117] RDX: ffff880137b16210 RSI: ffff880137b161bb RDI: 
ffff880137b161dc
Mar 23 10:50:00 nanuk kernel: [11422.926145] RBP: ffff880137b16540 R08: 0000000000000b1e R09: 
0000000000000002
Mar 23 10:50:00 nanuk kernel: [11422.926173] R10: 0000000001594350 R11: 0000000000000246 R12: 
ffff8800ac017180
Mar 23 10:50:00 nanuk kernel: [11422.926201] R13: ffff88007831c3c0 R14: ffff880137b16210 R15: 
ffff88007831c450
Mar 23 10:50:00 nanuk kernel: [11422.926229] FS:  00007f563a46b700(0000) GS:ffff8800bd280000(0000) 
knlGS:0000000000000000
Mar 23 10:50:00 nanuk kernel: [11422.926265] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 23 10:50:00 nanuk kernel: [11422.926288] CR2: 0000000000000008 CR3: 00000001309bd000 CR4: 
00000000000406e0
Mar 23 10:50:00 nanuk kernel: [11422.926316] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Mar 23 10:50:00 nanuk kernel: [11422.926344] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
Mar 23 10:50:00 nanuk kernel: [11422.926372] Process updatedb.mlocat (pid: 6445, threadinfo 
ffff88013bd6a000, task ffff880134ef8d80)
Mar 23 10:50:00 nanuk kernel: [11422.926407] Stack:
Mar 23 10:50:00 nanuk kernel: [11422.926418]  ffff88013bd6bf38 ffffffff81100a70 ffff880137b1659c 
ffff880137b161dc
Mar 23 10:50:00 nanuk kernel: [11422.926459]  ffff880137b1659c ffff880137b165e0 ffff8800ac017190 
ffff8800ac017180
Mar 23 10:50:00 nanuk kernel: [11422.926500]  ffff880132805418 ffff88013bd6bf38 ffffffff81100a70 
ffff8801328053f0
Mar 23 10:50:00 nanuk kernel: [11422.926540] Call Trace:
Mar 23 10:50:00 nanuk kernel: [11422.926554]  [<ffffffff81100a70>] ? filldir+0x0/0xc3
Mar 23 10:50:00 nanuk kernel: [11422.926578]  [<ffffffff81100a70>] ? filldir+0x0/0xc3
Mar 23 10:50:00 nanuk kernel: [11422.926601]  [<ffffffff81100b9a>] ? vfs_readdir+0x67/0xa4
Mar 23 10:50:00 nanuk kernel: [11422.926624]  [<ffffffff81100d13>] ? sys_getdents+0x7d/0xcd
Mar 23 10:50:00 nanuk kernel: [11422.926650]  [<ffffffff81009952>] ? 
system_call_fastpath+0x16/0x1b
Mar 23 10:50:00 nanuk kernel: [11422.926676] Code: 8b 7c 24 20 e8 2b 51 21 00 48 8b 7c 24 18 e8 21 
51 21 00 49 8b 85 98 00 00 00 49 8b 95 90 00 00 00 48 89 42 08 48 89 10 49 8b 06 <4c> 89 78 08 49 
89 85 90 00 00 00 4d 89 b5 98 00 00 00 4d 89 3e 
Mar 23 10:50:00 nanuk kernel: [11422.926915] RIP  [<ffffffff8110d673>] dcache_readdir+0x1c7/0x211
Mar 23 10:50:00 nanuk kernel: [11422.926945]  RSP <ffff88013bd6be88>
Mar 23 10:50:00 nanuk kernel: [11422.926959] CR2: 0000000000000008
Mar 23 10:50:00 nanuk kernel: [11423.050380] ---[ end trace 954ed6519c57eb2c ]---
Mar 23 10:51:19 nanuk kernel: [11501.524428] BUG: soft lockup - CPU#1 stuck for 67s! 
[updatedb.mlocat:6445]
Mar 23 10:51:19 nanuk kernel: [11501.524431] Modules linked in: btusb binfmt_misc rfcomm sco bnep 
l2cap bluetooth acpi_cpufreq mperf vboxnetadp(O) cpufreq_conservative cpufreq_userspace 
vboxnetflt(O) cpufreq_powersave cpufreq_stats vboxdrv(O) microcode parport_pc ppdev lp parport 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_LOG ip6table_filter ip6_tables ipt_REJECT 
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_LOG ipt_addrtype iptable_filter ip_tables 
x_tables zaurus ext2 snd_hda_codec_conexant arc4 ecb cdc_ether uvcvideo snd_hda_intel usbnet 
thinkpad_acpi mii videodev cdc_wdm v4l2_compat_ioctl32 cdc_acm joydev snd_hda_codec iwlagn 
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device psmouse iwlcore serio_raw mac80211 snd cfg80211 
battery i2c_i801 tpm_tis nvram soundcore ac snd_page_alloc rfkill tpm tpm_bios power_supply wmi 
evdev processor nf_conntrack_netbios_ns nf_conntrack_ftp nf_conntrack loop autofs4 ext4 mbcache 
jbd2 crc16 sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod btrf
Mar 23 10:51:19 nanuk kernel: s zlib_deflate crc32c libcrc32c sg sr_mod cdrom sd_mod crc_t10dif 
usbhid hid uhci_hcd i915 drm_kms_helper drm i2c_algo_bit ahci libahci sdhci_pci libata ehci_hcd 
sdhci scsi_mod usbcore e1000e mmc_core i2c_core thermal video thermal_sys button nls_base [last 
unloaded: scsi_wait_scan]
Mar 23 10:51:19 nanuk kernel: [11501.524515] CPU 1 
Mar 23 10:51:19 nanuk kernel: [11501.524517] Modules linked in: btusb binfmt_misc rfcomm sco bnep 
l2cap bluetooth acpi_cpufreq mperf vboxnetadp(O) cpufreq_conservative cpufreq_userspace 
vboxnetflt(O) cpufreq_powersave cpufreq_stats vboxdrv(O) microcode parport_pc ppdev lp parport 
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_LOG ip6table_filter ip6_tables ipt_REJECT 
xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_LOG ipt_addrtype iptable_filter ip_tables 
x_tables zaurus ext2 snd_hda_codec_conexant arc4 ecb cdc_ether uvcvideo snd_hda_intel usbnet 
thinkpad_acpi mii videodev cdc_wdm v4l2_compat_ioctl32 cdc_acm joydev snd_hda_codec iwlagn 
snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device psmouse iwlcore serio_raw mac80211 snd cfg80211 
battery i2c_i801 tpm_tis nvram soundcore ac snd_page_alloc rfkill tpm tpm_bios power_supply wmi 
evdev processor nf_conntrack_netbios_ns nf_conntrack_ftp nf_conntrack loop autofs4 ext4 mbcache 
jbd2 crc16 sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod btrf
Mar 23 10:51:19 nanuk kernel: s zlib_deflate crc32c libcrc32c sg sr_mod cdrom sd_mod crc_t10dif 
usbhid hid uhci_hcd i915 drm_kms_helper drm i2c_algo_bit ahci libahci sdhci_pci libata ehci_hcd 
sdhci scsi_mod usbcore e1000e mmc_core i2c_core thermal video thermal_sys button nls_base [last 
unloaded: scsi_wait_scan]
Mar 23 10:51:19 nanuk kernel: [11501.524579] 
Mar 23 10:51:19 nanuk kernel: [11501.524581] Pid: 6445, comm: updatedb.mlocat Tainted: G      D    
O 2.6.38-1-amd64 #1 LENOVO 2808D9G/2808D9G
Mar 23 10:51:19 nanuk kernel: [11501.524586] RIP: 0010:[<ffffffff8132278b>]  [<ffffffff8132278b>] 
_raw_spin_lock+0xf/0x1b
Mar 23 10:51:19 nanuk kernel: [11501.524592] RSP: 0018:ffff88013bd6bbb0  EFLAGS: 00000297
Mar 23 10:51:19 nanuk kernel: [11501.524594] RAX: 000000000000009f RBX: ffffffff810f4bec RCX: 
ffff8801344ec838
Mar 23 10:51:19 nanuk kernel: [11501.524596] RDX: 000000000000009e RSI: 0000000000000007 RDI: 
ffff880137b1659c
Mar 23 10:51:19 nanuk kernel: [11501.524598] RBP: ffff880137b1659c R08: 0000000040000010 R09: 
00000000000000bf
Mar 23 10:51:19 nanuk kernel: [11501.524600] R10: 0000000000000009 R11: ffff880132efed70 R12: 
ffffffff8100a30e
Mar 23 10:51:19 nanuk kernel: [11501.524602] R13: 0000000040000010 R14: ffffffff8110436b R15: 
0000000040000010
Mar 23 10:51:19 nanuk kernel: [11501.524604] FS:  00007f563a46b700(0000) GS:ffff8800bd280000(0000) 
knlGS:0000000000000000
Mar 23 10:51:19 nanuk kernel: [11501.524607] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 23 10:51:19 nanuk kernel: [11501.524608] CR2: 00007f689b60e000 CR3: 00000000b4da9000 CR4: 
00000000000406e0
Mar 23 10:51:19 nanuk kernel: [11501.524610] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Mar 23 10:51:19 nanuk kernel: [11501.524613] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
Mar 23 10:51:19 nanuk kernel: [11501.524615] Process updatedb.mlocat (pid: 6445, threadinfo 
ffff88013bd6a000, task ffff880134ef8d80)
Mar 23 10:51:19 nanuk kernel: [11501.524617] Stack:
Mar 23 10:51:19 nanuk kernel: [11501.524618]  ffffffff8110436b 0000000000000009 ffff8800a5f3d8a8 
0000000000000009
Mar 23 10:51:19 nanuk kernel: [11501.524622]  ffffffff810fbc3d ffff8800a5f3d880 ffffffff81113e22 
ffff880134ef8d80
Mar 23 10:51:19 nanuk kernel: [11501.524625]  ffffffff8104a323 000000000000009c ffffffff810471c4 
ffff88013bd6bc18
Mar 23 10:51:19 nanuk kernel: [11501.524628] Call Trace:
Mar 23 10:51:19 nanuk kernel: [11501.524633]  [<ffffffff8110436b>] ? dput+0x29/0xe9
Mar 23 10:51:19 nanuk kernel: [11501.524636]  [<ffffffff810fbc3d>] ? path_put+0xd/0x16
Mar 23 10:51:19 nanuk kernel: [11501.524639]  [<ffffffff81113e22>] ? free_fs_struct+0x16/0x26
Mar 23 10:51:19 nanuk kernel: [11501.524643]  [<ffffffff8104a323>] ? do_exit+0x278/0x736
Mar 23 10:51:19 nanuk kernel: [11501.524645]  [<ffffffff810471c4>] ? kmsg_dump+0x41/0xe3
Mar 23 10:51:19 nanuk kernel: [11501.524648]  [<ffffffff81323933>] ? oops_end+0xb1/0xb6
Mar 23 10:51:19 nanuk kernel: [11501.524653]  [<ffffffff8102d803>] ? no_context+0x1f4/0x201
Mar 23 10:51:19 nanuk kernel: [11501.524655]  [<ffffffff8132596d>] ? do_page_fault+0x217/0x34c
Mar 23 10:51:19 nanuk kernel: [11501.524658]  [<ffffffff8110dfc7>] ? dcache_dir_open+0x0/0x26
Mar 23 10:51:19 nanuk kernel: [11501.524661]  [<ffffffff811033df>] ? d_alloc+0x15a/0x195
Mar 23 10:51:19 nanuk kernel: [11501.524663]  [<ffffffff8110dfdb>] ? dcache_dir_open+0x14/0x26
Mar 23 10:51:19 nanuk kernel: [11501.524666]  [<ffffffff810f2333>] ? __dentry_open+0x17f/0x271
Mar 23 10:51:19 nanuk kernel: [11501.524668]  [<ffffffff810fb4ef>] ? dget+0x12/0x1e
Mar 23 10:51:19 nanuk kernel: [11501.524671]  [<ffffffff8110436b>] ? dput+0x29/0xe9
Mar 23 10:51:19 nanuk kernel: [11501.524673]  [<ffffffff81322e15>] ? page_fault+0x25/0x30
Mar 23 10:51:19 nanuk kernel: [11501.524676]  [<ffffffff8110d673>] ? dcache_readdir+0x1c7/0x211
Mar 23 10:51:19 nanuk kernel: [11501.524678]  [<ffffffff8110d65b>] ? dcache_readdir+0x1af/0x211
Mar 23 10:51:19 nanuk kernel: [11501.524681]  [<ffffffff81100a70>] ? filldir+0x0/0xc3
Mar 23 10:51:19 nanuk kernel: [11501.524683]  [<ffffffff81100a70>] ? filldir+0x0/0xc3
Mar 23 10:51:19 nanuk kernel: [11501.524686]  [<ffffffff81100b9a>] ? vfs_readdir+0x67/0xa4
Mar 23 10:51:19 nanuk kernel: [11501.524688]  [<ffffffff81100d13>] ? sys_getdents+0x7d/0xcd
Mar 23 10:51:19 nanuk kernel: [11501.524691]  [<ffffffff81009952>] ? 
system_call_fastpath+0x16/0x1b
Mar 23 10:51:19 nanuk kernel: [11501.524693] Code: c2 8d 90 00 00 01 00 75 04 f0 0f b1 17 0f 94 c2 
0f b6 c2 85 c0 0f 95 c0 0f b6 c0 c3 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10 <39> c2 74 07 f3 
90 0f b7 17 eb f5 c3 9c 58 0f 1f 44 00 00 48 89 
Mar 23 10:51:19 nanuk kernel: [11501.524716] Call Trace:
Mar 23 10:51:19 nanuk kernel: [11501.524718]  [<ffffffff8110436b>] ? dput+0x29/0xe9
Mar 23 10:51:19 nanuk kernel: [11501.524721]  [<ffffffff810fbc3d>] ? path_put+0xd/0x16
Mar 23 10:51:19 nanuk kernel: [11501.524723]  [<ffffffff81113e22>] ? free_fs_struct+0x16/0x26
Mar 23 10:51:19 nanuk kernel: [11501.524726]  [<ffffffff8104a323>] ? do_exit+0x278/0x736
Mar 23 10:51:19 nanuk kernel: [11501.524728]  [<ffffffff810471c4>] ? kmsg_dump+0x41/0xe3
Mar 23 10:51:19 nanuk kernel: [11501.524730]  [<ffffffff81323933>] ? oops_end+0xb1/0xb6
Mar 23 10:51:19 nanuk kernel: [11501.524733]  [<ffffffff8102d803>] ? no_context+0x1f4/0x201
Mar 23 10:51:19 nanuk kernel: [11501.524736]  [<ffffffff8132596d>] ? do_page_fault+0x217/0x34c
Mar 23 10:51:19 nanuk kernel: [11501.524738]  [<ffffffff8110dfc7>] ? dcache_dir_open+0x0/0x26
Mar 23 10:51:19 nanuk kernel: [11501.524741]  [<ffffffff811033df>] ? d_alloc+0x15a/0x195
Mar 23 10:51:19 nanuk kernel: [11501.524743]  [<ffffffff8110dfdb>] ? dcache_dir_open+0x14/0x26
Mar 23 10:51:19 nanuk kernel: [11501.524746]  [<ffffffff810f2333>] ? __dentry_open+0x17f/0x271
Mar 23 10:51:19 nanuk kernel: [11501.524748]  [<ffffffff810fb4ef>] ? dget+0x12/0x1e
Mar 23 10:51:19 nanuk kernel: [11501.524750]  [<ffffffff8110436b>] ? dput+0x29/0xe9
Mar 23 10:51:19 nanuk kernel: [11501.524753]  [<ffffffff81322e15>] ? page_fault+0x25/0x30
Mar 23 10:51:19 nanuk kernel: [11501.524755]  [<ffffffff8110d673>] ? dcache_readdir+0x1c7/0x211
Mar 23 10:51:19 nanuk kernel: [11501.524758]  [<ffffffff8110d65b>] ? dcache_readdir+0x1af/0x211
Mar 23 10:51:19 nanuk kernel: [11501.524760]  [<ffffffff81100a70>] ? filldir+0x0/0xc3
Mar 23 10:51:19 nanuk kernel: [11501.524763]  [<ffffffff81100a70>] ? filldir+0x0/0xc3
Mar 23 10:51:19 nanuk kernel: [11501.524765]  [<ffffffff81100b9a>] ? vfs_readdir+0x67/0xa4
Mar 23 10:51:19 nanuk kernel: [11501.524768]  [<ffffffff81100d13>] ? sys_getdents+0x7d/0xcd
Mar 23 10:51:19 nanuk kernel: [11501.524770]  [<ffffffff81009952>] ? 
system_call_fastpath+0x16/0x1b


[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

Linux nanuk 2.6.38-1-amd64 #1 SMP Wed Mar 16 17:38:02 UTC 2011 x86_64 GNU/Linux
 
Gnu C                  4.5.2
Gnu make               3.81
binutils               2.21.0.20110302
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               8.5
wireless-tools         30
Modules Loaded         rfcomm sco bnep l2cap binfmt_misc bluetooth acpi_cpufreq mperf 
cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats vboxnetadp vboxnetflt 
vboxdrv parport_pc ppdev lp parport microcode ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
ip6t_LOG ip6table_filter ip6_tables ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
ipt_LOG ipt_addrtype iptable_filter ip_tables x_tables ext2 snd_hda_codec_conexant arc4 ecb 
snd_hda_intel iwlagn snd_hda_codec snd_hwdep zaurus cdc_ether usbnet mii thinkpad_acpi snd_pcm 
iwlcore joydev uvcvideo videodev v4l2_compat_ioctl32 cdc_acm cdc_wdm snd_seq snd_timer mac80211 
snd_seq_device cfg80211 psmouse i2c_i801 tpm_tis tpm tpm_bios snd rfkill wmi evdev serio_raw ac 
nvram battery power_supply soundcore snd_page_alloc processor nf_conntrack_netbios_ns 
nf_conntrack_ftp nf_conntrack loop autofs4 ext4 mbcache jbd2 crc16 sha256_generic cryptd 
aes_x86_64 aes_generic cbc usbhid hid dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c sg 
sr_mod sd_mod cdrom crc_t10dif i915 uhci_hcd drm_kms_helper drm i2c_algo_bit ahci libahci 
sdhci_pci sdhci libata e1000e scsi_mod mmc_core ehci_hcd usbcore i2c_core video thermal 
thermal_sys nls_base button


[7.2.] Processor information (from /proc/cpuinfo):

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     P9400  @ 2.40GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 6144 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush 
dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good 
nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave 
lahf_lm ida dts tpr_shadow vnmi flexpriority
bogomips        : 4788.83
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     P9400  @ 2.40GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 6144 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush 
dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good 
nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave 
lahf_lm ida dts tpr_shadow vnmi flexpriority
bogomips        : 4790.59
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

rfcomm 28424 0 - Live 0xffffffffa0758000
sco 7587 2 - Live 0xffffffffa0750000
bnep 9968 2 - Live 0xffffffffa0747000
l2cap 30891 6 rfcomm,bnep, Live 0xffffffffa0729000
binfmt_misc 6322 1 - Live 0xffffffffa0722000
bluetooth 46631 6 rfcomm,sco,bnep,l2cap, Live 0xffffffffa070c000
acpi_cpufreq 5193 1 - Live 0xffffffffa0546000
mperf 1251 1 acpi_cpufreq, Live 0xffffffffa051d000
cpufreq_conservative 7654 0 - Live 0xffffffffa0515000
cpufreq_userspace 2024 0 - Live 0xffffffffa04a3000
cpufreq_powersave 950 0 - Live 0xffffffffa049d000
cpufreq_stats 2641 0 - Live 0xffffffffa0494000
vboxnetadp 4967 0 - Live 0xffffffffa048b000 (O)
vboxnetflt 15923 0 - Live 0xffffffffa0481000 (O)
vboxdrv 1739634 2 vboxnetadp,vboxnetflt, Live 0xffffffffa0561000 (O)
parport_pc 18663 0 - Live 0xffffffffa0457000
ppdev 5037 0 - Live 0xffffffffa0450000
lp 7918 0 - Live 0xffffffffa0426000
parport 25186 3 parport_pc,ppdev,lp, Live 0xffffffffa0443000
microcode 21493 0 - Live 0xffffffffa041e000
ip6t_REJECT 2569 1 - Live 0xffffffffa03f8000
nf_conntrack_ipv6 5557 4 - Live 0xffffffffa03e2000
nf_defrag_ipv6 5733 1 nf_conntrack_ipv6, Live 0xffffffffa03db000
ip6t_LOG 6145 4 - Live 0xffffffffa03cb000
ip6table_filter 1340 1 - Live 0xffffffffa0399000
ip6_tables 15163 2 ip6t_LOG,ip6table_filter, Live 0xffffffffa0393000
ipt_REJECT 2033 1 - Live 0xffffffffa036b000
xt_tcpudp 2319 19 - Live 0xffffffffa030d000
nf_conntrack_ipv4 9817 4 - Live 0xffffffffa023f000
nf_defrag_ipv4 1267 1 nf_conntrack_ipv4, Live 0xffffffffa0235000
xt_state 1191 8 - Live 0xffffffffa022f000
ipt_LOG 6189 4 - Live 0xffffffffa0223000
ipt_addrtype 1801 3 - Live 0xffffffffa01f5000
iptable_filter 1384 1 - Live 0xffffffffa0135000
ip_tables 14082 1 iptable_filter, Live 0xffffffffa01e1000
x_tables 14127 11 
ip6t_REJECT,ip6t_LOG,ip6table_filter,ip6_tables,ipt_REJECT,xt_tcpudp,xt_state,ipt_LOG,ipt_addrtype,iptable_filter,ip_tables, 
Live 0xffffffffa0176000
ext2 52652 1 - Live 0xffffffffa0185000
snd_hda_codec_conexant 36280 1 - Live 0xffffffffa013f000
arc4 1338 2 - Live 0xffffffffa007d000
ecb 1889 2 - Live 0xffffffffa0046000
snd_hda_intel 19482 4 - Live 0xffffffffa0052000
iwlagn 135204 0 - Live 0xffffffffa051f000
snd_hda_codec 62079 2 snd_hda_codec_conexant,snd_hda_intel, Live 0xffffffffa054f000
snd_hwdep 5412 1 snd_hda_codec, Live 0xffffffffa03a8000
zaurus 2720 0 - Live 0xffffffffa03eb000
cdc_ether 3466 1 zaurus, Live 0xffffffffa039b000
usbnet 13178 2 zaurus,cdc_ether, Live 0xffffffffa03c2000
mii 3274 1 usbnet, Live 0xffffffffa0313000
thinkpad_acpi 53136 0 - Live 0xffffffffa04f4000
snd_pcm 61463 3 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0503000
iwlcore 50488 1 iwlagn, Live 0xffffffffa0406000
joydev 9010 0 - Live 0xffffffffa0377000
uvcvideo 51066 0 - Live 0xffffffffa03b3000
videodev 52746 1 uvcvideo, Live 0xffffffffa035c000
v4l2_compat_ioctl32 6175 1 videodev, Live 0xffffffffa01e9000
cdc_acm 14212 0 - Live 0xffffffffa0307000
cdc_wdm 7288 0 - Live 0xffffffffa0119000
snd_seq 42022 0 - Live 0xffffffffa0194000
snd_timer 16146 2 snd_pcm,snd_seq, Live 0xffffffffa010c000
mac80211 173173 2 iwlagn,iwlcore, Live 0xffffffffa04c7000
snd_seq_device 4539 1 snd_seq, Live 0xffffffffa0062000
cfg80211 118409 3 iwlagn,iwlcore,mac80211, Live 0xffffffffa04a8000
psmouse 45999 0 - Live 0xffffffffa00fe000
i2c_i801 7262 0 - Live 0xffffffffa0004000
tpm_tis 7165 0 - Live 0xffffffffa0499000
tpm 9838 1 tpm_tis, Live 0xffffffffa048f000
tpm_bios 4455 1 tpm, Live 0xffffffffa0465000
snd 46464 16 
snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,thinkpad_acpi,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffffa0435000
rfkill 13526 4 bluetooth,thinkpad_acpi,cfg80211, Live 0xffffffffa042a000
wmi 7402 0 - Live 0xffffffffa041a000
evdev 8147 18 - Live 0xffffffffa0402000
serio_raw 3750 0 - Live 0xffffffffa03fc000
ac 2224 0 - Live 0xffffffffa03ee000
nvram 5221 1 thinkpad_acpi, Live 0xffffffffa03f4000
battery 5822 0 - Live 0xffffffffa03e7000
power_supply 7619 2 ac,battery, Live 0xffffffffa03d7000
soundcore 4566 1 snd, Live 0xffffffffa03cf000
snd_page_alloc 6169 2 snd_hda_intel,snd_pcm, Live 0xffffffffa03c7000
processor 23743 3 acpi_cpufreq, Live 0xffffffffa03ab000
nf_conntrack_netbios_ns 1314 0 - Live 0xffffffffa03a5000
nf_conntrack_ftp 5412 0 - Live 0xffffffffa039e000
nf_conntrack 48039 5 
nf_conntrack_ipv6,nf_conntrack_ipv4,xt_state,nf_conntrack_netbios_ns,nf_conntrack_ftp, Live 
0xffffffffa0385000
loop 13683 0 - Live 0xffffffffa037b000
autofs4 19662 7 - Live 0xffffffffa0370000
ext4 281598 2 - Live 0xffffffffa0315000
mbcache 4970 2 ext2,ext4, Live 0xffffffffa0263000
jbd2 57749 1 ext4, Live 0xffffffffa02f6000
crc16 1335 2 l2cap,ext4, Live 0xffffffffa0253000
sha256_generic 9421 2 - Live 0xffffffffa0248000
cryptd 6855 0 - Live 0xffffffffa021f000
aes_x86_64 7404 8 - Live 0xffffffffa0218000
aes_generic 26114 1 aes_x86_64, Live 0xffffffffa01ec000
cbc 2619 4 - Live 0xffffffffa01e6000
usbhid 29796 0 - Live 0xffffffffa01d7000
hid 65464 1 usbhid, Live 0xffffffffa01bf000
dm_crypt 13272 1 - Live 0xffffffffa017f000
dm_mod 56003 13 dm_crypt, Live 0xffffffffa0166000
btrfs 423054 0 - Live 0xffffffffa028c000
zlib_deflate 17650 1 btrfs, Live 0xffffffffa0138000
crc32c 2608 1 - Live 0xffffffffa0132000
libcrc32c 1106 1 btrfs, Live 0xffffffffa012c000
sg 18737 0 - Live 0xffffffffa0122000
sr_mod 12536 0 - Live 0xffffffffa0113000
sd_mod 28661 3 - Live 0xffffffffa0049000
cdrom 29894 1 sr_mod, Live 0xffffffffa0073000
crc_t10dif 1308 1 sd_mod, Live 0xffffffffa0016000
i915 309290 3 - Live 0xffffffffa00b0000
uhci_hcd 18402 0 - Live 0xffffffffa0068000
drm_kms_helper 22205 1 i915, Live 0xffffffffa005a000
drm 154927 4 i915,drm_kms_helper, Live 0xffffffffa001e000
i2c_algo_bit 4202 1 i915, Live 0xffffffffa000e000
ahci 19449 2 - Live 0xffffffffa00a9000
libahci 16136 1 ahci, Live 0xffffffffa011c000
sdhci_pci 7440 0 - Live 0xffffffffa0012000
sdhci 14567 1 sdhci_pci, Live 0xffffffffa0008000
libata 143040 2 ahci,libahci, Live 0xffffffffa0267000
e1000e 118349 0 - Live 0xffffffffa01a0000
scsi_mod 153953 4 sg,sr_mod,sd_mod,libata, Live 0xffffffffa0081000
mmc_core 54941 1 sdhci, Live 0xffffffffa0156000
ehci_hcd 32425 0 - Live 0xffffffffa0259000
usbcore 117260 10 zaurus,cdc_ether,usbnet,uvcvideo,cdc_acm,cdc_wdm,usbhid,uhci_hcd,ehci_hcd, Live 
0xffffffffa01f9000
i2c_core 16421 6 videodev,i2c_i801,i915,drm_kms_helper,drm,i2c_algo_bit, Live 0xffffffffa024c000
video 10649 1 i915, Live 0xffffffffa0243000
thermal 7482 0 - Live 0xffffffffa023b000
thermal_sys 12507 3 processor,video,thermal, Live 0xffffffffa0229000
nls_base 6377 1 usbcore, Live 0xffffffffa001a000
button 4730 1 i915, Live 0xffffffffa0000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  0800-080f : pnp 00:02
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-107f : pnp 00:02
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-102f : ACPI GPE0_BLK
    1050-1050 : ACPI PM2_CNT_BLK
  1180-11ff : pnp 00:02
  15e0-15ef : pnp 00:02
  1600-167f : pnp 00:02
  1680-169f : pnp 00:02
  1800-1807 : 0000:00:02.0
  1838-183b : 0000:00:1f.2
    1838-183b : ahci
  183c-183f : 0000:00:1f.2
    183c-183f : ahci
  1840-185f : 0000:00:19.0
  1860-187f : 0000:00:1a.0
    1860-187f : uhci_hcd
  1880-189f : 0000:00:1a.1
    1880-189f : uhci_hcd
  18a0-18bf : 0000:00:1a.2
    18a0-18bf : uhci_hcd
  18c0-18df : 0000:00:1d.0
    18c0-18df : uhci_hcd
  18e0-18ff : 0000:00:1d.1
    18e0-18ff : uhci_hcd
  1c00-1c1f : 0000:00:1d.2
    1c00-1c1f : uhci_hcd
  1c20-1c3f : 0000:00:1f.2
    1c20-1c3f : ahci
  1c40-1c47 : 0000:00:1f.2
    1c40-1c47 : ahci
  1c48-1c4f : 0000:00:1f.2
    1c48-1c4f : ahci
  1c60-1c7f : 0000:00:1f.3
    1c60-1c7f : i801_smbus
  2000-2fff : PCI Bus 0000:05
  3000-3fff : PCI Bus 0000:02
  4000-4fff : PCI Bus 0000:03


00000000-0000ffff : reserved
00010000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c3fff : pnp 00:00
000c4000-000c7fff : pnp 00:00
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000fffff : reserved
00100000-bd4a0fff : System RAM
  01000000-0132ab6b : Kernel code
  0132ab6c-0168767f : Kernel data
  01737000-0180ffff : Kernel bss
bd4a1000-bd4a6fff : reserved
bd4a7000-bd5b6fff : System RAM
bd5b7000-bd60efff : reserved
bd60f000-bd6c5fff : System RAM
bd6c6000-bd6d0fff : ACPI Non-volatile Storage
bd6d1000-bd6d3fff : ACPI Tables
bd6d4000-bd6d7fff : reserved
bd6d8000-bd6dbfff : ACPI Non-volatile Storage
bd6dc000-bd6defff : reserved
bd6df000-bd705fff : ACPI Non-volatile Storage
bd706000-bd707fff : ACPI Tables
bd708000-bd90efff : reserved
bd90f000-bd99efff : ACPI Non-volatile Storage
bd99f000-bd9fefff : ACPI Tables
bd9ff000-bd9fffff : System RAM
bda00000-bdbfffff : RAM buffer
bdc00000-bfffffff : reserved
c0000000-febfffff : PCI Bus 0000:00
  c0000000-c01fffff : PCI Bus 0000:02
  c0200000-c03fffff : PCI Bus 0000:02
  c0400000-c05fffff : PCI Bus 0000:03
  c0600000-c0600fff : Intel Flush Page
  d0000000-dfffffff : 0000:00:02.0
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:02
      e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f0000000-f1ffffff : PCI Bus 0000:05
    f1f00000-f1f000ff : 0000:05:00.0
      f1f00000-f1f000ff : mmc0
    f1f00400-f1f004ff : 0000:05:00.1
  f2000000-f23fffff : 0000:00:02.0
  f2400000-f24fffff : 0000:00:02.1
  f2500000-f25fffff : PCI Bus 0000:03
    f2500000-f2501fff : 0000:03:00.0
      f2500000-f2501fff : iwlagn
  f2600000-f261ffff : 0000:00:19.0
    f2600000-f261ffff : e1000e
  f2620000-f2623fff : 0000:00:1b.0
    f2620000-f2623fff : ICH HD audio
  f2625000-f2625fff : 0000:00:19.0
    f2625000-f2625fff : e1000e
  f2826000-f28267ff : 0000:00:1f.2
    f2826000-f28267ff : ahci
  f2826800-f282680f : 0000:00:03.0
  f2826c00-f2826fff : 0000:00:1a.7
    f2826c00-f2826fff : ehci_hcd
  f2827000-f28273ff : 0000:00:1d.7
    f2827000-f28273ff : ehci_hcd
  f2827400-f28274ff : 0000:00:1f.3
  f2900000-f29fffff : PCI Bus 0000:05
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed10000-fed13fff : reserved
  fed10000-fed13fff : pnp 00:02
fed18000-fed19fff : reserved
  fed18000-fed18fff : pnp 00:02
  fed19000-fed19fff : pnp 00:02
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
  fed45000-fed4bfff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff800000-ffffffff : reserved
100000000-13bffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
        Subsystem: Lenovo Device 20e0
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- 
<PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0a <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics 
Controller (rev 07) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Device 20e4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 45
        Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 1800 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 41a1
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics 
Controller (rev 07)
        Subsystem: Lenovo Device 20e4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Region 0: Memory at f2400000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 
07)
        Subsystem: Lenovo Device 20e6
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx+
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f2826800 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
        Subsystem: Lenovo Device 20ee
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 43
        Region 0: Memory at f2600000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at f2625000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 1840 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 4142
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03) 
(prog-if 00 [UHCI])
        Subsystem: Lenovo Device 20f0
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at 1860 [size=32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03) 
(prog-if 00 [UHCI])
        Subsystem: Lenovo Device 20f0
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at 1880 [size=32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03) 
(prog-if 00 [UHCI])
        Subsystem: Lenovo Device 20f0
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 22
        Region 4: I/O ports at 18a0 [size=32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) 
(prog-if 20 [EHCI])
        Subsystem: Lenovo Device 20f1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at f2826c00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
        Subsystem: Lenovo Device 20f2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 47
        Region 0: Memory at f2620000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 4122
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable- ID=0 ArbSelect=Fixed TC/VC=00
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped 
LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03) (prog-if 00 
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: c0000000-c01fffff
        Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- 
<PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4151
        Capabilities: [90] Subsystem: Lenovo Device 20f3
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=01 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped 
LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03) (prog-if 00 
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: f2500000-f25fffff
        Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- 
<PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4159
        Capabilities: [90] Subsystem: Lenovo Device 20f3
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=02 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped 
LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03) (prog-if 00 
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: f0000000-f1ffffff
        Prefetchable memory behind bridge: 00000000f2900000-00000000f29fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- 
<PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
                        Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4161
        Capabilities: [90] Subsystem: Lenovo Device 20f3
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=04 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped 
LinkValid+
                        Addr:   00000000fed1c000
        Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03) 
(prog-if 00 [UHCI])
        Subsystem: Lenovo Device 20f0
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at 18c0 [size=32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03) 
(prog-if 00 [UHCI])
        Subsystem: Lenovo Device 20f0
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 18e0 [size=32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03) 
(prog-if 00 [UHCI])
        Subsystem: Lenovo Device 20f0
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 1c00 [size=32]
        Capabilities: [50] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) 
(prog-if 20 [EHCI])
        Subsystem: Lenovo Device 20f1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 19
        Region 0: Memory at f2827000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01 [Subtractive 
decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- 
<PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Lenovo Device 20f4

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
        Subsystem: Lenovo Device 20f5
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01 
[AHCI 1.0])
        Subsystem: Lenovo Device 20f8
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- 
FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 44
        Region 0: I/O ports at 1c48 [size=8]
        Region 1: I/O ports at 183c [size=4]
        Region 2: I/O ports at 1c40 [size=8]
        Region 3: I/O ports at 1838 [size=4]
        Region 4: I/O ports at 1c20 [size=32]
        Region 5: Memory at f2826000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
                Address: fee0100c  Data: 4181
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Capabilities: [b0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
        Subsystem: Lenovo Device 20f9
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f2827400 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 1c60 [size=32]
        Kernel driver in use: i801_smbus

03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
        Subsystem: Intel Corporation Device 1111
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 41a9
        Capabilities: [e0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- 
UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [140 v1] Device Serial Number 00-21-6a-ff-ff-9e-3e-f2
        Kernel driver in use: iwlagn

05:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
        Subsystem: Lenovo Device 2133
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f1f00000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [80] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [800 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- 
UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Kernel driver in use: sdhci-pci

05:00.1 System peripheral: Ricoh Co Ltd Memory Stick Host Controller (rev 01)
        Subsystem: Lenovo Device 2134
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ 
FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- 
<PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at f1f00400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [80] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- 
UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- 
UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-

[7.6.] SCSI information (from /proc/scsi/scsi)

(seems to be missing, but I don't have any real scsi devices installed)

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

I often see this error when resuming and hibernating:

Mar 23 18:01:18 nanuk kernel: [ 1026.849200] legacy_resume(): pnp_bus_resume+0x0/0x65 returns -19
Mar 23 18:01:18 nanuk kernel: [ 1026.849203] PM: Device 00:0a failed to restore: error -19

with 00:0a beeing the tpm device

Mar 23 10:53:06 nanuk kernel: [    8.060938] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
Mar 23 10:53:06 nanuk kernel: [    8.060941] tpm_tis 00:0a: Intel iTPM workaround enabled


[X.] Other notes, patches, fixes, workarounds:

Could this be related to the bug linked below?

https://bugzilla.kernel.org/show_bug.cgi?id=26612


And would you be so kind to CC me, as I am not on the list. Thanks a lot,
Flo.
