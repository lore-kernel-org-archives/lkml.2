Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1EBVK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:10:28 -0400
Received: from christianhoffmann.info ([88.175.101.52]:49092 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1EBVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:10:27 -0400
Message-ID: <4DBF1DBD.40108@christianhoffmann.info>
Date: Mon, 02 May 2011 23:10:21 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info> <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>
In-Reply-To: <4DBF1725.3030800@christianhoffmann.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 10:42 PM, Christian Hoffmann wrote:
> Hi,
>
>> Hrm. So, on older kernels, what do you see from:
>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>
> On older and newer kernel I see the same output:
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> tsc hpet acpi_pm
>
>>
>> Hrm. The delay in the dmesg logs doesn't really seem to correlate that
>> closely with the delayed tsc calibration. Hrmm..

I also ran it now with calltrace_debug:

[    1.451920] NET: Registered protocol family 2
[    1.452077] IP route cache hash table entries: 262144 (order: 9, 
2097152 bytes)
[    1.453060] TCP established hash table entries: 524288 (order: 11, 
8388608 bytes)
[    1.454859] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.455078] TCP: Hash tables configured (established 524288 bind 65536)
[    1.455079] TCP reno registered
[    1.455090] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.455132] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.455241] initcall inet_init+0x0/0x24a returned 0 after 3257 usecs
[    1.455243] calling  af_unix_init+0x0/0x55 @ 1
[    1.455245] NET: Registered protocol family 1
[    1.455251] initcall af_unix_init+0x0/0x55 returned 0 after 4 usecs
[    1.455253] calling  pci_apply_final_quirks+0x0/0x105 @ 1
[    1.455259] pci 0000:00:01.0: MSI quirk detected; subordinate MSI 
disabled
[  146.830206] pci 0000:01:05.0: Boot video device
[  146.830219] PCI: CLS 64 bytes, default 64
[  146.830224] initcall pci_apply_final_quirks+0x0/0x105 returned 0 
after 141967734 usecs
[  146.830227] calling  populate_rootfs+0x0/0x24 @ 1
[  146.830231] initcall populate_rootfs+0x0/0x24 returned 801341486 
after 0 usecs
[  146.830233] initcall populate_rootfs+0x0/0x24 returned with error 
code 801341486
[  146.830236] calling  pci_iommu_init+0x0/0x41 @ 1
[  146.831483] PCI-DMA: Disabling AGP.
[  146.831625] PCI-DMA: aperture base @ c4000000 size 65536 KB
[  146.831627] PCI-DMA: using GART IOMMU.
[  146.831629] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[  146.834920] initcall pci_iommu_init+0x0/0x41 returned 0 after 4571 usecs
[  146.834924] calling  calgary_fixup_tce_spaces+0x0/0xf0 @ 1
[  146.834928] initcall calgary_fixup_tce_spaces+0x0/0xf0 returned -19 
after 0 usecs
[  146.834930] calling  i8259A_init_sysfs+0x0/0x31 @ 1
[  146.834949] initcall i8259A_init_sysfs+0x0/0x31 returned 0 after 15 usecs
[  146.834951] calling  vsyscall_init+0x0/0x66 @ 1
[  146.835020] initcall vsyscall_init+0x0/0x66 returned 0 after 65 usecs
[  146.835023] calling  sbf_init+0x0/0xf4 @ 1
[  146.835026] initcall sbf_init+0x0/0xf4 returned 0 after 0 usecs
[  146.835028] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[  146.835037] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 6 usecs
[  146.835039] calling  init_tsc_clocksource+0x0/0x5f @ 1
[  146.835049] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 6 
usecs
[  146.835051] calling  add_rtc_cmos+0x0/0x96 @ 1
[  146.835056] initcall add_rtc_cmos+0x0/0x96 returned 0 after 1 usecs
[  146.835059] calling  cache_sysfs_init+0x0/0x5e @ 1
[  146.835292] initcall cache_sysfs_init+0x0/0x5e returned 0 after 225 usecs
[  146.835295] calling  mcheck_init_device+0x0/0xfd @ 1
[  146.835422] initcall mcheck_init_device+0x0/0xfd returned 0 after 120 
usecs
[  146.835424] calling  threshold_init_device+0x0/0x56 @ 1
[  146.835480] initcall threshold_init_device+0x0/0x56 returned 0 after 
51 usecs
[  146.835483] calling  thermal_throttle_init_device+0x0/0x9c @ 1


Rgds,
Chris
