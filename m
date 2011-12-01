Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1LASx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:53:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1LASx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:53:57 -0500
Message-ID: <4ED7BBA3.5020002@redhat.com>
Date: Thu, 01 Dec 2011 15:38:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
In-Reply-To: <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-12-2011 12:58, HoP wrote:
> Hi,
>
> let me ask you some details of your interesting idea (how to
> achieve the same functionality as with vtunerc driver):
>
> [...]
>
>> The driver, as proposed, is not really a driver, as it doesn't support any
>> hardware. The kernel driver would be used to just copy data from one
>> userspace
>
> Please stop learning me what can be called driver and what nope.
> Your definition is nonsense and I don't want to follow you on it.
>
>> application to the other. The same result could be obtained in userspace,
>> by implementing a library. Such library could even use LD_PRELOAD to support
>> binary only applications, like what libv4l does. In terms of performance,
>> such library would probably perform better than a kernel driver, as there's
>> no need to do context switching for each call, and no need to talk with a
>> device (where kernel outperforms userspace). Also, depending on how such
>> library
>> is implemented, double buffering might be avoided.
>>
>> So, from architectural POV, this code should be written as an userspace
>> library.
>> BTW, alsa also came with the same results, years ago, as audio remote
>> streaming is supported via userspace tools, like pulseaudio.
>
> Can you show me, how then can be reused most important part
> of dvb-core subsystem like tuning and demuxing?

Why do you need to implement it? Just forward the requests to the machine
with the real driver.

> Or do you want me
> to invent wheels and to recode everything in the library?

Kernel code is GPLv2. You can use its code on a GPLv2 licensed library.

> Of course
> I can be wrong, I'm no big kernel hacker. So please show me the
> way for it. BTW, even if you can find the way, then data copying
> from userspace to the kernel and back is also necessery.

See libv4l, at v4l2-utils.git (at linuxtv.org).

> I really
> don't see any advantage of you solution.

And I can't see any advantage on yours ;) Putting something that belongs
to userspace into kernelspace just because it is easier to re-use the
existing code inside the kernel is not a good argument.

Don't get me wrong but if you want to submit a code to be merged
on any existing software (being open source or not), you should be
prepared to defend your code and justify the need for it to the
other developers.

Regards,
Mauro

