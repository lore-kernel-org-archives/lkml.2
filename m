Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2L3JkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 04:40:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51311 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2L3JkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 04:40:09 -0500
Date: Sun, 30 Dec 2012 10:40:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Du Jiulun <dujiulun@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: Fwd: PROBLEM: Random kernel panic & system freeze when watching
 video
Message-ID: <20121230094008.GA28308@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Du Jiulun <dujiulun@gmail.com>, linux-kernel@vger.kernel.org,
	Tony Luck <tony.luck@intel.com>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
 <CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony.

On Sun, Dec 30, 2012 at 01:45:40AM +0800, Du Jiulun wrote:
> [1.] One line summary of the problem:
> 
> Random kernel panic and system freeze when watching video on my linux laptop
> 
> [2.] Full description of the problem/report:
> 
> I'm experiencing random (but frequent) kernel panics and system
> freezes without panic information while I'm watching videos using
> SMPlayer or Google Chrome (with Flash plugin).
> 
> This problem has been troubling me since (about) a year ago when I was
> using Ubuntu with 3.2.x kernel.
> 
> I'm not quite sure if I should report to the kernel developers or the
> Intel graphics driver's developers, so if it shouldn't be here, I'm
> really sorry about this.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> 
> kernel, panic, freeze, video, Intel, h264, flash
> 
> [4.] Kernel version (from /proc/version):
> 
> Linux version 3.6.10-1-ck (xiaodu@xiaodupc) (gcc version 4.7.2 (GCC) )
> #1 SMP PREEMPT Wed Dec 12 15:26:26 CST 2012
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> 
> [5.1.] Kernel panic information (I read from the photo I taken, but
> I'm not sure if it's completely correct)

Recheck that it is completely correct and then run it through mcelog as
it says above to decode what kind of error you get.

> 
> mce: [Hardware Error]: CPU 2: Machine Check Exception: 4 Bank 2:
> b200000000000005
> mce: [Hardware Error]: TSC 6568f53a1cee
> mce: [Hardware Error]: PROCESSOR 0:20652 TIME 1356717945 SOCKET 0 APIC
> 1 microcode c
> mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> mce: [Hardware Error]: CPU 0: Machine Check Exception: 4 Bank 2:
> b200000000000005
> mce: [Hardware Error]: TSC 6568f53a1cfc
> mce: [Hardware Error]: PROCESSOR 0:20652 TIME 1356717945 SOCKET 0 APIC
> 0 microcode c
> mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> mce: [Hardware Error]: Machine check: Processor context corrupt

this piece until here should suffice.

Leaving in the rest for reference.

> Kernel panic - not syncing: Fatal Machine check
> panic occurred, switching back to text console
> Rebooting in 30 seconds..
> 
> [5.2.] Some other error message I get from "journald" (don't know if
> it's relevant)
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/apic/ipi.c:109
> default_send_IPI_mask_logical+0xb2/0xf0()
> Hardware name: K42Jv
> empty IPI mask
> Modules linked in:
>  hid_generic hidp hid rfcomm btusb fuse ablk_helper cryptd aes_i586
> aes_generic pci_stub vboxpci(O) vboxnetflt(O) vboxne
>  libata sdhci_pci sdhci scsi_mod ehci_hcd mmc_core usbcore usb_common
> Pid: 6456, comm: WorkerPool/6456 Tainted: G           O 3.6.10-1-ck #1
> Call Trace:
>  [<c103a582>] warn_slowpath_common+0x72/0xa0
>  [<c1025b92>] ? default_send_IPI_mask_logical+0xb2/0xf0
>  [<c1025b92>] ? default_send_IPI_mask_logical+0xb2/0xf0
>  [<c103a653>] warn_slowpath_fmt+0x33/0x40
>  [<c1025b92>] default_send_IPI_mask_logical+0xb2/0xf0
>  [<c1023bf5>] native_send_call_func_ipi+0x45/0x60
>  [<c1084a42>] smp_call_function_many+0x172/0x200
>  [<c1033b1b>] native_flush_tlb_others+0x2b/0x30
>  [<c1033dfc>] flush_tlb_page+0x5c/0xc0
>  [<c1032b76>] ptep_set_access_flags+0x66/0x80
>  [<c1100239>] do_wp_page+0x369/0x8a0
>  [<c1041848>] ? current_fs_time+0x18/0x60
>  [<c1101dff>] handle_pte_fault+0x2cf/0xad0
>  [<c1103665>] handle_mm_fault+0x1f5/0x290
>  [<c11663f9>] ? fsnotify+0x1e9/0x2d0
>  [<c13d4f90>] ? spurious_fault+0x114/0x114
>  [<c13d50a0>] do_page_fault+0x110/0x510
>  [<c11f8971>] ? copy_to_user+0x31/0x50
>  [<c105a468>] ? sys_clock_gettime+0x48/0x70
>  [<c13d4f90>] ? spurious_fault+0x114/0x114
>  [<c13d2bb7>] error_code+0x67/0x6c
>  [<c13d007b>] ? schedule_hrtimeout_range_clock+0xab/0x160
>  [<c13d0000>] ? schedule_hrtimeout_range_clock+0x30/0x160
> ---[ end trace 61cedb85d35e275f ]---
> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> 
> Just watch some online video with Flash plugin (with Firefox or
> Chrome), or local ones with mplayer, mostly encoded with H.264 (mp4 or
> mkv format).
> 
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> 
> Linux xiaodupc 3.6.10-1-ck #1 SMP PREEMPT Wed Dec 12 15:26:26 CST 2012
> i686 GNU/Linux
> 
> Gnu C                  4.7.2
> Gnu make               3.82
> binutils               2.23.1
> util-linux             2.22.2
> mount                  debug
> module-init-tools      12
> e2fsprogs              1.42.6
> jfsutils               1.1.15
> reiserfsprogs          3.6.21
> xfsprogs               3.1.8
> pcmciautils            018
> PPP                    2.4.5
> Linux C Library        2.16
> Dynamic linker (ldd)   2.16
> Linux C++ Library      6.0.17
> Procps                 3.3.5
> Net-tools              1.60
> Kbd                    1.15.3
> Sh-utils               8.20
> wireless-tools         29
> Modules Loaded         hid_generic hidp hid fuse ablk_helper cryptd
> aes_i586 aes_generic pci_stub vboxpci vboxnetflt vboxnetadp vboxdrv
> rfcomm bnep btusb joydev bluetooth uvcvideo videobuf2_vmalloc
> videobuf2_memops videobuf2_core videodev media iTCO_wdt
> iTCO_vendor_support i915 coretemp snd_hda_codec_hdmi kvm_intel kvm
> snd_hda_codec_realtek acpi_cpufreq mperf crc32c_intel arc4 processor
> mei mxm_wmi drm_kms_helper drm intel_agp intel_gtt agpgart
> i2c_algo_bit i2c_core jme intel_ips mii evdev lpc_ich psmouse
> asus_laptop sparse_keymap input_polldev ath9k ath9k_common ath9k_hw
> ath mac80211 cfg80211 rfkill serio_raw pcspkr wmi video thermal
> battery ac button microcode snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm snd_page_alloc snd_timer snd soundcore bbswitch ext4 crc16
> jbd2 mbcache sd_mod ahci libahci libata scsi_mod sdhci_pci sdhci
> mmc_core ehci_hcd usbcore usb_common
> 
> Now I'm using Arch Linux x86 with custom 3.6.10 kernel with -ck
> patchset and PAE enabled. But since the problem has been here since
> the old days when I was using Ubuntu x86 with original 3.2.x PAE
> kernel, I don't think it's the problem.
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> 
> (tldr: Core i5 520M with Intel HD Graphics)
> 
> processor : 0
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping : 2
> microcode : 0xc
> cpu MHz : 1199.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 0
> initial apicid : 0
> fdiv_bug : no
> hlt_bug : no
> f00f_bug : no
> coma_bug : no
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
> constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
> pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1
> sse4_2 popcnt lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept
> vpid
> bogomips : 4789.28
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> processor : 1
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping : 2
> microcode : 0xc
> cpu MHz : 1199.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 2
> cpu cores : 2
> apicid : 4
> initial apicid : 4
> fdiv_bug : no
> hlt_bug : no
> f00f_bug : no
> coma_bug : no
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
> constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
> pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1
> sse4_2 popcnt lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept
> vpid
> bogomips : 4789.28
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> processor : 2
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping : 2
> microcode : 0xc
> cpu MHz : 1199.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 0
> cpu cores : 2
> apicid : 1
> initial apicid : 1
> fdiv_bug : no
> hlt_bug : no
> f00f_bug : no
> coma_bug : no
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
> constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
> pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1
> sse4_2 popcnt lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept
> vpid
> bogomips : 4789.28
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> processor : 3
> vendor_id : GenuineIntel
> cpu family : 6
> model : 37
> model name : Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
> stepping : 2
> microcode : 0xc
> cpu MHz : 1199.000
> cache size : 3072 KB
> physical id : 0
> siblings : 4
> core id : 2
> cpu cores : 2
> apicid : 5
> initial apicid : 5
> fdiv_bug : no
> hlt_bug : no
> f00f_bug : no
> coma_bug : no
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
> constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
> pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1
> sse4_2 popcnt lahf_lm ida arat dtherm tpr_shadow vnmi flexpriority ept
> vpid
> bogomips : 4789.28
> clflush size : 64
> cache_alignment : 64
> address sizes : 36 bits physical, 48 bits virtual
> power management:
> 
> [7.3.] Module information (from /proc/modules):
> 
> hid_generic 710 0 - Live 0xf8f18000
> hidp 11319 1 - Live 0xf8d7c000
> hid 68226 2 hid_generic,hidp, Live 0xf8f31000
> fuse 60479 3 - Live 0xf8f21000
> ablk_helper 1529 0 - Live 0xf8b4e000
> cryptd 7390 1 ablk_helper, Live 0xf8b37000
> aes_i586 6980 2 - Live 0xf8b2c000
> aes_generic 26055 1 aes_i586, Live 0xf8b0b000
> pci_stub 970 1 - Live 0xf8b04000
> vboxpci 15026 0 - Live 0xf8aff000 (O)
> vboxnetflt 16625 0 - Live 0xf8a89000 (O)
> vboxnetadp 19240 0 - Live 0xf8a7a000 (O)
> vboxdrv 222873 4 vboxpci,vboxnetflt,vboxnetadp, Live 0xf8da1000 (O)
> rfcomm 28358 4 - Live 0xf89b8000
> bnep 7063 2 - Live 0xf899a000
> btusb 10401 0 - Live 0xf8986000
> joydev 7696 0 - Live 0xf88d7000
> bluetooth 168947 27 hidp,rfcomm,bnep,btusb, Live 0xf88f8000
> uvcvideo 63452 0 - Live 0xf88c1000
> videobuf2_vmalloc 1897 1 uvcvideo, Live 0xf88bd000
> videobuf2_memops 1655 1 videobuf2_vmalloc, Live 0xf8892000
> videobuf2_core 20881 1 uvcvideo, Live 0xf8888000
> videodev 79257 2 uvcvideo,videobuf2_core, Live 0xf87e9000
> media 8546 2 uvcvideo,videodev, Live 0xf87a9000
> iTCO_wdt 4604 0 - Live 0xf8474000
> iTCO_vendor_support 1546 1 iTCO_wdt, Live 0xf846b000
> i915 442072 8 - Live 0xf881b000
> coretemp 4959 0 - Live 0xfa578000
> snd_hda_codec_hdmi 22049 1 - Live 0xf995c000
> kvm_intel 117568 0 - Live 0xf9853000
> kvm 324233 1 kvm_intel, Live 0xf9689000
> snd_hda_codec_realtek 52472 1 - Live 0xf949e000
> acpi_cpufreq 5142 1 - Live 0xf9484000
> mperf 1024 1 acpi_cpufreq, Live 0xf947b000
> crc32c_intel 1488 0 - Live 0xf9472000
> arc4 1604 2 - Live 0xf946b000
> processor 24040 1 acpi_cpufreq, Live 0xf93d5000
> mei 28001 0 - Live 0xf9395000
> mxm_wmi 1136 0 - Live 0xf847e000
> drm_kms_helper 28942 1 i915, Live 0xf9369000
> drm 180693 4 i915,drm_kms_helper, Live 0xf931b000
> intel_agp 8593 1 i915, Live 0xf92cb000
> intel_gtt 12680 3 i915,intel_agp, Live 0xf92bc000
> agpgart 22000 3 drm,intel_agp,intel_gtt, Live 0xf92a3000
> i2c_algo_bit 4584 1 i915, Live 0xf927f000
> i2c_core 16880 5 videodev,i915,drm_kms_helper,drm,i2c_algo_bit, Live 0xf9270000
> jme 32438 0 - Live 0xf90d1000
> intel_ips 10420 0 - Live 0xf90bd000
> mii 3440 1 jme, Live 0xf90b2000
> evdev 7663 25 - Live 0xf9082000
> lpc_ich 9374 0 - Live 0xf9066000
> psmouse 63392 0 - Live 0xf9031000
> asus_laptop 15635 0 - Live 0xf8f91000
> sparse_keymap 2533 1 asus_laptop, Live 0xf8f6e000
> input_polldev 2143 1 asus_laptop, Live 0xf8f67000
> ath9k 88678 0 - Live 0xf8f46000
> ath9k_common 1605 1 ath9k, Live 0xf8f1f000
> ath9k_hw 324321 2 ath9k,ath9k_common, Live 0xf8ebf000
> ath 12382 3 ath9k,ath9k_common,ath9k_hw, Live 0xf8e5a000
> mac80211 367308 1 ath9k, Live 0xf8ddf000
> cfg80211 153457 3 ath9k,ath,mac80211, Live 0xf8d28000
> rfkill 12569 6 bluetooth,asus_laptop,cfg80211, Live 0xf8ce8000
> serio_raw 3714 0 - Live 0xf8cd3000
> pcspkr 1456 0 - Live 0xf8cbb000
> wmi 7196 1 mxm_wmi, Live 0xf8cb2000
> video 9885 1 i915, Live 0xf8ca2000
> thermal 6660 0 - Live 0xf8c7c000
> battery 5214 0 - Live 0xf8c71000
> ac 1893 0 - Live 0xf8c60000
> button 3711 1 i915, Live 0xf8c55000
> microcode 8922 0 - Live 0xf8c39000
> snd_hda_intel 22353 6 - Live 0xf8c04000
> snd_hda_codec 83678 3
> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live
> 0xf8bd5000
> snd_hwdep 4843 1 snd_hda_codec, Live 0xf8bab000
> snd_pcm 62086 5 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xf8b88000
> snd_page_alloc 5934 2 snd_hda_intel,snd_pcm, Live 0xf8b68000
> snd_timer 14903 1 snd_pcm, Live 0xf8b5b000
> snd 45098 17 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
> Live 0xf8b3b000
> soundcore 4379 1 snd, Live 0xf8b1f000
> bbswitch 4291 0 - Live 0xf8b13000 (O)
> ext4 402657 3 - Live 0xf8a93000
> crc16 1092 2 bluetooth,ext4, Live 0xf8a02000
> jbd2 66384 1 ext4, Live 0xf89e6000
> mbcache 4387 1 ext4, Live 0xf89c3000
> sd_mod 27312 6 - Live 0xf89b0000
> ahci 18661 4 - Live 0xf8980000
> libahci 16876 1 ahci, Live 0xf896a000
> libata 146097 2 ahci,libahci, Live 0xf8929000
> scsi_mod 113073 2 sd_mod,libata, Live 0xf88a0000
> sdhci_pci 8910 0 - Live 0xf88d3000
> sdhci 20587 1 sdhci_pci, Live 0xf8899000
> mmc_core 73455 2 sdhci_pci,sdhci, Live 0xf8808000
> ehci_hcd 37165 0 - Live 0xf87de000
> usbcore 127212 3 btusb,uvcvideo,ehci_hcd, Live 0xf8781000
> usb_common 623 1 usbcore, Live 0xf8432000
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> 
> 0000-0cf7 : PCI Bus 0000:00
>   0000-001f : dma1
>   0020-0021 : pic1
>   0040-0043 : timer0
>   0050-0053 : timer1
>   0060-0060 : keyboard
>   0062-0062 : EC data
>   0064-0064 : keyboard
>   0066-0066 : EC cmd
>   0070-0077 : rtc0
>   0080-008f : dma page reg
>   00a0-00a1 : pic2
>   00c0-00df : dma2
>   00f0-00ff : fpu
>   0240-0259 : pnp 00:07
>   03c0-03df : vesafb
>   0400-047f : pnp 00:05
>     0400-0403 : ACPI PM1a_EVT_BLK
>     0404-0405 : ACPI PM1a_CNT_BLK
>     0408-040b : ACPI PM_TMR
>     0410-0415 : ACPI CPU throttle
>     0420-042f : ACPI GPE0_BLK
>     0430-0433 : iTCO_wdt
>       0430-0433 : iTCO_wdt
>     0450-0450 : ACPI PM2_CNT_BLK
>     0460-047f : iTCO_wdt
>       0460-047f : iTCO_wdt
>   0500-057f : pnp 00:05
>   0680-069f : pnp 00:05
> 0cf8-0cff : PCI conf1
> 0d00-ffff : PCI Bus 0000:00
>   164e-164f : pnp 00:05
>   9000-9fff : PCI Bus 0000:07
>     9000-90ff : 0000:07:00.5
>       9000-90ff : jme
>     9100-917f : 0000:07:00.5
>       9100-917f : jme
>   a000-afff : PCI Bus 0000:04
>   b000-bfff : PCI Bus 0000:03
>   c000-cfff : PCI Bus 0000:02
>   d000-dfff : PCI Bus 0000:01
>     d000-d07f : 0000:01:00.0
>   e020-e03f : 0000:00:1f.2
>     e020-e03f : ahci
>   e040-e043 : 0000:00:1f.2
>     e040-e043 : ahci
>   e050-e057 : 0000:00:1f.2
>     e050-e057 : ahci
>   e060-e063 : 0000:00:1f.2
>     e060-e063 : ahci
>   e070-e077 : 0000:00:1f.2
>     e070-e077 : ahci
>   e080-e087 : 0000:00:02.0
>   ff00-ff0f : pnp 00:05
>   ffff-ffff : pnp 00:05
>     ffff-ffff : pnp 00:05
> 
> 00000000-0000ffff : reserved
> 00010000-0009bbff : System RAM
> 0009bc00-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
>   000a0000-000bffff : Video RAM area
> 000c0000-000cefff : Video ROM
> 000d0000-000d3fff : PCI Bus 0000:00
> 000d4000-000d7fff : PCI Bus 0000:00
> 000d8000-000dbfff : PCI Bus 0000:00
> 000dc000-000dffff : PCI Bus 0000:00
> 000e0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-aace2fff : System RAM
>   01000000-013d9771 : Kernel code
>   013d9772-0155813f : Kernel data
>   015e2000-016c3fff : Kernel bss
> aace3000-aad32fff : ACPI Non-volatile Storage
> aad33000-aad43fff : reserved
> aad44000-aad57fff : ACPI Non-volatile Storage
> aad58000-aad60fff : reserved
> aad61000-aad68fff : ACPI Non-volatile Storage
> aad69000-aad80fff : reserved
> aad81000-aad81fff : ACPI Non-volatile Storage
> aad82000-aad90fff : reserved
> aad91000-aad95fff : ACPI Non-volatile Storage
> aad96000-aad99fff : reserved
> aad9a000-aad9cfff : ACPI Non-volatile Storage
> aad9d000-aad9efff : reserved
> aad9f000-aad9ffff : ACPI Non-volatile Storage
> aada0000-aada3fff : reserved
> aada4000-aada6fff : ACPI Tables
> aada7000-aadabfff : reserved
> aadac000-aadb9fff : ACPI Non-volatile Storage
> aadba000-aadcffff : reserved
> aadd0000-aadd1fff : ACPI Non-volatile Storage
> aadd2000-abffffff : reserved
> adc00000-afffffff : reserved
> b0000000-feafffff : PCI Bus 0000:00
>   b0000000-bfffffff : 0000:00:02.0
>   c0000000-d30fffff : PCI Bus 0000:01
>     c0000000-cfffffff : 0000:01:00.0
>     d0000000-d1ffffff : 0000:01:00.0
>     d2000000-d2ffffff : 0000:01:00.0
>     d3000000-d307ffff : 0000:01:00.0
>   d3100000-d32fffff : PCI Bus 0000:02
>   d3300000-d3300fff : Intel Flush Page
>   d3400000-d37fffff : 0000:00:02.0
>   d3800000-d4bfffff : PCI Bus 0000:07
>     d3800000-d3803fff : 0000:07:00.5
>       d3800000-d3803fff : jme
>     d3804000-d38040ff : 0000:07:00.2
>     d3805000-d38050ff : 0000:07:00.0
>       d3805000-d38050ff : mmc0
>   d4c00000-d5ffffff : PCI Bus 0000:04
>   d6000000-d73fffff : PCI Bus 0000:03
>     d6000000-d600ffff : 0000:03:00.0
>       d6000000-d600ffff : ath9k
>   d7400000-d87fffff : PCI Bus 0000:02
>   d8800000-d8803fff : 0000:00:1b.0
>     d8800000-d8803fff : ICH HD audio
>   d8804000-d8804fff : 0000:00:1f.6
>     d8804000-d8804fff : ips thermal sensor
>   d8805000-d8805fff : pnp 00:0a
>   d8806000-d88067ff : 0000:00:1f.2
>     d8806000-d88067ff : ahci
>   d8807000-d88073ff : 0000:00:1d.0
>     d8807000-d88073ff : ehci_hcd
>   d8808000-d88083ff : 0000:00:1a.0
>     d8808000-d88083ff : ehci_hcd
>   d880a000-d880a00f : 0000:00:16.0
>     d880a000-d880a00f : mei
>   d8900000-d8afffff : PCI Bus 0000:03
>   d8b00000-d8cfffff : PCI Bus 0000:04
>   d8d00000-d8efffff : PCI Bus 0000:07
>   dffff000-dfffffff : pnp 00:0a
>   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>     e0000000-efffffff : reserved
>       e0000000-efffffff : pnp 00:0a
> fec00000-fec00fff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fed00000-fed003ff : HPET 0
> fed10000-fed13fff : reserved
>   fed10000-fed13fff : pnp 00:0a
> fed18000-fed19fff : reserved
>   fed18000-fed18fff : pnp 00:0a
>   fed19000-fed19fff : pnp 00:0a
> fed1c000-fed1ffff : reserved
>   fed1c000-fed1ffff : pnp 00:0a
>     fed1f410-fed1f414 : iTCO_wdt
>       fed1f410-fed1f414 : iTCO_wdt
> fed20000-fed3ffff : pnp 00:0a
> fed45000-fed8ffff : pnp 00:0a
> fed90000-fed93fff : pnp 00:0a
>   fed90000-fed90fff : dmar0
>   fed91000-fed91fff : dmar1
>   fed93000-fed93fff : dmar2
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> ffa00000-ffbfffff : reserved
> ffe00000-ffffffff : reserved
> 100000000-147ffffff : System RAM
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> 
> 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 12)
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: <access denied>
> Kernel driver in use: agpgart-intel
> 
> 00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16
> Root Port (rev ff) (prog-if ff)
> !!! Unknown header type 7f
> Kernel driver in use: pcieport
> 
> 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> Integrated Graphics Controller (rev 12) (prog-if 00 [VGA controller])
> Subsystem: ASUSTeK Computer Inc. Device 1422
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 48
> Region 0: Memory at d3400000 (64-bit, non-prefetchable) [size=4M]
> Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
> Region 4: I/O ports at e080 [size=8]
> Expansion ROM at <unassigned> [disabled]
> Capabilities: <access denied>
> Kernel driver in use: i915
> 
> 00:16.0 Communication controller: Intel Corporation 5 Series/3400
> Series Chipset HECI Controller (rev 06)
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 47
> Region 0: Memory at d880a000 (64-bit, non-prefetchable) [size=16]
> Capabilities: <access denied>
> Kernel driver in use: mei
> 
> 00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 16
> Region 0: Memory at d8808000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: <access denied>
> Kernel driver in use: ehci_hcd
> 
> 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
> High Definition Audio (rev 06)
> Subsystem: ASUSTeK Computer Inc. Device 1153
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 46
> Region 0: Memory at d8800000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: <access denied>
> Kernel driver in use: snd_hda_intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> I/O behind bridge: 0000c000-0000cfff
> Memory behind bridge: d7400000-d87fffff
> Prefetchable memory behind bridge: 00000000d3100000-00000000d32fffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: <access denied>
> Kernel driver in use: pcieport
> 
> 00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 2 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> I/O behind bridge: 0000b000-0000bfff
> Memory behind bridge: d6000000-d73fffff
> Prefetchable memory behind bridge: 00000000d8900000-00000000d8afffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: <access denied>
> Kernel driver in use: pcieport
> 
> 00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 3 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=04, subordinate=06, sec-latency=0
> I/O behind bridge: 0000a000-0000afff
> Memory behind bridge: d4c00000-d5ffffff
> Prefetchable memory behind bridge: 00000000d8b00000-00000000d8cfffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: <access denied>
> Kernel driver in use: pcieport
> 
> 00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 6 (rev 06) (prog-if 00 [Normal decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
> I/O behind bridge: 00009000-00009fff
> Memory behind bridge: d3800000-d4bfffff
> Prefetchable memory behind bridge: 00000000d8d00000-00000000d8efffff
> Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: <access denied>
> Kernel driver in use: pcieport
> 
> 00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin A routed to IRQ 23
> Region 0: Memory at d8807000 (32-bit, non-prefetchable) [size=1K]
> Capabilities: <access denied>
> Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
> (prog-if 01 [Subtractive decode])
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Bus: primary=00, secondary=08, subordinate=08, sec-latency=32
> I/O behind bridge: 0000f000-00000fff
> Memory behind bridge: fff00000-000fffff
> Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> Capabilities: <access denied>
> 
> 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
> Interface Controller (rev 06)
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Capabilities: <access denied>
> Kernel driver in use: lpc_ich
> 
> 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series
> Chipset 4 port SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin B routed to IRQ 45
> Region 0: I/O ports at e070 [size=8]
> Region 1: I/O ports at e060 [size=4]
> Region 2: I/O ports at e050 [size=8]
> Region 3: I/O ports at e040 [size=4]
> Region 4: I/O ports at e020 [size=32]
> Region 5: Memory at d8806000 (32-bit, non-prefetchable) [size=2K]
> Capabilities: <access denied>
> Kernel driver in use: ahci
> 
> 00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
> Series Chipset Thermal Subsystem (rev 06)
> Subsystem: ASUSTeK Computer Inc. Device 1c77
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> Interrupt: pin C routed to IRQ 18
> Region 0: Memory at d8804000 (64-bit, non-prefetchable) [size=4K]
> Capabilities: <access denied>
> Kernel driver in use: intel ips
> 
> 01:00.0 VGA compatible controller: NVIDIA Corporation GT215 [GeForce
> GT 335M] (rev ff) (prog-if ff)
> !!! Unknown header type 7f
> 
> 03:00.0 Network controller: Atheros Communications Inc. AR9285
> Wireless Network Adapter (PCI-Express) (rev 01)
> Subsystem: AzureWave AW-NE785 / AW-NE785H 802.11bgn Wireless Full or
> Half-size Mini PCIe Card
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 17
> Region 0: Memory at d6000000 (64-bit, non-prefetchable) [size=64K]
> Capabilities: <access denied>
> Kernel driver in use: ath9k
> 
> 07:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host
> Controller (rev 80)
> Subsystem: ASUSTeK Computer Inc. Device 1a07
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin B routed to IRQ 18
> Region 0: Memory at d3805000 (32-bit, non-prefetchable) [size=256]
> Capabilities: <access denied>
> Kernel driver in use: sdhci-pci
> 
> 07:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host
> Controller (rev 80) (prog-if 01)
> Subsystem: ASUSTeK Computer Inc. Device 1a07
> Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Interrupt: pin B routed to IRQ 18
> Region 0: Memory at d3804000 (32-bit, non-prefetchable) [size=256]
> Capabilities: <access denied>
> 
> 07:00.5 Ethernet controller: JMicron Technology Corp. JMC250 PCI
> Express Gigabit Ethernet Controller (rev 03)
> Subsystem: ASUSTeK Computer Inc. Device 1905
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 49
> Region 0: Memory at d3800000 (32-bit, non-prefetchable) [size=16K]
> Region 2: I/O ports at 9100 [size=128]
> Region 3: I/O ports at 9000 [size=256]
> Capabilities: <access denied>
> Kernel driver in use: jme
> 
> ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture Generic Non-core Registers (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture System Address Decoder (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
> Subsystem: Intel Corporation Device 8086
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> 
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: ST9500420AS      Rev: 0003
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: OCZ-AGILITY3     Rev: 2.15
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> 
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> 
> (1) I'm using a laptop with both concrete Intel HD Graphics and NVIDIA
> GT520M, but I used some kernel modules (like bbswitch or acpi_call) to
> turn the latter off. They are used for most of the time, and the
> panics happen during these time. I don't know if it's relevant.
> 
> (2) Another special point of my laptop's hardware is that I removed
> the DVD-R* and added a SSD with a weird "tray" to put it on. Don't
> know if relevant either.
> 
> (3) Intel driver versions: xf86-video-intel 2.20.16-1 // intel-dri 9.0.1-1
> 
> (4) Watching videos in a VirtualBox VM won't cause any problem.
> 
> [X.] Other notes, patches, fixes, workarounds:
> 
> Thank you for paying attention to this weird bug. I know the
> information I provided is not solid, but since the panics happen
> randomly, and I don't know how to dig deeper about the panics, so I
> want to know if you can help me out.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
Boris.
