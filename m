Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab2EJPMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:12:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65283 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab2EJPMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaiTsaBT=20UUOx2mYsK4r5rArVqXfU9LMObFVb3iEA9w@mail.gmail.com>
References: <1336470270-23518-1-git-send-email-linus.walleij@stericsson.com>
	<4FAAD4EB.4010007@wwwdotorg.org>
	<CACRpkdaiTsaBT=20UUOx2mYsK4r5rArVqXfU9LMObFVb3iEA9w@mail.gmail.com>
Date: Thu, 10 May 2012 17:12:02 +0200
Message-ID: <CACRpkdZ+8n-E_8nyq-kO=Y+GYekkjiNXd3nzTqFnxLszpuKKPg@mail.gmail.com>
Subject: Re: [PATCH 02/12] pinctrl: basic Nomadik pinctrl interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then it's probably a good idea to actually loop in Arnd too...
sorry for missing it!

On Thu, May 10, 2012 at 5:10 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, May 9, 2012 at 10:34 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>>> +static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
>>
>>> +     /* Poke in other ASIC variants here */
>>> +     if (platid->driver_data == PINCTRL_NMK_DB8500)
>>> +             nmk_pinctrl_db8500_init(&npct->soc);
>>
>> Other platforms have a unique top-level driver for each variant, with
>> the probe() function for each variant calling into a utility function.
>> That way, the common/utility code doesn't need to contain a
>> table/list/... of all the variants. Can the same approach be used here?
>
> Of course I could do it that way, but it's not using this feature
> of the driver base to have a string identifier telling which version
> it is.
>
> Since I'm unsure, let's ask Arnd.
>
> Arnd, what is your preferred design pattern of:
>
> A) sub-drivers that register one struct platform_driver per
>  variant, then calls into a shared core driver, or
>
> B) a shared core driver registering one platform_driver
>  with several struct platform_device_id that then call
>  sub-drivers depending on which one is found
>
> Either way is actually OK for me, but I was thinking if one
> is preferred over the other.
>
> Yours,
> Linus Walleij

Linus Walleij
