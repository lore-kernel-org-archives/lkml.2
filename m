Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1LFRfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:35:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37005 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1LFRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <4EDE2DFE.9060003@linuxtv.org>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
	<4EDC9B17.2080701@gmail.com>
	<CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
	<4EDD01BA.40208@redhat.com>
	<CAJbz7-1S6K=sDJFcOM8mMxL3t2JS91k+fHLy4gq868_9eUyS9A@mail.gmail.com>
	<4EDE1733.8060409@redhat.com>
	<4EDE1D57.90307@linuxtv.org>
	<4EDE24C6.2020407@redhat.com>
	<4EDE2DFE.9060003@linuxtv.org>
Date: Tue, 6 Dec 2011 18:35:50 +0100
Message-ID: <CAJbz7-2mQ-mCYyqGR8iuP-z_ZaDaGtBS9V9oQxk9pd99tA7AEg@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas

[...]

>>> You don't need to wait for write-only operations. Basically all demux
>>> ioctls are write-only. Since vtunerc is using dvb-core's software demux
>>> *locally*, errors for invalid arguments etc. will be returned as usual.
>>>
>>> What's left is one call to FE_SET_FRONTEND for each frequency to tune
>>> to, and one FE_READ_STATUS for each time the lock status is queried.
>>> Note that one may use FE_GET_EVENT instead of FE_READ_STATUS to get
>>> notified of status changes asynchronously if desired.
>>>
>>> Btw.: FE_SET_FRONTEND doesn't block either, because the driver callback
>>> is called from a dvb_frontend's *local* kernel thread.
>>
>> Still, vtunerc waits for write operations:
>>
>> http://code.google.com/p/vtuner/source/browse/vtunerc_proxyfe.c?repo=linux-driver#285
>>
>> No matter if they are read or write, all of them call this function:
>>
>> http://code.google.com/p/vtuner/source/browse/vtunerc_ctrldev.c?repo=linux-driver#390
>>
>> That has a wait_event inside that function, as everything is directed to
>> the userspace.
>
> Please, stop writing such bullshit! Just before the call to wait_event
> there's code to return from the function if waiting has not been requested.
>
>> This is probably the way Florian found to return the errors returned by
>> the ioctls. This driver is synchronous, with simplifies it, at the lack of
>> performance.
>
> The fix is easy: set the third parameter to 0. A DVB application doesn't
> need to know whether SET_VOLTAGE etc. succeeded or not, because it won't
> get any feedback from the switch. If tuning fails, it has to retry
> anyway, even if all ioctls returned 0.
>
>> Ok, the driver could be smarter than that, and some heuristics could be
>> added into it, in order to foresee the likely error code, returning it
>> in advance, and then implementing some asynchronous mechanism that would
>> handle the error later, but that would be complex and may still introduce
>> some bad behaviors.
>
> There's no need to handle errors that don't occur.
>
> Nobody said that the implementation of vtunerc was perfect. I've already
> listed many things that need to be changed in order to even consider it
> for merging.

Exactly that was an intention for my first RFC - to get driver reviewed by
kernel hackers and enhance/fixe it to prepare it for merging.

I'm going to address all your findings during Xmass, so hopefully I will
spam here again after New Year :-)

I very appreciate your POV which helped me stay remembering
it is not way to the wall.

Thanks

Honza
