Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0G1Fme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:42:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37140 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0G1Fma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:42:30 -0400
Message-ID: <4C4FC2CB.6040200@kernel.org>
Date: Tue, 27 Jul 2010 22:40:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/16] x86, memblock: Add memblock_x86_to_bootmem()
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>	 <1279824241-17582-4-git-send-email-yinghai@kernel.org> <1280293236.1970.234.camel@pasglop>
In-Reply-To: <1280293236.1970.234.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C4FC32A.0099,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:00 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
>> memblock_x86_to_bootmem() will reserve memblock.reserved.region in bootmem after bootmem is
> 
>> +#ifndef CONFIG_NO_BOOTMEM
>> +void __init memblock_x86_to_bootmem(u64 start, u64 end)
>> +{
>> +	int count;
>> +	u64 final_start, final_end;
>> +	struct memblock_region *r;
>> +
>> +	/* Take out region array itself */
>> +	if (memblock.reserved.regions != memblock_reserved_init_regions)
>> +		memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
> 
> So that's why you export memblock_reserved_init_regions...
> 
> I really -really- don't like it. First of all, it's really gross to
> free the array then walk it. We know it won't race but still ...
> especially since you re-do the above every time
> memblock_x86_to_bootmem() is called. Is it called more than once ? If
> yes, then it's bogus. If not, then why have start,end ?

only one time for x86.

> 
> If you really want to free it, maybe best is to stick something in
> mm/memblock.c that kicks in at late init time and does the freeing ?
> 
> I'm going to keep the exporting out of my branch for now. If you really
> want it, you can always add it to this specific patch, but it sucks.

Actually the last patch remove this bootmem support for x86, so this function get removed later.

Thanks

Yinghai
