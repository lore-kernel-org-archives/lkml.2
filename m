Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1DTMTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:19:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54389 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1DTMTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kMoWKNudu1tVi11pMHdb2fjZZZDc5vStIJAtY7NjJ7WFg6qVb6RdiBsbwbntEL4qLu
         r4xZ1PKKaWjrW7YjL2pp99Iug06Jc7Erjotx5E1DFV2GTluQC8a2yP+38FvTzQ7MgoXO
         abVRNEyUkKidsNitkbOSKETnT5CvX/bwbiYR8=
MIME-Version: 1.0
In-Reply-To: <20110418132629.12d9a106@lxorguk.ukuu.org.uk>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
Date: Wed, 20 Apr 2011 14:19:04 +0200
X-Google-Sender-Auth: 2edPrXEBeGUZb4EC4l8iq5epEh8
Message-ID: <BANLkTimZLBG++w5b6D4EtNYPNP6H=hH+uA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/18 Alan Cox <alan@lxorguk.ukuu.org.uk>:

> And for a lot of this stuff that the gpio layer really doesn't want
> internal knowledge of other chunks of the kernel have used models like
> 'get_property/set_property' (eg battery, video4linux etc) so that the mid
> layer can plumb in a conversation between the handle owner and the driver
> without getting involved in the conversation.

I will implement that when I get to consolidare the
plat-nomadik/gpio.c driver. It has custom sleep modes and
stuff noone will be interested in duplicating.

I was thinking of something along the lines of:

int gpio_set_custom(unsigned gpio, unsigned long data);
int gpio_get_custom(unsigned gpio, unsigned long *data);

So like an ioctl() it can pass in/out arbitrary data by
casting to an unsigned long, handling enums, pointers
to structs and the like.

We used this design pattern in the DMA engine, it
works fine for that.

Yours,
Linus Walleij
