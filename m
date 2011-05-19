Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1ESOFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:05:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42420 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab1ESOFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Q5XxLvZhhOomXncfuigYrGqFqFtxEBLdh9x4BGz6T1UAlYMmjE14SKnNcpyJTq+tYH
         Cw5O3EQd8Rw8Pd6gWTLQCrZEaxKUZ9PmSLmygWTpUaBSBKH/XcxR9MFHckpmqWJf1AGB
         /6VbflNftPtOAsTt6C+HQmX7ChQwsvQlFqjsA=
MIME-Version: 1.0
In-Reply-To: <BANLkTinABWucqESqSRYJV+-frm6vDmpxFQ@mail.gmail.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com> <BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
 <BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com> <BANLkTim2rv9QHDd2zjBfyVqG9dSGCM=PAw@mail.gmail.com>
 <BANLkTinABWucqESqSRYJV+-frm6vDmpxFQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 22:05:25 +0800
Message-ID: <BANLkTim=iwHY2NhWuK6qmhAdez-5AiJDBw@mail.gmail.com>
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
> On Thu, May 19, 2011 at 2:35 PM, Barry Song <21cnbao@gmail.com> wrote:
>> 2011/5/19 Linus Walleij <linus.walleij@linaro.org>:
>>> On Thu, May 19, 2011 at 1:38 PM, Barry Song <21cnbao@gmail.com> wrote:
>>>>
>>>> looks like the driver can't be a real module, is the module_exit
>>>> suitable? it looks strange module_exit plays together with
>>>> arch_initcall.
>>>
>>> It's a rather common design pattern in the kernel for early
>>> platform drivers. Either the dependencies are resolved by the
>>> different initlevels or they are resolved in probe order with
>>> loadable modules. Module load will call all initlevels in order.
>>>
>>> It is not elegant but it is common.
>>
>> Linus, thanks for your reply. module_exit and related functions are
>> really useless codes. but people have done that before, then we have
>> no way except following.
>> u300_gpio_exit never gets chance to run and when we disassemble
>> vmlinux, u300_gpio_exit()  function should be not in the final binary
>> at all, just a symbol name is left.
>
> I know. I can make the Kconfig options tristate if it makes you feel
> better...
what i feel headache is that it is really difficult and unpredicted
for an internal gpio driver to be removable in lots of read products
because gpio is probably the last bottom module other drivers need.
even it can be called in arch/arm/plat(mach).

i am not sure whether  i am thinking right. gpio and pinmux are more
things of bottom level APIs like dma/clock tree but not like device
drivers.  but i really think you have sent a great pinmux core
framework.

we once thought we could have a plat-common above all
plat-xxx/mach-xxx, and let the plat-common provide the cores of dma,
clk, gpio, pinmux(pinmux core from you), for example, all common API
and abstract level codes like gpio_request can be there, and SoCs just
implement some hardware-related callbacks required by plat-common in
themselves plat-xxx .

>
> Linus Walleij
>
