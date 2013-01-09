Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab3AIQUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:20:05 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:62174 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3AIQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:20:01 -0500
Message-ID: <50ED98AA.1090304@gmail.com>
Date: Wed, 09 Jan 2013 17:19:54 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
References: <50ED371A.3080903@gmail.com> <20130109120732.GA8016@liondog.tnic>
In-Reply-To: <20130109120732.GA8016@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.7.1 without staging modules I still get kernel panics, but
with 3.8.0-rc2 it looks like it's working correctly - I've tried the
unplug/plug sequence more than 5 times and it seems to work fine.

On 09/01/13 13:07, Borislav Petkov wrote:
> Looks like some corruption in the RB timer queue, AFAICT. Let's add some
> timer people to CC.
> 
> Adrian, can you try reproducing without the staging modules you have
> enabled? Make sure they're disabled in menuconfig and removed from
> /lib/modules/... so that they don't get loaded.
> 
> Also, can you try to reproduce with the latest linus tree from git?
> 
> Leaving in the rest for reference.
> 
> Thanks.
> 
> On Wed, Jan 09, 2013 at 10:23:38AM +0100, Adrian Byszuk wrote:
>> Hello!
>>
>> I want to report a bug resulting in kernel panic.
>> It happens always when I plug in AC adapter, at least happened 3 times
>> in a row - I didn't test it further.
>> Spotted on a vanilla 3.7.1 kernel. Kernel config attached.
>>
>> Pictures of 2 screens with kernel panic:
>> http://postimage.org/image/wg80pi5e3/
>> http://postimage.org/image/obzwkriyz/
>>
>>
>> adrian:~$ cat /proc/version
>> Linux version 3.7.1 (root@adrian-lap) (gcc version 4.7.2 (Debian
>> 4.7.2-4) ) #10 SMP PREEMPT Thu Dec 27 23:27:04 CET 2012
>>
>>
>> adrian:~/linux/kernel/linux-stable$ ./scripts/ver_linux
>> If some fields are empty or look unusual you may have an old version.
>> Compare to the current minimal requirements in Documentation/Changes.
>>
>> Linux adrian-lap 3.7.1 #10 SMP PREEMPT Thu Dec 27 23:27:04 CET 2012
>> x86_64 GNU/Linux
>>
>> Gnu C                  4.7
>> Gnu make               3.81
>> binutils               2.22
>> util-linux             ./scripts/ver_linux: 23: ./scripts/ver_linux:
>> fdformat: not found
>> mount                  support
>> module-init-tools      found
>> Linux C Library        2.13
>> Dynamic linker (ldd)   2.13
>> Procps                 3.3.3
>> Kbd                    1.15.3
>> Sh-utils               8.13
>> Modules Loaded         usb_storage hid_generic usbhid hid bnep rfcomm
>> binfmt_misc i8k uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc
>> nls_utf8 nls_cp437 vfat fat joydev loop firewire_sbp2 firewire_core
>> crc_itu_t arc4 snd_hda_codec_hdmi snd_hda_codec_conexant ath9k
>> snd_hda_intel ath9k_common snd_hda_codec ath9k_hw snd_hwdep coretemp ath
>> snd_pcm mac80211 uvcvideo crc32c_intel radeon snd_page_alloc snd_seq
>> ghash_clmulni_intel ath3k snd_seq_device videobuf2_vmalloc btusb
>> videobuf2_memops aesni_intel snd_timer iTCO_wdt videobuf2_core bluetooth
>> aes_x86_64 iTCO_vendor_support cfg80211 videodev acpi_cpufreq psmouse
>> ablk_helper mperf snd lpc_ich cryptd dell_wmi dell_laptop rts5139 media
>> sparse_keymap xts lrw dcdbas gf128mul rfkill i2c_i801 pcspkr serio_raw
>> soundcore mei mfd_core ttm wmi battery ac evdev processor ext4 crc16
>> jbd2 mbcache sg sr_mod cdrom ahci i915 microcode libahci r8169 mii
>> ehci_hcd xhci_hcd usbcore usb_common drm_kms_helper video thermal_sys button
>>
>>
>> adrian:~/linux/kernel/linux-stable$ cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 0
>> cpu cores       : 4
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 1
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 0
>> cpu cores       : 4
>> apicid          : 1
>> initial apicid  : 1
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 2
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 1
>> cpu cores       : 4
>> apicid          : 2
>> initial apicid  : 2
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 3
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 1
>> cpu cores       : 4
>> apicid          : 3
>> initial apicid  : 3
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 4
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 2
>> cpu cores       : 4
>> apicid          : 4
>> initial apicid  : 4
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 5
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 2
>> cpu cores       : 4
>> apicid          : 5
>> initial apicid  : 5
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 6
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 3
>> cpu cores       : 4
>> apicid          : 6
>> initial apicid  : 6
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 7
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 58
>> model name      : Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz
>> stepping        : 9
>> microcode       : 0x15
>> cpu MHz         : 1200.000
>> cache size      : 6144 KB
>> physical id     : 0
>> siblings        : 8
>> core id         : 3
>> cpu cores       : 4
>> apicid          : 7
>> initial apicid  : 7
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
>> xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
>> xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
>> smep erms
>> bogomips        : 4190.30
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>>
>> adrian:~/linux/kernel/linux-stable$ cat /proc/modules
>> usb_storage 51993 1 - Live 0xffffffffa078f000
>> hid_generic 12386 0 - Live 0xffffffffa0759000
>> usbhid 44588 0 - Live 0xffffffffa0783000
>> hid 93561 2 hid_generic,usbhid, Live 0xffffffffa0765000
>> bnep 17429 2 - Live 0xffffffffa075f000
>> rfcomm 37039 12 - Live 0xffffffffa074e000
>> binfmt_misc 16982 1 - Live 0xffffffffa0748000
>> i8k 13059 0 - Live 0xffffffffa073e000
>> uinput 17362 1 - Live 0xffffffffa06d9000
>> nfsd 237022 2 - Live 0xffffffffa0703000
>> auth_rpcgss 37162 1 nfsd, Live 0xffffffffa0651000
>> nfs_acl 12512 1 nfsd, Live 0xffffffffa049b000
>> nfs 131531 0 - Live 0xffffffffa06e1000
>> lockd 71225 2 nfsd,nfs, Live 0xffffffffa06c6000
>> fscache 40128 1 nfs, Live 0xffffffffa04a8000
>> sunrpc 190277 6 nfsd,auth_rpcgss,nfs_acl,nfs,lockd, Live 0xffffffffa0696000
>> nls_utf8 12457 2 - Live 0xffffffffa0496000
>> nls_cp437 16554 2 - Live 0xffffffffa0460000
>> vfat 17186 2 - Live 0xffffffffa0466000
>> fat 53501 1 vfat, Live 0xffffffffa0451000
>> joydev 17109 0 - Live 0xffffffffa038c000
>> loop 26561 0 - Live 0xffffffffa0449000
>> firewire_sbp2 21754 0 - Live 0xffffffffa0310000
>> firewire_core 56646 1 firewire_sbp2, Live 0xffffffffa0377000
>> crc_itu_t 12348 1 firewire_core, Live 0xffffffffa02e9000
>> arc4 12544 2 - Live 0xffffffffa02cc000
>> snd_hda_codec_hdmi 35497 1 - Live 0xffffffffa0427000
>> snd_hda_codec_conexant 53557 1 - Live 0xffffffffa0418000
>> ath9k 103329 0 - Live 0xffffffffa067b000
>> snd_hda_intel 30563 3 - Live 0xffffffffa0278000
>> ath9k_common 12729 1 ath9k, Live 0xffffffffa01e1000
>> snd_hda_codec 103985 3
>> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live
>> 0xffffffffa0660000
>> ath9k_hw 356764 2 ath9k,ath9k_common, Live 0xffffffffa05f8000
>> snd_hwdep 13149 1 snd_hda_codec, Live 0xffffffffa0431000
>> coretemp 12855 0 - Live 0xffffffffa02ba000
>> ath 21418 3 ath9k,ath9k_common,ath9k_hw, Live 0xffffffffa04a1000
>> snd_pcm 79843 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
>> 0xffffffffa0481000
>> mac80211 432417 1 ath9k, Live 0xffffffffa058d000
>> uvcvideo 78915 0 - Live 0xffffffffa046c000
>> crc32c_intel 12748 0 - Live 0xffffffffa036d000
>> radeon 850561 0 - Live 0xffffffffa04bc000
>> snd_page_alloc 17115 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0386000
>> snd_seq 52931 0 - Live 0xffffffffa040a000
>> ghash_clmulni_intel 13022 0 - Live 0xffffffffa0372000
>> ath3k 12686 0 - Live 0xffffffffa028c000
>> snd_seq_device 13133 1 snd_seq, Live 0xffffffffa025e000
>> videobuf2_vmalloc 12621 1 uvcvideo, Live 0xffffffffa0259000
>> btusb 17301 0 - Live 0xffffffffa01db000
>> videobuf2_memops 12563 1 videobuf2_vmalloc, Live 0xffffffffa04b7000
>> aesni_intel 54761 1 - Live 0xffffffffa043a000
>> snd_timer 26607 2 snd_pcm,snd_seq, Live 0xffffffffa02c4000
>> iTCO_wdt 12832 0 - Live 0xffffffffa030b000
>> videobuf2_core 30729 1 uvcvideo, Live 0xffffffffa02e0000
>> bluetooth 192117 25 bnep,rfcomm,ath3k,btusb, Live 0xffffffffa03da000
>> aes_x86_64 16844 1 aesni_intel, Live 0xffffffffa0305000
>> iTCO_vendor_support 12650 1 iTCO_wdt, Live 0xffffffffa0220000
>> cfg80211 179218 3 ath9k,ath,mac80211, Live 0xffffffffa0392000
>> videodev 104105 2 uvcvideo,videobuf2_core, Live 0xffffffffa03bf000
>> acpi_cpufreq 13055 1 - Live 0xffffffffa0217000
>> psmouse 76664 0 - Live 0xffffffffa023b000
>> ablk_helper 12573 1 aesni_intel, Live 0xffffffffa0203000
>> mperf 12412 1 acpi_cpufreq, Live 0xffffffffa0208000
>> snd 60885 15
>> snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer,
>> Live 0xffffffffa022b000
>> lpc_ich 16666 0 - Live 0xffffffffa01fd000
>> cryptd 14560 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
>> 0xffffffffa0106000
>> dell_wmi 12478 0 - Live 0xffffffffa01f4000
>> dell_laptop 16724 0 - Live 0xffffffffa0225000
>> rts5139 341121 0 - Live 0xffffffffa0318000 (C)
>> media 18110 2 uvcvideo,videodev, Live 0xffffffffa02f9000
>> sparse_keymap 12761 1 dell_wmi, Live 0xffffffffa02d4000
>> xts 12680 1 aesni_intel, Live 0xffffffffa02db000
>> lrw 12758 1 aesni_intel, Live 0xffffffffa0300000
>> dcdbas 13257 1 dell_laptop, Live 0xffffffffa02f0000
>> gf128mul 12971 2 xts,lrw, Live 0xffffffffa02bf000
>> rfkill 19021 4 bluetooth,cfg80211, Live 0xffffffffa02b4000
>> i2c_i801 16965 0 - Live 0xffffffffa02aa000
>> pcspkr 12596 0 - Live 0xffffffffa02a2000
>> serio_raw 12850 0 - Live 0xffffffffa029a000
>> soundcore 13027 1 snd, Live 0xffffffffa0291000
>> mei 35676 0 - Live 0xffffffffa0282000
>> mfd_core 12602 1 lpc_ich, Live 0xffffffffa0150000
>> ttm 65441 1 radeon, Live 0xffffffffa0267000
>> wmi 17340 1 dell_wmi, Live 0xffffffffa01ee000
>> battery 13147 0 - Live 0xffffffffa01e9000
>> ac 12625 0 - Live 0xffffffffa0124000
>> evdev 17445 22 - Live 0xffffffffa0253000
>> processor 28153 1 acpi_cpufreq, Live 0xffffffffa020f000
>> ext4 443202 3 - Live 0xffffffffa016d000
>> crc16 12344 2 bluetooth,ext4, Live 0xffffffffa0032000
>> jbd2 82210 1 ext4, Live 0xffffffffa00f0000
>> mbcache 13035 1 ext4, Live 0xffffffffa0028000
>> sg 30003 0 - Live 0xffffffffa0164000
>> sr_mod 21856 0 - Live 0xffffffffa015d000
>> cdrom 39233 1 sr_mod, Live 0xffffffffa0137000
>> ahci 25009 4 - Live 0xffffffffa0155000
>> i915 518772 3 - Live 0xffffffffa0070000
>> microcode 17706 0 - Live 0xffffffffa014a000
>> libahci 26891 1 ahci, Live 0xffffffffa0142000
>> r8169 60215 0 - Live 0xffffffffa005e000
>> mii 12676 1 r8169, Live 0xffffffffa0019000
>> ehci_hcd 48662 0 - Live 0xffffffffa012a000
>> xhci_hcd 89723 0 - Live 0xffffffffa010d000
>> usbcore 152905 8
>> usb_storage,usbhid,uvcvideo,ath3k,btusb,rts5139,ehci_hcd,xhci_hcd, Live
>> 0xffffffffa0037000
>> usb_common 12355 1 usbcore, Live 0xffffffffa002d000
>> drm_kms_helper 35296 2 radeon,i915, Live 0xffffffffa001e000
>> video 17687 1 i915, Live 0xffffffffa0013000
>> thermal_sys 22264 2 processor,video, Live 0xffffffffa0008000
>> button 12945 1 i915, Live 0xffffffffa0000000
>>
>>
>> adrian:~/linux/kernel/linux-stable$ cat /proc/ioports
>> 0000-0cf7 : PCI Bus 0000:00
>>   0000-001f : dma1
>>   0020-0021 : pic1
>>   0040-0043 : timer0
>>   0050-0053 : timer1
>>   0060-0060 : keyboard
>>   0062-0062 : EC data
>>   0064-0064 : keyboard
>>   0066-0066 : EC cmd
>>   0070-0077 : rtc0
>>   0080-008f : dma page reg
>>   00a0-00a1 : pic2
>>   00c0-00df : dma2
>>   00f0-00ff : fpu
>>   0400-0453 : pnp 00:05
>>     0400-0403 : ACPI PM1a_EVT_BLK
>>     0404-0405 : ACPI PM1a_CNT_BLK
>>     0408-040b : ACPI PM_TMR
>>     0410-0415 : ACPI CPU throttle
>>     0420-042f : ACPI GPE0_BLK
>>     0430-0433 : iTCO_wdt
>>       0430-0433 : iTCO_wdt
>>     0450-0450 : ACPI PM2_CNT_BLK
>>   0454-0457 : pnp 00:07
>>   0458-047f : pnp 00:05
>>     0460-047f : iTCO_wdt
>>       0460-047f : iTCO_wdt
>>   0500-057f : pnp 00:05
>>   0680-069f : pnp 00:05
>> 0cf8-0cff : PCI conf1
>> 0d00-ffff : PCI Bus 0000:00
>>   1000-100f : pnp 00:05
>>   164e-164f : pnp 00:05
>>   2000-2fff : PCI Bus 0000:09
>>   3000-3fff : PCI Bus 0000:07
>>     3000-30ff : 0000:07:00.0
>>       3000-30ff : r8169
>>   4000-4fff : PCI Bus 0000:01
>>     4000-40ff : 0000:01:00.0
>>   5000-503f : 0000:00:02.0
>>   5040-505f : 0000:00:1f.3
>>   5060-507f : 0000:00:1f.2
>>     5060-507f : ahci
>>   5080-5087 : 0000:00:1f.2
>>     5080-5087 : ahci
>>   5088-508f : 0000:00:1f.2
>>     5088-508f : ahci
>>   5090-5093 : 0000:00:1f.2
>>     5090-5093 : ahci
>>   5094-5097 : 0000:00:1f.2
>>     5094-5097 : ahci
>>   fd60-fd63 : pnp 00:05
>>   ffff-ffff : pnp 00:05
>>     ffff-ffff : pnp 00:05
>>
>>
>> adrian:~/linux/kernel/linux-stable$ cat /proc/iomem
>> 00000000-0000ffff : reserved
>> 00010000-00087fff : System RAM
>> 00088000-000bffff : reserved
>>   000a0000-000bffff : PCI Bus 0000:00
>> 000c0000-000c3fff : PCI Bus 0000:00
>> 000c4000-000c7fff : PCI Bus 0000:00
>> 000c8000-000cbfff : PCI Bus 0000:00
>> 000cc000-000cffff : PCI Bus 0000:00
>> 000d0000-000d3fff : PCI Bus 0000:00
>> 000d4000-000d7fff : PCI Bus 0000:00
>> 000d8000-000dbfff : PCI Bus 0000:00
>> 000dc000-000dffff : PCI Bus 0000:00
>> 000e0000-000e3fff : PCI Bus 0000:00
>> 000e4000-000e7fff : PCI Bus 0000:00
>> 000e8000-000ebfff : PCI Bus 0000:00
>> 000ec000-000effff : PCI Bus 0000:00
>> 000f0000-000fffff : PCI Bus 0000:00
>>   000f0000-000fffff : System ROM
>> 00100000-1fffffff : System RAM
>>   01000000-01476aaf : Kernel code
>>   01476ab0-0188a3ff : Kernel data
>>   01925000-019f4fff : Kernel bss
>> 20000000-201fffff : reserved
>>   20000000-201fffff : pnp 00:0c
>> 20200000-40003fff : System RAM
>> 40004000-40004fff : reserved
>>   40004000-40004fff : pnp 00:0c
>> 40005000-8ffaffff : System RAM
>> 8ffb0000-913affff : reserved
>> 913b0000-99dbefff : System RAM
>> 99dbf000-9aebefff : reserved
>> 9aebf000-9afbefff : ACPI Non-volatile Storage
>> 9afbf000-9affefff : ACPI Tables
>> 9afff000-9affffff : System RAM
>> 9b000000-9f9fffff : reserved
>> 9fa00000-feafffff : PCI Bus 0000:00
>>   9fa00000-9fa00fff : pnp 00:0b
>>   9fb00000-9fbfffff : PCI Bus 0000:08
>>     9fb00000-9fb0ffff : 0000:08:00.0
>>   a0000000-afffffff : PCI Bus 0000:01
>>     a0000000-afffffff : 0000:01:00.0
>>   b0000000-bfffffff : 0000:00:02.0
>>   c0000000-c0ffffff : PCI Bus 0000:09
>>   c1000000-c1ffffff : PCI Bus 0000:09
>>   c2000000-c2ffffff : PCI Bus 0000:01
>>     c2000000-c201ffff : 0000:01:00.0
>>     c2020000-c203ffff : 0000:01:00.0
>>   c3000000-c33fffff : 0000:00:02.0
>>   c3400000-c34fffff : PCI Bus 0000:07
>>     c3400000-c3403fff : 0000:07:00.0
>>       c3400000-c3403fff : r8169
>>     c3404000-c3404fff : 0000:07:00.0
>>       c3404000-c3404fff : r8169
>>   c3500000-c35fffff : PCI Bus 0000:08
>>     c3500000-c357ffff : 0000:08:00.0
>>       c3500000-c357ffff : ath9k
>>   c3600000-c360ffff : 0000:00:14.0
>>     c3600000-c360ffff : xhci_hcd
>>   c3610000-c3613fff : 0000:00:1b.0
>>     c3610000-c3613fff : ICH HD audio
>>   c3614000-c361400f : 0000:00:16.0
>>     c3614000-c361400f : mei
>>   c3615000-c36150ff : 0000:00:1f.3
>>   c3617000-c36177ff : 0000:00:1f.2
>>     c3617000-c36177ff : ahci
>>   c3618000-c36183ff : 0000:00:1d.0
>>     c3618000-c36183ff : ehci_hcd
>>   c3619000-c36193ff : 0000:00:1a.0
>>     c3619000-c36193ff : ehci_hcd
>>   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>>     e0000000-efffffff : reserved
>>       e0000000-efffffff : pnp 00:0b
>> feb00000-feb03fff : reserved
>> fec00000-fec00fff : reserved
>>   fec00000-fec003ff : IOAPIC 0
>> fed00000-fed003ff : HPET 0
>> fed10000-fed19fff : reserved
>>   fed10000-fed17fff : pnp 00:0b
>>   fed18000-fed18fff : pnp 00:0b
>>   fed19000-fed19fff : pnp 00:0b
>> fed1c000-fed1ffff : reserved
>>   fed1c000-fed1ffff : pnp 00:0b
>>     fed1f410-fed1f414 : iTCO_wdt
>>       fed1f410-fed1f414 : iTCO_wdt
>> fed20000-fed3ffff : pnp 00:0b
>> fed90000-fed93fff : pnp 00:0b
>> fee00000-fee00fff : Local APIC
>>   fee00000-fee00fff : reserved
>> ff000000-ff000fff : pnp 00:0b
>> ffb80000-ffffffff : reserved
>> 100000000-35f5fffff : System RAM
>> 35f600000-35fffffff : RAM buffer
>>
>>
>> root:/home/adrian/linux/kernel/linux-stable# lspci -vvv
>> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
>>         Subsystem: Dell Device 056e
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>>         Latency: 0
>>         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>
>> 00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
>>         I/O behind bridge: 00004000-00004fff
>>         Memory behind bridge: c2000000-c2ffffff
>>         Prefetchable memory behind bridge: 00000000a0000000-00000000afffffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [88] Subsystem: Dell Device 056e
>>         Capabilities: [80] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>                 Address: feeff00c  Data: 41a1
>>         Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>                 LnkCap: Port #2, Speed 8GT/s, Width x8, ASPM L0s L1, Latency L0 <256ns, L1 <8us
>>                         ClockPM- Surprise- LLActRep- BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
>>                         Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>                         Changed: MRL- PresDet+ LinkState-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>                 DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
>>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
>>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>         Capabilities: [100 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>                         Status: NegoPending- InProgress-
>>         Capabilities: [140 v1] Root Complex Link
>>                 Desc:   PortNumber=02 ComponentID=01 EltType=Config
>>                 Link0:  Desc:   TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
>>                         Addr:   00000000fed19000
>>         Capabilities: [d94 v1] #19
>>         Kernel driver in use: pcieport
>>
>> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
>>         Subsystem: Dell Device 056e
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 44
>>         Region 0: Memory at c3000000 (64-bit, non-prefetchable) [size=4M]
>>         Region 2: Memory at b0000000 (64-bit, prefetchable) [size=256M]
>>         Region 4: I/O ports at 5000 [size=64]
>>         Expansion ROM at <unassigned> [disabled]
>>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>                 Address: feeff00c  Data: 4122
>>         Capabilities: [d0] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [a4] PCI Advanced Features
>>                 AFCap: TP+ FLR+
>>                 AFCtrl: FLR-
>>                 AFStatus: TP-
>>         Kernel driver in use: i915
>>
>> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
>>         Subsystem: Dell Device 056e
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 41
>>         Region 0: Memory at c3600000 (64-bit, non-prefetchable) [size=64K]
>>         Capabilities: [70] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
>>                 Address: 00000000fee0100c  Data: 41b1
>>         Kernel driver in use: xhci_hcd
>>
>> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
>>         Subsystem: Dell Device 056e
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 45
>>         Region 0: Memory at c3614000 (64-bit, non-prefetchable) [size=16]
>>         Capabilities: [50] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>                 Address: 00000000feeff00c  Data: 4182
>>         Kernel driver in use: mei
>>
>> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
>>         Subsystem: Dell Device 056e
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: Memory at c3619000 (32-bit, non-prefetchable) [size=1K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>         Capabilities: [98] PCI Advanced Features
>>                 AFCap: TP+ FLR+
>>                 AFCtrl: FLR-
>>                 AFStatus: TP-
>>         Kernel driver in use: ehci_hcd
>>
>> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
>>         Subsystem: Dell Device 056e
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 46
>>         Region 0: Memory at c3610000 (64-bit, non-prefetchable) [size=16K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>                 Address: 00000000feeff00c  Data: 4192
>>         Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>                         ExtTag- RBE- FLReset+
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
>>                         ClockPM- Surprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>>         Capabilities: [100 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>>                         Status: NegoPending- InProgress-
>>                 VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=22
>>                         Status: NegoPending- InProgress-
>>         Capabilities: [130 v1] Root Complex Link
>>                 Desc:   PortNumber=0f ComponentID=00 EltType=Config
>>                 Link0:  Desc:   TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
>>                         Addr:   00000000fed1c000
>>         Kernel driver in use: snd_hda_intel
>>
>> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
>>         I/O behind bridge: 00003000-00003fff
>>         Memory behind bridge: fff00000-000fffff
>>         Prefetchable memory behind bridge: 00000000c3400000-00000000c34fffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>                 LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
>>                         ClockPM- Surprise- LLActRep+ BwNot-
>>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
>>                         Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>                         Changed: MRL- PresDet- LinkState-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
>>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>                 Address: 00000000  Data: 0000
>>         Capabilities: [90] Subsystem: Dell Device 056e
>>         Capabilities: [a0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: pcieport
>>
>> 00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: c3500000-c35fffff
>>         Prefetchable memory behind bridge: 000000009fb00000-000000009fbfffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>                 LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
>>                         ClockPM- Surprise- LLActRep+ BwNot-
>>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
>>                         Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>                         Changed: MRL- PresDet- LinkState-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
>>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>                 Address: 00000000  Data: 0000
>>         Capabilities: [90] Subsystem: Dell Device 056e
>>         Capabilities: [a0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: pcieport
>>
>> 00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=00, secondary=09, subordinate=0e, sec-latency=0
>>         I/O behind bridge: 00002000-00002fff
>>         Memory behind bridge: c1000000-c1ffffff
>>         Prefetchable memory behind bridge: 00000000c0000000-00000000c0ffffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>                 LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us
>>                         ClockPM- Surprise- LLActRep+ BwNot-
>>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
>>                         Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
>>                         Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>>                         Changed: MRL- PresDet- LinkState-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, EqualizationPhase1-
>>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>                 Address: 00000000  Data: 0000
>>         Capabilities: [90] Subsystem: Dell Device 056e
>>         Capabilities: [a0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
>>         Kernel driver in use: pcieport
>>
>> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
>>         Subsystem: Dell Device 056e
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 23
>>         Region 0: Memory at c3618000 (32-bit, non-prefetchable) [size=1K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>         Capabilities: [98] PCI Advanced Features
>>                 AFCap: TP+ FLR+
>>                 AFCtrl: FLR-
>>                 AFStatus: TP-
>>         Kernel driver in use: ehci_hcd
>>
>> 00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
>>         Subsystem: Dell Device 056e
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>         Kernel driver in use: lpc_ich
>>
>> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
>>         Subsystem: Dell Device 056e
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin B routed to IRQ 43
>>         Region 0: I/O ports at 5088 [size=8]
>>         Region 1: I/O ports at 5094 [size=4]
>>         Region 2: I/O ports at 5080 [size=8]
>>         Region 3: I/O ports at 5090 [size=4]
>>         Region 4: I/O ports at 5060 [size=32]
>>         Region 5: Memory at c3617000 (32-bit, non-prefetchable) [size=2K]
>>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>                 Address: fee0100c  Data: 41e1
>>         Capabilities: [70] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
>>         Capabilities: [b0] PCI Advanced Features
>>                 AFCap: TP+ FLR+
>>                 AFCtrl: FLR-
>>                 AFStatus: TP-
>>         Kernel driver in use: ahci
>>
>> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
>>         Subsystem: Dell Device 056e
>>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Interrupt: pin C routed to IRQ 19
>>         Region 0: Memory at c3615000 (64-bit, non-prefetchable) [size=256]
>>         Region 4: I/O ports at 5040 [size=32]
>>
>> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Thames XT/GL [Radeon HD 7600M Series] (rev ff) (prog-if ff)
>>         !!! Unknown header type 7f
>>         Kernel driver in use: radeon
>>
>> 07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)
>>         Subsystem: Dell Device 056e
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 42
>>         Region 0: I/O ports at 3000 [size=256]
>>         Region 2: Memory at c3404000 (64-bit, prefetchable) [size=4K]
>>         Region 4: Memory at c3400000 (64-bit, prefetchable) [size=16K]
>>         Capabilities: [40] Power Management version 3
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>                 Address: 00000000feeff00c  Data: 41c1
>>         Capabilities: [70] Express (v2) Endpoint, MSI 01
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 <64us
>>                         ClockPM+ Surprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>>                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
>>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
>>                 Vector table: BAR=4 offset=00000000
>>                 PBA: BAR=4 offset=00000800
>>         Capabilities: [d0] Vital Product Data
>>                 No end tag found
>>         Capabilities: [100 v1] Advanced Error Reporting
>>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>>         Capabilities: [140 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>                         Status: NegoPending- InProgress-
>>         Capabilities: [160 v1] Device Serial Number 01-08-00-00-68-4c-e0-00
>>         Kernel driver in use: r8169
>>
>> 08:00.0 Network controller: Atheros Communications Inc. AR9485 Wireless Network Adapter (rev 01)
>>         Subsystem: Dell Device 0209
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 17
>>         Region 0: Memory at c3500000 (64-bit, non-prefetchable) [size=512K]
>>         Expansion ROM at 9fb00000 [disabled] [size=64K]
>>         Capabilities: [40] Power Management version 2
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>         Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
>>                 Address: 0000000000000000  Data: 0000
>>                 Masking: 00000000  Pending: 00000000
>>         Capabilities: [70] Express (v2) Endpoint, MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
>>                         ClockPM- Surprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>                 DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>>                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>>                          Compliance De-emphasis: -6dB
>>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
>>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>>         Capabilities: [100 v1] Advanced Error Reporting
>>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>                 CESta:  RxErr+ BadTLP- BadDLLP+ Rollover- Timeout- NonFatalErr-
>>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>                 AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>>         Capabilities: [140 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>>                         Status: NegoPending- InProgress-
>>         Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
>>         Kernel driver in use: ath9k
>>
>>
>> root:/home/adrian/linux/kernel/linux-stable# dmesg
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.7.1 (root@adrian-lap) (gcc version 4.7.2 (Debian 4.7.2-4) ) #10 SMP PREEMPT Thu Dec 27 23:27:04 CET 2012
>> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.7.1 root=UUID=0bf20693-75cd-440a-b2f2-e8bedb062a3f ro quiet
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000087fff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000000088000-0x00000000000bffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008ffaffff] usable
>> [    0.000000] BIOS-e820: [mem 0x000000008ffb0000-0x00000000913affff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000913b0000-0x0000000099dbefff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000099dbf000-0x000000009aebefff] reserved
>> [    0.000000] BIOS-e820: [mem 0x000000009aebf000-0x000000009afbefff] ACPI NVS
>> [    0.000000] BIOS-e820: [mem 0x000000009afbf000-0x000000009affefff] ACPI data
>> [    0.000000] BIOS-e820: [mem 0x000000009afff000-0x000000009affffff] usable
>> [    0.000000] BIOS-e820: [mem 0x000000009b000000-0x000000009f9fffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000ffb80000-0x00000000ffffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000035f5fffff] usable
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] efi: EFI v2.31 by INSYDE Corp.
>> [    0.000000] efi:  ACPI=0x9affe000  ACPI 2.0=0x9affe014  SMBIOS=0x9aebef98 
>> [    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
>> [    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000006f000) (0MB)
>> [    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000006f000-0x0000000000070000) (0MB)
>> [    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000070000-0x0000000000088000) (0MB)
>> [    0.000000] efi: mem04: type=6, attr=0x800000000000000f, range=[0x0000000000088000-0x00000000000a0000) (0MB)
>> [    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000393000) (2MB)
>> [    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000393000-0x0000000020000000) (508MB)
>> [    0.000000] efi: mem07: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
>> [    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000020200000-0x0000000036a72000) (360MB)
>> [    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000036a72000-0x0000000037531000) (10MB)
>> [    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000037531000-0x0000000040004000) (138MB)
>> [    0.000000] efi: mem11: type=0, attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
>> [    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000040005000-0x0000000069392000) (659MB)
>> [    0.000000] efi: mem13: type=2, attr=0xf, range=[0x0000000069392000-0x000000008e3c0000) (592MB)
>> [    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000008e3c0000-0x000000008e3e0000) (0MB)
>> [    0.000000] efi: mem15: type=7, attr=0xf, range=[0x000000008e3e0000-0x000000008efcc000) (11MB)
>> [    0.000000] efi: mem16: type=4, attr=0xf, range=[0x000000008efcc000-0x000000008ffb0000) (15MB)
>> [    0.000000] efi: mem17: type=0, attr=0xf, range=[0x000000008ffb0000-0x00000000913b0000) (20MB)
>> [    0.000000] efi: mem18: type=7, attr=0xf, range=[0x00000000913b0000-0x00000000915a2000) (1MB)
>> [    0.000000] efi: mem19: type=1, attr=0xf, range=[0x00000000915a2000-0x00000000915bf000) (0MB)
>> [    0.000000] efi: mem20: type=7, attr=0xf, range=[0x00000000915bf000-0x0000000095bba000) (69MB)
>> [    0.000000] efi: mem21: type=4, attr=0xf, range=[0x0000000095bba000-0x00000000963fc000) (8MB)
>> [    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000963fc000-0x0000000096410000) (0MB)
>> [    0.000000] efi: mem23: type=4, attr=0xf, range=[0x0000000096410000-0x0000000096a2d000) (6MB)
>> [    0.000000] efi: mem24: type=7, attr=0xf, range=[0x0000000096a2d000-0x0000000097092000) (6MB)
>> [    0.000000] efi: mem25: type=4, attr=0xf, range=[0x0000000097092000-0x00000000970ea000) (0MB)
>> [    0.000000] efi: mem26: type=7, attr=0xf, range=[0x00000000970ea000-0x00000000971bf000) (0MB)
>> [    0.000000] efi: mem27: type=4, attr=0xf, range=[0x00000000971bf000-0x0000000097301000) (1MB)
>> [    0.000000] efi: mem28: type=7, attr=0xf, range=[0x0000000097301000-0x0000000097308000) (0MB)
>> [    0.000000] efi: mem29: type=4, attr=0xf, range=[0x0000000097308000-0x0000000097335000) (0MB)
>> [    0.000000] efi: mem30: type=7, attr=0xf, range=[0x0000000097335000-0x0000000097336000) (0MB)
>> [    0.000000] efi: mem31: type=4, attr=0xf, range=[0x0000000097336000-0x0000000097338000) (0MB)
>> [    0.000000] efi: mem32: type=7, attr=0xf, range=[0x0000000097338000-0x0000000097339000) (0MB)
>> [    0.000000] efi: mem33: type=4, attr=0xf, range=[0x0000000097339000-0x0000000097442000) (1MB)
>> [    0.000000] efi: mem34: type=7, attr=0xf, range=[0x0000000097442000-0x0000000097443000) (0MB)
>> [    0.000000] efi: mem35: type=4, attr=0xf, range=[0x0000000097443000-0x000000009747d000) (0MB)
>> [    0.000000] efi: mem36: type=7, attr=0xf, range=[0x000000009747d000-0x0000000097481000) (0MB)
>> [    0.000000] efi: mem37: type=4, attr=0xf, range=[0x0000000097481000-0x0000000097484000) (0MB)
>> [    0.000000] efi: mem38: type=7, attr=0xf, range=[0x0000000097484000-0x0000000097486000) (0MB)
>> [    0.000000] efi: mem39: type=4, attr=0xf, range=[0x0000000097486000-0x00000000978c2000) (4MB)
>> [    0.000000] efi: mem40: type=7, attr=0xf, range=[0x00000000978c2000-0x00000000978c3000) (0MB)
>> [    0.000000] efi: mem41: type=4, attr=0xf, range=[0x00000000978c3000-0x00000000978da000) (0MB)
>> [    0.000000] efi: mem42: type=7, attr=0xf, range=[0x00000000978da000-0x00000000978e6000) (0MB)
>> [    0.000000] efi: mem43: type=4, attr=0xf, range=[0x00000000978e6000-0x00000000978e7000) (0MB)
>> [    0.000000] efi: mem44: type=7, attr=0xf, range=[0x00000000978e7000-0x00000000978e8000) (0MB)
>> [    0.000000] efi: mem45: type=4, attr=0xf, range=[0x00000000978e8000-0x00000000995bf000) (28MB)
>> [    0.000000] efi: mem46: type=7, attr=0xf, range=[0x00000000995bf000-0x00000000999c2000) (4MB)
>> [    0.000000] efi: mem47: type=2, attr=0xf, range=[0x00000000999c2000-0x00000000999c8000) (0MB)
>> [    0.000000] efi: mem48: type=3, attr=0xf, range=[0x00000000999c8000-0x0000000099dbf000) (3MB)
>> [    0.000000] efi: mem49: type=5, attr=0x800000000000000f, range=[0x0000000099dbf000-0x0000000099f2d000) (1MB)
>> [    0.000000] efi: mem50: type=5, attr=0x800000000000000f, range=[0x0000000099f2d000-0x0000000099f32000) (0MB)
>> [    0.000000] efi: mem51: type=6, attr=0x800000000000000f, range=[0x0000000099f32000-0x000000009a0b8000) (1MB)
>> [    0.000000] efi: mem52: type=5, attr=0x800000000000000f, range=[0x000000009a0b8000-0x000000009a1bf000) (1MB)
>> [    0.000000] efi: mem53: type=6, attr=0x800000000000000f, range=[0x000000009a1bf000-0x000000009a2af000) (0MB)
>> [    0.000000] efi: mem54: type=6, attr=0x800000000000000f, range=[0x000000009a2af000-0x000000009a3bf000) (1MB)
>> [    0.000000] efi: mem55: type=0, attr=0xf, range=[0x000000009a3bf000-0x000000009add3000) (10MB)
>> [    0.000000] efi: mem56: type=0, attr=0xf, range=[0x000000009add3000-0x000000009aebf000) (0MB)
>> [    0.000000] efi: mem57: type=10, attr=0xf, range=[0x000000009aebf000-0x000000009af91000) (0MB)
>> [    0.000000] efi: mem58: type=10, attr=0xf, range=[0x000000009af91000-0x000000009afbf000) (0MB)
>> [    0.000000] efi: mem59: type=9, attr=0xf, range=[0x000000009afbf000-0x000000009afe1000) (0MB)
>> [    0.000000] efi: mem60: type=9, attr=0xf, range=[0x000000009afe1000-0x000000009afff000) (0MB)
>> [    0.000000] efi: mem61: type=4, attr=0xf, range=[0x000000009afff000-0x000000009b000000) (0MB)
>> [    0.000000] efi: mem62: type=7, attr=0xf, range=[0x0000000100000000-0x000000035f600000) (9718MB)
>> [    0.000000] efi: mem63: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
>> [    0.000000] efi: mem64: type=0, attr=0x0, range=[0x000000009b000000-0x000000009fa00000) (74MB)
>> [    0.000000] efi: mem65: type=11, attr=0x8000000000000001, range=[0x00000000e0000000-0x00000000f0000000) (256MB)
>> [    0.000000] efi: mem66: type=11, attr=0x8000000000000001, range=[0x00000000feb00000-0x00000000feb04000) (0MB)
>> [    0.000000] efi: mem67: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
>> [    0.000000] efi: mem68: type=11, attr=0x8000000000000001, range=[0x00000000fed10000-0x00000000fed1a000) (0MB)
>> [    0.000000] efi: mem69: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
>> [    0.000000] efi: mem70: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
>> [    0.000000] efi: mem71: type=11, attr=0x8000000000000000, range=[0x00000000ffb80000-0x00000000fff00000) (3MB)
>> [    0.000000] efi: mem72: type=11, attr=0x8000000000000000, range=[0x00000000fff00000-0x00000000fff40000) (0MB)
>> [    0.000000] efi: mem73: type=11, attr=0x8000000000000000, range=[0x00000000fff40000-0x0000000100000000) (0MB)
>> [    0.000000] DMI 2.7 present.
>> [    0.000000] DMI: Dell Inc. Vostro 3560/0C05GV, BIOS A11 10/03/2012
>> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>> [    0.000000] No AGP bridge found
>> [    0.000000] e820: last_pfn = 0x35f600 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-E7FFF write-protect
>> [    0.000000]   E8000-EFFFF write-combining
>> [    0.000000]   F0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 000000000 mask F80000000 write-back
>> [    0.000000]   1 base 080000000 mask FE0000000 write-back
>> [    0.000000]   2 base 09B000000 mask FFF000000 uncachable
>> [    0.000000]   3 base 09C000000 mask FFC000000 uncachable
>> [    0.000000]   4 base 0FFA00000 mask FFFE00000 write-protect
>> [    0.000000]   5 base 0FFC00000 mask FFFC00000 write-protect
>> [    0.000000]   6 base 100000000 mask F00000000 write-back
>> [    0.000000]   7 base 200000000 mask E00000000 write-back
>> [    0.000000]   8 base 35F600000 mask FFFE00000 uncachable
>> [    0.000000]   9 base 35F800000 mask FFF800000 uncachable
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] e820: last_pfn = 0x9b000 max_arch_pfn = 0x400000000
>> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
>> [    0.000000] Base memory trampoline at [ffff880000080000] 80000 size 24576
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x9affffff]
>> [    0.000000]  [mem 0x00000000-0x9affffff] page 2M
>> [    0.000000] kernel direct mapping tables up to 0x9affffff @ [mem 0x1fffc000-0x1fffffff]
>> [    0.000000] init_memory_mapping: [mem 0x100000000-0x35f5fffff]
>> [    0.000000]  [mem 0x100000000-0x35f5fffff] page 2M
>> [    0.000000] kernel direct mapping tables up to 0x35f5fffff @ [mem 0x999bd000-0x999c7fff]
>> [    0.000000] RAMDISK: [mem 0x36a72000-0x37530fff]
>> [    0.000000] ACPI: RSDP 000000009affe014 00024 (v02 DELL  )
>> [    0.000000] ACPI: XSDT 000000009affe210 0009C (v01 DELL    CL09    00000001      01000013)
>> [    0.000000] ACPI: FACP 000000009affb000 0010C (v05 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: DSDT 000000009afee000 09692 (v01 DELL    CL09    00000000 ASL  00040000)
>> [    0.000000] ACPI: FACS 000000009afb9000 00040
>> [    0.000000] ACPI: UEFI 000000009affd000 00236 (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: ASF! 000000009affc000 000A5 (v32 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: HPET 000000009affa000 00038 (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: APIC 000000009aff9000 0008C (v03 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: MCFG 000000009aff8000 0003C (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: SSDT 000000009afed000 006FE (v01 COMPAL CRV ORB  00001000 ACPI 00040000)
>> [    0.000000] ACPI: BOOT 000000009afeb000 00028 (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: ASPT 000000009afe9000 00034 (v07 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: DBGP 000000009afe8000 00034 (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: FPDT 000000009afe6000 00044 (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: SSDT 000000009afe5000 00860 (v01 COMPAL CRV ORB  00003000 ACPI 00040000)
>> [    0.000000] ACPI: SSDT 000000009afe4000 00A92 (v01 COMPAL CRV ORB  00003000 ACPI 00040000)
>> [    0.000000] ACPI: SSDT 000000009afe1000 01EED (v01 COMPAL CRV ORB  00001000 ACPI 00040000)
>> [    0.000000] ACPI: BGRT 000000009afe3000 00038 (v01 DELL    CL09    00000001 ASL  00040000)
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] No NUMA configuration found
>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000035f5fffff]
>> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x35f5fffff]
>> [    0.000000]   NODE_DATA [mem 0x35f5fc000-0x35f5fffff]
>> [    0.000000]  [ffffea0000000000-ffffea000d7fffff] PMD -> [ffff880352c00000-ffff88035ebfffff] on node 0
>> [    0.000000] Zone ranges:
>> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
>> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
>> [    0.000000]   Normal   [mem 0x100000000-0x35f5fffff]
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x00010000-0x00087fff]
>> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
>> [    0.000000]   node   0: [mem 0x20200000-0x40003fff]
>> [    0.000000]   node   0: [mem 0x40005000-0x8ffaffff]
>> [    0.000000]   node   0: [mem 0x913b0000-0x99dbefff]
>> [    0.000000]   node   0: [mem 0x9afff000-0x9affffff]
>> [    0.000000]   node   0: [mem 0x100000000-0x35f5fffff]
>> [    0.000000] On node 0 totalpages: 3112247
>> [    0.000000]   DMA zone: 64 pages used for memmap
>> [    0.000000]   DMA zone: 8 pages reserved
>> [    0.000000]   DMA zone: 3888 pages, LIFO batch:0
>> [    0.000000]   DMA32 zone: 16320 pages used for memmap
>> [    0.000000]   DMA32 zone: 604159 pages, LIFO batch:31
>> [    0.000000]   Normal zone: 38872 pages used for memmap
>> [    0.000000]   Normal zone: 2448936 pages, LIFO batch:31
>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
>> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
>> [    0.000000] nr_irqs_gsi: 40
>> [    0.000000] PM: Registered nosave memory: 0000000000088000 - 00000000000c0000
>> [    0.000000] PM: Registered nosave memory: 00000000000c0000 - 0000000000100000
>> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
>> [    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
>> [    0.000000] PM: Registered nosave memory: 000000008ffb0000 - 00000000913b0000
>> [    0.000000] PM: Registered nosave memory: 0000000099dbf000 - 000000009aebf000
>> [    0.000000] PM: Registered nosave memory: 000000009aebf000 - 000000009afbf000
>> [    0.000000] PM: Registered nosave memory: 000000009afbf000 - 000000009afff000
>> [    0.000000] PM: Registered nosave memory: 000000009b000000 - 000000009fa00000
>> [    0.000000] PM: Registered nosave memory: 000000009fa00000 - 00000000e0000000
>> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
>> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
>> [    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
>> [    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
>> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
>> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
>> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
>> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
>> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
>> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
>> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
>> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb80000
>> [    0.000000] PM: Registered nosave memory: 00000000ffb80000 - 0000000100000000
>> [    0.000000] e820: [mem 0x9fa00000-0xdfffffff] available for PCI devices
>> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
>> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88035f200000 s79616 r8192 d22784 u262144
>> [    0.000000] pcpu-alloc: s79616 r8192 d22784 u262144 alloc=1*2097152
>> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3056983
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.7.1 root=UUID=0bf20693-75cd-440a-b2f2-e8bedb062a3f ro quiet
>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>> [    0.000000] __ex_table already sorted, skipping sort
>> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
>> [    0.000000] Checking aperture...
>> [    0.000000] No AGP bridge found
>> [    0.000000] Memory: 12091732k/14145536k available (4570k kernel code, 1696548k absent, 357256k reserved, 4174k data, 592k init)
>> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
>> [    0.000000] Preemptible hierarchical RCU implementation.
>> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
>> [    0.000000] NR_IRQS:4352 nr_irqs:744 16
>> [    0.000000] Console: colour dummy device 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.000000] allocated 50331648 bytes of page_cgroup
>> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
>> [    0.000000] hpet clockevent registered
>> [    0.000000] tsc: Fast TSC calibration using PIT
>> [    0.001000] tsc: Detected 2095.154 MHz processor
>> [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4190.30 BogoMIPS (lpj=2095154)
>> [    0.000005] pid_max: default: 32768 minimum: 301
>> [    0.045104] Security Framework initialized
>> [    0.046069] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
>> [    0.050643] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
>> [    0.052697] Mount-cache hash table entries: 256
>> [    0.052873] Initializing cgroup subsys cpuacct
>> [    0.052875] Initializing cgroup subsys memory
>> [    0.052881] Initializing cgroup subsys devices
>> [    0.052883] Initializing cgroup subsys freezer
>> [    0.052884] Initializing cgroup subsys net_cls
>> [    0.052885] Initializing cgroup subsys blkio
>> [    0.052886] Initializing cgroup subsys perf_event
>> [    0.052889] Initializing cgroup subsys hugetlb
>> [    0.052912] CPU: Physical Processor ID: 0
>> [    0.052913] CPU: Processor Core ID: 0
>> [    0.052918] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>> [    0.052918] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>> [    0.053343] mce: CPU supports 9 MCE banks
>> [    0.053357] CPU0: Thermal monitoring enabled (TM1)
>> [    0.053366] process: using mwait in idle threads
>> [    0.053369] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
>> [    0.053369] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
>> [    0.053369] tlb_flushall_shift: 1
>> [    0.053512] Freeing SMP alternatives: 16k freed
>> [    0.053519] ACPI: Core revision 20120913
>> [    0.074065] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.084053] smpboot: CPU0: Intel(R) Core(TM) i7-3612QM CPU @ 2.10GHz (fam: 06, model: 3a, stepping: 09)
>> [    0.185661] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
>> [    0.185667] ... version:                3
>> [    0.185668] ... bit width:              48
>> [    0.185669] ... generic registers:      4
>> [    0.185670] ... value mask:             0000ffffffffffff
>> [    0.185671] ... max period:             000000007fffffff
>> [    0.185672] ... fixed-purpose events:   3
>> [    0.185673] ... event mask:             000000070000000f
>> [    0.207513] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>> [    0.193703] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
>> [    0.297175] Brought up 8 CPUs
>> [    0.297179] smpboot: Total of 8 processors activated (33522.46 BogoMIPS)
>> [    0.304277] devtmpfs: initialized
>> [    0.304412] PM: Registering ACPI NVS region [mem 0x9aebf000-0x9afbefff] (1048576 bytes)
>> [    0.304517] regulator-dummy: no parameters
>> [    0.304549] RTC time: 16:36:25, date: 01/08/13
>> [    0.304585] NET: Registered protocol family 16
>> [    0.304680] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
>> [    0.304682] ACPI: bus type pci registered
>> [    0.304748] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>> [    0.304751] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
>> [    0.334222] PCI: Using configuration type 1 for base access
>> [    0.334358] dmi type 0xB1 record - unknown flag
>> [    0.334890] bio: create slab <bio-0> at 0
>> [    0.334937] ACPI: Added _OSI(Module Device)
>> [    0.334939] ACPI: Added _OSI(Processor Device)
>> [    0.334940] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.334942] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.336533] ACPI: EC: Look up EC in DSDT
>> [    0.338137] ACPI: Executed 1 blocks of module-level executable AML code
>> [    0.344586] ACPI: SSDT 000000009adf7018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20111123)
>> [    0.344992] ACPI: Dynamic OEM Table Load:
>> [    0.344995] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20111123)
>> [    0.350315] ACPI: SSDT 000000009adf8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20111123)
>> [    0.350746] ACPI: Dynamic OEM Table Load:
>> [    0.350748] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20111123)
>> [    0.356185] ACPI: SSDT 000000009adf6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20111123)
>> [    0.356584] ACPI: Dynamic OEM Table Load:
>> [    0.356586] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20111123)
>> [    0.363253] ACPI: Interpreter enabled
>> [    0.363256] ACPI: (supports S0 S3 S4 S5)
>> [    0.363275] ACPI: Using IOAPIC for interrupt routing
>> [    0.487091] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
>> [    0.487119] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>> [    0.487377] \_SB_.PCI0:_OSC invalid UUID
>> [    0.487378] _OSC request data:1 8 1f 
>> [    0.487382] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
>> [    0.487652] PCI host bridge to bus 0000:00
>> [    0.487655] pci_bus 0000:00: root bus resource [bus 00-fe]
>> [    0.487657] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
>> [    0.487659] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
>> [    0.487661] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
>> [    0.487662] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
>> [    0.487664] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
>> [    0.487665] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
>> [    0.487667] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
>> [    0.487668] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
>> [    0.487670] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
>> [    0.487672] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
>> [    0.487673] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
>> [    0.487675] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
>> [    0.487676] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
>> [    0.487678] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
>> [    0.487679] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
>> [    0.487681] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
>> [    0.487683] pci_bus 0000:00: root bus resource [mem 0x9fa00000-0xfeafffff]
>> [    0.487691] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
>> [    0.487730] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
>> [    0.487764] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
>> [    0.487785] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
>> [    0.487797] pci 0000:00:02.0: reg 10: [mem 0xc3000000-0xc33fffff 64bit]
>> [    0.487804] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
>> [    0.487810] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
>> [    0.487874] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
>> [    0.487898] pci 0000:00:14.0: reg 10: [mem 0xc3600000-0xc360ffff 64bit]
>> [    0.487974] pci 0000:00:14.0: PME# supported from D3hot D3cold
>> [    0.488000] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
>> [    0.488025] pci 0000:00:16.0: reg 10: [mem 0xc3614000-0xc361400f 64bit]
>> [    0.488106] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
>> [    0.488141] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
>> [    0.488165] pci 0000:00:1a.0: reg 10: [mem 0xc3619000-0xc36193ff]
>> [    0.488261] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
>> [    0.488289] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
>> [    0.488306] pci 0000:00:1b.0: reg 10: [mem 0xc3610000-0xc3613fff 64bit]
>> [    0.488378] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>> [    0.488402] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
>> [    0.488486] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>> [    0.488515] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
>> [    0.488598] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>> [    0.488626] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
>> [    0.488708] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>> [    0.488748] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
>> [    0.488772] pci 0000:00:1d.0: reg 10: [mem 0xc3618000-0xc36183ff]
>> [    0.488872] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>> [    0.488900] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
>> [    0.489033] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
>> [    0.489053] pci 0000:00:1f.2: reg 10: [io  0x5088-0x508f]
>> [    0.489062] pci 0000:00:1f.2: reg 14: [io  0x5094-0x5097]
>> [    0.489070] pci 0000:00:1f.2: reg 18: [io  0x5080-0x5087]
>> [    0.489079] pci 0000:00:1f.2: reg 1c: [io  0x5090-0x5093]
>> [    0.489087] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
>> [    0.489096] pci 0000:00:1f.2: reg 24: [mem 0xc3617000-0xc36177ff]
>> [    0.489144] pci 0000:00:1f.2: PME# supported from D3hot
>> [    0.489164] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
>> [    0.489180] pci 0000:00:1f.3: reg 10: [mem 0xc3615000-0xc36150ff 64bit]
>> [    0.489203] pci 0000:00:1f.3: reg 20: [io  0x5040-0x505f]
>> [    0.489267] pci 0000:01:00.0: [1002:6840] type 00 class 0x030000
>> [    0.489280] pci 0000:01:00.0: reg 10: [mem 0xa0000000-0xafffffff 64bit pref]
>> [    0.489291] pci 0000:01:00.0: reg 18: [mem 0xc2000000-0xc201ffff 64bit]
>> [    0.489299] pci 0000:01:00.0: reg 20: [io  0x4000-0x40ff]
>> [    0.489312] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
>> [    0.489345] pci 0000:01:00.0: supports D1 D2
>> [    0.491864] pci 0000:00:01.0: PCI bridge to [bus 01-06]
>> [    0.491868] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
>> [    0.491887] pci 0000:00:01.0:   bridge window [mem 0xc2000000-0xc2ffffff]
>> [    0.491890] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
>> [    0.492019] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
>> [    0.492089] pci 0000:07:00.0: reg 10: [io  0x3000-0x30ff]
>> [    0.492213] pci 0000:07:00.0: reg 18: [mem 0xc3404000-0xc3404fff 64bit pref]
>> [    0.492289] pci 0000:07:00.0: reg 20: [mem 0xc3400000-0xc3403fff 64bit pref]
>> [    0.492629] pci 0000:07:00.0: supports D1 D2
>> [    0.492631] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>> [    0.494916] pci 0000:00:1c.0: PCI bridge to [bus 07]
>> [    0.494920] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
>> [    0.494929] pci 0000:00:1c.0:   bridge window [mem 0xc3400000-0xc34fffff 64bit pref]
>> [    0.495014] pci 0000:08:00.0: [168c:0032] type 00 class 0x028000
>> [    0.495058] pci 0000:08:00.0: reg 10: [mem 0xc3500000-0xc357ffff 64bit]
>> [    0.495147] pci 0000:08:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
>> [    0.495236] pci 0000:08:00.0: supports D1 D2
>> [    0.495238] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>> [    0.497883] pci 0000:00:1c.1: PCI bridge to [bus 08]
>> [    0.497890] pci 0000:00:1c.1:   bridge window [mem 0xc3500000-0xc35fffff]
>> [    0.497943] pci 0000:00:1c.2: PCI bridge to [bus 09-0e]
>> [    0.497947] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
>> [    0.497952] pci 0000:00:1c.2:   bridge window [mem 0xc1000000-0xc1ffffff]
>> [    0.497958] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc0ffffff 64bit pref]
>> [    0.497979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> [    0.498097] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
>> [    0.498124] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
>> [    0.498148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
>> [    0.498178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
>> [    0.498266] \_SB_.PCI0:_OSC invalid UUID
>> [    0.498267] _OSC request data:1 1f 1f 
>> [    0.498271]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>> [    0.498272]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
>> [    0.500826] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.500873] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.500913] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.500951] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.500989] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.501028] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.501066] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.501103] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>> [    0.501168] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
>> [    0.501173] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
>> [    0.501174] vgaarb: loaded
>> [    0.501175] vgaarb: bridge control possible 0000:01:00.0
>> [    0.501176] vgaarb: no bridge control possible 0000:00:02.0
>> [    0.501222] SCSI subsystem initialized
>> [    0.501223] ACPI: bus type scsi registered
>> [    0.501253] libata version 3.00 loaded.
>> [    0.501279] PCI: Using ACPI for IRQ routing
>> [    0.508092] PCI: pci_cache_line_size set to 64 bytes
>> [    0.508171] e820: reserve RAM buffer [mem 0x00088000-0x0008ffff]
>> [    0.508173] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
>> [    0.508175] e820: reserve RAM buffer [mem 0x8ffb0000-0x8fffffff]
>> [    0.508176] e820: reserve RAM buffer [mem 0x99dbf000-0x9bffffff]
>> [    0.508178] e820: reserve RAM buffer [mem 0x9b000000-0x9bffffff]
>> [    0.508179] e820: reserve RAM buffer [mem 0x35f600000-0x35fffffff]
>> [    0.508266] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
>> [    0.508272] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
>> [    0.510282] Switching to clocksource hpet
>> [    0.511407] pnp: PnP ACPI init
>> [    0.511415] ACPI: bus type pnp registered
>> [    0.511560] pnp 00:00: [bus 00-fe]
>> [    0.511563] pnp 00:00: [io  0x0000-0x0cf7 window]
>> [    0.511565] pnp 00:00: [io  0x0cf8-0x0cff]
>> [    0.511566] pnp 00:00: [io  0x0d00-0xffff window]
>> [    0.511568] pnp 00:00: [mem 0x000a0000-0x000bffff window]
>> [    0.511570] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
>> [    0.511571] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
>> [    0.511573] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
>> [    0.511574] pnp 00:00: [mem 0x000cc000-0x000cffff window]
>> [    0.511576] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
>> [    0.511577] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
>> [    0.511579] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
>> [    0.511580] pnp 00:00: [mem 0x000dc000-0x000dffff window]
>> [    0.511582] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
>> [    0.511585] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
>> [    0.511587] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
>> [    0.511588] pnp 00:00: [mem 0x000ec000-0x000effff window]
>> [    0.511590] pnp 00:00: [mem 0x000f0000-0x000fffff window]
>> [    0.511592] pnp 00:00: [mem 0x9fa00000-0xfeafffff window]
>> [    0.511593] pnp 00:00: [mem 0x00010000-0x0001ffff window]
>> [    0.511617] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
>> [    0.511628] pnp 00:01: [io  0x0000-0x001f]
>> [    0.511629] pnp 00:01: [io  0x0081-0x0091]
>> [    0.511631] pnp 00:01: [io  0x0093-0x009f]
>> [    0.511632] pnp 00:01: [io  0x00c0-0x00df]
>> [    0.511634] pnp 00:01: [dma 4]
>> [    0.511649] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
>> [    0.511656] pnp 00:02: [mem 0xff010000-0xffffffff]
>> [    0.511668] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
>> [    0.511729] pnp 00:03: [mem 0xfed00000-0xfed003ff]
>> [    0.511742] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
>> [    0.511750] pnp 00:04: [io  0x00f0]
>> [    0.511758] pnp 00:04: [irq 13]
>> [    0.511772] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
>> [    0.511780] pnp 00:05: [io  0x002e-0x002f]
>> [    0.511782] pnp 00:05: [io  0x004e-0x004f]
>> [    0.511783] pnp 00:05: [io  0x0061]
>> [    0.511784] pnp 00:05: [io  0x0063]
>> [    0.511786] pnp 00:05: [io  0x0065]
>> [    0.511787] pnp 00:05: [io  0x0067]
>> [    0.511788] pnp 00:05: [io  0x0070]
>> [    0.511790] pnp 00:05: [io  0x0080]
>> [    0.511791] pnp 00:05: [io  0x0092]
>> [    0.511793] pnp 00:05: [io  0x00b2-0x00b3]
>> [    0.511794] pnp 00:05: [io  0x0680-0x069f]
>> [    0.511796] pnp 00:05: [io  0x1000-0x100f]
>> [    0.511797] pnp 00:05: [io  0xffff]
>> [    0.511798] pnp 00:05: [io  0xffff]
>> [    0.511800] pnp 00:05: [io  0x0400-0x0453]
>> [    0.511801] pnp 00:05: [io  0x0458-0x047f]
>> [    0.511803] pnp 00:05: [io  0x0500-0x057f]
>> [    0.511804] pnp 00:05: [io  0x164e-0x164f]
>> [    0.511805] pnp 00:05: [io  0xfd60-0xfd63]
>> [    0.511831] system 00:05: [io  0x0680-0x069f] has been reserved
>> [    0.511833] system 00:05: [io  0x1000-0x100f] has been reserved
>> [    0.511834] system 00:05: [io  0xffff] has been reserved
>> [    0.511836] system 00:05: [io  0xffff] has been reserved
>> [    0.511838] system 00:05: [io  0x0400-0x0453] has been reserved
>> [    0.511840] system 00:05: [io  0x0458-0x047f] has been reserved
>> [    0.511842] system 00:05: [io  0x0500-0x057f] has been reserved
>> [    0.511843] system 00:05: [io  0x164e-0x164f] has been reserved
>> [    0.511845] system 00:05: [io  0xfd60-0xfd63] has been reserved
>> [    0.511847] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.511854] pnp 00:06: [io  0x0070-0x0077]
>> [    0.511859] pnp 00:06: [irq 8]
>> [    0.511872] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
>> [    0.511893] pnp 00:07: [io  0x0454-0x0457]
>> [    0.511911] system 00:07: [io  0x0454-0x0457] has been reserved
>> [    0.511914] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
>> [    0.511925] pnp 00:08: [io  0x0060]
>> [    0.511927] pnp 00:08: [io  0x0064]
>> [    0.511931] pnp 00:08: [irq 1]
>> [    0.511951] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
>> [    0.511964] pnp 00:09: [irq 12]
>> [    0.511977] pnp 00:09: Plug and Play ACPI device, IDs DLL056e PNP0f13 (active)
>> [    0.571258] pnp 00:0a: [irq 20]
>> [    0.571276] pnp 00:0a: Plug and Play ACPI device, IDs SMO8810 (active)
>> [    0.571359] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
>> [    0.571361] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
>> [    0.571362] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
>> [    0.571364] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
>> [    0.571365] pnp 00:0b: [mem 0xe0000000-0xefffffff]
>> [    0.571367] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
>> [    0.571368] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
>> [    0.571370] pnp 00:0b: [mem 0xff000000-0xff000fff]
>> [    0.571371] pnp 00:0b: [mem 0xff010000-0xffffffff]
>> [    0.571372] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
>> [    0.571374] pnp 00:0b: [mem 0x9fa00000-0x9fa00fff]
>> [    0.571400] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
>> [    0.571402] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
>> [    0.571404] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
>> [    0.571405] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
>> [    0.571407] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
>> [    0.571409] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
>> [    0.571411] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
>> [    0.571413] system 00:0b: [mem 0xff000000-0xff000fff] has been reserved
>> [    0.571415] system 00:0b: [mem 0xff010000-0xffffffff] could not be reserved
>> [    0.571417] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
>> [    0.571419] system 00:0b: [mem 0x9fa00000-0x9fa00fff] has been reserved
>> [    0.571421] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
>> [    0.571717] pnp 00:0c: [mem 0x20000000-0x201fffff]
>> [    0.571719] pnp 00:0c: [mem 0x40004000-0x40004fff]
>> [    0.571743] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
>> [    0.571745] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
>> [    0.571747] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
>> [    0.571762] pnp: PnP ACPI: found 13 devices
>> [    0.571763] ACPI: ACPI bus type pnp unregistered
>> [    0.578132] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
>> [    0.578134] pci 0000:08:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
>> [    0.578170] pci 0000:00:1c.1: BAR 15: assigned [mem 0x9fb00000-0x9fbfffff pref]
>> [    0.578173] pci 0000:01:00.0: BAR 6: assigned [mem 0xc2020000-0xc203ffff pref]
>> [    0.578175] pci 0000:00:01.0: PCI bridge to [bus 01-06]
>> [    0.578178] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
>> [    0.578181] pci 0000:00:01.0:   bridge window [mem 0xc2000000-0xc2ffffff]
>> [    0.578184] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
>> [    0.578187] pci 0000:00:1c.0: PCI bridge to [bus 07]
>> [    0.578191] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
>> [    0.578204] pci 0000:00:1c.0:   bridge window [mem 0xc3400000-0xc34fffff 64bit pref]
>> [    0.578212] pci 0000:08:00.0: BAR 6: assigned [mem 0x9fb00000-0x9fb0ffff pref]
>> [    0.578214] pci 0000:00:1c.1: PCI bridge to [bus 08]
>> [    0.578219] pci 0000:00:1c.1:   bridge window [mem 0xc3500000-0xc35fffff]
>> [    0.578224] pci 0000:00:1c.1:   bridge window [mem 0x9fb00000-0x9fbfffff pref]
>> [    0.578230] pci 0000:00:1c.2: PCI bridge to [bus 09-0e]
>> [    0.578234] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
>> [    0.578239] pci 0000:00:1c.2:   bridge window [mem 0xc1000000-0xc1ffffff]
>> [    0.578244] pci 0000:00:1c.2:   bridge window [mem 0xc0000000-0xc0ffffff 64bit pref]
>> [    0.578277] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
>> [    0.578279] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
>> [    0.578281] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
>> [    0.578282] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
>> [    0.578284] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
>> [    0.578286] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
>> [    0.578287] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
>> [    0.578289] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
>> [    0.578291] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
>> [    0.578292] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
>> [    0.578294] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
>> [    0.578295] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
>> [    0.578297] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
>> [    0.578299] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
>> [    0.578300] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
>> [    0.578302] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
>> [    0.578304] pci_bus 0000:00: resource 20 [mem 0x9fa00000-0xfeafffff]
>> [    0.578305] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
>> [    0.578307] pci_bus 0000:01: resource 1 [mem 0xc2000000-0xc2ffffff]
>> [    0.578309] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
>> [    0.578311] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
>> [    0.578312] pci_bus 0000:07: resource 2 [mem 0xc3400000-0xc34fffff 64bit pref]
>> [    0.578314] pci_bus 0000:08: resource 1 [mem 0xc3500000-0xc35fffff]
>> [    0.578316] pci_bus 0000:08: resource 2 [mem 0x9fb00000-0x9fbfffff pref]
>> [    0.578317] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
>> [    0.578319] pci_bus 0000:09: resource 1 [mem 0xc1000000-0xc1ffffff]
>> [    0.578321] pci_bus 0000:09: resource 2 [mem 0xc0000000-0xc0ffffff 64bit pref]
>> [    0.578347] NET: Registered protocol family 2
>> [    0.578932] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
>> [    0.580086] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>> [    0.580218] TCP: Hash tables configured (established 524288 bind 65536)
>> [    0.580242] TCP: reno registered
>> [    0.580263] UDP hash table entries: 8192 (order: 6, 262144 bytes)
>> [    0.580315] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
>> [    0.580416] NET: Registered protocol family 1
>> [    0.580430] pci 0000:00:02.0: Boot video device
>> [    0.603219] PCI: CLS 64 bytes, default 64
>> [    0.603256] Unpacking initramfs...
>> [    0.820991] Freeing initrd memory: 11004k freed
>> [    0.822369] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> [    0.822374] software IO TLB [mem 0x91bba000-0x95bb9fff] (64MB) mapped at [ffff880091bba000-ffff880095bb9fff]
>> [    0.822400] Simple Boot Flag at 0x44 set to 0x1
>> [    0.822777] audit: initializing netlink socket (disabled)
>> [    0.822793] type=2000 audit(1357662985.683:1): initialized
>> [    0.838155] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>> [    0.839508] VFS: Disk quotas dquot_6.5.2
>> [    0.839546] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> [    0.839630] msgmni has been set to 23779
>> [    0.839904] alg: No test for stdrng (krng)
>> [    0.839946] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
>> [    0.839948] io scheduler noop registered
>> [    0.839949] io scheduler deadline registered
>> [    0.839969] io scheduler cfq registered (default)
>> [    0.840040] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
>> [    0.840213] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> [    0.840228] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>> [    0.840229] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> [    0.840420] acpiphp: Slot [1] registered
>> [    0.840522] efifb: probing for efifb
>> [    0.841671] efifb: framebuffer at 0xb0000000, mapped to 0xffffc90022780000, using 8128k, total 8128k
>> [    0.841672] efifb: mode is 1920x1080x32, linelength=7680, pages=1
>> [    0.841673] efifb: scrolling: redraw
>> [    0.841675] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
>> [    0.847927] Console: switching to colour frame buffer device 240x67
>> [    0.853774] fb0: EFI VGA frame buffer device
>> [    0.853780] intel_idle: MWAIT substates: 0x21120
>> [    0.853789] intel_idle: v0.4 model 0x3A
>> [    0.853791] intel_idle: lapic_timer_reliable_states 0xffffffff
>> [    0.853831] GHES: HEST is not enabled!
>> [    0.853867] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    0.854246] Linux agpgart interface v0.103
>> [    0.854266] [drm] Initialized drm 1.1.0 20060810
>> [    0.854329] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
>> [    0.872670] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    0.872697] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    0.872780] mousedev: PS/2 mouse device common for all mice
>> [    0.873074] rtc_cmos 00:06: RTC can wake from S4
>> [    0.873193] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
>> [    0.873221] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
>> [    0.873337] cpuidle: using governor ladder
>> [    0.873495] cpuidle: using governor menu
>> [    0.873532] drop_monitor: Initializing network drop monitor service
>> [    0.873596] TCP: cubic registered
>> [    0.873668] NET: Registered protocol family 10
>> [    0.873823] mip6: Mobile IPv6
>> [    0.873826] NET: Registered protocol family 17
>> [    0.873833] Key type dns_resolver registered
>> [    0.874340] PM: Hibernation image not present or could not be loaded.
>> [    0.874350] registered taskstats version 1
>> [    0.875047]   Magic number: 13:845:640
>> [    0.875142] rtc_cmos 00:06: setting system clock to 2013-01-08 16:36:26 UTC (1357662986)
>> [    0.876230] Freeing unused kernel memory: 592k freed
>> [    0.876313] Write protecting the kernel read-only data: 8192k
>> [    0.880170] Freeing unused kernel memory: 1564k freed
>> [    0.881569] Freeing unused kernel memory: 476k freed
>> [    0.893070] udevd[92]: starting version 175
>> [    0.897556] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
>> [    0.903312] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0C:00/input/input1
>> [    0.903319] ACPI: Power Button [PWRB]
>> [    0.903400] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
>> [    0.903452] ACPI: Lid Switch [LID0]
>> [    0.903505] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
>> [    0.903509] ACPI: Power Button [PWRF]
>> [    0.916022] ACPI: bus type usb registered
>> [    0.916047] usbcore: registered new interface driver usbfs
>> [    0.916055] usbcore: registered new interface driver hub
>> [    0.916745] usbcore: registered new device driver usb
>> [    0.917383] xhci_hcd 0000:00:14.0: setting latency timer to 64
>> [    0.917391] xhci_hcd 0000:00:14.0: xHCI Host Controller
>> [    0.917401] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
>> [    0.917404] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    0.917819] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
>> [    0.917850] xhci_hcd 0000:00:14.0: irq 21, io mem 0xc3600000
>> [    0.917912] xhci_hcd 0000:00:14.0: irq 41 for MSI/MSI-X
>> [    0.917977] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    0.917981] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    0.917984] usb usb1: Product: xHCI Host Controller
>> [    0.917986] usb usb1: Manufacturer: Linux 3.7.1 xhci_hcd
>> [    0.917988] usb usb1: SerialNumber: 0000:00:14.0
>> [    0.918112] xHCI xhci_add_endpoint called for root hub
>> [    0.918115] xHCI xhci_check_bandwidth called for root hub
>> [    0.918152] hub 1-0:1.0: USB hub found
>> [    0.918161] hub 1-0:1.0: 4 ports detected
>> [    0.918601] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
>> [    0.918854] r8169 0000:07:00.0: irq 42 for MSI/MSI-X
>> [    0.918960] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919001] xhci_hcd 0000:00:14.0: xHCI Host Controller
>> [    0.919007] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919009] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
>> [    0.919038] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
>> [    0.919042] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    0.919045] usb usb2: Product: xHCI Host Controller
>> [    0.919048] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919049] usb usb2: Manufacturer: Linux 3.7.1 xhci_hcd
>> [    0.919051] usb usb2: SerialNumber: 0000:00:14.0
>> [    0.919095] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919132] microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919136] r8169 0000:07:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000060000, d4:be:d9:62:91:a0, XID 0c900880 IRQ 42
>> [    0.919139] r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
>> [    0.919162] xHCI xhci_add_endpoint called for root hub
>> [    0.919165] xHCI xhci_check_bandwidth called for root hub
>> [    0.919186] microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919201] hub 2-0:1.0: USB hub found
>> [    0.919212] hub 2-0:1.0: 4 ports detected
>> [    0.919234] microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919280] microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x15
>> [    0.919468] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> [    0.925058] ehci_hcd 0000:00:1a.0: setting latency timer to 64
>> [    0.925065] ehci_hcd 0000:00:1a.0: EHCI Host Controller
>> [    0.925072] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
>> [    0.928990] ehci_hcd 0000:00:1a.0: debug port 2
>> [    0.929000] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
>> [    0.929017] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xc3619000
>> [    0.934714] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
>> [    0.934735] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
>> [    0.934737] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    0.934739] usb usb3: Product: EHCI Host Controller
>> [    0.934741] usb usb3: Manufacturer: Linux 3.7.1 ehci_hcd
>> [    0.934742] usb usb3: SerialNumber: 0000:00:1a.0
>> [    0.934919] hub 3-0:1.0: USB hub found
>> [    0.934924] hub 3-0:1.0: 2 ports detected
>> [    0.935074] ehci_hcd 0000:00:1d.0: setting latency timer to 64
>> [    0.935079] ehci_hcd 0000:00:1d.0: EHCI Host Controller
>> [    0.935084] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
>> [    0.938982] ehci_hcd 0000:00:1d.0: debug port 2
>> [    0.938990] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
>> [    0.939003] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xc3618000
>> [    0.944698] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>> [    0.944718] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
>> [    0.944721] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    0.944723] usb usb4: Product: EHCI Host Controller
>> [    0.944725] usb usb4: Manufacturer: Linux 3.7.1 ehci_hcd
>> [    0.944727] usb usb4: SerialNumber: 0000:00:1d.0
>> [    0.944893] hub 4-0:1.0: USB hub found
>> [    0.944897] hub 4-0:1.0: 2 ports detected
>> [    0.945038] ahci 0000:00:1f.2: version 3.0
>> [    0.945131] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
>> [    0.955696] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x5 impl SATA mode
>> [    0.955700] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
>> [    0.955706] ahci 0000:00:1f.2: setting latency timer to 64
>> [    0.958112] scsi0 : ahci
>> [    0.958263] scsi1 : ahci
>> [    0.958407] scsi2 : ahci
>> [    0.958549] scsi3 : ahci
>> [    0.958686] scsi4 : ahci
>> [    0.958830] scsi5 : ahci
>> [    0.958884] ata1: SATA max UDMA/133 abar m2048@0xc3617000 port 0xc3617100 irq 43
>> [    0.958886] ata2: DUMMY
>> [    0.958889] ata3: SATA max UDMA/133 abar m2048@0xc3617000 port 0xc3617200 irq 43
>> [    0.958890] ata4: DUMMY
>> [    0.958891] ata5: DUMMY
>> [    0.958892] ata6: DUMMY
>> [    0.959201] pci 0000:00:00.0: Intel Ivybridge Chipset
>> [    0.959326] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
>> [    0.960705] pci 0000:00:00.0: detected 65536K stolen memory
>> [    0.960751] checking generic (b0000000 7f0000) vs hw (b0000000 10000000)
>> [    0.960753] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
>> [    0.960774] Console: switching to colour dummy device 80x25
>> [    0.960915] i915 0000:00:02.0: setting latency timer to 64
>> [    1.000568] [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake old ack to clear.
>> [    1.000691] i915 0000:00:02.0: irq 44 for MSI/MSI-X
>> [    1.000698] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>> [    1.000699] [drm] Driver supports precise vblank timestamp query.
>> [    1.000778] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
>> [    1.000780] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
>> [    1.081142] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
>> [    1.146423] fbcon: inteldrmfb (fb0) is primary device
>> [    1.236311] usb 3-1: new high-speed USB device number 2 using ehci_hcd
>> [    1.263263] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    1.263285] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>> [    1.264479] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
>> [    1.264542] ata1.00: ATA-9: OCZ-VERTEX4, 1.5, max UDMA/133
>> [    1.264544] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> [    1.265399] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
>> [    1.265473] ata1.00: configured for UDMA/133
>> [    1.267459] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX4      1.5  PQ: 0 ANSI: 5
>> [    1.267708] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
>> [    1.267771] sd 0:0:0:0: [sda] Write Protect is off
>> [    1.267774] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    1.267794] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    1.269704]  sda: sda1 sda2 sda3 sda4 sda5
>> [    1.270264] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    1.278693] ata3.00: ATAPI: MATSHITA DVD+/-RW UJ8D1, D.02, max UDMA/100
>> [    1.297024] ata3.00: configured for UDMA/100
>> [    1.308868] scsi 2:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ8D1    D.02 PQ: 0 ANSI: 5
>> [    1.309232] ACPI: Invalid Power Resource to register!
>> [    1.313893] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [    1.313929] sr 2:0:0:0: Attached scsi generic sg1 type 5
>> [    1.318407] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
>> [    1.318409] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    1.318564] sr 2:0:0:0: Attached scsi CD-ROM sr0
>> [    1.350489] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
>> [    1.350491] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [    1.350739] hub 3-1:1.0: USB hub found
>> [    1.350816] hub 3-1:1.0: 6 ports detected
>> [    1.453928] usb 4-1: new high-speed USB device number 2 using ehci_hcd
>> [    1.568163] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
>> [    1.568165] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> [    1.568421] hub 4-1:1.0: USB hub found
>> [    1.568491] hub 4-1:1.0: 8 ports detected
>> [    1.642759] usb 3-1.1: new full-speed USB device number 3 using ehci_hcd
>> [    1.731445] usb 3-1.1: New USB device found, idVendor=138a, idProduct=0011
>> [    1.731447] usb 3-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=1
>> [    1.731449] usb 3-1.1: SerialNumber: 5db29fbb9f4c
>> [    1.804560] usb 3-1.3: new high-speed USB device number 4 using ehci_hcd
>> [    1.822412] tsc: Refined TSC clocksource calibration: 2095.240 MHz
>> [    1.822415] Switching to clocksource tsc
>> [    1.831430] ACPI: Invalid Power Resource to register!
>> [    1.831431] Console: switching to colour frame buffer device 240x67
>> [    1.837649] fb0: inteldrmfb frame buffer device
>> [    1.837650] drm: registered panic notifier
>> [    1.837831] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
>> [    1.838744] acpi device:32: registered as cooling_device0
>> [    1.838906] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
>> [    1.838959] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:30/LNXVIDEO:00/input/input4
>> [    1.838980] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
>> [    1.839688] acpi device:41: registered as cooling_device1
>> [    1.839811] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>> [    1.839847] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:02/input/input5
>> [    1.839864] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>> [    1.861142] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
>> [    1.861146] EXT4-fs (sda2): write access will be enabled during recovery
>> [    1.879339] EXT4-fs (sda2): recovery complete
>> [    1.881583] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
>> [    1.890126] usb 3-1.3: New USB device found, idVendor=0bda, idProduct=0129
>> [    1.890131] usb 3-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [    1.890133] usb 3-1.3: Product: USB2.0-CRW
>> [    1.890135] usb 3-1.3: Manufacturer: Generic
>> [    1.890136] usb 3-1.3: SerialNumber: 20100201396000000
>> [    1.963271] usb 3-1.5: new high-speed USB device number 5 using ehci_hcd
>> [    2.051983] udevd[395]: starting version 175
>> [    2.104301] ACPI: Requesting acpi_cpufreq
>> [    2.107970] ACPI: AC Adapter [ACAD] (on-line)
>> [    2.120282] usb 3-1.5: New USB device found, idVendor=0c45, idProduct=648b
>> [    2.120286] usb 3-1.5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
>> [    2.120289] usb 3-1.5: Product: Laptop_Integrated_Webcam_E4HD
>> [    2.120290] usb 3-1.5: Manufacturer: CNFB183I3620100005L2
>> [    2.120408] wmi: Mapper loaded
>> [    2.124274] mei 0000:00:16.0: setting latency timer to 64
>> [    2.124348] mei 0000:00:16.0: irq 45 for MSI/MSI-X
>> [    2.127270] input: PC Speaker as /devices/platform/pcspkr/input/input6
>> [    2.128371] ACPI Warning: 0x0000000000005040-0x000000000000505f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
>> [    2.128380] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>> [    2.129998] mei 0000:00:16.0: wd: failed to find the client
>> [    2.135574] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
>> [    2.199916] usb 4-1.5: new full-speed USB device number 3 using ehci_hcd
>> [    2.207439] media: Linux media interface: v0.10
>> [    2.214444] rts5139: module is from the staging directory, the quality is unknown, you have been warned.
>> [    2.218219] scsi6 : SCSI emulation for RTS5139 USB card reader
>> [    2.218377] usbcore: registered new interface driver rts5139
>> [    2.218696] scsi 6:0:0:0: Direct-Access     Generic- xD/SD/M.S.       1.00 PQ: 0 ANSI: 0 CCS
>> [    2.219511] sd 6:0:0:0: Attached scsi generic sg2 type 0
>> [    2.222269] sd 6:0:0:0: [sdb] Attached SCSI removable disk
>> [    2.286677] usb 4-1.5: New USB device found, idVendor=0cf3, idProduct=e004
>> [    2.286682] usb 4-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [    2.286685] usb 4-1.5: Product: Bluetooth USB Host Controller
>> [    2.286688] usb 4-1.5: Manufacturer: Atheros Communications
>> [    2.286691] usb 4-1.5: SerialNumber: Alaska Day 2006
>> [    2.312704] ACPI: Battery Slot [BAT1] (battery present)
>> [    2.568155] Registered led device: dell-laptop::touchpad
>> [    2.568374] input: Dell WMI hotkeys as /devices/virtual/input/input7
>> [    2.568543] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
>> [    2.568551] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>> [    2.568556] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 1 (20120913/utaddress-251)
>> [    2.568562] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
>> [    2.568567] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>> [    2.568569] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 1 (20120913/utaddress-251)
>> [    2.568573] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
>> [    2.568578] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>> [    2.568579] lpc_ich: Resource conflict(s) found affecting gpio_ich
>> [    2.572626] Linux video capture interface: v2.00
>> [    2.572631] iTCO_vendor_support: vendor-support=0
>> [    2.572696] cfg80211: Calling CRDA to update world regulatory domain
>> [    2.573936] Bluetooth: Core ver 2.16
>> [    2.573945] NET: Registered protocol family 31
>> [    2.573947] Bluetooth: HCI device and connection manager initialized
>> [    2.573952] Bluetooth: HCI socket layer initialized
>> [    2.573953] Bluetooth: L2CAP socket layer initialized
>> [    2.573957] Bluetooth: SCO socket layer initialized
>> [    2.574177] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
>> [    2.574210] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
>> [    2.574317] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
>> [    2.577419] usbcore: registered new interface driver btusb
>> [    2.577668] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
>> [    2.582981] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_E4HD (0c45:648b)
>> [    2.583068] [drm] radeon kernel modesetting enabled.
>> [    2.583082] VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
>> [    2.586470] ata1.00: configured for UDMA/133
>> [    2.586475] ata1: EH complete
>> [    2.593260] radeon 0000:01:00.0: enabling device (0000 -> 0003)
>> [    2.593397] [drm] initializing kernel modesetting (TURKS 0x1002:0x6840 0x1028:0x056E).
>> [    2.593827] [drm] register mmio base: 0xC2000000
>> [    2.593829] [drm] register mmio size: 131072
>> [    2.593830] vga_switcheroo: enabled
>> [    2.593927] ATPX version 1
>> [    2.595391] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
>> [    2.604824] cfg80211: World regulatory domain updated:
>> [    2.604827] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> [    2.604831] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [    2.604833] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> [    2.604836] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> [    2.604838] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [    2.604841] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [    2.608942] input: Laptop_Integrated_Webcam_E4HD as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.5/3-1.5:1.0/input/input8
>> [    2.609010] usbcore: registered new interface driver uvcvideo
>> [    2.609011] USB Video Class driver (1.1.1)
>> [    2.609328] hda_codec: CX20590: BIOS auto-probing.
>> [    2.610175] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
>> [    2.616226] ath: phy0: ASPM enabled: 0x43
>> [    2.616230] ath: EEPROM regdomain: 0x60
>> [    2.616232] ath: EEPROM indicates we should expect a direct regpair map
>> [    2.616235] ath: Country alpha2 being used: 00
>> [    2.616237] ath: Regpair used: 0x60
>> [    2.616985] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
>> [    2.617146] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
>> [    2.617373] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
>> [    2.621002] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
>> [    2.621228] Registered led device: ath9k-phy0
>> [    2.621235] ieee80211 phy0: Atheros AR9485 Rev:1 mem=0xffffc90022900000, irq=17
>> [    2.626014] cfg80211: Calling CRDA for country: PL
>> [    2.628746] cfg80211: Regulatory domain changed to country: PL
>> [    2.628750] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> [    2.628753] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> [    2.628755] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> [    2.628757] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> [    2.628759] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
>> [    2.633426] usbcore: registered new interface driver ath3k
>> [    2.730667] usb 4-1.5: USB disconnect, device number 3
>> [    2.907868] usb 4-1.5: new full-speed USB device number 4 using ehci_hcd
>> [    2.994859] usb 4-1.5: New USB device found, idVendor=0cf3, idProduct=e004
>> [    2.994868] usb 4-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [    2.994873] usb 4-1.5: Product: Bluetooth USB Host Controller
>> [    2.994878] usb 4-1.5: Manufacturer: Atheros Communications
>> [    2.994882] usb 4-1.5: SerialNumber: Alaska Day 2006
>> [    3.038993] ATOM BIOS: Dell/Compal
>> [    3.039022] [drm] GPU not posted. posting now...
>> [    3.042795] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
>> [    3.042800] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
>> [    3.042812] mtrr: no more MTRRs available
>> [    3.042815] [drm] Detected VRAM RAM=1024M, BAR=256M
>> [    3.042817] [drm] RAM width 128bits DDR
>> [    3.042972] [TTM] Zone  kernel: Available graphics memory: 6088832 kiB
>> [    3.042976] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
>> [    3.042978] [TTM] Initializing pool allocator
>> [    3.042984] [TTM] Initializing DMA pool allocator
>> [    3.043021] [drm] radeon: 1024M of VRAM memory ready
>> [    3.043023] [drm] radeon: 512M of GTT memory ready.
>> [    3.043043] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>> [    3.043045] [drm] Driver supports precise vblank timestamp query.
>> [    3.043099] radeon 0000:01:00.0: irq 47 for MSI/MSI-X
>> [    3.043113] radeon 0000:01:00.0: radeon: using MSI.
>> [    3.043162] [drm] radeon: irq initialized.
>> [    3.043170] [drm] GART: num cpu pages 131072, num gpu pages 131072
>> [    3.043873] [drm] probing gen 2 caps for device 8086:151 = 3/e
>> [    3.043878] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
>> [    3.044066] [drm] Loading TURKS Microcode
>> [    3.047923] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
>> [    3.048094] radeon 0000:01:00.0: WB enabled
>> [    3.048099] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88034b6efc00
>> [    3.064893] [drm] ring test on 0 succeeded in 1 usecs
>> [    3.065082] [drm] ib test on ring 0 succeeded in 0 usecs
>> [    3.065190] [drm] Radeon Display Connectors
>> [    3.067701] [drm] Internal thermal controller with fan control
>> [    3.068566] [drm] radeon: power management initialized
>> [    3.068667] No connectors reported connected with modes
>> [    3.068669] [drm] Cannot find any crtc or sizes - going 1024x768
>> [    3.070113] [drm] fb mappable at 0xA0142000
>> [    3.070114] [drm] vram apper at 0xA0000000
>> [    3.070115] [drm] size 3145728
>> [    3.070117] [drm] fb depth is 24
>> [    3.070118] [drm]    pitch is 4096
>> [    3.070222] fb1: radeondrmfb frame buffer device
>> [    3.070242] [drm] Initialized radeon 2.24.0 20080528 for 0000:01:00.0 on minor 1
>> [    3.348920] EXT4-fs (sda2): re-mounted. Opts: (null)
>> [    3.391412] EXT4-fs (sda2): re-mounted. Opts: discard,user_xattr,errors=remount-ro
>> [    3.427091] loop: module loaded
>> [    3.515014] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f02)
>> [    3.546317] psmouse serio1: elantech: Synaptics capabilities query result 0x79, 0x17, 0x0c.
>> [    3.706748] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input13
>> [    3.961227] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: discard
>> [    3.970949] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: user_xattr,discard
>> [    3.975743] FAT-fs (sda5): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
>> [    4.369198] RPC: Registered named UNIX socket transport module.
>> [    4.369202] RPC: Registered udp transport module.
>> [    4.369204] RPC: Registered tcp transport module.
>> [    4.369206] RPC: Registered tcp NFSv4.1 backchannel transport module.
>> [    4.373352] FS-Cache: Loaded
>> [    4.379657] FS-Cache: Netfs 'nfs' registered for caching
>> [    4.387749] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
>> [    5.131652] i8k: unable to get SMM BIOS version
>> [    5.131865] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
>> [    5.254200] Bluetooth: RFCOMM TTY layer initialized
>> [    5.254212] Bluetooth: RFCOMM socket layer initialized
>> [    5.254213] Bluetooth: RFCOMM ver 1.11
>> [    5.254440] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>> [    5.254445] Bluetooth: BNEP filters: protocol multicast
>> [    5.254448] Bluetooth: BNEP socket layer initialized
>> [    5.500983] r8169 0000:07:00.0 eth1: link down
>> [    5.501030] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
>> [    5.511732] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
>> [    6.134390] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input14
>> [    6.155793] radeon: switched off
>> [    6.507796] EXT4-fs (sda2): re-mounted. Opts: discard,errors=remount-ro,data=ordered,commit=360
>> [    6.512504] EXT4-fs (sda1): re-mounted. Opts: discard,data=ordered,commit=360
>> [    6.516752] ata1.00: configured for UDMA/133
>> [    6.516758] ata1: EH complete
>> [    6.528987] EXT4-fs (sda3): re-mounted. Opts: discard,data=ordered,commit=360
>> [    7.652058] wlan1: authenticate with 00:0f:3d:df:42:fe
>> [    7.660605] wlan1: send auth to 00:0f:3d:df:42:fe (try 1/3)
>> [    7.662884] wlan1: authenticated
>> [    7.662975] ath9k 0000:08:00.0 wlan1: disabling HT as WMM/QoS is not supported by the AP
>> [    7.662978] ath9k 0000:08:00.0 wlan1: disabling VHT as WMM/QoS is not supported by the AP
>> [    7.663629] wlan1: associate with 00:0f:3d:df:42:fe (try 1/3)
>> [    7.666152] wlan1: RX AssocResp from 00:0f:3d:df:42:fe (capab=0x431 status=0 aid=4)
>> [    7.666199] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
>> [    7.666249] wlan1: associated
>> [    7.666270] cfg80211: Calling CRDA for country: GB
>> [    7.668925] ath: regdomain 0x833a updated by CountryIE
>> [    7.668928] ath: EEPROM regdomain: 0x833a
>> [    7.668929] ath: EEPROM indicates we should expect a country code
>> [    7.668930] ath: doing EEPROM country->regdmn map search
>> [    7.668931] ath: country maps to regdmn code: 0x37
>> [    7.668932] ath: Country alpha2 being used: GB
>> [    7.668933] ath: Regpair used: 0x37
>> [    7.668951] cfg80211: Regulatory domain changed to country: GB
>> [    7.668952] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> [    7.668953] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> [    7.668954] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> [    7.668955] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>> [    7.668956] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
>> [  530.566393] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
>> [  530.581089] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
>> [  530.595712] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
>> [  530.610841] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
>> [  530.625458] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
>> [  530.625465] psmouse serio1: issuing reconnect request
>>
> 
>> #
>> # Automatically generated file; DO NOT EDIT.
>> # Linux/x86_64 3.7.1 Kernel Configuration
>> #
>> CONFIG_64BIT=y
>> CONFIG_X86_64=y
>> CONFIG_X86=y
>> CONFIG_INSTRUCTION_DECODER=y
>> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
>> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
>> CONFIG_LOCKDEP_SUPPORT=y
>> CONFIG_STACKTRACE_SUPPORT=y
>> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
>> CONFIG_MMU=y
>> CONFIG_NEED_DMA_MAP_STATE=y
>> CONFIG_NEED_SG_DMA_LENGTH=y
>> CONFIG_GENERIC_ISA_DMA=y
>> CONFIG_GENERIC_BUG=y
>> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
>> CONFIG_GENERIC_HWEIGHT=y
>> CONFIG_GENERIC_GPIO=y
>> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
>> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
>> CONFIG_GENERIC_CALIBRATE_DELAY=y
>> CONFIG_ARCH_HAS_CPU_RELAX=y
>> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
>> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
>> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
>> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
>> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
>> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
>> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
>> CONFIG_ARCH_SUSPEND_POSSIBLE=y
>> CONFIG_ZONE_DMA32=y
>> CONFIG_AUDIT_ARCH=y
>> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
>> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
>> CONFIG_HAVE_INTEL_TXT=y
>> CONFIG_X86_64_SMP=y
>> CONFIG_X86_HT=y
>> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
>> CONFIG_ARCH_CPU_PROBE_RELEASE=y
>> CONFIG_ARCH_SUPPORTS_UPROBES=y
>> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>> CONFIG_HAVE_IRQ_WORK=y
>> CONFIG_IRQ_WORK=y
>> CONFIG_BUILDTIME_EXTABLE_SORT=y
>>
>> #
>> # General setup
>> #
>> CONFIG_EXPERIMENTAL=y
>> CONFIG_INIT_ENV_ARG_LIMIT=32
>> CONFIG_CROSS_COMPILE=""
>> CONFIG_LOCALVERSION=""
>> # CONFIG_LOCALVERSION_AUTO is not set
>> CONFIG_HAVE_KERNEL_GZIP=y
>> CONFIG_HAVE_KERNEL_BZIP2=y
>> CONFIG_HAVE_KERNEL_LZMA=y
>> CONFIG_HAVE_KERNEL_XZ=y
>> CONFIG_HAVE_KERNEL_LZO=y
>> # CONFIG_KERNEL_GZIP is not set
>> # CONFIG_KERNEL_BZIP2 is not set
>> # CONFIG_KERNEL_LZMA is not set
>> CONFIG_KERNEL_XZ=y
>> # CONFIG_KERNEL_LZO is not set
>> CONFIG_DEFAULT_HOSTNAME="(none)"
>> CONFIG_SWAP=y
>> CONFIG_SYSVIPC=y
>> CONFIG_SYSVIPC_SYSCTL=y
>> CONFIG_POSIX_MQUEUE=y
>> CONFIG_POSIX_MQUEUE_SYSCTL=y
>> CONFIG_FHANDLE=y
>> CONFIG_AUDIT=y
>> CONFIG_AUDITSYSCALL=y
>> CONFIG_AUDIT_WATCH=y
>> CONFIG_AUDIT_TREE=y
>> CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
>> CONFIG_HAVE_GENERIC_HARDIRQS=y
>>
>> #
>> # IRQ subsystem
>> #
>> CONFIG_GENERIC_HARDIRQS=y
>> CONFIG_GENERIC_IRQ_PROBE=y
>> CONFIG_GENERIC_IRQ_SHOW=y
>> CONFIG_GENERIC_PENDING_IRQ=y
>> CONFIG_GENERIC_IRQ_CHIP=y
>> CONFIG_IRQ_DOMAIN=y
>> CONFIG_IRQ_DOMAIN_DEBUG=y
>> CONFIG_IRQ_FORCED_THREADING=y
>> CONFIG_SPARSE_IRQ=y
>> CONFIG_CLOCKSOURCE_WATCHDOG=y
>> CONFIG_ARCH_CLOCKSOURCE_DATA=y
>> CONFIG_GENERIC_TIME_VSYSCALL=y
>> CONFIG_GENERIC_CLOCKEVENTS=y
>> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
>> CONFIG_GENERIC_CMOS_UPDATE=y
>>
>> #
>> # Timers subsystem
>> #
>> CONFIG_TICK_ONESHOT=y
>> CONFIG_NO_HZ=y
>> CONFIG_HIGH_RES_TIMERS=y
>>
>> #
>> # CPU/Task time and stats accounting
>> #
>> CONFIG_TICK_CPU_ACCOUNTING=y
>> # CONFIG_IRQ_TIME_ACCOUNTING is not set
>> CONFIG_BSD_PROCESS_ACCT=y
>> CONFIG_BSD_PROCESS_ACCT_V3=y
>> CONFIG_TASKSTATS=y
>> CONFIG_TASK_DELAY_ACCT=y
>> CONFIG_TASK_XACCT=y
>> CONFIG_TASK_IO_ACCOUNTING=y
>>
>> #
>> # RCU Subsystem
>> #
>> CONFIG_TREE_PREEMPT_RCU=y
>> CONFIG_PREEMPT_RCU=y
>> # CONFIG_RCU_USER_QS is not set
>> CONFIG_RCU_FANOUT=64
>> CONFIG_RCU_FANOUT_LEAF=16
>> # CONFIG_RCU_FANOUT_EXACT is not set
>> CONFIG_RCU_FAST_NO_HZ=y
>> # CONFIG_TREE_RCU_TRACE is not set
>> # CONFIG_RCU_BOOST is not set
>> CONFIG_IKCONFIG=y
>> CONFIG_IKCONFIG_PROC=y
>> CONFIG_LOG_BUF_SHIFT=17
>> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>> CONFIG_CGROUPS=y
>> # CONFIG_CGROUP_DEBUG is not set
>> CONFIG_CGROUP_FREEZER=y
>> CONFIG_CGROUP_DEVICE=y
>> CONFIG_CPUSETS=y
>> CONFIG_PROC_PID_CPUSET=y
>> CONFIG_CGROUP_CPUACCT=y
>> CONFIG_RESOURCE_COUNTERS=y
>> CONFIG_MEMCG=y
>> # CONFIG_MEMCG_SWAP is not set
>> # CONFIG_MEMCG_KMEM is not set
>> CONFIG_CGROUP_HUGETLB=y
>> CONFIG_CGROUP_PERF=y
>> CONFIG_CGROUP_SCHED=y
>> CONFIG_FAIR_GROUP_SCHED=y
>> # CONFIG_CFS_BANDWIDTH is not set
>> # CONFIG_RT_GROUP_SCHED is not set
>> CONFIG_BLK_CGROUP=y
>> # CONFIG_DEBUG_BLK_CGROUP is not set
>> # CONFIG_CHECKPOINT_RESTORE is not set
>> CONFIG_NAMESPACES=y
>> CONFIG_UTS_NS=y
>> CONFIG_IPC_NS=y
>> CONFIG_PID_NS=y
>> CONFIG_NET_NS=y
>> CONFIG_SCHED_AUTOGROUP=y
>> CONFIG_MM_OWNER=y
>> # CONFIG_SYSFS_DEPRECATED is not set
>> CONFIG_RELAY=y
>> CONFIG_BLK_DEV_INITRD=y
>> CONFIG_INITRAMFS_SOURCE=""
>> CONFIG_RD_GZIP=y
>> CONFIG_RD_BZIP2=y
>> CONFIG_RD_LZMA=y
>> CONFIG_RD_XZ=y
>> CONFIG_RD_LZO=y
>> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
>> CONFIG_SYSCTL=y
>> CONFIG_ANON_INODES=y
>> # CONFIG_EXPERT is not set
>> CONFIG_HAVE_UID16=y
>> CONFIG_UID16=y
>> # CONFIG_SYSCTL_SYSCALL is not set
>> CONFIG_SYSCTL_EXCEPTION_TRACE=y
>> CONFIG_KALLSYMS=y
>> # CONFIG_KALLSYMS_ALL is not set
>> CONFIG_HOTPLUG=y
>> CONFIG_PRINTK=y
>> CONFIG_BUG=y
>> CONFIG_ELF_CORE=y
>> CONFIG_PCSPKR_PLATFORM=y
>> CONFIG_HAVE_PCSPKR_PLATFORM=y
>> CONFIG_BASE_FULL=y
>> CONFIG_FUTEX=y
>> CONFIG_EPOLL=y
>> CONFIG_SIGNALFD=y
>> CONFIG_TIMERFD=y
>> CONFIG_EVENTFD=y
>> CONFIG_SHMEM=y
>> CONFIG_AIO=y
>> # CONFIG_EMBEDDED is not set
>> CONFIG_HAVE_PERF_EVENTS=y
>>
>> #
>> # Kernel Performance Events And Counters
>> #
>> CONFIG_PERF_EVENTS=y
>> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
>> CONFIG_VM_EVENT_COUNTERS=y
>> CONFIG_PCI_QUIRKS=y
>> CONFIG_SLUB_DEBUG=y
>> # CONFIG_COMPAT_BRK is not set
>> # CONFIG_SLAB is not set
>> CONFIG_SLUB=y
>> CONFIG_PROFILING=y
>> CONFIG_TRACEPOINTS=y
>> CONFIG_OPROFILE=m
>> # CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
>> CONFIG_HAVE_OPROFILE=y
>> CONFIG_OPROFILE_NMI_TIMER=y
>> CONFIG_KPROBES=y
>> CONFIG_JUMP_LABEL=y
>> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
>> CONFIG_KRETPROBES=y
>> CONFIG_HAVE_IOREMAP_PROT=y
>> CONFIG_HAVE_KPROBES=y
>> CONFIG_HAVE_KRETPROBES=y
>> CONFIG_HAVE_OPTPROBES=y
>> CONFIG_HAVE_ARCH_TRACEHOOK=y
>> CONFIG_HAVE_DMA_ATTRS=y
>> CONFIG_USE_GENERIC_SMP_HELPERS=y
>> CONFIG_GENERIC_SMP_IDLE_THREAD=y
>> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
>> CONFIG_HAVE_DMA_API_DEBUG=y
>> CONFIG_HAVE_HW_BREAKPOINT=y
>> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
>> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
>> CONFIG_HAVE_PERF_EVENTS_NMI=y
>> CONFIG_HAVE_PERF_REGS=y
>> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
>> CONFIG_HAVE_ARCH_JUMP_LABEL=y
>> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
>> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
>> CONFIG_HAVE_CMPXCHG_LOCAL=y
>> CONFIG_HAVE_CMPXCHG_DOUBLE=y
>> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
>> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
>> CONFIG_GENERIC_KERNEL_THREAD=y
>> CONFIG_GENERIC_KERNEL_EXECVE=y
>> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
>> CONFIG_SECCOMP_FILTER=y
>> CONFIG_HAVE_RCU_USER_QS=y
>> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
>> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
>> CONFIG_MODULES_USE_ELF_RELA=y
>>
>> #
>> # GCOV-based kernel profiling
>> #
>> # CONFIG_GCOV_KERNEL is not set
>> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
>> CONFIG_SLABINFO=y
>> CONFIG_RT_MUTEXES=y
>> CONFIG_BASE_SMALL=0
>> CONFIG_MODULES=y
>> CONFIG_MODULE_FORCE_LOAD=y
>> CONFIG_MODULE_UNLOAD=y
>> CONFIG_MODULE_FORCE_UNLOAD=y
>> CONFIG_MODVERSIONS=y
>> # CONFIG_MODULE_SRCVERSION_ALL is not set
>> # CONFIG_MODULE_SIG is not set
>> CONFIG_STOP_MACHINE=y
>> CONFIG_BLOCK=y
>> CONFIG_BLK_DEV_BSG=y
>> CONFIG_BLK_DEV_BSGLIB=y
>> CONFIG_BLK_DEV_INTEGRITY=y
>> # CONFIG_BLK_DEV_THROTTLING is not set
>>
>> #
>> # Partition Types
>> #
>> CONFIG_PARTITION_ADVANCED=y
>> # CONFIG_ACORN_PARTITION is not set
>> # CONFIG_OSF_PARTITION is not set
>> # CONFIG_AMIGA_PARTITION is not set
>> # CONFIG_ATARI_PARTITION is not set
>> CONFIG_MAC_PARTITION=y
>> CONFIG_MSDOS_PARTITION=y
>> CONFIG_BSD_DISKLABEL=y
>> # CONFIG_MINIX_SUBPARTITION is not set
>> # CONFIG_SOLARIS_X86_PARTITION is not set
>> # CONFIG_UNIXWARE_DISKLABEL is not set
>> CONFIG_LDM_PARTITION=y
>> # CONFIG_LDM_DEBUG is not set
>> # CONFIG_SGI_PARTITION is not set
>> # CONFIG_ULTRIX_PARTITION is not set
>> # CONFIG_SUN_PARTITION is not set
>> # CONFIG_KARMA_PARTITION is not set
>> CONFIG_EFI_PARTITION=y
>> # CONFIG_SYSV68_PARTITION is not set
>> CONFIG_BLOCK_COMPAT=y
>>
>> #
>> # IO Schedulers
>> #
>> CONFIG_IOSCHED_NOOP=y
>> CONFIG_IOSCHED_DEADLINE=y
>> CONFIG_IOSCHED_CFQ=y
>> CONFIG_CFQ_GROUP_IOSCHED=y
>> # CONFIG_DEFAULT_DEADLINE is not set
>> CONFIG_DEFAULT_CFQ=y
>> # CONFIG_DEFAULT_NOOP is not set
>> CONFIG_DEFAULT_IOSCHED="cfq"
>> CONFIG_PADATA=y
>> CONFIG_ASN1=m
>> CONFIG_UNINLINE_SPIN_UNLOCK=y
>> CONFIG_MUTEX_SPIN_ON_OWNER=y
>> CONFIG_FREEZER=y
>>
>> #
>> # Processor type and features
>> #
>> CONFIG_ZONE_DMA=y
>> CONFIG_SMP=y
>> CONFIG_X86_X2APIC=y
>> CONFIG_X86_MPPARSE=y
>> # CONFIG_X86_EXTENDED_PLATFORM is not set
>> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
>> CONFIG_SCHED_OMIT_FRAME_POINTER=y
>> CONFIG_PARAVIRT_GUEST=y
>> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
>> # CONFIG_XEN is not set
>> # CONFIG_XEN_PRIVILEGED_GUEST is not set
>> # CONFIG_KVM_GUEST is not set
>> # CONFIG_PARAVIRT is not set
>> CONFIG_NO_BOOTMEM=y
>> CONFIG_MEMTEST=y
>> # CONFIG_MK8 is not set
>> # CONFIG_MPSC is not set
>> CONFIG_MCORE2=y
>> # CONFIG_MATOM is not set
>> # CONFIG_GENERIC_CPU is not set
>> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
>> CONFIG_X86_CMPXCHG=y
>> CONFIG_X86_L1_CACHE_SHIFT=6
>> CONFIG_X86_XADD=y
>> CONFIG_X86_WP_WORKS_OK=y
>> CONFIG_X86_INTEL_USERCOPY=y
>> CONFIG_X86_USE_PPRO_CHECKSUM=y
>> CONFIG_X86_P6_NOP=y
>> CONFIG_X86_TSC=y
>> CONFIG_X86_CMPXCHG64=y
>> CONFIG_X86_CMOV=y
>> CONFIG_X86_MINIMUM_CPU_FAMILY=64
>> CONFIG_X86_DEBUGCTLMSR=y
>> CONFIG_CPU_SUP_INTEL=y
>> CONFIG_CPU_SUP_AMD=y
>> CONFIG_CPU_SUP_CENTAUR=y
>> CONFIG_HPET_TIMER=y
>> CONFIG_HPET_EMULATE_RTC=y
>> CONFIG_DMI=y
>> CONFIG_GART_IOMMU=y
>> # CONFIG_CALGARY_IOMMU is not set
>> CONFIG_SWIOTLB=y
>> CONFIG_IOMMU_HELPER=y
>> # CONFIG_MAXSMP is not set
>> CONFIG_NR_CPUS=8
>> CONFIG_SCHED_SMT=y
>> CONFIG_SCHED_MC=y
>> # CONFIG_PREEMPT_NONE is not set
>> # CONFIG_PREEMPT_VOLUNTARY is not set
>> CONFIG_PREEMPT=y
>> CONFIG_PREEMPT_COUNT=y
>> CONFIG_X86_LOCAL_APIC=y
>> CONFIG_X86_IO_APIC=y
>> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
>> CONFIG_X86_MCE=y
>> CONFIG_X86_MCE_INTEL=y
>> CONFIG_X86_MCE_AMD=y
>> CONFIG_X86_MCE_THRESHOLD=y
>> CONFIG_X86_MCE_INJECT=m
>> CONFIG_X86_THERMAL_VECTOR=y
>> CONFIG_I8K=m
>> CONFIG_MICROCODE=m
>> CONFIG_MICROCODE_INTEL=y
>> CONFIG_MICROCODE_AMD=y
>> CONFIG_MICROCODE_OLD_INTERFACE=y
>> CONFIG_X86_MSR=m
>> CONFIG_X86_CPUID=m
>> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
>> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
>> CONFIG_DIRECT_GBPAGES=y
>> CONFIG_NUMA=y
>> CONFIG_AMD_NUMA=y
>> CONFIG_X86_64_ACPI_NUMA=y
>> CONFIG_NODES_SPAN_OTHER_NODES=y
>> CONFIG_NUMA_EMU=y
>> CONFIG_NODES_SHIFT=6
>> CONFIG_ARCH_SPARSEMEM_ENABLE=y
>> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
>> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
>> CONFIG_ARCH_PROC_KCORE_TEXT=y
>> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
>> CONFIG_SELECT_MEMORY_MODEL=y
>> CONFIG_SPARSEMEM_MANUAL=y
>> CONFIG_SPARSEMEM=y
>> CONFIG_NEED_MULTIPLE_NODES=y
>> CONFIG_HAVE_MEMORY_PRESENT=y
>> CONFIG_SPARSEMEM_EXTREME=y
>> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
>> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
>> CONFIG_SPARSEMEM_VMEMMAP=y
>> CONFIG_HAVE_MEMBLOCK=y
>> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
>> CONFIG_ARCH_DISCARD_MEMBLOCK=y
>> CONFIG_MEMORY_ISOLATION=y
>> # CONFIG_MEMORY_HOTPLUG is not set
>> CONFIG_PAGEFLAGS_EXTENDED=y
>> CONFIG_SPLIT_PTLOCK_CPUS=4
>> CONFIG_COMPACTION=y
>> CONFIG_MIGRATION=y
>> CONFIG_PHYS_ADDR_T_64BIT=y
>> CONFIG_ZONE_DMA_FLAG=1
>> CONFIG_BOUNCE=y
>> CONFIG_VIRT_TO_BUS=y
>> CONFIG_MMU_NOTIFIER=y
>> CONFIG_KSM=y
>> CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
>> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
>> CONFIG_MEMORY_FAILURE=y
>> CONFIG_HWPOISON_INJECT=m
>> CONFIG_TRANSPARENT_HUGEPAGE=y
>> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
>> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
>> CONFIG_CROSS_MEMORY_ATTACH=y
>> CONFIG_CLEANCACHE=y
>> CONFIG_FRONTSWAP=y
>> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
>> CONFIG_X86_RESERVE_LOW=64
>> CONFIG_MTRR=y
>> CONFIG_MTRR_SANITIZER=y
>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>> CONFIG_X86_PAT=y
>> CONFIG_ARCH_USES_PG_UNCACHED=y
>> CONFIG_ARCH_RANDOM=y
>> CONFIG_X86_SMAP=y
>> CONFIG_EFI=y
>> CONFIG_EFI_STUB=y
>> CONFIG_SECCOMP=y
>> CONFIG_CC_STACKPROTECTOR=y
>> # CONFIG_HZ_100 is not set
>> # CONFIG_HZ_250 is not set
>> # CONFIG_HZ_300 is not set
>> CONFIG_HZ_1000=y
>> CONFIG_HZ=1000
>> CONFIG_SCHED_HRTICK=y
>> # CONFIG_KEXEC is not set
>> CONFIG_CRASH_DUMP=y
>> CONFIG_PHYSICAL_START=0x1000000
>> CONFIG_RELOCATABLE=y
>> CONFIG_PHYSICAL_ALIGN=0x1000000
>> CONFIG_HOTPLUG_CPU=y
>> # CONFIG_COMPAT_VDSO is not set
>> # CONFIG_CMDLINE_BOOL is not set
>> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>> CONFIG_USE_PERCPU_NUMA_NODE_ID=y
>>
>> #
>> # Power management and ACPI options
>> #
>> CONFIG_ARCH_HIBERNATION_HEADER=y
>> CONFIG_SUSPEND=y
>> CONFIG_SUSPEND_FREEZER=y
>> CONFIG_HIBERNATE_CALLBACKS=y
>> CONFIG_HIBERNATION=y
>> CONFIG_PM_STD_PARTITION=""
>> CONFIG_PM_SLEEP=y
>> CONFIG_PM_SLEEP_SMP=y
>> # CONFIG_PM_AUTOSLEEP is not set
>> # CONFIG_PM_WAKELOCKS is not set
>> CONFIG_PM_RUNTIME=y
>> CONFIG_PM=y
>> CONFIG_PM_DEBUG=y
>> CONFIG_PM_ADVANCED_DEBUG=y
>> # CONFIG_PM_TEST_SUSPEND is not set
>> CONFIG_PM_SLEEP_DEBUG=y
>> CONFIG_PM_TRACE=y
>> CONFIG_PM_TRACE_RTC=y
>> CONFIG_ACPI=y
>> CONFIG_ACPI_SLEEP=y
>> # CONFIG_ACPI_PROCFS is not set
>> # CONFIG_ACPI_PROCFS_POWER is not set
>> # CONFIG_ACPI_EC_DEBUGFS is not set
>> # CONFIG_ACPI_PROC_EVENT is not set
>> CONFIG_ACPI_AC=m
>> CONFIG_ACPI_BATTERY=m
>> CONFIG_ACPI_BUTTON=m
>> CONFIG_ACPI_VIDEO=m
>> CONFIG_ACPI_FAN=m
>> # CONFIG_ACPI_DOCK is not set
>> CONFIG_ACPI_PROCESSOR=m
>> CONFIG_ACPI_IPMI=m
>> CONFIG_ACPI_HOTPLUG_CPU=y
>> CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
>> CONFIG_ACPI_THERMAL=m
>> CONFIG_ACPI_NUMA=y
>> # CONFIG_ACPI_CUSTOM_DSDT is not set
>> CONFIG_ACPI_BLACKLIST_YEAR=0
>> # CONFIG_ACPI_DEBUG is not set
>> CONFIG_ACPI_PCI_SLOT=m
>> CONFIG_X86_PM_TIMER=y
>> CONFIG_ACPI_CONTAINER=m
>> CONFIG_ACPI_SBS=m
>> CONFIG_ACPI_HED=y
>> # CONFIG_ACPI_CUSTOM_METHOD is not set
>> CONFIG_ACPI_BGRT=y
>> CONFIG_ACPI_APEI=y
>> CONFIG_ACPI_APEI_GHES=y
>> CONFIG_ACPI_APEI_PCIEAER=y
>> CONFIG_ACPI_APEI_MEMORY_FAILURE=y
>> # CONFIG_ACPI_APEI_EINJ is not set
>> # CONFIG_ACPI_APEI_ERST_DEBUG is not set
>> # CONFIG_SFI is not set
>>
>> #
>> # CPU Frequency scaling
>> #
>> CONFIG_CPU_FREQ=y
>> CONFIG_CPU_FREQ_TABLE=y
>> CONFIG_CPU_FREQ_STAT=m
>> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
>> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
>> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
>> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
>> CONFIG_CPU_FREQ_GOV_USERSPACE=m
>> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
>> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
>>
>> #
>> # x86 CPU frequency scaling drivers
>> #
>> CONFIG_X86_PCC_CPUFREQ=m
>> CONFIG_X86_ACPI_CPUFREQ=m
>> # CONFIG_X86_ACPI_CPUFREQ_CPB is not set
>> # CONFIG_X86_POWERNOW_K8 is not set
>> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
>> # CONFIG_X86_P4_CLOCKMOD is not set
>>
>> #
>> # shared options
>> #
>> # CONFIG_X86_SPEEDSTEP_LIB is not set
>> CONFIG_CPU_IDLE=y
>> CONFIG_CPU_IDLE_GOV_LADDER=y
>> CONFIG_CPU_IDLE_GOV_MENU=y
>> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
>> CONFIG_INTEL_IDLE=y
>>
>> #
>> # Memory power savings
>> #
>> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
>> CONFIG_I7300_IDLE=m
>>
>> #
>> # Bus options (PCI etc.)
>> #
>> CONFIG_PCI=y
>> CONFIG_PCI_DIRECT=y
>> CONFIG_PCI_MMCONFIG=y
>> CONFIG_PCI_DOMAINS=y
>> CONFIG_PCIEPORTBUS=y
>> CONFIG_HOTPLUG_PCI_PCIE=y
>> CONFIG_PCIEAER=y
>> # CONFIG_PCIE_ECRC is not set
>> CONFIG_PCIEAER_INJECT=m
>> CONFIG_PCIEASPM=y
>> # CONFIG_PCIEASPM_DEBUG is not set
>> CONFIG_PCIEASPM_DEFAULT=y
>> # CONFIG_PCIEASPM_POWERSAVE is not set
>> # CONFIG_PCIEASPM_PERFORMANCE is not set
>> CONFIG_PCIE_PME=y
>> CONFIG_ARCH_SUPPORTS_MSI=y
>> CONFIG_PCI_MSI=y
>> # CONFIG_PCI_DEBUG is not set
>> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
>> # CONFIG_PCI_STUB is not set
>> CONFIG_HT_IRQ=y
>> CONFIG_PCI_ATS=y
>> CONFIG_PCI_IOV=y
>> CONFIG_PCI_PRI=y
>> CONFIG_PCI_PASID=y
>> CONFIG_PCI_IOAPIC=y
>> CONFIG_PCI_LABEL=y
>> CONFIG_ISA_DMA_API=y
>> CONFIG_AMD_NB=y
>> # CONFIG_PCCARD is not set
>> CONFIG_HOTPLUG_PCI=y
>> CONFIG_HOTPLUG_PCI_ACPI=y
>> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
>> CONFIG_HOTPLUG_PCI_CPCI=y
>> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
>> CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
>> CONFIG_HOTPLUG_PCI_SHPC=m
>> # CONFIG_RAPIDIO is not set
>>
>> #
>> # Executable file formats / Emulations
>> #
>> CONFIG_BINFMT_ELF=y
>> CONFIG_COMPAT_BINFMT_ELF=y
>> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
>> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
>> # CONFIG_HAVE_AOUT is not set
>> CONFIG_BINFMT_MISC=m
>> CONFIG_COREDUMP=y
>> CONFIG_IA32_EMULATION=y
>> # CONFIG_IA32_AOUT is not set
>> # CONFIG_X86_X32 is not set
>> CONFIG_COMPAT=y
>> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
>> CONFIG_SYSVIPC_COMPAT=y
>> CONFIG_KEYS_COMPAT=y
>> CONFIG_HAVE_TEXT_POKE_SMP=y
>> CONFIG_X86_DEV_DMA_OPS=y
>> CONFIG_NET=y
>> CONFIG_COMPAT_NETLINK_MESSAGES=y
>>
>> #
>> # Networking options
>> #
>> CONFIG_PACKET=y
>> CONFIG_PACKET_DIAG=y
>> CONFIG_UNIX=y
>> # CONFIG_UNIX_DIAG is not set
>> CONFIG_XFRM=y
>> CONFIG_XFRM_ALGO=m
>> CONFIG_XFRM_USER=m
>> CONFIG_XFRM_SUB_POLICY=y
>> CONFIG_XFRM_MIGRATE=y
>> # CONFIG_XFRM_STATISTICS is not set
>> CONFIG_XFRM_IPCOMP=m
>> CONFIG_NET_KEY=m
>> CONFIG_NET_KEY_MIGRATE=y
>> CONFIG_INET=y
>> CONFIG_IP_MULTICAST=y
>> CONFIG_IP_ADVANCED_ROUTER=y
>> CONFIG_IP_FIB_TRIE_STATS=y
>> CONFIG_IP_MULTIPLE_TABLES=y
>> CONFIG_IP_ROUTE_MULTIPATH=y
>> CONFIG_IP_ROUTE_VERBOSE=y
>> CONFIG_IP_ROUTE_CLASSID=y
>> # CONFIG_IP_PNP is not set
>> CONFIG_NET_IPIP=m
>> CONFIG_NET_IPGRE_DEMUX=m
>> CONFIG_NET_IPGRE=m
>> CONFIG_NET_IPGRE_BROADCAST=y
>> CONFIG_IP_MROUTE=y
>> CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
>> CONFIG_IP_PIMSM_V1=y
>> CONFIG_IP_PIMSM_V2=y
>> # CONFIG_ARPD is not set
>> CONFIG_SYN_COOKIES=y
>> # CONFIG_NET_IPVTI is not set
>> CONFIG_INET_AH=m
>> CONFIG_INET_ESP=m
>> CONFIG_INET_IPCOMP=m
>> CONFIG_INET_XFRM_TUNNEL=m
>> CONFIG_INET_TUNNEL=m
>> CONFIG_INET_XFRM_MODE_TRANSPORT=m
>> CONFIG_INET_XFRM_MODE_TUNNEL=m
>> CONFIG_INET_XFRM_MODE_BEET=m
>> CONFIG_INET_LRO=m
>> CONFIG_INET_DIAG=m
>> CONFIG_INET_TCP_DIAG=m
>> # CONFIG_INET_UDP_DIAG is not set
>> CONFIG_TCP_CONG_ADVANCED=y
>> CONFIG_TCP_CONG_BIC=m
>> CONFIG_TCP_CONG_CUBIC=y
>> CONFIG_TCP_CONG_WESTWOOD=m
>> CONFIG_TCP_CONG_HTCP=m
>> CONFIG_TCP_CONG_HSTCP=m
>> CONFIG_TCP_CONG_HYBLA=m
>> CONFIG_TCP_CONG_VEGAS=m
>> CONFIG_TCP_CONG_SCALABLE=m
>> CONFIG_TCP_CONG_LP=m
>> CONFIG_TCP_CONG_VENO=m
>> CONFIG_TCP_CONG_YEAH=m
>> CONFIG_TCP_CONG_ILLINOIS=m
>> CONFIG_DEFAULT_CUBIC=y
>> # CONFIG_DEFAULT_RENO is not set
>> CONFIG_DEFAULT_TCP_CONG="cubic"
>> CONFIG_TCP_MD5SIG=y
>> CONFIG_IPV6=y
>> CONFIG_IPV6_PRIVACY=y
>> CONFIG_IPV6_ROUTER_PREF=y
>> CONFIG_IPV6_ROUTE_INFO=y
>> CONFIG_IPV6_OPTIMISTIC_DAD=y
>> CONFIG_INET6_AH=m
>> CONFIG_INET6_ESP=m
>> CONFIG_INET6_IPCOMP=m
>> CONFIG_IPV6_MIP6=y
>> CONFIG_INET6_XFRM_TUNNEL=m
>> CONFIG_INET6_TUNNEL=m
>> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
>> CONFIG_INET6_XFRM_MODE_TUNNEL=m
>> CONFIG_INET6_XFRM_MODE_BEET=m
>> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
>> CONFIG_IPV6_SIT=m
>> CONFIG_IPV6_SIT_6RD=y
>> CONFIG_IPV6_NDISC_NODETYPE=y
>> CONFIG_IPV6_TUNNEL=m
>> CONFIG_IPV6_GRE=m
>> CONFIG_IPV6_MULTIPLE_TABLES=y
>> CONFIG_IPV6_SUBTREES=y
>> CONFIG_IPV6_MROUTE=y
>> CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
>> CONFIG_IPV6_PIMSM_V2=y
>> # CONFIG_NETLABEL is not set
>> CONFIG_NETWORK_SECMARK=y
>> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
>> CONFIG_NETFILTER=y
>> # CONFIG_NETFILTER_DEBUG is not set
>> CONFIG_NETFILTER_ADVANCED=y
>> CONFIG_BRIDGE_NETFILTER=y
>>
>> #
>> # Core Netfilter Configuration
>> #
>> CONFIG_NETFILTER_NETLINK=m
>> # CONFIG_NETFILTER_NETLINK_ACCT is not set
>> CONFIG_NETFILTER_NETLINK_QUEUE=m
>> CONFIG_NETFILTER_NETLINK_LOG=m
>> CONFIG_NF_CONNTRACK=m
>> CONFIG_NF_CONNTRACK_MARK=y
>> CONFIG_NF_CONNTRACK_SECMARK=y
>> CONFIG_NF_CONNTRACK_ZONES=y
>> CONFIG_NF_CONNTRACK_PROCFS=y
>> CONFIG_NF_CONNTRACK_EVENTS=y
>> # CONFIG_NF_CONNTRACK_TIMEOUT is not set
>> CONFIG_NF_CONNTRACK_TIMESTAMP=y
>> CONFIG_NF_CT_PROTO_DCCP=m
>> CONFIG_NF_CT_PROTO_GRE=m
>> CONFIG_NF_CT_PROTO_SCTP=m
>> CONFIG_NF_CT_PROTO_UDPLITE=m
>> CONFIG_NF_CONNTRACK_AMANDA=m
>> CONFIG_NF_CONNTRACK_FTP=m
>> CONFIG_NF_CONNTRACK_H323=m
>> CONFIG_NF_CONNTRACK_IRC=m
>> CONFIG_NF_CONNTRACK_BROADCAST=m
>> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
>> CONFIG_NF_CONNTRACK_SNMP=m
>> CONFIG_NF_CONNTRACK_PPTP=m
>> CONFIG_NF_CONNTRACK_SANE=m
>> CONFIG_NF_CONNTRACK_SIP=m
>> CONFIG_NF_CONNTRACK_TFTP=m
>> CONFIG_NF_CT_NETLINK=m
>> # CONFIG_NF_CT_NETLINK_TIMEOUT is not set
>> # CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
>> CONFIG_NETFILTER_TPROXY=m
>> CONFIG_NETFILTER_XTABLES=m
>>
>> #
>> # Xtables combined modules
>> #
>> CONFIG_NETFILTER_XT_MARK=m
>> CONFIG_NETFILTER_XT_CONNMARK=m
>> CONFIG_NETFILTER_XT_SET=m
>>
>> #
>> # Xtables targets
>> #
>> CONFIG_NETFILTER_XT_TARGET_AUDIT=m
>> CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
>> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
>> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
>> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
>> CONFIG_NETFILTER_XT_TARGET_CT=m
>> CONFIG_NETFILTER_XT_TARGET_DSCP=m
>> CONFIG_NETFILTER_XT_TARGET_HL=m
>> # CONFIG_NETFILTER_XT_TARGET_HMARK is not set
>> CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
>> CONFIG_NETFILTER_XT_TARGET_LED=m
>> # CONFIG_NETFILTER_XT_TARGET_LOG is not set
>> CONFIG_NETFILTER_XT_TARGET_MARK=m
>> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
>> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
>> CONFIG_NETFILTER_XT_TARGET_RATEEST=m
>> CONFIG_NETFILTER_XT_TARGET_TEE=m
>> CONFIG_NETFILTER_XT_TARGET_TPROXY=m
>> CONFIG_NETFILTER_XT_TARGET_TRACE=m
>> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
>> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
>> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
>>
>> #
>> # Xtables matches
>> #
>> CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
>> CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
>> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
>> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
>> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
>> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
>> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
>> CONFIG_NETFILTER_XT_MATCH_CPU=m
>> CONFIG_NETFILTER_XT_MATCH_DCCP=m
>> CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
>> CONFIG_NETFILTER_XT_MATCH_DSCP=m
>> CONFIG_NETFILTER_XT_MATCH_ECN=m
>> CONFIG_NETFILTER_XT_MATCH_ESP=m
>> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
>> CONFIG_NETFILTER_XT_MATCH_HELPER=m
>> CONFIG_NETFILTER_XT_MATCH_HL=m
>> CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
>> CONFIG_NETFILTER_XT_MATCH_IPVS=m
>> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
>> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
>> CONFIG_NETFILTER_XT_MATCH_MAC=m
>> CONFIG_NETFILTER_XT_MATCH_MARK=m
>> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
>> # CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
>> CONFIG_NETFILTER_XT_MATCH_OSF=m
>> CONFIG_NETFILTER_XT_MATCH_OWNER=m
>> CONFIG_NETFILTER_XT_MATCH_POLICY=m
>> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
>> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
>> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
>> CONFIG_NETFILTER_XT_MATCH_RATEEST=m
>> CONFIG_NETFILTER_XT_MATCH_REALM=m
>> CONFIG_NETFILTER_XT_MATCH_RECENT=m
>> CONFIG_NETFILTER_XT_MATCH_SCTP=m
>> CONFIG_NETFILTER_XT_MATCH_SOCKET=m
>> CONFIG_NETFILTER_XT_MATCH_STATE=m
>> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
>> CONFIG_NETFILTER_XT_MATCH_STRING=m
>> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
>> CONFIG_NETFILTER_XT_MATCH_TIME=m
>> CONFIG_NETFILTER_XT_MATCH_U32=m
>> CONFIG_IP_SET=m
>> CONFIG_IP_SET_MAX=256
>> CONFIG_IP_SET_BITMAP_IP=m
>> CONFIG_IP_SET_BITMAP_IPMAC=m
>> CONFIG_IP_SET_BITMAP_PORT=m
>> CONFIG_IP_SET_HASH_IP=m
>> CONFIG_IP_SET_HASH_IPPORT=m
>> CONFIG_IP_SET_HASH_IPPORTIP=m
>> CONFIG_IP_SET_HASH_IPPORTNET=m
>> CONFIG_IP_SET_HASH_NET=m
>> CONFIG_IP_SET_HASH_NETPORT=m
>> CONFIG_IP_SET_HASH_NETIFACE=m
>> CONFIG_IP_SET_LIST_SET=m
>> CONFIG_IP_VS=m
>> CONFIG_IP_VS_IPV6=y
>> # CONFIG_IP_VS_DEBUG is not set
>> CONFIG_IP_VS_TAB_BITS=12
>>
>> #
>> # IPVS transport protocol load balancing support
>> #
>> CONFIG_IP_VS_PROTO_TCP=y
>> CONFIG_IP_VS_PROTO_UDP=y
>> CONFIG_IP_VS_PROTO_AH_ESP=y
>> CONFIG_IP_VS_PROTO_ESP=y
>> CONFIG_IP_VS_PROTO_AH=y
>> CONFIG_IP_VS_PROTO_SCTP=y
>>
>> #
>> # IPVS scheduler
>> #
>> CONFIG_IP_VS_RR=m
>> CONFIG_IP_VS_WRR=m
>> CONFIG_IP_VS_LC=m
>> CONFIG_IP_VS_WLC=m
>> CONFIG_IP_VS_LBLC=m
>> CONFIG_IP_VS_LBLCR=m
>> CONFIG_IP_VS_DH=m
>> CONFIG_IP_VS_SH=m
>> CONFIG_IP_VS_SED=m
>> CONFIG_IP_VS_NQ=m
>>
>> #
>> # IPVS SH scheduler
>> #
>> CONFIG_IP_VS_SH_TAB_BITS=8
>>
>> #
>> # IPVS application helper
>> #
>> CONFIG_IP_VS_NFCT=y
>> CONFIG_IP_VS_PE_SIP=m
>>
>> #
>> # IP: Netfilter Configuration
>> #
>> CONFIG_NF_DEFRAG_IPV4=m
>> CONFIG_NF_CONNTRACK_IPV4=m
>> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
>> CONFIG_IP_NF_QUEUE=m
>> CONFIG_IP_NF_IPTABLES=m
>> CONFIG_IP_NF_MATCH_AH=m
>> CONFIG_IP_NF_MATCH_ECN=m
>> # CONFIG_IP_NF_MATCH_RPFILTER is not set
>> CONFIG_IP_NF_MATCH_TTL=m
>> CONFIG_IP_NF_FILTER=m
>> CONFIG_IP_NF_TARGET_REJECT=m
>> CONFIG_IP_NF_TARGET_ULOG=m
>> # CONFIG_NF_NAT_IPV4 is not set
>> CONFIG_IP_NF_MANGLE=m
>> CONFIG_IP_NF_TARGET_CLUSTERIP=m
>> CONFIG_IP_NF_TARGET_ECN=m
>> CONFIG_IP_NF_TARGET_TTL=m
>> CONFIG_IP_NF_RAW=m
>> CONFIG_IP_NF_SECURITY=m
>> CONFIG_IP_NF_ARPTABLES=m
>> CONFIG_IP_NF_ARPFILTER=m
>> CONFIG_IP_NF_ARP_MANGLE=m
>>
>> #
>> # IPv6: Netfilter Configuration
>> #
>> CONFIG_NF_DEFRAG_IPV6=m
>> CONFIG_NF_CONNTRACK_IPV6=m
>> CONFIG_IP6_NF_IPTABLES=m
>> CONFIG_IP6_NF_MATCH_AH=m
>> CONFIG_IP6_NF_MATCH_EUI64=m
>> CONFIG_IP6_NF_MATCH_FRAG=m
>> CONFIG_IP6_NF_MATCH_OPTS=m
>> CONFIG_IP6_NF_MATCH_HL=m
>> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
>> CONFIG_IP6_NF_MATCH_MH=m
>> # CONFIG_IP6_NF_MATCH_RPFILTER is not set
>> CONFIG_IP6_NF_MATCH_RT=m
>> CONFIG_IP6_NF_TARGET_HL=m
>> CONFIG_IP6_NF_FILTER=m
>> CONFIG_IP6_NF_TARGET_REJECT=m
>> CONFIG_IP6_NF_MANGLE=m
>> CONFIG_IP6_NF_RAW=m
>> CONFIG_IP6_NF_SECURITY=m
>> # CONFIG_NF_NAT_IPV6 is not set
>>
>> #
>> # DECnet: Netfilter Configuration
>> #
>> CONFIG_DECNET_NF_GRABULATOR=m
>> CONFIG_BRIDGE_NF_EBTABLES=m
>> CONFIG_BRIDGE_EBT_BROUTE=m
>> CONFIG_BRIDGE_EBT_T_FILTER=m
>> CONFIG_BRIDGE_EBT_T_NAT=m
>> CONFIG_BRIDGE_EBT_802_3=m
>> CONFIG_BRIDGE_EBT_AMONG=m
>> CONFIG_BRIDGE_EBT_ARP=m
>> CONFIG_BRIDGE_EBT_IP=m
>> CONFIG_BRIDGE_EBT_IP6=m
>> CONFIG_BRIDGE_EBT_LIMIT=m
>> CONFIG_BRIDGE_EBT_MARK=m
>> CONFIG_BRIDGE_EBT_PKTTYPE=m
>> CONFIG_BRIDGE_EBT_STP=m
>> CONFIG_BRIDGE_EBT_VLAN=m
>> CONFIG_BRIDGE_EBT_ARPREPLY=m
>> CONFIG_BRIDGE_EBT_DNAT=m
>> CONFIG_BRIDGE_EBT_MARK_T=m
>> CONFIG_BRIDGE_EBT_REDIRECT=m
>> CONFIG_BRIDGE_EBT_SNAT=m
>> CONFIG_BRIDGE_EBT_LOG=m
>> CONFIG_BRIDGE_EBT_ULOG=m
>> CONFIG_BRIDGE_EBT_NFLOG=m
>> CONFIG_IP_DCCP=m
>> CONFIG_INET_DCCP_DIAG=m
>>
>> #
>> # DCCP CCIDs Configuration (EXPERIMENTAL)
>> #
>> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
>> CONFIG_IP_DCCP_CCID3=y
>> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
>> CONFIG_IP_DCCP_TFRC_LIB=y
>>
>> #
>> # DCCP Kernel Hacking
>> #
>> # CONFIG_IP_DCCP_DEBUG is not set
>> CONFIG_NET_DCCPPROBE=m
>> CONFIG_IP_SCTP=m
>> CONFIG_NET_SCTPPROBE=m
>> # CONFIG_SCTP_DBG_MSG is not set
>> # CONFIG_SCTP_DBG_OBJCNT is not set
>> # CONFIG_SCTP_HMAC_NONE is not set
>> # CONFIG_SCTP_HMAC_SHA1 is not set
>> CONFIG_SCTP_HMAC_MD5=y
>> CONFIG_RDS=m
>> CONFIG_RDS_RDMA=m
>> CONFIG_RDS_TCP=m
>> # CONFIG_RDS_DEBUG is not set
>> CONFIG_TIPC=m
>> CONFIG_TIPC_ADVANCED=y
>> CONFIG_TIPC_PORTS=8191
>> CONFIG_ATM=m
>> CONFIG_ATM_CLIP=m
>> # CONFIG_ATM_CLIP_NO_ICMP is not set
>> CONFIG_ATM_LANE=m
>> CONFIG_ATM_MPOA=m
>> CONFIG_ATM_BR2684=m
>> # CONFIG_ATM_BR2684_IPFILTER is not set
>> CONFIG_L2TP=m
>> CONFIG_L2TP_DEBUGFS=m
>> CONFIG_L2TP_V3=y
>> CONFIG_L2TP_IP=m
>> CONFIG_L2TP_ETH=m
>> CONFIG_STP=m
>> CONFIG_GARP=m
>> CONFIG_BRIDGE=m
>> CONFIG_BRIDGE_IGMP_SNOOPING=y
>> # CONFIG_NET_DSA is not set
>> CONFIG_VLAN_8021Q=m
>> CONFIG_VLAN_8021Q_GVRP=y
>> CONFIG_DECNET=m
>> # CONFIG_DECNET_ROUTER is not set
>> CONFIG_LLC=m
>> CONFIG_LLC2=m
>> CONFIG_IPX=m
>> # CONFIG_IPX_INTERN is not set
>> CONFIG_ATALK=m
>> CONFIG_DEV_APPLETALK=m
>> CONFIG_IPDDP=m
>> CONFIG_IPDDP_ENCAP=y
>> CONFIG_IPDDP_DECAP=y
>> # CONFIG_X25 is not set
>> CONFIG_LAPB=m
>> CONFIG_WAN_ROUTER=m
>> CONFIG_PHONET=m
>> CONFIG_IEEE802154=m
>> CONFIG_IEEE802154_6LOWPAN=m
>> # CONFIG_MAC802154 is not set
>> CONFIG_NET_SCHED=y
>>
>> #
>> # Queueing/Scheduling
>> #
>> CONFIG_NET_SCH_CBQ=m
>> CONFIG_NET_SCH_HTB=m
>> CONFIG_NET_SCH_HFSC=m
>> CONFIG_NET_SCH_ATM=m
>> CONFIG_NET_SCH_PRIO=m
>> CONFIG_NET_SCH_MULTIQ=m
>> CONFIG_NET_SCH_RED=m
>> CONFIG_NET_SCH_SFB=m
>> CONFIG_NET_SCH_SFQ=m
>> CONFIG_NET_SCH_TEQL=m
>> CONFIG_NET_SCH_TBF=m
>> CONFIG_NET_SCH_GRED=m
>> CONFIG_NET_SCH_DSMARK=m
>> CONFIG_NET_SCH_NETEM=m
>> CONFIG_NET_SCH_DRR=m
>> CONFIG_NET_SCH_MQPRIO=m
>> CONFIG_NET_SCH_CHOKE=m
>> CONFIG_NET_SCH_QFQ=m
>> CONFIG_NET_SCH_CODEL=m
>> CONFIG_NET_SCH_FQ_CODEL=m
>> CONFIG_NET_SCH_INGRESS=m
>> # CONFIG_NET_SCH_PLUG is not set
>>
>> #
>> # Classification
>> #
>> CONFIG_NET_CLS=y
>> CONFIG_NET_CLS_BASIC=m
>> CONFIG_NET_CLS_TCINDEX=m
>> CONFIG_NET_CLS_ROUTE4=m
>> CONFIG_NET_CLS_FW=m
>> CONFIG_NET_CLS_U32=m
>> CONFIG_CLS_U32_PERF=y
>> CONFIG_CLS_U32_MARK=y
>> CONFIG_NET_CLS_RSVP=m
>> CONFIG_NET_CLS_RSVP6=m
>> CONFIG_NET_CLS_FLOW=m
>> CONFIG_NET_CLS_CGROUP=y
>> CONFIG_NET_EMATCH=y
>> CONFIG_NET_EMATCH_STACK=32
>> CONFIG_NET_EMATCH_CMP=m
>> CONFIG_NET_EMATCH_NBYTE=m
>> CONFIG_NET_EMATCH_U32=m
>> CONFIG_NET_EMATCH_META=m
>> CONFIG_NET_EMATCH_TEXT=m
>> # CONFIG_NET_EMATCH_CANID is not set
>> # CONFIG_NET_EMATCH_IPSET is not set
>> CONFIG_NET_CLS_ACT=y
>> CONFIG_NET_ACT_POLICE=m
>> CONFIG_NET_ACT_GACT=m
>> CONFIG_GACT_PROB=y
>> CONFIG_NET_ACT_MIRRED=m
>> CONFIG_NET_ACT_IPT=m
>> CONFIG_NET_ACT_NAT=m
>> CONFIG_NET_ACT_PEDIT=m
>> CONFIG_NET_ACT_SIMP=m
>> CONFIG_NET_ACT_SKBEDIT=m
>> CONFIG_NET_ACT_CSUM=m
>> CONFIG_NET_CLS_IND=y
>> CONFIG_NET_SCH_FIFO=y
>> CONFIG_DCB=y
>> CONFIG_DNS_RESOLVER=y
>> CONFIG_BATMAN_ADV=m
>> CONFIG_BATMAN_ADV_BLA=y
>> # CONFIG_BATMAN_ADV_DEBUG is not set
>> # CONFIG_OPENVSWITCH is not set
>> CONFIG_RPS=y
>> CONFIG_RFS_ACCEL=y
>> CONFIG_XPS=y
>> # CONFIG_NETPRIO_CGROUP is not set
>> CONFIG_BQL=y
>> CONFIG_BPF_JIT=y
>>
>> #
>> # Network testing
>> #
>> CONFIG_NET_PKTGEN=m
>> # CONFIG_NET_TCPPROBE is not set
>> CONFIG_NET_DROP_MONITOR=y
>> CONFIG_HAMRADIO=y
>>
>> #
>> # Packet Radio protocols
>> #
>> CONFIG_AX25=m
>> # CONFIG_AX25_DAMA_SLAVE is not set
>> CONFIG_NETROM=m
>> CONFIG_ROSE=m
>>
>> #
>> # AX.25 network device drivers
>> #
>> CONFIG_MKISS=m
>> CONFIG_6PACK=m
>> CONFIG_BPQETHER=m
>> CONFIG_BAYCOM_SER_FDX=m
>> CONFIG_BAYCOM_SER_HDX=m
>> CONFIG_YAM=m
>> CONFIG_CAN=m
>> CONFIG_CAN_RAW=m
>> CONFIG_CAN_BCM=m
>> CONFIG_CAN_GW=m
>>
>> #
>> # CAN Device Drivers
>> #
>> CONFIG_CAN_VCAN=m
>> CONFIG_CAN_SLCAN=m
>> CONFIG_CAN_DEV=m
>> CONFIG_CAN_CALC_BITTIMING=y
>> CONFIG_CAN_MCP251X=m
>> CONFIG_PCH_CAN=m
>> CONFIG_CAN_SJA1000=m
>> # CONFIG_CAN_SJA1000_ISA is not set
>> # CONFIG_CAN_SJA1000_PLATFORM is not set
>> CONFIG_CAN_EMS_PCI=m
>> CONFIG_CAN_PEAK_PCI=m
>> CONFIG_CAN_PEAK_PCIEC=y
>> CONFIG_CAN_KVASER_PCI=m
>> CONFIG_CAN_PLX_PCI=m
>> # CONFIG_CAN_C_CAN is not set
>> # CONFIG_CAN_CC770 is not set
>>
>> #
>> # CAN USB interfaces
>> #
>> CONFIG_CAN_EMS_USB=m
>> CONFIG_CAN_ESD_USB2=m
>> # CONFIG_CAN_PEAK_USB is not set
>> CONFIG_CAN_SOFTING=m
>> # CONFIG_CAN_DEBUG_DEVICES is not set
>> CONFIG_IRDA=m
>>
>> #
>> # IrDA protocols
>> #
>> CONFIG_IRLAN=m
>> CONFIG_IRNET=m
>> CONFIG_IRCOMM=m
>> # CONFIG_IRDA_ULTRA is not set
>>
>> #
>> # IrDA options
>> #
>> CONFIG_IRDA_CACHE_LAST_LSAP=y
>> CONFIG_IRDA_FAST_RR=y
>> # CONFIG_IRDA_DEBUG is not set
>>
>> #
>> # Infrared-port device drivers
>> #
>>
>> #
>> # SIR device drivers
>> #
>> CONFIG_IRTTY_SIR=m
>>
>> #
>> # Dongle support
>> #
>> CONFIG_DONGLE=y
>> CONFIG_ESI_DONGLE=m
>> CONFIG_ACTISYS_DONGLE=m
>> CONFIG_TEKRAM_DONGLE=m
>> CONFIG_TOIM3232_DONGLE=m
>> CONFIG_LITELINK_DONGLE=m
>> CONFIG_MA600_DONGLE=m
>> CONFIG_GIRBIL_DONGLE=m
>> CONFIG_MCP2120_DONGLE=m
>> CONFIG_OLD_BELKIN_DONGLE=m
>> CONFIG_ACT200L_DONGLE=m
>> CONFIG_KINGSUN_DONGLE=m
>> CONFIG_KSDAZZLE_DONGLE=m
>> CONFIG_KS959_DONGLE=m
>>
>> #
>> # FIR device drivers
>> #
>> CONFIG_USB_IRDA=m
>> CONFIG_SIGMATEL_FIR=m
>> CONFIG_NSC_FIR=m
>> CONFIG_WINBOND_FIR=m
>> CONFIG_SMC_IRCC_FIR=m
>> CONFIG_ALI_FIR=m
>> CONFIG_VLSI_FIR=m
>> CONFIG_VIA_FIR=m
>> CONFIG_MCS_FIR=m
>> CONFIG_BT=m
>> CONFIG_BT_RFCOMM=m
>> CONFIG_BT_RFCOMM_TTY=y
>> CONFIG_BT_BNEP=m
>> CONFIG_BT_BNEP_MC_FILTER=y
>> CONFIG_BT_BNEP_PROTO_FILTER=y
>> CONFIG_BT_CMTP=m
>> CONFIG_BT_HIDP=m
>>
>> #
>> # Bluetooth device drivers
>> #
>> CONFIG_BT_HCIBTUSB=m
>> CONFIG_BT_HCIBTSDIO=m
>> CONFIG_BT_HCIUART=m
>> CONFIG_BT_HCIUART_H4=y
>> CONFIG_BT_HCIUART_BCSP=y
>> CONFIG_BT_HCIUART_ATH3K=y
>> CONFIG_BT_HCIUART_LL=y
>> CONFIG_BT_HCIUART_3WIRE=y
>> CONFIG_BT_HCIBCM203X=m
>> CONFIG_BT_HCIBPA10X=m
>> CONFIG_BT_HCIBFUSB=m
>> CONFIG_BT_HCIVHCI=m
>> CONFIG_BT_MRVL=m
>> CONFIG_BT_MRVL_SDIO=m
>> CONFIG_BT_ATH3K=m
>> CONFIG_AF_RXRPC=m
>> # CONFIG_AF_RXRPC_DEBUG is not set
>> CONFIG_RXKAD=m
>> CONFIG_FIB_RULES=y
>> CONFIG_WIRELESS=y
>> CONFIG_WIRELESS_EXT=y
>> CONFIG_WEXT_CORE=y
>> CONFIG_WEXT_PROC=y
>> CONFIG_WEXT_SPY=y
>> CONFIG_WEXT_PRIV=y
>> CONFIG_CFG80211=m
>> # CONFIG_NL80211_TESTMODE is not set
>> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
>> # CONFIG_CFG80211_REG_DEBUG is not set
>> CONFIG_CFG80211_DEFAULT_PS=y
>> # CONFIG_CFG80211_DEBUGFS is not set
>> # CONFIG_CFG80211_INTERNAL_REGDB is not set
>> CONFIG_CFG80211_WEXT=y
>> CONFIG_LIB80211=m
>> CONFIG_LIB80211_CRYPT_WEP=m
>> CONFIG_LIB80211_CRYPT_CCMP=m
>> CONFIG_LIB80211_CRYPT_TKIP=m
>> # CONFIG_LIB80211_DEBUG is not set
>> CONFIG_MAC80211=m
>> CONFIG_MAC80211_HAS_RC=y
>> CONFIG_MAC80211_RC_MINSTREL=y
>> CONFIG_MAC80211_RC_MINSTREL_HT=y
>> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
>> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
>> CONFIG_MAC80211_MESH=y
>> CONFIG_MAC80211_LEDS=y
>> # CONFIG_MAC80211_DEBUGFS is not set
>> # CONFIG_MAC80211_MESSAGE_TRACING is not set
>> # CONFIG_MAC80211_DEBUG_MENU is not set
>> CONFIG_WIMAX=m
>> CONFIG_WIMAX_DEBUG_LEVEL=8
>> CONFIG_RFKILL=m
>> CONFIG_RFKILL_LEDS=y
>> CONFIG_RFKILL_INPUT=y
>> # CONFIG_RFKILL_REGULATOR is not set
>> # CONFIG_NET_9P is not set
>> # CONFIG_CAIF is not set
>> CONFIG_CEPH_LIB=m
>> # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
>> # CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
>> # CONFIG_NFC is not set
>> CONFIG_HAVE_BPF_JIT=y
>>
>> #
>> # Device Drivers
>> #
>>
>> #
>> # Generic Driver Options
>> #
>> CONFIG_UEVENT_HELPER_PATH=""
>> CONFIG_DEVTMPFS=y
>> # CONFIG_DEVTMPFS_MOUNT is not set
>> CONFIG_STANDALONE=y
>> CONFIG_PREVENT_FIRMWARE_BUILD=y
>> CONFIG_FW_LOADER=y
>> # CONFIG_FIRMWARE_IN_KERNEL is not set
>> CONFIG_EXTRA_FIRMWARE=""
>> # CONFIG_DEBUG_DRIVER is not set
>> # CONFIG_DEBUG_DEVRES is not set
>> # CONFIG_SYS_HYPERVISOR is not set
>> # CONFIG_GENERIC_CPU_DEVICES is not set
>> CONFIG_REGMAP=y
>> CONFIG_REGMAP_I2C=m
>> CONFIG_REGMAP_SPI=m
>> CONFIG_DMA_SHARED_BUFFER=y
>>
>> #
>> # Bus devices
>> #
>> # CONFIG_OMAP_OCP2SCP is not set
>> CONFIG_CONNECTOR=m
>> CONFIG_MTD=m
>> # CONFIG_MTD_TESTS is not set
>> CONFIG_MTD_REDBOOT_PARTS=m
>> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
>> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
>> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
>> CONFIG_MTD_AR7_PARTS=m
>>
>> #
>> # User Modules And Translation Layers
>> #
>> CONFIG_MTD_CHAR=m
>> CONFIG_MTD_BLKDEVS=m
>> CONFIG_MTD_BLOCK=m
>> CONFIG_MTD_BLOCK_RO=m
>> CONFIG_FTL=m
>> CONFIG_NFTL=m
>> CONFIG_NFTL_RW=y
>> CONFIG_INFTL=m
>> CONFIG_RFD_FTL=m
>> CONFIG_SSFDC=m
>> # CONFIG_SM_FTL is not set
>> CONFIG_MTD_OOPS=m
>> CONFIG_MTD_SWAP=m
>>
>> #
>> # RAM/ROM/Flash chip drivers
>> #
>> CONFIG_MTD_CFI=m
>> CONFIG_MTD_JEDECPROBE=m
>> CONFIG_MTD_GEN_PROBE=m
>> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
>> CONFIG_MTD_MAP_BANK_WIDTH_1=y
>> CONFIG_MTD_MAP_BANK_WIDTH_2=y
>> CONFIG_MTD_MAP_BANK_WIDTH_4=y
>> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
>> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
>> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
>> CONFIG_MTD_CFI_I1=y
>> CONFIG_MTD_CFI_I2=y
>> # CONFIG_MTD_CFI_I4 is not set
>> # CONFIG_MTD_CFI_I8 is not set
>> CONFIG_MTD_CFI_INTELEXT=m
>> CONFIG_MTD_CFI_AMDSTD=m
>> CONFIG_MTD_CFI_STAA=m
>> CONFIG_MTD_CFI_UTIL=m
>> CONFIG_MTD_RAM=m
>> CONFIG_MTD_ROM=m
>> CONFIG_MTD_ABSENT=m
>>
>> #
>> # Mapping drivers for chip access
>> #
>> CONFIG_MTD_COMPLEX_MAPPINGS=y
>> CONFIG_MTD_PHYSMAP=m
>> # CONFIG_MTD_PHYSMAP_COMPAT is not set
>> CONFIG_MTD_SC520CDP=m
>> CONFIG_MTD_NETSC520=m
>> CONFIG_MTD_TS5500=m
>> CONFIG_MTD_SBC_GXX=m
>> # CONFIG_MTD_AMD76XROM is not set
>> # CONFIG_MTD_ICHXROM is not set
>> # CONFIG_MTD_ESB2ROM is not set
>> # CONFIG_MTD_CK804XROM is not set
>> # CONFIG_MTD_SCB2_FLASH is not set
>> CONFIG_MTD_NETtel=m
>> # CONFIG_MTD_L440GX is not set
>> CONFIG_MTD_PCI=m
>> # CONFIG_MTD_GPIO_ADDR is not set
>> CONFIG_MTD_INTEL_VR_NOR=m
>> CONFIG_MTD_PLATRAM=m
>> # CONFIG_MTD_LATCH_ADDR is not set
>>
>> #
>> # Self-contained MTD device drivers
>> #
>> CONFIG_MTD_PMC551=m
>> # CONFIG_MTD_PMC551_BUGFIX is not set
>> # CONFIG_MTD_PMC551_DEBUG is not set
>> CONFIG_MTD_DATAFLASH=m
>> # CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
>> # CONFIG_MTD_DATAFLASH_OTP is not set
>> CONFIG_MTD_M25P80=m
>> CONFIG_M25PXX_USE_FAST_READ=y
>> CONFIG_MTD_SST25L=m
>> CONFIG_MTD_SLRAM=m
>> CONFIG_MTD_PHRAM=m
>> CONFIG_MTD_MTDRAM=m
>> CONFIG_MTDRAM_TOTAL_SIZE=4096
>> CONFIG_MTDRAM_ERASE_SIZE=128
>> CONFIG_MTD_BLOCK2MTD=m
>>
>> #
>> # Disk-On-Chip Device Drivers
>> #
>> CONFIG_MTD_DOC2000=m
>> CONFIG_MTD_DOC2001=m
>> CONFIG_MTD_DOC2001PLUS=m
>> # CONFIG_MTD_DOCG3 is not set
>> CONFIG_MTD_DOCPROBE=m
>> CONFIG_MTD_DOCECC=m
>> # CONFIG_MTD_DOCPROBE_ADVANCED is not set
>> CONFIG_MTD_DOCPROBE_ADDRESS=0x0
>> CONFIG_MTD_NAND_ECC=m
>> # CONFIG_MTD_NAND_ECC_SMC is not set
>> CONFIG_MTD_NAND=m
>> # CONFIG_MTD_NAND_ECC_BCH is not set
>> CONFIG_MTD_SM_COMMON=m
>> # CONFIG_MTD_NAND_MUSEUM_IDS is not set
>> # CONFIG_MTD_NAND_DENALI is not set
>> CONFIG_MTD_NAND_IDS=m
>> CONFIG_MTD_NAND_RICOH=m
>> CONFIG_MTD_NAND_DISKONCHIP=m
>> # CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
>> CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
>> # CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
>> # CONFIG_MTD_NAND_DOCG4 is not set
>> CONFIG_MTD_NAND_CAFE=m
>> CONFIG_MTD_NAND_NANDSIM=m
>> CONFIG_MTD_NAND_PLATFORM=m
>> CONFIG_MTD_ALAUDA=m
>> CONFIG_MTD_ONENAND=m
>> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
>> CONFIG_MTD_ONENAND_GENERIC=m
>> # CONFIG_MTD_ONENAND_OTP is not set
>> CONFIG_MTD_ONENAND_2X_PROGRAM=y
>> CONFIG_MTD_ONENAND_SIM=m
>>
>> #
>> # LPDDR flash memory drivers
>> #
>> CONFIG_MTD_LPDDR=m
>> CONFIG_MTD_QINFO_PROBE=m
>> CONFIG_MTD_UBI=m
>> CONFIG_MTD_UBI_WL_THRESHOLD=4096
>> CONFIG_MTD_UBI_BEB_LIMIT=20
>> # CONFIG_MTD_UBI_FASTMAP is not set
>> # CONFIG_MTD_UBI_GLUEBI is not set
>> # CONFIG_PARPORT is not set
>> CONFIG_PNP=y
>> # CONFIG_PNP_DEBUG_MESSAGES is not set
>>
>> #
>> # Protocols
>> #
>> CONFIG_PNPACPI=y
>> CONFIG_BLK_DEV=y
>> # CONFIG_BLK_DEV_FD is not set
>> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
>> # CONFIG_BLK_CPQ_DA is not set
>> # CONFIG_BLK_CPQ_CISS_DA is not set
>> # CONFIG_BLK_DEV_DAC960 is not set
>> # CONFIG_BLK_DEV_UMEM is not set
>> # CONFIG_BLK_DEV_COW_COMMON is not set
>> CONFIG_BLK_DEV_LOOP=m
>> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
>> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
>> CONFIG_BLK_DEV_DRBD=m
>> # CONFIG_DRBD_FAULT_INJECTION is not set
>> CONFIG_BLK_DEV_NBD=m
>> # CONFIG_BLK_DEV_NVME is not set
>> # CONFIG_BLK_DEV_OSD is not set
>> # CONFIG_BLK_DEV_SX8 is not set
>> CONFIG_BLK_DEV_RAM=m
>> CONFIG_BLK_DEV_RAM_COUNT=16
>> CONFIG_BLK_DEV_RAM_SIZE=65536
>> # CONFIG_BLK_DEV_XIP is not set
>> CONFIG_CDROM_PKTCDVD=m
>> CONFIG_CDROM_PKTCDVD_BUFFERS=8
>> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
>> # CONFIG_ATA_OVER_ETH is not set
>> CONFIG_VIRTIO_BLK=m
>> # CONFIG_BLK_DEV_HD is not set
>> # CONFIG_BLK_DEV_RBD is not set
>>
>> #
>> # Misc devices
>> #
>> CONFIG_SENSORS_LIS3LV02D=m
>> CONFIG_AD525X_DPOT=m
>> CONFIG_AD525X_DPOT_I2C=m
>> CONFIG_AD525X_DPOT_SPI=m
>> CONFIG_IBM_ASM=m
>> CONFIG_PHANTOM=m
>> # CONFIG_INTEL_MID_PTI is not set
>> CONFIG_SGI_IOC4=m
>> CONFIG_TIFM_CORE=m
>> CONFIG_TIFM_7XX1=m
>> CONFIG_ICS932S401=m
>> CONFIG_ENCLOSURE_SERVICES=m
>> CONFIG_HP_ILO=m
>> CONFIG_APDS9802ALS=m
>> CONFIG_ISL29003=m
>> CONFIG_ISL29020=m
>> CONFIG_SENSORS_TSL2550=m
>> CONFIG_SENSORS_BH1780=m
>> CONFIG_SENSORS_BH1770=m
>> CONFIG_SENSORS_APDS990X=m
>> CONFIG_HMC6352=m
>> CONFIG_DS1682=m
>> CONFIG_TI_DAC7512=m
>> CONFIG_VMWARE_BALLOON=m
>> CONFIG_BMP085=y
>> # CONFIG_BMP085_I2C is not set
>> CONFIG_BMP085_SPI=m
>> CONFIG_PCH_PHUB=m
>> # CONFIG_USB_SWITCH_FSA9480 is not set
>> CONFIG_C2PORT=m
>> CONFIG_C2PORT_DURAMAR_2150=m
>>
>> #
>> # EEPROM support
>> #
>> CONFIG_EEPROM_AT24=m
>> CONFIG_EEPROM_AT25=m
>> CONFIG_EEPROM_LEGACY=m
>> CONFIG_EEPROM_MAX6875=m
>> CONFIG_EEPROM_93CX6=m
>> # CONFIG_EEPROM_93XX46 is not set
>> CONFIG_CB710_CORE=m
>> # CONFIG_CB710_DEBUG is not set
>> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
>>
>> #
>> # Texas Instruments shared transport line discipline
>> #
>> # CONFIG_TI_ST is not set
>> CONFIG_SENSORS_LIS3_I2C=m
>>
>> #
>> # Altera FPGA firmware download module
>> #
>> CONFIG_ALTERA_STAPL=m
>> CONFIG_INTEL_MEI=m
>> CONFIG_HAVE_IDE=y
>> # CONFIG_IDE is not set
>>
>> #
>> # SCSI device support
>> #
>> CONFIG_SCSI_MOD=y
>> CONFIG_RAID_ATTRS=m
>> CONFIG_SCSI=y
>> CONFIG_SCSI_DMA=y
>> CONFIG_SCSI_TGT=m
>> CONFIG_SCSI_NETLINK=y
>> # CONFIG_SCSI_PROC_FS is not set
>>
>> #
>> # SCSI support type (disk, tape, CD-ROM)
>> #
>> CONFIG_BLK_DEV_SD=y
>> # CONFIG_CHR_DEV_ST is not set
>> # CONFIG_CHR_DEV_OSST is not set
>> CONFIG_BLK_DEV_SR=m
>> CONFIG_BLK_DEV_SR_VENDOR=y
>> CONFIG_CHR_DEV_SG=m
>> CONFIG_CHR_DEV_SCH=m
>> # CONFIG_SCSI_ENCLOSURE is not set
>> CONFIG_SCSI_MULTI_LUN=y
>> CONFIG_SCSI_CONSTANTS=y
>> CONFIG_SCSI_LOGGING=y
>> CONFIG_SCSI_SCAN_ASYNC=y
>>
>> #
>> # SCSI Transports
>> #
>> CONFIG_SCSI_SPI_ATTRS=m
>> CONFIG_SCSI_FC_ATTRS=m
>> CONFIG_SCSI_FC_TGT_ATTRS=y
>> CONFIG_SCSI_ISCSI_ATTRS=m
>> CONFIG_SCSI_SAS_ATTRS=m
>> CONFIG_SCSI_SAS_LIBSAS=m
>> CONFIG_SCSI_SAS_ATA=y
>> CONFIG_SCSI_SAS_HOST_SMP=y
>> CONFIG_SCSI_SRP_ATTRS=m
>> CONFIG_SCSI_SRP_TGT_ATTRS=y
>> CONFIG_SCSI_LOWLEVEL=y
>> CONFIG_ISCSI_TCP=m
>> CONFIG_ISCSI_BOOT_SYSFS=m
>> CONFIG_SCSI_CXGB3_ISCSI=m
>> CONFIG_SCSI_CXGB4_ISCSI=m
>> CONFIG_SCSI_BNX2_ISCSI=m
>> CONFIG_SCSI_BNX2X_FCOE=m
>> CONFIG_BE2ISCSI=m
>> CONFIG_BLK_DEV_3W_XXXX_RAID=m
>> CONFIG_SCSI_HPSA=m
>> CONFIG_SCSI_3W_9XXX=m
>> CONFIG_SCSI_3W_SAS=m
>> CONFIG_SCSI_ACARD=m
>> CONFIG_SCSI_AACRAID=m
>> CONFIG_SCSI_AIC7XXX=m
>> CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
>> CONFIG_AIC7XXX_RESET_DELAY_MS=15000
>> CONFIG_AIC7XXX_DEBUG_ENABLE=y
>> CONFIG_AIC7XXX_DEBUG_MASK=0
>> CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
>> CONFIG_SCSI_AIC7XXX_OLD=m
>> CONFIG_SCSI_AIC79XX=m
>> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
>> CONFIG_AIC79XX_RESET_DELAY_MS=15000
>> CONFIG_AIC79XX_DEBUG_ENABLE=y
>> CONFIG_AIC79XX_DEBUG_MASK=0
>> CONFIG_AIC79XX_REG_PRETTY_PRINT=y
>> CONFIG_SCSI_AIC94XX=m
>> # CONFIG_AIC94XX_DEBUG is not set
>> CONFIG_SCSI_MVSAS=m
>> # CONFIG_SCSI_MVSAS_DEBUG is not set
>> # CONFIG_SCSI_MVSAS_TASKLET is not set
>> CONFIG_SCSI_MVUMI=m
>> CONFIG_SCSI_DPT_I2O=m
>> CONFIG_SCSI_ADVANSYS=m
>> CONFIG_SCSI_ARCMSR=m
>> CONFIG_MEGARAID_NEWGEN=y
>> CONFIG_MEGARAID_MM=m
>> CONFIG_MEGARAID_MAILBOX=m
>> CONFIG_MEGARAID_LEGACY=m
>> CONFIG_MEGARAID_SAS=m
>> CONFIG_SCSI_MPT2SAS=m
>> CONFIG_SCSI_MPT2SAS_MAX_SGE=128
>> # CONFIG_SCSI_MPT2SAS_LOGGING is not set
>> CONFIG_SCSI_UFSHCD=m
>> CONFIG_SCSI_HPTIOP=m
>> CONFIG_SCSI_BUSLOGIC=m
>> CONFIG_VMWARE_PVSCSI=m
>> CONFIG_HYPERV_STORAGE=m
>> CONFIG_LIBFC=m
>> CONFIG_LIBFCOE=m
>> CONFIG_FCOE=m
>> CONFIG_FCOE_FNIC=m
>> CONFIG_SCSI_DMX3191D=m
>> CONFIG_SCSI_EATA=m
>> CONFIG_SCSI_EATA_TAGGED_QUEUE=y
>> CONFIG_SCSI_EATA_LINKED_COMMANDS=y
>> CONFIG_SCSI_EATA_MAX_TAGS=16
>> CONFIG_SCSI_FUTURE_DOMAIN=m
>> CONFIG_SCSI_GDTH=m
>> CONFIG_SCSI_ISCI=m
>> CONFIG_SCSI_IPS=m
>> CONFIG_SCSI_INITIO=m
>> CONFIG_SCSI_INIA100=m
>> CONFIG_SCSI_STEX=m
>> CONFIG_SCSI_SYM53C8XX_2=m
>> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
>> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
>> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
>> CONFIG_SCSI_SYM53C8XX_MMIO=y
>> CONFIG_SCSI_IPR=m
>> # CONFIG_SCSI_IPR_TRACE is not set
>> # CONFIG_SCSI_IPR_DUMP is not set
>> CONFIG_SCSI_QLOGIC_1280=m
>> CONFIG_SCSI_QLA_FC=m
>> CONFIG_TCM_QLA2XXX=m
>> CONFIG_SCSI_QLA_ISCSI=m
>> CONFIG_SCSI_LPFC=m
>> # CONFIG_SCSI_LPFC_DEBUG_FS is not set
>> CONFIG_SCSI_DC395x=m
>> CONFIG_SCSI_DC390T=m
>> CONFIG_SCSI_DEBUG=m
>> CONFIG_SCSI_PMCRAID=m
>> CONFIG_SCSI_PM8001=m
>> CONFIG_SCSI_SRP=m
>> CONFIG_SCSI_BFA_FC=m
>> CONFIG_SCSI_VIRTIO=m
>> CONFIG_SCSI_DH=m
>> CONFIG_SCSI_DH_RDAC=m
>> CONFIG_SCSI_DH_HP_SW=m
>> CONFIG_SCSI_DH_EMC=m
>> CONFIG_SCSI_DH_ALUA=m
>> CONFIG_SCSI_OSD_INITIATOR=m
>> CONFIG_SCSI_OSD_ULD=m
>> CONFIG_SCSI_OSD_DPRINT_SENSE=1
>> # CONFIG_SCSI_OSD_DEBUG is not set
>> CONFIG_ATA=y
>> # CONFIG_ATA_NONSTANDARD is not set
>> CONFIG_ATA_VERBOSE_ERROR=y
>> CONFIG_ATA_ACPI=y
>> CONFIG_SATA_PMP=y
>>
>> #
>> # Controllers with non-SFF native interface
>> #
>> CONFIG_SATA_AHCI=m
>> CONFIG_SATA_AHCI_PLATFORM=m
>> # CONFIG_SATA_INIC162X is not set
>> # CONFIG_SATA_ACARD_AHCI is not set
>> # CONFIG_SATA_SIL24 is not set
>> CONFIG_ATA_SFF=y
>>
>> #
>> # SFF controllers with custom DMA interface
>> #
>> # CONFIG_PDC_ADMA is not set
>> # CONFIG_SATA_QSTOR is not set
>> # CONFIG_SATA_SX4 is not set
>> CONFIG_ATA_BMDMA=y
>>
>> #
>> # SATA SFF controllers with BMDMA
>> #
>> CONFIG_ATA_PIIX=m
>> # CONFIG_SATA_HIGHBANK is not set
>> CONFIG_SATA_MV=m
>> CONFIG_SATA_NV=m
>> # CONFIG_SATA_PROMISE is not set
>> # CONFIG_SATA_SIL is not set
>> # CONFIG_SATA_SIS is not set
>> # CONFIG_SATA_SVW is not set
>> # CONFIG_SATA_ULI is not set
>> # CONFIG_SATA_VIA is not set
>> # CONFIG_SATA_VITESSE is not set
>>
>> #
>> # PATA SFF controllers with BMDMA
>> #
>> # CONFIG_PATA_ALI is not set
>> # CONFIG_PATA_AMD is not set
>> # CONFIG_PATA_ARASAN_CF is not set
>> # CONFIG_PATA_ARTOP is not set
>> # CONFIG_PATA_ATIIXP is not set
>> # CONFIG_PATA_ATP867X is not set
>> # CONFIG_PATA_CMD64X is not set
>> # CONFIG_PATA_CS5520 is not set
>> # CONFIG_PATA_CS5530 is not set
>> # CONFIG_PATA_CS5536 is not set
>> # CONFIG_PATA_CYPRESS is not set
>> # CONFIG_PATA_EFAR is not set
>> # CONFIG_PATA_HPT366 is not set
>> # CONFIG_PATA_HPT37X is not set
>> # CONFIG_PATA_HPT3X2N is not set
>> # CONFIG_PATA_HPT3X3 is not set
>> # CONFIG_PATA_IT8213 is not set
>> # CONFIG_PATA_IT821X is not set
>> # CONFIG_PATA_JMICRON is not set
>> # CONFIG_PATA_MARVELL is not set
>> # CONFIG_PATA_NETCELL is not set
>> # CONFIG_PATA_NINJA32 is not set
>> # CONFIG_PATA_NS87415 is not set
>> # CONFIG_PATA_OLDPIIX is not set
>> # CONFIG_PATA_OPTIDMA is not set
>> # CONFIG_PATA_PDC2027X is not set
>> # CONFIG_PATA_PDC_OLD is not set
>> # CONFIG_PATA_RADISYS is not set
>> # CONFIG_PATA_RDC is not set
>> # CONFIG_PATA_SC1200 is not set
>> # CONFIG_PATA_SCH is not set
>> # CONFIG_PATA_SERVERWORKS is not set
>> # CONFIG_PATA_SIL680 is not set
>> # CONFIG_PATA_SIS is not set
>> # CONFIG_PATA_TOSHIBA is not set
>> # CONFIG_PATA_TRIFLEX is not set
>> # CONFIG_PATA_VIA is not set
>> # CONFIG_PATA_WINBOND is not set
>>
>> #
>> # PIO-only SFF controllers
>> #
>> # CONFIG_PATA_CMD640_PCI is not set
>> # CONFIG_PATA_MPIIX is not set
>> # CONFIG_PATA_NS87410 is not set
>> # CONFIG_PATA_OPTI is not set
>> # CONFIG_PATA_RZ1000 is not set
>>
>> #
>> # Generic fallback / legacy drivers
>> #
>> CONFIG_PATA_ACPI=m
>> CONFIG_ATA_GENERIC=m
>> # CONFIG_PATA_LEGACY is not set
>> CONFIG_MD=y
>> CONFIG_BLK_DEV_MD=m
>> CONFIG_MD_LINEAR=m
>> CONFIG_MD_RAID0=m
>> CONFIG_MD_RAID1=m
>> CONFIG_MD_RAID10=m
>> CONFIG_MD_RAID456=m
>> # CONFIG_MULTICORE_RAID456 is not set
>> CONFIG_MD_MULTIPATH=m
>> CONFIG_MD_FAULTY=m
>> CONFIG_BLK_DEV_DM=m
>> # CONFIG_DM_DEBUG is not set
>> CONFIG_DM_BUFIO=m
>> CONFIG_DM_BIO_PRISON=m
>> CONFIG_DM_PERSISTENT_DATA=m
>> CONFIG_DM_CRYPT=m
>> CONFIG_DM_SNAPSHOT=m
>> CONFIG_DM_THIN_PROVISIONING=m
>> # CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
>> CONFIG_DM_MIRROR=m
>> CONFIG_DM_RAID=m
>> CONFIG_DM_LOG_USERSPACE=m
>> CONFIG_DM_ZERO=m
>> CONFIG_DM_MULTIPATH=m
>> CONFIG_DM_MULTIPATH_QL=m
>> CONFIG_DM_MULTIPATH_ST=m
>> CONFIG_DM_DELAY=m
>> CONFIG_DM_UEVENT=y
>> CONFIG_DM_FLAKEY=m
>> CONFIG_DM_VERITY=m
>> CONFIG_TARGET_CORE=m
>> CONFIG_TCM_IBLOCK=m
>> CONFIG_TCM_FILEIO=m
>> CONFIG_TCM_PSCSI=m
>> CONFIG_LOOPBACK_TARGET=m
>> CONFIG_TCM_FC=m
>> CONFIG_ISCSI_TARGET=m
>> CONFIG_SBP_TARGET=m
>> CONFIG_FUSION=y
>> CONFIG_FUSION_SPI=m
>> CONFIG_FUSION_FC=m
>> CONFIG_FUSION_SAS=m
>> CONFIG_FUSION_MAX_SGE=128
>> CONFIG_FUSION_CTL=m
>> CONFIG_FUSION_LAN=m
>> # CONFIG_FUSION_LOGGING is not set
>>
>> #
>> # IEEE 1394 (FireWire) support
>> #
>> CONFIG_FIREWIRE=m
>> CONFIG_FIREWIRE_OHCI=m
>> CONFIG_FIREWIRE_SBP2=m
>> CONFIG_FIREWIRE_NET=m
>> CONFIG_FIREWIRE_NOSY=m
>> CONFIG_I2O=m
>> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
>> CONFIG_I2O_EXT_ADAPTEC=y
>> CONFIG_I2O_EXT_ADAPTEC_DMA64=y
>> CONFIG_I2O_CONFIG=m
>> CONFIG_I2O_CONFIG_OLD_IOCTL=y
>> CONFIG_I2O_BUS=m
>> CONFIG_I2O_BLOCK=m
>> CONFIG_I2O_SCSI=m
>> CONFIG_I2O_PROC=m
>> CONFIG_MACINTOSH_DRIVERS=y
>> CONFIG_MAC_EMUMOUSEBTN=y
>> CONFIG_NETDEVICES=y
>> CONFIG_NET_CORE=y
>> CONFIG_BONDING=m
>> CONFIG_DUMMY=m
>> CONFIG_EQUALIZER=m
>> CONFIG_NET_FC=y
>> CONFIG_MII=m
>> CONFIG_IFB=m
>> CONFIG_NET_TEAM=m
>> CONFIG_NET_TEAM_MODE_BROADCAST=m
>> CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
>> CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
>> CONFIG_NET_TEAM_MODE_LOADBALANCE=m
>> CONFIG_MACVLAN=m
>> CONFIG_MACVTAP=m
>> # CONFIG_VXLAN is not set
>> CONFIG_NETCONSOLE=m
>> CONFIG_NETCONSOLE_DYNAMIC=y
>> CONFIG_NETPOLL=y
>> # CONFIG_NETPOLL_TRAP is not set
>> CONFIG_NET_POLL_CONTROLLER=y
>> CONFIG_TUN=m
>> CONFIG_VETH=m
>> CONFIG_VIRTIO_NET=m
>> CONFIG_SUNGEM_PHY=m
>> # CONFIG_ARCNET is not set
>> # CONFIG_ATM_DRIVERS is not set
>>
>> #
>> # CAIF transport drivers
>> #
>> CONFIG_ETHERNET=y
>> CONFIG_MDIO=m
>> CONFIG_NET_VENDOR_3COM=y
>> CONFIG_VORTEX=m
>> CONFIG_TYPHOON=m
>> CONFIG_NET_VENDOR_ADAPTEC=y
>> CONFIG_ADAPTEC_STARFIRE=m
>> CONFIG_NET_VENDOR_ALTEON=y
>> CONFIG_ACENIC=m
>> # CONFIG_ACENIC_OMIT_TIGON_I is not set
>> CONFIG_NET_VENDOR_AMD=y
>> CONFIG_AMD8111_ETH=m
>> CONFIG_PCNET32=m
>> CONFIG_NET_VENDOR_ATHEROS=y
>> CONFIG_ATL2=m
>> CONFIG_ATL1=m
>> CONFIG_ATL1E=m
>> CONFIG_ATL1C=m
>> CONFIG_NET_VENDOR_BROADCOM=y
>> CONFIG_B44=m
>> CONFIG_B44_PCI_AUTOSELECT=y
>> CONFIG_B44_PCICORE_AUTOSELECT=y
>> CONFIG_B44_PCI=y
>> CONFIG_BNX2=m
>> CONFIG_CNIC=m
>> CONFIG_TIGON3=m
>> CONFIG_BNX2X=m
>> CONFIG_NET_VENDOR_BROCADE=y
>> CONFIG_BNA=m
>> CONFIG_NET_CALXEDA_XGMAC=m
>> CONFIG_NET_VENDOR_CHELSIO=y
>> CONFIG_CHELSIO_T1=m
>> CONFIG_CHELSIO_T1_1G=y
>> CONFIG_CHELSIO_T3=m
>> CONFIG_CHELSIO_T4=m
>> CONFIG_CHELSIO_T4VF=m
>> CONFIG_NET_VENDOR_CISCO=y
>> CONFIG_ENIC=m
>> CONFIG_DNET=m
>> CONFIG_NET_VENDOR_DEC=y
>> CONFIG_NET_TULIP=y
>> CONFIG_DE2104X=m
>> CONFIG_DE2104X_DSL=0
>> CONFIG_TULIP=m
>> # CONFIG_TULIP_MWI is not set
>> # CONFIG_TULIP_MMIO is not set
>> CONFIG_TULIP_NAPI=y
>> CONFIG_TULIP_NAPI_HW_MITIGATION=y
>> # CONFIG_DE4X5 is not set
>> CONFIG_WINBOND_840=m
>> CONFIG_DM9102=m
>> CONFIG_ULI526X=m
>> CONFIG_NET_VENDOR_DLINK=y
>> CONFIG_DL2K=m
>> CONFIG_SUNDANCE=m
>> # CONFIG_SUNDANCE_MMIO is not set
>> CONFIG_NET_VENDOR_EMULEX=y
>> CONFIG_BE2NET=m
>> CONFIG_NET_VENDOR_EXAR=y
>> CONFIG_S2IO=m
>> CONFIG_VXGE=m
>> # CONFIG_VXGE_DEBUG_TRACE_ALL is not set
>> CONFIG_NET_VENDOR_HP=y
>> CONFIG_HP100=m
>> CONFIG_NET_VENDOR_INTEL=y
>> CONFIG_E100=m
>> CONFIG_E1000=m
>> CONFIG_E1000E=m
>> CONFIG_IGB=m
>> CONFIG_IGB_DCA=y
>> CONFIG_IGB_PTP=y
>> CONFIG_IGBVF=m
>> CONFIG_IXGB=m
>> CONFIG_IXGBE=m
>> CONFIG_IXGBE_HWMON=y
>> CONFIG_IXGBE_DCA=y
>> CONFIG_IXGBE_DCB=y
>> CONFIG_IXGBE_PTP=y
>> CONFIG_IXGBEVF=m
>> CONFIG_NET_VENDOR_I825XX=y
>> # CONFIG_ZNET is not set
>> CONFIG_IP1000=m
>> CONFIG_JME=m
>> CONFIG_NET_VENDOR_MARVELL=y
>> CONFIG_SKGE=m
>> # CONFIG_SKGE_DEBUG is not set
>> CONFIG_SKGE_GENESIS=y
>> CONFIG_SKY2=m
>> # CONFIG_SKY2_DEBUG is not set
>> CONFIG_NET_VENDOR_MELLANOX=y
>> CONFIG_MLX4_EN=m
>> CONFIG_MLX4_EN_DCB=y
>> CONFIG_MLX4_CORE=m
>> CONFIG_MLX4_DEBUG=y
>> CONFIG_NET_VENDOR_MICREL=y
>> CONFIG_KS8842=m
>> CONFIG_KS8851=m
>> CONFIG_KS8851_MLL=m
>> CONFIG_KSZ884X_PCI=m
>> CONFIG_NET_VENDOR_MICROCHIP=y
>> CONFIG_ENC28J60=m
>> # CONFIG_ENC28J60_WRITEVERIFY is not set
>> CONFIG_NET_VENDOR_MYRI=y
>> CONFIG_MYRI10GE=m
>> CONFIG_MYRI10GE_DCA=y
>> CONFIG_FEALNX=m
>> CONFIG_NET_VENDOR_NATSEMI=y
>> CONFIG_NATSEMI=m
>> CONFIG_NS83820=m
>> CONFIG_NET_VENDOR_8390=y
>> CONFIG_NE2K_PCI=m
>> CONFIG_NET_VENDOR_NVIDIA=y
>> CONFIG_FORCEDETH=m
>> CONFIG_NET_VENDOR_OKI=y
>> CONFIG_PCH_GBE=m
>> CONFIG_PCH_PTP=y
>> CONFIG_ETHOC=m
>> CONFIG_NET_PACKET_ENGINE=y
>> CONFIG_HAMACHI=m
>> CONFIG_YELLOWFIN=m
>> CONFIG_NET_VENDOR_QLOGIC=y
>> CONFIG_QLA3XXX=m
>> CONFIG_QLCNIC=m
>> CONFIG_QLGE=m
>> CONFIG_NETXEN_NIC=m
>> CONFIG_NET_VENDOR_REALTEK=y
>> CONFIG_8139CP=m
>> CONFIG_8139TOO=m
>> # CONFIG_8139TOO_PIO is not set
>> CONFIG_8139TOO_TUNE_TWISTER=y
>> CONFIG_8139TOO_8129=y
>> # CONFIG_8139_OLD_RX_RESET is not set
>> CONFIG_R8169=m
>> CONFIG_NET_VENDOR_RDC=y
>> CONFIG_R6040=m
>> CONFIG_NET_VENDOR_SEEQ=y
>> # CONFIG_SEEQ8005 is not set
>> CONFIG_NET_VENDOR_SILAN=y
>> CONFIG_SC92031=m
>> CONFIG_NET_VENDOR_SIS=y
>> CONFIG_SIS900=m
>> CONFIG_SIS190=m
>> CONFIG_SFC=m
>> CONFIG_SFC_MTD=y
>> CONFIG_SFC_MCDI_MON=y
>> CONFIG_SFC_SRIOV=y
>> CONFIG_SFC_PTP=y
>> CONFIG_NET_VENDOR_SMSC=y
>> CONFIG_EPIC100=m
>> CONFIG_SMSC9420=m
>> CONFIG_NET_VENDOR_STMICRO=y
>> # CONFIG_STMMAC_ETH is not set
>> CONFIG_NET_VENDOR_SUN=y
>> CONFIG_HAPPYMEAL=m
>> CONFIG_SUNGEM=m
>> CONFIG_CASSINI=m
>> CONFIG_NIU=m
>> CONFIG_NET_VENDOR_TEHUTI=y
>> CONFIG_TEHUTI=m
>> CONFIG_NET_VENDOR_TI=y
>> CONFIG_TLAN=m
>> CONFIG_NET_VENDOR_VIA=y
>> CONFIG_VIA_RHINE=m
>> # CONFIG_VIA_RHINE_MMIO is not set
>> CONFIG_VIA_VELOCITY=m
>> CONFIG_NET_VENDOR_WIZNET=y
>> CONFIG_WIZNET_W5100=m
>> CONFIG_WIZNET_W5300=m
>> # CONFIG_WIZNET_BUS_DIRECT is not set
>> # CONFIG_WIZNET_BUS_INDIRECT is not set
>> CONFIG_WIZNET_BUS_ANY=y
>> # CONFIG_FDDI is not set
>> # CONFIG_HIPPI is not set
>> # CONFIG_NET_SB1000 is not set
>> CONFIG_PHYLIB=m
>>
>> #
>> # MII PHY device drivers
>> #
>> # CONFIG_AT803X_PHY is not set
>> CONFIG_AMD_PHY=m
>> CONFIG_MARVELL_PHY=m
>> CONFIG_DAVICOM_PHY=m
>> CONFIG_QSEMI_PHY=m
>> CONFIG_LXT_PHY=m
>> CONFIG_CICADA_PHY=m
>> CONFIG_VITESSE_PHY=m
>> CONFIG_SMSC_PHY=m
>> CONFIG_BROADCOM_PHY=m
>> CONFIG_BCM87XX_PHY=m
>> CONFIG_ICPLUS_PHY=m
>> CONFIG_REALTEK_PHY=m
>> CONFIG_NATIONAL_PHY=m
>> CONFIG_STE10XP=m
>> CONFIG_LSI_ET1011C_PHY=m
>> CONFIG_MICREL_PHY=m
>> CONFIG_MDIO_BITBANG=m
>> # CONFIG_MDIO_GPIO is not set
>> # CONFIG_MICREL_KS8995MA is not set
>> CONFIG_PPP=m
>> CONFIG_PPP_BSDCOMP=m
>> CONFIG_PPP_DEFLATE=m
>> CONFIG_PPP_FILTER=y
>> CONFIG_PPP_MPPE=m
>> CONFIG_PPP_MULTILINK=y
>> CONFIG_PPPOATM=m
>> CONFIG_PPPOE=m
>> CONFIG_PPTP=m
>> CONFIG_PPPOL2TP=m
>> CONFIG_PPP_ASYNC=m
>> CONFIG_PPP_SYNC_TTY=m
>> CONFIG_SLIP=m
>> CONFIG_SLHC=m
>> CONFIG_SLIP_COMPRESSED=y
>> CONFIG_SLIP_SMART=y
>> CONFIG_SLIP_MODE_SLIP6=y
>>
>> #
>> # USB Network Adapters
>> #
>> CONFIG_USB_CATC=m
>> CONFIG_USB_KAWETH=m
>> CONFIG_USB_PEGASUS=m
>> CONFIG_USB_RTL8150=m
>> CONFIG_USB_USBNET=m
>> CONFIG_USB_NET_AX8817X=m
>> CONFIG_USB_NET_CDCETHER=m
>> CONFIG_USB_NET_CDC_EEM=m
>> CONFIG_USB_NET_CDC_NCM=m
>> CONFIG_USB_NET_DM9601=m
>> CONFIG_USB_NET_SMSC75XX=m
>> CONFIG_USB_NET_SMSC95XX=m
>> CONFIG_USB_NET_GL620A=m
>> CONFIG_USB_NET_NET1080=m
>> CONFIG_USB_NET_PLUSB=m
>> CONFIG_USB_NET_MCS7830=m
>> CONFIG_USB_NET_RNDIS_HOST=m
>> CONFIG_USB_NET_CDC_SUBSET=m
>> CONFIG_USB_ALI_M5632=y
>> CONFIG_USB_AN2720=y
>> CONFIG_USB_BELKIN=y
>> CONFIG_USB_ARMLINUX=y
>> CONFIG_USB_EPSON2888=y
>> CONFIG_USB_KC2190=y
>> CONFIG_USB_NET_ZAURUS=m
>> CONFIG_USB_NET_CX82310_ETH=m
>> CONFIG_USB_NET_KALMIA=m
>> CONFIG_USB_NET_QMI_WWAN=m
>> CONFIG_USB_HSO=m
>> CONFIG_USB_NET_INT51X1=m
>> CONFIG_USB_CDC_PHONET=m
>> CONFIG_USB_IPHETH=m
>> CONFIG_USB_SIERRA_NET=m
>> CONFIG_USB_VL600=m
>> CONFIG_WLAN=y
>> CONFIG_LIBERTAS_THINFIRM=m
>> # CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
>> CONFIG_LIBERTAS_THINFIRM_USB=m
>> CONFIG_AIRO=m
>> CONFIG_ATMEL=m
>> CONFIG_PCI_ATMEL=m
>> CONFIG_AT76C50X_USB=m
>> # CONFIG_PRISM54 is not set
>> CONFIG_USB_ZD1201=m
>> CONFIG_USB_NET_RNDIS_WLAN=m
>> CONFIG_RTL8180=m
>> CONFIG_RTL8187=m
>> CONFIG_RTL8187_LEDS=y
>> CONFIG_ADM8211=m
>> CONFIG_MAC80211_HWSIM=m
>> CONFIG_MWL8K=m
>> CONFIG_ATH_COMMON=m
>> # CONFIG_ATH_DEBUG is not set
>> CONFIG_ATH5K=m
>> # CONFIG_ATH5K_DEBUG is not set
>> # CONFIG_ATH5K_TRACER is not set
>> CONFIG_ATH5K_PCI=y
>> CONFIG_ATH9K_HW=m
>> CONFIG_ATH9K_COMMON=m
>> CONFIG_ATH9K_BTCOEX_SUPPORT=y
>> CONFIG_ATH9K=m
>> CONFIG_ATH9K_PCI=y
>> # CONFIG_ATH9K_AHB is not set
>> # CONFIG_ATH9K_DEBUGFS is not set
>> CONFIG_ATH9K_RATE_CONTROL=y
>> CONFIG_ATH9K_HTC=m
>> # CONFIG_ATH9K_HTC_DEBUGFS is not set
>> CONFIG_CARL9170=m
>> CONFIG_CARL9170_LEDS=y
>> CONFIG_CARL9170_WPC=y
>> # CONFIG_CARL9170_HWRNG is not set
>> # CONFIG_ATH6KL is not set
>> CONFIG_B43=m
>> CONFIG_B43_BCMA=y
>> CONFIG_B43_BCMA_EXTRA=y
>> CONFIG_B43_SSB=y
>> CONFIG_B43_PCI_AUTOSELECT=y
>> CONFIG_B43_PCICORE_AUTOSELECT=y
>> CONFIG_B43_SDIO=y
>> CONFIG_B43_BCMA_PIO=y
>> CONFIG_B43_PIO=y
>> CONFIG_B43_PHY_N=y
>> CONFIG_B43_PHY_LP=y
>> CONFIG_B43_PHY_HT=y
>> CONFIG_B43_LEDS=y
>> CONFIG_B43_HWRNG=y
>> # CONFIG_B43_DEBUG is not set
>> CONFIG_B43LEGACY=m
>> CONFIG_B43LEGACY_PCI_AUTOSELECT=y
>> CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
>> CONFIG_B43LEGACY_LEDS=y
>> CONFIG_B43LEGACY_HWRNG=y
>> CONFIG_B43LEGACY_DEBUG=y
>> CONFIG_B43LEGACY_DMA=y
>> CONFIG_B43LEGACY_PIO=y
>> CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
>> # CONFIG_B43LEGACY_DMA_MODE is not set
>> # CONFIG_B43LEGACY_PIO_MODE is not set
>> CONFIG_BRCMUTIL=m
>> CONFIG_BRCMSMAC=m
>> # CONFIG_BRCMFMAC is not set
>> # CONFIG_BRCMDBG is not set
>> CONFIG_HOSTAP=m
>> CONFIG_HOSTAP_FIRMWARE=y
>> # CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
>> CONFIG_HOSTAP_PLX=m
>> CONFIG_HOSTAP_PCI=m
>> # CONFIG_IPW2100 is not set
>> CONFIG_IPW2200=m
>> CONFIG_IPW2200_MONITOR=y
>> CONFIG_IPW2200_RADIOTAP=y
>> CONFIG_IPW2200_PROMISCUOUS=y
>> CONFIG_IPW2200_QOS=y
>> # CONFIG_IPW2200_DEBUG is not set
>> CONFIG_LIBIPW=m
>> # CONFIG_LIBIPW_DEBUG is not set
>> CONFIG_IWLWIFI=m
>> CONFIG_IWLDVM=m
>>
>> #
>> # Debugging Options
>> #
>> # CONFIG_IWLWIFI_DEBUG is not set
>> # CONFIG_IWLWIFI_DEVICE_TRACING is not set
>> CONFIG_IWLWIFI_P2P=y
>> # CONFIG_IWLWIFI_EXPERIMENTAL_MFP is not set
>> CONFIG_IWLEGACY=m
>> CONFIG_IWL4965=m
>> CONFIG_IWL3945=m
>>
>> #
>> # iwl3945 / iwl4965 Debugging Options
>> #
>> # CONFIG_IWLEGACY_DEBUG is not set
>> CONFIG_LIBERTAS=m
>> CONFIG_LIBERTAS_USB=m
>> CONFIG_LIBERTAS_SDIO=m
>> CONFIG_LIBERTAS_SPI=m
>> # CONFIG_LIBERTAS_DEBUG is not set
>> CONFIG_LIBERTAS_MESH=y
>> CONFIG_HERMES=m
>> # CONFIG_HERMES_PRISM is not set
>> CONFIG_HERMES_CACHE_FW_ON_INIT=y
>> CONFIG_PLX_HERMES=m
>> CONFIG_TMD_HERMES=m
>> CONFIG_NORTEL_HERMES=m
>> CONFIG_ORINOCO_USB=m
>> CONFIG_P54_COMMON=m
>> CONFIG_P54_USB=m
>> CONFIG_P54_PCI=m
>> CONFIG_P54_SPI=m
>> # CONFIG_P54_SPI_DEFAULT_EEPROM is not set
>> CONFIG_P54_LEDS=y
>> CONFIG_RT2X00=m
>> CONFIG_RT2400PCI=m
>> CONFIG_RT2500PCI=m
>> CONFIG_RT61PCI=m
>> CONFIG_RT2800PCI=m
>> CONFIG_RT2800PCI_RT33XX=y
>> CONFIG_RT2800PCI_RT35XX=y
>> CONFIG_RT2800PCI_RT53XX=y
>> CONFIG_RT2800PCI_RT3290=y
>> CONFIG_RT2500USB=m
>> CONFIG_RT73USB=m
>> CONFIG_RT2800USB=m
>> CONFIG_RT2800USB_RT33XX=y
>> CONFIG_RT2800USB_RT35XX=y
>> CONFIG_RT2800USB_RT53XX=y
>> # CONFIG_RT2800USB_UNKNOWN is not set
>> CONFIG_RT2800_LIB=m
>> CONFIG_RT2X00_LIB_PCI=m
>> CONFIG_RT2X00_LIB_USB=m
>> CONFIG_RT2X00_LIB=m
>> CONFIG_RT2X00_LIB_FIRMWARE=y
>> CONFIG_RT2X00_LIB_CRYPTO=y
>> CONFIG_RT2X00_LIB_LEDS=y
>> # CONFIG_RT2X00_DEBUG is not set
>> CONFIG_RTL8192CE=m
>> CONFIG_RTL8192SE=m
>> CONFIG_RTL8192DE=m
>> CONFIG_RTL8192CU=m
>> CONFIG_RTLWIFI=m
>> # CONFIG_RTLWIFI_DEBUG is not set
>> CONFIG_RTL8192C_COMMON=m
>> CONFIG_WL_TI=y
>> CONFIG_WL1251=m
>> CONFIG_WL1251_SPI=m
>> CONFIG_WL1251_SDIO=m
>> CONFIG_WL12XX=m
>> CONFIG_WL18XX=m
>> CONFIG_WLCORE=m
>> CONFIG_WLCORE_SPI=m
>> CONFIG_WLCORE_SDIO=m
>> CONFIG_WL12XX_PLATFORM_DATA=y
>> CONFIG_ZD1211RW=m
>> # CONFIG_ZD1211RW_DEBUG is not set
>> CONFIG_MWIFIEX=m
>> CONFIG_MWIFIEX_SDIO=m
>> CONFIG_MWIFIEX_PCIE=m
>> CONFIG_MWIFIEX_USB=m
>>
>> #
>> # WiMAX Wireless Broadband devices
>> #
>> CONFIG_WIMAX_I2400M=m
>> CONFIG_WIMAX_I2400M_USB=m
>> CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
>> CONFIG_WAN=y
>> # CONFIG_LANMEDIA is not set
>> CONFIG_HDLC=m
>> CONFIG_HDLC_RAW=m
>> CONFIG_HDLC_RAW_ETH=m
>> CONFIG_HDLC_CISCO=m
>> CONFIG_HDLC_FR=m
>> CONFIG_HDLC_PPP=m
>> # CONFIG_HDLC_X25 is not set
>> # CONFIG_PCI200SYN is not set
>> # CONFIG_WANXL is not set
>> # CONFIG_PC300TOO is not set
>> # CONFIG_FARSYNC is not set
>> # CONFIG_DSCC4 is not set
>> CONFIG_DLCI=m
>> CONFIG_DLCI_MAX=8
>> CONFIG_WAN_ROUTER_DRIVERS=m
>> # CONFIG_CYCLADES_SYNC is not set
>> # CONFIG_SBNI is not set
>> CONFIG_IEEE802154_DRIVERS=m
>> CONFIG_IEEE802154_FAKEHARD=m
>> CONFIG_VMXNET3=m
>> CONFIG_HYPERV_NET=m
>> CONFIG_ISDN=y
>> # CONFIG_ISDN_I4L is not set
>> CONFIG_ISDN_CAPI=m
>> CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
>> CONFIG_CAPI_TRACE=y
>> CONFIG_ISDN_CAPI_MIDDLEWARE=y
>> CONFIG_ISDN_CAPI_CAPI20=m
>>
>> #
>> # CAPI hardware drivers
>> #
>> CONFIG_CAPI_AVM=y
>> CONFIG_ISDN_DRV_AVMB1_B1PCI=m
>> CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
>> CONFIG_ISDN_DRV_AVMB1_T1PCI=m
>> CONFIG_ISDN_DRV_AVMB1_C4=m
>> CONFIG_CAPI_EICON=y
>> CONFIG_ISDN_DIVAS=m
>> CONFIG_ISDN_DIVAS_BRIPCI=y
>> CONFIG_ISDN_DIVAS_PRIPCI=y
>> CONFIG_ISDN_DIVAS_DIVACAPI=m
>> CONFIG_ISDN_DIVAS_USERIDI=m
>> CONFIG_ISDN_DIVAS_MAINT=m
>> CONFIG_ISDN_DRV_GIGASET=m
>> CONFIG_GIGASET_CAPI=y
>> # CONFIG_GIGASET_DUMMYLL is not set
>> CONFIG_GIGASET_BASE=m
>> CONFIG_GIGASET_M105=m
>> CONFIG_GIGASET_M101=m
>> # CONFIG_GIGASET_DEBUG is not set
>> # CONFIG_HYSDN is not set
>> CONFIG_MISDN=m
>> CONFIG_MISDN_DSP=m
>> CONFIG_MISDN_L1OIP=m
>>
>> #
>> # mISDN hardware drivers
>> #
>> CONFIG_MISDN_HFCPCI=m
>> CONFIG_MISDN_HFCMULTI=m
>> CONFIG_MISDN_HFCUSB=m
>> CONFIG_MISDN_AVMFRITZ=m
>> CONFIG_MISDN_SPEEDFAX=m
>> CONFIG_MISDN_INFINEON=m
>> CONFIG_MISDN_W6692=m
>> # CONFIG_MISDN_NETJET is not set
>> CONFIG_MISDN_IPAC=m
>> CONFIG_MISDN_ISAR=m
>>
>> #
>> # Input device support
>> #
>> CONFIG_INPUT=y
>> CONFIG_INPUT_FF_MEMLESS=m
>> CONFIG_INPUT_POLLDEV=m
>> CONFIG_INPUT_SPARSEKMAP=m
>> CONFIG_INPUT_MATRIXKMAP=m
>>
>> #
>> # Userland interfaces
>> #
>> CONFIG_INPUT_MOUSEDEV=y
>> CONFIG_INPUT_MOUSEDEV_PSAUX=y
>> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
>> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
>> CONFIG_INPUT_JOYDEV=m
>> CONFIG_INPUT_EVDEV=m
>> # CONFIG_INPUT_EVBUG is not set
>>
>> #
>> # Input Device Drivers
>> #
>> CONFIG_INPUT_KEYBOARD=y
>> CONFIG_KEYBOARD_ADP5588=m
>> # CONFIG_KEYBOARD_ADP5589 is not set
>> CONFIG_KEYBOARD_ATKBD=y
>> # CONFIG_KEYBOARD_QT1070 is not set
>> CONFIG_KEYBOARD_QT2160=m
>> CONFIG_KEYBOARD_LKKBD=m
>> # CONFIG_KEYBOARD_GPIO is not set
>> # CONFIG_KEYBOARD_GPIO_POLLED is not set
>> # CONFIG_KEYBOARD_TCA6416 is not set
>> CONFIG_KEYBOARD_TCA8418=m
>> # CONFIG_KEYBOARD_MATRIX is not set
>> CONFIG_KEYBOARD_LM8323=m
>> CONFIG_KEYBOARD_LM8333=m
>> CONFIG_KEYBOARD_MAX7359=m
>> # CONFIG_KEYBOARD_MCS is not set
>> # CONFIG_KEYBOARD_MPR121 is not set
>> CONFIG_KEYBOARD_NEWTON=m
>> CONFIG_KEYBOARD_OPENCORES=m
>> CONFIG_KEYBOARD_STOWAWAY=m
>> CONFIG_KEYBOARD_SUNKBD=m
>> CONFIG_KEYBOARD_OMAP4=m
>> CONFIG_KEYBOARD_XTKBD=m
>> CONFIG_INPUT_MOUSE=y
>> CONFIG_MOUSE_PS2=m
>> CONFIG_MOUSE_PS2_ALPS=y
>> CONFIG_MOUSE_PS2_LOGIPS2PP=y
>> CONFIG_MOUSE_PS2_SYNAPTICS=y
>> CONFIG_MOUSE_PS2_LIFEBOOK=y
>> CONFIG_MOUSE_PS2_TRACKPOINT=y
>> CONFIG_MOUSE_PS2_ELANTECH=y
>> CONFIG_MOUSE_PS2_SENTELIC=y
>> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
>> CONFIG_MOUSE_SERIAL=m
>> CONFIG_MOUSE_APPLETOUCH=m
>> CONFIG_MOUSE_BCM5974=m
>> CONFIG_MOUSE_VSXXXAA=m
>> # CONFIG_MOUSE_GPIO is not set
>> CONFIG_MOUSE_SYNAPTICS_I2C=m
>> CONFIG_MOUSE_SYNAPTICS_USB=m
>> CONFIG_INPUT_JOYSTICK=y
>> CONFIG_JOYSTICK_ANALOG=m
>> CONFIG_JOYSTICK_A3D=m
>> CONFIG_JOYSTICK_ADI=m
>> CONFIG_JOYSTICK_COBRA=m
>> CONFIG_JOYSTICK_GF2K=m
>> CONFIG_JOYSTICK_GRIP=m
>> CONFIG_JOYSTICK_GRIP_MP=m
>> CONFIG_JOYSTICK_GUILLEMOT=m
>> CONFIG_JOYSTICK_INTERACT=m
>> CONFIG_JOYSTICK_SIDEWINDER=m
>> CONFIG_JOYSTICK_TMDC=m
>> CONFIG_JOYSTICK_IFORCE=m
>> CONFIG_JOYSTICK_IFORCE_USB=y
>> CONFIG_JOYSTICK_IFORCE_232=y
>> CONFIG_JOYSTICK_WARRIOR=m
>> CONFIG_JOYSTICK_MAGELLAN=m
>> CONFIG_JOYSTICK_SPACEORB=m
>> CONFIG_JOYSTICK_SPACEBALL=m
>> CONFIG_JOYSTICK_STINGER=m
>> CONFIG_JOYSTICK_TWIDJOY=m
>> CONFIG_JOYSTICK_ZHENHUA=m
>> # CONFIG_JOYSTICK_AS5011 is not set
>> CONFIG_JOYSTICK_JOYDUMP=m
>> CONFIG_JOYSTICK_XPAD=m
>> CONFIG_JOYSTICK_XPAD_FF=y
>> CONFIG_JOYSTICK_XPAD_LEDS=y
>> CONFIG_INPUT_TABLET=y
>> CONFIG_TABLET_USB_ACECAD=m
>> CONFIG_TABLET_USB_AIPTEK=m
>> CONFIG_TABLET_USB_GTCO=m
>> CONFIG_TABLET_USB_HANWANG=m
>> CONFIG_TABLET_USB_KBTAB=m
>> CONFIG_TABLET_USB_WACOM=m
>> CONFIG_INPUT_TOUCHSCREEN=y
>> CONFIG_TOUCHSCREEN_ADS7846=m
>> CONFIG_TOUCHSCREEN_AD7877=m
>> CONFIG_TOUCHSCREEN_AD7879=m
>> CONFIG_TOUCHSCREEN_AD7879_I2C=m
>> # CONFIG_TOUCHSCREEN_AD7879_SPI is not set
>> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
>> CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
>> # CONFIG_TOUCHSCREEN_BU21013 is not set
>> # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
>> CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
>> CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
>> CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
>> CONFIG_TOUCHSCREEN_DYNAPRO=m
>> CONFIG_TOUCHSCREEN_HAMPSHIRE=m
>> CONFIG_TOUCHSCREEN_EETI=m
>> CONFIG_TOUCHSCREEN_FUJITSU=m
>> CONFIG_TOUCHSCREEN_ILI210X=m
>> CONFIG_TOUCHSCREEN_GUNZE=m
>> CONFIG_TOUCHSCREEN_ELO=m
>> CONFIG_TOUCHSCREEN_WACOM_W8001=m
>> CONFIG_TOUCHSCREEN_WACOM_I2C=m
>> # CONFIG_TOUCHSCREEN_MAX11801 is not set
>> CONFIG_TOUCHSCREEN_MCS5000=m
>> CONFIG_TOUCHSCREEN_MMS114=m
>> CONFIG_TOUCHSCREEN_MTOUCH=m
>> CONFIG_TOUCHSCREEN_INEXIO=m
>> CONFIG_TOUCHSCREEN_MK712=m
>> CONFIG_TOUCHSCREEN_PENMOUNT=m
>> CONFIG_TOUCHSCREEN_EDT_FT5X06=m
>> CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
>> CONFIG_TOUCHSCREEN_TOUCHWIN=m
>> CONFIG_TOUCHSCREEN_PIXCIR=m
>> CONFIG_TOUCHSCREEN_WM97XX=m
>> CONFIG_TOUCHSCREEN_WM9705=y
>> CONFIG_TOUCHSCREEN_WM9712=y
>> CONFIG_TOUCHSCREEN_WM9713=y
>> CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
>> CONFIG_TOUCHSCREEN_USB_EGALAX=y
>> CONFIG_TOUCHSCREEN_USB_PANJIT=y
>> CONFIG_TOUCHSCREEN_USB_3M=y
>> CONFIG_TOUCHSCREEN_USB_ITM=y
>> CONFIG_TOUCHSCREEN_USB_ETURBO=y
>> CONFIG_TOUCHSCREEN_USB_GUNZE=y
>> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
>> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
>> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
>> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
>> CONFIG_TOUCHSCREEN_USB_GOTOP=y
>> CONFIG_TOUCHSCREEN_USB_JASTEC=y
>> CONFIG_TOUCHSCREEN_USB_ELO=y
>> CONFIG_TOUCHSCREEN_USB_E2I=y
>> CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
>> CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
>> CONFIG_TOUCHSCREEN_USB_NEXIO=y
>> CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
>> CONFIG_TOUCHSCREEN_TOUCHIT213=m
>> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
>> # CONFIG_TOUCHSCREEN_TSC2005 is not set
>> CONFIG_TOUCHSCREEN_TSC2007=m
>> # CONFIG_TOUCHSCREEN_ST1232 is not set
>> CONFIG_TOUCHSCREEN_TPS6507X=m
>> CONFIG_INPUT_MISC=y
>> # CONFIG_INPUT_AD714X is not set
>> # CONFIG_INPUT_BMA150 is not set
>> CONFIG_INPUT_PCSPKR=m
>> # CONFIG_INPUT_MMA8450 is not set
>> # CONFIG_INPUT_MPU3050 is not set
>> CONFIG_INPUT_APANEL=m
>> CONFIG_INPUT_GP2A=m
>> CONFIG_INPUT_GPIO_TILT_POLLED=m
>> CONFIG_INPUT_ATLAS_BTNS=m
>> CONFIG_INPUT_ATI_REMOTE2=m
>> CONFIG_INPUT_KEYSPAN_REMOTE=m
>> # CONFIG_INPUT_KXTJ9 is not set
>> CONFIG_INPUT_POWERMATE=m
>> CONFIG_INPUT_YEALINK=m
>> CONFIG_INPUT_CM109=m
>> CONFIG_INPUT_UINPUT=m
>> CONFIG_INPUT_PCF50633_PMU=m
>> # CONFIG_INPUT_PCF8574 is not set
>> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
>> # CONFIG_INPUT_ADXL34X is not set
>> # CONFIG_INPUT_CMA3000 is not set
>>
>> #
>> # Hardware I/O ports
>> #
>> CONFIG_SERIO=y
>> CONFIG_SERIO_I8042=y
>> CONFIG_SERIO_SERPORT=m
>> CONFIG_SERIO_CT82C710=m
>> CONFIG_SERIO_PCIPS2=m
>> CONFIG_SERIO_LIBPS2=y
>> CONFIG_SERIO_RAW=m
>> CONFIG_SERIO_ALTERA_PS2=m
>> # CONFIG_SERIO_PS2MULT is not set
>> CONFIG_GAMEPORT=m
>> CONFIG_GAMEPORT_NS558=m
>> CONFIG_GAMEPORT_L4=m
>> CONFIG_GAMEPORT_EMU10K1=m
>> CONFIG_GAMEPORT_FM801=m
>>
>> #
>> # Character devices
>> #
>> CONFIG_VT=y
>> CONFIG_CONSOLE_TRANSLATIONS=y
>> CONFIG_VT_CONSOLE=y
>> CONFIG_VT_CONSOLE_SLEEP=y
>> CONFIG_HW_CONSOLE=y
>> CONFIG_VT_HW_CONSOLE_BINDING=y
>> CONFIG_UNIX98_PTYS=y
>> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
>> # CONFIG_LEGACY_PTYS is not set
>> CONFIG_SERIAL_NONSTANDARD=y
>> CONFIG_ROCKETPORT=m
>> CONFIG_CYCLADES=m
>> # CONFIG_CYZ_INTR is not set
>> CONFIG_MOXA_INTELLIO=m
>> CONFIG_MOXA_SMARTIO=m
>> CONFIG_SYNCLINK=m
>> CONFIG_SYNCLINKMP=m
>> CONFIG_SYNCLINK_GT=m
>> CONFIG_NOZOMI=m
>> CONFIG_ISI=m
>> CONFIG_N_HDLC=m
>> CONFIG_N_GSM=m
>> # CONFIG_TRACE_SINK is not set
>> # CONFIG_DEVKMEM is not set
>> CONFIG_STALDRV=y
>>
>> #
>> # Serial drivers
>> #
>> CONFIG_SERIAL_8250=y
>> CONFIG_SERIAL_8250_PNP=y
>> CONFIG_SERIAL_8250_CONSOLE=y
>> CONFIG_FIX_EARLYCON_MEM=y
>> CONFIG_SERIAL_8250_PCI=y
>> CONFIG_SERIAL_8250_NR_UARTS=32
>> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
>> CONFIG_SERIAL_8250_EXTENDED=y
>> CONFIG_SERIAL_8250_MANY_PORTS=y
>> CONFIG_SERIAL_8250_SHARE_IRQ=y
>> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
>> CONFIG_SERIAL_8250_RSA=y
>>
>> #
>> # Non-8250 serial port support
>> #
>> CONFIG_SERIAL_MAX3100=m
>> # CONFIG_SERIAL_MAX310X is not set
>> CONFIG_SERIAL_MFD_HSU=m
>> CONFIG_SERIAL_CORE=y
>> CONFIG_SERIAL_CORE_CONSOLE=y
>> CONFIG_SERIAL_JSM=m
>> # CONFIG_SERIAL_SCCNXP is not set
>> # CONFIG_SERIAL_TIMBERDALE is not set
>> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
>> # CONFIG_SERIAL_ALTERA_UART is not set
>> # CONFIG_SERIAL_IFX6X60 is not set
>> CONFIG_SERIAL_PCH_UART=m
>> # CONFIG_SERIAL_XILINX_PS_UART is not set
>> CONFIG_HVC_DRIVER=y
>> CONFIG_VIRTIO_CONSOLE=m
>> CONFIG_IPMI_HANDLER=m
>> # CONFIG_IPMI_PANIC_EVENT is not set
>> CONFIG_IPMI_DEVICE_INTERFACE=m
>> CONFIG_IPMI_SI=m
>> CONFIG_IPMI_WATCHDOG=m
>> CONFIG_IPMI_POWEROFF=m
>> CONFIG_HW_RANDOM=m
>> CONFIG_HW_RANDOM_TIMERIOMEM=m
>> CONFIG_HW_RANDOM_INTEL=m
>> CONFIG_HW_RANDOM_AMD=m
>> CONFIG_HW_RANDOM_VIA=m
>> CONFIG_HW_RANDOM_VIRTIO=m
>> CONFIG_HW_RANDOM_TPM=m
>> CONFIG_NVRAM=m
>> CONFIG_R3964=m
>> CONFIG_APPLICOM=m
>> CONFIG_MWAVE=m
>> CONFIG_RAW_DRIVER=m
>> CONFIG_MAX_RAW_DEVS=256
>> CONFIG_HPET=y
>> CONFIG_HPET_MMAP=y
>> CONFIG_HANGCHECK_TIMER=m
>> CONFIG_TCG_TPM=m
>> CONFIG_TCG_TIS=m
>> CONFIG_TCG_TIS_I2C_INFINEON=m
>> CONFIG_TCG_NSC=m
>> CONFIG_TCG_ATMEL=m
>> CONFIG_TCG_INFINEON=m
>> CONFIG_TELCLOCK=m
>> CONFIG_DEVPORT=y
>> CONFIG_I2C=y
>> CONFIG_I2C_BOARDINFO=y
>> CONFIG_I2C_COMPAT=y
>> CONFIG_I2C_CHARDEV=m
>> # CONFIG_I2C_MUX is not set
>> CONFIG_I2C_HELPER_AUTO=y
>> CONFIG_I2C_SMBUS=m
>> CONFIG_I2C_ALGOBIT=y
>> CONFIG_I2C_ALGOPCA=m
>>
>> #
>> # I2C Hardware Bus support
>> #
>>
>> #
>> # PC SMBus host controller drivers
>> #
>> CONFIG_I2C_ALI1535=m
>> CONFIG_I2C_ALI1563=m
>> CONFIG_I2C_ALI15X3=m
>> CONFIG_I2C_AMD756=m
>> CONFIG_I2C_AMD756_S4882=m
>> CONFIG_I2C_AMD8111=m
>> CONFIG_I2C_I801=m
>> CONFIG_I2C_ISCH=m
>> CONFIG_I2C_PIIX4=m
>> CONFIG_I2C_NFORCE2=m
>> CONFIG_I2C_NFORCE2_S4985=m
>> CONFIG_I2C_SIS5595=m
>> CONFIG_I2C_SIS630=m
>> CONFIG_I2C_SIS96X=m
>> CONFIG_I2C_VIA=m
>> CONFIG_I2C_VIAPRO=m
>>
>> #
>> # ACPI drivers
>> #
>> CONFIG_I2C_SCMI=m
>>
>> #
>> # I2C system bus drivers (mostly embedded / system-on-chip)
>> #
>> # CONFIG_I2C_DESIGNWARE_PCI is not set
>> CONFIG_I2C_EG20T=m
>> # CONFIG_I2C_GPIO is not set
>> # CONFIG_I2C_INTEL_MID is not set
>> CONFIG_I2C_OCORES=m
>> CONFIG_I2C_PCA_PLATFORM=m
>> # CONFIG_I2C_PXA_PCI is not set
>> CONFIG_I2C_SIMTEC=m
>> # CONFIG_I2C_XILINX is not set
>>
>> #
>> # External I2C/SMBus adapter drivers
>> #
>> CONFIG_I2C_DIOLAN_U2C=m
>> CONFIG_I2C_PARPORT_LIGHT=m
>> CONFIG_I2C_TAOS_EVM=m
>> CONFIG_I2C_TINY_USB=m
>>
>> #
>> # Other I2C/SMBus bus drivers
>> #
>> CONFIG_I2C_STUB=m
>> # CONFIG_I2C_DEBUG_CORE is not set
>> # CONFIG_I2C_DEBUG_ALGO is not set
>> # CONFIG_I2C_DEBUG_BUS is not set
>> CONFIG_SPI=y
>> # CONFIG_SPI_DEBUG is not set
>> CONFIG_SPI_MASTER=y
>>
>> #
>> # SPI Master Controller Drivers
>> #
>> # CONFIG_SPI_ALTERA is not set
>> CONFIG_SPI_BITBANG=m
>> # CONFIG_SPI_GPIO is not set
>> # CONFIG_SPI_OC_TINY is not set
>> # CONFIG_SPI_PXA2XX_PCI is not set
>> # CONFIG_SPI_SC18IS602 is not set
>> CONFIG_SPI_TOPCLIFF_PCH=m
>> CONFIG_SPI_XCOMM=m
>> # CONFIG_SPI_XILINX is not set
>> # CONFIG_SPI_DESIGNWARE is not set
>>
>> #
>> # SPI Protocol Masters
>> #
>> # CONFIG_SPI_SPIDEV is not set
>> CONFIG_SPI_TLE62X0=m
>> CONFIG_HSI=m
>> CONFIG_HSI_BOARDINFO=y
>>
>> #
>> # HSI clients
>> #
>> CONFIG_HSI_CHAR=m
>>
>> #
>> # PPS support
>> #
>> CONFIG_PPS=m
>> # CONFIG_PPS_DEBUG is not set
>>
>> #
>> # PPS clients support
>> #
>> # CONFIG_PPS_CLIENT_KTIMER is not set
>> CONFIG_PPS_CLIENT_LDISC=m
>> # CONFIG_PPS_CLIENT_GPIO is not set
>>
>> #
>> # PPS generators support
>> #
>>
>> #
>> # PTP clock support
>> #
>> CONFIG_PTP_1588_CLOCK=m
>>
>> #
>> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
>> #
>> CONFIG_PTP_1588_CLOCK_PCH=m
>> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
>> CONFIG_GPIOLIB=y
>> # CONFIG_DEBUG_GPIO is not set
>> # CONFIG_GPIO_SYSFS is not set
>> CONFIG_GPIO_GENERIC=m
>>
>> #
>> # Memory mapped GPIO drivers:
>> #
>> CONFIG_GPIO_GENERIC_PLATFORM=m
>> CONFIG_GPIO_IT8761E=m
>> # CONFIG_GPIO_SCH is not set
>> CONFIG_GPIO_ICH=m
>> # CONFIG_GPIO_VX855 is not set
>>
>> #
>> # I2C GPIO expanders:
>> #
>> # CONFIG_GPIO_MAX7300 is not set
>> # CONFIG_GPIO_MAX732X is not set
>> # CONFIG_GPIO_PCA953X is not set
>> # CONFIG_GPIO_PCF857X is not set
>> # CONFIG_GPIO_SX150X is not set
>> # CONFIG_GPIO_ADP5588 is not set
>>
>> #
>> # PCI GPIO expanders:
>> #
>> CONFIG_GPIO_AMD8111=m
>> # CONFIG_GPIO_LANGWELL is not set
>> CONFIG_GPIO_PCH=m
>> # CONFIG_GPIO_ML_IOH is not set
>> # CONFIG_GPIO_RDC321X is not set
>>
>> #
>> # SPI GPIO expanders:
>> #
>> # CONFIG_GPIO_MAX7301 is not set
>> # CONFIG_GPIO_MCP23S08 is not set
>> # CONFIG_GPIO_MC33880 is not set
>> # CONFIG_GPIO_74X164 is not set
>>
>> #
>> # AC97 GPIO expanders:
>> #
>>
>> #
>> # MODULbus GPIO expanders:
>> #
>> CONFIG_W1=m
>> CONFIG_W1_CON=y
>>
>> #
>> # 1-wire Bus Masters
>> #
>> CONFIG_W1_MASTER_MATROX=m
>> CONFIG_W1_MASTER_DS2490=m
>> CONFIG_W1_MASTER_DS2482=m
>> # CONFIG_W1_MASTER_DS1WM is not set
>> # CONFIG_W1_MASTER_GPIO is not set
>> # CONFIG_HDQ_MASTER_OMAP is not set
>>
>> #
>> # 1-wire Slaves
>> #
>> CONFIG_W1_SLAVE_THERM=m
>> CONFIG_W1_SLAVE_SMEM=m
>> # CONFIG_W1_SLAVE_DS2408 is not set
>> # CONFIG_W1_SLAVE_DS2423 is not set
>> CONFIG_W1_SLAVE_DS2431=m
>> CONFIG_W1_SLAVE_DS2433=m
>> # CONFIG_W1_SLAVE_DS2433_CRC is not set
>> CONFIG_W1_SLAVE_DS2760=m
>> # CONFIG_W1_SLAVE_DS2780 is not set
>> CONFIG_W1_SLAVE_DS2781=m
>> CONFIG_W1_SLAVE_DS28E04=m
>> CONFIG_W1_SLAVE_BQ27000=m
>> CONFIG_POWER_SUPPLY=y
>> # CONFIG_POWER_SUPPLY_DEBUG is not set
>> CONFIG_PDA_POWER=m
>> # CONFIG_TEST_POWER is not set
>> CONFIG_BATTERY_DS2760=m
>> # CONFIG_BATTERY_DS2780 is not set
>> CONFIG_BATTERY_DS2781=m
>> CONFIG_BATTERY_DS2782=m
>> CONFIG_BATTERY_SBS=m
>> CONFIG_BATTERY_BQ27x00=m
>> CONFIG_BATTERY_BQ27X00_I2C=y
>> CONFIG_BATTERY_BQ27X00_PLATFORM=y
>> CONFIG_BATTERY_MAX17040=m
>> # CONFIG_BATTERY_MAX17042 is not set
>> CONFIG_CHARGER_PCF50633=m
>> # CONFIG_CHARGER_ISP1704 is not set
>> # CONFIG_CHARGER_MAX8903 is not set
>> CONFIG_CHARGER_LP8727=m
>> # CONFIG_CHARGER_GPIO is not set
>> # CONFIG_CHARGER_MANAGER is not set
>> CONFIG_CHARGER_SMB347=m
>> # CONFIG_POWER_AVS is not set
>> CONFIG_HWMON=y
>> CONFIG_HWMON_VID=m
>> # CONFIG_HWMON_DEBUG_CHIP is not set
>>
>> #
>> # Native drivers
>> #
>> # CONFIG_SENSORS_ABITUGURU is not set
>> # CONFIG_SENSORS_ABITUGURU3 is not set
>> # CONFIG_SENSORS_AD7314 is not set
>> CONFIG_SENSORS_AD7414=m
>> CONFIG_SENSORS_AD7418=m
>> CONFIG_SENSORS_ADCXX=m
>> CONFIG_SENSORS_ADM1021=m
>> CONFIG_SENSORS_ADM1025=m
>> CONFIG_SENSORS_ADM1026=m
>> CONFIG_SENSORS_ADM1029=m
>> CONFIG_SENSORS_ADM1031=m
>> CONFIG_SENSORS_ADM9240=m
>> CONFIG_SENSORS_ADT7410=m
>> CONFIG_SENSORS_ADT7411=m
>> CONFIG_SENSORS_ADT7462=m
>> CONFIG_SENSORS_ADT7470=m
>> CONFIG_SENSORS_ADT7475=m
>> CONFIG_SENSORS_ASC7621=m
>> CONFIG_SENSORS_K8TEMP=m
>> CONFIG_SENSORS_K10TEMP=m
>> CONFIG_SENSORS_FAM15H_POWER=m
>> CONFIG_SENSORS_ASB100=m
>> CONFIG_SENSORS_ATXP1=m
>> CONFIG_SENSORS_DS620=m
>> CONFIG_SENSORS_DS1621=m
>> CONFIG_SENSORS_I5K_AMB=m
>> CONFIG_SENSORS_F71805F=m
>> CONFIG_SENSORS_F71882FG=m
>> CONFIG_SENSORS_F75375S=m
>> CONFIG_SENSORS_FSCHMD=m
>> CONFIG_SENSORS_G760A=m
>> CONFIG_SENSORS_GL518SM=m
>> CONFIG_SENSORS_GL520SM=m
>> # CONFIG_SENSORS_GPIO_FAN is not set
>> CONFIG_SENSORS_HIH6130=m
>> CONFIG_SENSORS_CORETEMP=m
>> CONFIG_SENSORS_IBMAEM=m
>> CONFIG_SENSORS_IBMPEX=m
>> CONFIG_SENSORS_IT87=m
>> # CONFIG_SENSORS_JC42 is not set
>> CONFIG_SENSORS_LINEAGE=m
>> CONFIG_SENSORS_LM63=m
>> CONFIG_SENSORS_LM70=m
>> CONFIG_SENSORS_LM73=m
>> CONFIG_SENSORS_LM75=m
>> CONFIG_SENSORS_LM77=m
>> CONFIG_SENSORS_LM78=m
>> CONFIG_SENSORS_LM80=m
>> CONFIG_SENSORS_LM83=m
>> CONFIG_SENSORS_LM85=m
>> CONFIG_SENSORS_LM87=m
>> CONFIG_SENSORS_LM90=m
>> CONFIG_SENSORS_LM92=m
>> CONFIG_SENSORS_LM93=m
>> CONFIG_SENSORS_LTC4151=m
>> CONFIG_SENSORS_LTC4215=m
>> CONFIG_SENSORS_LTC4245=m
>> CONFIG_SENSORS_LTC4261=m
>> CONFIG_SENSORS_LM95241=m
>> CONFIG_SENSORS_LM95245=m
>> CONFIG_SENSORS_MAX1111=m
>> CONFIG_SENSORS_MAX16065=m
>> CONFIG_SENSORS_MAX1619=m
>> CONFIG_SENSORS_MAX1668=m
>> CONFIG_SENSORS_MAX197=m
>> CONFIG_SENSORS_MAX6639=m
>> CONFIG_SENSORS_MAX6642=m
>> CONFIG_SENSORS_MAX6650=m
>> # CONFIG_SENSORS_MCP3021 is not set
>> CONFIG_SENSORS_NTC_THERMISTOR=m
>> CONFIG_SENSORS_PC87360=m
>> CONFIG_SENSORS_PC87427=m
>> CONFIG_SENSORS_PCF8591=m
>> # CONFIG_PMBUS is not set
>> # CONFIG_SENSORS_SHT15 is not set
>> CONFIG_SENSORS_SHT21=m
>> CONFIG_SENSORS_SIS5595=m
>> CONFIG_SENSORS_SMM665=m
>> CONFIG_SENSORS_DME1737=m
>> CONFIG_SENSORS_EMC1403=m
>> CONFIG_SENSORS_EMC2103=m
>> CONFIG_SENSORS_EMC6W201=m
>> CONFIG_SENSORS_SMSC47M1=m
>> CONFIG_SENSORS_SMSC47M192=m
>> CONFIG_SENSORS_SMSC47B397=m
>> CONFIG_SENSORS_SCH56XX_COMMON=m
>> CONFIG_SENSORS_SCH5627=m
>> CONFIG_SENSORS_SCH5636=m
>> CONFIG_SENSORS_ADS1015=m
>> CONFIG_SENSORS_ADS7828=m
>> CONFIG_SENSORS_ADS7871=m
>> CONFIG_SENSORS_AMC6821=m
>> # CONFIG_SENSORS_INA2XX is not set
>> CONFIG_SENSORS_THMC50=m
>> CONFIG_SENSORS_TMP102=m
>> CONFIG_SENSORS_TMP401=m
>> CONFIG_SENSORS_TMP421=m
>> CONFIG_SENSORS_VIA_CPUTEMP=m
>> CONFIG_SENSORS_VIA686A=m
>> CONFIG_SENSORS_VT1211=m
>> CONFIG_SENSORS_VT8231=m
>> CONFIG_SENSORS_W83781D=m
>> CONFIG_SENSORS_W83791D=m
>> CONFIG_SENSORS_W83792D=m
>> CONFIG_SENSORS_W83793=m
>> CONFIG_SENSORS_W83795=m
>> # CONFIG_SENSORS_W83795_FANCTRL is not set
>> CONFIG_SENSORS_W83L785TS=m
>> CONFIG_SENSORS_W83L786NG=m
>> CONFIG_SENSORS_W83627HF=m
>> CONFIG_SENSORS_W83627EHF=m
>> CONFIG_SENSORS_APPLESMC=m
>>
>> #
>> # ACPI drivers
>> #
>> CONFIG_SENSORS_ACPI_POWER=m
>> CONFIG_SENSORS_ATK0110=m
>> CONFIG_THERMAL=m
>> CONFIG_THERMAL_HWMON=y
>> # CONFIG_CPU_THERMAL is not set
>> CONFIG_WATCHDOG=y
>> CONFIG_WATCHDOG_CORE=y
>> # CONFIG_WATCHDOG_NOWAYOUT is not set
>>
>> #
>> # Watchdog Device Drivers
>> #
>> CONFIG_SOFT_WATCHDOG=m
>> CONFIG_ACQUIRE_WDT=m
>> CONFIG_ADVANTECH_WDT=m
>> CONFIG_ALIM1535_WDT=m
>> CONFIG_ALIM7101_WDT=m
>> CONFIG_F71808E_WDT=m
>> CONFIG_SP5100_TCO=m
>> CONFIG_SC520_WDT=m
>> CONFIG_SBC_FITPC2_WATCHDOG=m
>> CONFIG_EUROTECH_WDT=m
>> CONFIG_IB700_WDT=m
>> CONFIG_IBMASR=m
>> CONFIG_WAFER_WDT=m
>> CONFIG_I6300ESB_WDT=m
>> # CONFIG_IE6XX_WDT is not set
>> CONFIG_ITCO_WDT=m
>> CONFIG_ITCO_VENDOR_SUPPORT=y
>> CONFIG_IT8712F_WDT=m
>> CONFIG_IT87_WDT=m
>> CONFIG_HP_WATCHDOG=m
>> CONFIG_HPWDT_NMI_DECODING=y
>> CONFIG_SC1200_WDT=m
>> CONFIG_PC87413_WDT=m
>> CONFIG_NV_TCO=m
>> CONFIG_60XX_WDT=m
>> CONFIG_SBC8360_WDT=m
>> CONFIG_CPU5_WDT=m
>> CONFIG_SMSC_SCH311X_WDT=m
>> CONFIG_SMSC37B787_WDT=m
>> # CONFIG_VIA_WDT is not set
>> CONFIG_W83627HF_WDT=m
>> CONFIG_W83697HF_WDT=m
>> CONFIG_W83697UG_WDT=m
>> CONFIG_W83877F_WDT=m
>> CONFIG_W83977F_WDT=m
>> CONFIG_MACHZ_WDT=m
>> CONFIG_SBC_EPX_C3_WATCHDOG=m
>>
>> #
>> # PCI-based Watchdog Cards
>> #
>> CONFIG_PCIPCWATCHDOG=m
>> CONFIG_WDTPCI=m
>>
>> #
>> # USB-based Watchdog Cards
>> #
>> CONFIG_USBPCWATCHDOG=m
>> CONFIG_SSB_POSSIBLE=y
>>
>> #
>> # Sonics Silicon Backplane
>> #
>> CONFIG_SSB=m
>> CONFIG_SSB_SPROM=y
>> CONFIG_SSB_BLOCKIO=y
>> CONFIG_SSB_PCIHOST_POSSIBLE=y
>> CONFIG_SSB_PCIHOST=y
>> CONFIG_SSB_B43_PCI_BRIDGE=y
>> CONFIG_SSB_SDIOHOST_POSSIBLE=y
>> CONFIG_SSB_SDIOHOST=y
>> # CONFIG_SSB_DEBUG is not set
>> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
>> CONFIG_SSB_DRIVER_PCICORE=y
>> CONFIG_BCMA_POSSIBLE=y
>>
>> #
>> # Broadcom specific AMBA
>> #
>> CONFIG_BCMA=m
>> CONFIG_BCMA_BLOCKIO=y
>> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
>> CONFIG_BCMA_HOST_PCI=y
>> CONFIG_BCMA_DRIVER_GMAC_CMN=y
>> # CONFIG_BCMA_DEBUG is not set
>>
>> #
>> # Multifunction device drivers
>> #
>> CONFIG_MFD_CORE=m
>> # CONFIG_MFD_88PM860X is not set
>> # CONFIG_MFD_88PM800 is not set
>> # CONFIG_MFD_88PM805 is not set
>> CONFIG_MFD_SM501=m
>> # CONFIG_MFD_SM501_GPIO is not set
>> CONFIG_HTC_PASIC3=m
>> # CONFIG_HTC_I2CPLD is not set
>> # CONFIG_UCB1400_CORE is not set
>> # CONFIG_MFD_LM3533 is not set
>> # CONFIG_TPS6105X is not set
>> CONFIG_TPS65010=m
>> # CONFIG_TPS6507X is not set
>> # CONFIG_MFD_TPS65217 is not set
>> # CONFIG_MFD_TPS6586X is not set
>> # CONFIG_MFD_TPS65910 is not set
>> # CONFIG_MFD_TPS65912_I2C is not set
>> # CONFIG_MFD_TPS65912_SPI is not set
>> # CONFIG_TWL4030_CORE is not set
>> # CONFIG_TWL6040_CORE is not set
>> # CONFIG_MFD_STMPE is not set
>> # CONFIG_MFD_TC3589X is not set
>> # CONFIG_MFD_TMIO is not set
>> # CONFIG_MFD_SMSC is not set
>> # CONFIG_PMIC_DA903X is not set
>> # CONFIG_MFD_DA9052_SPI is not set
>> # CONFIG_MFD_DA9052_I2C is not set
>> # CONFIG_MFD_DA9055 is not set
>> # CONFIG_PMIC_ADP5520 is not set
>> # CONFIG_MFD_LP8788 is not set
>> # CONFIG_MFD_MAX77686 is not set
>> # CONFIG_MFD_MAX77693 is not set
>> # CONFIG_MFD_MAX8907 is not set
>> # CONFIG_MFD_MAX8925 is not set
>> # CONFIG_MFD_MAX8997 is not set
>> # CONFIG_MFD_MAX8998 is not set
>> # CONFIG_MFD_SEC_CORE is not set
>> # CONFIG_MFD_ARIZONA_I2C is not set
>> # CONFIG_MFD_ARIZONA_SPI is not set
>> # CONFIG_MFD_WM8400 is not set
>> # CONFIG_MFD_WM831X_I2C is not set
>> # CONFIG_MFD_WM831X_SPI is not set
>> # CONFIG_MFD_WM8350_I2C is not set
>> # CONFIG_MFD_WM8994 is not set
>> CONFIG_MFD_PCF50633=m
>> CONFIG_PCF50633_ADC=m
>> CONFIG_PCF50633_GPIO=m
>> # CONFIG_MFD_MC13XXX_SPI is not set
>> # CONFIG_MFD_MC13XXX_I2C is not set
>> # CONFIG_ABX500_CORE is not set
>> # CONFIG_EZX_PCAP is not set
>> # CONFIG_MFD_CS5535 is not set
>> # CONFIG_MFD_TIMBERDALE is not set
>> CONFIG_LPC_SCH=m
>> CONFIG_LPC_ICH=m
>> # CONFIG_MFD_RDC321X is not set
>> # CONFIG_MFD_JANZ_CMODIO is not set
>> # CONFIG_MFD_VX855 is not set
>> CONFIG_MFD_WL1273_CORE=m
>> # CONFIG_MFD_TPS65090 is not set
>> # CONFIG_MFD_AAT2870_CORE is not set
>> # CONFIG_MFD_RC5T583 is not set
>> # CONFIG_MFD_PALMAS is not set
>> CONFIG_REGULATOR=y
>> # CONFIG_REGULATOR_DEBUG is not set
>> # CONFIG_REGULATOR_DUMMY is not set
>> CONFIG_REGULATOR_FIXED_VOLTAGE=m
>> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
>> CONFIG_REGULATOR_USERSPACE_CONSUMER=m
>> # CONFIG_REGULATOR_GPIO is not set
>> # CONFIG_REGULATOR_AD5398 is not set
>> CONFIG_REGULATOR_FAN53555=m
>> # CONFIG_REGULATOR_ISL6271A is not set
>> CONFIG_REGULATOR_MAX1586=m
>> CONFIG_REGULATOR_MAX8649=m
>> CONFIG_REGULATOR_MAX8660=m
>> # CONFIG_REGULATOR_MAX8952 is not set
>> CONFIG_REGULATOR_LP3971=m
>> # CONFIG_REGULATOR_LP3972 is not set
>> # CONFIG_REGULATOR_LP872X is not set
>> CONFIG_REGULATOR_PCF50633=m
>> # CONFIG_REGULATOR_TPS62360 is not set
>> CONFIG_REGULATOR_TPS65023=m
>> CONFIG_REGULATOR_TPS6507X=m
>> # CONFIG_REGULATOR_TPS6524X is not set
>> CONFIG_MEDIA_SUPPORT=m
>>
>> #
>> # Multimedia core support
>> #
>> CONFIG_MEDIA_CAMERA_SUPPORT=y
>> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
>> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
>> CONFIG_MEDIA_RADIO_SUPPORT=y
>> CONFIG_MEDIA_RC_SUPPORT=y
>> CONFIG_MEDIA_CONTROLLER=y
>> CONFIG_VIDEO_DEV=m
>> # CONFIG_VIDEO_V4L2_SUBDEV_API is not set
>> CONFIG_VIDEO_V4L2=m
>> # CONFIG_VIDEO_ADV_DEBUG is not set
>> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
>> CONFIG_VIDEO_TUNER=m
>> CONFIG_V4L2_MEM2MEM_DEV=m
>> CONFIG_VIDEOBUF_GEN=m
>> CONFIG_VIDEOBUF_DMA_SG=m
>> CONFIG_VIDEOBUF_VMALLOC=m
>> CONFIG_VIDEOBUF_DVB=m
>> CONFIG_VIDEOBUF2_CORE=m
>> CONFIG_VIDEOBUF2_MEMOPS=m
>> CONFIG_VIDEOBUF2_DMA_CONTIG=m
>> CONFIG_VIDEOBUF2_VMALLOC=m
>> CONFIG_DVB_CORE=m
>> CONFIG_DVB_NET=y
>> CONFIG_DVB_MAX_ADAPTERS=8
>> CONFIG_DVB_DYNAMIC_MINORS=y
>>
>> #
>> # Media drivers
>> #
>> CONFIG_RC_CORE=m
>> CONFIG_RC_MAP=m
>> CONFIG_RC_DECODERS=y
>> CONFIG_LIRC=m
>> CONFIG_IR_LIRC_CODEC=m
>> CONFIG_IR_NEC_DECODER=m
>> CONFIG_IR_RC5_DECODER=m
>> CONFIG_IR_RC6_DECODER=m
>> CONFIG_IR_JVC_DECODER=m
>> CONFIG_IR_SONY_DECODER=m
>> CONFIG_IR_RC5_SZ_DECODER=m
>> CONFIG_IR_SANYO_DECODER=m
>> CONFIG_IR_MCE_KBD_DECODER=m
>> CONFIG_RC_DEVICES=y
>> CONFIG_RC_ATI_REMOTE=m
>> CONFIG_IR_ENE=m
>> CONFIG_IR_IMON=m
>> CONFIG_IR_MCEUSB=m
>> CONFIG_IR_ITE_CIR=m
>> CONFIG_IR_FINTEK=m
>> CONFIG_IR_NUVOTON=m
>> CONFIG_IR_REDRAT3=m
>> CONFIG_IR_STREAMZAP=m
>> CONFIG_IR_WINBOND_CIR=m
>> CONFIG_IR_IGUANA=m
>> CONFIG_IR_TTUSBIR=m
>> CONFIG_RC_LOOPBACK=m
>> CONFIG_IR_GPIO_CIR=m
>> CONFIG_MEDIA_USB_SUPPORT=y
>>
>> #
>> # Webcam devices
>> #
>> CONFIG_USB_VIDEO_CLASS=m
>> CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
>> CONFIG_USB_GSPCA=m
>> CONFIG_USB_M5602=m
>> CONFIG_USB_STV06XX=m
>> CONFIG_USB_GL860=m
>> CONFIG_USB_GSPCA_BENQ=m
>> CONFIG_USB_GSPCA_CONEX=m
>> CONFIG_USB_GSPCA_CPIA1=m
>> CONFIG_USB_GSPCA_ETOMS=m
>> CONFIG_USB_GSPCA_FINEPIX=m
>> CONFIG_USB_GSPCA_JEILINJ=m
>> CONFIG_USB_GSPCA_JL2005BCD=m
>> CONFIG_USB_GSPCA_KINECT=m
>> CONFIG_USB_GSPCA_KONICA=m
>> CONFIG_USB_GSPCA_MARS=m
>> CONFIG_USB_GSPCA_MR97310A=m
>> CONFIG_USB_GSPCA_NW80X=m
>> CONFIG_USB_GSPCA_OV519=m
>> CONFIG_USB_GSPCA_OV534=m
>> CONFIG_USB_GSPCA_OV534_9=m
>> CONFIG_USB_GSPCA_PAC207=m
>> CONFIG_USB_GSPCA_PAC7302=m
>> CONFIG_USB_GSPCA_PAC7311=m
>> CONFIG_USB_GSPCA_SE401=m
>> CONFIG_USB_GSPCA_SN9C2028=m
>> CONFIG_USB_GSPCA_SN9C20X=m
>> CONFIG_USB_GSPCA_SONIXB=m
>> CONFIG_USB_GSPCA_SONIXJ=m
>> CONFIG_USB_GSPCA_SPCA500=m
>> CONFIG_USB_GSPCA_SPCA501=m
>> CONFIG_USB_GSPCA_SPCA505=m
>> CONFIG_USB_GSPCA_SPCA506=m
>> CONFIG_USB_GSPCA_SPCA508=m
>> CONFIG_USB_GSPCA_SPCA561=m
>> CONFIG_USB_GSPCA_SPCA1528=m
>> CONFIG_USB_GSPCA_SQ905=m
>> CONFIG_USB_GSPCA_SQ905C=m
>> CONFIG_USB_GSPCA_SQ930X=m
>> CONFIG_USB_GSPCA_STK014=m
>> CONFIG_USB_GSPCA_STV0680=m
>> CONFIG_USB_GSPCA_SUNPLUS=m
>> CONFIG_USB_GSPCA_T613=m
>> CONFIG_USB_GSPCA_TOPRO=m
>> CONFIG_USB_GSPCA_TV8532=m
>> CONFIG_USB_GSPCA_VC032X=m
>> CONFIG_USB_GSPCA_VICAM=m
>> CONFIG_USB_GSPCA_XIRLINK_CIT=m
>> CONFIG_USB_GSPCA_ZC3XX=m
>> CONFIG_USB_PWC=m
>> # CONFIG_USB_PWC_DEBUG is not set
>> CONFIG_USB_PWC_INPUT_EVDEV=y
>> CONFIG_VIDEO_CPIA2=m
>> CONFIG_USB_ZR364XX=m
>> CONFIG_USB_STKWEBCAM=m
>> CONFIG_USB_S2255=m
>> CONFIG_USB_SN9C102=m
>>
>> #
>> # Analog TV USB devices
>> #
>> CONFIG_VIDEO_AU0828=m
>> CONFIG_VIDEO_PVRUSB2=m
>> CONFIG_VIDEO_PVRUSB2_SYSFS=y
>> CONFIG_VIDEO_PVRUSB2_DVB=y
>> # CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
>> CONFIG_VIDEO_HDPVR=m
>> CONFIG_VIDEO_TLG2300=m
>> CONFIG_VIDEO_USBVISION=m
>> CONFIG_VIDEO_STK1160=m
>> CONFIG_VIDEO_STK1160_AC97=y
>>
>> #
>> # Analog/digital TV USB devices
>> #
>> CONFIG_VIDEO_CX231XX=m
>> CONFIG_VIDEO_CX231XX_RC=y
>> CONFIG_VIDEO_CX231XX_ALSA=m
>> CONFIG_VIDEO_CX231XX_DVB=m
>> CONFIG_VIDEO_TM6000=m
>> CONFIG_VIDEO_TM6000_ALSA=m
>> CONFIG_VIDEO_TM6000_DVB=m
>>
>> #
>> # Digital TV USB devices
>> #
>> CONFIG_DVB_USB=m
>> # CONFIG_DVB_USB_DEBUG is not set
>> CONFIG_DVB_USB_A800=m
>> CONFIG_DVB_USB_DIBUSB_MB=m
>> CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
>> CONFIG_DVB_USB_DIBUSB_MC=m
>> CONFIG_DVB_USB_DIB0700=m
>> CONFIG_DVB_USB_UMT_010=m
>> CONFIG_DVB_USB_CXUSB=m
>> CONFIG_DVB_USB_M920X=m
>> CONFIG_DVB_USB_DIGITV=m
>> CONFIG_DVB_USB_VP7045=m
>> CONFIG_DVB_USB_VP702X=m
>> CONFIG_DVB_USB_GP8PSK=m
>> CONFIG_DVB_USB_NOVA_T_USB2=m
>> CONFIG_DVB_USB_TTUSB2=m
>> CONFIG_DVB_USB_DTT200U=m
>> CONFIG_DVB_USB_OPERA1=m
>> CONFIG_DVB_USB_AF9005=m
>> CONFIG_DVB_USB_AF9005_REMOTE=m
>> CONFIG_DVB_USB_PCTV452E=m
>> CONFIG_DVB_USB_DW2102=m
>> CONFIG_DVB_USB_CINERGY_T2=m
>> CONFIG_DVB_USB_DTV5100=m
>> CONFIG_DVB_USB_FRIIO=m
>> CONFIG_DVB_USB_AZ6027=m
>> CONFIG_DVB_USB_TECHNISAT_USB2=m
>> CONFIG_DVB_USB_V2=m
>> CONFIG_DVB_USB_CYPRESS_FIRMWARE=m
>> CONFIG_DVB_USB_AF9015=m
>> CONFIG_DVB_USB_AF9035=m
>> CONFIG_DVB_USB_ANYSEE=m
>> CONFIG_DVB_USB_AU6610=m
>> CONFIG_DVB_USB_AZ6007=m
>> CONFIG_DVB_USB_CE6230=m
>> CONFIG_DVB_USB_EC168=m
>> CONFIG_DVB_USB_GL861=m
>> CONFIG_DVB_USB_IT913X=m
>> CONFIG_DVB_USB_LME2510=m
>> CONFIG_DVB_USB_MXL111SF=m
>> CONFIG_DVB_USB_RTL28XXU=m
>> CONFIG_DVB_TTUSB_BUDGET=m
>> CONFIG_DVB_TTUSB_DEC=m
>> CONFIG_SMS_USB_DRV=m
>> CONFIG_DVB_B2C2_FLEXCOP_USB=m
>> # CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
>>
>> #
>> # Webcam, TV (analog/digital) USB devices
>> #
>> CONFIG_VIDEO_EM28XX=m
>> CONFIG_VIDEO_EM28XX_ALSA=m
>> CONFIG_VIDEO_EM28XX_DVB=m
>> CONFIG_VIDEO_EM28XX_RC=m
>> CONFIG_MEDIA_PCI_SUPPORT=y
>>
>> #
>> # Media capture support
>> #
>>
>> #
>> # Media capture/analog TV support
>> #
>> CONFIG_VIDEO_IVTV=m
>> # CONFIG_VIDEO_IVTV_ALSA is not set
>> CONFIG_VIDEO_FB_IVTV=m
>> CONFIG_VIDEO_ZORAN=m
>> CONFIG_VIDEO_ZORAN_DC30=m
>> CONFIG_VIDEO_ZORAN_ZR36060=m
>> CONFIG_VIDEO_ZORAN_BUZ=m
>> CONFIG_VIDEO_ZORAN_DC10=m
>> CONFIG_VIDEO_ZORAN_LML33=m
>> CONFIG_VIDEO_ZORAN_LML33R10=m
>> CONFIG_VIDEO_ZORAN_AVS6EYES=m
>> CONFIG_VIDEO_HEXIUM_GEMINI=m
>> CONFIG_VIDEO_HEXIUM_ORION=m
>> CONFIG_VIDEO_MXB=m
>>
>> #
>> # Media capture/analog/hybrid TV support
>> #
>> CONFIG_VIDEO_CX18=m
>> CONFIG_VIDEO_CX18_ALSA=m
>> CONFIG_VIDEO_CX23885=m
>> # CONFIG_MEDIA_ALTERA_CI is not set
>> # CONFIG_VIDEO_CX25821 is not set
>> CONFIG_VIDEO_CX88=m
>> CONFIG_VIDEO_CX88_ALSA=m
>> CONFIG_VIDEO_CX88_BLACKBIRD=m
>> CONFIG_VIDEO_CX88_DVB=m
>> CONFIG_VIDEO_CX88_VP3054=m
>> CONFIG_VIDEO_CX88_MPEG=m
>> CONFIG_VIDEO_BT848=m
>> CONFIG_DVB_BT8XX=m
>> CONFIG_VIDEO_SAA7134=m
>> CONFIG_VIDEO_SAA7134_ALSA=m
>> CONFIG_VIDEO_SAA7134_RC=y
>> CONFIG_VIDEO_SAA7134_DVB=m
>> CONFIG_VIDEO_SAA7164=m
>>
>> #
>> # Media digital TV PCI Adapters
>> #
>> CONFIG_TTPCI_EEPROM=m
>> CONFIG_DVB_AV7110=m
>> CONFIG_DVB_AV7110_OSD=y
>> CONFIG_DVB_BUDGET_CORE=m
>> CONFIG_DVB_BUDGET=m
>> CONFIG_DVB_BUDGET_CI=m
>> CONFIG_DVB_BUDGET_AV=m
>> CONFIG_DVB_BUDGET_PATCH=m
>> CONFIG_DVB_B2C2_FLEXCOP_PCI=m
>> # CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
>> CONFIG_DVB_PLUTO2=m
>> CONFIG_DVB_DM1105=m
>> CONFIG_DVB_PT1=m
>> CONFIG_MANTIS_CORE=m
>> CONFIG_DVB_MANTIS=m
>> CONFIG_DVB_HOPPER=m
>> CONFIG_DVB_NGENE=m
>> CONFIG_DVB_DDBRIDGE=m
>> CONFIG_V4L_PLATFORM_DRIVERS=y
>> CONFIG_VIDEO_CAFE_CCIC=m
>> CONFIG_VIDEO_VIA_CAMERA=m
>> # CONFIG_VIDEO_TIMBERDALE is not set
>> CONFIG_SOC_CAMERA=m
>> CONFIG_SOC_CAMERA_PLATFORM=m
>> CONFIG_V4L_MEM2MEM_DRIVERS=y
>> CONFIG_VIDEO_MEM2MEM_DEINTERLACE=m
>> # CONFIG_V4L_TEST_DRIVERS is not set
>>
>> #
>> # Supported MMC/SDIO adapters
>> #
>> CONFIG_SMS_SDIO_DRV=m
>> CONFIG_RADIO_ADAPTERS=y
>> CONFIG_RADIO_SI470X=y
>> CONFIG_USB_SI470X=m
>> CONFIG_I2C_SI470X=m
>> CONFIG_USB_MR800=m
>> CONFIG_USB_DSBR=m
>> CONFIG_RADIO_MAXIRADIO=m
>> CONFIG_RADIO_SHARK=m
>> CONFIG_RADIO_SHARK2=m
>> CONFIG_I2C_SI4713=m
>> CONFIG_RADIO_SI4713=m
>> CONFIG_USB_KEENE=m
>> CONFIG_RADIO_TEA5764=m
>> CONFIG_RADIO_SAA7706H=m
>> CONFIG_RADIO_TEF6862=m
>> CONFIG_RADIO_WL1273=m
>>
>> #
>> # Texas Instruments WL128x FM driver (ST based)
>> #
>> # CONFIG_RADIO_WL128X is not set
>>
>> #
>> # Supported FireWire (IEEE 1394) Adapters
>> #
>> CONFIG_DVB_FIREDTV=m
>> CONFIG_DVB_FIREDTV_INPUT=y
>> CONFIG_DVB_B2C2_FLEXCOP=m
>> CONFIG_VIDEO_SAA7146=m
>> CONFIG_VIDEO_SAA7146_VV=m
>> CONFIG_SMS_SIANO_MDTV=m
>> CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
>>
>> #
>> # Media ancillary drivers (tuners, sensors, i2c, frontends)
>> #
>> CONFIG_VIDEO_BTCX=m
>> CONFIG_VIDEO_TVEEPROM=m
>> CONFIG_VIDEO_IR_I2C=m
>>
>> #
>> # Audio decoders, processors and mixers
>> #
>> CONFIG_VIDEO_TVAUDIO=m
>> CONFIG_VIDEO_TDA7432=m
>> CONFIG_VIDEO_TDA9840=m
>> CONFIG_VIDEO_TEA6415C=m
>> CONFIG_VIDEO_TEA6420=m
>> CONFIG_VIDEO_MSP3400=m
>> CONFIG_VIDEO_CS5345=m
>> CONFIG_VIDEO_CS53L32A=m
>> CONFIG_VIDEO_WM8775=m
>> CONFIG_VIDEO_WM8739=m
>> CONFIG_VIDEO_VP27SMPX=m
>>
>> #
>> # RDS decoders
>> #
>> CONFIG_VIDEO_SAA6588=m
>>
>> #
>> # Video decoders
>> #
>> CONFIG_VIDEO_BT819=m
>> CONFIG_VIDEO_BT856=m
>> CONFIG_VIDEO_BT866=m
>> CONFIG_VIDEO_KS0127=m
>> CONFIG_VIDEO_SAA7110=m
>> CONFIG_VIDEO_SAA711X=m
>> CONFIG_VIDEO_TVP5150=m
>> CONFIG_VIDEO_VPX3220=m
>>
>> #
>> # Video and audio decoders
>> #
>> CONFIG_VIDEO_SAA717X=m
>> CONFIG_VIDEO_CX25840=m
>>
>> #
>> # MPEG video encoders
>> #
>> CONFIG_VIDEO_CX2341X=m
>>
>> #
>> # Video encoders
>> #
>> CONFIG_VIDEO_SAA7127=m
>> CONFIG_VIDEO_SAA7185=m
>> CONFIG_VIDEO_ADV7170=m
>> CONFIG_VIDEO_ADV7175=m
>>
>> #
>> # Camera sensor devices
>> #
>> CONFIG_VIDEO_OV7670=m
>> CONFIG_VIDEO_MT9V011=m
>>
>> #
>> # Flash devices
>> #
>>
>> #
>> # Video improvement chips
>> #
>> CONFIG_VIDEO_UPD64031A=m
>> CONFIG_VIDEO_UPD64083=m
>>
>> #
>> # Miscelaneous helper chips
>> #
>> CONFIG_VIDEO_M52790=m
>>
>> #
>> # Sensors used on soc_camera driver
>> #
>>
>> #
>> # soc_camera sensor drivers
>> #
>> CONFIG_SOC_CAMERA_IMX074=m
>> CONFIG_SOC_CAMERA_MT9M001=m
>> CONFIG_SOC_CAMERA_MT9M111=m
>> CONFIG_SOC_CAMERA_MT9T031=m
>> CONFIG_SOC_CAMERA_MT9T112=m
>> CONFIG_SOC_CAMERA_MT9V022=m
>> CONFIG_SOC_CAMERA_OV2640=m
>> # CONFIG_SOC_CAMERA_OV5642 is not set
>> CONFIG_SOC_CAMERA_OV6650=m
>> CONFIG_SOC_CAMERA_OV772X=m
>> CONFIG_SOC_CAMERA_OV9640=m
>> CONFIG_SOC_CAMERA_OV9740=m
>> CONFIG_SOC_CAMERA_RJ54N1=m
>> CONFIG_SOC_CAMERA_TW9910=m
>> CONFIG_MEDIA_ATTACH=y
>> CONFIG_MEDIA_TUNER=m
>> CONFIG_MEDIA_TUNER_SIMPLE=m
>> CONFIG_MEDIA_TUNER_TDA8290=m
>> CONFIG_MEDIA_TUNER_TDA827X=m
>> CONFIG_MEDIA_TUNER_TDA18271=m
>> CONFIG_MEDIA_TUNER_TDA9887=m
>> CONFIG_MEDIA_TUNER_TEA5761=m
>> CONFIG_MEDIA_TUNER_TEA5767=m
>> CONFIG_MEDIA_TUNER_MT20XX=m
>> CONFIG_MEDIA_TUNER_MT2060=m
>> CONFIG_MEDIA_TUNER_MT2063=m
>> CONFIG_MEDIA_TUNER_MT2266=m
>> CONFIG_MEDIA_TUNER_MT2131=m
>> CONFIG_MEDIA_TUNER_QT1010=m
>> CONFIG_MEDIA_TUNER_XC2028=m
>> CONFIG_MEDIA_TUNER_XC5000=m
>> CONFIG_MEDIA_TUNER_XC4000=m
>> CONFIG_MEDIA_TUNER_MXL5005S=m
>> CONFIG_MEDIA_TUNER_MXL5007T=m
>> CONFIG_MEDIA_TUNER_MC44S803=m
>> CONFIG_MEDIA_TUNER_MAX2165=m
>> CONFIG_MEDIA_TUNER_TDA18218=m
>> CONFIG_MEDIA_TUNER_FC0011=m
>> CONFIG_MEDIA_TUNER_FC0012=m
>> CONFIG_MEDIA_TUNER_FC0013=m
>> CONFIG_MEDIA_TUNER_TDA18212=m
>> CONFIG_MEDIA_TUNER_E4000=m
>> CONFIG_MEDIA_TUNER_FC2580=m
>> CONFIG_MEDIA_TUNER_TUA9001=m
>>
>> #
>> # Multistandard (satellite) frontends
>> #
>> CONFIG_DVB_STB0899=m
>> CONFIG_DVB_STB6100=m
>> CONFIG_DVB_STV090x=m
>> CONFIG_DVB_STV6110x=m
>>
>> #
>> # Multistandard (cable + terrestrial) frontends
>> #
>> CONFIG_DVB_DRXK=m
>> CONFIG_DVB_TDA18271C2DD=m
>>
>> #
>> # DVB-S (satellite) frontends
>> #
>> CONFIG_DVB_CX24110=m
>> CONFIG_DVB_CX24123=m
>> CONFIG_DVB_MT312=m
>> CONFIG_DVB_ZL10036=m
>> CONFIG_DVB_ZL10039=m
>> CONFIG_DVB_S5H1420=m
>> CONFIG_DVB_STV0288=m
>> CONFIG_DVB_STB6000=m
>> CONFIG_DVB_STV0299=m
>> CONFIG_DVB_STV6110=m
>> CONFIG_DVB_STV0900=m
>> CONFIG_DVB_TDA8083=m
>> CONFIG_DVB_TDA10086=m
>> CONFIG_DVB_TDA8261=m
>> CONFIG_DVB_VES1X93=m
>> CONFIG_DVB_TUNER_ITD1000=m
>> CONFIG_DVB_TUNER_CX24113=m
>> CONFIG_DVB_TDA826X=m
>> CONFIG_DVB_TUA6100=m
>> CONFIG_DVB_CX24116=m
>> CONFIG_DVB_SI21XX=m
>> CONFIG_DVB_DS3000=m
>> CONFIG_DVB_MB86A16=m
>> CONFIG_DVB_TDA10071=m
>>
>> #
>> # DVB-T (terrestrial) frontends
>> #
>> CONFIG_DVB_SP8870=m
>> CONFIG_DVB_SP887X=m
>> CONFIG_DVB_CX22700=m
>> CONFIG_DVB_CX22702=m
>> CONFIG_DVB_DRXD=m
>> CONFIG_DVB_L64781=m
>> CONFIG_DVB_TDA1004X=m
>> CONFIG_DVB_NXT6000=m
>> CONFIG_DVB_MT352=m
>> CONFIG_DVB_ZL10353=m
>> CONFIG_DVB_DIB3000MB=m
>> CONFIG_DVB_DIB3000MC=m
>> CONFIG_DVB_DIB7000M=m
>> CONFIG_DVB_DIB7000P=m
>> CONFIG_DVB_TDA10048=m
>> CONFIG_DVB_AF9013=m
>> CONFIG_DVB_EC100=m
>> CONFIG_DVB_STV0367=m
>> CONFIG_DVB_CXD2820R=m
>> CONFIG_DVB_RTL2830=m
>> CONFIG_DVB_RTL2832=m
>>
>> #
>> # DVB-C (cable) frontends
>> #
>> CONFIG_DVB_VES1820=m
>> CONFIG_DVB_TDA10021=m
>> CONFIG_DVB_TDA10023=m
>> CONFIG_DVB_STV0297=m
>>
>> #
>> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
>> #
>> CONFIG_DVB_NXT200X=m
>> CONFIG_DVB_OR51211=m
>> CONFIG_DVB_OR51132=m
>> CONFIG_DVB_BCM3510=m
>> CONFIG_DVB_LGDT330X=m
>> CONFIG_DVB_LGDT3305=m
>> CONFIG_DVB_LG2160=m
>> CONFIG_DVB_S5H1409=m
>> CONFIG_DVB_AU8522=m
>> CONFIG_DVB_AU8522_DTV=m
>> CONFIG_DVB_AU8522_V4L=m
>> CONFIG_DVB_S5H1411=m
>>
>> #
>> # ISDB-T (terrestrial) frontends
>> #
>> CONFIG_DVB_S921=m
>> CONFIG_DVB_DIB8000=m
>> CONFIG_DVB_MB86A20S=m
>>
>> #
>> # Digital terrestrial only tuners/PLL
>> #
>> CONFIG_DVB_PLL=m
>> CONFIG_DVB_TUNER_DIB0070=m
>> CONFIG_DVB_TUNER_DIB0090=m
>>
>> #
>> # SEC control devices for DVB-S
>> #
>> CONFIG_DVB_LNBP21=m
>> CONFIG_DVB_LNBP22=m
>> CONFIG_DVB_ISL6405=m
>> CONFIG_DVB_ISL6421=m
>> CONFIG_DVB_ISL6423=m
>> CONFIG_DVB_A8293=m
>> CONFIG_DVB_LGS8GXX=m
>> CONFIG_DVB_ATBM8830=m
>> CONFIG_DVB_TDA665x=m
>> CONFIG_DVB_IX2505V=m
>> CONFIG_DVB_IT913X_FE=m
>> CONFIG_DVB_M88RS2000=m
>> CONFIG_DVB_AF9033=m
>>
>> #
>> # Tools to develop new frontends
>> #
>> # CONFIG_DVB_DUMMY_FE is not set
>>
>> #
>> # Graphics support
>> #
>> CONFIG_AGP=y
>> # CONFIG_AGP_AMD64 is not set
>> CONFIG_AGP_INTEL=y
>> # CONFIG_AGP_SIS is not set
>> # CONFIG_AGP_VIA is not set
>> CONFIG_VGA_ARB=y
>> CONFIG_VGA_ARB_MAX_GPUS=2
>> CONFIG_VGA_SWITCHEROO=y
>> CONFIG_DRM=y
>> CONFIG_DRM_USB=m
>> CONFIG_DRM_KMS_HELPER=m
>> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
>> CONFIG_DRM_TTM=m
>> # CONFIG_DRM_TDFX is not set
>> # CONFIG_DRM_R128 is not set
>> CONFIG_DRM_RADEON=m
>> CONFIG_DRM_RADEON_KMS=y
>> # CONFIG_DRM_NOUVEAU is not set
>>
>> #
>> # I2C encoder or helper chips
>> #
>> CONFIG_DRM_I2C_CH7006=m
>> CONFIG_DRM_I2C_SIL164=m
>> CONFIG_DRM_I915=m
>> CONFIG_DRM_I915_KMS=y
>> # CONFIG_DRM_MGA is not set
>> # CONFIG_DRM_SIS is not set
>> # CONFIG_DRM_VIA is not set
>> # CONFIG_DRM_SAVAGE is not set
>> CONFIG_DRM_VMWGFX=m
>> # CONFIG_DRM_VMWGFX_FBCON is not set
>> # CONFIG_DRM_GMA500 is not set
>> CONFIG_DRM_UDL=m
>> # CONFIG_DRM_AST is not set
>> # CONFIG_DRM_MGAG200 is not set
>> # CONFIG_DRM_CIRRUS_QEMU is not set
>> # CONFIG_STUB_POULSBO is not set
>> CONFIG_VGASTATE=m
>> CONFIG_VIDEO_OUTPUT_CONTROL=m
>> CONFIG_FB=y
>> CONFIG_FIRMWARE_EDID=y
>> CONFIG_FB_DDC=m
>> CONFIG_FB_BOOT_VESA_SUPPORT=y
>> CONFIG_FB_CFB_FILLRECT=y
>> CONFIG_FB_CFB_COPYAREA=y
>> CONFIG_FB_CFB_IMAGEBLIT=y
>> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
>> CONFIG_FB_SYS_FILLRECT=m
>> CONFIG_FB_SYS_COPYAREA=m
>> CONFIG_FB_SYS_IMAGEBLIT=m
>> # CONFIG_FB_FOREIGN_ENDIAN is not set
>> CONFIG_FB_SYS_FOPS=m
>> # CONFIG_FB_WMT_GE_ROPS is not set
>> CONFIG_FB_DEFERRED_IO=y
>> CONFIG_FB_HECUBA=m
>> CONFIG_FB_SVGALIB=m
>> # CONFIG_FB_MACMODES is not set
>> CONFIG_FB_BACKLIGHT=y
>> CONFIG_FB_MODE_HELPERS=y
>> CONFIG_FB_TILEBLITTING=y
>>
>> #
>> # Frame buffer hardware drivers
>> #
>> CONFIG_FB_CIRRUS=m
>> CONFIG_FB_PM2=m
>> CONFIG_FB_PM2_FIFO_DISCONNECT=y
>> CONFIG_FB_CYBER2000=m
>> CONFIG_FB_CYBER2000_DDC=y
>> CONFIG_FB_ARC=m
>> # CONFIG_FB_ASILIANT is not set
>> # CONFIG_FB_IMSTT is not set
>> CONFIG_FB_VGA16=m
>> CONFIG_FB_UVESA=m
>> CONFIG_FB_VESA=y
>> CONFIG_FB_EFI=y
>> CONFIG_FB_N411=m
>> CONFIG_FB_HGA=m
>> CONFIG_FB_S1D13XXX=m
>> # CONFIG_FB_NVIDIA is not set
>> # CONFIG_FB_RIVA is not set
>> # CONFIG_FB_I740 is not set
>> CONFIG_FB_LE80578=m
>> CONFIG_FB_CARILLO_RANCH=m
>> CONFIG_FB_MATROX=m
>> CONFIG_FB_MATROX_MILLENIUM=y
>> CONFIG_FB_MATROX_MYSTIQUE=y
>> CONFIG_FB_MATROX_G=y
>> CONFIG_FB_MATROX_I2C=m
>> CONFIG_FB_MATROX_MAVEN=m
>> CONFIG_FB_RADEON=m
>> CONFIG_FB_RADEON_I2C=y
>> CONFIG_FB_RADEON_BACKLIGHT=y
>> # CONFIG_FB_RADEON_DEBUG is not set
>> CONFIG_FB_ATY128=m
>> CONFIG_FB_ATY128_BACKLIGHT=y
>> CONFIG_FB_ATY=m
>> CONFIG_FB_ATY_CT=y
>> # CONFIG_FB_ATY_GENERIC_LCD is not set
>> CONFIG_FB_ATY_GX=y
>> CONFIG_FB_ATY_BACKLIGHT=y
>> CONFIG_FB_S3=m
>> CONFIG_FB_S3_DDC=y
>> CONFIG_FB_SAVAGE=m
>> # CONFIG_FB_SAVAGE_I2C is not set
>> # CONFIG_FB_SAVAGE_ACCEL is not set
>> CONFIG_FB_SIS=m
>> CONFIG_FB_SIS_300=y
>> CONFIG_FB_SIS_315=y
>> CONFIG_FB_VIA=m
>> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
>> CONFIG_FB_VIA_X_COMPATIBILITY=y
>> CONFIG_FB_NEOMAGIC=m
>> CONFIG_FB_KYRO=m
>> CONFIG_FB_3DFX=m
>> # CONFIG_FB_3DFX_ACCEL is not set
>> CONFIG_FB_3DFX_I2C=y
>> CONFIG_FB_VOODOO1=m
>> CONFIG_FB_VT8623=m
>> CONFIG_FB_TRIDENT=m
>> CONFIG_FB_ARK=m
>> CONFIG_FB_PM3=m
>> # CONFIG_FB_CARMINE is not set
>> # CONFIG_FB_GEODE is not set
>> # CONFIG_FB_TMIO is not set
>> CONFIG_FB_SM501=m
>> # CONFIG_FB_SMSCUFX is not set
>> CONFIG_FB_UDL=m
>> CONFIG_FB_VIRTUAL=m
>> CONFIG_FB_METRONOME=m
>> CONFIG_FB_MB862XX=m
>> CONFIG_FB_MB862XX_PCI_GDC=y
>> CONFIG_FB_MB862XX_I2C=y
>> # CONFIG_FB_BROADSHEET is not set
>> # CONFIG_FB_AUO_K190X is not set
>> # CONFIG_EXYNOS_VIDEO is not set
>> CONFIG_BACKLIGHT_LCD_SUPPORT=y
>> # CONFIG_LCD_CLASS_DEVICE is not set
>> CONFIG_BACKLIGHT_CLASS_DEVICE=y
>> CONFIG_BACKLIGHT_GENERIC=m
>> CONFIG_BACKLIGHT_PWM=m
>> CONFIG_BACKLIGHT_APPLE=m
>> CONFIG_BACKLIGHT_SAHARA=m
>> CONFIG_BACKLIGHT_ADP8860=m
>> CONFIG_BACKLIGHT_ADP8870=m
>> CONFIG_BACKLIGHT_PCF50633=m
>> CONFIG_BACKLIGHT_LM3630=m
>> CONFIG_BACKLIGHT_LM3639=m
>> CONFIG_BACKLIGHT_LP855X=m
>>
>> #
>> # Console display driver support
>> #
>> CONFIG_VGA_CONSOLE=y
>> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
>> CONFIG_DUMMY_CONSOLE=y
>> CONFIG_FRAMEBUFFER_CONSOLE=y
>> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
>> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
>> # CONFIG_FONTS is not set
>> CONFIG_FONT_8x8=y
>> CONFIG_FONT_8x16=y
>> CONFIG_LOGO=y
>> # CONFIG_LOGO_LINUX_MONO is not set
>> # CONFIG_LOGO_LINUX_VGA16 is not set
>> CONFIG_LOGO_LINUX_CLUT224=y
>> CONFIG_SOUND=m
>> CONFIG_SOUND_OSS_CORE=y
>> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
>> CONFIG_SND=m
>> CONFIG_SND_TIMER=m
>> CONFIG_SND_PCM=m
>> CONFIG_SND_HWDEP=m
>> CONFIG_SND_RAWMIDI=m
>> CONFIG_SND_JACK=y
>> CONFIG_SND_SEQUENCER=m
>> CONFIG_SND_SEQ_DUMMY=m
>> CONFIG_SND_OSSEMUL=y
>> CONFIG_SND_MIXER_OSS=m
>> CONFIG_SND_PCM_OSS=m
>> CONFIG_SND_PCM_OSS_PLUGINS=y
>> # CONFIG_SND_SEQUENCER_OSS is not set
>> CONFIG_SND_HRTIMER=m
>> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
>> CONFIG_SND_DYNAMIC_MINORS=y
>> CONFIG_SND_SUPPORT_OLD_API=y
>> CONFIG_SND_VERBOSE_PROCFS=y
>> # CONFIG_SND_VERBOSE_PRINTK is not set
>> # CONFIG_SND_DEBUG is not set
>> CONFIG_SND_VMASTER=y
>> CONFIG_SND_KCTL_JACK=y
>> CONFIG_SND_DMA_SGBUF=y
>> CONFIG_SND_RAWMIDI_SEQ=m
>> CONFIG_SND_OPL3_LIB_SEQ=m
>> # CONFIG_SND_OPL4_LIB_SEQ is not set
>> # CONFIG_SND_SBAWE_SEQ is not set
>> CONFIG_SND_EMU10K1_SEQ=m
>> CONFIG_SND_MPU401_UART=m
>> CONFIG_SND_OPL3_LIB=m
>> CONFIG_SND_VX_LIB=m
>> CONFIG_SND_AC97_CODEC=m
>> CONFIG_SND_DRIVERS=y
>> CONFIG_SND_PCSP=m
>> CONFIG_SND_DUMMY=m
>> CONFIG_SND_ALOOP=m
>> CONFIG_SND_VIRMIDI=m
>> CONFIG_SND_MTPAV=m
>> CONFIG_SND_SERIAL_U16550=m
>> CONFIG_SND_MPU401=m
>> CONFIG_SND_AC97_POWER_SAVE=y
>> CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
>> CONFIG_SND_SB_COMMON=m
>> CONFIG_SND_SB16_DSP=m
>> CONFIG_SND_TEA575X=m
>> CONFIG_SND_PCI=y
>> CONFIG_SND_AD1889=m
>> CONFIG_SND_ALS300=m
>> CONFIG_SND_ALS4000=m
>> CONFIG_SND_ALI5451=m
>> CONFIG_SND_ASIHPI=m
>> CONFIG_SND_ATIIXP=m
>> CONFIG_SND_ATIIXP_MODEM=m
>> CONFIG_SND_AU8810=m
>> CONFIG_SND_AU8820=m
>> CONFIG_SND_AU8830=m
>> # CONFIG_SND_AW2 is not set
>> CONFIG_SND_AZT3328=m
>> CONFIG_SND_BT87X=m
>> # CONFIG_SND_BT87X_OVERCLOCK is not set
>> CONFIG_SND_CA0106=m
>> CONFIG_SND_CMIPCI=m
>> CONFIG_SND_OXYGEN_LIB=m
>> CONFIG_SND_OXYGEN=m
>> CONFIG_SND_CS4281=m
>> CONFIG_SND_CS46XX=m
>> CONFIG_SND_CS46XX_NEW_DSP=y
>> CONFIG_SND_CS5530=m
>> CONFIG_SND_CS5535AUDIO=m
>> CONFIG_SND_CTXFI=m
>> CONFIG_SND_DARLA20=m
>> CONFIG_SND_GINA20=m
>> CONFIG_SND_LAYLA20=m
>> CONFIG_SND_DARLA24=m
>> CONFIG_SND_GINA24=m
>> CONFIG_SND_LAYLA24=m
>> CONFIG_SND_MONA=m
>> CONFIG_SND_MIA=m
>> CONFIG_SND_ECHO3G=m
>> CONFIG_SND_INDIGO=m
>> CONFIG_SND_INDIGOIO=m
>> CONFIG_SND_INDIGODJ=m
>> CONFIG_SND_INDIGOIOX=m
>> CONFIG_SND_INDIGODJX=m
>> CONFIG_SND_EMU10K1=m
>> CONFIG_SND_EMU10K1X=m
>> CONFIG_SND_ENS1370=m
>> CONFIG_SND_ENS1371=m
>> CONFIG_SND_ES1938=m
>> CONFIG_SND_ES1968=m
>> CONFIG_SND_ES1968_INPUT=y
>> CONFIG_SND_ES1968_RADIO=y
>> CONFIG_SND_FM801=m
>> CONFIG_SND_FM801_TEA575X_BOOL=y
>> CONFIG_SND_HDA_INTEL=m
>> CONFIG_SND_HDA_PREALLOC_SIZE=64
>> CONFIG_SND_HDA_HWDEP=y
>> CONFIG_SND_HDA_RECONFIG=y
>> CONFIG_SND_HDA_INPUT_BEEP=y
>> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
>> CONFIG_SND_HDA_INPUT_JACK=y
>> CONFIG_SND_HDA_PATCH_LOADER=y
>> CONFIG_SND_HDA_CODEC_REALTEK=y
>> CONFIG_SND_HDA_CODEC_ANALOG=y
>> CONFIG_SND_HDA_CODEC_SIGMATEL=y
>> CONFIG_SND_HDA_CODEC_VIA=y
>> CONFIG_SND_HDA_CODEC_HDMI=y
>> CONFIG_SND_HDA_CODEC_CIRRUS=y
>> CONFIG_SND_HDA_CODEC_CONEXANT=y
>> CONFIG_SND_HDA_CODEC_CA0110=y
>> CONFIG_SND_HDA_CODEC_CA0132=y
>> CONFIG_SND_HDA_CODEC_CMEDIA=y
>> CONFIG_SND_HDA_CODEC_SI3054=y
>> CONFIG_SND_HDA_GENERIC=y
>> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
>> CONFIG_SND_HDSP=m
>> CONFIG_SND_HDSPM=m
>> CONFIG_SND_ICE1712=m
>> CONFIG_SND_ICE1724=m
>> CONFIG_SND_INTEL8X0=m
>> CONFIG_SND_INTEL8X0M=m
>> CONFIG_SND_KORG1212=m
>> CONFIG_SND_LOLA=m
>> CONFIG_SND_LX6464ES=m
>> CONFIG_SND_MAESTRO3=m
>> CONFIG_SND_MAESTRO3_INPUT=y
>> CONFIG_SND_MIXART=m
>> CONFIG_SND_NM256=m
>> CONFIG_SND_PCXHR=m
>> CONFIG_SND_RIPTIDE=m
>> CONFIG_SND_RME32=m
>> CONFIG_SND_RME96=m
>> CONFIG_SND_RME9652=m
>> CONFIG_SND_SONICVIBES=m
>> CONFIG_SND_TRIDENT=m
>> CONFIG_SND_VIA82XX=m
>> CONFIG_SND_VIA82XX_MODEM=m
>> CONFIG_SND_VIRTUOSO=m
>> CONFIG_SND_VX222=m
>> CONFIG_SND_YMFPCI=m
>> # CONFIG_SND_SPI is not set
>> CONFIG_SND_USB=y
>> CONFIG_SND_USB_AUDIO=m
>> CONFIG_SND_USB_UA101=m
>> CONFIG_SND_USB_USX2Y=m
>> CONFIG_SND_USB_CAIAQ=m
>> CONFIG_SND_USB_CAIAQ_INPUT=y
>> CONFIG_SND_USB_US122L=m
>> CONFIG_SND_USB_6FIRE=m
>> CONFIG_SND_FIREWIRE=y
>> CONFIG_SND_FIREWIRE_LIB=m
>> CONFIG_SND_FIREWIRE_SPEAKERS=m
>> CONFIG_SND_ISIGHT=m
>> # CONFIG_SND_SOC is not set
>> # CONFIG_SOUND_PRIME is not set
>> CONFIG_AC97_BUS=m
>>
>> #
>> # HID support
>> #
>> CONFIG_HID=m
>> CONFIG_HIDRAW=y
>> CONFIG_UHID=m
>> CONFIG_HID_GENERIC=m
>>
>> #
>> # Special HID drivers
>> #
>> CONFIG_HID_A4TECH=m
>> CONFIG_HID_ACRUX=m
>> CONFIG_HID_ACRUX_FF=y
>> CONFIG_HID_APPLE=m
>> CONFIG_HID_AUREAL=m
>> CONFIG_HID_BELKIN=m
>> CONFIG_HID_CHERRY=m
>> CONFIG_HID_CHICONY=m
>> CONFIG_HID_PRODIKEYS=m
>> CONFIG_HID_CYPRESS=m
>> CONFIG_HID_DRAGONRISE=m
>> CONFIG_DRAGONRISE_FF=y
>> CONFIG_HID_EMS_FF=m
>> CONFIG_HID_ELECOM=m
>> CONFIG_HID_EZKEY=m
>> CONFIG_HID_HOLTEK=m
>> # CONFIG_HOLTEK_FF is not set
>> CONFIG_HID_KEYTOUCH=m
>> CONFIG_HID_KYE=m
>> CONFIG_HID_UCLOGIC=m
>> CONFIG_HID_WALTOP=m
>> CONFIG_HID_GYRATION=m
>> CONFIG_HID_TWINHAN=m
>> CONFIG_HID_KENSINGTON=m
>> CONFIG_HID_LCPOWER=m
>> CONFIG_HID_LENOVO_TPKBD=m
>> CONFIG_HID_LOGITECH=m
>> CONFIG_HID_LOGITECH_DJ=m
>> CONFIG_LOGITECH_FF=y
>> CONFIG_LOGIRUMBLEPAD2_FF=y
>> CONFIG_LOGIG940_FF=y
>> CONFIG_LOGIWHEELS_FF=y
>> CONFIG_HID_MAGICMOUSE=m
>> CONFIG_HID_MICROSOFT=m
>> CONFIG_HID_MONTEREY=m
>> CONFIG_HID_MULTITOUCH=m
>> CONFIG_HID_NTRIG=m
>> CONFIG_HID_ORTEK=m
>> CONFIG_HID_PANTHERLORD=m
>> CONFIG_PANTHERLORD_FF=y
>> CONFIG_HID_PETALYNX=m
>> CONFIG_HID_PICOLCD=m
>> CONFIG_HID_PICOLCD_FB=y
>> CONFIG_HID_PICOLCD_BACKLIGHT=y
>> CONFIG_HID_PICOLCD_LEDS=y
>> CONFIG_HID_PICOLCD_CIR=y
>> CONFIG_HID_PRIMAX=m
>> CONFIG_HID_PS3REMOTE=m
>> CONFIG_HID_ROCCAT=m
>> CONFIG_HID_SAITEK=m
>> CONFIG_HID_SAMSUNG=m
>> CONFIG_HID_SONY=m
>> CONFIG_HID_SPEEDLINK=m
>> CONFIG_HID_SUNPLUS=m
>> CONFIG_HID_GREENASIA=m
>> CONFIG_GREENASIA_FF=y
>> CONFIG_HID_HYPERV_MOUSE=m
>> CONFIG_HID_SMARTJOYPLUS=m
>> CONFIG_SMARTJOYPLUS_FF=y
>> CONFIG_HID_TIVO=m
>> CONFIG_HID_TOPSEED=m
>> CONFIG_HID_THRUSTMASTER=m
>> CONFIG_THRUSTMASTER_FF=y
>> CONFIG_HID_WACOM=m
>> CONFIG_HID_WIIMOTE=m
>> CONFIG_HID_WIIMOTE_EXT=y
>> CONFIG_HID_ZEROPLUS=m
>> CONFIG_ZEROPLUS_FF=y
>> CONFIG_HID_ZYDACRON=m
>> CONFIG_HID_SENSOR_HUB=m
>>
>> #
>> # USB HID support
>> #
>> CONFIG_USB_HID=m
>> CONFIG_HID_PID=y
>> CONFIG_USB_HIDDEV=y
>> CONFIG_USB_ARCH_HAS_OHCI=y
>> CONFIG_USB_ARCH_HAS_EHCI=y
>> CONFIG_USB_ARCH_HAS_XHCI=y
>> CONFIG_USB_SUPPORT=y
>> CONFIG_USB_COMMON=m
>> CONFIG_USB_ARCH_HAS_HCD=y
>> CONFIG_USB=m
>> # CONFIG_USB_DEBUG is not set
>> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
>>
>> #
>> # Miscellaneous USB options
>> #
>> CONFIG_USB_DYNAMIC_MINORS=y
>> CONFIG_USB_SUSPEND=y
>> # CONFIG_USB_OTG is not set
>> # CONFIG_USB_DWC3 is not set
>> CONFIG_USB_MON=m
>> CONFIG_USB_WUSB=m
>> CONFIG_USB_WUSB_CBAF=m
>> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
>>
>> #
>> # USB Host Controller Drivers
>> #
>> # CONFIG_USB_C67X00_HCD is not set
>> CONFIG_USB_XHCI_HCD=m
>> # CONFIG_USB_XHCI_HCD_DEBUGGING is not set
>> CONFIG_USB_EHCI_HCD=m
>> CONFIG_USB_EHCI_ROOT_HUB_TT=y
>> CONFIG_USB_EHCI_TT_NEWSCHED=y
>> # CONFIG_USB_OXU210HP_HCD is not set
>> # CONFIG_USB_ISP116X_HCD is not set
>> # CONFIG_USB_ISP1760_HCD is not set
>> # CONFIG_USB_ISP1362_HCD is not set
>> # CONFIG_USB_OHCI_HCD is not set
>> CONFIG_USB_EHCI_HCD_PLATFORM=y
>> CONFIG_USB_UHCI_HCD=m
>> # CONFIG_USB_U132_HCD is not set
>> CONFIG_USB_SL811_HCD=m
>> # CONFIG_USB_SL811_HCD_ISO is not set
>> CONFIG_USB_R8A66597_HCD=m
>> CONFIG_USB_WHCI_HCD=m
>> CONFIG_USB_HWA_HCD=m
>> CONFIG_USB_HCD_BCMA=m
>> # CONFIG_USB_HCD_SSB is not set
>> # CONFIG_USB_MUSB_HDRC is not set
>> # CONFIG_USB_CHIPIDEA is not set
>> # CONFIG_USB_RENESAS_USBHS is not set
>>
>> #
>> # USB Device Class drivers
>> #
>> CONFIG_USB_ACM=m
>> CONFIG_USB_PRINTER=m
>> CONFIG_USB_WDM=m
>> CONFIG_USB_TMC=m
>>
>> #
>> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
>> #
>>
>> #
>> # also be needed; see USB_STORAGE Help for more info
>> #
>> CONFIG_USB_STORAGE=m
>> # CONFIG_USB_STORAGE_DEBUG is not set
>> CONFIG_USB_STORAGE_REALTEK=m
>> CONFIG_REALTEK_AUTOPM=y
>> CONFIG_USB_STORAGE_DATAFAB=m
>> CONFIG_USB_STORAGE_FREECOM=m
>> CONFIG_USB_STORAGE_ISD200=m
>> CONFIG_USB_STORAGE_USBAT=m
>> CONFIG_USB_STORAGE_SDDR09=m
>> CONFIG_USB_STORAGE_SDDR55=m
>> CONFIG_USB_STORAGE_JUMPSHOT=m
>> CONFIG_USB_STORAGE_ALAUDA=m
>> CONFIG_USB_STORAGE_ONETOUCH=m
>> CONFIG_USB_STORAGE_KARMA=m
>> CONFIG_USB_STORAGE_CYPRESS_ATACB=m
>> CONFIG_USB_STORAGE_ENE_UB6250=m
>>
>> #
>> # USB Imaging devices
>> #
>> CONFIG_USB_MDC800=m
>> CONFIG_USB_MICROTEK=m
>>
>> #
>> # USB port drivers
>> #
>> CONFIG_USB_SERIAL=m
>> CONFIG_USB_SERIAL_GENERIC=y
>> CONFIG_USB_SERIAL_AIRCABLE=m
>> CONFIG_USB_SERIAL_ARK3116=m
>> CONFIG_USB_SERIAL_BELKIN=m
>> CONFIG_USB_SERIAL_CH341=m
>> CONFIG_USB_SERIAL_WHITEHEAT=m
>> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
>> CONFIG_USB_SERIAL_CP210X=m
>> CONFIG_USB_SERIAL_CYPRESS_M8=m
>> CONFIG_USB_SERIAL_EMPEG=m
>> CONFIG_USB_SERIAL_FTDI_SIO=m
>> CONFIG_USB_SERIAL_FUNSOFT=m
>> CONFIG_USB_SERIAL_VISOR=m
>> CONFIG_USB_SERIAL_IPAQ=m
>> CONFIG_USB_SERIAL_IR=m
>> CONFIG_USB_SERIAL_EDGEPORT=m
>> CONFIG_USB_SERIAL_EDGEPORT_TI=m
>> CONFIG_USB_SERIAL_F81232=m
>> CONFIG_USB_SERIAL_GARMIN=m
>> CONFIG_USB_SERIAL_IPW=m
>> CONFIG_USB_SERIAL_IUU=m
>> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
>> CONFIG_USB_SERIAL_KEYSPAN=m
>> CONFIG_USB_SERIAL_KLSI=m
>> CONFIG_USB_SERIAL_KOBIL_SCT=m
>> CONFIG_USB_SERIAL_MCT_U232=m
>> CONFIG_USB_SERIAL_METRO=m
>> CONFIG_USB_SERIAL_MOS7720=m
>> CONFIG_USB_SERIAL_MOS7840=m
>> CONFIG_USB_SERIAL_MOTOROLA=m
>> CONFIG_USB_SERIAL_NAVMAN=m
>> CONFIG_USB_SERIAL_PL2303=m
>> CONFIG_USB_SERIAL_OTI6858=m
>> CONFIG_USB_SERIAL_QCAUX=m
>> CONFIG_USB_SERIAL_QUALCOMM=m
>> CONFIG_USB_SERIAL_SPCP8X5=m
>> CONFIG_USB_SERIAL_HP4X=m
>> CONFIG_USB_SERIAL_SAFE=m
>> # CONFIG_USB_SERIAL_SAFE_PADDED is not set
>> CONFIG_USB_SERIAL_SIEMENS_MPI=m
>> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
>> CONFIG_USB_SERIAL_SYMBOL=m
>> CONFIG_USB_SERIAL_TI=m
>> CONFIG_USB_SERIAL_CYBERJACK=m
>> CONFIG_USB_SERIAL_XIRCOM=m
>> CONFIG_USB_SERIAL_WWAN=m
>> CONFIG_USB_SERIAL_OPTION=m
>> CONFIG_USB_SERIAL_OMNINET=m
>> CONFIG_USB_SERIAL_OPTICON=m
>> CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
>> CONFIG_USB_SERIAL_ZIO=m
>> CONFIG_USB_SERIAL_ZTE=m
>> CONFIG_USB_SERIAL_SSU100=m
>> CONFIG_USB_SERIAL_QT2=m
>> CONFIG_USB_SERIAL_DEBUG=m
>>
>> #
>> # USB Miscellaneous drivers
>> #
>> CONFIG_USB_EMI62=m
>> CONFIG_USB_EMI26=m
>> CONFIG_USB_ADUTUX=m
>> CONFIG_USB_SEVSEG=m
>> CONFIG_USB_RIO500=m
>> CONFIG_USB_LEGOTOWER=m
>> CONFIG_USB_LCD=m
>> CONFIG_USB_LED=m
>> CONFIG_USB_CYPRESS_CY7C63=m
>> CONFIG_USB_CYTHERM=m
>> CONFIG_USB_IDMOUSE=m
>> CONFIG_USB_FTDI_ELAN=m
>> CONFIG_USB_APPLEDISPLAY=m
>> CONFIG_USB_SISUSBVGA=m
>> CONFIG_USB_SISUSBVGA_CON=y
>> CONFIG_USB_LD=m
>> CONFIG_USB_TRANCEVIBRATOR=m
>> CONFIG_USB_IOWARRIOR=m
>> CONFIG_USB_TEST=m
>> CONFIG_USB_ISIGHTFW=m
>> CONFIG_USB_YUREX=m
>> CONFIG_USB_EZUSB_FX2=m
>>
>> #
>> # USB Physical Layer drivers
>> #
>> # CONFIG_OMAP_USB2 is not set
>> # CONFIG_USB_ISP1301 is not set
>> CONFIG_USB_ATM=m
>> CONFIG_USB_SPEEDTOUCH=m
>> CONFIG_USB_CXACRU=m
>> CONFIG_USB_UEAGLEATM=m
>> CONFIG_USB_XUSBATM=m
>> CONFIG_USB_GADGET=m
>> # CONFIG_USB_GADGET_DEBUG is not set
>> # CONFIG_USB_GADGET_DEBUG_FILES is not set
>> # CONFIG_USB_GADGET_DEBUG_FS is not set
>> CONFIG_USB_GADGET_VBUS_DRAW=2
>> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
>>
>> #
>> # USB Peripheral Controller
>> #
>> # CONFIG_USB_R8A66597 is not set
>> # CONFIG_USB_MV_UDC is not set
>> # CONFIG_USB_M66592 is not set
>> # CONFIG_USB_AMD5536UDC is not set
>> # CONFIG_USB_NET2272 is not set
>> # CONFIG_USB_NET2280 is not set
>> # CONFIG_USB_GOKU is not set
>> CONFIG_USB_EG20T=m
>> # CONFIG_USB_DUMMY_HCD is not set
>> CONFIG_USB_LIBCOMPOSITE=m
>> # CONFIG_USB_ZERO is not set
>> # CONFIG_USB_AUDIO is not set
>> # CONFIG_USB_ETH is not set
>> # CONFIG_USB_G_NCM is not set
>> # CONFIG_USB_GADGETFS is not set
>> # CONFIG_USB_FUNCTIONFS is not set
>> # CONFIG_USB_FILE_STORAGE is not set
>> # CONFIG_USB_MASS_STORAGE is not set
>> CONFIG_USB_GADGET_TARGET=m
>> # CONFIG_USB_G_SERIAL is not set
>> # CONFIG_USB_MIDI_GADGET is not set
>> # CONFIG_USB_G_PRINTER is not set
>> # CONFIG_USB_CDC_COMPOSITE is not set
>> # CONFIG_USB_G_NOKIA is not set
>> # CONFIG_USB_G_ACM_MS is not set
>> # CONFIG_USB_G_MULTI is not set
>> # CONFIG_USB_G_HID is not set
>> # CONFIG_USB_G_DBGP is not set
>> # CONFIG_USB_G_WEBCAM is not set
>>
>> #
>> # OTG and related infrastructure
>> #
>> CONFIG_USB_OTG_UTILS=y
>> # CONFIG_USB_GPIO_VBUS is not set
>> CONFIG_NOP_USB_XCEIV=m
>> CONFIG_UWB=m
>> CONFIG_UWB_HWA=m
>> CONFIG_UWB_WHCI=m
>> CONFIG_UWB_I1480U=m
>> CONFIG_MMC=m
>> # CONFIG_MMC_DEBUG is not set
>> # CONFIG_MMC_UNSAFE_RESUME is not set
>> # CONFIG_MMC_CLKGATE is not set
>>
>> #
>> # MMC/SD/SDIO Card Drivers
>> #
>> CONFIG_MMC_BLOCK=m
>> CONFIG_MMC_BLOCK_MINORS=8
>> CONFIG_MMC_BLOCK_BOUNCE=y
>> CONFIG_SDIO_UART=m
>> # CONFIG_MMC_TEST is not set
>>
>> #
>> # MMC/SD/SDIO Host Controller Drivers
>> #
>> CONFIG_MMC_SDHCI=m
>> CONFIG_MMC_SDHCI_PCI=m
>> CONFIG_MMC_RICOH_MMC=y
>> CONFIG_MMC_SDHCI_PLTFM=m
>> CONFIG_MMC_WBSD=m
>> CONFIG_MMC_TIFM_SD=m
>> CONFIG_MMC_SPI=m
>> CONFIG_MMC_CB710=m
>> CONFIG_MMC_VIA_SDMMC=m
>> CONFIG_MMC_VUB300=m
>> CONFIG_MMC_USHC=m
>> CONFIG_MEMSTICK=m
>> # CONFIG_MEMSTICK_DEBUG is not set
>>
>> #
>> # MemoryStick drivers
>> #
>> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
>> CONFIG_MSPRO_BLOCK=m
>>
>> #
>> # MemoryStick Host Controller Drivers
>> #
>> CONFIG_MEMSTICK_TIFM_MS=m
>> CONFIG_MEMSTICK_JMICRON_38X=m
>> CONFIG_MEMSTICK_R592=m
>> CONFIG_NEW_LEDS=y
>> CONFIG_LEDS_CLASS=y
>>
>> #
>> # LED drivers
>> #
>> # CONFIG_LEDS_LM3530 is not set
>> # CONFIG_LEDS_LM3642 is not set
>> CONFIG_LEDS_PCA9532=m
>> # CONFIG_LEDS_PCA9532_GPIO is not set
>> # CONFIG_LEDS_GPIO is not set
>> CONFIG_LEDS_LP3944=m
>> # CONFIG_LEDS_LP5521 is not set
>> # CONFIG_LEDS_LP5523 is not set
>> CONFIG_LEDS_CLEVO_MAIL=m
>> CONFIG_LEDS_PCA955X=m
>> CONFIG_LEDS_PCA9633=m
>> CONFIG_LEDS_DAC124S085=m
>> CONFIG_LEDS_REGULATOR=m
>> CONFIG_LEDS_BD2802=m
>> CONFIG_LEDS_INTEL_SS4200=m
>> CONFIG_LEDS_LT3593=m
>> CONFIG_LEDS_DELL_NETBOOKS=m
>> CONFIG_LEDS_TCA6507=m
>> CONFIG_LEDS_LM355x=m
>> CONFIG_LEDS_OT200=m
>> CONFIG_LEDS_BLINKM=m
>> CONFIG_LEDS_TRIGGERS=y
>>
>> #
>> # LED Triggers
>> #
>> CONFIG_LEDS_TRIGGER_TIMER=m
>> CONFIG_LEDS_TRIGGER_ONESHOT=m
>> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
>> CONFIG_LEDS_TRIGGER_BACKLIGHT=m
>> # CONFIG_LEDS_TRIGGER_CPU is not set
>> # CONFIG_LEDS_TRIGGER_GPIO is not set
>> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
>>
>> #
>> # iptables trigger is under Netfilter config (LED target)
>> #
>> CONFIG_LEDS_TRIGGER_TRANSIENT=m
>> CONFIG_ACCESSIBILITY=y
>> CONFIG_A11Y_BRAILLE_CONSOLE=y
>> CONFIG_INFINIBAND=m
>> CONFIG_INFINIBAND_USER_MAD=m
>> CONFIG_INFINIBAND_USER_ACCESS=m
>> CONFIG_INFINIBAND_USER_MEM=y
>> CONFIG_INFINIBAND_ADDR_TRANS=y
>> CONFIG_INFINIBAND_MTHCA=m
>> CONFIG_INFINIBAND_MTHCA_DEBUG=y
>> CONFIG_INFINIBAND_IPATH=m
>> CONFIG_INFINIBAND_QIB=m
>> CONFIG_INFINIBAND_AMSO1100=m
>> # CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
>> CONFIG_INFINIBAND_CXGB3=m
>> # CONFIG_INFINIBAND_CXGB3_DEBUG is not set
>> CONFIG_INFINIBAND_CXGB4=m
>> CONFIG_MLX4_INFINIBAND=m
>> CONFIG_INFINIBAND_NES=m
>> # CONFIG_INFINIBAND_NES_DEBUG is not set
>> CONFIG_INFINIBAND_OCRDMA=m
>> CONFIG_INFINIBAND_IPOIB=m
>> CONFIG_INFINIBAND_IPOIB_CM=y
>> CONFIG_INFINIBAND_IPOIB_DEBUG=y
>> # CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
>> CONFIG_INFINIBAND_SRP=m
>> CONFIG_INFINIBAND_SRPT=m
>> CONFIG_INFINIBAND_ISER=m
>> CONFIG_EDAC=y
>>
>> #
>> # Reporting subsystems
>> #
>> CONFIG_EDAC_LEGACY_SYSFS=y
>> # CONFIG_EDAC_DEBUG is not set
>> CONFIG_EDAC_DECODE_MCE=m
>> # CONFIG_EDAC_MCE_INJ is not set
>> CONFIG_EDAC_MM_EDAC=m
>> CONFIG_EDAC_AMD64=m
>> # CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
>> CONFIG_EDAC_E752X=m
>> CONFIG_EDAC_I82975X=m
>> CONFIG_EDAC_I3000=m
>> CONFIG_EDAC_I3200=m
>> CONFIG_EDAC_X38=m
>> CONFIG_EDAC_I5400=m
>> CONFIG_EDAC_I7CORE=m
>> CONFIG_EDAC_I5000=m
>> CONFIG_EDAC_I5100=m
>> CONFIG_EDAC_I7300=m
>> # CONFIG_EDAC_SBRIDGE is not set
>> CONFIG_RTC_LIB=y
>> CONFIG_RTC_CLASS=y
>> CONFIG_RTC_HCTOSYS=y
>> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
>> # CONFIG_RTC_DEBUG is not set
>>
>> #
>> # RTC interfaces
>> #
>> CONFIG_RTC_INTF_SYSFS=y
>> CONFIG_RTC_INTF_PROC=y
>> CONFIG_RTC_INTF_DEV=y
>> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
>> # CONFIG_RTC_DRV_TEST is not set
>>
>> #
>> # I2C RTC drivers
>> #
>> CONFIG_RTC_DRV_DS1307=m
>> CONFIG_RTC_DRV_DS1374=m
>> CONFIG_RTC_DRV_DS1672=m
>> # CONFIG_RTC_DRV_DS3232 is not set
>> CONFIG_RTC_DRV_MAX6900=m
>> CONFIG_RTC_DRV_RS5C372=m
>> CONFIG_RTC_DRV_ISL1208=m
>> # CONFIG_RTC_DRV_ISL12022 is not set
>> CONFIG_RTC_DRV_X1205=m
>> CONFIG_RTC_DRV_PCF8563=m
>> CONFIG_RTC_DRV_PCF8583=m
>> CONFIG_RTC_DRV_M41T80=m
>> # CONFIG_RTC_DRV_M41T80_WDT is not set
>> CONFIG_RTC_DRV_BQ32K=m
>> CONFIG_RTC_DRV_S35390A=m
>> CONFIG_RTC_DRV_FM3130=m
>> CONFIG_RTC_DRV_RX8581=m
>> CONFIG_RTC_DRV_RX8025=m
>> # CONFIG_RTC_DRV_EM3027 is not set
>> # CONFIG_RTC_DRV_RV3029C2 is not set
>>
>> #
>> # SPI RTC drivers
>> #
>> # CONFIG_RTC_DRV_M41T93 is not set
>> CONFIG_RTC_DRV_M41T94=m
>> CONFIG_RTC_DRV_DS1305=m
>> CONFIG_RTC_DRV_DS1390=m
>> CONFIG_RTC_DRV_MAX6902=m
>> CONFIG_RTC_DRV_R9701=m
>> CONFIG_RTC_DRV_RS5C348=m
>> CONFIG_RTC_DRV_DS3234=m
>> CONFIG_RTC_DRV_PCF2123=m
>>
>> #
>> # Platform RTC drivers
>> #
>> CONFIG_RTC_DRV_CMOS=y
>> CONFIG_RTC_DRV_DS1286=m
>> CONFIG_RTC_DRV_DS1511=m
>> CONFIG_RTC_DRV_DS1553=m
>> CONFIG_RTC_DRV_DS1742=m
>> CONFIG_RTC_DRV_STK17TA8=m
>> CONFIG_RTC_DRV_M48T86=m
>> CONFIG_RTC_DRV_M48T35=m
>> CONFIG_RTC_DRV_M48T59=m
>> CONFIG_RTC_DRV_MSM6242=m
>> CONFIG_RTC_DRV_BQ4802=m
>> CONFIG_RTC_DRV_RP5C01=m
>> CONFIG_RTC_DRV_V3020=m
>> CONFIG_RTC_DRV_DS2404=m
>> CONFIG_RTC_DRV_PCF50633=m
>>
>> #
>> # on-CPU RTC drivers
>> #
>> CONFIG_DMADEVICES=y
>> # CONFIG_DMADEVICES_DEBUG is not set
>>
>> #
>> # DMA Devices
>> #
>> CONFIG_INTEL_MID_DMAC=m
>> CONFIG_INTEL_IOATDMA=m
>> # CONFIG_TIMB_DMA is not set
>> CONFIG_PCH_DMA=m
>> CONFIG_DMA_ENGINE=y
>>
>> #
>> # DMA Clients
>> #
>> CONFIG_NET_DMA=y
>> CONFIG_ASYNC_TX_DMA=y
>> # CONFIG_DMATEST is not set
>> CONFIG_DCA=m
>> # CONFIG_AUXDISPLAY is not set
>> CONFIG_UIO=m
>> CONFIG_UIO_CIF=m
>> CONFIG_UIO_PDRV=m
>> CONFIG_UIO_PDRV_GENIRQ=m
>> CONFIG_UIO_AEC=m
>> CONFIG_UIO_SERCOS3=m
>> CONFIG_UIO_PCI_GENERIC=m
>> CONFIG_UIO_NETX=m
>> CONFIG_VFIO_IOMMU_TYPE1=m
>> CONFIG_VFIO=m
>> CONFIG_VFIO_PCI=m
>> CONFIG_VIRTIO=m
>>
>> #
>> # Virtio drivers
>> #
>> CONFIG_VIRTIO_PCI=m
>> CONFIG_VIRTIO_BALLOON=m
>> # CONFIG_VIRTIO_MMIO is not set
>>
>> #
>> # Microsoft Hyper-V guest support
>> #
>> CONFIG_HYPERV=m
>> CONFIG_HYPERV_UTILS=m
>> CONFIG_STAGING=y
>> CONFIG_ET131X=m
>> # CONFIG_SLICOSS is not set
>> CONFIG_USBIP_CORE=m
>> CONFIG_USBIP_VHCI_HCD=m
>> CONFIG_USBIP_HOST=m
>> # CONFIG_USBIP_DEBUG is not set
>> # CONFIG_W35UND is not set
>> CONFIG_PRISM2_USB=m
>> # CONFIG_ECHO is not set
>> CONFIG_COMEDI=m
>> # CONFIG_COMEDI_DEBUG is not set
>> CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
>> CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
>> CONFIG_COMEDI_MISC_DRIVERS=y
>> CONFIG_COMEDI_KCOMEDILIB=m
>> CONFIG_COMEDI_BOND=m
>> CONFIG_COMEDI_TEST=m
>> CONFIG_COMEDI_PARPORT=m
>> CONFIG_COMEDI_SERIAL2002=m
>> # CONFIG_COMEDI_SKEL is not set
>> CONFIG_COMEDI_PCI_DRIVERS=y
>> # CONFIG_COMEDI_8255_PCI is not set
>> CONFIG_COMEDI_ADDI_APCI_035=m
>> CONFIG_COMEDI_ADDI_APCI_1032=m
>> CONFIG_COMEDI_ADDI_APCI_1500=m
>> CONFIG_COMEDI_ADDI_APCI_1516=m
>> CONFIG_COMEDI_ADDI_APCI_1564=m
>> CONFIG_COMEDI_ADDI_APCI_16XX=m
>> CONFIG_COMEDI_ADDI_APCI_2016=m
>> CONFIG_COMEDI_ADDI_APCI_2032=m
>> CONFIG_COMEDI_ADDI_APCI_2200=m
>> CONFIG_COMEDI_ADDI_APCI_3001=m
>> CONFIG_COMEDI_ADDI_APCI_3120=m
>> CONFIG_COMEDI_ADDI_APCI_3501=m
>> CONFIG_COMEDI_ADDI_APCI_3XXX=m
>> CONFIG_COMEDI_ADL_PCI6208=m
>> # CONFIG_COMEDI_ADL_PCI7X3X is not set
>> CONFIG_COMEDI_ADL_PCI8164=m
>> CONFIG_COMEDI_ADL_PCI9111=m
>> CONFIG_COMEDI_ADL_PCI9118=m
>> CONFIG_COMEDI_ADV_PCI1710=m
>> CONFIG_COMEDI_ADV_PCI1723=m
>> CONFIG_COMEDI_ADV_PCI_DIO=m
>> CONFIG_COMEDI_AMPLC_DIO200_PCI=m
>> CONFIG_COMEDI_AMPLC_PC236_PCI=m
>> CONFIG_COMEDI_AMPLC_PC263_PCI=m
>> CONFIG_COMEDI_AMPLC_PCI224=m
>> CONFIG_COMEDI_AMPLC_PCI230=m
>> CONFIG_COMEDI_CONTEC_PCI_DIO=m
>> CONFIG_COMEDI_DAS08_PCI=m
>> CONFIG_COMEDI_DT3000=m
>> # CONFIG_COMEDI_DYNA_PCI10XX is not set
>> CONFIG_COMEDI_UNIOXX5=m
>> CONFIG_COMEDI_GSC_HPDI=m
>> CONFIG_COMEDI_ICP_MULTI=m
>> CONFIG_COMEDI_II_PCI20KC=m
>> CONFIG_COMEDI_DAQBOARD2000=m
>> CONFIG_COMEDI_JR3_PCI=m
>> CONFIG_COMEDI_KE_COUNTER=m
>> CONFIG_COMEDI_CB_PCIDAS64=m
>> CONFIG_COMEDI_CB_PCIDAS=m
>> CONFIG_COMEDI_CB_PCIDDA=m
>> CONFIG_COMEDI_CB_PCIMDAS=m
>> CONFIG_COMEDI_CB_PCIMDDA=m
>> CONFIG_COMEDI_ME4000=m
>> CONFIG_COMEDI_ME_DAQ=m
>> CONFIG_COMEDI_NI_6527=m
>> CONFIG_COMEDI_NI_65XX=m
>> CONFIG_COMEDI_NI_660X=m
>> CONFIG_COMEDI_NI_670X=m
>> CONFIG_COMEDI_NI_LABPC=m
>> CONFIG_COMEDI_NI_PCIDIO=m
>> CONFIG_COMEDI_NI_PCIMIO=m
>> CONFIG_COMEDI_RTD520=m
>> CONFIG_COMEDI_S526=m
>> CONFIG_COMEDI_S626=m
>> CONFIG_COMEDI_SSV_DNP=m
>> CONFIG_COMEDI_MITE=m
>> CONFIG_COMEDI_NI_TIOCMD=m
>> CONFIG_COMEDI_USB_DRIVERS=y
>> CONFIG_COMEDI_DT9812=m
>> CONFIG_COMEDI_USBDUX=m
>> CONFIG_COMEDI_USBDUXFAST=m
>> # CONFIG_COMEDI_USBDUXSIGMA is not set
>> CONFIG_COMEDI_VMK80XX=m
>> CONFIG_COMEDI_8255=m
>> CONFIG_COMEDI_FC=m
>> CONFIG_COMEDI_AMPLC_DIO200=m
>> CONFIG_COMEDI_AMPLC_PC236=m
>> CONFIG_COMEDI_AMPLC_PC263=m
>> CONFIG_COMEDI_DAS08=m
>> CONFIG_COMEDI_NI_TIO=m
>> # CONFIG_ASUS_OLED is not set
>> CONFIG_R8187SE=m
>> CONFIG_RTL8192U=m
>> CONFIG_RTLLIB=m
>> CONFIG_RTLLIB_CRYPTO_CCMP=m
>> CONFIG_RTLLIB_CRYPTO_TKIP=m
>> CONFIG_RTLLIB_CRYPTO_WEP=m
>> CONFIG_RTL8192E=m
>> CONFIG_R8712U=m
>> CONFIG_RTS_PSTOR=m
>> # CONFIG_RTS_PSTOR_DEBUG is not set
>> CONFIG_RTS5139=m
>> # CONFIG_RTS5139_DEBUG is not set
>> # CONFIG_TRANZPORT is not set
>> # CONFIG_IDE_PHISON is not set
>> # CONFIG_LINE6_USB is not set
>> # CONFIG_USB_SERIAL_QUATECH2 is not set
>> # CONFIG_VT6655 is not set
>> CONFIG_VT6656=m
>> # CONFIG_DX_SEP is not set
>> CONFIG_ZRAM=m
>> # CONFIG_ZRAM_DEBUG is not set
>> CONFIG_ZSMALLOC=m
>> # CONFIG_FB_SM7XX is not set
>> # CONFIG_CRYSTALHD is not set
>> # CONFIG_CXT1E1 is not set
>> # CONFIG_FB_XGI is not set
>> # CONFIG_ACPI_QUICKSTART is not set
>> # CONFIG_SBE_2T3E3 is not set
>> # CONFIG_USB_ENESTORAGE is not set
>> # CONFIG_BCM_WIMAX is not set
>> # CONFIG_FT1000 is not set
>>
>> #
>> # Speakup console speech
>> #
>> CONFIG_SPEAKUP=m
>> CONFIG_SPEAKUP_SYNTH_ACNTSA=m
>> CONFIG_SPEAKUP_SYNTH_ACNTPC=m
>> CONFIG_SPEAKUP_SYNTH_APOLLO=m
>> CONFIG_SPEAKUP_SYNTH_AUDPTR=m
>> CONFIG_SPEAKUP_SYNTH_BNS=m
>> CONFIG_SPEAKUP_SYNTH_DECTLK=m
>> CONFIG_SPEAKUP_SYNTH_DECEXT=m
>> # CONFIG_SPEAKUP_SYNTH_DECPC is not set
>> CONFIG_SPEAKUP_SYNTH_DTLK=m
>> CONFIG_SPEAKUP_SYNTH_KEYPC=m
>> CONFIG_SPEAKUP_SYNTH_LTLK=m
>> CONFIG_SPEAKUP_SYNTH_SOFT=m
>> CONFIG_SPEAKUP_SYNTH_SPKOUT=m
>> CONFIG_SPEAKUP_SYNTH_TXPRT=m
>> CONFIG_SPEAKUP_SYNTH_DUMMY=m
>> # CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
>> # CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
>> CONFIG_STAGING_MEDIA=y
>> # CONFIG_DVB_AS102 is not set
>> # CONFIG_DVB_CXD2099 is not set
>> # CONFIG_VIDEO_DT3155 is not set
>> # CONFIG_VIDEO_GO7007 is not set
>> # CONFIG_SOLO6X10 is not set
>> CONFIG_LIRC_STAGING=y
>> CONFIG_LIRC_BT829=m
>> CONFIG_LIRC_IGORPLUGUSB=m
>> CONFIG_LIRC_IMON=m
>> CONFIG_LIRC_SASEM=m
>> CONFIG_LIRC_SERIAL=m
>> CONFIG_LIRC_SERIAL_TRANSMITTER=y
>> CONFIG_LIRC_SIR=m
>> CONFIG_LIRC_ZILOG=m
>>
>> #
>> # Android
>> #
>> # CONFIG_ANDROID is not set
>> CONFIG_PHONE=m
>> CONFIG_PHONE_IXJ=m
>> CONFIG_USB_WPAN_HCD=m
>> # CONFIG_USB_G_CCG is not set
>> CONFIG_IPACK_BUS=m
>> CONFIG_BOARD_TPCI200=m
>> CONFIG_SERIAL_IPOCTAL=m
>> # CONFIG_WIMAX_GDM72XX is not set
>> CONFIG_CSR_WIFI=m
>> CONFIG_ZCACHE2=y
>> # CONFIG_NET_VENDOR_SILICOM is not set
>> # CONFIG_CED1401 is not set
>> # CONFIG_DGRP is not set
>> CONFIG_X86_PLATFORM_DEVICES=y
>> # CONFIG_ACER_WMI is not set
>> # CONFIG_ACERHDF is not set
>> CONFIG_ASUS_LAPTOP=m
>> CONFIG_DELL_LAPTOP=m
>> CONFIG_DELL_WMI=m
>> CONFIG_DELL_WMI_AIO=m
>> # CONFIG_FUJITSU_LAPTOP is not set
>> # CONFIG_FUJITSU_TABLET is not set
>> # CONFIG_AMILO_RFKILL is not set
>> # CONFIG_HP_ACCEL is not set
>> # CONFIG_HP_WMI is not set
>> # CONFIG_MSI_LAPTOP is not set
>> # CONFIG_PANASONIC_LAPTOP is not set
>> # CONFIG_COMPAL_LAPTOP is not set
>> # CONFIG_SONY_LAPTOP is not set
>> # CONFIG_IDEAPAD_LAPTOP is not set
>> # CONFIG_THINKPAD_ACPI is not set
>> # CONFIG_SENSORS_HDAPS is not set
>> # CONFIG_INTEL_MENLOW is not set
>> CONFIG_EEEPC_LAPTOP=m
>> CONFIG_ASUS_WMI=m
>> CONFIG_ASUS_NB_WMI=m
>> CONFIG_EEEPC_WMI=m
>> CONFIG_ACPI_WMI=m
>> CONFIG_MSI_WMI=m
>> # CONFIG_TOPSTAR_LAPTOP is not set
>> # CONFIG_ACPI_TOSHIBA is not set
>> # CONFIG_TOSHIBA_BT_RFKILL is not set
>> # CONFIG_ACPI_CMPC is not set
>> CONFIG_INTEL_IPS=m
>> # CONFIG_IBM_RTL is not set
>> # CONFIG_XO15_EBOOK is not set
>> # CONFIG_SAMSUNG_LAPTOP is not set
>> CONFIG_MXM_WMI=m
>> CONFIG_INTEL_OAKTRAIL=m
>> # CONFIG_SAMSUNG_Q10 is not set
>> CONFIG_APPLE_GMUX=m
>>
>> #
>> # Hardware Spinlock drivers
>> #
>> CONFIG_CLKEVT_I8253=y
>> CONFIG_I8253_LOCK=y
>> CONFIG_CLKBLD_I8253=y
>> CONFIG_IOMMU_API=y
>> CONFIG_IOMMU_SUPPORT=y
>> CONFIG_AMD_IOMMU=y
>> # CONFIG_AMD_IOMMU_STATS is not set
>> CONFIG_AMD_IOMMU_V2=m
>> CONFIG_DMAR_TABLE=y
>> CONFIG_INTEL_IOMMU=y
>> # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
>> CONFIG_INTEL_IOMMU_FLOPPY_WA=y
>> CONFIG_IRQ_REMAP=y
>>
>> #
>> # Remoteproc drivers (EXPERIMENTAL)
>> #
>> # CONFIG_STE_MODEM_RPROC is not set
>>
>> #
>> # Rpmsg drivers (EXPERIMENTAL)
>> #
>> CONFIG_VIRT_DRIVERS=y
>> # CONFIG_PM_DEVFREQ is not set
>> CONFIG_EXTCON=m
>>
>> #
>> # Extcon Device Drivers
>> #
>> CONFIG_EXTCON_GPIO=m
>> # CONFIG_MEMORY is not set
>> # CONFIG_IIO is not set
>> # CONFIG_VME_BUS is not set
>> CONFIG_PWM=y
>>
>> #
>> # Firmware Drivers
>> #
>> CONFIG_EDD=m
>> # CONFIG_EDD_OFF is not set
>> CONFIG_FIRMWARE_MEMMAP=y
>> CONFIG_EFI_VARS=m
>> CONFIG_DELL_RBU=m
>> CONFIG_DCDBAS=m
>> CONFIG_DMIID=y
>> CONFIG_DMI_SYSFS=m
>> CONFIG_ISCSI_IBFT_FIND=y
>> CONFIG_ISCSI_IBFT=m
>> # CONFIG_GOOGLE_FIRMWARE is not set
>>
>> #
>> # File systems
>> #
>> CONFIG_DCACHE_WORD_ACCESS=y
>> # CONFIG_EXT2_FS is not set
>> # CONFIG_EXT3_FS is not set
>> CONFIG_EXT4_FS=m
>> CONFIG_EXT4_USE_FOR_EXT23=y
>> CONFIG_EXT4_FS_XATTR=y
>> CONFIG_EXT4_FS_POSIX_ACL=y
>> CONFIG_EXT4_FS_SECURITY=y
>> # CONFIG_EXT4_DEBUG is not set
>> CONFIG_JBD2=m
>> # CONFIG_JBD2_DEBUG is not set
>> CONFIG_FS_MBCACHE=m
>> # CONFIG_REISERFS_FS is not set
>> CONFIG_JFS_FS=m
>> CONFIG_JFS_POSIX_ACL=y
>> CONFIG_JFS_SECURITY=y
>> # CONFIG_JFS_DEBUG is not set
>> # CONFIG_JFS_STATISTICS is not set
>> CONFIG_XFS_FS=m
>> CONFIG_XFS_QUOTA=y
>> CONFIG_XFS_POSIX_ACL=y
>> CONFIG_XFS_RT=y
>> # CONFIG_XFS_DEBUG is not set
>> # CONFIG_GFS2_FS is not set
>> # CONFIG_OCFS2_FS is not set
>> CONFIG_BTRFS_FS=m
>> CONFIG_BTRFS_FS_POSIX_ACL=y
>> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
>> # CONFIG_NILFS2_FS is not set
>> CONFIG_FS_POSIX_ACL=y
>> CONFIG_EXPORTFS=y
>> CONFIG_FILE_LOCKING=y
>> CONFIG_FSNOTIFY=y
>> CONFIG_DNOTIFY=y
>> CONFIG_INOTIFY_USER=y
>> CONFIG_FANOTIFY=y
>> # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
>> CONFIG_QUOTA=y
>> CONFIG_QUOTA_NETLINK_INTERFACE=y
>> CONFIG_PRINT_QUOTA_WARNING=y
>> # CONFIG_QUOTA_DEBUG is not set
>> CONFIG_QUOTA_TREE=m
>> CONFIG_QFMT_V1=m
>> CONFIG_QFMT_V2=m
>> CONFIG_QUOTACTL=y
>> CONFIG_QUOTACTL_COMPAT=y
>> CONFIG_AUTOFS4_FS=m
>> CONFIG_FUSE_FS=m
>> CONFIG_CUSE=m
>> CONFIG_GENERIC_ACL=y
>>
>> #
>> # Caches
>> #
>> CONFIG_FSCACHE=m
>> CONFIG_FSCACHE_STATS=y
>> # CONFIG_FSCACHE_HISTOGRAM is not set
>> # CONFIG_FSCACHE_DEBUG is not set
>> # CONFIG_FSCACHE_OBJECT_LIST is not set
>> CONFIG_CACHEFILES=m
>> # CONFIG_CACHEFILES_DEBUG is not set
>> # CONFIG_CACHEFILES_HISTOGRAM is not set
>>
>> #
>> # CD-ROM/DVD Filesystems
>> #
>> CONFIG_ISO9660_FS=m
>> CONFIG_JOLIET=y
>> CONFIG_ZISOFS=y
>> CONFIG_UDF_FS=m
>> CONFIG_UDF_NLS=y
>>
>> #
>> # DOS/FAT/NT Filesystems
>> #
>> CONFIG_FAT_FS=m
>> CONFIG_MSDOS_FS=m
>> CONFIG_VFAT_FS=m
>> CONFIG_FAT_DEFAULT_CODEPAGE=437
>> CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
>> CONFIG_NTFS_FS=m
>> # CONFIG_NTFS_DEBUG is not set
>> CONFIG_NTFS_RW=y
>>
>> #
>> # Pseudo filesystems
>> #
>> CONFIG_PROC_FS=y
>> CONFIG_PROC_KCORE=y
>> CONFIG_PROC_VMCORE=y
>> CONFIG_PROC_SYSCTL=y
>> CONFIG_PROC_PAGE_MONITOR=y
>> CONFIG_SYSFS=y
>> CONFIG_TMPFS=y
>> CONFIG_TMPFS_POSIX_ACL=y
>> CONFIG_TMPFS_XATTR=y
>> CONFIG_HUGETLBFS=y
>> CONFIG_HUGETLB_PAGE=y
>> CONFIG_CONFIGFS_FS=m
>> CONFIG_MISC_FILESYSTEMS=y
>> # CONFIG_ADFS_FS is not set
>> # CONFIG_AFFS_FS is not set
>> # CONFIG_ECRYPT_FS is not set
>> CONFIG_HFS_FS=m
>> CONFIG_HFSPLUS_FS=m
>> # CONFIG_BEFS_FS is not set
>> # CONFIG_BFS_FS is not set
>> # CONFIG_EFS_FS is not set
>> # CONFIG_JFFS2_FS is not set
>> # CONFIG_UBIFS_FS is not set
>> # CONFIG_LOGFS is not set
>> # CONFIG_CRAMFS is not set
>> # CONFIG_SQUASHFS is not set
>> # CONFIG_VXFS_FS is not set
>> # CONFIG_MINIX_FS is not set
>> # CONFIG_OMFS_FS is not set
>> # CONFIG_HPFS_FS is not set
>> # CONFIG_QNX4FS_FS is not set
>> # CONFIG_QNX6FS_FS is not set
>> # CONFIG_ROMFS_FS is not set
>> CONFIG_PSTORE=y
>> # CONFIG_PSTORE_CONSOLE is not set
>> CONFIG_PSTORE_RAM=m
>> # CONFIG_SYSV_FS is not set
>> # CONFIG_UFS_FS is not set
>> # CONFIG_EXOFS_FS is not set
>> CONFIG_ORE=m
>> CONFIG_NETWORK_FILESYSTEMS=y
>> CONFIG_NFS_FS=m
>> CONFIG_NFS_V2=m
>> CONFIG_NFS_V3=m
>> CONFIG_NFS_V3_ACL=y
>> CONFIG_NFS_V4=m
>> # CONFIG_NFS_SWAP is not set
>> CONFIG_NFS_V4_1=y
>> CONFIG_PNFS_FILE_LAYOUT=m
>> CONFIG_PNFS_BLOCK=m
>> CONFIG_PNFS_OBJLAYOUT=m
>> CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
>> CONFIG_NFS_FSCACHE=y
>> # CONFIG_NFS_USE_LEGACY_DNS is not set
>> CONFIG_NFS_USE_KERNEL_DNS=y
>> CONFIG_NFSD=m
>> CONFIG_NFSD_V2_ACL=y
>> CONFIG_NFSD_V3=y
>> CONFIG_NFSD_V3_ACL=y
>> CONFIG_NFSD_V4=y
>> # CONFIG_NFSD_FAULT_INJECTION is not set
>> CONFIG_LOCKD=m
>> CONFIG_LOCKD_V4=y
>> CONFIG_NFS_ACL_SUPPORT=m
>> CONFIG_NFS_COMMON=y
>> CONFIG_SUNRPC=m
>> CONFIG_SUNRPC_GSS=m
>> CONFIG_SUNRPC_BACKCHANNEL=y
>> CONFIG_SUNRPC_XPRT_RDMA=m
>> CONFIG_RPCSEC_GSS_KRB5=m
>> # CONFIG_SUNRPC_DEBUG is not set
>> CONFIG_CEPH_FS=m
>> CONFIG_CIFS=m
>> # CONFIG_CIFS_STATS is not set
>> CONFIG_CIFS_WEAK_PW_HASH=y
>> CONFIG_CIFS_UPCALL=y
>> CONFIG_CIFS_XATTR=y
>> CONFIG_CIFS_POSIX=y
>> CONFIG_CIFS_ACL=y
>> # CONFIG_CIFS_DEBUG2 is not set
>> CONFIG_CIFS_DFS_UPCALL=y
>> CONFIG_CIFS_SMB2=y
>> CONFIG_CIFS_FSCACHE=y
>> # CONFIG_NCP_FS is not set
>> # CONFIG_CODA_FS is not set
>> # CONFIG_AFS_FS is not set
>> CONFIG_NLS=y
>> CONFIG_NLS_DEFAULT="utf8"
>> CONFIG_NLS_CODEPAGE_437=m
>> CONFIG_NLS_CODEPAGE_737=m
>> CONFIG_NLS_CODEPAGE_775=m
>> CONFIG_NLS_CODEPAGE_850=m
>> CONFIG_NLS_CODEPAGE_852=m
>> CONFIG_NLS_CODEPAGE_855=m
>> CONFIG_NLS_CODEPAGE_857=m
>> CONFIG_NLS_CODEPAGE_860=m
>> CONFIG_NLS_CODEPAGE_861=m
>> CONFIG_NLS_CODEPAGE_862=m
>> CONFIG_NLS_CODEPAGE_863=m
>> CONFIG_NLS_CODEPAGE_864=m
>> CONFIG_NLS_CODEPAGE_865=m
>> CONFIG_NLS_CODEPAGE_866=m
>> CONFIG_NLS_CODEPAGE_869=m
>> CONFIG_NLS_CODEPAGE_936=m
>> CONFIG_NLS_CODEPAGE_950=m
>> CONFIG_NLS_CODEPAGE_932=m
>> CONFIG_NLS_CODEPAGE_949=m
>> CONFIG_NLS_CODEPAGE_874=m
>> CONFIG_NLS_ISO8859_8=m
>> CONFIG_NLS_CODEPAGE_1250=m
>> CONFIG_NLS_CODEPAGE_1251=m
>> CONFIG_NLS_ASCII=m
>> CONFIG_NLS_ISO8859_1=m
>> CONFIG_NLS_ISO8859_2=m
>> CONFIG_NLS_ISO8859_3=m
>> CONFIG_NLS_ISO8859_4=m
>> CONFIG_NLS_ISO8859_5=m
>> CONFIG_NLS_ISO8859_6=m
>> CONFIG_NLS_ISO8859_7=m
>> CONFIG_NLS_ISO8859_9=m
>> CONFIG_NLS_ISO8859_13=m
>> CONFIG_NLS_ISO8859_14=m
>> CONFIG_NLS_ISO8859_15=m
>> CONFIG_NLS_KOI8_R=m
>> CONFIG_NLS_KOI8_U=m
>> # CONFIG_NLS_MAC_ROMAN is not set
>> # CONFIG_NLS_MAC_CELTIC is not set
>> # CONFIG_NLS_MAC_CENTEURO is not set
>> # CONFIG_NLS_MAC_CROATIAN is not set
>> # CONFIG_NLS_MAC_CYRILLIC is not set
>> # CONFIG_NLS_MAC_GAELIC is not set
>> # CONFIG_NLS_MAC_GREEK is not set
>> # CONFIG_NLS_MAC_ICELAND is not set
>> # CONFIG_NLS_MAC_INUIT is not set
>> # CONFIG_NLS_MAC_ROMANIAN is not set
>> # CONFIG_NLS_MAC_TURKISH is not set
>> CONFIG_NLS_UTF8=m
>> CONFIG_DLM=m
>> # CONFIG_DLM_DEBUG is not set
>>
>> #
>> # Kernel hacking
>> #
>> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
>> CONFIG_PRINTK_TIME=y
>> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
>> CONFIG_ENABLE_WARN_DEPRECATED=y
>> CONFIG_ENABLE_MUST_CHECK=y
>> CONFIG_FRAME_WARN=2048
>> CONFIG_MAGIC_SYSRQ=y
>> CONFIG_STRIP_ASM_SYMS=y
>> # CONFIG_READABLE_ASM is not set
>> # CONFIG_UNUSED_SYMBOLS is not set
>> CONFIG_DEBUG_FS=y
>> # CONFIG_HEADERS_CHECK is not set
>> # CONFIG_DEBUG_SECTION_MISMATCH is not set
>> CONFIG_DEBUG_KERNEL=y
>> # CONFIG_DEBUG_SHIRQ is not set
>> CONFIG_LOCKUP_DETECTOR=y
>> CONFIG_HARDLOCKUP_DETECTOR=y
>> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
>> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
>> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
>> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
>> # CONFIG_PANIC_ON_OOPS is not set
>> CONFIG_PANIC_ON_OOPS_VALUE=0
>> CONFIG_DETECT_HUNG_TASK=y
>> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
>> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
>> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
>> CONFIG_SCHED_DEBUG=y
>> CONFIG_SCHEDSTATS=y
>> CONFIG_TIMER_STATS=y
>> # CONFIG_DEBUG_OBJECTS is not set
>> # CONFIG_SLUB_DEBUG_ON is not set
>> # CONFIG_SLUB_STATS is not set
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> # CONFIG_DEBUG_KMEMLEAK is not set
>> CONFIG_DEBUG_PREEMPT=y
>> # CONFIG_DEBUG_RT_MUTEXES is not set
>> # CONFIG_RT_MUTEX_TESTER is not set
>> # CONFIG_DEBUG_SPINLOCK is not set
>> # CONFIG_DEBUG_MUTEXES is not set
>> # CONFIG_DEBUG_LOCK_ALLOC is not set
>> # CONFIG_PROVE_LOCKING is not set
>> # CONFIG_PROVE_RCU_DELAY is not set
>> # CONFIG_SPARSE_RCU_POINTER is not set
>> # CONFIG_LOCK_STAT is not set
>> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
>> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
>> CONFIG_STACKTRACE=y
>> # CONFIG_DEBUG_STACK_USAGE is not set
>> # CONFIG_DEBUG_KOBJECT is not set
>> CONFIG_DEBUG_BUGVERBOSE=y
>> CONFIG_DEBUG_INFO=y
>> # CONFIG_DEBUG_INFO_REDUCED is not set
>> # CONFIG_DEBUG_VM is not set
>> # CONFIG_DEBUG_VIRTUAL is not set
>> # CONFIG_DEBUG_WRITECOUNT is not set
>> CONFIG_DEBUG_MEMORY_INIT=y
>> # CONFIG_DEBUG_LIST is not set
>> # CONFIG_TEST_LIST_SORT is not set
>> # CONFIG_DEBUG_SG is not set
>> # CONFIG_DEBUG_NOTIFIERS is not set
>> # CONFIG_DEBUG_CREDENTIALS is not set
>> CONFIG_ARCH_WANT_FRAME_POINTERS=y
>> # CONFIG_FRAME_POINTER is not set
>> CONFIG_BOOT_PRINTK_DELAY=y
>> # CONFIG_RCU_TORTURE_TEST is not set
>> CONFIG_RCU_CPU_STALL_TIMEOUT=60
>> CONFIG_RCU_CPU_STALL_VERBOSE=y
>> # CONFIG_RCU_CPU_STALL_INFO is not set
>> # CONFIG_RCU_TRACE is not set
>> # CONFIG_KPROBES_SANITY_TEST is not set
>> # CONFIG_BACKTRACE_SELF_TEST is not set
>> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
>> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
>> # CONFIG_DEBUG_PER_CPU_MAPS is not set
>> # CONFIG_LKDTM is not set
>> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
>> # CONFIG_FAULT_INJECTION is not set
>> # CONFIG_LATENCYTOP is not set
>> # CONFIG_DEBUG_PAGEALLOC is not set
>> CONFIG_USER_STACKTRACE_SUPPORT=y
>> CONFIG_NOP_TRACER=y
>> CONFIG_HAVE_FUNCTION_TRACER=y
>> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
>> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
>> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
>> CONFIG_HAVE_DYNAMIC_FTRACE=y
>> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
>> CONFIG_HAVE_FENTRY=y
>> CONFIG_HAVE_C_RECORDMCOUNT=y
>> CONFIG_TRACE_CLOCK=y
>> CONFIG_RING_BUFFER=y
>> CONFIG_EVENT_TRACING=y
>> CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
>> CONFIG_CONTEXT_SWITCH_TRACER=y
>> CONFIG_RING_BUFFER_ALLOW_SWAP=y
>> CONFIG_TRACING=y
>> CONFIG_GENERIC_TRACER=y
>> CONFIG_TRACING_SUPPORT=y
>> CONFIG_FTRACE=y
>> # CONFIG_FUNCTION_TRACER is not set
>> # CONFIG_IRQSOFF_TRACER is not set
>> # CONFIG_PREEMPT_TRACER is not set
>> # CONFIG_SCHED_TRACER is not set
>> # CONFIG_FTRACE_SYSCALLS is not set
>> CONFIG_BRANCH_PROFILE_NONE=y
>> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
>> # CONFIG_PROFILE_ALL_BRANCHES is not set
>> # CONFIG_STACK_TRACER is not set
>> CONFIG_BLK_DEV_IO_TRACE=y
>> # CONFIG_KPROBE_EVENT is not set
>> # CONFIG_UPROBE_EVENT is not set
>> # CONFIG_PROBE_EVENTS is not set
>> # CONFIG_FTRACE_STARTUP_TEST is not set
>> # CONFIG_MMIOTRACE is not set
>> # CONFIG_RING_BUFFER_BENCHMARK is not set
>> # CONFIG_RBTREE_TEST is not set
>> # CONFIG_INTERVAL_TREE_TEST is not set
>> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
>> # CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
>> # CONFIG_DYNAMIC_DEBUG is not set
>> # CONFIG_DMA_API_DEBUG is not set
>> # CONFIG_ATOMIC64_SELFTEST is not set
>> # CONFIG_ASYNC_RAID6_TEST is not set
>> # CONFIG_SAMPLES is not set
>> CONFIG_HAVE_ARCH_KGDB=y
>> # CONFIG_KGDB is not set
>> CONFIG_HAVE_ARCH_KMEMCHECK=y
>> # CONFIG_KMEMCHECK is not set
>> # CONFIG_TEST_KSTRTOX is not set
>> CONFIG_STRICT_DEVMEM=y
>> CONFIG_X86_VERBOSE_BOOTUP=y
>> CONFIG_EARLY_PRINTK=y
>> # CONFIG_EARLY_PRINTK_DBGP is not set
>> # CONFIG_DEBUG_STACKOVERFLOW is not set
>> # CONFIG_X86_PTDUMP is not set
>> CONFIG_DEBUG_RODATA=y
>> # CONFIG_DEBUG_RODATA_TEST is not set
>> CONFIG_DEBUG_SET_MODULE_RONX=y
>> # CONFIG_DEBUG_NX_TEST is not set
>> # CONFIG_DEBUG_TLBFLUSH is not set
>> # CONFIG_IOMMU_DEBUG is not set
>> # CONFIG_IOMMU_STRESS is not set
>> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
>> # CONFIG_X86_DECODER_SELFTEST is not set
>> CONFIG_IO_DELAY_TYPE_0X80=0
>> CONFIG_IO_DELAY_TYPE_0XED=1
>> CONFIG_IO_DELAY_TYPE_UDELAY=2
>> CONFIG_IO_DELAY_TYPE_NONE=3
>> CONFIG_IO_DELAY_0X80=y
>> # CONFIG_IO_DELAY_0XED is not set
>> # CONFIG_IO_DELAY_UDELAY is not set
>> # CONFIG_IO_DELAY_NONE is not set
>> CONFIG_DEFAULT_IO_DELAY_TYPE=0
>> # CONFIG_DEBUG_BOOT_PARAMS is not set
>> # CONFIG_CPA_DEBUG is not set
>> CONFIG_OPTIMIZE_INLINING=y
>> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
>> # CONFIG_DEBUG_NMI_SELFTEST is not set
>>
>> #
>> # Security options
>> #
>> CONFIG_KEYS=y
>> # CONFIG_TRUSTED_KEYS is not set
>> # CONFIG_ENCRYPTED_KEYS is not set
>> CONFIG_KEYS_DEBUG_PROC_KEYS=y
>> # CONFIG_SECURITY_DMESG_RESTRICT is not set
>> CONFIG_SECURITY=y
>> CONFIG_SECURITYFS=y
>> CONFIG_SECURITY_NETWORK=y
>> CONFIG_SECURITY_NETWORK_XFRM=y
>> CONFIG_SECURITY_PATH=y
>> CONFIG_INTEL_TXT=y
>> # CONFIG_SECURITY_SELINUX is not set
>> # CONFIG_SECURITY_TOMOYO is not set
>> # CONFIG_SECURITY_APPARMOR is not set
>> # CONFIG_SECURITY_YAMA is not set
>> # CONFIG_IMA is not set
>> # CONFIG_EVM is not set
>> CONFIG_DEFAULT_SECURITY_DAC=y
>> CONFIG_DEFAULT_SECURITY=""
>> CONFIG_XOR_BLOCKS=m
>> CONFIG_ASYNC_CORE=m
>> CONFIG_ASYNC_MEMCPY=m
>> CONFIG_ASYNC_XOR=m
>> CONFIG_ASYNC_PQ=m
>> CONFIG_ASYNC_RAID6_RECOV=m
>> CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
>> CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
>> CONFIG_CRYPTO=y
>>
>> #
>> # Crypto core or helper
>> #
>> CONFIG_CRYPTO_FIPS=y
>> CONFIG_CRYPTO_ALGAPI=y
>> CONFIG_CRYPTO_ALGAPI2=y
>> CONFIG_CRYPTO_AEAD=m
>> CONFIG_CRYPTO_AEAD2=y
>> CONFIG_CRYPTO_BLKCIPHER=m
>> CONFIG_CRYPTO_BLKCIPHER2=y
>> CONFIG_CRYPTO_HASH=y
>> CONFIG_CRYPTO_HASH2=y
>> CONFIG_CRYPTO_RNG=m
>> CONFIG_CRYPTO_RNG2=y
>> CONFIG_CRYPTO_PCOMP=m
>> CONFIG_CRYPTO_PCOMP2=y
>> CONFIG_CRYPTO_MANAGER=y
>> CONFIG_CRYPTO_MANAGER2=y
>> # CONFIG_CRYPTO_USER is not set
>> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>> CONFIG_CRYPTO_GF128MUL=m
>> CONFIG_CRYPTO_NULL=m
>> CONFIG_CRYPTO_PCRYPT=m
>> CONFIG_CRYPTO_WORKQUEUE=y
>> CONFIG_CRYPTO_CRYPTD=m
>> CONFIG_CRYPTO_AUTHENC=m
>> CONFIG_CRYPTO_TEST=m
>> CONFIG_CRYPTO_ABLK_HELPER_X86=m
>> CONFIG_CRYPTO_GLUE_HELPER_X86=m
>>
>> #
>> # Authenticated Encryption with Associated Data
>> #
>> CONFIG_CRYPTO_CCM=m
>> CONFIG_CRYPTO_GCM=m
>> CONFIG_CRYPTO_SEQIV=m
>>
>> #
>> # Block modes
>> #
>> CONFIG_CRYPTO_CBC=m
>> CONFIG_CRYPTO_CTR=m
>> CONFIG_CRYPTO_CTS=m
>> CONFIG_CRYPTO_ECB=m
>> CONFIG_CRYPTO_LRW=m
>> CONFIG_CRYPTO_PCBC=m
>> CONFIG_CRYPTO_XTS=m
>>
>> #
>> # Hash modes
>> #
>> CONFIG_CRYPTO_HMAC=m
>> CONFIG_CRYPTO_XCBC=m
>> CONFIG_CRYPTO_VMAC=m
>>
>> #
>> # Digest
>> #
>> CONFIG_CRYPTO_CRC32C=m
>> CONFIG_CRYPTO_CRC32C_INTEL=m
>> CONFIG_CRYPTO_GHASH=m
>> CONFIG_CRYPTO_MD4=m
>> CONFIG_CRYPTO_MD5=y
>> CONFIG_CRYPTO_MICHAEL_MIC=m
>> CONFIG_CRYPTO_RMD128=m
>> CONFIG_CRYPTO_RMD160=m
>> CONFIG_CRYPTO_RMD256=m
>> CONFIG_CRYPTO_RMD320=m
>> CONFIG_CRYPTO_SHA1=m
>> CONFIG_CRYPTO_SHA1_SSSE3=m
>> CONFIG_CRYPTO_SHA256=m
>> CONFIG_CRYPTO_SHA512=m
>> CONFIG_CRYPTO_TGR192=m
>> CONFIG_CRYPTO_WP512=m
>> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
>>
>> #
>> # Ciphers
>> #
>> CONFIG_CRYPTO_AES=y
>> CONFIG_CRYPTO_AES_X86_64=m
>> CONFIG_CRYPTO_AES_NI_INTEL=m
>> CONFIG_CRYPTO_ANUBIS=m
>> CONFIG_CRYPTO_ARC4=m
>> CONFIG_CRYPTO_BLOWFISH=m
>> CONFIG_CRYPTO_BLOWFISH_COMMON=m
>> CONFIG_CRYPTO_BLOWFISH_X86_64=m
>> CONFIG_CRYPTO_CAMELLIA=m
>> CONFIG_CRYPTO_CAMELLIA_X86_64=m
>> CONFIG_CRYPTO_CAST5=m
>> CONFIG_CRYPTO_CAST5_AVX_X86_64=m
>> CONFIG_CRYPTO_CAST6=m
>> CONFIG_CRYPTO_CAST6_AVX_X86_64=m
>> CONFIG_CRYPTO_DES=m
>> CONFIG_CRYPTO_FCRYPT=m
>> CONFIG_CRYPTO_KHAZAD=m
>> CONFIG_CRYPTO_SALSA20=m
>> CONFIG_CRYPTO_SALSA20_X86_64=m
>> CONFIG_CRYPTO_SEED=m
>> CONFIG_CRYPTO_SERPENT=m
>> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
>> CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
>> CONFIG_CRYPTO_TEA=m
>> CONFIG_CRYPTO_TWOFISH=m
>> CONFIG_CRYPTO_TWOFISH_COMMON=m
>> CONFIG_CRYPTO_TWOFISH_X86_64=m
>> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
>> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
>>
>> #
>> # Compression
>> #
>> CONFIG_CRYPTO_DEFLATE=m
>> CONFIG_CRYPTO_ZLIB=m
>> CONFIG_CRYPTO_LZO=y
>>
>> #
>> # Random Number Generation
>> #
>> CONFIG_CRYPTO_ANSI_CPRNG=m
>> CONFIG_CRYPTO_USER_API=m
>> CONFIG_CRYPTO_USER_API_HASH=m
>> CONFIG_CRYPTO_USER_API_SKCIPHER=m
>> CONFIG_CRYPTO_HW=y
>> CONFIG_CRYPTO_DEV_PADLOCK=m
>> CONFIG_CRYPTO_DEV_PADLOCK_AES=m
>> CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
>> CONFIG_ASYMMETRIC_KEY_TYPE=m
>> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
>> CONFIG_PUBLIC_KEY_ALGO_RSA=m
>> CONFIG_X509_CERTIFICATE_PARSER=m
>> CONFIG_HAVE_KVM=y
>> # CONFIG_VIRTUALIZATION is not set
>> CONFIG_BINARY_PRINTF=y
>>
>> #
>> # Library routines
>> #
>> CONFIG_RAID6_PQ=m
>> CONFIG_BITREVERSE=y
>> CONFIG_GENERIC_STRNCPY_FROM_USER=y
>> CONFIG_GENERIC_STRNLEN_USER=y
>> CONFIG_GENERIC_FIND_FIRST_BIT=y
>> CONFIG_GENERIC_PCI_IOMAP=y
>> CONFIG_GENERIC_IOMAP=y
>> CONFIG_GENERIC_IO=y
>> CONFIG_CRC_CCITT=m
>> CONFIG_CRC16=m
>> CONFIG_CRC_T10DIF=y
>> CONFIG_CRC_ITU_T=m
>> CONFIG_CRC32=y
>> # CONFIG_CRC32_SELFTEST is not set
>> CONFIG_CRC32_SLICEBY8=y
>> # CONFIG_CRC32_SLICEBY4 is not set
>> # CONFIG_CRC32_SARWATE is not set
>> # CONFIG_CRC32_BIT is not set
>> CONFIG_CRC7=m
>> CONFIG_LIBCRC32C=m
>> CONFIG_CRC8=m
>> CONFIG_ZLIB_INFLATE=y
>> CONFIG_ZLIB_DEFLATE=m
>> CONFIG_LZO_COMPRESS=y
>> CONFIG_LZO_DECOMPRESS=y
>> CONFIG_XZ_DEC=y
>> CONFIG_XZ_DEC_X86=y
>> CONFIG_XZ_DEC_POWERPC=y
>> CONFIG_XZ_DEC_IA64=y
>> CONFIG_XZ_DEC_ARM=y
>> CONFIG_XZ_DEC_ARMTHUMB=y
>> CONFIG_XZ_DEC_SPARC=y
>> CONFIG_XZ_DEC_BCJ=y
>> # CONFIG_XZ_DEC_TEST is not set
>> CONFIG_DECOMPRESS_GZIP=y
>> CONFIG_DECOMPRESS_BZIP2=y
>> CONFIG_DECOMPRESS_LZMA=y
>> CONFIG_DECOMPRESS_XZ=y
>> CONFIG_DECOMPRESS_LZO=y
>> CONFIG_GENERIC_ALLOCATOR=y
>> CONFIG_REED_SOLOMON=m
>> CONFIG_REED_SOLOMON_ENC8=y
>> CONFIG_REED_SOLOMON_DEC8=y
>> CONFIG_REED_SOLOMON_DEC16=y
>> CONFIG_TEXTSEARCH=y
>> CONFIG_TEXTSEARCH_KMP=m
>> CONFIG_TEXTSEARCH_BM=m
>> CONFIG_TEXTSEARCH_FSM=m
>> CONFIG_BTREE=y
>> CONFIG_HAS_IOMEM=y
>> CONFIG_HAS_IOPORT=y
>> CONFIG_HAS_DMA=y
>> CONFIG_CHECK_SIGNATURE=y
>> CONFIG_CPU_RMAP=y
>> CONFIG_DQL=y
>> CONFIG_NLATTR=y
>> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
>> CONFIG_LRU_CACHE=m
>> CONFIG_AVERAGE=y
>> CONFIG_CLZ_TAB=y
>> CONFIG_CORDIC=m
>> CONFIG_DDR=y
>> CONFIG_MPILIB=m
>> CONFIG_OID_REGISTRY=m
>>
> 
> 
