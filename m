Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2JVNzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:55:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37526 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2JVNzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
References: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
Date: Mon, 22 Oct 2012 19:25:45 +0530
Message-ID: <CAKohpon7e0+PhikmHkgcY30gEH0v+nYJzctA-0wN7w+oDRO7Vw@mail.gmail.com>
Subject: Re: [PATCH V4] PWM: Add SPEAr PWM chip driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: thierry.reding@avionic-design.de, Shiraz Hashim <shiraz.hashim@st.com>
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2012 16:36, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> Add support for PWM chips present on SPEAr platforms. These PWM
> chips support 4 channel output with programmable duty cycle and
> frequency.
>
> More details on these PWM chips can be obtained from relevant
> chapter of reference manual, present at following[1] location.
>
> 1. http://www.st.com/internet/mcu/product/251211.jsp
>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Vipin Kumar <vipin.kumar@st.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> +static int spear_pwm_probe(struct platform_device *pdev)
> +{

> +       ret = pwmchip_add(&pc->chip);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +               return ret;
> +       }

Sorry couldn't think of this complex situation earlier :(

Can it happen that we get a request for a pwm here and its config or enable
gets called...?

If yes, then we must call clk_prepare() before doing pwmchip_add?? Otherwise
you will see a crash :)

@Thierry: Can this happen?

> +       ret = clk_prepare_enable(pc->clk);
> +       if (ret < 0)
> +               return pwmchip_remove(&pc->chip);

--
viresh
