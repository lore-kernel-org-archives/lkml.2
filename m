Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1ERUCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:02:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46753 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1ERUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jA4U1uznWvd3ymFOUhNT+uc30k2KfrioxFZzGNWgqoPoMuK+NMAwtgewQxnQppNm3l
         OKt9km7MgmoUnUpO9CApPfAYQW1x4SBujTSBHFEBB/JtA5bVm8KuAt7EvbMx2Rc7EPas
         AYJ+YBor1ML/+vQ/v5Zl565/2v0Omzg9kPvLw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=TDiAziQU0fYBiK_Npk0x50av7tA@mail.gmail.com>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110503172712.GE6538@lunn.ch>
	<BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
	<20110515133312.GM4071@lunn.ch>
	<BANLkTi=O_mZEqMhOS_Fz0vAYCQ-XpyG4UA@mail.gmail.com>
	<BANLkTi=TDiAziQU0fYBiK_Npk0x50av7tA@mail.gmail.com>
Date: Wed, 18 May 2011 22:02:47 +0200
X-Google-Sender-Auth: BCEdo8JcYG_uayR0SSJf-4UgalI
Message-ID: <BANLkTikUbxHQH-sAP+uOy7bnpZcyN_GHxQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/17 Kyungmin Park <kmpark@infradead.org>:

> In this case we only need to set the function at interrupt by like
> s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
> So pinmux function provides this feature also.

This function:
s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));

Isn't part of the gpiolib I can see, I am discussing with Grant
how to handle custom GPIO configuration. Looking in
archa/arm/plat-samsung/include/plat/gpio-core.h
it looks like you have your own reimplementation of the
entire gpiolib in order to get these special configuration
functions... (So hopefully if I can add custom GPIO
configs to gpiolib, all of this can move to drivers/gpio/*)

So I don't know exactly what this means, if it means that you want to
mux pin 0xf to become GPIO, then yes, in the pinmux framework
you would:

pinmux_request_gpio(pinno, gpiono);

(As you see pins and GPIOs are now in different address spaces
and that is why two number have to be given, but if you manage
it the number space it can basically be the same number if
the platform so permits.)

Yours,
Linus Walleij
