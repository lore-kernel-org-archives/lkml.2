Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2LMMWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:22:14 -0500
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:37633 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111Ab2LMMWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:22:12 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 07:22:12 EST
Date: Thu, 13 Dec 2012 13:12:42 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 1/1] pwm: atmel: add Timer Counter Block PWM driver
Message-ID: <20121213121242.GB23971@game.jcrosoft.org>
References: <cover.1354810562.git.linux-arm@overkiz.com>
 <2ab3d3afe800febece9994d55813ab71b27c2d25.1354810562.git.linux-arm@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ab3d3afe800febece9994d55813ab71b27c2d25.1354810562.git.linux-arm@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14308780441303559093
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehjedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:45 Thu 06 Dec     , Boris BREZILLON wrote:
> Add TCB PWM driver.
> Add device tree binding.
> 
> Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
> --
>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
>  create mode 100644 drivers/pwm/pwm-atmel-tcb.c
> 
> diff --git a/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
> new file mode 100644
> index 0000000..7644889
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
> @@ -0,0 +1,15 @@
> +Atmel TCB PWM controller
> +
> +Required properties:
> +- compatible: should be "atmel,tcb-pwm"
> +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> +  of the PWM to use and the second cell is the period in nanoseconds.
> +- atmel,tc-block: the Timer Counter block to use as a PWM chip.
> +
> +Example:
> +
> +pwm: pwm@80064000 {
> +	compatible = "fsl,imx28-pwm", "fsl,imx23-pwm";
are you sure?
> +	#pwm-cells = <2>;
> +	atmel,tc-block = <1>;
> +};
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index e513cd9..bda52f7 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -37,6 +37,14 @@ config PWM_AB8500
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-ab8500.
>  
> +config PWM_ATMEL_TCB
> +	bool "TC Block PWM"
> +	depends on ATMEL_TCLIB
> +	select HAVE_PWM
> +	default y
not default y
> +	help
> +	  Select this to get 6 PWM devices.
> +
>  config PWM_BFIN
>  	tristate "Blackfin PWM support"
>  	depends on BFIN_GPTIMERS
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 62a2963..94ba21e 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_PWM)		+= core.o
>  obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
> +obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>  obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
>  obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
> diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
> new file mode 100644
> index 0000000..d5a87cc
> --- /dev/null
> +++ b/drivers/pwm/pwm-atmel-tcb.c
> @@ -0,0 +1,335 @@
> +/*
> + * Copyright (C) Overkiz SAS 2012
> + *
> + * Author: Boris BREZILLON <b.brezillon@overkiz.com>
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/ioport.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/atmel_tc.h>
> +#include <linux/pwm.h>
> +#include <linux/of_device.h>
> +#include <linux/slab.h>
> +
> +#define NPWM	6
> +
> +struct atmel_tcb_pwm_device {
> +	u8 polarity : 1;
> +	u8 clk : 3;
no need to optimise that much
> +	u32 duty;
> +	u32 period;
> +};
> +
> +struct atmel_tcb_pwm_chip {
> +	struct pwm_chip chip;
> +	spinlock_t lock;
> +	struct atmel_tc *tc;
> +	struct atmel_tcb_pwm_device pwms[NPWM];
need to be aloocated
> +};
> +
> +static inline struct atmel_tcb_pwm_chip *to_atmel_tcb_pwm_chip(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct atmel_tcb_pwm_chip, chip);
> +}
> +
> +static int atmel_tcb_pwm_set_polarity (struct pwm_chip *chip, struct pwm_device *pwm,
> +					  enum pwm_polarity polarity)
> +{
> +	struct atmel_tcb_pwm_device *tcbpwm =
> +			(struct atmel_tcb_pwm_device *)pwm_get_chip_data(pwm);
> +
> +	tcbpwm->polarity = polarity;
> +
> +	return 0;
> +}
> +
> +static int atmel_tcb_pwm_request (struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwmc = to_atmel_tcb_pwm_chip(chip);
> +	struct atmel_tcb_pwm_device *tcbpwm = &(tcbpwmc->pwms[pwm->hwpwm]);
> +	struct atmel_tc *tc = tcbpwmc->tc;
> +	void __iomem *regs = tc->regs;
> +	u32 reg;
> +
> +	pwm_set_chip_data(pwm, tcbpwm);
> +	tcbpwm->polarity = PWM_POLARITY_NORMAL;
> +	tcbpwm->duty = 0;
> +	tcbpwm->period = 0;
> +	tcbpwm->clk = 0;
> +	spin_lock(&tcbpwmc->lock);
> +	reg = __raw_readl (regs + ATMEL_TC_REG(pwm->hwpwm / 2, CMR));
no space before (
> +	if (reg & ATMEL_TC_WAVE) {
> +		tcbpwm->duty = __raw_readl (regs + ((pwm->hwpwm % 2) ?
> +				ATMEL_TC_REG(pwm->hwpwm / 2, RB) :
> +				ATMEL_TC_REG(pwm->hwpwm / 2, RA)));
> +
> +
> +		tcbpwm->clk = reg & ATMEL_TC_TCCLKS;
> +		tcbpwm->period = __raw_readl (regs + ATMEL_TC_REG(pwm->hwpwm / 2, RC));
> +		reg &= (ATMEL_TC_TCCLKS |
> +				ATMEL_TC_ACPA | ATMEL_TC_ACPC | ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG |
> +				ATMEL_TC_BCPB | ATMEL_TC_BCPC | ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
> +	}
> +	else
> +		reg = 0;
> +	reg |= ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO | ATMEL_TC_EEVT_XC0;
> +	__raw_writel (reg, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CMR));
> +	spin_unlock(&tcbpwmc->lock);
> +
> +	clk_enable (tc->clk[pwm->hwpwm / 2]);
> +
> +	return 0;
> +}
> +
> +static void atmel_tcb_pwm_free (struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwmc = to_atmel_tcb_pwm_chip(chip);
> +	struct atmel_tc *tc = tcbpwmc->tc;
> +
> +	clk_disable (tc->clk[pwm->hwpwm / 2]);
> +}
> +
> +static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwmc = to_atmel_tcb_pwm_chip(chip);
> +	struct atmel_tcb_pwm_device *tcbpwm =
> +			(struct atmel_tcb_pwm_device *)pwm_get_chip_data(pwm);
> +	struct atmel_tc *tc = tcbpwmc->tc;
> +	void __iomem *regs = tc->regs;
> +	u32 reg;
> +	u32 cmr = 0;
> +	u8 shift = pwm->hwpwm % 2 ? 8 : 0;
> +	enum pwm_polarity polarity = tcbpwm->polarity;
> +
> +	if (tcbpwm->duty == 0)
> +		polarity = !polarity;
> +
> +	if (polarity)
> +		cmr |= ATMEL_TC_ASWTRG_CLEAR;
> +	else
> +		cmr |= ATMEL_TC_ASWTRG_SET;
> +
> +	cmr <<= shift;
> +
> +	spin_lock(&tcbpwmc->lock);
> +	reg = __raw_readl(regs + ATMEL_TC_REG(pwm->hwpwm / 2, CMR));
> +	reg &= ~((ATMEL_TC_ACPA | ATMEL_TC_ACPC | ATMEL_TC_AEEVT | ATMEL_TC_BSWTRG) << shift);
> +	reg |= cmr;
> +	__raw_writel (reg, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CMR));
> +	__raw_writel (ATMEL_TC_SWTRG, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CCR));
> +	if (!(reg & (ATMEL_TC_ACPC | ATMEL_TC_BCPC)))
> +		__raw_writel(ATMEL_TC_SWTRG | ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CCR));
> +	else
> +		__raw_writel (ATMEL_TC_SWTRG, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CCR));
> +	spin_unlock(&tcbpwmc->lock);
> +}
> +
> +static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwmc = to_atmel_tcb_pwm_chip(chip);
> +	struct atmel_tcb_pwm_device *tcbpwm =
> +			(struct atmel_tcb_pwm_device *)pwm_get_chip_data(pwm);
> +	struct atmel_tc *tc = tcbpwmc->tc;
> +	void __iomem *regs = tc->regs;
> +	u32 reg;
> +	u32 cmr = 0;
> +	u8 shift = pwm->hwpwm % 2 ? 8 : 0;
> +	enum pwm_polarity polarity = tcbpwm->polarity;
> +
> +	if (tcbpwm->duty == 0)
> +		polarity = !polarity;
> +
> +	if (polarity)
> +		cmr |= ATMEL_TC_ASWTRG_CLEAR;
> +	else
> +		cmr |= ATMEL_TC_ASWTRG_SET;
> +
> +	if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0) {
> +		if (polarity)
> +			cmr |= ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
> +		else
> +			cmr |= ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
> +	}
> +
> +	cmr <<= shift;
> +	cmr |= tcbpwm->clk;
> +
> +	spin_lock(&tcbpwmc->lock);
> +	reg = __raw_readl(regs + ATMEL_TC_REG(pwm->hwpwm / 2, CMR));
> +	reg &= ~(((ATMEL_TC_ACPA |
> +				ATMEL_TC_ACPC |
> +				ATMEL_TC_AEEVT |
> +				ATMEL_TC_ASWTRG) << shift) |
> +			ATMEL_TC_TCCLKS);
> +	reg |= cmr;
> +	__raw_writel (reg, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CMR));
> +	__raw_writel(tcbpwm->duty, regs + ((pwm->hwpwm % 2) ? ATMEL_TC_REG(pwm->hwpwm / 2, RB) : ATMEL_TC_REG(pwm->hwpwm / 2, RA)));
> +	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(pwm->hwpwm / 2, RC));
> +	__raw_writel (ATMEL_TC_CLKEN | ATMEL_TC_SWTRG, regs + ATMEL_TC_REG(pwm->hwpwm / 2, CCR));
> +	spin_unlock(&tcbpwmc->lock);
> +	return 0;
> +}
> +
> +static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +		int duty_ns, int period_ns)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwmc = to_atmel_tcb_pwm_chip(chip);
> +	struct atmel_tcb_pwm_device *tcbpwm =
> +			(struct atmel_tcb_pwm_device *)pwm_get_chip_data(pwm);
> +	struct atmel_tcb_pwm_device *atcbpwm = &(tcbpwmc->pwms[pwm->hwpwm % 2 ? pwm->hwpwm - 1 : pwm->hwpwm + 1]);
> +	struct atmel_tc *tc = tcbpwmc->tc;
> +	int i;
> +	int slowclk = 0;
> +	u32 period;
> +	u32 rate = clk_get_rate(tc->clk[pwm->hwpwm / 2]);
> +	u64 min;
> +	u64 max;
> +	u64 duty;
> +
> +	for (i = 0; i < 5; ++i) {
> +		if (atmel_tc_divisors[i] == 0) {
> +			slowclk = i;
> +			continue;
> +		}
> +		min = div_u64 (1000000000, div_u64 (rate, atmel_tc_divisors[i]));
> +		max = min << tc->tcb_config->counter_width;
> +		if (max >= period_ns)
> +			break;
> +	}
> +
> +	if (i == 5) {
> +		i = slowclk;
> +		rate = 32768;
> +		min = div_u64 (1000000000, rate);
> +		max = min << 16;
> +
> +		if (max < period_ns)
> +			return -ERANGE;
> +	}
> +
> +	duty = div_u64 (duty_ns, min);
> +	duty &=  ((u64)(1 << tc->tcb_config->counter_width) - 1);
> +
> +	period = div_u64 (period_ns, min);
> +	period &= ((u64)(1 << tc->tcb_config->counter_width) - 1);
> +
> +	if ((atcbpwm->duty > 0 && atcbpwm->duty != atcbpwm->period) &&
> +		(atcbpwm->clk != i || atcbpwm->period != period)) {
> +		dev_err(chip->dev, "failed to configure period_ns\n");
> +		return -EINVAL;
> +	}
> +
> +	tcbpwm->period = period;
> +	tcbpwm->clk = i;
> +	tcbpwm->duty = duty;
> +
> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
> +		atmel_tcb_pwm_enable(chip, pwm);
> +
> +	return 0;
> +}
> +
> +static const struct pwm_ops atmel_tcb_pwm_ops = {
> +	.set_polarity = atmel_tcb_pwm_set_polarity,
> +	.request = atmel_tcb_pwm_request,
> +	.free = atmel_tcb_pwm_free,
> +	.config = atmel_tcb_pwm_config,
> +	.enable = atmel_tcb_pwm_enable,
> +	.disable = atmel_tcb_pwm_disable,
> +};
> +
> +static int __devinit atmel_tcb_pwm_probe(struct platform_device *pdev)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwm;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct atmel_tc *tc;
> +	int err;
> +	int tcblock;
> +
> +
> +	err = of_property_read_u32(np, "tc-block", &tcblock);
> +	if (err < 0) {
> +		dev_err(&pdev->dev,
> +				"failed to get tc block number from device tree (error: %d)\n", err);
> +		return err;
> +	}
> +
> +	tc = atmel_tc_alloc(tcblock, "tcb-pwm");
> +	if (tc == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
> +		return -ENOMEM;
> +	}
> +
> +	tcbpwm = kzalloc(sizeof(*tcbpwm), GFP_KERNEL);
devm

I'll check more in detail later the tc part

Best Regards,
J.
> +	if (tcbpwm == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	tcbpwm->chip.dev = &pdev->dev;
> +	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
> +	tcbpwm->chip.base = pdev->id;
> +	tcbpwm->chip.npwm = NPWM;
> +	tcbpwm->tc = tc;
> +
> +	spin_lock_init(&tcbpwm->lock);
> +
> +	err = pwmchip_add(&tcbpwm->chip);
> +	if (err < 0) {
> +		kfree(tcbpwm);
> +		return err;
> +	}
> +
> +	dev_dbg(&pdev->dev, "pwm probe successful\n");
> +	platform_set_drvdata(pdev, tcbpwm);
> +
> +	return 0;
> +}
> +
> +static int __devexit atmel_tcb_pwm_remove(struct platform_device *pdev)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwm = platform_get_drvdata(pdev);
> +	int err;
> +
> +	err = pwmchip_remove(&tcbpwm->chip);
> +	if (err < 0)
> +		return err;
> +
> +	atmel_tc_free(tcbpwm->tc);
> +
> +	dev_dbg(&pdev->dev, "pwm driver removed\n");
> +	kfree(tcbpwm);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id atmel_tcb_pwm_dt_ids[] = {
> +	{ .compatible = "atmel,tcb-pwm", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mxs_pwm_dt_ids);
> +
> +static struct platform_driver atmel_tcb_pwm_driver = {
> +	.driver = {
> +		.name = "atmel-tcb-pwm",
> +		.of_match_table = of_match_ptr(atmel_tcb_pwm_dt_ids),
> +	},
> +	.probe = atmel_tcb_pwm_probe,
> +	.remove = __devexit_p(atmel_tcb_pwm_remove),
> +};
> +module_platform_driver(atmel_tcb_pwm_driver);
> +
> +MODULE_AUTHOR("Boris BREZILLON <b.brezillon@overkiz.com>");
> +MODULE_DESCRIPTION("Atmel Timer Counter Pulse Width Modulation Driver");
> +MODULE_ALIAS("platform:atmel-tcb-pwm");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.7.0.4
> 
