Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0FEQ6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:58:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0FEQ6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TnbVfqdfXbL1Vl5wwHwEVkMUvlq6uPTkrRwMR0/8N8EVjtsQj3PEl4/doAnlVh0BxP
         xHMXYALnxZZ+ZDnZqORP07CfC0Y4zzemPger+Te6oaFgkgJcKufLrmXhfMzZw5uhQvgn
         jDGhFd10+XptFBBckXq//aGrKlW8jVLwIGWbI=
MIME-Version: 1.0
In-Reply-To: <4C034F55.1090807@nokia.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
	<AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
	<4BFFCF39.3010507@nokia.com>
	<AANLkTinyh1YLmL6miVAxvkh9RMYDY5JChA-_f7oN0zvb@mail.gmail.com>
	<4C034F55.1090807@nokia.com>
Date: Sat, 5 Jun 2010 19:58:35 +0300
Message-ID: <AANLkTinJLxT845j8fV39jIzO1yznnyugfyimk9zA93z8@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Igor Stoppa <igor.stoppa@nokia.com>
Cc: ext Brian Swetland <swetland@google.com>,
       ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 8:55 AM, Igor Stoppa <igor.stoppa@nokia.com> wrote:
> ext Felipe Contreras wrote:
>
>> I think this information can be obtained dynamically while the
>> application is running,
>
> yes, that was the idea
>
>>  and perhaps the limits can be stored. It would
>> be pretty difficult for the applications to give this kind of
>> information because there are so many variables.
>>
>> For example, an media player can tell you: this clip has 24 fps, but
>> if the user is moving the time slider, the fps would increase and drop
>> very rapidly, and how much depends at least on the container format
>> and type of seek.
>>
>
> I doubt that belongs to typical QoS. Maybe the target could be to be able to
> decode a sequence of i-frames?

I'm not sure what you mean. I-frames comes usually one per second, so
if you only decode I-frames, your experience would be really bad.
Moreover, you don't know beforehand when an I-frame is coming, only
when it's there, and some clips can have only one I-frame at the
beginning.

>> A game or a telephony app could tell you "I need real-time priority"
>> but so much as giving the details of latency and bandwidth? I find
>> that very unlikely.
>>
>
> from my gaming days the games were still evaluated in fps ... maybe i made
> the wrong assumption?

Yes, the more fps, the better, but you calculate that by counting the
amount of frames rendered over a period of time; you know the fps
*after* the fact.

> A telephony app should still be able to tell if it's dropping audio frames.

Yes, which could be unrelated to PM, like bad network conditions, but
yeah, it should also be able to tell if the problem is with the
application itself (audio decoder too slow).

> In all cases there should be some device independent limit - like: what is
> the sort of degradation that is considered acceptable by the typical user?

It is easy to tell after the PM actions have been made, as in "wait!
I'm not able to perform gimme more power!". But I don't see how that
could be done _before_ the PM actions are done.

>From all the QoS proposals I have seen here, and considering that some
people said that suspend blockers could be a specific case of QOS, I
don't think people have been considering QoS as something to state
_after_.

> Tuning might be offered, but at least this should set some sane set of
> defaults.

Huh? Defaults in what units, based on what, and when and how to update?

Cheers.

-- 
Felipe Contreras
