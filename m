Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab1BWUwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:52:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41471 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1BWUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:52:19 -0500
Message-ID: <4D657359.5060901@kernel.org>
Date: Wed, 23 Feb 2011 12:51:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org> <4D656D1A.7030006@kernel.org> <20110223204656.GA27738@atj.dyndns.org>
In-Reply-To: <20110223204656.GA27738@atj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020A.4D65736D.019F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 12:46 PM, Tejun Heo wrote:
> On Wed, Feb 23, 2011 at 12:24:58PM -0800, Yinghai Lu wrote:
>>>    I guess this was the reason why the commit message showed usage of
>>>    2MiB mappings so that each node would end up with their own third
>>>    level page tables.  Is this something we need to optimize for?  I
>>>    don't recall seeing recent machines which don't use 1GiB pages for
>>>    the linear mapping.  Are there NUMA machines which can't use 1GiB
>>>    mappings?
>>
>> till now:
>> amd 64 cpu does support 1gb page.
>>
>> Intel CPU Nehalem-EX does not. and several vendors do provide 8 sockets
>> NUMA system with 1024g and 2048g RAM
> 
> That's interesting.  Didn't expect that.  So, this one is an actually
> valid reason for implementing per node mapping.  Is this Nehalem-EX
> only thing?  Or is it applicable to all xeons upto now?

only have access for Nehalem-EX and Westmere-EX till now.

> 
>>> 3. The new code creates linear mapping only for memory regions where
>>>    e820 actually says there is memory as opposed to mapping from base
>>>    to top.  Again, I'm not sure what the intention of this change was.
>>>    Having larger mappings over holes is much cheaper than having to
>>>    break down the mappings into smaller sized mappings around the
>>>    holes both in terms of memory and run time overhead.  Why would we
>>>    want to match the linear address mapping to the e820 map exactly?
>>
>> we don't need to map those holes if there is any.
> 
> Yeah, sure, my point was that not mapping those holes is likely to be
> worse.  Wouldn't it be better to get low and high ends of the occupied
> area and expand those to larger mapping size?  It's worse to match the
> memory map exactly.  You unnecessarily end up with smaller mappings.

it will reuse previous not used entries in the init_memory_mapping().

> 
>> for hotplug case, they should map new added memory later.
> 
> Sure.
> 
>>> Also, Yinghai, can you please try to write commit descriptions with
>>> more details?  It really sucks for other people when they have to
>>> guess what the actual changes and underlying intentions are.  The
>>> commit adding init_memory_mapping_high() is very anemic on details
>>> about how the behavior changes and the only intention given there is
>>> RED-PEN removal even which is largely a miss.
>>
>> i don't know what you are talking about. that changelog is clear enough.
> 
> Ah well, if you still think the changelog is clear enough, I give up.
> I guess I'll just keep rewriting your changelogs.

Thank you very much.

Yinghai
