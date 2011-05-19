Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1ESLiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:38:50 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54235 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab1ESLit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=FDzw60aUdO9sz5ZtmwW3aJg+BXMOwwFexbIn2uQn6IH62ZPTxkRZJzd78GkYOIGIme
         IRnKgHt86Ms0zP9gtL5ChAWe8H83x79d0PCFApbOkmyLGfZ9Po47LUddau0SafwT5trs
         9i8vJyeRmwebjyy2KBVilJlyk050YWV56mxL8=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com> <BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 19:38:27 +0800
Message-ID: <BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -arch_initcall(u300_gpio_init);
> -module_exit(u300_gpio_exit);
>
looks like the driver can't be a real module, is the module_exit
suitable? it looks strange module_exit plays together with
arch_initcall.
guess symbol u300_gpio_exit will finally lose in the last vmlinux
since it is in exit section and built-in kernel.

another problem i see is after moving gpio/pinmux to drivers as
platform device, codes in arch/arm/plat(mach) can't  call gpio/pinmux
api before the related platform devices registerred. that will
required these platform devices enter system earlier.
