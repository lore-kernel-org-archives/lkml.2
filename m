Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1DYXci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:32:38 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:61237 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1DYXcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:32:36 -0400
X-Authority-Analysis: v=1.1 cv=u0GDbnsGpYF3ufkDf8oJFk+kgusfHOwmXSY+Z6GJvsg= c=1 sm=0 a=VpboIDtyrZQA:10 a=NN14mYwwY30A:10 a=8nJEP1OIZ-IA:10 a=JDBpcgVbJLzshLqne7oz2g==:17 a=vTr9H3xdAAAA:8 a=WTCdki9lT0OpIUfgFE0A:9 a=t7p53rFoyTe_NCmjPdQA:7 a=wPNLvfGTeEIA:10 a=btGhsTMntQZVlShd:21 a=F5ghDYKD1-U0t1zP:21 a=JDBpcgVbJLzshLqne7oz2g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 69.134.8.117
Message-ID: <4DB60493.7000906@nc.rr.com>
Date: Mon, 25 Apr 2011 19:32:35 -0400
From: Ralph Blach <chipperb@nc.rr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kernel error and possible bug on nvida boards
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Asus P5n-T running Fedora 13 and am running a quad core Q9000 cpu with kernel version

every few days I get this message for ether my 3ware raid controller or my single sata boot disk.
The 3way is plugged into the pci express slot, and the boot disk plugged into the onbaord sata
ether one will hang in exactly the same way.  Does anybody have any answers or has this been seen before



Apr 22 05:51:18 chipblach kernel: sd 0:0:0:0: WARNING: (0x06:0x002C): Command (0x2a) timed out, resetting card.
Apr 22 05:51:52 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
Apr 22 05:52:32 chipblach kernel: sd 0:0:0:0: WARNING: (0x06:0x002C): Command (0x0) timed out, resetting card.
Apr 22 05:53:27 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
Apr 22 05:53:58 chipblach kernel: INFO: task kdmflush:1147 blocked for more than 120 seconds.
Apr 22 05:53:58 chipblach kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 22 05:53:58 chipblach kernel: kdmflush      D 0000000000000000     0  1147      2 0x00000000
Apr 22 05:53:58 chipblach kernel: ffff880126119d50 0000000000000046 ffff880126119cd0 ffffffff00000000
Apr 22 05:53:58 chipblach kernel: ffff880126119fd8 ffff8801269e2ee0 00000000000153c0 ffff880126119fd8
Apr 22 05:53:58 chipblach kernel: 00000000000153c0 00000000000153c0 00000000000153c0 00000000000153c0
Apr 22 05:53:58 chipblach kernel: Call Trace:
Apr 22 05:53:58 chipblach kernel: [<ffffffff8144be26>] io_schedule+0x73/0xb5
Apr 22 05:53:58 chipblach kernel: [<ffffffff81368480>] dm_wait_for_completion+0xa6/0xe7
Apr 22 05:53:58 chipblach kernel: [<ffffffff81048292>] ? default_wake_function+0x0/0x14
Apr 22 05:53:58 chipblach kernel: [<ffffffff813693be>] dm_flush+0x20/0x5e
Apr 22 05:53:58 chipblach kernel: [<ffffffff813694bd>] dm_wq_work+0xc1/0x173
Apr 22 05:53:58 chipblach kernel: [<ffffffff81062411>] worker_thread+0x1a9/0x237
Apr 22 05:53:58 chipblach kernel: [<ffffffff813693fc>] ? dm_wq_work+0x0/0x173
Apr 22 05:53:58 chipblach kernel: [<ffffffff8106625f>] ? autoremove_wake_function+0x0/0x39
Apr 22 05:53:58 chipblach kernel: [<ffffffff81062268>] ? worker_thread+0x0/0x237
Apr 22 05:53:58 chipblach kernel: [<ffffffff81065de5>] kthread+0x7f/0x87
Apr 22 05:53:58 chipblach kernel: [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
Apr 22 05:53:58 chipblach kernel: [<ffffffff81065d66>] ? kthread+0x0/0x87
Apr 22 05:53:58 chipblach kernel: [<ffffffff8100aa60>] ? kernel_thread_helper+0x0/0x10
Apr 22 05:53:58 chipblach kernel: INFO: task jbd2/dm-2-8:1236 blocked for more than 120 seconds.
Apr 22 05:53:58 chipblach kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 22 05:53:58 chipblach kernel: jbd2/dm-2-8   D 0000000000000003     0  1236      2 0x00000000
Apr 22 05:53:58 chipblach kernel: ffff8801170afbe0 0000000000000046 ffff8801170afb50 ffffffff81010296
Apr 22 05:53:58 chipblach kernel: ffff8801170affd8 ffff8801271e5dc0 00000000000153c0 ffff8801170affd8
Apr 22 05:53:58 chipblach kernel: 00000000000153c0 00000000000153c0 00000000000153c0 00000000000153c0
Apr 22 05:53:58 chipblach kernel: Call Trace:
Apr 22 05:53:58 chipblach kernel: [<ffffffff81010296>] ? read_tsc+0x9/0x1b
Apr 22 05:53:58 chipblach kernel: [<ffffffff8112f767>] ? sync_buffer+0x0/0x44
Apr 22 05:53:58 chipblach kernel: [<ffffffff8144be26>] io_schedule+0x73/0xb5
Apr 22 05:53:58 chipblach kernel: [<ffffffff8112f7a7>] sync_buffer+0x40/0x44
Apr 22 05:53:58 chipblach kernel: [<ffffffff8144c3b7>] __wait_on_bit+0x48/0x7b
Apr 22 05:53:58 chipblach kernel: [<ffffffff811fac55>] ? submit_bio+0xde/0xfb
Apr 22 05:53:58 chipblach kernel: [<ffffffff8144c458>] out_of_line_wait_on_bit+0x6e/0x79
Apr 22 05:53:58 chipblach kernel: [<ffffffff8112f767>] ? sync_buffer+0x0/0x44
Apr 22 05:53:58 chipblach kernel: [<ffffffff81066298>] ? wake_bit_function+0x0/0x33
Apr 22 05:53:58 chipblach kernel: [<ffffffff8112f6ca>] __wait_on_buffer+0x24/0x26
Apr 22 05:53:58 chipblach kernel: [<ffffffff811b1989>] wait_on_buffer+0x3d/0x41
Apr 22 05:53:58 chipblach kernel: [<ffffffff811b281f>] jbd2_journal_commit_transaction+0xb83/0x11b4
Apr 22 05:53:58 chipblach kernel: [<ffffffff810085ee>] ? __switch_to+0xd7/0x227
Apr 22 05:53:58 chipblach kernel: [<ffffffff81059898>] ? try_to_del_timer_sync+0x7b/0x89
Apr 22 05:53:58 chipblach kernel: [<ffffffff811b7382>] kjournald2+0xc6/0x203
Apr 22 05:53:58 chipblach kernel: [<ffffffff8106625f>] ? autoremove_wake_function+0x0/0x39
Apr 22 05:53:58 chipblach kernel: [<ffffffff811b72bc>] ? kjournald2+0x0/0x203
Apr 22 05:53:58 chipblach kernel: [<ffffffff81065de5>] kthread+0x7f/0x87
Apr 22 05:53:58 chipblach kernel: [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
Apr 22 05:53:58 chipblach kernel: [<ffffffff81065d66>] ? kthread+0x0/0x87
Apr 22 05:53:58 chipblach kernel: [<ffffffff8100aa60>] ? kernel_thread_helper+0x0/0x10
Apr 22 05:54:06 chipblach kernel: sd 0:0:0:0: WARNING: (0x06:0x002C): Command (0x0) timed out, resetting card.
Apr 22 05:55:01 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: Device offlined - not ready after error recovery
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: Device offlined - not ready after error recovery
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: [sdb] Unhandled error code
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 1a c0 08 29 00 00 08 00
Apr 22 05:55:30 chipblach kernel: end_request: I/O error, dev sdb, sector 448792617
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56099029
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: [sdb] Unhandled error code
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: [sdb] CDB: Write(10): 2a 00 19 40 2d 39 00 00 10 00
Apr 22 05:55:30 chipblach kernel: end_request: I/O error, dev sdb, sector 423636281
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 52954487
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 52954488
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: Aborting journal on device dm-2-8.
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56262256
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56262257
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56262258
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56262259
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56262260
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: Buffer I/O error on device dm-2, logical block 56262261
Apr 22 05:55:30 chipblach kernel: lost page write due to I/O error on dm-2
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: sd 0:0:0:0: rejecting I/O to offline device
Apr 22 05:55:30 chipblach kernel: JBD2: I/O error detected when updating journal superblock for dm-2-8.
Apr 22 05:55:30 chipblach kernel: JBD2: Detected IO errors while flushing file data on dm-2-8
Apr 22 05:55:30 chipblach kernel: EXT4-fs error (device dm-2): ext4_journal_start_sb: Detected aborted journal
Apr 22 05:55:30 chipblach kernel: EXT4-fs (dm-2): Remounting filesystem read-only
Apr 22 05:56:35 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
Apr 22 05:58:00 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
Apr 22 05:59:25 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
Apr 22 06:00:49 chipblach kernel: 3w-9xxx: scsi0: WARNING: (0x06:0x003

And either my scsi raid card goes to a read only file system of my root, wich is singe disk goes to a read only file system.

I am running fedora core 13 with be below kernel level

Linux version 2.6.34.8-68.fc13.x86_64 (mockbuild@x86-03.phx2.fedoraproject.org) (gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC) ) #1 SMP Thu Feb 17 15:03:58 UTC 2011

here is the lspci of my system

Password:
[root@chipblach ~]# lspci
00:00.0 Host bridge: nVidia Corporation C55 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.3 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.4 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.5 RAM memory: nVidia Corporation C55 Memory Controller (rev a2)
00:00.6 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.7 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.0 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.3 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.4 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.5 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.6 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:02.0 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:02.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:02.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:03.0 PCI bridge: nVidia Corporation C55 PCI Express bridge (rev a1)
00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a3)
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
01:00.0 PCI bridge: nVidia Corporation Device 05bf (rev a2)
02:00.0 PCI bridge: nVidia Corporation Device 05bf (rev a2)
02:01.0 PCI bridge: nVidia Corporation Device 05bf (rev a2)
02:02.0 PCI bridge: nVidia Corporation Device 05bf (rev a2)
02:03.0 PCI bridge: nVidia Corporation Device 05bf (rev a2)
03:00.0 VGA compatible controller: nVidia Corporation G72 [GeForce 7300 SE/7200 GS] (rev a1)
05:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID PCIe (rev 01)
07:07.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID Controller (rev 50)
07:08.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev c0)
[root@chipblach ~]#



Here is the cpu info
[root@chipblach log]# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 5333.73
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 5333.06
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 5333.05
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 5333.04
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


Below is the list of modules which are loaded

fuse                   57421  2
vboxnetadp              4999  0
vboxnetflt             17096  0
vboxdrv              1777684  2 vboxnetadp,vboxnetflt
hwmon_vid               2099  0
coretemp                5542  0
cpufreq_ondemand        8764  1
acpi_cpufreq            7693  4
freq_table              3955  2 cpufreq_ondemand,acpi_cpufreq
ipv6                  275841  32
kvm_intel              43352  0
kvm                   260338  1 kvm_intel
uinput                  7455  0
usblp                  10964  0
snd_hda_codec_realtek   297127  1
snd_hda_intel          23960  2
snd_hda_codec          85624  2 snd_hda_codec_realtek,snd_hda_intel
snd_seq                53005  0
snd_usb_audio          90322  1
snd_hwdep               6454  2 snd_hda_codec,snd_usb_audio
snd_pcm                80324  3 snd_hda_intel,snd_hda_codec,snd_usb_audio
uvcvideo               54612  0
videodev               35667  1 uvcvideo
v4l1_compat            12930  2 uvcvideo,videodev
v4l2_compat_ioctl32     9877  1 videodev
forcedeth              48276  0
ppdev                   8326  0
parport_pc             21225  0
snd_usb_lib            17502  1 snd_usb_audio
snd_rawmidi            20605  1 snd_usb_lib
snd_seq_device          6159  2 snd_seq,snd_rawmidi
snd_timer              19882  2 snd_seq,snd_pcm
snd                    62913  17 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_seq,snd_usb_audio,snd_hwdep,snd_pcm,snd_usb_lib,snd_rawmidi,snd_seq_device,snd_timer
shpchp                 28540  0
parport                31449  2 ppdev,parport_pc
snd_page_alloc          7437  2 snd_hda_intel,snd_pcm
serio_raw               4588  0
joydev                  9803  0
soundcore               6390  1 snd
i2c_nforce2             6622  0
asus_atk0110           14532  0
microcode              18234  0
firewire_ohci          20544  0
ata_generic             3427  0
usb_storage            45368  0
pata_acpi               3419  0
firewire_core          44966  1 firewire_ohci
crc_itu_t               1547  1 firewire_core
3w_9xxx                30358  1
sata_via                8993  0
sata_nv                20997  2
pata_amd               11154  0
nouveau               394453  2
ttm                    54787  1 nouveau
drm_kms_helper         24738  1 nouveau
drm                   176712  4 nouveau,ttm,drm_kms_helper
i2c_algo_bit            5061  1 nouveau
video                  21629  1 nouveau
output                  2221  1 video
i2c_core               25709  6 videodev,i2c_nforce2,nouveau,drm_kms_helper,drm,i2c_algo_bit


Every few days I get the following error on one of the hard drives in my system.  I have on 3ware raid card and one
sata connected directly to the motherboard.  Either one will hang.




Does anybody have any ideas of why this is happening.

Thanks

Chip
