Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030281Ab2JSNos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:44:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44972 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab2JSNor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:44:47 -0400
MIME-Version: 1.0
In-Reply-To: <1350641746-14520-1-git-send-email-shiraz.hashim@st.com>
References: <1350641746-14520-1-git-send-email-shiraz.hashim@st.com>
Date: Fri, 19 Oct 2012 19:14:47 +0530
Message-ID: <CAKohpok9PNEpvMeKJ0QRHN+pRQuZBEicb3DZgsyht77+wUmGWA@mail.gmail.com>
Subject: Re: [PATCH V2] PWM: Add SPEAr PWM chip driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2012 15:45, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> diff --git a/Documentation/devicetree/bindings/pwm/spear-pwm.txt b/Documentation/devicetree/bindings/pwm/spear-pwm.txt
> +        pwm: pwm@a8000000 {
> +            compatible ="st,spear320-pwm";
> +            reg = <0xa8000000 0x1000>;
> +            #pwm-cells = <2>;
> +            status = "disabled";

Must remove disabled from here. Isn't it?

> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/math64.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#define NUM_PWM                4
> +
> +/* PWM registers and bits definitions */
> +#define PWMCR                  0x00    /* Control Register */
> +#define PWMCR_PWM_ENABLE       0x1
> +#define PWMCR_PRESCALE_SHIFT   2
> +#define PWMCR_MIN_PRESCALE     0x00
> +#define PWMCR_MAX_PRESCALE     0x3FFF

I would do it as to make it more readable, your call:

#define PWMCR                  0x00    /* Control Register */
	#define PWMCR_PWM_ENABLE       0x1
	#define PWMCR_PRESCALE_SHIFT   2
	#define PWMCR_MIN_PRESCALE     0x00
	#define PWMCR_MAX_PRESCALE     0x3FFF

> +static int spear_pwm_remove(struct platform_device *pdev)
> +{
> +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
> +       int i;
> +
> +       if (WARN_ON(!pc))
> +               return -ENODEV;

Sorry for not asking earlier, how can this be true anytime?

--
viresh
