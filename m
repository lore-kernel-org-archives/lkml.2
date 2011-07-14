Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1GNVYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:24:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:24:54 -0400
Message-ID: <4E1F5E96.2060709@zytor.com>
Date: Thu, 14 Jul 2011 14:24:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Tejun Heo <tj@kernel.org>, mingo@redhat.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2.5/13] memblock: Use __meminit[data] instead of __init[data]
References: <1310462166-31469-1-git-send-email-tj@kernel.org>	<20110714094203.GE3455@htj.dyndns.org> <CAE9FiQU92k-GAy3DVB4HYpn6D6_u=4T7t9_8FOGh8BLDEAKD=Q@mail.gmail.com>
In-Reply-To: <CAE9FiQU92k-GAy3DVB4HYpn6D6_u=4T7t9_8FOGh8BLDEAKD=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 02:00 PM, Yinghai Lu wrote:
>>
>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
>> index aa5df9e..434b958 100644
>> --- a/include/linux/memblock.h
>> +++ b/include/linux/memblock.h
>> @@ -152,8 +152,8 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
>>
>>
>>  #ifdef ARCH_DISCARD_MEMBLOCK
>> -#define __init_memblock __init
>> -#define __initdata_memblock __initdata
>> +#define __init_memblock __meminit
>> +#define __initdata_memblock __meminitdata
>>  #else
>>  #define __init_memblock
>>  #define __initdata_memblock
> 
> that is not good. It will keep memblock.reserved related data and
> functions after boot.
> and those data/func are not used after slab is ready.
> 

>From the look of it this ranges from about 7-19K, so I'm going to take
this and we can optimize this later.

	-hpa
