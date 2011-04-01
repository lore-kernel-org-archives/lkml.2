Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1DAEzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:55:00 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:35216 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1DAEy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:54:59 -0400
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 00:54:57 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisLAARXlU3AqIO8/2dsb2JhbACXR44SeIENvyqDCAMFglsEjRY
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: linux-fsdevel@vger.kernel.org
Subject: OOPS ncpfs kernel version 2.6.38
Date: Fri, 1 Apr 2011 06:44:02 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.36.2-desktop-2mnb; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104010644.02775.bonganilinux@mweb.co.za>
X-GeoIP: ZA|South Africa
X-EximConfig: v2.5 on mail.iburst.co.za
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My early email was rejected by vger, because I only have access to my account 
using a webmail client.

So here it is again.

After applying the 2.6.38 patch I cannot access ncpfs volumes any more. 
ncpmount mounts the volume successfully, bus when I ether run ls or change to 
the mount mount I get the following Oops:

ncpfs is version 2.2.6, my distro is Mandriva 2010.1

------------[ cut here ]------------

kernel BUG at 
/home/bongani/development/c/kernel/linux-2.6.33/fs/dcache.c:2126!

invalid opcode: 0000 [#1] PREEMPT SMP 

last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.5/host2/target2:0:0/2:0:0:0/block/sdb/uevent

CPU 0 

Modules linked in: ncpfs nls_iso8859_1 nls_cp437 vfat fat uas usb_storage fuse 
vmnet vmblock vsock vmci vmmon af_packet ipv6 snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm sg 
snd_timer snd_mixer_oss snd iTCO_wdt iTCO_vendor_support serio_raw sr_mod 
soundcore snd_page_alloc r8169 mii i2c_i801 radeon ttm drm_kms_helper drm 
i2c_algo_bit i2c_core binfmt_misc cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table mperf nvram evdev button ppdev 
parport_pc parport processor ide_generic pata_jmicron ide_pci_generic 
ide_gd_mod ide_core pata_acpi ata_generic ahci libahci ata_piix libata sd_mod 
scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid 
usbcore


Pid: 12199, comm: bash Not tainted 2.6.38 #1 Gigabyte Technology Co., Ltd. 
EG45M-UD2H/EG45M-UD2H

RIP: 0010:[]  [] dentry_update_name_case+0x6c/0x80

RSP: 0018:ffff8801b5af99c8  EFLAGS: 00010246

RAX: 0000000000000001 RBX: ffff8801a81bd9c0 RCX: 0000000000000000

RDX: 0000000000000000 RSI: ffff8801b5af9a88 RDI: ffff8801a81bd9c0

RBP: ffff8801b5af99e8 R08: 0000000000000053 R09: ffff8801a81bd9f8

R10: 0000000000000000 R11: 0000000000000000 R12: ffff88010039c048

R13: ffff8801b5af9a88 R14: ffff8800b8d170c0 R15: ffff8801a81bd9c0

FS:  00007f74a48b9700(0000) GS:ffff8800bfc00000(0000) knlGS:0000000000000000

CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b

CR2: 00007f74a3ff2360 CR3: 000000011075c000 CR4: 00000000000406f0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Process bash (pid: 12199, threadinfo ffff8801b5af8000, task ffff8801bdf6e440)

Stack:

 ffff88010039c048 ffff8801b5af9e58 ffff88010039c048 ffff8801b5af9c08

 ffff8801b5af9bd8 ffffffffa05ef62f ffff8801b5af9a18 ffffffff8103e4f1

 ffff8801b5af9a38 ffffffff8114a030 ffff8801b5af9f38 0000000000000000

Call Trace:

 [] ncp_fill_cache+0x1df/0x5a0 [ncpfs]

 [] ? get_parent_ip+0x11/0x50

 [] ? filldir+0x0/0xd0

 [] ? get_parent_ip+0x11/0x50

 [] ? sub_preempt_count+0x9d/0xd0

 [] ? _raw_spin_unlock_irqrestore+0x2c/0x60

 [] ? ncp_do_request+0x2b0/0x3c0 [ncpfs]

 [] ? autoremove_wake_function+0x0/0x40

 [] ? autoremove_wake_function+0x0/0x40

 [] ? ncp_request2+0x52/0x90 [ncpfs]

 [] ncp_read_volume_list+0xe7/0x120 [ncpfs]

 [] ? filldir+0x0/0xd0

 [] ? find_lock_page+0x26/0x80

 [] ? untrack_pfn_vma+0x0/0x70

 [] ncp_readdir+0x310/0x750 [ncpfs]

 [] ? filldir+0x0/0xd0

 [] ? filldir+0x0/0xd0

 [] vfs_readdir+0xb8/0xe0

 [] sys_getdents+0x85/0xf0

 [] ? page_fault+0x25/0x30

 [] system_call_fastpath+0x16/0x1b

Code: 04 48 8b 7b 28 41 8b 55 04 49 8b 75 08 e8 cd 79 0b 00 ff 43 04 4c 89 e7 
e8 22 5c 26 00 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 <0f> 0b eb fe 0f 0b 
eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 

RIP  [] dentry_update_name_case+0x6c/0x80

 RSP

---[ end trace 08aa9ee28dc4838c ]---


decodecode < ncpfs-oops2.txt 


Code: 04 48 8b 7b 28 41 8b 55 04 49 8b 75 08 e8 cd 79 0b 00 ff 43 04 4c 89 e7 
e8 22 5c 26 00 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 <0f> 0b eb fe 0f 0b 
eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55

All code

========

   0:   04 48                   add    $0x48,%al

   2:   8b 7b 28                mov    0x28(%rbx),%edi

   5:   41 8b 55 04             mov    0x4(%r13),%edx

   9:   49 8b 75 08             mov    0x8(%r13),%rsi

   d:   e8 cd 79 0b 00          callq  0xb79df

  12:   ff 43 04                incl   0x4(%rbx)

  15:   4c 89 e7                mov    %r12,%rdi

  18:   e8 22 5c 26 00          callq  0x265c3f

  1d:   48 8b 5d e8             mov    -0x18(%rbp),%rbx

  21:   4c 8b 65 f0             mov    -0x10(%rbp),%r12

  25:   4c 8b 6d f8             mov    -0x8(%rbp),%r13

  29:   c9                      leaveq 

  2a:   c3                      retq   

  2b:*  0f 0b                   ud2a        <-- trapping instruction

  2d:   eb fe                   jmp    0x2d

  2f:*  0f 0b                   ud2a        <-- trapping instruction

  31:   eb fe                   jmp    0x31

  33:   66 66 66 2e 0f 1f 84    data32 data32 nopw %cs:0x0(%rax,%rax,1)

  3a:   00 00 00 00 00 

  3f:   55                      push   %rbp


Code starting with the faulting instruction

===========================================

   0:   0f 0b                   ud2a   

   2:   eb fe                   jmp    0x2

   4:   0f 0b                   ud2a   

   6:   eb fe                   jmp    0x6

   8:   66 66 66 2e 0f 1f 84    data32 data32 nopw %cs:0x0(%rax,%rax,1)

   f:   00 00 00 00 00 

  14:   55                      push   %rbp


gdb gives me this:


(gdb) l *0xffffffff8114d19c

0xffffffff8114d19c is in dentry_update_name_case 
(/home/bongani/development/c/kernel/linux-2.6.33/fs/dcache.c:2126).

2121     * Parent inode i_mutex must be held over d_lookup and into this call 
(to

2122     * keep renames and concurrent inserts, and readdir(2) away).

2123     */

2124    void dentry_update_name_case(struct dentry *dentry, struct qstr *name)

2125    {

2126            BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));

2127            BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives 
this */

2128

2129            spin_lock(&dentry->d_lock);

2130            write_seqcount_begin(&dentry->d_seq);


./linux-2.6.33/scripts/ver_linux 

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux localhost 2.6.38 #1 SMP PREEMPT Wed Mar 16 13:57:13 SAST 2011 x86_64 
x86_64 x86_64 GNU/Linux
 
Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.51.0.7.20100318
util-linux             ./linux-2.6.33/scripts/ver_linux: line 23: fdformat: 
command not found
mount                  support
module-init-tools      found
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Kbd                    1.15.2
Sh-utils               8.5
Modules Loaded         ncpfs nls_iso8859_1 nls_cp437 vfat fat uas usb_storage 
fuse vmnet vmblock vsock vmci vmmon af_packet ipv6 snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm sg 
snd_timer snd_mixer_oss snd iTCO_wdt iTCO_vendor_support serio_raw sr_mod 
soundcore snd_page_alloc r8169 mii i2c_i801 radeon ttm drm_kms_helper drm 
i2c_algo_bit i2c_core binfmt_misc cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table mperf nvram evdev button ppdev 
parport_pc parport processor ide_generic pata_jmicron ide_pci_generic 
ide_gd_mod ide_core pata_acpi ata_generic ahci libahci ata_piix libata sd_mod 
scsi_mod crc_t10dif ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd usbhid hid 
usbcore


cat /proc/cpuinfo (trimed to display only the first core)

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping        : 10
cpu MHz         : 2667.000
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor 
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm dts 
tpr_shadow vnmi flexpriority
bogomips        : 5332.75
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:




