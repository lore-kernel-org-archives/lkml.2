Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0DBKCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:02:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:49002 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab0DBKCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:02:05 -0400
Date: Fri, 2 Apr 2010 12:02:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Troilo, Domenic" <Domenic.Troilo@gwl.ca>
Cc: linux-kernel@vger.kernel.org, Maik Broemme <mbroemme@plusserver.de>,
       linux-fbdev@vger.kernel.org
Subject: Re: PROBLEM: intelfb driver causes trace
In-Reply-To: <CBF11783AA883E41A86C009F3AE5D47F0CAE08C1@GWCORPMAIL4.gwl.bz>
Message-ID: <alpine.LRH.2.00.1004021201170.20810@twin.jikos.cz>
References: <CBF11783AA883E41A86C009F3AE5D47F0CAE08C1@GWCORPMAIL4.gwl.bz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding some appropriate CCs ]

On Thu, 1 Apr 2010, Troilo, Domenic wrote:

> [1.] One line summary of the problem:     intelfb driver causes trace
> [2.] Full description of the problem/report: upon boot of system, no
> longer see data on console, as the intelfb driver abends
> [3.] Keywords (i.e., modules, networking, kernel): modules, framebuffer,
> intelfb
> [4.] Kernel version (from /proc/version): Linux version 2.6.33.1

Does it happen with current latest Linus' git as well?

> (root@upstairs) (gcc version 4.3.2 (Debian 4.3.2-1.1) )
> [5.] Output of Oops.. message (if applicable) with symbolic information 
>      resolved (see Documentation/oops-tracing.txt)
> Mar 31 07:02:04 upstairs kernel: ------------[ cut here ]------------
> Mar 31 07:02:04 upstairs kernel: WARNING: at
> drivers/video/intelfb/intelfbhw.c:491 intelfbhw_active_pipe+0x52/0x55
> [intelfb]()
> Mar 31 07:02:04 upstairs kernel: Hardware name: DFDFGDF
> Mar 31 07:02:04 upstairs kernel: Modules linked in: intelfb(+)
> snd_intel8x0 snd_emu10k1_synth snd_emux_synth snd_seq_virmidi
> snd_seq_midi_emul snd_emu10k1 snd_ac97_codec stv0299 ac97_bus
> snd_pcm_oss rtl8187 snd_mixer_oss snd_pcm mac80211 led_class cfg80211
> snd_util_mem eeprom_93cx6 snd_hwdep ati_remote snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event rtc_cmos rtc_core rtc_lib
> snd_seq snd_timer snd_seq_device budget_ci 8250_pnp 8250 ir_common
> budget_core serial_core snd dvb_core saa7146 ttpci_eeprom ehci_hcd
> ir_core e1000 uhci_hcd parport_pc parport intel_agp usbcore pcspkr
> psmouse soundcore i2c_i801 agpgart snd_page_alloc evdev
> Mar 31 07:02:04 upstairs kernel: Pid: 1477, comm: modprobe Not tainted
> 2.6.33.1 #2
> Mar 31 07:02:04 upstairs kernel: Call Trace:
> Mar 31 07:02:04 upstairs kernel:  [<f87846a9>] ?
> intelfbhw_active_pipe+0x52/0x55 [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<f87846a9>] ?
> intelfbhw_active_pipe+0x52/0x55 [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<c10290b6>] ?
> warn_slowpath_common+0x67/0xb0
> Mar 31 07:02:04 upstairs kernel:  [<f87846a9>] ?
> intelfbhw_active_pipe+0x52/0x55 [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<c1029112>] ?
> warn_slowpath_null+0x13/0x17
> Mar 31 07:02:04 upstairs kernel:  [<f87846a9>] ?
> intelfbhw_active_pipe+0x52/0x55 [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<f878735e>] ?
> intelfb_pci_register+0x112e/0x13cb [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<c118f2ef>] ?
> ida_get_new_above+0x7c/0x1d4
> Mar 31 07:02:04 upstairs kernel:  [<c11a30d0>] ? local_pci_probe+0xb/0xc
> Mar 31 07:02:04 upstairs kernel:  [<c11a31d8>] ?
> pci_device_probe+0x4e/0x69
> Mar 31 07:02:04 upstairs kernel:  [<c121b030>] ?
> driver_probe_device+0x50/0x13f
> Mar 31 07:02:04 upstairs kernel:  [<c121b184>] ?
> __driver_attach+0x65/0x67
> Mar 31 07:02:04 upstairs kernel:  [<c11a3141>] ?
> pci_device_remove+0x0/0x36
> Mar 31 07:02:04 upstairs kernel:  [<c121aa04>] ?
> bus_for_each_dev+0x47/0x65
> Mar 31 07:02:04 upstairs kernel:  [<c11a3141>] ?
> pci_device_remove+0x0/0x36
> Mar 31 07:02:04 upstairs kernel:  [<c121af26>] ? driver_attach+0x16/0x1a
> Mar 31 07:02:04 upstairs kernel:  [<c121b11f>] ?
> __driver_attach+0x0/0x67
> Mar 31 07:02:04 upstairs kernel:  [<c121a42b>] ?
> bus_add_driver+0x1de/0x297
> Mar 31 07:02:04 upstairs kernel:  [<c11a3141>] ?
> pci_device_remove+0x0/0x36
> Mar 31 07:02:04 upstairs kernel:  [<c121b38d>] ?
> driver_register+0x67/0x12e
> Mar 31 07:02:04 upstairs kernel:  [<f878c000>] ? intelfb_init+0x0/0x50
> [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<c11a33af>] ?
> __pci_register_driver+0x2b/0x82
> Mar 31 07:02:04 upstairs kernel:  [<f878c000>] ? intelfb_init+0x0/0x50
> [intelfb]
> Mar 31 07:02:04 upstairs kernel:  [<c1001022>] ?
> do_one_initcall+0x22/0x15b
> Mar 31 07:02:04 upstairs kernel:  [<c1050bb1>] ?
> sys_init_module+0xac/0x21b
> Mar 31 07:02:04 upstairs kernel:  [<c13033ad>] ? syscall_call+0x7/0xb
> Mar 31 07:02:04 upstairs kernel: ---[ end trace f43ebebb5719a058 ]---
> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible) (N/A)
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux upstairs 2.6.33.1 #2 Tue Mar 30 09:07:24 CDT 2010 i686 GNU/Linux
> 
> Gnu C                  4.3.2
> Gnu make               3.81
> binutils               2.18.0.20080103
> util-linux             2.13.1.1
> mount                  2.13.1.1
> module-init-tools      3.4
> e2fsprogs              1.41.3
> jfsutils               1.1.12
> reiserfsprogs          3.6.19
> xfsprogs               2.9.8
> PPP                    2.4.4
> Linux C Library        2.7
> Dynamic linker (ldd)   2.7
> Linux C++ Library      6..
> Procps                 3.2.7
> Net-tools              1.60
> Console-tools          0.2.3
> oprofile               0.9.3
> Sh-utils               6.10
> udev                   125
> wireless-tools         29
> Modules Loaded         i915 drm_kms_helper drm i2c_algo_bit video output
> intelfb snd_intel8x0 snd_emu10k1_synth snd_emux_synth snd_seq_virmidi
> snd_seq_midi_emul snd_emu10k1 snd_ac97_codec stv0299 ac97_bus
> snd_pcm_oss rtl8187 snd_mixer_oss snd_pcm mac80211 led_class cfg80211
> snd_util_mem eeprom_93cx6 snd_hwdep ati_remote snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event rtc_cmos rtc_core rtc_lib
> snd_seq snd_timer snd_seq_device budget_ci 8250_pnp 8250 ir_common
> budget_core serial_core snd dvb_core saa7146 ttpci_eeprom ehci_hcd
> ir_core e1000 uhci_hcd parport_pc parport intel_agp usbcore pcspkr
> psmouse soundcore i2c_i801 agpgart snd_page_alloc evdev
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 3
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 4
> cpu MHz         : 2992.556
> cache size      : 1024 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> constant_tsc pebs bts pni dtes64 monitor ds_cpl cid xtpr
> bogomips        : 5985.11
> clflush size    : 64
> cache_alignment : 128
> address sizes   : 36 bits physical, 32 bits virtual
> power management:
> 
> [7.3.] Module information (from /proc/modules):
> i915 246706 0 - Live 0xfd882000
> drm_kms_helper 22567 1 i915, Live 0xf808c000
> drm 123895 2 i915,drm_kms_helper, Live 0xf8099000
> i2c_algo_bit 4155 1 i915, Live 0xf8078000
> video 15302 1 i915, Live 0xf8058000
> output 1308 1 video, Live 0xf803a000
> intelfb 36037 0 - Live 0xf8781000
> snd_intel8x0 21195 3 - Live 0xf8739000
> snd_emu10k1_synth 4296 0 - Live 0xf8725000
> snd_emux_synth 26814 1 snd_emu10k1_synth, Live 0xf8713000
> snd_seq_virmidi 3380 1 snd_emux_synth, Live 0xf8701000
> snd_seq_midi_emul 4381 1 snd_emux_synth, Live 0xf86f5000
> snd_emu10k1 118517 1 snd_emu10k1_synth, Live 0xf86c9000
> snd_ac97_codec 82864 2 snd_intel8x0,snd_emu10k1, Live 0xf867e000
> stv0299 7156 1 - Live 0xf8656000
> ac97_bus 750 1 snd_ac97_codec, Live 0xf864a000
> snd_pcm_oss 31843 0 - Live 0xf8639000
> rtl8187 51426 0 - Live 0xf8618000
> snd_mixer_oss 13102 1 snd_pcm_oss, Live 0xf85fa000
> snd_pcm 51817 5 snd_intel8x0,snd_emu10k1,snd_ac97_codec,snd_pcm_oss,
> Live 0xf8479000
> mac80211 140205 1 rtl8187, Live 0xf8431000
> led_class 1869 1 rtl8187, Live 0xf83f8000
> cfg80211 102949 2 rtl8187,mac80211, Live 0xf83ce000
> snd_util_mem 1648 2 snd_emux_synth,snd_emu10k1, Live 0xf839f000
> eeprom_93cx6 984 1 rtl8187, Live 0xf8395000
> snd_hwdep 4430 2 snd_emux_synth,snd_emu10k1, Live 0xf838b000
> ati_remote 6643 0 - Live 0xf837e000
> snd_seq_dummy 971 0 - Live 0xf8372000
> snd_seq_oss 21693 0 - Live 0xf8362000
> snd_seq_midi 3784 0 - Live 0xf8351000
> snd_rawmidi 13375 3 snd_seq_virmidi,snd_emu10k1,snd_seq_midi, Live
> 0xf8341000
> snd_seq_midi_event 3908 3 snd_seq_virmidi,snd_seq_oss,snd_seq_midi, Live
> 0xf8331000
> rtc_cmos 6237 0 - Live 0xf8325000
> rtc_core 9725 1 rtc_cmos, Live 0xf8316000
> rtc_lib 1513 1 rtc_core, Live 0xf8308000
> snd_seq 34165 9
> snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_o
> ss,snd_seq_midi,snd_seq_midi_event, Live 0xf82f3000
> snd_timer 13776 4 snd_emu10k1,snd_pcm,snd_seq, Live 0xf82d9000
> snd_seq_device 4025 8
> snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,s
> nd_seq_midi,snd_rawmidi,snd_seq, Live 0xf82ca000
> budget_ci 17145 16 - Live 0xf82ba000
> 8250_pnp 3516 0 - Live 0xf82a8000
> 8250 15643 1 8250_pnp, Live 0xf8296000
> ir_common 24862 1 budget_ci, Live 0xf827b000
> budget_core 5480 1 budget_ci, Live 0xf8268000
> serial_core 12309 1 8250, Live 0xf8258000
> snd 37125 18
> snd_intel8x0,snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_ac97_codec,s
> nd_pcm_oss,snd_mixer_oss,snd_pcm,snd_hwdep,snd_seq_oss,snd_rawmidi,snd_s
> eq,snd_timer,snd_seq_device, Live 0xf823b000
> dvb_core 70731 3 stv0299,budget_ci,budget_core, Live 0xf816b000
> saa7146 11878 2 budget_ci,budget_core, Live 0xf8162000
> ttpci_eeprom 1336 1 budget_core, Live 0xf812f000
> ehci_hcd 30231 0 - Live 0xf80f4000
> ir_core 3362 2 budget_ci,ir_common, Live 0xf807f000
> e1000 87249 0 - Live 0xf8117000
> uhci_hcd 17623 0 - Live 0xf8062000
> parport_pc 15269 0 - Live 0xf8052000
> parport 13758 1 parport_pc, Live 0xf802d000
> intel_agp 21611 1 - Live 0xf8101000
> usbcore 107876 5 rtl8187,ati_remote,ehci_hcd,uhci_hcd, Live 0xf80ca000
> pcspkr 1283 0 - Live 0xf8096000
> psmouse 29985 0 - Live 0xf8082000
> soundcore 4175 1 snd, Live 0xf806a000
> i2c_i801 6372 0 - Live 0xf805e000
> agpgart 21944 4 drm,intelfb,intel_agp, Live 0xf804a000
> snd_page_alloc 5297 3 snd_intel8x0,snd_emu10k1,snd_pcm, Live 0xf8036000
> evdev 6392 5 - Live 0xf8029000
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports,
> /proc/iomem)
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-0060 : keyboard
> 0064-0064 : keyboard
> 0070-0071 : rtc0
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00e1-00e1 : #ENUM hotswap signal register
> 00f0-00ff : fpu
> 0170-0177 : 0000:00:1f.1
>   0170-0177 : ata_piix
> 01f0-01f7 : 0000:00:1f.1
>   01f0-01f7 : ata_piix
> 02f8-02ff : serial
> 0376-0376 : 0000:00:1f.1
>   0376-0376 : ata_piix
> 0378-037a : parport0
> 03f2-03f2 : floppy
> 03f4-03f5 : floppy
> 03f6-03f6 : 0000:00:1f.1
>   03f6-03f6 : ata_piix
> 03f7-03f7 : floppy
> 03f8-03ff : serial
> 04d0-04d1 : pnp 00:01
> 0800-087f : pnp 00:01
> 0cf8-0cff : PCI conf1
> 1000-107f : 0000:00:1f.0
>   1000-107f : pnp 00:01
>     1000-1003 : ACPI PM1a_EVT_BLK
>     1008-100b : ACPI PM_TMR
>     1010-1015 : ACPI CPU throttle
>     1028-102f : ACPI GPE0_BLK
> 1100-111f : pnp 00:01
> 1180-11bf : 0000:00:1f.0
>   1180-11bf : pnp 00:01
> 1800-1807 : 0000:00:02.0
> 1810-181f : 0000:00:1f.1
>   1810-181f : ata_piix
> 1820-183f : 0000:00:1d.0
>   1820-183f : uhci_hcd
> 1840-185f : 0000:00:1d.1
>   1840-185f : uhci_hcd
> 1860-187f : 0000:00:1d.2
>   1860-187f : uhci_hcd
> 1880-189f : 0000:00:1d.3
>   1880-189f : uhci_hcd
> 18a0-18bf : 0000:00:1f.3
> 18c0-18ff : 0000:00:1f.5
>   18c0-18ff : Intel ICH5
> 1c00-1cff : 0000:00:1f.5
>   1c00-1cff : Intel ICH5
> 2000-2fff : PCI Bus 0000:03
>   2000-203f : 0000:03:0b.0
>     2000-203f : e1000
> e000-e00f : pnp 00:01
> fe00-fe00 : pnp 00:01
> fe10-fe11 : pnp 00:01
>   fe10-fe11 : ACPI PM1a_CNT_BLK
> 
> 00000000-0009f7ff : System RAM
> 0009f800-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000ca5ff : Video ROM
> 000e0000-000fffff : reserved
>   000f0000-000fffff : System ROM
> 00100000-3df6ffff : System RAM
>   01000000-0130450f : Kernel code
>   01304510-014579f7 : Kernel data
>   014b1000-014f8abf : Kernel bss
> 3df70000-3df79fff : ACPI Tables
> 3df7a000-3df7ffff : ACPI Non-volatile Storage
> 3df80000-3fffffff : reserved
> 40000000-400003ff : 0000:00:1f.1
> d0000000-d007ffff : 0000:00:02.0
>   d0000000-d007ffff : intelfb
> d0080000-d00803ff : 0000:00:1d.7
>   d0080000-d00803ff : ehci_hcd
> d0080800-d00808ff : 0000:00:1f.5
>   d0080800-d00808ff : Intel ICH5
> d0080c00-d0080dff : 0000:00:1f.5
>   d0080c00-d0080dff : Intel ICH5
> d0100000-d01fffff : PCI Bus 0000:03
>   d0100000-d011ffff : 0000:03:0b.0
>     d0100000-d011ffff : e1000
>   d0120000-d01201ff : 0000:03:0a.0
>     d0120000-d01201ff : saa7146
> d8000000-dfffffff : 0000:00:02.0
>   d8000000-dfffffff : intelfb
> e0000000-efffffff : 0000:00:00.0
> fec00000-fec0ffff : reserved
>   fec00000-fec003ff : IOAPIC 0
> fecf0000-fecf0fff : 0000:00:06.0
> fed20000-fed8ffff : pnp 00:01
> fed90000-fed903ff : pnp 00:01
> fee00000-fee00fff : Local APIC
>   fee00000-fee00fff : reserved
> ff800000-ffffffff : reserved
> 
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM
> Controller/Host-Hub Interface (rev 02)
>         Subsystem: Intel Corporation 82865G/PE/P DRAM
> Controller/Host-Hub Interface
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR- INTx-
>         Latency: 0
>         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
>         Capabilities: [e4] Vendor Specific Information <?>
>         Kernel driver in use: agpgart-intel
>         Kernel modules: intel-agp
> 
> 00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated
> Graphics Controller (rev 02) (prog-if 00 [VGA controller])
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
>         Region 1: Memory at d0000000 (32-bit, non-prefetchable)
> [size=512K]
>         Region 2: I/O ports at 1800 [size=8]
>         Capabilities: [d0] Power Management version 1
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: intelfb
>         Kernel modules: i915, intelfb
> 
> 00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to
> I/O Memory Interface (rev 02)
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Region 0: Memory at fecf0000 (32-bit, non-prefetchable)
> [size=4K]
> 
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16
>         Region 4: I/O ports at 1820 [size=32]
>         Kernel driver in use: uhci_hcd
>         Kernel modules: uhci-hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 19
>         Region 4: I/O ports at 1840 [size=32]
>         Kernel driver in use: uhci_hcd
>         Kernel modules: uhci-hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 18
>         Region 4: I/O ports at 1860 [size=32]
>         Kernel driver in use: uhci_hcd
>         Kernel modules: uhci-hcd
> 
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16
>         Region 4: I/O ports at 1880 [size=32]
>         Kernel driver in use: uhci_hcd
>         Kernel modules: uhci-hcd
> 
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2
> EHCI Controller (rev 02) (prog-if 20 [EHCI])
>         Subsystem: IBM Device 0287
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin D routed to IRQ 23
>         Region 0: Memory at d0080000 (32-bit, non-prefetchable)
> [size=1K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Kernel driver in use: ehci_hcd
>         Kernel modules: ehci-hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if
> 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=248
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: d0100000-d01fffff
>         Prefetchable memory behind bridge: fff00000-000fffff
>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
> Interface Bridge (rev 02)
>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
> 
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
> Controller (rev 02) (prog-if 8a [Master SecP PriP])
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx+
>         Latency: 0
>         Interrupt: pin A routed to IRQ 18
>         Region 0: I/O ports at 01f0 [size=8]
>         Region 1: I/O ports at 03f4 [size=1]
>         Region 2: I/O ports at 0170 [size=8]
>         Region 3: I/O ports at 0374 [size=1]
>         Region 4: I/O ports at 1810 [size=16]
>         Region 5: Memory at 40000000 (32-bit, non-prefetchable)
> [size=1K]
>         Kernel driver in use: ata_piix
> 
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus
> Controller (rev 02)
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin B routed to IRQ 17
>         Region 4: I/O ports at 18a0 [size=32]
>         Kernel modules: i2c-i801
> 
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER
> (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 17
>         Region 0: I/O ports at 1c00 [size=256]
>         Region 1: I/O ports at 18c0 [size=64]
>         Region 2: Memory at d0080c00 (32-bit, non-prefetchable)
> [size=512]
>         Region 3: Memory at d0080800 (32-bit, non-prefetchable)
> [size=256]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: Intel ICH
>         Kernel modules: snd-intel8x0
> 
> 03:0a.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH
> Technotrend-Budget/Hauppauge WinTV-NOVA-CI DVB card
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 123 (3750ns min, 9500ns max)
>         Interrupt: pin A routed to IRQ 22
>         Region 0: Memory at d0120000 (32-bit, non-prefetchable)
> [size=512]
>         Kernel driver in use: budget_ci dvb
>         Kernel modules: budget-ci
> 
> 03:0b.0 Ethernet controller: Intel Corporation 82541EI Gigabit Ethernet
> Controller
>         Subsystem: IBM Device 0287
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 52 (63750ns min), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at d0100000 (32-bit, non-prefetchable)
> [size=128K]
>         Region 2: I/O ports at 2000 [size=64]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>         Capabilities: [e4] PCI-X non-bridge device
>                 Command: DPERE- ERO+ RBC=512 OST=1
>                 Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple
> DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
>         Capabilities: [f0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Kernel driver in use: e1000
>         Kernel modules: e1000
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: WDC WD800JB-00JJ Rev: 05.0
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>   Vendor: HL-DT-ST Model: DVD-ROM GDR8164B Rev: 0M08
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> 
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> upstairs:/usr/src/linux-2.6.33.1# cat /proc/fb
> 0 Intel(R) 865G
> 
> [X.] Other notes, patches, fixes, workarounds:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

