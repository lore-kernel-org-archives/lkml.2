Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2A0BXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:23:00 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41731 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2A0BW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:22:59 -0500
Message-ID: <4F21FC69.6040402@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 09:22:49 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Xiaotian Feng <xtfeng@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu>
In-Reply-To: <20120126100429.GA3853@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012701-3864-0000-0000-00000122839C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 06:04 PM, Ingo Molnar wrote:

> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> On Tue, 2012-01-17 at 11:04 +0800, Michael Wang wrote:
>>>
>>>> Then what if condition 1 is true now?
>>>
>>> We can see in original code, even condition 1 is true, we
>>> still will use value3 if condition3 is true, like this:
>>>
>>> original:
>>>
>>> condition1      condition3      result
>>> true            true            value3
>>> true            false           value1
>>>
>>> That means if condition3 is true, we don't care whether
>>> condition1 is true or not because we will finally use value3.
>>
>> Right, so from the original 8 possible states we used to evaluate 3*8 =
>> 24 conditionals. The new code will reduce this to 1*4 + 2*2 + 2*3 = 14.
>>
>> Now I guess the question is if it matters for the modal or average
>> state.
>>
>> I've applied the patch since it can't be worse, but I've no idea if it
>> matters or not in practice.
> 
> A before/after kernel/sched.o size comparison on 64-bit 
> defconfig typically gives a pretty good indication whether it's 
> a step forward or not.
> 
> Thanks,
> 
> 	Ingo
> 


Hi, Ingo

Thanks for your reply.

I have try use "ls -l" to see the size of sched.o, but after applied the
patch, it is still 1636.

I have not use this method before, may be I use the wrong command...

But I think the new code should be similar to the old one after compile,
because we still have 3 condition check here.

I suppose the new sched.o will be a little bigger, because one jump
command and a label need to be added.

Regards,
Michael Wang

