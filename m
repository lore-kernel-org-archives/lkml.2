Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126Ab2FARJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:09:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47030 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269Ab2FARJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:09:24 -0400
Message-ID: <4FC8F740.7070606@gmail.com>
Date: Fri, 01 Jun 2012 13:09:20 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [Patch] x86 : set numa_nodes_parsed at acpi_numa_memory_affinity_init
References: <4FC47E88.2000403@jp.fujitsu.com> <4FC75525.8010508@gmail.com> <4FC8A2AA.5090003@jp.fujitsu.com>
In-Reply-To: <4FC8A2AA.5090003@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/1/12 7:08 AM), Yasuaki Ishimatsu wrote:
> Hi Kosaki-san,
> 
> 2012/05/31 20:25, KOSAKI Motohiro wrote:
>> Hi Ishimatsu-san,
>>
>>
>> (5/29/12 3:45 AM), Yasuaki Ishimatsu wrote:
>>> When hot-adding a CPU into my system, the system showed following message
>>> since node_to_cpumask_map[2] was not allocated memory.
>>>
>>> Booting Node 2 Processor 32 APIC 0xc0
>>> node_to_cpumask_map[2] NULL
>>> Pid: 0, comm: swapper/32 Tainted: G       A     3.3.5-acd #21
>>> Call Trace:
>>>     [<ffffffff81048845>] debug_cpumask_set_cpu+0x155/0x160
>>>     [<ffffffff8105e28a>] ? add_timer_on+0xaa/0x120
>>>     [<ffffffff8150665f>] numa_add_cpu+0x1e/0x22
>>>     [<ffffffff815020bb>] identify_cpu+0x1df/0x1e4
>>>     [<ffffffff815020d6>] identify_econdary_cpu+0x16/0x1d
>>>     [<ffffffff81504614>] smp_store_cpu_info+0x3c/0x3e
>>>     [<ffffffff81505263>] smp_callin+0x139/0x1be
>>>     [<ffffffff815052fb>] start_secondary+0x13/0xeb
>>>
>>> In my investigation, the root cause is that the bit of node 2 was not set at
>>> numa_nodes_parsed since hot-added cpu was not written in ACPI SRAT Table.
>>> But hot-added memory which is same PXM as the cpu is written in here.
>>
>> I don't understand this explanation. If cpu is not written in srat table,
>> it is firmware bug. isn't it? srat table should describe all possible cpus.
>> Why doesn't your system describe cpu info in acpi table?
> 
> As jiang answered, hot-added CPU need not be written in SRAT Table.
> So I don't think it is firmware bug.

If so, please write it to the description. Your changelog was unclear. Other than that,

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




