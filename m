Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1DTMLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:11:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1DTMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=DXstV80Ua0D3oDmHUFLjnUcnO22IFK2TPxo4ZqB7KKd/AtvzqB6bB528vGnAod+ayG
         33HG6+kNM+j6RVxugVfJqlhHT9CVyyDQvaKIV41KuiFtMRjKxPb9SGDT8pnxwixtgX58
         fcyncNBw+qn5cuaCJCMpAymUpcikvjLTBpXhg=
MIME-Version: 1.0
In-Reply-To: <34EB51B7-AF3B-4DCE-A402-953B2DBC0474@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418115903.GB9462@sirena.org.uk>
	<34EB51B7-AF3B-4DCE-A402-953B2DBC0474@niasdigital.com>
Date: Wed, 20 Apr 2011 14:11:47 +0200
X-Google-Sender-Auth: 7uNgduRM8PCe5xxCKOzk6UP4ZM8
Message-ID: <BANLkTik_cSUDEjfF6VqdNgxAgQjftGRc4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/19 Ben Nizette <bn@niasdigital.com>:

> It just doesn't make sense to me to bounce from the board code in to
> 'generic' gpio code then back to platform-specific implementations when
> you could cut out the middle man.

In the demonstrated case the U300 GPIO controller has a number
of registers banks per 8-bit port, the U300 GPIO driver in
drivers/gpio/u300-cgpio.c knows the physical whereabouts of
these registers. So it maps them into virtual memory and
manipulate them.

Now to configure a pin from the board code without calling out
to the GPIO subsystem you need to map the same registers
into virtual memory a second time from board-u300-gpio.c,
provide custom set-up functions there and manipulate the
same register range from another place.

This is intuitively bad design to me, it's better to compartmentalize
the GPIO pin handling and whatever it takes into *one*
driver file, not two drivers writing into the same register
range, thanks.

Yours,
Linus Walleij
