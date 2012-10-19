Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab2JSQpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:45:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34193 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab2JSQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpok9PNEpvMeKJ0QRHN+pRQuZBEicb3DZgsyht77+wUmGWA@mail.gmail.com>
References: <1350641746-14520-1-git-send-email-shiraz.hashim@st.com>
	<CAKohpok9PNEpvMeKJ0QRHN+pRQuZBEicb3DZgsyht77+wUmGWA@mail.gmail.com>
Date: Fri, 19 Oct 2012 22:15:27 +0530
Message-ID: <CAPub14-ekG+ncJDPyt3Ef04CKJo5cjLDO32GMEaCLnmYiYL1Nw@mail.gmail.com>
Subject: Re: [PATCH V2] PWM: Add SPEAr PWM chip driver support
From: shiraz hashim <shiraz.linux.kernel@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Oct 19, 2012 at 7:14 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 19 October 2012 15:45, Shiraz Hashim <shiraz.hashim@st.com> wrote:
>> diff --git a/Documentation/devicetree/bindings/pwm/spear-pwm.txt b/Documentation/devicetree/bindings/pwm/spear-pwm.txt
>> +        pwm: pwm@a8000000 {
>> +            compatible ="st,spear320-pwm";
>> +            reg = <0xa8000000 0x1000>;
>> +            #pwm-cells = <2>;
>> +            status = "disabled";
>
> Must remove disabled from here. Isn't it?

yes, would remove it.

>> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/ioport.h>
>> +#include <linux/kernel.h>
>> +#include <linux/math64.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pwm.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +
>> +#define NUM_PWM                4
>> +
>> +/* PWM registers and bits definitions */
>> +#define PWMCR                  0x00    /* Control Register */
>> +#define PWMCR_PWM_ENABLE       0x1
>> +#define PWMCR_PRESCALE_SHIFT   2
>> +#define PWMCR_MIN_PRESCALE     0x00
>> +#define PWMCR_MAX_PRESCALE     0x3FFF
>
> I would do it as to make it more readable, your call:
>
> #define PWMCR                  0x00    /* Control Register */
>         #define PWMCR_PWM_ENABLE       0x1
>         #define PWMCR_PRESCALE_SHIFT   2
>         #define PWMCR_MIN_PRESCALE     0x00
>         #define PWMCR_MAX_PRESCALE     0x3FFF

There are some who don't like this (personally I see it quite clear),
so it becomes a matter of choice. I intentionaly prefixed each
bit definition by its register name to make association clear.

>
>> +static int spear_pwm_remove(struct platform_device *pdev)
>> +{
>> +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
>> +       int i;
>> +
>> +       if (WARN_ON(!pc))
>> +               return -ENODEV;
>
> Sorry for not asking earlier, how can this be true anytime?

Probably never :), just copied from some other implementation.
Would remove this in V3.

-- 
regards
Shiraz Hashim
