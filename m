Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab1ESMgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:36:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50025 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab1ESMgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GhrXNsTde5LcrkE4+Q2YxgwwZUVpnJmIsx/K7sFqBajj4y3ahmuBGscgB+CxYK36gC
         5huxKrCcc8//RH0Ls0pbowC21G3bD9JyfnHMSMx4ofqGAB6qTvG9bxFvAMG6DxX3JyH3
         5im7IfJ75WeTiAKuZdVbdO6THSyaFpX2PGvVA=
MIME-Version: 1.0
In-Reply-To: <BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com> <BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
 <BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 20:35:59 +0800
Message-ID: <BANLkTim2rv9QHDd2zjBfyVqG9dSGCM=PAw@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/19 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, May 19, 2011 at 1:38 PM, Barry Song <21cnbao@gmail.com> wrote:
>
>>> -arch_initcall(u300_gpio_init);
>>> -module_exit(u300_gpio_exit);
>>>
>> looks like the driver can't be a real module, is the module_exit
>> suitable? it looks strange module_exit plays together with
>> arch_initcall.
>
> It's a rather common design pattern in the kernel for early
> platform drivers. Either the dependencies are resolved by the
> different initlevels or they are resolved in probe order with
> loadable modules. Module load will call all initlevels in order.
>
> It is not elegant but it is common.

Linus, thanks for your reply. module_exit and related functions are
really useless codes. but people have done that before, then we have
no way except following.
u300_gpio_exit never gets chance to run and when we disassemble
vmlinux, u300_gpio_exit()  function should be not in the final binary
at all, just a symbol name is left.

>
>> guess symbol u300_gpio_exit will finally lose in the last vmlinux
>> since it is in exit section and built-in kernel.
>
> Yes. And if you one day, to do some testing, compile and load it
> as module and unload it, it is handy.
>
> I have other drivers where I simply don't have an exit function
> but this one I have actually used.
>
>> another problem i see is after moving gpio/pinmux to drivers as
>> platform device, codes in arch/arm/plat(mach) can't  call gpio/pinmux
>> api before the related platform devices registerred. that will
>> required these platform devices enter system earlier.
>
> This is exactly the reason why the u300 gpio driver needs to
> be initialized in an arch_initcall().
>
> Yours,
> Linus Walleij
>
