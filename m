Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1I1Pgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:36:45 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35487 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab1I1Pgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:36:44 -0400
Message-ID: <4E833ED4.4020205@parallels.com>
Date: Wed, 28 Sep 2011 12:35:48 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>   <1316816432-9237-5-git-send-email-glommer@parallels.com>   <1317160837.21836.21.camel@twins> <20110928101357.5a90c2ab@de.ibm.com>   <1317206124.20318.6.camel@twins> <20110928144218.6a4882e5@de.ibm.com>  <1317214418.24040.13.camel@twins> <4E833D6D.1030407@parallels.com> <1317224038.24040.52.camel@twins>
In-Reply-To: <1317224038.24040.52.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 12:33 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-28 at 12:29 -0300, Glauber Costa wrote:
>> On 09/28/2011 09:53 AM, Peter Zijlstra wrote:
>>> On Wed, 2011-09-28 at 14:42 +0200, Martin Schwidefsky wrote:
>>>
>>>>> That is, am I missing some added value of all this cputime*() foo?
>>>>
>>>> C can do the math as long as the encoding of the cputime is simple enough.
>>>> Can we demand that a cputime value needs to be an integral type ?
>>>
>>> I'd like to think we can ;-)
>>>
>>>> What I did when I wrote all that stuff is to define cputime_t as a struct
>>>> that contains a single u64. That way I found all the places in the kernel
>>>> that used a cputime and could convert the code accordingly.
>>>
>>> Indeed, that makes it a non-simple type and breaks all the C arith bits.
>>>
>>>> My fear is that if the cputime_xxx operations are removed, code will
>>>> sneak in again that just uses an unsigned long instead of a cputime_t.
>>>> That would break any arch that requires something bigger than a u32 for
>>>> its cputime.
>>>
>>> Which is only a problem for 32bit archs, of which s390 is the only one
>>> that matters, right? Hurm,. could we do something with sparse? Lots of
>>> people run sparse.
>>>
>> Well, I think x86-32 is unlikely to ever really go away.
>
> Sadly I'd agree with you, but that's not really the point, the only 32
> bit arch that has !32 bit cputime_t is s390.

Ah, I see.

Right, then.

So let me get this straight: The proposal here is really to get rid of 
all cputime_t , not only cputime64_t ?

>
> But yeah, death to ia32 (and everything else 32bit fwiw)!
Well, we need to kill the 16bit stuff still lying around first =)

