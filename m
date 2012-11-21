Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2KUS0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:26:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53299 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab2KUS0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:26:20 -0500
Message-ID: <50AD1CB6.9030707@zytor.com>
Date: Wed, 21 Nov 2012 10:25:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH] x86, smpboot: allow manual hotplug of CPUs
References: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 10:22 AM, Sasha Levin wrote:
> So far CPU hotplug was ignored for mptable implementations which support it by
> having the hotpluggable CPUs marked as disabled during boot.
> 
> The current kernel code detects that behaviour and actually deals with it
> properly:
> 
> 	[    0.000000] Intel MultiProcessor Specification v1.4
> 	[    0.000000] MPTABLE: OEM ID: KVMCPU00
> 	[    0.000000] MPTABLE: Product ID: 0.1
> 	[    0.000000] MPTABLE: APIC at: 0xFEE00000
> 	[    0.000000] Processor #0 (Bootup-CPU)
> 	[    0.000000] Processor #1
> 	[    0.000000] Processor #2
> 	[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
> 	[    0.000000] Processors: 3
> 	[    0.000000] smpboot: Allowing 3 CPUs, 1 hotplug CPUs
> 
> The problem begins when a user might actually want to online such CPU; there
> is no interface for him to tell the kernel that the CPU is now present and
> can be used.
> 
> Luckily, the kernel provides a generic interface in the form of 'probe' and
> 'release' sysfs files which are used on different architectures exactly for
> that - to probe and release CPUs. On x86 however this was unimplemented
> until now.
> 
> This patch adds code into the x86 implementation of probe and release to allow
> adding and removing CPUs. This allows machines that use mptable to hotplug
> CPUs:
> 

Reading between the lines, this sounds like would cause a user-visible
difference between mptable platforms and ACPI platforms?  If so, that is
totally unacceptable.  If not, the description is confusing.

	-hpa


