Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1KKSOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:14:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61062 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1KKSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:14:16 -0500
Message-ID: <4EBD65F5.8090808@lwfinger.net>
Date: Fri, 11 Nov 2011 12:14:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: USB list <linux-usb@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: nommu warning message
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the driver rtl8192cu (a USB wireless device), the current version loads the 
15KB firmware asynchronously one 32-bit quantity at a time. Although 
inefficient. this method works with USB 1.1 and USB 2.0 adapters; however, it 
fails on at least one USB 3.0 adapter with "xhci_hcd 0000:05:00.0: ERROR no room 
on ep ring" errors.

These errors are believed to arise from small, fixed-size ep rings. There is a 
vendor driver that works with that same hardware. The major difference is that 
it uses synchronous block writes of 254 bytes. When I tried this with the 
in-kernel driver, each block write yields a warning as shown below:

nommu_map_single: overflow 41000340d020+254 of device mask ffffffff

The only remaining difference between the two drivers is that the vendor version 
uses firmware hard coded into the driver while the kernel version uses a file 
from /lib/firmware.

My cpu info is:

----- /proc/cpuinfo -----
   processor     : 0
   vendor_id     : AuthenticAMD
   cpu family    : 15
   model         : 104
   model name    : AMD Turion(tm) 64 X2 TL-60
   stepping      : 2
   cpu MHz               : 2000.000
   cache size    : 512 KB
   physical id   : 0
   siblings      : 2
   core id               : 0
   cpu cores     : 2
   apicid                : 0
   initial apicid        : 0
   fpu           : yes
   fpu_exception : yes
   cpuid level   : 1
   wp            : yes
   flags         : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 
3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic 
cr8_legacy 3dnowprefetch lbrv
   bogomips      : 4001.06
   TLB size      : 1024 4K pages
   clflush size  : 64
   cache_alignment       : 64
   address sizes : 40 bits physical, 48 bits virtual
   power management: ts fid vid ttp tm stc 100mhzsteps


Could someone please explain the meaning of the above messages? Even with them 
present, the device works.

Thanks,

Larry
