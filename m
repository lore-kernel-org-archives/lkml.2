Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2H0UCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:02:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36807 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2H0UCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:02:37 -0400
Message-ID: <503BD258.8050209@wwwdotorg.org>
Date: Mon, 27 Aug 2012 13:02:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/11] pinctrl: mvebu: kirkwood pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1344689809-6223-4-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdbG4jkFcVP_6AmAZzciffQCamKXw7PcFnTdccyq7AMa8A@mail.gmail.com> <343192fa3698ed0575444a5603ed734d@codethink.co.uk> <503BC830.7090705@gmail.com>
In-Reply-To: <503BC830.7090705@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 12:19 PM, Sebastian Hesselbarth wrote:
> On 08/27/2012 03:43 PM, Ben Dooks wrote:
>> On 20/08/2012 06:49, Linus Walleij wrote:
>>> On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
>>> <sebastian.hesselbarth@gmail.com> wrote:
>>> (...)
>>>> diff --git a/drivers/pinctrl/pinctrl-kirkwood.c
>>>> b/drivers/pinctrl/pinctrl-kirkwood.c
>>>> +static struct mvebu_pinctrl_soc_info kirkwood_pinctrl_info;
>>>> +
>>>> +static struct of_device_id kirkwood_pinctrl_of_match[] __devinitdata
>>>> = {
>>>> + { .compatible = "marvell,88f6180-pinctrl",
>>>> + .data = (void *)VARIANT_MV88F6180 },
>>>> + { .compatible = "marvell,88f6190-pinctrl",
>>>> + .data = (void *)VARIANT_MV88F6190 },
>>>> + { .compatible = "marvell,88f6192-pinctrl",
>>>> + .data = (void *)VARIANT_MV88F6192 },
>>>> + { .compatible = "marvell,88f6281-pinctrl",
>>>> + .data = (void *)VARIANT_MV88F6281 },
>>>> + { .compatible = "marvell,88f6282-pinctrl",
>>>> + .data = (void *)VARIANT_MV88F6282 },
>>>> + { }
>>>> +};
>>>
>>> I'm thinking this variant should maybe be an enum... unless it is
>>> strongly established somewhere in Orion/Marvell stuff.
>>>
>>>> +static int __devinit kirkwood_pinctrl_probe(struct platform_device
>>>> *pdev)
>>>> +{
>>>> + struct mvebu_pinctrl_soc_info *soc = &kirkwood_pinctrl_info;
>>>> + const struct of_device_id *match =
>>>> + of_match_device(kirkwood_pinctrl_of_match, &pdev->dev);
>>>> +
>>>> + if (match) {
>>>> + soc->variant = (unsigned)match->data & 0xff;
>>>> + switch (soc->variant) {
>>>> + case VARIANT_MV88F6180:
>>>> + soc->controls = mv88f6180_mpp_controls;
>>>> + soc->ncontrols = ARRAY_SIZE(mv88f6180_mpp_controls);
>>>> + soc->modes = mv88f6xxx_mpp_modes;
>>>> + soc->nmodes = ARRAY_SIZE(mv88f6xxx_mpp_modes);
>>>> + soc->gpioranges = mv88f6180_gpio_ranges;
>>>> + soc->ngpioranges = ARRAY_SIZE(mv88f6180_gpio_ranges);
>>>> + break;
>>>> + case VARIANT_MV88F6190:
>>>> + case VARIANT_MV88F6192:
>>>> + soc->controls = mv88f619x_mpp_controls;
>>>> + soc->ncontrols = ARRAY_SIZE(mv88f619x_mpp_controls);
>>>> + soc->modes = mv88f6xxx_mpp_modes;
>>>> + soc->nmodes = ARRAY_SIZE(mv88f6xxx_mpp_modes);
>>>> + soc->gpioranges = mv88f619x_gpio_ranges;
>>>> + soc->ngpioranges = ARRAY_SIZE(mv88f619x_gpio_ranges);
>>>> + break;
>>>> + case VARIANT_MV88F6281:
>>>> + case VARIANT_MV88F6282:
>>>> + soc->controls = mv88f628x_mpp_controls;
>>>> + soc->ncontrols = ARRAY_SIZE(mv88f628x_mpp_controls);
>>>> + soc->modes = mv88f6xxx_mpp_modes;
>>>> + soc->nmodes = ARRAY_SIZE(mv88f6xxx_mpp_modes);
>>>> + soc->gpioranges = mv88f628x_gpio_ranges;
>>>> + soc->ngpioranges = ARRAY_SIZE(mv88f628x_gpio_ranges);
>>>> + break;
>>>> + }
>>>> + pdev->dev.platform_data = soc;
>>>> + }
>>>> + return mvebu_pinctrl_probe(pdev);
>>>> +}
>>
>> Why not have structures defining the soc-> parameters and use that in the
>> of_match list?
> 
> Ben,
> 
> functionally it is equivalent and IMHO using soc structs doesn't improve
> readability here. I there any other good reason to have structs for each
> soc?

Well, it does change from 6 assignments down to one, and remove the need
for a switch statement - i.e. all of the code quoted above becomes just
roughly:

*soc = *match->data;

