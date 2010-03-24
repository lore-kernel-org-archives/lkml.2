Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0CXGHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 02:07:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:44449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0CXGHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 02:07:32 -0400
Message-ID: <4BA9ABB6.2070105@kernel.org>
Date: Tue, 23 Mar 2010 23:05:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
References: <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org>	 <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>	 <4BA7EE72.7000507@kernel.org>	 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>	 <4BA80019.5000900@kernel.org>	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>	 <4BA813A4.1010704@kernel.org>	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>	 <4BA8594F.8090205@kernel.org>  <20100323080252.GA4848@elte.hu> <1269404686.8599.144.camel@pasglop>
In-Reply-To: <1269404686.8599.144.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 09:24 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-23 at 09:02 +0100, Ingo Molnar wrote:
>>> -u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
>>> +u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
>>> +u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
>>> +u64 find_lmb_area_node(int nid, u64 start, u64 end, u64 size, u64
>> align);
>>> +void lmb_register_active_regions(int nid, unsigned long start_pfn,
>>> +                                      unsigned long last_pfn);
>>> +u64 lmb_hole_size(u64 start, u64 end);
>>>  u64 get_max_mapped(void);
>>>  #include <linux/range.h>
>>>  int get_free_all_memory_range(struct range **rangep, int nodeid);
>>
>> those new lmb_*() APIs should go into lmb.h.
> 
> And while at it properly documented :-) I wouldn't mind also a
> reasonably clear explanation in the changeset comment as to why
> they are necessary for x86.

new early_res.c will have
find_lmb_area
reserve_early
free_early
also have get_free_all_memory_range to support bootmem replacement.

find_lmb_area: will take goal/limit, so we can find free region with more control.

when we try to check if there is enough slots for new reserve entry.
we need to make sure the new array will not overlap with range below to
entry that going to be reserved.
so we need to goal for find.
otherwise you have to keep trying with lmb_alloc until get one for new array
that will not overlap with new entry.


> 
> To be honest, that's my #1 grief so far with this entire patch set,
> it Yinghai apparent inability to write anything ressembling remotely
> like an explanation. All we get is key words, bullet points and half
> sentences, and I admit have a very very hard time extracting a meaning
> out of anything he's been writing so far.

will spend more time to write more sentences...

thought you guys like to read code instead.

Thanks for you patience.

Yinghai Lu
