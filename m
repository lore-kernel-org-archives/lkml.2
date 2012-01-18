Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2ARWHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:07:20 -0500
Received: from mail.lang.hm ([64.81.33.126]:48058 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2ARWHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:07:19 -0500
Date: Wed, 18 Jan 2012 14:05:31 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
In-Reply-To: <m1obu29fnf.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
References: <20120117142759.GE16213@moon> <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com> <20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com> <m1obu29fnf.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Eric W. Biederman wrote:

> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>> On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
>>> On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
>>>> On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>>> +#define KCMP_EQ		0
>>>>> +#define KCMP_LT		1
>>>>> +#define KCMP_GT		2
>>>>
>>>> LT and GT are meaningless.
>>>>
>>>
>>> I found symbolic names better than open-coded values. But sure,
>>> if this is problem it could be dropped.
>>>
>>> Or you mean that in general anything but 'equal' is useless?
>>>
>>
>> Why on Earth would user space need to know which order in memory certain
>> kernel objects are?
>
> For checkpoint restart and for some other kinds of introspection what is
> needed is a comparison function to see if two processes share the same
> object.  The most interesting of these objects from a checkpoint restart case
> are file descriptors, and there can be a lot of file descriptors.
>
> The order in memory does not matter.  What does matter is that the
> comparison function return some ordering between objects.  The algorithm
> for figuring out of N items which of them are duplicates is O(N^2) if
> the comparison function can only return equal or not equal.  The
> algorithm for finding duplications is only O(NlogN) if the comparison
> function will return an ordering among the objects.

so what you really want is a syscall that can take a list of objects 
instead of having to do a syscall per object. right?

David Lang
