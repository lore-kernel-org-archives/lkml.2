Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886Ab2ARFIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:08:37 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33445 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab2ARFIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:08:36 -0500
Message-ID: <4F165393.2000900@parallels.com>
Date: Wed, 18 Jan 2012 09:07:31 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
References: <20120117142759.GE16213@moon>	<CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>	<20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com>	<20120117211521.GP16213@moon> <m1fwfe9fdm.fsf@fess.ebiederm.org>
In-Reply-To: <m1fwfe9fdm.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 01:40 AM, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> writes:
> 
>> On Tue, Jan 17, 2012 at 10:47:37AM -0800, H. Peter Anvin wrote:
>>> On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
>>>> On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
>>>>> On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>>>> +#define KCMP_EQ		0
>>>>>> +#define KCMP_LT		1
>>>>>> +#define KCMP_GT		2
>>>>>
>>>>> LT and GT are meaningless.
>>>>>
>>>>
>>>> I found symbolic names better than open-coded values. But sure,
>>>> if this is problem it could be dropped.
>>>>
>>>> Or you mean that in general anything but 'equal' is useless?
>>>>
>>>
>>> Why on Earth would user space need to know which order in memory certain
>>> kernel objects are?
>>>
>>> Keep in mind that this is *exactly* the kind of information which makes
>>> rootkits easier.
>>>
>>
>> Hmm, indeed this might help narrow down the target address I fear. So
>> after some conversation with Pavel I think we can try to live with just
>> one result -- is objects are at same location in kernel memory or not.
>> The updated version is below. Please review if you get a chance. Thanks
>> a lot for comments!
> 
> Seriously?
> 
> Or is this a case where you get something in then when people start
> seriously using it and the performance is sucks badly you go back to
> something like the current system call?
> 
> How are you going to ensure the performance does not degrade badly when
> looking across a large number of processes?

We can compare the e.g. files' target inodes (ino + dev) and positions and
comparing each-to-each only for those having these pairs equal. Looking at
the existing large containers with tens thousands of fd-s we have this 
gives us maximum 6 files to compare, and performing 15 syscalls for this suits 
us for now.

Of course, if you manage to persuade Peter that his memory ordering concerns
are not real problems _now_, that would be great, but, yet again -- simple
{eq, ne} suit us for now, providing we can extend this API on {eq, le, gt}
in the future.

> Eric
> .
> 

