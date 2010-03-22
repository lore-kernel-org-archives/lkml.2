Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0CVW2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:28:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0CVW17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:27:59 -0400
Message-ID: <4BA7EE72.7000507@kernel.org>
Date: Mon, 22 Mar 2010 15:25:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu> <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain> <20100322193720.GA2844@elte.hu> <4BA7CE1B.9070109@kernel.org> <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 03:09 PM, Thomas Gleixner wrote:
> Yinghai,
> 
> On Mon, 22 Mar 2010, Yinghai Lu wrote:
>> On 03/22/2010 12:37 PM, Ingo Molnar wrote:
>>> * Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>>>> The main point is that there is still no answer why lmb cannot be used and 
>>>> the reposted patch still is a full move of the x86 e820 functions into 
>>>> kernel/fw_memmap.c.
>>>>
>>>> That's not a generalization, that's simply a relocation of x86 code to 
>>>> kernel/. And I agree with Dave and Ben that this is an useless exercise.
>>>
>>> ok - i think you are right. Yinghai, mind having a look at using
>>> lib/lmb.c for all this?
>>
>> 1. need to keep e820
> 
>   That's neither an argument for using lmb nor an argument not to use
>   lmb. e820 is x86 specific BIOS wreckage and it's whole purpose is
>   just to feed information into a (hopefully) generic early resource
>   management facility.
> 
>   e820 _CANNOT_ be generalized. Period.
> 
>> 2. use e820 range with RAM to fill lmb.memory when finizing_e820
> 
>   What's finizing_e820 ???
 finish_e820_parsing();
> 
>> 3. use lmb.reserved to replace early_res.
> 
>   What's the implication of doing that ?

early_res array is only corresponding to lmb.reserved, aka reserved region from kernel.

>  
>> current lmb is merging the region, we can not use name tag any more.
> 
>   What's wrong with merging of regions ? Are you arguing about a
>   specific region ("the region") ?

> 
>   Which name tag ? And why is that name tag important ?

struct early_res {
        u64 start, end;
        char name[15];
        char overlap_ok;
};

>  
>> may need to dump early_memtest, and use early_res for bootmem at
>> first.
> 
>   Why exactly might early_memtest not longer be possible ?
early_memtest need to call find_e820_area_size
current lmb doesn't have that kind of find util.
the one memory subtract reserved memory by kernel.
> 
>   What means "early_res for bootmem" ?

use early_res to replace bootmem, the CONFIG_NO_BOOTMEM.
that need early_res can be double or increase the slots automatically.

Yinghai
