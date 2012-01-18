Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2ARJM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:12:26 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33941 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2ARJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:12:23 -0500
Message-ID: <4F168CF3.5090400@gmail.com>
Date: Wed, 18 Jan 2012 04:12:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
References: <20120117142759.GE16213@moon> <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com> <20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com> <m1obu29fnf.fsf@fess.ebiederm.org> <20120118080103.GA2889@moon>
In-Reply-To: <20120118080103.GA2889@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/18/12 3:01 AM), Cyrill Gorcunov wrote:
> On Tue, Jan 17, 2012 at 01:35:00PM -0800, Eric W. Biederman wrote:
>> "H. Peter Anvin"<hpa@zytor.com>  writes:
>>
>>> On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
>>>> On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
>>>>> On 1/17/12, Cyrill Gorcunov<gorcunov@gmail.com>  wrote:
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
>>
>> For checkpoint restart and for some other kinds of introspection what is
>> needed is a comparison function to see if two processes share the same
>> object.  The most interesting of these objects from a checkpoint restart case
>> are file descriptors, and there can be a lot of file descriptors.
>>
>> The order in memory does not matter.  What does matter is that the
>> comparison function return some ordering between objects.  The algorithm
>> for figuring out of N items which of them are duplicates is O(N^2) if
>> the comparison function can only return equal or not equal.  The
>> algorithm for finding duplications is only O(NlogN) if the comparison
>> function will return an ordering among the objects.
>
> Yes, thanks Eric, I missed this text in patch description, my bad. And
> yes, performance will degrade with plain eq/ne approach. But as Pavel
> stated in another email

I think Eric only said gt/lt compare is useful. We don't need to expose bare
pointer order. example, kcmp(rotate(ptr, per-task-random-value)) is enough
hide the critical information. I think.

