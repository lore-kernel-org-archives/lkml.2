Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2LSL3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:29:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2LSL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:29:08 -0500
Date: Wed, 19 Dec 2012 12:26:10 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v3] pwm: atmel: add Timer Counter Block PWM driver
Message-ID: <20121219112610.GA22613@avionic-0098.adnet.avionic-design.de>
References: <1355742810-4241-1-git-send-email-linux-arm@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1355742810-4241-1-git-send-email-linux-arm@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VsGYQbVbbmnyy7G5n3Kv0LtmOz0F2Qs1UmZDqaUYQ/M
 wWzRL0AXsEL67u7J7ODqF0HCNB7Wp2sRCnJTPO7RF1eYJJtIlb
 UQed5e6CO9607zaHzsDSzvb3C44yDiekNlLEDo27WMVoGlcfNq
 O1YnD5fANE3SQaS/+OrtpeqyI0h2P1zV4dPOrrrRxUZtSuHy7O
 RtONcKymCg5rhlfA0RVavd0Ex6iFa2o2U0Rk1QnArC2YbmCznb
 g4i/Spu3lGxx3jvQUw1OZK6IfpTpe7bwfwCv0IZo9KVhp6KORg
 Uhy4s/kGMrezsakBPGvkMdaQyw5DaMTyqo1jEWuA+6vkLWYuaV
 AchvB5fr+3naxlVZSiJV0LOIuopFPbPrGxKrs4C+HJX4kSDPuJ
 Pt+fba1scV9ZrwsfVG+dXKUQ92aBpqJrkE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 17, 2012 at 12:13:30PM +0100, Boris BREZILLON wrote:
> Hello,
>=20
> This patch adds a PWM driver based on Atmel Timer Counter Block.
> Timer Counter Block is used in Waveform generator mode.
>=20
> A Timer Counter Block provides up to 6 PWM devices grouped by 2:
> * group 0 =3D PWM 0 and 1
> * group 1 =3D PWM 1 and 2
> * group 2 =3D PMW 3 and 4
>=20
> PWM devices in a given group must be configured with the same
> period value.
> If a PWM device in a group tries to change the period value and
> the other device is already configured with a different value an
> error will be returned.
>=20
> This driver requires device tree support.
> The Timer Counter Block number used to create a PWM chip is
> given by tc-block field in an "atmel,pwm-tcb" compatible node.

The device tree binding says that the compatible value should be
"atmel,tcb-pwm", not "atmel,pwm-tcb".

> diff --git a/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt b/Do=
cumentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
> new file mode 100644
> index 0000000..bd99fdd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
> @@ -0,0 +1,18 @@
> +Atmel TCB PWM controller
> +
> +Required properties:
> +- compatible: should be "atmel,tcb-pwm"
> +- #pwm-cells: should be 3.  The first cell specifies the per-chip index

"Should be 3." Capital S since you terminate the sentence with a full
stop.

> +  of the PWM to use, the second cell is the period in nanoseconds and
> +  bit 0 in the third cell is used to encode the polarity of PWM output.
> +  Set bit 0 of the third in PWM specifier to 1 for inverse polarity &

"of the third cell"

> +  set to 0 for normal polarity.
> +- tc-block: the Timer Counter block to use as a PWM chip.

Also: "The Timer Counter..." because of the terminating full stop.

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index e513cd9..2f4941b 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -37,6 +37,18 @@ config PWM_AB8500
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-ab8500.
> =20
> +config PWM_ATMEL_TCB
> +	tristate "TC Block PWM"
> +	depends on ATMEL_TCLIB && OF
> +	help
> +	  Generic PWM framework driver for Atmel Timer Counter Block.
> +
> +	  A Timer Counter Block provides 6 PWM devices grouped by 2.
> +	  Devices in a given group must have the same period.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-atmel-tc.

The Makefile says it is called pwm-atmel-tc_b_.

> diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
[...]
> +static int atmel_tcb_pwm_set_polarity(struct pwm_chip *chip,
> +					  struct pwm_device *pwm,
> +					  enum pwm_polarity polarity)

The arguments are no longer properly aligned.

> +static int atmel_tcb_pwm_request(struct pwm_chip *chip,
> +					  struct pwm_device *pwm)

Same here.

> +	} else
> +		cmr =3D 0;
> +	cmr |=3D ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO | ATMEL_TC_EEVT_XC0;

There should be a blank line between the above two lines for better
readability.

> +	/* If duty is 0 reverse polarity */
> +	if (tcbpwm->duty =3D=3D 0)
> +		polarity =3D !polarity;
> +
> +	if (polarity =3D=3D PWM_POLARITY_INVERSED) {
> +		if (index =3D=3D 0)
> +			newcmr |=3D ATMEL_TC_ASWTRG_CLEAR;
> +		else
> +			newcmr |=3D ATMEL_TC_BSWTRG_CLEAR;
> +	} else {
> +		if (index =3D=3D 0)
> +			newcmr |=3D ATMEL_TC_ASWTRG_SET;
> +		else
> +			newcmr |=3D ATMEL_TC_BSWTRG_SET;
> +	}
> +
> +	spin_lock(&tcbpwmc->lock);
> +	cmr =3D __raw_readl(regs + ATMEL_TC_REG(group, CMR));
> +
> +	/* flush old setting */
> +	if (index =3D=3D 0)
> +		cmr &=3D ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC |
> +				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG);
> +	else
> +		cmr &=3D ~(ATMEL_TC_BCPB | ATMEL_TC_BCPC |
> +				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);

These should be aligned differently:

		cmr &=3D ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC | ATMEL_TC_AEEVT |
			 ATMEL_TC_ASWTRG);

Although maybe you should define a mask for this since you reuse the
exact same sequence in atmel_tcb_pwm_enable().

> +
> +	/* configure new setting */
> +	cmr |=3D newcmr;
> +	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));

I wonder why you bother setting newcmr and OR'ing it into cmr. Couldn't
you just mask all previous settings in cmr first, then OR the new bits?

> +
> +	/*
> +	 * Use software trigger to apply the new setting.
> +	 * If both pwm devices in this group are disabled we stop the clock.

"both PWM devices"

> +	 */
> +	if (!(cmr & (ATMEL_TC_ACPC | ATMEL_TC_BCPC)))
> +		__raw_writel(ATMEL_TC_SWTRG | ATMEL_TC_CLKDIS,
> +				regs + ATMEL_TC_REG(group, CCR));
> +	else
> +		__raw_writel(ATMEL_TC_SWTRG, regs +
> +				ATMEL_TC_REG(group, CCR));
> +	spin_unlock(&tcbpwmc->lock);

This could use another blank line.

> +	/*
> +	 * If duty is 0 or equal to period there's no need to register
> +	 * a specific action on RA/RB and RC compare.
> +	 * The output will be configured on software trigger and keep
> +	 * this config till next config call.
> +	 */
> +	if (tcbpwm->duty !=3D tcbpwm->period && tcbpwm->duty > 0) {
> +		if (polarity =3D=3D PWM_POLARITY_INVERSED) {
> +			if (index =3D=3D 0)
> +				newcmr |=3D
> +					ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
> +			else
> +				newcmr |=3D
> +					ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
> +		} else {
> +			if (index =3D=3D 0)
> +				newcmr |=3D
> +					ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
> +			else
> +				newcmr |=3D
> +					ATMEL_TC_BCPB_CLEAR | ATMEL_TC_BCPC_SET;

If you can get rid of newcmr and OR directly into cmr instead, these
will fit on one line.

> +		}
> +	}
> +
> +	newcmr |=3D tcbpwm->clk;
> +
> +	spin_lock(&tcbpwmc->lock);
> +	cmr =3D __raw_readl(regs + ATMEL_TC_REG(group, CMR));
> +
> +	/* flush old setting */
> +	cmr &=3D ~ATMEL_TC_TCCLKS;
> +	if (index =3D=3D 0)
> +		cmr &=3D ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC |
> +				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG);
> +	else
> +		cmr &=3D ~(ATMEL_TC_BCPB | ATMEL_TC_BCPC |
> +				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
> +
> +	/* configure new setting */
> +	cmr |=3D newcmr;
> +	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
> +
> +	if (index =3D=3D 0)
> +		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RA));
> +	else
> +		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RB));
> +	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(group, RC));

Could use another blank line.

> +static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device=
 *pwm,
> +		int duty_ns, int period_ns)

These aren't properly aligned.

> +{
> +	struct atmel_tcb_pwm_chip *tcbpwmc =3D to_tcb_chip(chip);
> +	struct atmel_tcb_pwm_device *tcbpwm =3D pwm_get_chip_data(pwm);
> +	unsigned group =3D pwm->hwpwm / 2;
> +	unsigned index =3D pwm->hwpwm % 2;
> +	struct atmel_tcb_pwm_device *atcbpwm =3D NULL;
> +	struct atmel_tc *tc =3D tcbpwmc->tc;
> +	int i;
> +	int slowclk =3D 0;
> +	unsigned period;
> +	unsigned duty;
> +	unsigned rate =3D clk_get_rate(tc->clk[group]);
> +	unsigned long long min;
> +	unsigned long long max;
> +
> +	/*
> +	 * Find best clk divisor:
> +	 * the smallest divisor which can fulfill the period_ns requirements.
> +	 */
> +	for (i =3D 0; i < 5; ++i) {
> +		if (atmel_tc_divisors[i] =3D=3D 0) {
> +			slowclk =3D i;
> +			continue;
> +		}
> +		min =3D div_u64((unsigned long long)1000000000 *
> +						atmel_tc_divisors[i],
> +						rate);

Maybe use NSEC_PER_SEC instead? Like this:

		min =3D div_u64((u64)NSEC_PER_SEC * atmel_tc_divisors[i], rate);

> +		max =3D min << tc->tcb_config->counter_width;
> +		if (max >=3D period_ns)
> +			break;
> +	}
> +
> +	/*
> +	 * If none of the divisor are small enough to represent period_ns
> +	 * take slow clock (32KHz).
> +	 */
> +	if (i =3D=3D 5) {
> +		i =3D slowclk;
> +		rate =3D 32768;
> +		min =3D div_u64(1000000000, rate);

Again this is NSEC_PER_SEC.

> +		max =3D min << 16;
> +
> +		/* If period is too big return ERANGE error */
> +		if (max < period_ns)
> +			return -ERANGE;
> +	}
> +
> +	duty =3D div_u64(duty_ns, min);
> +	period =3D div_u64(period_ns, min);
> +
> +	if (index =3D=3D 0)
> +		atcbpwm =3D tcbpwmc->pwms[pwm->hwpwm + 1];
> +	else
> +		atcbpwm =3D tcbpwmc->pwms[pwm->hwpwm - 1];
> +
> +	/*
> +	 * Check that associated PWM (if present) is configured
> +	 * with the same period.
> +	 * If not, return an error.
> +	 */
> +	if ((atcbpwm && atcbpwm->duty > 0 &&
> +			atcbpwm->duty !=3D atcbpwm->period) &&
> +		(atcbpwm->clk !=3D i || atcbpwm->period !=3D period)) {
> +		dev_err(chip->dev, "failed to configure period_ns\n");
> +		return -EINVAL;
> +	}

I had to read this a couple of times to figure out that what you check
for is consistency with the settings of the second PWM of the same
group. Maybe you can make this a bit clearer in the comment.
"associated PWM" is a bit vague. Also maybe the error message should
mention that the reason why the period cannot be configured is that the
settings for this PWM are incompatible with those of the sibling.

Also, the atcbpwm->clk field seems to refer to a divider, so renaming it
to atcbpwm->div might be more appropriate.

> +
> +	tcbpwm->period =3D period;
> +	tcbpwm->clk =3D i;
> +	tcbpwm->duty =3D duty;
> +
> +	/* If the PWM is enabled, call enable to apply the new conf */
> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
> +		atmel_tcb_pwm_enable(chip, pwm);
> +
> +	return 0;
> +}
> +
> +static const struct pwm_ops atmel_tcb_pwm_ops =3D {
> +	.set_polarity =3D atmel_tcb_pwm_set_polarity,
> +	.request =3D atmel_tcb_pwm_request,
> +	.free =3D atmel_tcb_pwm_free,
> +	.config =3D atmel_tcb_pwm_config,
> +	.enable =3D atmel_tcb_pwm_enable,
> +	.disable =3D atmel_tcb_pwm_disable,
> +};

Can you put these in the same order as defined by struct pwm_ops?

> +
> +static int atmel_tcb_pwm_probe(struct platform_device *pdev)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwm;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct atmel_tc *tc;
> +	int err;
> +	int tcblock;
> +
> +	err =3D of_property_read_u32(np, "tc-block", &tcblock);
> +	if (err < 0) {
> +		dev_err(&pdev->dev,
> +				"failed to get tc block number from device tree (error: %d)\n",
> +				err);

These should align with &pdev->dev.

> +		return err;
> +	}
> +
> +	tc =3D atmel_tc_alloc(tcblock, "tcb-pwm");
> +	if (tc =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
> +		return -ENOMEM;
> +	}
> +
> +	tcbpwm =3D devm_kzalloc(&pdev->dev, sizeof(*tcbpwm), GFP_KERNEL);
> +	if (tcbpwm =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}

Shouldn't you free tc in this case?

> +
> +	tcbpwm->chip.dev =3D &pdev->dev;
> +	tcbpwm->chip.ops =3D &atmel_tcb_pwm_ops;
> +	tcbpwm->chip.of_xlate =3D of_pwm_xlate_with_flags;
> +	tcbpwm->chip.of_pwm_n_cells =3D 3;
> +	tcbpwm->chip.base =3D -1;
> +	tcbpwm->chip.npwm =3D NPWM;
> +	tcbpwm->tc =3D tc;
> +
> +	spin_lock_init(&tcbpwm->lock);
> +
> +	err =3D pwmchip_add(&tcbpwm->chip);
> +	if (err < 0) {
> +		devm_kfree(&pdev->dev, tcbpwm);

No need to call this. The whole point of the device-managed functions is
that you don't have to care about the cleanup in the error path. However
the atmel_tc_alloc() doesn't seem to be managed, so you should probably
call atmel_tc_free() to release it, right?

> +		return err;
> +	}
> +
> +	dev_dbg(&pdev->dev, "pwm probe successful\n");

I think this can go away now. The kernel will tell you if the driver
can't be probed successfully, so keeping this isn't useful.

> +	platform_set_drvdata(pdev, tcbpwm);
> +
> +	return 0;
> +}
> +
> +static int atmel_tcb_pwm_remove(struct platform_device *pdev)
> +{
> +	struct atmel_tcb_pwm_chip *tcbpwm =3D platform_get_drvdata(pdev);
> +	int err;
> +
> +	err =3D pwmchip_remove(&tcbpwm->chip);
> +	if (err < 0)
> +		return err;
> +
> +	atmel_tc_free(tcbpwm->tc);
> +
> +	dev_dbg(&pdev->dev, "pwm driver removed\n");

Same here, it can go away.

> +	devm_kfree(&pdev->dev, tcbpwm);

Again, kfree() will automatically be called on tcbpwm once the .remove()
function exits.

> +
> +	return 0;
> +}
> +
> +static struct of_device_id atmel_tcb_pwm_dt_ids[] =3D {

This should probably be "static const". I just noticed that not all
drivers do this, but they should.

Thierry

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0aRSAAoJEN0jrNd/PrOhseUP/jKL+85fbxcHDm8vuRdnUkv7
Q4RQM2YXNKL3cpDWkCky/4NYDTbyVzZalweatlLPWeu01N9gD4leDzIWczhRZk0+
5OQdRxa9hiOY1nkH1oVJzknbG+OTUuCA01mzrQ1dysmItUK+DCCSjNtzS3SwHDDy
DBBib817zSU4PdWZ8xLm3z6aC5FZJ/7PePBV61wl5/2YF84hfKCdC6k16V/zxCJy
S/fZD38ssH0o/c7KGnxtie3OunHPOGW3jgib5Xs2Fx+HvQ9zfuOa5GQnlL+jOSmG
eQbNWt826heFcZAZAh+U4Og6aHn/PrVXPRLMnf/wmcIGhTE4mm/U1CpaBMpdBbTj
MKLyfNJKqL6jXNdocSMHoCBh5GCeZlDpf24a8ddUU44S2rezX1Gt9xM6WQFIS8TW
8+aWCWIpK6LX2U10w1po7SxnD+P0clKLkkpkiDyd95MSM1VDYuw6m9OnrzmUMhCd
GWczq6QklkhbJAfF7pezuDxub2zemlIUsOku+yE64E578GQgDL8zBeqXXNU4Y0o8
YFbOV+giT4LRO9+31NWpTitBiZKSL13M+Jt8HVvJUgBHbiqQ3pGHLrGC8h9WKz0D
xdAFRGfG6N5/taK4byb+JpnivMfMzf1iedTyrxT8VmKxKghNT2ul1zuTD9GtMeEp
yKHwuYxHPSwWNgYRrmZt
=+SJQ
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
