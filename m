Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1ESNRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:17:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38825 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1ESNRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim2rv9QHDd2zjBfyVqG9dSGCM=PAw@mail.gmail.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
	<BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
	<BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com>
	<BANLkTim2rv9QHDd2zjBfyVqG9dSGCM=PAw@mail.gmail.com>
Date: Thu, 19 May 2011 15:17:35 +0200
Message-ID: <BANLkTinABWucqESqSRYJV+-frm6vDmpxFQ@mail.gmail.com>
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

On Thu, May 19, 2011 at 2:35 PM, Barry Song <21cnbao@gmail.com> wrote:
> 2011/5/19 Linus Walleij <linus.walleij@linaro.org>:
>> On Thu, May 19, 2011 at 1:38 PM, Barry Song <21cnbao@gmail.com> wrote:
>>>
>>> looks like the driver can't be a real module, is the module_exit
>>> suitable? it looks strange module_exit plays together with
>>> arch_initcall.
>>
>> It's a rather common design pattern in the kernel for early
>> platform drivers. Either the dependencies are resolved by the
>> different initlevels or they are resolved in probe order with
>> loadable modules. Module load will call all initlevels in order.
>>
>> It is not elegant but it is common.
>
> Linus, thanks for your reply. module_exit and related functions are
> really useless codes. but people have done that before, then we have
> no way except following.
> u300_gpio_exit never gets chance to run and when we disassemble
> vmlinux, u300_gpio_exit()  function should be not in the final binary
> at all, just a symbol name is left.

I know. I can make the Kconfig options tristate if it makes you feel
better...

Linus Walleij
