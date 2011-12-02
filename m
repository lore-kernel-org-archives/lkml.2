Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1LBL6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:58:04 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59782 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1LBL6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:58:01 -0500
MIME-Version: 1.0
In-Reply-To: <4ED8B327.9090505@redhat.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<4ED7BBA3.5020002@redhat.com>
	<CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com>
	<4ED7E5D7.8070909@redhat.com>
	<4ED805CB.5020302@linuxtv.org>
	<4ED8B327.9090505@redhat.com>
Date: Fri, 2 Dec 2011 12:57:58 +0100
Message-ID: <CAJbz7-2EVgwPY0wkqPVCoOyH2gM_7pf0DzP-Lf4Y65uZpci9GQ@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

>>> you failed to convince
>>> people
>>> why this can't be implemented on userspace,
>>
>> Wrong. You failed to convince people why this must be implemented in
>> userspace. Even Michael Krufky, who's "only" against merging it, likes
>> the idea, because it's useful.
>
> Sometimes, when I'm debugging a driver, I use to add several hacks inside
> the kernelspace, in order to do things that are useful on my development
> (debug printk's, dirty hacks, etc). I even have my own set of patches that
> I apply on kvm, in order to sniff PCI traffic. This doesn't mean that
> I should send all those crap upstream.

If you want to disscuss, please better use wordings. Even my Subject was
not about endless discussion that your userspace aproach is better
(me, Andreas and few others doesn't agree with you, it is your own POV,
nobody follows you, if you not noted) don't be so offensive regarding my code.
I don't thing it is so crap.

>
>> Just because something can be implemented in userspace doesn't mean that
>> it's technically superior.
>
> True, but I didn't see anything at the submitted code or at the discussions
> showing that implementing it in kernelspace is technically superior.
>
> What I'm seeing is what is coded there:
>
>        http://code.google.com/p/vtuner/
>
> The kernelspace part is just a piggyback driver, that just copies data
> from/to
> the dvb calls into another device, that sends the request back to userspace.
>
> A separate userspace daemon will get such results and send to the network
> stack:
>
>  http://code.google.com/p/vtuner/source/browse/vtuner-network.c?repo=apps
>
> This is technically inferior of letting the application just talk to vtuner
> directly via some library call.
>
> Btw, applications like vdr, vlc, kaffeine and others already implement their
> own ways to remotelly access the DVB devices without requiring any
> kernelspace piggyback driver.

This in not only about well-known "fatty" applications like vdr, kaffeine etc.
Using vtunerc allows to use any dvb api compatible tools. Like tools
from dvb-tools package (szap/dvbsnoop/...)

There is no more general way of having dvb adapter virtualized.

>
>>> the driver adds hooks at
>>> kernelspace
>>> that would open internal API's that several developers don't agree on
>>> exposing
>>> at userspace, as would allow non GPL license compatible drivers to re-use
>>> their work in a way they are against.
>>
>> What's left is your unreasonable GPL blah blah. So the answer to Honza's
>> question is: Yes, Mauro is nacking the driver because he's worrying
>> about possible misuse.

Well, yes. I feel the same what wrote Andreas. The only pity is that
nobody from outside linuxm-media need to comment that.

Honza
