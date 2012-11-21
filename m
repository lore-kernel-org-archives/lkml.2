Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2KUSgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:36:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36476 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2KUSgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:36:02 -0500
Message-ID: <50AD1EE7.6020304@oracle.com>
Date: Wed, 21 Nov 2012 13:35:19 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH] x86, smpboot: allow manual hotplug of CPUs
References: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com> <50AD1CB6.9030707@zytor.com>
In-Reply-To: <50AD1CB6.9030707@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 01:25 PM, H. Peter Anvin wrote:
> On 11/21/2012 10:22 AM, Sasha Levin wrote:
>> So far CPU hotplug was ignored for mptable implementations which support it by
>> having the hotpluggable CPUs marked as disabled during boot.
>>
>> The current kernel code detects that behaviour and actually deals with it
>> properly:
>>
>> 	[    0.000000] Intel MultiProcessor Specification v1.4
>> 	[    0.000000] MPTABLE: OEM ID: KVMCPU00
>> 	[    0.000000] MPTABLE: Product ID: 0.1
>> 	[    0.000000] MPTABLE: APIC at: 0xFEE00000
>> 	[    0.000000] Processor #0 (Bootup-CPU)
>> 	[    0.000000] Processor #1
>> 	[    0.000000] Processor #2
>> 	[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
>> 	[    0.000000] Processors: 3
>> 	[    0.000000] smpboot: Allowing 3 CPUs, 1 hotplug CPUs
>>
>> The problem begins when a user might actually want to online such CPU; there
>> is no interface for him to tell the kernel that the CPU is now present and
>> can be used.
>>
>> Luckily, the kernel provides a generic interface in the form of 'probe' and
>> 'release' sysfs files which are used on different architectures exactly for
>> that - to probe and release CPUs. On x86 however this was unimplemented
>> until now.
>>
>> This patch adds code into the x86 implementation of probe and release to allow
>> adding and removing CPUs. This allows machines that use mptable to hotplug
>> CPUs:
>>
> 
> Reading between the lines, this sounds like would cause a user-visible
> difference between mptable platforms and ACPI platforms?  If so, that is
> totally unacceptable.  If not, the description is confusing.

With ACPI platforms you don't need probe/release because the hardware notifies
on CPU insert/eject - this doesn't exist on mptable which is why you have to
do it manually with probe/release.

The difference is already user visible: you can hotplug on ACPI, but can't on
mptables.

Yes, reading back the subject does sound confusing - a better one would probably
be "provide interface for CPU hotplug on mptable platforms" or something similar.


Thanks,
Sasha

