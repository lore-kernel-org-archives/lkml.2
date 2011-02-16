Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1BPWzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:55:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23075 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab1BPWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:55:09 -0500
Message-ID: <4D5C554E.7050701@kernel.org>
Date: Wed, 16 Feb 2011 14:53:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: refactoring numa_register_memblks
References: <4D5C3A0F.3080107@kernel.org> <4D5C3A81.4070408@kernel.org> <20110216224322.GB29600@atj.dyndns.org>
In-Reply-To: <20110216224322.GB29600@atj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4D5C55B5.000B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 02:43 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Feb 16, 2011 at 12:58:41PM -0800, Yinghai Lu wrote:
>>
>> Don't hide init_memory_mapping and setup_bootmem into that __register__ function
>>
>> those are really work.
> 
> What does that mean?  What isn't really work?

i mean: really initmem init work.

> 
>> Also We don't need to scan two times for setup_node_bootmem() becase we
>> are using mapped memblock for node_data already.
> 
> If this isn't necessary, please make this change in a separate patch.
> This involves behavior change.

ok.


> 
>> @@ -968,6 +969,10 @@ void __init initmem_init(void)
>>  		if (numa_register_memblks(&numa_meminfo) < 0)
>>  			continue;
>>  
>> +		init_memory_mapping_high();
>> +
>> +		setup_numa_bootmem(&numa_meminfo);
>> +
> 
> Sorry, nack.  This squarely falls in the realm of bikeshedding and I
> plan on collapsing init_memory_mapping_high() into the register
> function.

no. init_memory_mapping_high now it is with early_node_map[], aka it is e820 and srat table overlapping one.

Yinghai
