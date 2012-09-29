Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab2I2MzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 08:55:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34551 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2I2MzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 08:55:08 -0400
Message-ID: <5066EFA6.1090706@gmail.com>
Date: Sat, 29 Sep 2012 14:55:02 +0200
From: Gabor Takacs <gbrtakacs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PROBLEM: kernel 3.6.rc6 bug report (usb 3.0 external hard drive
 problem)
References: <505F2BD8.6090204@gmail.com> <20120928141639.GH5368@mwanda>
In-Reply-To: <20120928141639.GH5368@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dan,

thank you, I could not file the bugzilla report for some reason (can't
recall now why exactly).

The lsusb output is:

Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 004 Device 007: ID 1058:0730 Western Digital Technologies, Inc.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 002 Device 003: ID 04f2:b330 Chicony Electronics Co., Ltd

Regards,

Gabor

On 09/28/2012 04:16 PM, Dan Carpenter wrote:
> I've filed a bug for this.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=48061
>
> Probably the other information which would be useful is the output
> from lsusb.  Anyway, I've added the USB list to the CC.
>
> regards,
> dan carpenter
>
> On Sun, Sep 23, 2012 at 05:33:44PM +0200, Gabor Takacs wrote:
>> Bug report for kernel version 3.6.rc6
>>
>> Content of message:
>>
>> - One-line description
>> - Full description
>> - Keywords
>> - CPU info
>> - Modules info
>> - Kernel version
>> - Loaded driver and hardware information
>> - PCI information
>> - SCSI information
>>
>> One-line description: Western Digital My Passport USB 3.0 hard drive not
>> handled by kernel
>>
>> Full description: under 3.6.rc6 kernel on an Asus Zenbook Prime UX21A,
>> when plugging in my
>> Western Digital My Passport USB 3.0 hard drive, the system does not
>> mount it. It worked with
>> previous (3.4.x) kernels.
>>
>> # mount /dev/sdb1 /mnt
>> mount: special device /dev/sdb1 does not exist
>>
>> Running dmesg reveals the following:
>>
>> [  744.054410] usb 4-1: new SuperSpeed USB device number 7 using xhci_hcd
>> [  744.066695] usb 4-1: New USB device found, idVendor=1058, idProduct=0730
>> [  744.066705] usb 4-1: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  744.066710] usb 4-1: Product: My Passport 0730
>> [  744.066714] usb 4-1: Manufacturer: Western Digital
>> [  744.066718] usb 4-1: SerialNumber: 575846314139304E30363638
>> [  744.068280] scsi7 : usb-storage 4-1:1.0
>> [  755.053758] scsi 7:0:0:0: Direct-Access     WD       My Passport 0730
>> 1008 PQ: 0 ANSI: 6
>> [  755.054732] sd 7:0:0:0: [sdb] 976707584 512-byte logical blocks: (500
>> GB/465 GiB)
>> [  755.054901] sd 7:0:0:0: Attached scsi generic sg1 type 0
>> [  755.055009] sd 7:0:0:0: [sdb] Write Protect is off
>> [  755.055025] sd 7:0:0:0: [sdb] Mode Sense: 47 00 10 08
>> [  755.055451] sd 7:0:0:0: [sdb] No Caching mode page present
>> [  755.055462] sd 7:0:0:0: [sdb] Assuming drive cache: write through
>> [  755.056757] sd 7:0:0:0: [sdb] No Caching mode page present
>> [  755.056772] sd 7:0:0:0: [sdb] Assuming drive cache: write through
>> [  755.091464]  sdb: sdb1 sdb2
>> [  755.093493] sd 7:0:0:0: [sdb] No Caching mode page present
>> [  755.093503] sd 7:0:0:0: [sdb] Assuming drive cache: write through
>> [  755.093509] sd 7:0:0:0: [sdb] Attached SCSI disk
>> [  755.097771] usb 4-1: Disable of device-initiated U1 failed.
>> [  755.097854] usb 4-1: Disable of device-initiated U2 failed.
>> [  755.199967] usb 4-1: Device not responding to set address.
>> [  755.400520] usb 4-1: Device not responding to set address.
>> [  755.601230] usb 4-1: device not accepting address 7, error -71
>> [  755.703214] usb 4-1: Device not responding to set address.
>> [  755.903825] usb 4-1: Device not responding to set address.
>> [  756.104468] usb 4-1: device not accepting address 7, error -71
>> [  756.206429] usb 4-1: Device not responding to set address.
>> [  756.407090] usb 4-1: Device not responding to set address.
>> [  756.607692] usb 4-1: device not accepting address 7, error -71
>> [  756.709677] usb 4-1: Device not responding to set address.
>> [  756.910348] usb 4-1: Device not responding to set address.
>> [  757.110950] usb 4-1: device not accepting address 7, error -71
>> [  757.111010] usb 4-1: USB disconnect, device number 7
>> [  757.114782] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
>> with disabled ep ffff880036c07400
>> [  757.114794] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
>> with disabled ep ffff880036c073c0
>> [  757.216889] usb 4-1: Device not responding to set address.
>> [  757.417560] usb 4-1: Device not responding to set address.
>> [  757.618212] usb 4-1: device not accepting address 8, error -71
>>
>> (the last three lines keep repeating)
>>
>> Keywords: usb-storage, external usb hard disk
>>
>> System info follows.
>>
>> CPU info:
>>
>>> cat /proc/cpuinfo
>> processor    : 0
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 0
>> cpu cores    : 2
>> apicid        : 0
>> initial apicid    : 0
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor    : 1
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 1
>> cpu cores    : 2
>> apicid        : 2
>> initial apicid    : 2
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor    : 2
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 0
>> cpu cores    : 2
>> apicid        : 1
>> initial apicid    : 1
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor    : 3
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 1
>> cpu cores    : 2
>> apicid        : 3
>> initial apicid    : 3
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>>> cat /proc/cpuinfo
>> processor    : 0
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 0
>> cpu cores    : 2
>> apicid        : 0
>> initial apicid    : 0
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor    : 1
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 1
>> cpu cores    : 2
>> apicid        : 2
>> initial apicid    : 2
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor    : 2
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 0
>> cpu cores    : 2
>> apicid        : 1
>> initial apicid    : 1
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> processor    : 3
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 58
>> model name    : Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz
>> stepping    : 9
>> microcode    : 0x12
>> cpu MHz        : 800.000
>> cache size    : 4096 KB
>> physical id    : 0
>> siblings    : 4
>> core id        : 1
>> cpu cores    : 2
>> apicid        : 3
>> initial apicid    : 3
>> fpu        : yes
>> fpu_exception    : yes
>> cpuid level    : 13
>> wp        : yes
>> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
>> nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
>> ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer
>> aes xsave avx f16c rdrand lahf_lm ida arat epb xsaveopt pln pts dtherm
>> tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
>> bogomips    : 4788.82
>> clflush size    : 64
>> cache_alignment    : 64
>> address sizes    : 36 bits physical, 48 bits virtual
>> power management:
>>
>> Modules info:
>>
>>> cat /proc/modules
>> af_packet 39409 4 - Live 0xffffffffa066b000
>> usb_storage 61837 0 - Live 0xffffffffa05d2000
>> uvcvideo 84938 0 - Live 0xffffffffa0642000
>> videobuf2_core 35867 1 uvcvideo, Live 0xffffffffa0638000
>> videodev 124078 2 uvcvideo,videobuf2_core, Live 0xffffffffa05b2000
>> videobuf2_vmalloc 13020 1 uvcvideo, Live 0xffffffffa0595000
>> videobuf2_memops 13608 1 videobuf2_vmalloc, Live 0xffffffffa0590000
>> fuse 87099 3 - Live 0xffffffffa059b000
>> btusb 23870 0 - Live 0xffffffffa0664000
>> bluetooth 339925 1 btusb, Live 0xffffffffa05e4000
>> xt_LOG 17519 10 - Live 0xffffffffa058a000
>> xt_tcpudp 12884 2 - Live 0xffffffffa0585000
>> xt_limit 12711 10 - Live 0xffffffffa02ae000
>> xt_pkttype 12504 3 - Live 0xffffffffa0573000
>> snd_hda_codec_hdmi 40327 1 - Live 0xffffffffa057a000
>> snd_hda_codec_realtek 82090 1 - Live 0xffffffffa055d000
>> nf_conntrack_ipv6 14686 3 - Live 0xffffffffa0554000
>> nf_defrag_ipv6 18189 1 nf_conntrack_ipv6, Live 0xffffffffa054a000
>> ip6t_REJECT 12939 3 - Live 0xffffffffa0545000
>> ipt_REJECT 12541 3 - Live 0xffffffffa0540000
>> ip6table_raw 12683 1 - Live 0xffffffffa053b000
>> xt_NOTRACK 12504 4 - Live 0xffffffffa0536000
>> iptable_raw 12678 1 - Live 0xffffffffa0531000
>> iptable_filter 12810 1 - Live 0xffffffffa052c000
>> ip6table_mangle 12700 0 - Live 0xffffffffa0527000
>> nf_conntrack_netbios_ns 12665 0 - Live 0xffffffffa0522000
>> nf_conntrack_broadcast 12589 1 nf_conntrack_netbios_ns, Live
>> 0xffffffffa051d000
>> nf_conntrack_ipv4 15230 3 - Live 0xffffffffa0514000
>> nf_defrag_ipv4 12729 1 nf_conntrack_ipv4, Live 0xffffffffa049c000
>> ip_tables 27239 2 iptable_raw,iptable_filter, Live 0xffffffffa050c000
>> xt_conntrack 12760 6 - Live 0xffffffffa0497000
>> nf_conntrack 98251 6
>> nf_conntrack_ipv6,xt_NOTRACK,nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_conntrack_ipv4,xt_conntrack,
>> Live 0xffffffffa04f3000
>> ip6table_filter 12815 1 - Live 0xffffffffa03c5000
>> ip6_tables 27207 3 ip6table_raw,ip6table_mangle,ip6table_filter, Live
>> 0xffffffffa048f000
>> x_tables 33967 15
>> xt_LOG,xt_tcpudp,xt_limit,xt_pkttype,ip6t_REJECT,ipt_REJECT,ip6table_raw,xt_NOTRACK,iptable_raw,iptable_filter,ip6table_mangle,ip_tables,xt_conntrack,ip6table_filter,ip6_tables,
>> Live 0xffffffffa0485000
>> cpufreq_conservative 13783 0 - Live 0xffffffffa03c0000
>> arc4 12615 2 - Live 0xffffffffa0480000
>> nls_iso8859_1 12713 1 - Live 0xffffffffa0376000
>> nls_cp437 16991 1 - Live 0xffffffffa02f5000
>> iwldvm 250001 0 - Live 0xffffffffa04b4000
>> vfat 17461 1 - Live 0xffffffffa0370000
>> fat 65418 1 vfat, Live 0xffffffffa04a3000
>> mac80211 608717 1 iwldvm, Live 0xffffffffa03ea000
>> iwlwifi 109123 1 iwldvm, Live 0xffffffffa03ce000
>> cfg80211 217590 3 iwldvm,mac80211,iwlwifi, Live 0xffffffffa0389000
>> snd_hda_intel 37618 2 - Live 0xffffffffa037e000
>> snd_hda_codec 142555 3
>> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live
>> 0xffffffffa02d1000
>> snd_hwdep 13602 1 snd_hda_codec, Live 0xffffffffa0296000
>> snd_pcm 109508 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
>> 0xffffffffa02b5000
>> snd_seq 69746 0 - Live 0xffffffffa029b000
>> snd_timer 29370 2 snd_pcm,snd_seq, Live 0xffffffffa028d000
>> snd_seq_device 14497 1 snd_seq, Live 0xffffffffa0204000
>> snd 91302 13
>> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_timer,snd_seq_device,
>> Live 0xffffffffa026b000
>> iTCO_wdt 13480 0 - Live 0xffffffffa0266000
>> sg 36486 0 - Live 0xffffffffa025c000
>> iTCO_vendor_support 13718 1 iTCO_wdt, Live 0xffffffffa0252000
>> soundcore 15047 1 snd, Live 0xffffffffa0257000
>> i2c_i801 18134 0 - Live 0xffffffffa01f1000
>> lpc_ich 17061 0 - Live 0xffffffffa020b000
>> mei 79580 0 - Live 0xffffffffa023d000
>> snd_page_alloc 18484 2 snd_hda_intel,snd_pcm, Live 0xffffffffa01d0000
>> mfd_core 13398 1 lpc_ich, Live 0xffffffffa01cb000
>> asus_nb_wmi 12854 0 - Live 0xffffffffa01a8000
>> asus_wmi 28309 1 asus_nb_wmi, Live 0xffffffffa01fc000
>> sparse_keymap 13890 1 asus_wmi, Live 0xffffffffa01f7000
>> acpi_cpufreq 18857 0 - Live 0xffffffffa01eb000
>> rfkill 26009 5 bluetooth,cfg80211,asus_wmi, Live 0xffffffffa01c3000
>> mperf 12667 1 acpi_cpufreq, Live 0xffffffffa01d8000
>> coretemp 13393 0 - Live 0xffffffffa01be000
>> pci_hotplug 35159 1 asus_wmi, Live 0xffffffffa0283000
>> kvm_intel 136957 0 - Live 0xffffffffa021a000
>> kvm 459260 1 kvm_intel, Live 0xffffffffa02fe000
>> crc32c_intel 12901 0 - Live 0xffffffffa01b3000
>> ghash_clmulni_intel 13180 0 - Live 0xffffffffa0215000
>> aesni_intel 50892 0 - Live 0xffffffffa01dd000
>> ablk_helper 13597 1 aesni_intel, Live 0xffffffffa01b9000
>> cryptd 16306 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
>> 0xffffffffa01a3000
>> aes_x86_64 17208 1 aesni_intel, Live 0xffffffffa01ad000
>> pcspkr 12718 0 - Live 0xffffffffa0087000
>> serio_raw 13375 0 - Live 0xffffffffa007d000
>> joydev 17457 0 - Live 0xffffffffa019d000
>> wmi 19070 1 asus_wmi, Live 0xffffffffa0197000
>> battery 22827 0 - Live 0xffffffffa00b1000
>> ac 13132 0 - Live 0xffffffffa0082000
>> cpufreq_userspace 13162 0 - Live 0xffffffffa0069000
>> cpufreq_powersave 12618 4 - Live 0xffffffffa0055000
>> microcode 35783 0 - Live 0xffffffffa0073000
>> autofs4 42753 2 - Live 0xffffffffa0049000
>> thermal 18669 0 - Live 0xffffffffa0043000
>> i915 572031 3 - Live 0xffffffffa010a000
>> drm_kms_helper 50838 1 i915, Live 0xffffffffa005b000
>> drm 287755 4 i915,drm_kms_helper, Live 0xffffffffa00c2000
>> i2c_algo_bit 13413 1 i915, Live 0xffffffffa003e000
>> button 13945 1 i915, Live 0xffffffffa006e000
>> video 19345 2 asus_wmi,i915, Live 0xffffffffa00bc000
>> xhci_hcd 147259 0 - Live 0xffffffffa008c000
>> processor 44949 1 acpi_cpufreq, Live 0xffffffffa0032000
>> thermal_sys 24859 3 thermal,video,processor, Live 0xffffffffa0026000
>> scsi_dh_alua 17161 0 - Live 0xffffffffa0020000
>> scsi_dh_hp_sw 12894 0 - Live 0xffffffffa0018000
>> scsi_dh_rdac 17408 0 - Live 0xffffffffa0012000
>> scsi_dh_emc 17258 0 - Live 0xffffffffa0009000
>> scsi_dh 14800 4 scsi_dh_alua,scsi_dh_hp_sw,scsi_dh_rdac,scsi_dh_emc,
>> Live 0xffffffffa0000000
>>
>> Kernel version:
>>
>>> cat /proc/version
>> Linux version 3.6.0-rc6-3-desktop (geeko@buildhost) (gcc version 4.7.1
>> 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT
>> Thu Sep 20 14:23:37 UTC 2012 (33eb1e6)
>>
>> Loaded driver and hardware information:
>>
>>> cat /proc/ioports
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
>>   0200-020f : pnp 00:05
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
>>   04d0-04d1 : pnp 00:08
>>   0500-057f : pnp 00:05
>>   0680-069f : pnp 00:05
>> 0cf8-0cff : PCI conf1
>> 0d00-ffff : PCI Bus 0000:00
>>   164e-164f : pnp 00:05
>>   f000-f03f : 0000:00:02.0
>>   f040-f05f : 0000:00:1f.3
>>   f060-f07f : 0000:00:1f.2
>>     f060-f07f : ahci
>>   f080-f083 : 0000:00:1f.2
>>     f080-f083 : ahci
>>   f090-f097 : 0000:00:1f.2
>>     f090-f097 : ahci
>>   f0a0-f0a3 : 0000:00:1f.2
>>     f0a0-f0a3 : ahci
>>   f0b0-f0b7 : 0000:00:1f.2
>>     f0b0-f0b7 : ahci
>>   ffff-ffff : pnp 00:05
>>     ffff-ffff : pnp 00:05
>>
>>> cat /proc/iomem
>> 00000000-0000ffff : reserved
>> 00010000-0009efff : System RAM
>> 0009f000-0009ffff : reserved
>> 000a0000-000bffff : PCI Bus 0000:00
>> 000c0000-000cefff : Video ROM
>> 000d0000-000d3fff : PCI Bus 0000:00
>> 000d4000-000d7fff : PCI Bus 0000:00
>> 000d8000-000dbfff : PCI Bus 0000:00
>> 000dc000-000dffff : PCI Bus 0000:00
>> 000f0000-000fffff : System ROM
>> 00100000-1fffffff : System RAM
>>   01000000-015bcb4b : Kernel code
>>   015bcb4c-01ab39ff : Kernel data
>>   01bad000-01d79fff : Kernel bss
>> 20000000-201fffff : reserved
>>   20000000-201fffff : pnp 00:0e
>> 20200000-40003fff : System RAM
>> 40004000-40004fff : reserved
>>   40004000-40004fff : pnp 00:0e
>> 40005000-d57c1fff : System RAM
>> d57c2000-d5dc2fff : ACPI Non-volatile Storage
>> d5dc3000-d5dc5fff : reserved
>> d5dc6000-d5ddafff : System RAM
>> d5ddb000-d5de0fff : reserved
>> d5de1000-d5de2fff : System RAM
>> d5de3000-d5de7fff : reserved
>> d5de8000-d5f40fff : System RAM
>> d5f41000-d5f44fff : reserved
>> d5f45000-d5f8efff : System RAM
>> d5f8f000-d5f95fff : reserved
>> d5f96000-d5f97fff : System RAM
>> d5f98000-d5fb5fff : reserved
>> d5fb6000-d5fb8fff : System RAM
>> d5fb9000-d5fbafff : reserved
>> d5fbb000-d5fd1fff : System RAM
>> d5fd2000-d5fd7fff : reserved
>> d5fd8000-d5fdffff : System RAM
>> d5fe0000-d5fe0fff : reserved
>> d5fe1000-d5feffff : System RAM
>> d5ff0000-d5ff0fff : reserved
>> d5ff1000-d5ffbfff : System RAM
>> d5ffc000-d6000fff : reserved
>> d6001000-d601efff : System RAM
>> d601f000-d6020fff : reserved
>> d6021000-d6034fff : System RAM
>> d6035000-d6035fff : reserved
>> d6036000-d6047fff : System RAM
>> d6048000-d606dfff : reserved
>> d606e000-d6081fff : System RAM
>> d6082000-d6082fff : reserved
>> d6083000-d6083fff : System RAM
>> d6084000-d6085fff : reserved
>> d6086000-d6086fff : System RAM
>> d6087000-d608bfff : reserved
>> d608c000-d60a0fff : System RAM
>> d60a1000-d6644fff : reserved
>> d6645000-d68c4fff : ACPI Non-volatile Storage
>> d68c5000-d68c9fff : ACPI Tables
>> d68ca000-d68cafff : System RAM
>> d68cb000-d690dfff : ACPI Non-volatile Storage
>> d690e000-d6d1cfff : System RAM
>> d6d1d000-d6ff3fff : reserved
>> d6ff4000-d6ffffff : System RAM
>> d7000000-d7bfffff : RAM buffer
>> d7c00000-dfdfffff : reserved
>> dfe00000-feafffff : PCI Bus 0000:00
>>   dfe00000-dfe00fff : pnp 00:0c
>>     dfe00000-dfe00fff : pnp 00:0d
>>   dfe08000-dfe0ffff : 0000:00:04.0
>>   e0000000-efffffff : 0000:00:02.0
>>   f7800000-f7bfffff : 0000:00:02.0
>>   f7c00000-f7cfffff : PCI Bus 0000:02
>>     f7c00000-f7c01fff : 0000:02:00.0
>>       f7c00000-f7c01fff : iwlwifi
>>   f7d00000-f7d0ffff : 0000:00:14.0
>>     f7d00000-f7d0ffff : xhci_hcd
>>   f7d18000-f7d1bfff : 0000:00:1b.0
>>     f7d18000-f7d1bfff : ICH HD audio
>>   f7d1c000-f7d1cfff : 0000:00:1f.6
>>   f7d1d000-f7d1d0ff : 0000:00:1f.3
>>   f7d1e000-f7d1e7ff : 0000:00:1f.2
>>     f7d1e000-f7d1e7ff : ahci
>>   f7d1f000-f7d1f3ff : 0000:00:1d.0
>>     f7d1f000-f7d1f3ff : ehci_hcd
>>   f7d20000-f7d203ff : 0000:00:1a.0
>>     f7d20000-f7d203ff : ehci_hcd
>>   f7d22000-f7d2200f : 0000:00:16.0
>>     f7d22000-f7d2200f : mei
>>   f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
>>     f8000000-fbffffff : reserved
>>       f8000000-fbffffff : pnp 00:0c
>> fec00000-fec00fff : reserved
>>   fec00000-fec003ff : IOAPIC 0
>> fed00000-fed03fff : reserved
>>   fed00000-fed003ff : HPET 0
>> fed10000-fed17fff : pnp 00:0c
>> fed18000-fed18fff : pnp 00:0c
>> fed19000-fed19fff : pnp 00:0c
>> fed1c000-fed1ffff : reserved
>>   fed1c000-fed1ffff : pnp 00:0c
>>     fed1f410-fed1f414 : iTCO_wdt
>>       fed1f410-fed1f414 : iTCO_wdt
>> fed20000-fed3ffff : pnp 00:0c
>> fed40000-fed44fff : pnp 00:01
>> fed45000-fed8ffff : pnp 00:0c
>> fed90000-fed90fff : dmar0
>> fed91000-fed91fff : dmar1
>> fee00000-fee00fff : Local APIC
>>   fee00000-fee00fff : reserved
>> ff000000-ffffffff : reserved
>>   ff000000-ffffffff : pnp 00:0c
>> 100000000-11f1fffff : System RAM
>> 11f200000-11fffffff : RAM buffer
>>
>> PCI information:
>>
>> # lspci -vvv
>> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
>> Controller (rev 09)
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort+ >SERR- <PERR- INTx-
>>     Latency: 0
>>     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>
>> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
>> processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Interrupt: pin A routed to IRQ 44
>>     Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]
>>     Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
>>     Region 4: I/O ports at f000 [size=64]
>>     Expansion ROM at <unassigned> [disabled]
>>     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>         Address: fee00018  Data: 0000
>>     Capabilities: [d0] Power Management version 2
>>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>     Capabilities: [a4] PCI Advanced Features
>>         AFCap: TP+ FLR+
>>         AFCtrl: FLR-
>>         AFStatus: TP-
>>     Kernel driver in use: i915
>>
>> 00:04.0 Signal processing controller: Intel Corporation Device 0153 (rev 09)
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Interrupt: pin A routed to IRQ 11
>>     Region 0: Memory at dfe08000 (64-bit, non-prefetchable) [size=32K]
>>     Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
>>         Address: 00000000  Data: 0000
>>     Capabilities: [d0] Power Management version 3
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>
>> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
>> Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Interrupt: pin A routed to IRQ 43
>>     Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=64K]
>>     Capabilities: [70] Power Management version 2
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>>         Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
>>     Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
>>         Address: 00000000fee00318  Data: 0000
>>     Kernel driver in use: xhci_hcd
>>
>> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series
>> Chipset Family MEI Controller #1 (rev 04)
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Interrupt: pin A routed to IRQ 45
>>     Region 0: Memory at f7d22000 (64-bit, non-prefetchable) [size=16]
>>     Capabilities: [50] Power Management version 3
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>     Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>         Address: 00000000fee00358  Data: 0000
>>     Kernel driver in use: mei
>>
>> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
>> Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Interrupt: pin A routed to IRQ 16
>>     Region 0: Memory at f7d20000 (32-bit, non-prefetchable) [size=1K]
>>     Capabilities: [50] Power Management version 2
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
>>     Capabilities: [58] Debug port: BAR=1 offset=00a0
>>     Capabilities: [98] PCI Advanced Features
>>         AFCap: TP+ FLR+
>>         AFCtrl: FLR-
>>         AFStatus: TP-
>>     Kernel driver in use: ehci_hcd
>>
>> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
>> Family High Definition Audio Controller (rev 04)
>>     Subsystem: ASUSTeK Computer Inc. Device 1c43
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0, Cache Line Size: 64 bytes
>>     Interrupt: pin A routed to IRQ 46
>>     Region 0: Memory at f7d18000 (64-bit, non-prefetchable) [size=16K]
>>     Capabilities: [50] Power Management version 2
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>         Address: 00000000fee00398  Data: 0000
>>     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>>         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>             ExtTag- RBE- FLReset+
>>         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>             MaxPayload 128 bytes, MaxReadReq 128 bytes
>>         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>         LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown,
>> Latency L0 <64ns, L1 <1us
>>             ClockPM- Surprise- LLActRep- BwNot-
>>         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
>>             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>         LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk-
>> DLActive- BWMgmt- ABWMgmt-
>>     Capabilities: [100 v1] Virtual Channel
>>         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
>>         Arb:    Fixed- WRR32- WRR64- WRR128-
>>         Ctrl:    ArbSelect=Fixed
>>         Status:    InProgress-
>>         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>>             Status:    NegoPending- InProgress-
>>         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>             Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=22
>>             Status:    NegoPending- InProgress-
>>     Capabilities: [130 v1] Root Complex Link
>>         Desc:    PortNumber=0f ComponentID=00 EltType=Config
>>         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB-
>> LinkType=MemMapped LinkValid+
>>             Addr:    00000000fed1c000
>>     Kernel driver in use: snd_hda_intel
>>
>> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
>> Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0, Cache Line Size: 64 bytes
>>     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>     I/O behind bridge: 0000f000-00000fff
>>     Memory behind bridge: fff00000-000fffff
>>     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort+ <SERR- <PERR-
>>     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>             ExtTag- RBE+ FLReset-
>>         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>             MaxPayload 128 bytes, MaxReadReq 128 bytes
>>         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>         LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency
>> L0 <1us, L1 <16us
>>             ClockPM- Surprise- LLActRep+ BwNot-
>>         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surprise-
>>             Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
>>         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>             Changed: MRL- PresDet- LinkState-
>>         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>         RootCap: CRSVisible-
>>         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -6dB
>>              Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>              Compliance De-emphasis: -6dB
>>         LnkSta2: Current De-emphasis Level: -3.5dB,
>> EqualizationComplete-, EqualizationPhase1-
>>              EqualizationPhase2-, EqualizationPhase3-,
>> LinkEqualizationRequest-
>>     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>         Address: 00000000  Data: 0000
>>     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Capabilities: [a0] Power Management version 2
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
>>     Kernel driver in use: pcieport
>>
>> 00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
>> Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0, Cache Line Size: 64 bytes
>>     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>     I/O behind bridge: 0000f000-00000fff
>>     Memory behind bridge: f7c00000-f7cfffff
>>     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort+ <SERR- <PERR-
>>     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
>>         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>             ExtTag- RBE+ FLReset-
>>         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>             MaxPayload 128 bytes, MaxReadReq 128 bytes
>>         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
>> TransPend-
>>         LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency
>> L0 <512ns, L1 <16us
>>             ClockPM- Surprise- LLActRep+ BwNot-
>>         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
>> DLActive+ BWMgmt+ ABWMgmt-
>>         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surprise-
>>             Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
>>         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
>>         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
>> Interlock-
>>             Changed: MRL- PresDet- LinkState+
>>         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>         RootCap: CRSVisible-
>>         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
>>         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
>>         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
>> Selectable De-emphasis: -6dB
>>              Transmit Margin: Normal Operating Range,
>> EnterModifiedCompliance- ComplianceSOS-
>>              Compliance De-emphasis: -6dB
>>         LnkSta2: Current De-emphasis Level: -3.5dB,
>> EqualizationComplete-, EqualizationPhase1-
>>              EqualizationPhase2-, EqualizationPhase3-,
>> LinkEqualizationRequest-
>>     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>>         Address: 00000000  Data: 0000
>>     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Capabilities: [a0] Power Management version 2
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>     Kernel driver in use: pcieport
>>
>> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
>> Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Interrupt: pin A routed to IRQ 23
>>     Region 0: Memory at f7d1f000 (32-bit, non-prefetchable) [size=1K]
>>     Capabilities: [50] Power Management version 2
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
>>     Capabilities: [58] Debug port: BAR=1 offset=00a0
>>     Capabilities: [98] PCI Advanced Features
>>         AFCap: TP+ FLR+
>>         AFCtrl: FLR-
>>         AFStatus: TP-
>>     Kernel driver in use: ehci_hcd
>>
>> 00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
>> Controller (rev 04)
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>>     Kernel driver in use: lpc_ich
>>
>> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
>> 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Interrupt: pin B routed to IRQ 42
>>     Region 0: I/O ports at f0b0 [size=8]
>>     Region 1: I/O ports at f0a0 [size=4]
>>     Region 2: I/O ports at f090 [size=8]
>>     Region 3: I/O ports at f080 [size=4]
>>     Region 4: I/O ports at f060 [size=32]
>>     Region 5: Memory at f7d1e000 (32-bit, non-prefetchable) [size=2K]
>>     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>         Address: fee002f8  Data: 0000
>>     Capabilities: [70] Power Management version 3
>>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>>         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>     Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
>>     Capabilities: [b0] PCI Advanced Features
>>         AFCap: TP+ FLR+
>>         AFCtrl: FLR-
>>         AFStatus: TP-
>>     Kernel driver in use: ahci
>>
>> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
>> SMBus Controller (rev 04)
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Interrupt: pin C routed to IRQ 18
>>     Region 0: Memory at f7d1d000 (64-bit, non-prefetchable) [size=256]
>>     Region 4: I/O ports at f040 [size=32]
>>
>> 00:1f.6 Signal processing controller: Intel Corporation 7 Series/C210
>> Series Chipset Family Thermal Management Controller (rev 04)
>>     Subsystem: ASUSTeK Computer Inc. Device 1517
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0
>>     Interrupt: pin C routed to IRQ 10
>>     Region 0: Memory at f7d1c000 (64-bit, non-prefetchable) [size=4K]
>>     Capabilities: [50] Power Management version 3
>>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>
>> 02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235
>> (rev 24)
>>     Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0, Cache Line Size: 64 bytes
>>     Interrupt: pin A routed to IRQ 47
>>     Region 0: Memory at f7c00000 (64-bit, non-prefetchable) [size=8K]
>>     Capabilities: [c8] Power Management version 3
>>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>         Address: 00000000fee003b8  Data: 0000
>>     Capabilities: [e0] Express (v1) Endpoint, MSI 00
>>         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>> <512ns, L1 unlimited
>>             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>>         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>>             MaxPayload 128 bytes, MaxReadReq 128 bytes
>>         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
>> TransPend-
>>         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <4us, L1 <32us
>>             ClockPM+ Surprise- LLActRep- BwNot-
>>         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>     Capabilities: [100 v1] Advanced Error Reporting
>>         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
>> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
>> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>>         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
>> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>>         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>>         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
>>     Capabilities: [140 v1] Device Serial Number c4-85-08-ff-ff-2b-7d-9d
>>     Kernel driver in use: iwlwifi
>>
>> SCSI information:
>>
>> # cat /proc/scsi/scsi
>> Attached devices:
>> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>>   Vendor: ATA      Model: SanDisk SSD U100 Rev: 10.5
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>
>>
>> -- 
>> Gabor Takacs
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Gabor Takacs

