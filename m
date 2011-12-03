Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1LCQNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 11:13:55 -0500
Received: from ffm.saftware.de ([83.141.3.46]:49205 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1LCQNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 11:13:51 -0500
Message-ID: <4EDA4AB4.90303@linuxtv.org>
Date: Sat, 03 Dec 2011 17:13:40 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: HoP <jpetrous@gmail.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

On 03.12.2011 00:19, Alan Cox wrote:
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
>>> The driver, as proposed, is not really a driver, as it doesn't support any
>>> hardware. The kernel driver would be used to just copy data from one
>>> userspace
>>
>> Please stop learning me what can be called driver and what nope.
>> Your definition is nonsense and I don't want to follow you on it.
> 
> You can stick your fingers in your ears and shout all you like but given
> Mauro is the maintainer I'd suggest you work with him rather than making
> it painful. One of the failures we routinely exclude code from the kernel
> for is best described as "user interface of contributor"
> 
> It's a loopback that adds a performance hit. The right way to do this is
> in userspace with the userspace infrastructure. At that point you can
> handle all the corner cases properly, integrate things like service
> discovery into your model and so on - stuff you'll never get to work that
> well with kernel loopback hackery.

FWIW, the virtual DVB device we're talking about doesn't have any
networking capabilities by itself. It only allows to create virtual DVB
adapters and to relay DVB API ioctls to userspace in a
transport-agnostic way. Networking already takes place in a separate
userspace process.

>> Can you show me, how then can be reused most important part
>> of dvb-core subsystem like tuning and demuxing? Or do you want me
>> to invent wheels and to recode everything in the library? Of course
> 
> You could certainly build a library from the same code. That might well
> be a good thing for all kinds of 'soft' DV applications. At that point
> the discussion to have is the best way to make that code sharable between
> a userspace library and the kernel and buildable for both.

You could certainly build a library to reach a different goal. The goal
of vtuner is to access remote tuners with any existing program
implementing the DVB API.

One of my primary use cases is to develop DVB API software on my
notebook, while receiving the data from an embedded device, so I don't
need an antenna cable connected to my notebook (or don't need to have an
antenna at my location at all, if an internet connection is available).

Another use case is to receive data streams over the internet from
satellite, cable and terrestrial networks that are impossible to receive
in my area to verify that my DVB API software works with those streams.

Furthermore, I'd like to use standard tools implementing theDid you even
unders DVB API, e.g. to scan for channels, to measure signal quality or
to decode streams on remote locations.

With vtuner, and an accompanying open source networking daemon, all of
the above works out of the box. If I'd like to change the way data gets
relayed between hosts (e.g. add IPv6 or SSL), I'd just need to update
the userspace client and server.

With a library, I'd need to implement networking in every little DVB API
tool I want to use, multiplying the code size of every tool, restricting
each tool to some arbitrarily chosen network protocol. If I'd like to
change the way data gets relayed between hosts, I'd need to update every
application using it.

>> I can be wrong, I'm no big kernel hacker. So please show me the
>> way for it. BTW, even if you can find the way, then data copying
>> from userspace to the kernel and back is also necessery. I really
>> don't see any advantage of you solution.
> 
> In a properly built media subsystem you shouldn't need any copies beyond
> those that naturally occur as part of a processing pass and are therefore
> free.

The original version of the vtuner interface makes use of demux hardware
and also feeds the relevant streams to a/v decoders, in which case you
cannot avoid copying the MPEG data to kernel space.

That's also the way to playback local DVB recordings works today without
vtuners.

I'm fine with not merging this code, if there are technical arguments
against it. And personally I don't need it to be merged to be able to
use it.

However, Mauro invents half-baked arguments against it, because he fears
that the code may be "abused" by closed-source userspace drivers (he
already declared the latter publicly on the linux-media list).

Unfortunately, I must assume that your own arguments are based on
Mauro's emails instead of on the source code, because you clearly didn't
understand the architecture of vtuner, regarding what's supposed to
happen in kernel space and what not.

Regards,
Andreas
