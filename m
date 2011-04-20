Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1DTPR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:17:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40379 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1DTPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Z0fG9V4WqiOjLBxP6Dm2vwJyA0vI4AumceYPkpEJITG0gm3YzjhV9c2/cSrJQESdUm
         /HmXgw2l9CaW4NLjxLmsb3a+n4D5P0VpZkg83/bpQEEuUn5HB7CtQ+mhsRT8eoYAiKRz
         1gKZjjmekpkiluifm0B3gZC913YjJzDImNCiA=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Oc+y+31KugbEy66Mp96=bf_G8Mg@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
	<BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com>
	<BANLkTinv-MSg5Sobg2X1cJpAwPkM1Gevcg@mail.gmail.com>
	<BANLkTi=Oc+y+31KugbEy66Mp96=bf_G8Mg@mail.gmail.com>
Date: Wed, 20 Apr 2011 17:17:55 +0200
X-Google-Sender-Auth: LzK5nCh1L-_IhYyJJyX04nb6grM
Message-ID: <BANLkTinv_-6dJJXAWc=NFTceXGA9sabanA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, Ben Nizette <bn@niasdigital.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Haojian Zhuang <haojian.zhuang@gmail.com>:

> I have an another question on board initialization. The configuration on pins
> are including drive strength, pull and multiple function.
>
> Since this patch can configure drive strength, pull. Will it be preferred to use
> in board initialization?

I am reusing it (inside the example driver) for drive strength and bias.

Multiple function again is pin/padmuxing.

Even if some people are only muxing pins that can also be used as GPIO,
this is not always the case. We can shunt out the same pins to be used as
I2C or SPI for example, that means this cannot be handled in a GPIO
driver since it has nothing to do with GPIO pins at all.

Thus we need an orthogonal pin/padmux mechanism.

Yours,
Linus Walleij
