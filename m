Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1BYPrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:47:12 -0500
Received: from smtp.supelec.fr ([160.228.120.99]:54483 "EHLO smtp.supelec.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab1BYPrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:47:10 -0500
X-Greylist: delayed 1046 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 10:47:09 EST
Message-ID: <4D67CAE4.2060909@free.fr>
Date: Fri, 25 Feb 2011 16:29:40 +0100
From: "Emmanuel V." <antro5@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Lightning/1.0b2 Icedove/3.1.7 ThunderBrowse/3.3.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bug in 2.6.32-5-amd64 : aufs/memory management related?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am faced with a kernel bug. It seems to be related to a memory management problem and/or the aufs module and/or Matlab operations on the system (the machine seems stable when not using Matlab).

I hope that I have provided enough information and that someone will be able to solve the problem.

$ cat /proc/version
Linux version 2.6.32-5-amd64 (Debian 2.6.32-30) (ben@decadent.org.uk) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Wed Jan 12 03:40:32 UTC 2011

$ dmesg

[...]
[10688.154693] ------------[ cut here ]------------
[10688.154741] kernel BUG at /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_amd64_none/mm/mmap.c:873!
[10688.154838] invalid opcode: 0000 [#1] SMP
[10688.154887] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
[10688.154975] CPU 10
[10688.155014] Modules linked in: parport_pc ppdev lp parport acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace fuse joydev evdev serio_raw button processor nfs lockd fscache nfs_acl auth_rpcgss sunrpc aufs(C) r8169 mii sg sr_mod sd_mod crc_t10dif cdrom usbhid hid ata_generic uhci_hcd ata_piix libata ehci_hcd scsi_mod usbcore nls_base igb thermal dca thermal_sys [last unloaded: scsi_wait_scan]
[10688.155419] Pid: 31889, comm: MATLAB Tainted: G         C 2.6.32-5-amd64 #1 ProLiant DL160 G6
[10688.155503] RIP: 0010:[<ffffffff810d05be>]  [<ffffffff810d05be>] find_mergeable_anon_vma+0x10e/0x1d5
[10688.155591] RSP: 0000:ffff8803fe485e18  EFLAGS: 00010287
[10688.163581] RAX: ffff88016b53c6a8 RBX: ffff88016b53c678 RCX: ffff88016b53c678
[10688.163635] RDX: ffff8803fe43ee60 RSI: 00007fd10e5c3000 RDI: ffff8803fe43fe30
[10688.163688] RBP: ffff88016b697cc0 R08: 00000000ffffffff R09: 0000000000000000
[10688.163741] R10: 000080d000000000 R11: 00000000ffffffff R12: ffff8803fe43ee60
[10688.163794] R13: ffff8803fe43fe30 R14: 0000000000000000 R15: ffff8801bc4cb390
[10688.163848] FS:  00007fd12f2d2700(0000) GS:ffff880006f80000(0000) knlGS:0000000000000000
[10688.163931] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10688.163979] CR2: 00007fd10e5c3000 CR3: 000000016b576000 CR4: 00000000000006e0
[10688.164032] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10688.164086] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10688.164140] Process MATLAB (pid: 31889, threadinfo ffff8803fe484000, task ffff8803fd48bf90)
[10688.164223] Stack:
[10688.164259]  ffff8803fe43e540 0000000000000000 ffff8803fe43fe30 0000000000000000
[10688.164320]<0>  ffff8801bd7b1880 ffffffff810d5065 00000000fffffff4 0000000000000000
[10688.164412]<0>  ffff8801a2e85e18 ffff8803fe485f58 ffff8803fe43fe30 ffffffff810cc70b
[10688.164535] Call Trace:
[10688.164575]  [<ffffffff810d5065>] ? anon_vma_prepare+0x2e/0xbd
[10688.164627]  [<ffffffff810cc70b>] ? handle_mm_fault+0x260/0x80f
[10688.164677]  [<ffffffff810cfec1>] ? get_unmapped_area+0xd7/0x139
[10688.164729]  [<ffffffff812fe0b6>] ? do_page_fault+0x2e0/0x2fc
[10688.164778]  [<ffffffff812fbf55>] ? page_fault+0x25/0x30
[10688.164825] Code: e8 48 85 d2 74 14 48 3b 72 10 72 0e 48 8b 40 08 48 89 cb 48 85 c0 75 d2 eb 03 48 89 cb 48 85 db 74 04 4c 8b 63 18 4d 39 ec 74 04<0f>  0b eb fe 48 85 db 74 7e 48 83 7b 78 00 4d 8b 6c 24 28 48 8b
[10688.165152] RIP  [<ffffffff810d05be>] find_mergeable_anon_vma+0x10e/0x1d5
[10688.165206]  RSP<ffff8803fe485e18>
[10688.165704] ---[ end trace 991ab831267554d4 ]---
[14740.925077] ------------[ cut here ]------------
[14740.925129] kernel BUG at /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_amd64_none/mm/mmap.c:2129!
[14740.925231] invalid opcode: 0000 [#2] SMP
[14740.925283] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/uevent
[14740.925374] CPU 0
[14740.925415] Modules linked in: parport_pc ppdev lp parport acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace fuse joydev evdev serio_raw button processor nfs lockd fscache nfs_acl auth_rpcgss sunrpc aufs(C) r8169 mii sg sr_mod sd_mod crc_t10dif cdrom usbhid hid ata_generic uhci_hcd ata_piix libata ehci_hcd scsi_mod usbcore nls_base igb thermal dca thermal_sys [last unloaded: scsi_wait_scan]
[14740.925851] Pid: 31983, comm: MATLAB Tainted: G      D  C 2.6.32-5-amd64 #1 ProLiant DL160 G6
[14740.925939] RIP: 0010:[<ffffffff810d02df>]  [<ffffffff810d02df>] exit_mmap+0x13b/0x148
[14740.926030] RSP: 0018:ffff88018bda3cb8  EFLAGS: 00010206
[14740.926080] RAX: 0000000000000000 RBX: ffff880006e0e9b0 RCX: ffff8801bd7b18e0
[14740.926137] RDX: ffff88016b53c398 RSI: ffffea0004f7a520 RDI: 0000000000000286
[14740.926194] RBP: ffff8801bd7b1880 R08: 0000000000000000 R09: ffff8801beca09c0
[14740.926250] R10: ffff8801bbb74730 R11: ffff8801a2d3cfc0 R12: 0000000000000000
[14740.926307] R13: ffff8801bd7b18e0 R14: ffff88016b61e9f0 R15: 0000000000000001
[14740.926365] FS:  00007fd10f378700(0000) GS:ffff880006e00000(0000) knlGS:0000000000000000
[14740.926451] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[14740.926502] CR2: 00007fba12eb1000 CR3: 0000000001001000 CR4: 00000000000006f0
[14740.926559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[14740.926615] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[14740.926673] Process MATLAB (pid: 31983, threadinfo ffff88018bda2000, task ffff88016b61e9f0)
[14740.926758] Stack:
[14740.926796]  ffff88016b61e9f0 ffff8801bd7b1880 00000007fd117fa5 ffff880006e0e9b0
[14740.926859]<0>  ffff8801bd7b1880 ffff88016b61e9f0 ffff8801bd7b1880 ffffffff8104bae9
[14740.926955]<0>  0000000000000000 ffffffff8104f6e2 ffff8803fe7e1400 0000000000000001
[14740.927080] Call Trace:
[14740.927124]  [<ffffffff8104bae9>] ? mmput+0x3c/0xdf
[14740.927175]  [<ffffffff8104f6e2>] ? exit_mm+0x102/0x10d
[14740.927227]  [<ffffffff81051107>] ? do_exit+0x1f8/0x6c6
[14740.927279]  [<ffffffff8105164b>] ? do_group_exit+0x76/0x9d
[14740.927334]  [<ffffffff8105ded7>] ? get_signal_to_deliver+0x310/0x339
[14740.927392]  [<ffffffff8101004f>] ? do_notify_resume+0x87/0x73f
[14740.927448]  [<ffffffff810cc863>] ? handle_mm_fault+0x3b8/0x80f
[14740.927503]  [<ffffffff8104f2d4>] ? put_online_cpus+0x22/0x54
[14740.927558]  [<ffffffff81073d4b>] ? sys_futex+0x113/0x131
[14740.927612]  [<ffffffff812fe0b6>] ? do_page_fault+0x2e0/0x2fc
[14740.927667]  [<ffffffff81010e0e>] ? int_signal+0x12/0x17
[14740.927716] Code: 10 48 8d 7b 18 e8 a4 87 00 00 c7 43 08 00 00 00 00 4c 89 e7 e8 65 fe ff ff 48 85 c0 49 89 c4 75 f0 48 83 bd f0 00 00 00 00 74 04<0f>  0b eb fe 48 83 c4 20 5b 5d 41 5c c3 41 56 41 be f4 ff ff ff
[14740.928098] RIP  [<ffffffff810d02df>] exit_mmap+0x13b/0x148
[14740.928153]  RSP<ffff88018bda3cb8>
[14740.928723] ---[ end trace 991ab831267554d5 ]---
[14740.928832] Fixing recursive fault but reboot is needed!
[14905.279188] aufs au_new_inode:360:MATLAB[1175]: Warning: Un-notified UDBA or repeatedly renamed dir, b0, tmpfs, 00335XEm8XZ, hi473419, i6219.
[18219.282679] ------------[ cut here ]------------
[18219.282731] kernel BUG at /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_amd64_none/mm/rmap.c:139!
[18219.282829] invalid opcode: 0000 [#3] SMP
[18219.282879] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sdb/uevent
[18219.282969] CPU 7
[18219.283008] Modules linked in: parport_pc ppdev lp parport acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace fuse joydev evdev serio_raw button processor nfs lockd fscache nfs_acl auth_rpcgss sunrpc aufs(C) r8169 mii sg sr_mod sd_mod crc_t10dif cdrom usbhid hid ata_generic uhci_hcd ata_piix libata ehci_hcd scsi_mod usbcore nls_base igb thermal dca thermal_sys [last unloaded: scsi_wait_scan]
[18219.283423] Pid: 7184, comm: MATLAB Tainted: G      D  C 2.6.32-5-amd64 #1 ProLiant DL160 G6
[18219.283507] RIP: 0010:[<ffffffff810d3c6e>]  [<ffffffff810d3c6e>] __anon_vma_merge+0xa/0x3a
[18219.283594] RSP: 0018:ffff88018bd5bde0  EFLAGS: 00010202
[18219.283642] RAX: ffff8801824ea480 RBX: ffff8801a2c6b9e0 RCX: 0000000000000000
[18219.283695] RDX: ffff88016b628258 RSI: ffff8801a2c6b9e0 RDI: ffff88016444e508
[18219.283749] RBP: ffff88016444e508 R08: ffff88016b628258 R09: 00000000ffffffff
[18219.283802] R10: 0000000000000040 R11: ffff8801825754c0 R12: ffff88016444e508
[18219.283855] R13: 0000000000000000 R14: ffff88018254ffa0 R15: 0000000000000000
[18219.283909] FS:  00007f2b729b7700(0000) GS:ffff8801c82c0000(0000) knlGS:0000000000000000
[18219.283992] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18219.284040] CR2: 0000000001a80fd0 CR3: 00000003fd4fe000 CR4: 00000000000006e0
[18219.284094] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18219.284147] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18219.284201] Process MATLAB (pid: 7184, threadinfo ffff88018bd5a000, task ffff8801825754c0)
[18219.284284] Stack:
[18219.284320]  ffffffff810d0cf1 00000002000280da 0000000000000000 0000000000001a7e
[18219.284381]<0>  0000000001a7e000 0000000001a7e000 ffff8803fdc93800 0000000000000000
[18219.284473]<0>  0000000000000000 0000000200000002 ffff88016444e508 0000000000001aa1
[18219.284596] Call Trace:
[18219.284635]  [<ffffffff810d0cf1>] ? vma_adjust+0x2fa/0x41b
[18219.284684]  [<ffffffff810d1501>] ? vma_merge+0x1e6/0x334
[18219.284732]  [<ffffffff810d1a58>] ? do_brk+0x227/0x307
[18219.284779]  [<ffffffff810d1c14>] ? sys_brk+0xdc/0x105
[18219.284828]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[18219.284878] Code: 63 c3 eb 05 48 63 44 24 14 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 bb ea ff ff ff eb e0 90 90 48 8b 46 78 48 39 47 78 74 04<0f>  0b eb fe 48 8b 56 68 48 8b 46 70 48 89 42 08 48 89 10 48 ba
[18219.285206] RIP  [<ffffffff810d3c6e>] __anon_vma_merge+0xa/0x3a
[18219.285257]  RSP<ffff88018bd5bde0>
[18219.285746] ---[ end trace 991ab831267554d6 ]---

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X5570  @ 2.93GHz
stepping	: 5
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5867.62
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

[...]

$ cat /proc/modules
parport_pc 18855 0 - Live 0xffffffffa015f000
ppdev 5030 0 - Live 0xffffffffa015b000
lp 7462 0 - Live 0xffffffffa0127000
parport 27954 3 parport_pc,ppdev,lp, Live 0xffffffffa011a000
acpi_cpufreq 5571 1 - Live 0xffffffffa00f3000
cpufreq_powersave 902 0 - Live 0xffffffffa00dc000
cpufreq_conservative 5162 0 - Live 0xffffffffa0093000
cpufreq_stats 2659 0 - Live 0xffffffffa0015000
cpufreq_userspace 1992 0 - Live 0xffffffffa0005000
fuse 50625 1 - Live 0xffffffffa018f000
processor 29935 1 acpi_cpufreq, Live 0xffffffffa024e000
button 4650 0 - Live 0xffffffffa0246000
joydev 8459 0 - Live 0xffffffffa023e000
evdev 7352 0 - Live 0xffffffffa0237000
serio_raw 3752 0 - Live 0xffffffffa0231000
nfs 241066 2 - Live 0xffffffffa01e2000
lockd 57603 1 nfs, Live 0xffffffffa01ca000
fscache 29834 1 nfs, Live 0xffffffffa01b9000
nfs_acl 2031 1 nfs, Live 0xffffffffa01b3000
auth_rpcgss 33476 1 nfs, Live 0xffffffffa01a3000
sunrpc 161541 15 nfs,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa0165000
aufs 127395 1 - Live 0xffffffffa0139000 (C)
r8169 29229 0 - Live 0xffffffffa012a000
mii 3210 1 r8169, Live 0xffffffffa0124000
sg 18744 0 - Live 0xffffffffa0113000
usbhid 33292 0 - Live 0xffffffffa0103000
sr_mod 12602 0 - Live 0xffffffffa00f9000
hid 63225 1 usbhid, Live 0xffffffffa00e1000
sd_mod 29889 2 - Live 0xffffffffa00d2000
cdrom 29415 1 sr_mod, Live 0xffffffffa00c8000
crc_t10dif 1276 1 sd_mod, Live 0xffffffffa0090000
ata_generic 3047 0 - Live 0xffffffffa008a000
ata_piix 21124 1 - Live 0xffffffffa0061000
uhci_hcd 18521 0 - Live 0xffffffffa005a000
libata 133632 2 ata_generic,ata_piix, Live 0xffffffffa00a5000
ehci_hcd 31151 0 - Live 0xffffffffa009b000
scsi_mod 122149 4 sg,sr_mod,sd_mod,libata, Live 0xffffffffa006a000
usbcore 122034 4 usbhid,uhci_hcd,ehci_hcd, Live 0xffffffffa003a000
nls_base 6377 1 usbcore, Live 0xffffffffa0036000
igb 77959 0 - Live 0xffffffffa0019000
thermal 11674 0 - Live 0xffffffffa0010000
dca 3761 1 igb, Live 0xffffffffa0009000
thermal_sys 11942 2 processor,thermal, Live 0xffffffffa0000000

$ cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000c0000-000cffff : pnp 00:0e
000e0000-000fffff : reserved
00100000-bf75ffff : System RAM
   01000000-01301cb4 : Kernel code
   01301cb5-014dae6f : Kernel data
   01579000-0168a413 : Kernel bss
bf760000-bf76dfff : RAM buffer
bf76e000-bf76ffff : reserved
bf770000-bf77dfff : ACPI Tables
bf77e000-bf7cffff : ACPI Non-volatile Storage
bf7d0000-bf7dffff : reserved
bf7e0000-bf7ecfff : RAM buffer
bf7ed000-bfffffff : reserved
c0000000-c03fffff : PCI Bus 0000:03
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
   e0000000-efffffff : reserved
     e0000000-efffffff : pnp 00:0d
f8000000-f8ffffff : PCI Bus 0000:02
   f8000000-f8ffffff : 0000:02:00.0
f9f00000-f9ffffff : PCI Bus 0000:03
faefa000-faefa3ff : 0000:00:1a.7
   faefa000-faefa3ff : ehci_hcd
faefc000-faefc3ff : 0000:00:1d.7
   faefc000-faefc3ff : ehci_hcd
faf00000-fbcfffff : PCI Bus 0000:02
   faff0000-faffffff : 0000:02:00.0
   fb000000-fb7fffff : 0000:02:00.0
   fbcfc000-fbcfffff : 0000:02:00.0
fbd00000-fbefffff : PCI Bus 0000:05
   fbd00000-fbd1ffff : 0000:05:00.0
   fbd20000-fbd3ffff : 0000:05:00.0
   fbd40000-fbd5ffff : 0000:05:00.1
   fbd60000-fbd7ffff : 0000:05:00.1
   fbdc0000-fbddffff : 0000:05:00.0
   fbdfc000-fbdfffff : 0000:05:00.0
     fbdfc000-fbdfffff : igb
   fbe00000-fbe1ffff : 0000:05:00.0
     fbe00000-fbe1ffff : igb
   fbe20000-fbe3ffff : 0000:05:00.0
     fbe20000-fbe3ffff : igb
   fbe80000-fbe9ffff : 0000:05:00.1
   fbebc000-fbebffff : 0000:05:00.1
     fbebc000-fbebffff : igb
   fbec0000-fbedffff : 0000:05:00.1
     fbec0000-fbedffff : igb
   fbee0000-fbefffff : 0000:05:00.1
     fbee0000-fbefffff : igb
fbf00000-fbffffff : pnp 00:01
fc000000-fcffffff : pnp 00:01
fd000000-fdffffff : pnp 00:01
fe000000-febfffff : pnp 00:01
fec00000-fec00fff : IOAPIC 0
fec8a000-fec8afff : IOAPIC 1
fed00000-fed003ff : HPET 0
fed10000-fed10fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:08
fed20000-fed3ffff : pnp 00:08
fed40000-fed8ffff : pnp 00:08
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
     fee00000-fee00fff : pnp 00:0c
ffa00000-ffffffff : reserved
100000000-3ffffffff : System RAM

Complementary information:
--------------------------
The machine is diskless and nfs-booted. The nfs file system is read-only and I use aufs in order to emulate a rw root file-system. To do so, the following script is used in the initramfs

# first, the nfs file system is mounted on /root
# make the mount points on the init root file system
mkdir /aufs /ro /rw

# mount read-write file system
mount -t tmpfs rw /rw -o noatime,mode=0755

# move real root out of the way
mount --move /root /ro

mount -t aufs aufs /aufs -o noatime,dirs=/rw:/ro=ro

# test for mount points on union file system
[ -d /aufs/ro ] || mkdir /aufs/ro
[ -d /aufs/rw ] || mkdir /aufs/rw

mount --move /ro /aufs/ro
mount --move /rw /aufs/rw

# remount on the root partition
mount --move /aufs /root

regards,
Emmanuel V.

