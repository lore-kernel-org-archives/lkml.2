Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2A0A4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:56:41 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34161 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2A0A4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:56:40 -0500
Message-ID: <4F21F638.2080306@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 08:56:24 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Xiaotian Feng <xtfeng@gmail.com>, ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins>	<4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop>
In-Reply-To: <1327506934.2614.87.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12012614-5140-0000-0000-000000A7FCDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 11:55 PM, Peter Zijlstra wrote:

> On Tue, 2012-01-17 at 11:04 +0800, Michael Wang wrote:
>>
>>> Then what if condition 1 is true now?
>>
>> We can see in original code, even condition 1 is true, we
>> still will use value3 if condition3 is true, like this:
>>
>> original:
>>
>> condition1      condition3      result
>> true            true            value3
>> true            false           value1
>>
>> That means if condition3 is true, we don't care whether
>> condition1 is true or not because we will finally use value3.
> 

> Right, so from the original 8 possible states we used to evaluate 3*8 =
> 24 conditionals. The new code will reduce this to 1*4 + 2*2 + 2*3 = 14.
> 
> Now I guess the question is if it matters for the modal or average
> state.
> 


Hi, Peter

I think how much help this patch can do on the performance depends on
how often the condition2 and 3 occur.

> I've applied the patch since it can't be worse, but I've no idea if it
> matters or not in practice.


It's hardly to say how useful this patch is, but it will do some help
under special condition.
Thanks for your review.

Regards,
Michael Wang

> 


