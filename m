Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2H1FZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 01:25:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57682 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2H1FZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 01:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbVY1mmzb9H4ZfmVScW1ZNf1FTMLdgo5UFgqTftycMyrQ@mail.gmail.com>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdYqPYesgE-YxPLZqROw1T2fsPWR6R+aDTTz2=XbP7oe9A@mail.gmail.com>
	<CAJuYYwQu7OXQEWCumuMeSKJ2RZD7e==pLKDE1=bvPgfXtO=AUw@mail.gmail.com>
	<CACRpkdbVY1mmzb9H4ZfmVScW1ZNf1FTMLdgo5UFgqTftycMyrQ@mail.gmail.com>
Date: Tue, 28 Aug 2012 10:55:52 +0530
Message-ID: <CAJuYYwRRQ-kd3ABrK82x2onFRFvHYnbVznuSssW_hXYhncDNWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pinctrl: add samsung pinctrl and gpiolib driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng <dong.aisheng@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2012 04:52, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Aug 21, 2012 at 9:22 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:

[...]

>>>> +/* list of all possible config options supported */
>>>> +struct pin_config {
>>>> +       char            *prop_cfg;
>>>> +       unsigned int    cfg_type;
>>>> +} pcfgs[] = {
>>>> +       { "samsung,pin-pud", PINCFG_TYPE_PUD },
>>>> +       { "samsung,pin-drv", PINCFG_TYPE_DRV },
>>>> +       { "samsung,pin-pud-pdn", PINCFG_TYPE_CON_PND },
>>>> +       { "samsung,pin-drv-pdn", PINCFG_TYPE_PUD_PND },
>>>> +};
>>>
>>> Hmmmmm it looks very much like this controller could make use of
>>> the generic pinconf library, but it's not mandatory so just a suggestion.
>>
>> Ok. The last two entries in the above table are Samsung specific and
>> not covered by generic-pinconf. So, I am not sure if it can be added
>> to generic-pinconf.
>
> What is so Samsung-specific about them?
>
> If you tell us the electrical property of setting them we can figure out
> if they should be generic or not...
>

The PINCFG_TYPE_CON_PND and PINCFG_TYPE_PUD_PND are "mux function" and
"pull up/down" settings that are automatically applied to the pin in
powert-down mode. It is same as the usual "mux function" and "pull
up/down" settings, but just that it is applied at suspend.

[...]

>
> OK whatever... looking formward to next iteration!

I have posted the updated version of this patch series based on your
comments (https://lkml.org/lkml/2012/8/23/183).

The only pending comment to be addressed at this point is about the
use of generic-pinconf as mentioned in the comment above. If
PINCFG_TYPE_CON_PND and PINCFG_TYPE_PUD_PND is available in
generic-pinconf, I wil switch to using generic-pinconf. Will that
qualify this Samsung pinctrl driver to be merged into your -devel
branch?

Thanks,
Thomas.
