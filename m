Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1DWIZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 04:25:34 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:27214
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214Ab1DWIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 04:25:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAECMsk3LrQ63/2dsb2JhbAANr0K7M4V2BJJY
X-IronPort-AV: E=Sophos;i="4.64,258,1301846400"; 
   d="scan'208";a="701767115"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <BANLkTin_e1Kkn=KGvnqCHvnJVZczRwdnVA@mail.gmail.com>
Date: Sat, 23 Apr 2011 18:25:27 +1000
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <699D6248-729F-4E9B-A9D3-713B653E818F@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418132629.12d9a106@lxorguk.ukuu.org.uk> <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com> <BANLkTi=W7jaVtW1FThvG_ca57q+yDz1kzQ@mail.gmail.com> <E0A55C1E-9DA0-4FFE-90EE-575BB1E649CB@niasdigital.com> <BANLkTin_e1Kkn=KGvnqCHvnJVZczRwdnVA@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 21/04/2011, at 4:48 PM, Linus Walleij wrote:

> 2011/4/21 Ben Nizette <bn@niasdigital.com>:
> 
>>> This patch is about biasing and drive modes. We need to alter
>>> these at runtime (from board code, indeed) due to the fact that
>>> when you go to sleep e.g. floating a pin yeilds better power
>>> characteristics.
>> 
>> This is actually an interesting case because floating pins yeild
>> /worse/ power characteristics (each transistor of the push-pull
>> is on a little bit and you get a path straight through) [1].  To
>> get good power performance you want to pull an input pin high or
>> low but which of those two directions depends on external
>> constraints, i.e. the board.
> 
> Yeah, mea culpa, I twisted it around in my head. I mean the
> reverse. So this is why there are GPIO_CONFIG_BIAS_HIGH
> and GPIO_CONFIG_BIAS_GROUND in the predefined pin
> bias states.
> 
> (I do get it, don't worry, I was in electroscience before I
> turned computer science actually...)

np, did a bit of a double-take myself :)

> 
>>  This is a case where the driver
>> should /not/ go playing with things it can't fully understand.
>> 
>> Perhaps one of the properties that a board can set in a gpio chip
>> driver is the suspend state and have suspend/resume hooks in the
>> gpio chip take care of setting things up on each side.
> 
> Yes, the API is not only for drivers, it's for boards alright.
> 
> Pushing it to drivers/gpio give us two advantages:
> 
> 1. Depopulate the overpopulated arch/arm/* etc trees
> 2. Give an overview so the GPIO maintainer and others can
>  think about consolidations
> 3. Clear cut drivers that can have runtime PM hooks etc...
> 

Yep I think I like this now, looking forward to seeing a few driver
implementations and seeing what kind of cool custom features i/o IP
blocks have that can now be easily and usefully exposed.

Thanks!
	--Ben.

> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

