Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1JJIRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:17:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58112 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1JJIRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:17:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yKzyFzJwKgA2nkUf6z2fYoQLB48SOJR82DyAvcut7khQ@mail.gmail.com>
References: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4yKzyFzJwKgA2nkUf6z2fYoQLB48SOJR82DyAvcut7khQ@mail.gmail.com>
Date: Mon, 10 Oct 2011 10:17:01 +0200
Message-ID: <CACRpkdZ-WTecB-SPXjs531heu4M5Jc-9YvjEV2fPfaHSxiYG2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 11:09 AM, Barry Song <21cnbao@gmail.com> wrote:
>> +static void __init u300_pmx_dumpregs(struct u300_pmx *upmx)
>> +{
>> +       u16 regval;
>> +       int i;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(u300_pmx_registers); i++) {
>> +               regval = readw(upmx->virtbase + u300_pmx_registers[i]);
>> +               dev_info(upmx->dev, "PMX%u: 0x%04x\n", i, regval);
>> +       }
>> +}
>
> is this a debug information or do you want it to be in mainline?

Debug info, I'll delete it. Not that it hurt, but I'll kill it.

>> +       /* Create state holders etc for this driver */
>> +       upmx = devm_kzalloc(&pdev->dev, sizeof(struct u300_pmx), GFP_KERNEL);
>
> and this would be "devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL); " ?

Same semantic effect, but if you prefer it that way, sure :-)

I've seen both used in the kernel before...

Can I have your Reviewed-by: tag after this?

Linus Walleij
