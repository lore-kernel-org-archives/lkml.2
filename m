Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1JJLYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:24:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64742 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1JJLYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:24:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ-WTecB-SPXjs531heu4M5Jc-9YvjEV2fPfaHSxiYG2A@mail.gmail.com>
References: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
 <CAGsJ_4yKzyFzJwKgA2nkUf6z2fYoQLB48SOJR82DyAvcut7khQ@mail.gmail.com> <CACRpkdZ-WTecB-SPXjs531heu4M5Jc-9YvjEV2fPfaHSxiYG2A@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 10 Oct 2011 19:23:46 +0800
Message-ID: <CAGsJ_4zkj-nJ9nX+vnLuvJpy124HNqQvUioRpJvLER5WUTZnJQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinmux: add a driver for the U300 pinmux
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Linus Walleij <linus.walleij@linaro.org>:
> On Sat, Oct 8, 2011 at 11:09 AM, Barry Song <21cnbao@gmail.com> wrote:
>>> +static void __init u300_pmx_dumpregs(struct u300_pmx *upmx)
>>> +{
>>> +       u16 regval;
>>> +       int i;
>>> +
>>> +       for (i = 0; i < ARRAY_SIZE(u300_pmx_registers); i++) {
>>> +               regval = readw(upmx->virtbase + u300_pmx_registers[i]);
>>> +               dev_info(upmx->dev, "PMX%u: 0x%04x\n", i, regval);
>>> +       }
>>> +}
>>
>> is this a debug information or do you want it to be in mainline?
>
> Debug info, I'll delete it. Not that it hurt, but I'll kill it.
>
>>> +       /* Create state holders etc for this driver */
>>> +       upmx = devm_kzalloc(&pdev->dev, sizeof(struct u300_pmx), GFP_KERNEL);
>>
>> and this would be "devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL); " ?
>
> Same semantic effect, but if you prefer it that way, sure :-)
>
> I've seen both used in the kernel before...

coding style document says :
"
                  Chapter 14: Allocating memory

  The kernel provides the following general purpose memory allocators:
  kmalloc(), kzalloc(), kcalloc(), vmalloc(), and vzalloc().  Please refer to
  the API documentation for further information about them.

 The preferred form for passing a size of a struct is the following:

          p = kmalloc(sizeof(*p), ...);

  The alternative form where struct name is spelled out hurts readability and
  introduces an opportunity for a bug when the pointer variable type is changed
  but the corresponding sizeof that is passed to a memory allocator is not.
"
>
> Can I have your Reviewed-by: tag after this?

yes. of course.

>
> Linus Walleij
>
Thanks
barry
