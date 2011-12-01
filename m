Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1LAWzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:55:15 -0500
Received: from ffm.saftware.de ([83.141.3.46]:36866 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab1LAWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:55:13 -0500
Message-ID: <4ED805CB.5020302@linuxtv.org>
Date: Thu, 01 Dec 2011 23:55:07 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: HoP <jpetrous@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <4ED7E5D7.8070909@redhat.com>
In-Reply-To: <4ED7E5D7.8070909@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2011 21:38, Mauro Carvalho Chehab wrote:
> I fail to see where do you need to duplicate dvb-core. An userspace
> LD_PRELOAD handler that would do:
> 
> int socket;
> 
> int dvb_ioctl(int fd, unsigned long int request, ...)
> {
>         void *arg;
>         va_list ap;
>  
>         va_start(ap, request);
>         arg = va_arg(ap, void *);
>         va_end(ap);
> 
>     send_net_ioctl_packet(socket, request, arg);
> }
> 
> Is probably all you need to send _any_ ioctl's to a remote machine
> (plus client's machine that would decode the ioctl packet and send
> the ioctl to the actual driver).
> 
> Of course, you'll need hooks for all syscalls used (likely open, close,
> ioctl, read, poll).
> 
> So, there's not much duplication, even if, for whatever reason, you
> might need to hook some specific ioctls in order to optimize the
> network performance.

Mauro, we've already had that discussion last time. In order to
intercept ioctls of a device, the device needs to exist to begin with,
right? That's where vtuner comes in: It creates the virtual device.

For that reason your suggested approach using LD_PRELOAD won't work.

Besides that, suggesting LD_PRELOAD for something other than a hack
can't be taken seriously.

I think you didn't even understand what vtuner does, after all the
discussion that took place.

>>>> Of course
>>>> I can be wrong, I'm no big kernel hacker. So please show me the
>>>> way for it. BTW, even if you can find the way, then data copying
>>>> from userspace to the kernel and back is also necessery.
>>>
>>> See libv4l, at v4l2-utils.git (at linuxtv.org).
>>>
>>>> I really
>>>> don't see any advantage of you solution.
>>>
>>> And I can't see any advantage on yours ;) Putting something that belongs
>>> to userspace into kernelspace just because it is easier to re-use the
>>> existing code inside the kernel is not a good argument.
>>
>> It is only your POV that it should be in userspace.
>>
>> Creating additional code which not only enlarge code size by 2
>> but I think by 10 is really not good idea.  And it get no advantage
>> only disadvantages.
>>
>>>
>>> Don't get me wrong but if you want to submit a code to be merged
>>> on any existing software (being open source or not), you should be
>>> prepared to defend your code and justify the need for it to the
>>> other developers.
>>
>> Sure. I was prepared for technical disscussion, but was fully suprised
>> that it was not happend (ok, to be correct, few guys are exception, like
>> Andreas and few others. I really appreciate it).
>>
>> So, my question was still not answered: "Can be driver NACKed only
>> because of worrying about possible misuse?"
> 
> To answer your question: your driver were nacked because of several
> reasons:
> it is not a driver for an unsupported hardware,

It's not a driver for supported hardware either. You named it before:
It's not a driver in your definition at all. It's a way to remotely
access digital TV tuners over a network.

> you failed to convince
> people
> why this can't be implemented on userspace,

Wrong. You failed to convince people why this must be implemented in
userspace. Even Michael Krufky, who's "only" against merging it, likes
the idea, because it's useful.

Just because something can be implemented in userspace doesn't mean that
it's technically superior.

> the driver adds hooks at
> kernelspace
> that would open internal API's that several developers don't agree on
> exposing
> at userspace, as would allow non GPL license compatible drivers to re-use
> their work in a way they are against.

What's left is your unreasonable GPL blah blah. So the answer to Honza's
question is: Yes, Mauro is nacking the driver because he's worrying
about possible misuse.

Regards,
Andreas
