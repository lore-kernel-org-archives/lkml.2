Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0ENQZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:25:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37349 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0ENQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:25:18 -0400
Message-ID: <4BED7A20.9060007@oracle.com>
Date: Fri, 14 May 2010 09:28:16 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 04/35] lmb: Add lmb_find_area()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-5-git-send-email-yinghai@kernel.org>	 <1273803410.21352.361.camel@pasglop>  <4BECECF4.4070205@oracle.com> <1273824726.21352.582.camel@pasglop>
In-Reply-To: <1273824726.21352.582.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4BED793F.005B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:12 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 23:25 -0700, Yinghai wrote:
>   
>>>> +u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>>>> +                    u64 size, u64 align);
>>>> +u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
>>>>         
>>> See my comments about sorting out the return from that function.
>>>
>>> Also, I don't understand the need for that __ version. It looks like
>>> something you should keep inside x86, I don't see the need for it in
>>>       
>> the
>>     
>>> generic LMB code, since it just does trivial cropping of the
>>>       
>> arguments.
>>
>> otherwise need to export lmb_find_base() and LMB_ERROR
>>     
> Well, then export lmb_find_base(), and just sanitize the result codes
> over all LMB. That's not -that- hard, it's not like there were gazillion
> of users yet. I don't have time now to do that myself before monday.
>
>   
 will check that.

>> yes. but need that to keep switch from early_res/nobootmem to
>> lmb/nobootmem smooth.
>>
>> will clean it after early_res is replaced.
>>     
> Then make it inline inside the x86 stuff. But really, you should cleanup
> that result code. It's something on my TODO list for lmb that I haven't
> had a chance to do yet, so please look at that or wait til next week so
> I do it myself.
>
>   
also need to include asm/lmb.h to the end of linux/lmb.h

YH
