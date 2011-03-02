Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1CBQrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:47:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38950 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1CBQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:46:59 -0500
Message-ID: <4D6E7459.6050706@kernel.org>
Date: Wed, 02 Mar 2011 08:46:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org> <20110302102530.GB3319@htj.dyndns.org> <4D6E6D52.8030901@kernel.org> <20110302163729.GQ3319@htj.dyndns.org>
In-Reply-To: <20110302163729.GQ3319@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D6E746F.01A3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 08:37 AM, Tejun Heo wrote:
> Hey, Yinghai.
> 
> On Wed, Mar 02, 2011 at 08:16:18AM -0800, Yinghai Lu wrote:
>> my original part:
>>
>> @@ -393,7 +393,7 @@ void __init numa_reset_distance(void)
>>         size_t size;
>>  
>>         if (numa_distance_cnt) {
>> -               size = numa_distance_cnt * sizeof(numa_distance[0]);
>> +               size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
>>                 memblock_x86_free_range(__pa(numa_distance),
>>                                         __pa(numa_distance) + size);
>>                 numa_distance_cnt = 0;
>>
>> So can you tell me why you need to make those change?
>> 	move out assigning or numa_distance_cnt and size of the the IF
> 
> Please read the patch description.  I actually wrote that down.  :-)

well you said:
> while at it, take numa_distance_cnt resetting in
> numa_reset_distance() out of the if block to simplify the code a bit.

what are you talking about? what do you mean "simplify the code a bit" ?

> 
>> the change include:
>> 1. you only need to go over new_nr*new_nr instead huge MAX_NUMNODES * MAX_NUMNODES
>> 2. you do NOT need to go over it if you don't have phys_dist assigned before.
>>    numa_alloc_distance already have that default set.
>> 3. do need to check if phys_dist is assigned before referring phys_dist.
> 
> * If you wanted to make that change, split it into a separate patch.
>   Don't mix it with changes which actually fix the bug.
> 
> * I don't think it's gonna matter all that much.  It's one time and
>   only used if emulation is enabled, but then again yeap MAX_NUMNODES
>   * MAX_NUMNODES can get quite high, but it looks way too complicated
>   for what it achieves.  Just looping over enabled nodes should
>   achieve about the same thing in much simpler way, right?

what kind of excuse to put inefficiency code there!

Yinghai
