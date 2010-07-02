Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0GBKXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:23:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0GBKXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XbSrQAIICHZbpsUUE205mGAYHU6H5gQjdU5QfbnYqXGWOM8YQrXBYskGvYBETacH63
         qPzYAP2cgOXhEHzFsGoHNVZ5Bl4eh+9aiwZKCmbvLIg7yjBmKhXLe8E4WGe9rTwDs6Vq
         eJef3E4C+foGgxrRV6pna25Dcp3eGH8G6XSDo=
MIME-Version: 1.0
In-Reply-To: <20100702095815.GA6802@skynet.be>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<20100702095815.GA6802@skynet.be>
Date: Fri, 2 Jul 2010 20:23:27 +1000
Message-ID: <AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Luc Verhaegen <libv@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Yes, this a mess indeed.
>
> But i fear that this a mess that cannot be fixed, in its entirety, in a single shot.
>
> Qualcomm making this code available already clearly shows the will and determination of
> some people inside qualcomm to do The Right Thing.
>
> This is Qualcomms first big step on the graphics side, where IP is always amongst the
> heaviest. I am certain that Qualcomm wants to go further, but since Qualcomm most
> likely licenses some parts of their graphics, Qualcomm can only open up those bits that
> they truly own, and then use mainly market/sales-volume driven pressure to get the
> original IP owner to play along.

They own quite a lot of the IP in the 3D core, having bought it from
AMD, you can see the CP packets and PM4 stuff just like in radeon.

>
> You should also take into account who Jordan is. He is one of the guys who worked the
> Geode before AMD decided to drop that, which is when he got hired by Qualcomm. He worked on
> both the graphics drivers and on (then still) LinuxBIOS. I know that redhat has no
> intention of going near coreboot, but in my world one cannot become more free, hardware
> wise, than supporting coreboot. This gives me very good hopes that this is a serious
> attempt by qualcomm to go somewhere, and that this is not some lame attempt to grab
> marketing attention.

I know who Jordan is well from AMD, and I've stated this isn't a
Qualcomm only thing, but companies need to understand that putting
stuff into the kernel is part of a bargain, where you get the benefits
of all the work everyone has done on the kernel and they get the
benefits of being able to do stuff with the code you provide, only
giving us a half arsed interface to the hw and hiding all the good
stuff in userspace isn't accepting this bargain. You can say what you
like about liceneses and legalese but Linus picked the GPL for this
sort of everyone gives what they get.

> Now that you slammed the door on these guys (and on others in the process), what do you
> think the response would be? Where will this get us to in the end?

They'll keep shipping closed stuff, just like they are now. Are you
going to reverse engineer the userspace drivers, so people who care
about open and free software platforms can use these drivers? (or have
you already signed NDAs saying you can't). Why should we maintain a
bunch of kernel code, when they are hiding away all the really useful
stuff that people could improve.

>> b) verifying the sanity of the userspace API.
>> 1. Security: GPUs can do a lot of damage if left at home alone, since
>> mostly you are submitting command streams unverified into the GPU and
>> won't tell us what they mean, there is little way we can work out if
>> the GPU is going to over-write my passwd file to get 5 fps more in
>> quake. Now newer GPUs have at least started having MMUs, but again
>> we've no idea if that is the only way they work without docs or a lot
>> of trust.
>
> This makes me wonder: Why do you even care?
>
> If redhat was working with qualcomm, you would not have taken this stance here at all.

I would, some points
(a) Red Hat is the company I work for.
(b) Red Hat doesn't really care about this stuff at all.
(c) I'm the kernel maintainer for far longer that I worked for Red
Hat, I also work a lot with Intel at Red Hat and I've told them the
same thing, and VIA and now I'm stating it so I don't have to restate
individually to every company again.

> If so, why couldn't you have stated "please guys, have fun with what you are doing, but
> i will not be responsible for it" in a different way.

You don't understand what being a kernel maintainer is do you? at all?

> Now, it is interesting how you now are demanding documentation. When did recent and
> relevant hw documentation happen for ATI? This pretty much died together when the
> ATI<->SuSE relationship died, as the cooperation of SuSE and AMD is how documentation
> was forced out of ATI in the first place, and ATI more and more found ways to get rid
> of this responsibility, or overhead as bridgman would most likely name it.

Wierd I'm still seeing new docs being produced and old docs being
updated, not as fast as I'd like but I understand how many people
there is working on it and I'd rather we also got fixes for all the
current stuff done as well.


> If you are backing this reasoning for ATI, what is wrong with this code being the
> documentation for Qualcomm?

The code doesn't exist, there is no userspace code to be the
documents, if you read what I said, documents would be a good start in
lieu of code, but code is perfectly fine.

> Heh, in some of these cases, not having looked at this code in detail yet, such code
> predates kms, and drm might not have provided what was needed. Not wanting to
> completely diminish the responsibility of qualcomm (or the other companies who are
> working or are forced to work like this), you might want to think about providing
> stable and fitting infrastructure, not just stating that something is how _you_ are
> doing it and declaring that the law.
>
> Next to that, the IP heavy part that cannot be released (yet?) might be some blob that
> is used on both linux, windows, ximbian, etc. The concept of talking to some os
> independent blob through some painful and ever-shifting layer is not that alien even to
> you, with your staunch defending of ATIs AtomBIOS over more direct modesetting.
>
> Also, from where i sit, you complaining about people reinventing the wheel does bring
> me some bitter amusement.
>
> As a conclusion: With you having sent this mail, guess what the guys at qualcomm, and
> most likely imagination technologies and ARM as well (i think we can already discount
> nvidia -- they are far too adept at producing solid closed source drivers -- to
> desktop users satisfaction too), will do next?

Imagintaion technologies seriously? they've never ever taken one step
towards opening anything, I don't think this statement is suddenly
going to jumpstart them.

>
> We already squandered the free software desktop (on x86), and part of the
> responsibility for that is with the graphics hw support (and the radeon versus radeonhd
> story shows nicely how to go about squandering such things). What i see here is that
> you clearly want to go down a similar street with the now blossoming ARM market.
>

Maybe you should disclose what NDAs you currently are under and who
pays your bills, since you accuse me of Red Hat mind-control.

I'm not sure how the ARM market would benefit from having no userspace
3D drivers just like the x86 market, if you actually were normal you'd
realise the ARM people are trying to screw the market just like the
desktop people, to save themselves some money, but maybe working on
closed drivers has twisted you.

Dave.
