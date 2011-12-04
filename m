Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1LDXy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:54:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62699 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1LDXyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:54:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAGoCfizCxC=W9RM+UhVkTf3Y0RnO2aASBU610vXutmu+aEjtBw@mail.gmail.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
	<CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com>
	<20111203174247.0bbab100@lxorguk.ukuu.org.uk>
	<CAGoCfizCxC=W9RM+UhVkTf3Y0RnO2aASBU610vXutmu+aEjtBw@mail.gmail.com>
Date: Mon, 5 Dec 2011 00:54:24 +0100
Message-ID: <CAJbz7-1OR61MQQr=kRGM+jVk8V5aWBrqbO7ca=kgOWJAahykDA@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, VDR User <user.vdr@gmail.com>,
        Andreas Oberritter <obi@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devin,

I perfectly remember your opinion regarding vtuner.

2011/12/3 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Sat, Dec 3, 2011 at 12:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Sat, 3 Dec 2011 09:21:23 -0800
>> VDR User <user.vdr@gmail.com> wrote:
>>
>>> On Sat, Dec 3, 2011 at 8:13 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>> > You could certainly build a library to reach a different goal. The goal
>>> > of vtuner is to access remote tuners with any existing program
>>> > implementing the DVB API.
>>>
>>> So you could finally use VDR as a server/client setup using vtuner,
>>> right? With full OSD, timer, etc? Yes, I'm aware that streamdev
>>> exists. It was horrible when I tried it last (a long time ago) and I
>>> understand it's gotten better. But it's not a suitable replacement for
>>> a real server/client setup. It sounds like using vtuner, this would
>>> finally be possible and since Klaus has no intention of ever
>>> modernizing VDR into server/client (that I'm aware of), it's also the
>>> only suitable option as well.
>>
>> I would expect it to still suck. One of the problems you have with trying
>> to pretend things are not networked is that you fake asynchronous events
>> synchronously, you can't properly cover error cases and as a result you
>> get things like ioctls that hang for two minutes or fail in bogus and
>> bizarre ways. If you loop via userspace you've also got to deal with
>> deadlocks and all sorts of horrible cornercases like the user space
>> daemon dying.
>>
>> There is a reason properly working client/server code looks different -
>> it's not a trivial transformation and faking it kernel side won't be any
>> better than faking it in user space - it may well even be a worse fake.
>>
>> Alan
>
> This whole notion of creating fake kernel devices to represent
> networked tuners feels like a hack.  If applications want to access
> networked tuners, adding support for RTP/RTSP or incorporating
> libhdhomerun (LGPL) is a fairly straightforward exercise.  In fact,
> many applications already have incorporated support for one of these
> two approaches.  The fact that app maintainers have been
> unwilling/uninterested to do such doesn't feel like it should be an
> excuse for hacking this functionality into the kernel.

Still the same nonsense - why I should add 10x or even 100 times more
code to achieve not the same but may be 80-90% same result?

The idea is hell simple = allow to use those remote tuners by
100% of dvb api compliant applications. Not 80%, but 100%.

Honza
