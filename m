Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1LCSRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:17:32 -0500
Received: from ffm.saftware.de ([83.141.3.46]:58101 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1LCSRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:17:30 -0500
Message-ID: <4EDA67B1.0@linuxtv.org>
Date: Sat, 03 Dec 2011 19:17:21 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: VDR User <user.vdr@gmail.com>, HoP <jpetrous@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <4EDA4AB4.90303@linuxtv.org> <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com> <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
In-Reply-To: <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.12.2011 18:42, Alan Cox wrote:
> On Sat, 3 Dec 2011 09:21:23 -0800
> VDR User <user.vdr@gmail.com> wrote:
> 
>> On Sat, Dec 3, 2011 at 8:13 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>> You could certainly build a library to reach a different goal. The goal
>>> of vtuner is to access remote tuners with any existing program
>>> implementing the DVB API.
>>
>> So you could finally use VDR as a server/client setup using vtuner,
>> right?

Yes.

>> With full OSD, timer, etc? Yes, I'm aware that streamdev
>> exists. It was horrible when I tried it last (a long time ago) and I
>> understand it's gotten better. But it's not a suitable replacement for
>> a real server/client setup. It sounds like using vtuner, this would
>> finally be possible and since Klaus has no intention of ever
>> modernizing VDR into server/client (that I'm aware of), it's also the
>> only suitable option as well.
> 
> I would expect it to still suck. One of the problems you have with trying
> to pretend things are not networked is that you fake asynchronous events
> synchronously, you can't properly cover error cases and as a result you
> get things like ioctls that hang for two minutes or fail in bogus and
> bizarre ways. If you loop via userspace you've also got to deal with
> deadlocks and all sorts of horrible cornercases like the user space
> daemon dying.

USB tuners may be removed anytime during any ioctl, too. Handling such
error cases is therefore already a requirement, at least for
hotplug-capable software.

> There is a reason properly working client/server code looks different -
> it's not a trivial transformation and faking it kernel side won't be any
> better than faking it in user space - it may well even be a worse fake.

It's certainly not suitable for every possible use case in the world.
For many, however, I think it's the optimal solution.

Regards,
Andreas
