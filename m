Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0C3AFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 20:05:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:60698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0C3AFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 20:05:31 -0400
Message-ID: <4BB13FDB.9060006@kernel.org>
Date: Mon, 29 Mar 2010 17:03:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 07/31] lmb: Add reserve_lmb/free_lmb
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>	 <1269830604-26214-8-git-send-email-yinghai@kernel.org>	 <1269865322.24620.42.camel@concordia>  <4BB0D92C.3010103@kernel.org>	 <1269901252.2286.11.camel@concordia> <1269905491.7101.40.camel@pasglop>
In-Reply-To: <1269905491.7101.40.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 04:31 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-30 at 09:20 +1100, Michael Ellerman wrote:
>>
>> But that's my point. You shouldn't need to touch the existing API, and
>> you shouldn't need to add a new parallel API. You should just be able to
>> add the logic for doubling the array in the lmb core, and then everyone
>> gets dynamically expandable lmb. I don't see any reason why we want to
>> have two APIs.
> 
> Ack.
ok, we can merge them later.
> 
>>>> It seems to me that rather than adding these "special" routines that
>>>> check for enough space on the way in, instead you should be checking in
>>>> lmb_add_region() - which is where AFAICS all allocs/frees/reserves
>>>> eventually end up if they need to insert a new region.
>>>
>>> later i prefer to replace lmb_alloc with find_lmb_area + reserve_lmb.
>>
>> Why? The existing code has been working for years and is well tested? 
> 
> I still don't totally understand why he needs a find_lmb_area()
> anyways. 
> 
> It might be justified ... or not. I just want it to be better
> documented.


current changelog for that

------------------

Subject: [PATCH 6/31] lmb: Add lmb_find_area()

It will try find area according with size/align in specified range (start, end).

Need use it find correct buffer for new lmb.reserved.region.

also make it more easy for x86 to use lmb.
x86 early_res is using find/reserve pattern instead of alloc.

lmb_find_area() will honor goal

When we need temporary buff for range array etc for range work, if We are using
lmb_alloc(), We will need to add some post fix code for buffer that is used
by range array, because it is in the lmb.reserved already.

----------------

in short: It could make us to avoid use the range that we are going to reserve,
      when we try to get new position new lmb.reserved.region.

Thanks

Yinghai
