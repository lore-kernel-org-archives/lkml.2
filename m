Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2FAB6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:58:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41159 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab2FAB6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZDnFW4-bDsHN5BOr2e5NLGzouSBY7ngf-VsoPn-SyxAA@mail.gmail.com>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
	<1337816857-14694-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdZDnFW4-bDsHN5BOr2e5NLGzouSBY7ngf-VsoPn-SyxAA@mail.gmail.com>
Date: Fri, 1 Jun 2012 09:58:49 +0800
Message-ID: <CAJuYYwQ_ec+dWVd49ZKqO1zk-8x93966gvrWddbx9kS8NBdMvg@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: add samsung pinctrl and gpiolib driver
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org,
        ext Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 June 2012 09:36, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, May 24, 2012 at 7:47 AM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
>
> It would be nice if some DT person could review the bindings, but if
> nothing happens
> I will accept them as-is.
>
> This driver is special since it seems to keep all pin, group and
> function information
> in the device tree, but not like Tony is doing it in pinctrl-simple,
> if I understand
> correctly?
>
>> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
>> new file mode 100644
>> index 0000000..480e2f0
> (...)
>> +/* reading pin pull up/down and driver strength settings not implemented */
>> +static int samsung_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
>> +                                       unsigned long *config)
>> +{
>> +       return -ENOTSUPP;
>> +}
>> +
>> +/* reading pin pull up/down and driver strength settings not implemented */
>> +static int samsung_pinconf_group_get(struct pinctrl_dev *pctldev,
>> +                               unsigned int group, unsigned long *config)
>> +{
>> +       return -ENOTSUPP;
>> +}
>
> I think we made these optional now, so you can just leave them undefined
> in the pinconf_ops.

Ok. I will leave them undefined.

>
>> +static inline struct samsung_pinctrl_drv_data *samsung_pinctrl_get_driver_data(
>> +                               struct platform_device *pdev)
>> +{
>> +#ifdef CONFIG_OF
>> +       if (pdev->dev.of_node) {
>> +               int id;
>> +               const struct of_device_id *match;
>> +               const struct device_node *node = pdev->dev.of_node;
>> +
>> +               id = of_alias_get_id(pdev->dev.of_node, "pinctrl");
>> +               if (id < 0) {
>> +                       dev_err(&pdev->dev, "failed to get alias id\n");
>> +                       return NULL;
>> +               }
>> +               match = of_match_node(samsung_pinctrl_dt_match, node);
>> +               return (struct samsung_pinctrl_drv_data *)match->data + id;
>> +       }
>> +#endif
>
> You don't need this #ifdef because in Kconfig the driver already depends on
> OF so this is always available.

Yes, I missed that.

>
>> +/* driver data for various samsung soc's */
>> +#ifdef CONFIG_CPU_EXYNOS4210
>> +#define EXYNOS4210_PCTRL_DRVDATA (&exynos4210_pinctrl_drv_data)
>> +#else
>> +#define EXYNOS4210_PCTRL_DRVDATA (NULL)
>> +#endif /* CONFIG_CPU_EXYNOS4210 */
>
> Can you do this in some .h file instead?

Ok. I will check on this.

>
>> +#ifdef CONFIG_OF
>
> You don't need this because in Kconfig the driver depends on OF
> already.
>
>> +static const struct of_device_id samsung_pinctrl_dt_match[] = {
>> +#ifdef CONFIG_CPU_EXYNOS4210
>> +       { .compatible = "samsung,pinctrl-exynos4210",
>> +               .data = (void *)exynos4210_pinctrl_drv_data },
>> +#endif /* CONFIG_CPU_EXYNOS4210 */
>> +       {},
>> +};
>> +MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
>> +#endif /* CONFIG_OF */
>
> So delete the closing #endif too.

Initially, it started with dt and non-dt support. Then switched over
to dt-only support and in the process, I left these artifacts. I will
clean this up.

Thank you Linus for your review and comments.

Regards,
Thomas.

>
> Yours,
> Linus Walleij
