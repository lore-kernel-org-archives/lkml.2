Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1BYG7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:59:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BYG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:59:47 -0500
Message-ID: <4D67533A.7010909@corscience.de>
Date: Fri, 25 Feb 2011 07:59:06 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20110121 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: balbi@ti.com, Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-omap@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
References: <20110215113717.GN2570@legolas.emea.dhcp.ti.com>	<4D5A672A.7040000@samsung.com>	<4D5A6874.1080705@corscience.de>	<20110215115349.GQ2570@legolas.emea.dhcp.ti.com>	<4D5A6EEC.5000908@maxwell.research.nokia.com>	<AANLkTik+6fguqgH8Bpnpqo7Axmquy3caRMELTZVmuN1j@mail.gmail.com>	<20110219150024.GA4487@legolas.emea.dhcp.ti.com>	<AANLkTik5dwNZrUxjgjKeAQOsp610d6y_TNGg1b5Vc5Zd@mail.gmail.com>	<20110221073640.GA3094@legolas.emea.dhcp.ti.com>	<AANLkTinf3Wj=nw_2Sx4r-VSsCH+=fzx-25hynH8hB0d9@mail.gmail.com>	<20110221122109.GA23087@legolas.emea.dhcp.ti.com> <AANLkTi=4L38=_a4hFyWqBZL1-CPDyp8t3GfW-M1u8wJF@mail.gmail.com>
In-Reply-To: <AANLkTi=4L38=_a4hFyWqBZL1-CPDyp8t3GfW-M1u8wJF@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ifDhgMSl1iEW0H7AF8kULAxs7QjnH+19aAeV+nee0ag
 ZTi/Wh35wSjYUei/0R9ImrxFuBZxzlwIqcePANoJzI5ff7gEYl
 WxV8HAJAOYvE5asm/IuvY0mlrkVxSuwzA/DGxsnNmK5tzB2RJt
 aruyL4JnN3hOdGoDuKqazP1JY2YV18UHGoMiXA0ccAU6u/6DJV
 k0RWy+8K/H+VD4YxOR7gQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo David,

Am 25.02.2011 00:36, schrieb David Cohen:
> On Mon, Feb 21, 2011 at 2:21 PM, Felipe Balbi <balbi@ti.com> wrote:
>> On Mon, Feb 21, 2011 at 02:09:07PM +0200, David Cohen wrote:
>>> On Mon, Feb 21, 2011 at 9:36 AM, Felipe Balbi <balbi@ti.com> wrote:
>>>> Hi,
>>>>
>>>> On Sat, Feb 19, 2011 at 06:04:58PM +0200, David Cohen wrote:
>>>>>> I have to disagree. The fundamental problem is the circular dependency
>>>>>> between those two files:
>>>>>>
>>>>>> sched.h uses wait_queue_head_t defined in wait.h
>>>>>> wait.h uses TASK_* defined in sched.h
>>>>>>
>>>>>> So, IMO the real fix would be clear out the circular dependency. Maybe
>>>>>> introducing <linux/task.h> to define those TASK_* symbols and include
>>>>>> that on sched.h and wait.h
>>>>>>
>>>>>> Just dig a quick and dirty to try it out and works like a charm
>>>>> We have 2 problems:
>>>>>  - omap24xxcam compilation broken
>>>>>  - circular dependency between sched.h and wait.h
>>>>>
>>>>> To fix the broken compilation we can do what the rest of the kernel is
>>>>> doing, which is to include sched.h.
>>>>> Then, the circular dependency is fixed by some different approach
>>>>> which would probably change *all* current usage of TASK_*.
>>>> considering that 1 is caused by 2 I would fix 2.
>>>>
>>>>> IMO, there's no need to create a dependency between those issues.
>>>> There's no dependency between them, it's just that the root cause for
>>>> this problem is a circular dependency between wait.h and sched.h
>>> I did a try to fix this circular dependency and the comment I got was
>>> to include sched.h in omap24xxcam.c file:
>>> http://marc.info/?l=linux-omap&m=129828637120270&w=2
>>>
>>> I'm working to remove v4l2 internal device interface from omap24xxcam
>>> and then I need this driver's compilation fixed.
>>> The whole kernel is including sched.h when wake_up*() macro is used,
>>> so this should be our first solution IMO.
>>> As I said earlier, no need to make this compilation fix be dependent
>>> of wait.h fix (if it's really going to be changed).
>>>
>>> I think we should proceed with this patch.
>> I would wait to hear from Ingo or Peter who are the maintainers for that
>> part, but fine by me.
> How about to proceed with this patch?
>
> Regards,
>
> David
>

I got a message that the patch is queued at

http://git.linuxtv.org/media_tree.git for_v2.6.39


Thanks Mauro.


Thomas




