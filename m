Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1DUGsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:48:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50202 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1DUGsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bB/c6o/EiIwDoiuti6b2IOaEroUBnkvlaDUBgxymJD6ifCW+JPoRmLcdalB8008yYb
         zq/aH8TFj9PN8dIB06VArRRpZVRG3/H0w0lRlZisYM213sTnL3afbZK/eP8ifRiToh1T
         THDj6ZIIM9WBLvG0bq6RYXpdWQ7dv1/uk4k5o=
MIME-Version: 1.0
In-Reply-To: <E0A55C1E-9DA0-4FFE-90EE-575BB1E649CB@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<BANLkTi=W7jaVtW1FThvG_ca57q+yDz1kzQ@mail.gmail.com>
	<E0A55C1E-9DA0-4FFE-90EE-575BB1E649CB@niasdigital.com>
Date: Thu, 21 Apr 2011 08:48:31 +0200
X-Google-Sender-Auth: Q6h2aNWoNWPQoYrtMqX96HX6ji8
Message-ID: <BANLkTin_e1Kkn=KGvnqCHvnJVZczRwdnVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/21 Ben Nizette <bn@niasdigital.com>:

>> This patch is about biasing and drive modes. We need to alter
>> these at runtime (from board code, indeed) due to the fact that
>> when you go to sleep e.g. floating a pin yeilds better power
>> characteristics.
>
> This is actually an interesting case because floating pins yeild
> /worse/ power characteristics (each transistor of the push-pull
> is on a little bit and you get a path straight through) [1].  To
> get good power performance you want to pull an input pin high or
> low but which of those two directions depends on external
> constraints, i.e. the board.

Yeah, mea culpa, I twisted it around in my head. I mean the
reverse. So this is why there are GPIO_CONFIG_BIAS_HIGH
and GPIO_CONFIG_BIAS_GROUND in the predefined pin
bias states.

(I do get it, don't worry, I was in electroscience before I
turned computer science actually...)

>  This is a case where the driver
> should /not/ go playing with things it can't fully understand.
>
> Perhaps one of the properties that a board can set in a gpio chip
> driver is the suspend state and have suspend/resume hooks in the
> gpio chip take care of setting things up on each side.

Yes, the API is not only for drivers, it's for boards alright.

Pushing it to drivers/gpio give us two advantages:

1. Depopulate the overpopulated arch/arm/* etc trees
2. Give an overview so the GPIO maintainer and others can
  think about consolidations
3. Clear cut drivers that can have runtime PM hooks etc...

Linus Walleij
