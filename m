Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1BUF0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:26:12 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:38124 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1BUF0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:26:10 -0500
Message-ID: <05d38af367ef4d312a506855a3c66689.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110221041011.22543.qmail@stuge.se>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
    <20110220035143.15480.qmail@stuge.se>
    <bf012806f2016262399d27c911a8514d.squirrel@webmail.greenhost.nl>
    <20110221041011.22543.qmail@stuge.se>
Date: Mon, 21 Feb 2011 06:26:05 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Peter Stuge" <peter@stuge.se>
Cc: "Indan Zupancic" <indan@nul.nu>, "LKML" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 9484ae446d4f83cee8bf28db5146d16c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

The new corruption is "fixed" with daniel's patch from
https://lkml.org/lkml/2011/2/20/25

On Mon, February 21, 2011 05:10, Peter Stuge wrote:
> Indan Zupancic wrote:
>> > Confirm I also have this issue on my X40, but there are other bugs
>> > that are much more significant so I haven't bothered mentioning this.
>>
>> What issues?
>
> The one I confirmed is corrupted graphics within Gecko. I haven't had
> Xv working for a long time either. Not sure if I've tried it with
> this kernel though.

Hmm, I recommend upgrading all the graphics userspace too then,
current stuff works pretty well for me.

>
>> If it's backlight related, try my patch at:
>> http://lkml.org/lkml/2011/2/16/447
>
> Yeah also have backlight issue whenever the backlight level changes
> by other means than Fn+Home/End. (Lid switch, screen blank)
> I noticed the patch and that it solved the issue for someone. I'm not
> too inconvenienced by this issue though.

Well, it was for me, because I suspend all the time.

>
>> Or if the screen is black after suspend/screen blank
>
> Oh I've stopped using suspend since using KMS. I get way too angry
> about all the state that I lose if resume fails so I don't risk it.

I never had a failed resume with this laptop, not even once. But I
avoided the early days of KMS because of all the instability.

>
>> Actually, a lot of bugs were recently introduced and fixed, with
>> two months ago you're probably in the new-bugs-only period, so I
>> can recommend trying 2.6.38-rc5.
>
> Yeah, I think it's time to pull Linus' git. I've been keeping an eye
> on things i915 on the list for a good while already.

There were coherency bugs for 855, but those seem to be fixed in the
newer kernel too (2.6.37?), so another reason to upgrade.

>
>> This screen corruption is the only problem for me, but I don't do
>> anything fancy with my laptop. The ipw2200 wireless driver is quite
>> crappy, but it has always been as far as I know.
>
> I've used ipw2200 with great success for many years, but these days
> I'm having fun (no, not at all) with ath9k where there is some very
> fundamental hardware issue between laptop and card. I'd need to hook
> up logic analyzer to say anything concrete, but I have no end of
> problems with internal ath9k in my machine. It's completely unusable.

My impression is that ipw2200's firmware is crappy. Everything is fine
with a good signal, but with a bad one things don't work out too well
after a time.

> The only other annoying issue I have is that as wine enumerates
> available screen resolutions i915 goes out to the VGA connector,
> which on 855 always means a 600ms timeout when nothing is connected,
> but this is a bit tricky because the hardware just can not tell if
> anything is connected.

I have the impression that got better too, but I haven't followed the
development. Can't you just lower the timeout in the code, or let it
cache the VGA status? The latter is what I'd expect the code to do.

Running xrandr to see the modes takes 0.3s here.

> I would be very happy if there was a knob for enabling/disabling the
> VGA connector though.
>
>
>> Good luck,
>
> Thanks, you too!

I can recommend using PHC too, if you don't already: www.linux-phc.org
With it I almost never have the fan running and it uses a lot less power
when under load. (But don't use it till you got your system stable.)

Greetings,

Indan


