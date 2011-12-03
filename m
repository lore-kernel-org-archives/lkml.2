Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1LCAhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 19:37:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62249 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1LCAht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 19:37:49 -0500
MIME-Version: 1.0
In-Reply-To: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
Date: Sat, 3 Dec 2011 01:37:48 +0100
Message-ID: <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan.

2011/12/3 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Thu, 1 Dec 2011 15:58:41 +0100
> HoP <jpetrous@gmail.com> wrote:
>
>> Hi,
>>
>> let me ask you some details of your interesting idea (how to
>> achieve the same functionality as with vtunerc driver):
>>
>> [...]
>>
>> > The driver, as proposed, is not really a driver, as it doesn't support any
>> > hardware. The kernel driver would be used to just copy data from one
>> > userspace
>>
>> Please stop learning me what can be called driver and what nope.
>> Your definition is nonsense and I don't want to follow you on it.
>
> You can stick your fingers in your ears and shout all you like but given
> Mauro is the maintainer I'd suggest you work with him rather than making
> it painful. One of the failures we routinely exclude code from the kernel
> for is best described as "user interface of contributor"

You may be not read all my mails but I really tried to be very positive in them.
I wanted to focus on my Subject, but Mauro has, sometimes, the demand
to focus on insignificant things (like if the code is driver or not). At least
it is my feeling from all those disscussions with him.

>
> It's a loopback that adds a performance hit. The right way to do this is
> in userspace with the userspace infrastructure. At that point you can
> handle all the corner cases properly, integrate things like service
> discovery into your model and so on - stuff you'll never get to work that
> well with kernel loopback hackery.
>
>> Can you show me, how then can be reused most important part
>> of dvb-core subsystem like tuning and demuxing? Or do you want me
>> to invent wheels and to recode everything in the library? Of course
>
> You could certainly build a library from the same code. That might well
> be a good thing for all kinds of 'soft' DV applications. At that point
> the discussion to have is the best way to make that code sharable between
> a userspace library and the kernel and buildable for both.
>
>> I can be wrong, I'm no big kernel hacker. So please show me the
>> way for it. BTW, even if you can find the way, then data copying
>> from userspace to the kernel and back is also necessery. I really
>> don't see any advantage of you solution.
>
> In a properly built media subsystem you shouldn't need any copies beyond
> those that naturally occur as part of a processing pass and are therefore
> free.

I may describe project goal, in few sentences: We have small box, running
embedded linux with 2 satellite tuners on input and ethernet. Nothing more.
We have designed the box for live sat TV/Radio reception, distributing them
down to the network. One of the mode of working is "vtuner", what allows
reuse those tuners remotely on linux desktop. The kernel part is very simple
code exposing kernel's dvb-core to the userspace. Userspace client/server
tools do all resource discovery and connection management. It works
nicely and guys with vdr who is using it are rather satisfied with it.
So, the main
goal of vtuner code is to fully virtualize remote DVB adapter. To any
linux dvb api
compatible applications and tools. The vtuner kernel code seems to be
the simplest and straightforward way to achieve it.

I still think the code is very similar to NBD (Network block device) what sits
in the kernel and is using silently. I guess NBD also do data copying
from/to user space. Is there something what I overlooked?

Can you show me the way (hint please) I can initiate TCP connection
from within kernel space? If I can do it, then the big disadvantage
of data passing to and from kernel can be removed.

I must say that the box is primary focused to the DLNA/UpnP world, so
vtuner feature is something like interesting addon only. But I was myself
very nice surprised how good it behaves on real installations and that
was reason I decided to try to get it included in kernel. I see that
in present there is no willingness for code acceptation, so I will continue
out of the kernel tree.

Anyway, if I can find the way how to start TCP connection from the kernel
part, I understand it can boost throughput very nicely up.

Honza
