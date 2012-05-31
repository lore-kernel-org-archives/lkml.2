Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab2EaUhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:37:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52016 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab2EaUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:37:53 -0400
Date: Thu, 31 May 2012 13:37:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] x86 : set numa_nodes_parsed at
 acpi_numa_memory_affinity_init
In-Reply-To: <4FC47E88.2000403@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1205311337340.2764@chino.kir.corp.google.com>
References: <4FC47E88.2000403@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Yasuaki Ishimatsu wrote:

> When hot-adding a CPU into my system, the system showed following message
> since node_to_cpumask_map[2] was not allocated memory.
> 
> Booting Node 2 Processor 32 APIC 0xc0
> node_to_cpumask_map[2] NULL
> Pid: 0, comm: swapper/32 Tainted: G       A     3.3.5-acd #21
> Call Trace:
>  [<ffffffff81048845>] debug_cpumask_set_cpu+0x155/0x160
>  [<ffffffff8105e28a>] ? add_timer_on+0xaa/0x120
>  [<ffffffff8150665f>] numa_add_cpu+0x1e/0x22
>  [<ffffffff815020bb>] identify_cpu+0x1df/0x1e4
>  [<ffffffff815020d6>] identify_econdary_cpu+0x16/0x1d
>  [<ffffffff81504614>] smp_store_cpu_info+0x3c/0x3e
>  [<ffffffff81505263>] smp_callin+0x139/0x1be
>  [<ffffffff815052fb>] start_secondary+0x13/0xeb
> 
> In my investigation, the root cause is that the bit of node 2 was not set at
> numa_nodes_parsed since hot-added cpu was not written in ACPI SRAT Table.
> But hot-added memory which is same PXM as the cpu is written in here.
> 
> ACPI Spec Rev 5.0 says about ACPI SRAT talbe as follows:
> This optional table provides information that allows OSPM to associate
> processors and memory ranges, including ranges of memory provided by
> hot-added memory devices, with system localities / proximity domains
> and clock domains.
> 
> So I think the ACPI SRAT Table is not wrong. Thus numa_nodes_parsed should be set
> by not only acpi_numa_processor_affinity_init / acpi_numa_x2apic_affinity_init
> but also acpi_numa_memory_affinity_init for the case.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
