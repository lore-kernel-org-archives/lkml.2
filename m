Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab0CVUJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:09:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:60462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0CVUJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:09:10 -0400
Message-ID: <4BA7CE1B.9070109@kernel.org>
Date: Mon, 22 Mar 2010 13:07:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
References: <4BA6EA62.1030603@kernel.org> <20100321.210023.209981130.davem@davemloft.net> <4BA6F1F6.3070102@kernel.org> <20100321.213350.176660494.davem@davemloft.net> <20100322092809.GA20607@elte.hu> <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain> <20100322193720.GA2844@elte.hu>
In-Reply-To: <20100322193720.GA2844@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 12:37 PM, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> Ingo,
>>
>> On Mon, 22 Mar 2010, Ingo Molnar wrote:
>>>
>>> ( Cc:-ed Andrew and Linus as this is a general design/policy matter wrt. 
>>>   memory management. )
>>>
>>> * David Miller <davem@davemloft.net> wrote:
>>>
>>>> From: Yinghai Lu <yinghai@kernel.org>
>>>> Date: Sun, 21 Mar 2010 21:28:38 -0700
>>>>
>>>>>>
>>>>>> That action means you absolutely don't value our feedback at all.
>>>>>
>>>>> [PATCH 01/20] x86: add find_e820_area_node
>>>>> is addressing your concern that early_res didn't handle memory cross the nodes problem.
>>>>
>>>> Now I know that you _REALLY_ aren't listening to us.
>>
>>> [ He has done a bit more than just to simply listen: he seems to
>>> have written a patch which he thinks is addressing the concerns you
>>> pointed out. It might not be the response you wished for (and it
>>> might be inadequate) for but it sure gives me the impression of him
>>> listening to you - unless by 'listening' you mean 'follow my exact
>>> opinion without argument'. ]
>>
>> I tend to disagree. Fixing the bug pointed out by Dave is not really a
>> good argument about listening.
>>
>> The main point is that there is still no answer why lmb cannot be used and 
>> the reposted patch still is a full move of the x86 e820 functions into 
>> kernel/fw_memmap.c.
>>
>> That's not a generalization, that's simply a relocation of x86 code to 
>> kernel/. And I agree with Dave and Ben that this is an useless exercise.
> 
> ok - i think you are right. Yinghai, mind having a look at using lib/lmb.c for 
> all this?

1. need to keep e820
2. use e820 range with RAM to fill lmb.memory when finizing_e820
3. use lmb.reserved to replace early_res.

current lmb is merging the region, we can not use name tag any more.

may need to dump early_memtest, and use early_res for bootmem at first.

YH
