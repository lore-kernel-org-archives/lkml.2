Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2LSKOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:14:44 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:19360 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2LSKOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:14:37 -0500
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>
Subject: RE: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Topic: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Index: Ac3dBDEGb3itVOfRRseMR0luplSOQwAQ8+AAACEggUA=
Date: Wed, 19 Dec 2012 10:13:50 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F91F2210@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
 <CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
In-Reply-To: <CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai , 
	Thanks very much for your reply. I also checked some other previous emails about x2apic patches.

> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu

I just worry about this case, 
> > b) If BIOS feel the system doesn't meet x2apic conditions , it will not set
> x2apic enablement bit in MSR ,and pass control to OS with xapic mode.
> 
> kernel will check if cpuid support x2apic, if it supports x2apic, it will check if
> DMAR/intr-remapping could be enabled, if so kernel will switch to x2apic.
> otherwise it will stay with xapic.
> 
> So you need to make cpuid show does not support x2apic --- check with intel
> they have way to do that.
My concerns is BIOS creates different ACPI tables in xAPIC mode and X2APIC mode. 
BIOS will auto detect if the system meets x2APIC condition , if no , it will not create right ACPI tables for this mode and don't set MSR bit.
For this case (BIOS didn't set MSR , but BSP supports x2apic ) , I want to know 
1, For Linux kernel, which ACPI tables will be used for x2apic and XAPIC ?
2, why Linux kernel will set x2apic enablement bit in CPU msr ? generally speaking , BIOS set it and OS get it.
If OS get it , who will read it ? BIOS ?  I consult BIOS designer , he said , their BIOS calling service(just like UEFI run time service)
will also judge MSR again , so I don't know why Linux kernel will set MSR bit , unless OS has special target . 

> or you can pass "nox2apic" in boot command line.
Yeah, I think this would be fine if we really want to use xAPIC mode instead of x2apic mode.
But I am puzzled why Linux kernel will force to enter x2apic just depends on BSP has supported x2apic ? 
"BSP supports x2apic" condition is enough for judging if OS can enable x2apic ? 


Thanks very much ! 

