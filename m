Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0G1GPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:15:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24322 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0G1GPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:15:19 -0400
Message-ID: <4C4FCA7A.1020506@kernel.org>
Date: Tue, 27 Jul 2010 23:13:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hpa@zytor.com, benh@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
References: <1280294128.1970.237.camel@pasglop>	<1280294376.1970.239.camel@pasglop>	<4C4FC5D1.3070708@zytor.com> <20100727.230120.43037767.davem@davemloft.net>
In-Reply-To: <20100727.230120.43037767.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C4FCAD8.0221,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 11:01 PM, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Tue, 27 Jul 2010 22:53:21 -0700
> 
>> On 07/27/2010 10:19 PM, Benjamin Herrenschmidt wrote:
>>>
>>> Screw it, I don't like it but I'll just split your patch in two for now
>>> and keep 0. It's a bit fishy but memblock does mostly top-down
>>> allocations and so shouldn't hit 0, and in practice the region at 0 is,
>>> I beleive, reserved, but we need to be extra careful and might need to
>>> revisit that a bit.
>>>
>>> That's an area where I don't completely agree with Linus, ie, 0 is a
>>> perfectly valid physical address for memblock to return :-)
>>>
>>
>> On x86, physical address 0 contains the real-mode IVT and will thus be
>> reserved, at least for the forseeable future.  Other architectures may
>> very well have non-special RAM there.
> 
> 0 is very much possible on sparc64

So still keep MEMBLOCK_ERROR to (~(phys_addr_t)0) ?

We can change some variable from unsigned long to phys_addr_t that will be
 assigned by memblock_find_base().

that could avoid casting too.

Thanks

Yinghai
