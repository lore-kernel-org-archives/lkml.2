Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0KYNTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:19:50 -0500
Received: from mx0.vr-web.de ([195.200.35.198]:54760 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0KYNTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:19:48 -0500
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: Re: resource map sanity check conflict
Date: Thu, 25 Nov 2010 14:20:55 +0100
Organization: privat
Message-ID: <4CEE62B7.6010600@01019freenet.de>
References: <fSnJM-6IJ-11@gated-at.bofh.it> <fSrkl-4sU-11@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.15) Gecko/20101026 SUSE/2.0.10-1.1 SeaMonkey/2.0.10
In-Reply-To: <fSrkl-4sU-11@gated-at.bofh.it>
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf103, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

well, I do have the same problem with a Radeon HD3200 onboard gfxcard.
On loading the fglrx-module, the following trace comes up:


resource map sanity check conflict: 0xcfbfb000 0xcfffbfff 0xcff00000
0xfebfffff PCI Bus 0000:00
------------[ cut here ]------------
WARNING: at
/usr/src/packages/BUILD/kernel-desktop-2.6.34.7/linux-2.6.34/arch/x86/mm/ioremap.c:98
__ioremap_caller+0x350/0x380()
Hardware name: GA-MA78G-DS3H
Info: mapping multiple BARs. Your kernel is fine.
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
bridge stp llc tun cpufreq_conservative cpufreq_userspace
cpufreq_powersave powernow_k8 mperf fuse sha256_generic cryptd
aes_x86_64 aes_generic cbc dm_crypt reiserfs loop dm_mod
snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
firewire_ohci firewire_core snd_hwdep snd_pcm crc_itu_t snd_timer
fglrx(P) ohci1394 kvm_amd snd shpchp edac_core sr_mod soundcore
edac_mce_amd ieee1394 kvm e100 cdrom snd_page_alloc usb_storage wmi
pci_hotplug i2c_piix4 k8temp pcspkr r8169 sg button sd_mod ahci edd fan
processor ata_generic pata_atiixp libata scsi_mod thermal thermal_sys raid1
Pid: 6069, comm: Xorg Tainted: P           2.6.34.7-33-desktop #1
Call Trace:
[<ffffffff810060a9>] dump_trace+0x79/0x340
[<ffffffff8149b75e>] dump_stack+0x69/0x6f
[<ffffffff81050f83>] warn_slowpath_common+0x73/0xb0
[<ffffffff81051020>] warn_slowpath_fmt+0x40/0x50
[<ffffffff810322c0>] __ioremap_caller+0x350/0x380
[<ffffffffa0251712>] drm_ioremap_nocache+0x52/0x120 [fglrx]
[<ffffffffa026b7ff>] __create_mapping+0x7f/0x4b0 [fglrx]
[<ffffffffa0267c52>] gal_map_virtual_space+0x62/0xc0 [fglrx]
[<ffffffffa027013e>] __mc_heap_map_virtual_space+0x12e/0x210 [fglrx]
[<ffffffffa026d7eb>] mc_heap_alloc_reserved_mem+0x1fb/0x360 [fglrx]
[<ffffffffa02627a4>] MCIL_AllocateMemory+0x264/0x420 [fglrx]
[<ffffffffa02f5198>]
_ZN7GpsBase15GPS_AllocMemoryEPvmjP15_ULARGE_INTEGERP9MCADDRESSb+0x68/0xa0 [fglrx]
[<ffffffffa02f5012>]
_ZN7GpsBase11AllocMemoryEmjP15_ULARGE_INTEGERP9MCADDRESSb+0x22/0x30 [fglrx]
[<ffffffffa03039a7>] _ZN9PageTable16CreateTableInLFBEm+0x47/0xb0 [fglrx]
[<ffffffffa02f4725>] _ZN17PageTableGartVmpt4InitEv+0x15/0x40 [fglrx]
[<ffffffffa0302342>]
_ZN13GartVmptRS78015CreatePageTableEP9GpsConfig+0x52/0x200 [fglrx]
[<ffffffffa02f631d>] _ZN10GPSContext18InitializeAsicGartEv+0x3d/0xf0 [fglrx]
[<ffffffffa02f1c63>] Gps_GartInitialization+0x23/0x40 [fglrx]
[<ffffffffa026ad1b>] __gart_init+0x2eb/0x6f0 [fglrx]
[<ffffffffa02686e0>] gal_init+0xc0/0x160 [fglrx]
[<ffffffffa026e552>] mc_heap_init+0xe2/0x200 [fglrx]
[<ffffffffa025ca2a>] firegl_init_pcie+0x16a/0x3e0 [fglrx]
[<ffffffffa02584da>] firegl_ioctl+0x1ea/0x250 [fglrx]
[<ffffffff81134086>] vfs_ioctl+0x96/0xd0
[<ffffffff811345a8>] do_vfs_ioctl+0x78/0x420
[<ffffffff811349d0>] sys_ioctl+0x80/0xa0
[<ffffffff81002fbb>] system_call_fastpath+0x16/0x1b
[<00007f5db85c0547>] 0x7f5db85c0547
---[ end trace e6f2dfd959f0bb46 ]---
[   56.972841] [fglrx] Could not enable MSI; System prevented initialization
[fglrx] Firegl kernel thread PID: 6104
[fglrx] IRQ 18 Enabled
[fglrx] Gart USWC size:1279 M.
[fglrx] Gart cacheable size:508 M.
[fglrx] Reserved FB block: Shared offset:0, size:1000000
[fglrx] Reserved FB block: Unshared offset:fbfb000, size:401000
[fglrx] Reserved FB block: Unshared offset:fffc000, size:4000


dmesg


Linux version 2.6.34.7-33-desktop (geeko@buildhost) (gcc version 4.4.1
[gcc-4_4-branch revision 150839] (SUSE Linux) ) #1 SMP PREEMPT
2010-11-09 20:08:44 +0100
Command line:
root=/dev/disk/by-id/scsi-SATA_WDC_WD5000AACS-_WD-WCAUF1158341-part1
splash=silent quiet nmi_watchdog=0 iommu=noagp,memaper=0 agp=off vga=0x376
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 00000000bfde0000 (usable)
BIOS-e820: 00000000bfde0000 - 00000000bfde3000 (ACPI NVS)
BIOS-e820: 00000000bfde3000 - 00000000bfdf0000 (ACPI data)
BIOS-e820: 00000000bfdf0000 - 00000000bfe00000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x230000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
 00000-9FFFF write-back
 A0000-BFFFF uncachable
 C0000-C7FFF write-protect
 C8000-FFFFF uncachable
MTRR variable ranges enabled:
 0 base 0000000000 mask FF80000000 write-back
 1 base 0080000000 mask FFC0000000 write-back
 2 base 00BFE00000 mask FFFFE00000 uncachable
 3 base 0100000000 mask FF00000000 write-back
 4 base 0200000000 mask FFE0000000 write-back
 5 base 0220000000 mask FFF0000000 write-back
 6 disabled
 7 disabled
TOM2: 0000000230000000 aka 8960M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000bfe00000 - 0000000100000000 (usable) ==>
(reserved)
last_pfn = 0xbfde0 max_arch_pfn = 0x400000000
e820 update range: 0000000000001000 - 0000000000010000 (usable) ==>
(reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
modified: 0000000000000000 - 0000000000010000 (reserved)
modified: 0000000000010000 - 000000000009f800 (usable)
modified: 000000000009f800 - 00000000000a0000 (reserved)
modified: 00000000000f0000 - 0000000000100000 (reserved)
modified: 0000000000100000 - 00000000bfde0000 (usable)
modified: 00000000bfde0000 - 00000000bfde3000 (ACPI NVS)
modified: 00000000bfde3000 - 00000000bfdf0000 (ACPI data)
modified: 00000000bfdf0000 - 00000000bfe00000 (reserved)
modified: 00000000e0000000 - 00000000f0000000 (reserved)
modified: 00000000fec00000 - 0000000100000000 (reserved)
modified: 0000000100000000 - 0000000230000000 (usable)
initial memory mapped : 0 - 20000000


lspci -v
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200
Graphics (prog-if 00 [VGA controller])
        Subsystem: Giga-byte Technology GA-MA78GM-S2H Motherboard
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        I/O ports at ee00 [size=256]
        Memory at fdfe0000 (32-bit, non-prefetchable) [size=64K]
        Memory at fde00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [50] Power Management version 3
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Kernel driver in use: fglrx_pci


btw: There is some memory missing:
The machine has 8 GB physical RAM, but free -m reports only 7779 MB. If
you ad the 256 MB of the shared memory for the gfxcard, you get 8035 MB.
This means: I'm missing 157 MB!


Kind regards,
Andreas
