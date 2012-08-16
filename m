Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2HPNfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:35:18 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42195 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2HPNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:35:16 -0400
Date: Thu, 16 Aug 2012 09:35:12 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Message-ID: <711271179.1776875.1345124112800.JavaMail.root@redhat.com>
In-Reply-To: <1104118228.1760802.1345121009530.JavaMail.root@redhat.com>
Subject: x86, nops settings result in kernel crash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.27.4]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing a file system test which I execute in qemu with kernel compiled from latest git sources and running it causes this error:

https://bugzilla.kernel.org/show_bug.cgi?id=45971

It works with v3.5, so I ran git bisect which pointed me to:

d6250a3f12edb3a86db9598ffeca3de8b4a219e9 x86, nops: Missing break resulting in incorrect selection on Intel

To be quite honest, I don't understand this stuff much but I tried to do some debugging and I figured out (I hope) that the crash is caused by setting ideal_nops to p6_nops (k8_nops was used before the break statement was added).

Here is cpuinfo from guest machine:

[root@test ~]# cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 2
model name      : QEMU Virtual CPU version 0.15.1
stepping        : 3
microcode       : 0x1
cpu MHz         : 2591.580
cache size      : 4096 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 4
wp              : yes
flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 clflush mmx fxsr sse sse2 syscall nx lm up rep_good nopl pni cx16 popcnt hypervisor lahf_lm
bogomips        : 5183.16
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual

And from host machine:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz
stepping        : 7
microcode       : 0x28
cpu MHz         : 800.000
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 5183.17
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

If I use "qemu-kvm -cpu host", it works correctly. I hope you'll find something useful in it. 
Thanks for your time.

Regards,
Tomas
