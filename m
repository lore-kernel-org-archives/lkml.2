Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1ESMZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:25:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52550 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab1ESMZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
	<BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
Date: Thu, 19 May 2011 14:25:47 +0200
Message-ID: <BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 1:38 PM, Barry Song <21cnbao@gmail.com> wrote:

>> -arch_initcall(u300_gpio_init);
>> -module_exit(u300_gpio_exit);
>>
> looks like the driver can't be a real module, is the module_exit
> suitable? it looks strange module_exit plays together with
> arch_initcall.

It's a rather common design pattern in the kernel for early
platform drivers. Either the dependencies are resolved by the
different initlevels or they are resolved in probe order with
loadable modules. Module load will call all initlevels in order.

It is not elegant but it is common.

> guess symbol u300_gpio_exit will finally lose in the last vmlinux
> since it is in exit section and built-in kernel.

Yes. And if you one day, to do some testing, compile and load it
as module and unload it, it is handy.

I have other drivers where I simply don't have an exit function
but this one I have actually used.

> another problem i see is after moving gpio/pinmux to drivers as
> platform device, codes in arch/arm/plat(mach) can't  call gpio/pinmux
> api before the related platform devices registerred. that will
> required these platform devices enter system earlier.

This is exactly the reason why the u300 gpio driver needs to
be initialized in an arch_initcall().

Yours,
Linus Walleij
