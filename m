Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2B0L3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:29:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2B0L3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:29:35 -0500
Message-ID: <4F4B690B.3010707@redhat.com>
Date: Mon, 27 Feb 2012 08:29:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Jidong Xiao <jidong.xiao@gmail.com>, david@lang.hm,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com> <4F4661D6.7030809@gmail.com> <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com> <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm> <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com> <20120224162109.1bbf157b@redhat.com> <20120225150940.GA3719@localhost> <4F497782.3060902@redhat.com> <20120226015820.GB18931@gallifrey>
In-Reply-To: <20120226015820.GB18931@gallifrey>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-02-2012 23:58, Dr. David Alan Gilbert escreveu:
> * Mauro Carvalho Chehab (mchehab@redhat.com) wrote:
>> Em 25-02-2012 13:10, Eduard - Gabriel Munteanu escreveu:
>>> On Fri, Feb 24, 2012 at 04:21:09PM -0200, Mauro Carvalho Chehab wrote:
>>>> Moving a buggy driver to userspace won't fix the bug. You're just moving
>>>> it from one place to another place. Also, the code will likely require changes
>>>> to work on userspace, so, the chances are that you're actually introducing more
>>>> bugs.
>>>
> 
> <snip>
> 
>>>> That's said, there are much more eyes inspecting the kernel sources than on any 
>>>> other userspace project. So, the risk of a bad code to be inserted unnoticed at
>>>> the Linux kernel is degrees of magnitude lower than on an userspace driver.
>>>
>>> Those much more eyes have already missed important bugs in the past.
>>
>> Yes, nobody is perfect. But the probability that something passes on a 4000+ people
>> review is lower than the probability of a bug on a piece of code where just one 
>> or two people are looking on it.
> 
> That there are 4000+ people reading a driver is a big assumption; for common
> drivers I'd agree - one problem though is there are a lot of drivers for obscure
> hardware or old/dead hardware/protocols that frankly near to nobody cares about.

Drivers for dead hardware won't offer security risks: those drivers will not load,
as such hardware won't be found at the machine. The same applies to old hardware drivers:
they won't run on modern machines.

Yet, even those old/dead drivers have people looking into it. I receive lots of patches
from the janitors team touching those old stuff, fixing potential issues on them.

If the userspace drivers become fragmented into hundreds of independent projects,
I doubt that most of those projects would have a janitors or a security team. Yet,
they can offer security risks.

> Very few people read those drivers; yet sometimes they get built and distributed
> and someone then finds that since no one has looked at them they're full of holes,
> and given a malicious USB device for example, you can suddenly create one of these
> devices that only 3 people have bothered to read the source to - 5 years ago.
> (The Econet security bug recently would be an example of that).

If a malicious person has physical access to the hardware, he can certainly compromise
the machine even without an USB device: if he powers off the machine, a DoS is caused;
if he stoles the hard disks, confidentiality is compromised; if he boots a live CD,
he can insert malicious code there, etc.

> There is a line which says that things that really aren't used
> just shouldn't be built; but then there are things that are only used
> by a few people, and then ones only used by a few organisations - and
> it gets very difficult to say at what point you say just turn it off.

True. If such organizations have high security requirements, they should be hardening 
the OS, disabling anything that allows to load a driver at runtime. The consulting
services for it I've worked with in the past generally disables not only all unused
drivers, but also any other drivers that would allow the usage of external media
(USB, CD rom, memory stick drivers) and userspace ones.

Regards,
Mauro
