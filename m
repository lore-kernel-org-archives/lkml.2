Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0G1Fmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:42:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37156 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0G1Fmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:42:31 -0400
Message-ID: <4C4FC312.4010503@kernel.org>
Date: Tue, 27 Jul 2010 22:41:38 -0700
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
        linux-arch@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 05/16] x86, memblock: Add get_free_all_memory_range()
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>	 <1279824241-17582-6-git-send-email-yinghai@kernel.org> <1280293338.1970.235.camel@pasglop>
In-Reply-To: <1280293338.1970.235.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C4FC325.001D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:02 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
>>
>> +       /* Take out region array itself at first*/
>> +       if (memblock.reserved.regions != memblock_reserved_init_regions)
>> +               memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
>> +
> 
> More of that horror. Don't.
> 
> Another option from what i proposed earlier is to actually have a function
> inside mm/memblock to free it (memblock_free_arrays()) that does nothing
> if memblock is to survive init.
> 
> I hate exporting variables or data structures like that. Functions are
> semantically a lot cleaner.

ok, will check if can change that to function instead.
but it will be with add-on patch.

Thanks

Yinghai
