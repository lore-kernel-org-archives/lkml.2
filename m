Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab0JIL7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 07:59:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45194 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0JIL7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 07:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f9htciObJSc6dr6r6ifM4lcto0aHK6NnapCm9VxQrfohV+tWaB179GOB02COeMxh63
         aexrOKSsqFAbzlChFe2010zi0pQc2wqQP8HtsjvUtvURz2aTdDxBI/FXx+n9qmF20ed4
         Nj56meixZamOGjkICesC8wKIUDjHNznN75emY=
MIME-Version: 1.0
In-Reply-To: <201010091311.26335.arnd@arndb.de>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
	<201010091311.26335.arnd@arndb.de>
Date: Sat, 9 Oct 2010 14:59:45 +0300
Message-ID: <AANLkTimDd10oj=rruYcB=qTaWWMAJvSCQAJNi+nQqzp7@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/9 Arnd Bergmann <arnd@arndb.de>:
> On Saturday 09 October 2010 12:28:19 Felipe Contreras wrote:
>> Also, what do you think is the right attitude? Do you think all
>> driver writers should follow each and every patch on the mailing list
>> or always try release candidates? Even if they all did (some do),
>> there's no generic solution, so they all are scratching their heads
>> about how to solve this. It might be crystal clear for you how such
>> generic solution could be implemented, or perhaps how some of these
>> drivers can be fixed individually, if so, why don't you come with a
>> proposal to mitigate the pain of fixing such drivers.
>
> Please put this into perspective, it's not like this was ever a
> normal thing to do, and drivers doing an ioremap on kernel memory
> would typically not make it through a review. I've looked through
> the ARM specific drivers that do ioremap and practically all of
> them just map their MMIO registers as they should.
>
> The few drivers that may be hit by this are typically in drivers/staging
> exactly because issues like this have not been fixed yet.
>
> We should probably just fix the non-staging drivers that are hit by
> this now and declare the issue done.
>
> When you say that "many drivers broken", can you list the ones you know
> about? It would probably help resolve this the right way.

I know of tidspbridge, in my original mail I listed some links, one
which mentions: sh_mobile_ceu_camera, maybe i.MX31 users of the
mx3_camera driver: pcm037 and mx31moboard.

http://article.gmane.org/gmane.linux.ports.sh.devel/8560

>From the looks of it, PowerVR SGX seems like it will be broken too:
http://meego.gitorious.org/meego-os-base/kernel-source/trees/master/patches

Other people have been asking questions without mentioning specific drivers too:
http://www.spinics.net/lists/linux-fbdev/msg01745.html

But my guess is that most of the issues would be found after releasing
.36, and of course the current issues cannot possibly be fixed in that
time-frame.

Anyway, Russell said he already reverted the change, which I don't
think is ideal, we need the warning, then I think many more will pop
up.

-- 
Felipe Contreras
