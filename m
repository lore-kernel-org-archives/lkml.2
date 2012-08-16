Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2HPHmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:42:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55032 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2HPHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:42:42 -0400
Date: Thu, 16 Aug 2012 09:42:32 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120816074232.GA17917@avionic-0098.mockup.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IRFpl9iVSIKMM30UUyQsvMdUHDodtlSZTwmkWmWOEy4
 fafwMD1gZRk7eA6+9NHBX6u0N92R9Tr29OcpWBT4GDr5xT4ABP
 441qUDmNVjOKLJ6UyV6pd835/3oNUEnHw1cc3/uwVIXG/m1KAN
 LfVM0UIndbuEXAPAgOOSqqIL4nOKiDXuoz44glMPRAg2D/2+xH
 4Zd8TXJotEOb6fN0Q+gwJBBE4paKJjHvuabtG+621XHASHYvDf
 Me4CTe3w3LJCae33pWgOif1HSo6dsxsLIVST3X0CatNMby1Qxt
 eC1eRuTGyMaFXkmzVQq1ynRMBz66S3fzJQcPXpps5wjj8Rco+0
 igI4Cywa99I0sHUFhjSk/UTr6Y8t2jMWpXl6bCHIU5V7tDQRVY
 8XIt6hOMe8cjLyuJciUyawg7GkXearWiG8fQje4ye+Qehkbye7
 6UJAW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 03:08:55PM +0900, Alexandre Courbot wrote:
> Some device drivers (panel backlights especially) need to follow precise
> sequences for powering on and off, involving gpios, regulators, PWMs
> with a precise powering order and delays to respect between each steps.
> These sequences are board-specific, and do not belong to a particular
> driver - therefore they have been performed by board-specific hook
> functions to far.
>=20
> With the advent of the device tree and of ARM kernels that are not
> board-tied, we cannot rely on these board-specific hooks anymore but
> need a way to implement these sequences in a portable manner. This patch
> introduces a simple interpreter that can execute such power sequences
> encoded either as platform data or within the device tree.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  .../devicetree/bindings/power_seq/power_seq.txt    | 101 +++++
>  Documentation/power/power_seq.txt                  | 129 +++++++
>  drivers/power/Kconfig                              |   3 +
>  drivers/power/Makefile                             |   1 +
>  drivers/power/power_seq.c                          | 420 +++++++++++++++=
++++++
>  include/linux/power_seq.h                          | 142 +++++++
>  6 files changed, 796 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_seq/power_seq=
=2Etxt
>  create mode 100644 Documentation/power/power_seq.txt
>  create mode 100644 drivers/power/power_seq.c
>  create mode 100644 include/linux/power_seq.h
>=20
> diff --git a/Documentation/devicetree/bindings/power_seq/power_seq.txt b/=
Documentation/devicetree/bindings/power_seq/power_seq.txt
> new file mode 100644
> index 0000000..749c6e4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_seq/power_seq.txt
> @@ -0,0 +1,101 @@
> +Specifying Power Sequences in the Device Tree
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +In the device tree, power sequences are specified as sub-nodes of the de=
vice
> +node and reference resources declared by that device.
> +
> +For an introduction about runtime interpreted power sequences, see
> +Documentation/power/power_seq.txt and include/linux/power_seq.h.
> +
> +Power Sequences Structure
> +-------------------------
> +Power sequences are sub-nodes that are named such as the device driver c=
an find

"named such that"?

> +them. The driver's documentation should list the sequence names it recog=
nizes.
> +
> +Inside a power sequence node are sub-nodes that describe the different s=
teps
> +of the sequence. Each step must be named sequentially, with the first st=
ep
> +named step0, the second step1, etc. Failure to follow this rule will res=
ult in a
> +parsing error.
> +
> +Power Sequences Steps
> +---------------------
> +Every step of a sequence describes an action to be performed on a resour=
ce. It
> +generally includes a property named after the resource type, and which v=
alue
> +references the resource to be used. Depending on the resource type, addi=
tional
> +properties can be defined to control the action to be performed.
> +
> +Currently supported resource types are:

I think the "currently" can be dropped.

> +- "delay", which should simply contain a delay in microseconds to wait b=
efore
> +  going on with the rest of the sequence. It takes no additional propert=
y.
> +- "regulator" contains the name of a regulator to be acquired using
> +  regulator_get(). An additional property, either "enable" or "disable",=
 must be
> +  present to control whether the regulator should be enabled or disabled=
 during
> +  that step.
> +- "pwm" is set to the name of a PWM acquired using pwm_get(). As with re=
gulator,
> +  an additional "enable" or "disable" property is required.
> +- "gpio" contains the name of a GPIO to enable or disable using the same
> +  additional property as regulator or pwm. The gpio is resolved by appen=
ding
> +  "-gpio" to the given name and looking for a device property with a GPIO
> +  phandle.

I find this part slightly confusing. It doesn't seem quite obvious from
the text that "delay", "regulator", "pwm" and "gpio" are also actual
property names.

It might also be worth saying that the "enable" and "disable" properties
are boolean in nature and don't need a value.

Then again this becomes much clearer with the example below, so maybe
I'm just being too picky here.

> +
> +Example
> +-------
> +Here are example sequences declared within a backlight device that use a=
ll the
> +supported resources types:
> +
> +	backlight {
> +		compatible =3D "pwm-backlight";
> +		...
> +
> +		/* resources used by the sequences */
> +		pwms =3D <&pwm 2 5000000>;
> +		pwm-names =3D "backlight";
> +		power-supply =3D <&backlight_reg>;
> +		enable-gpio =3D <&gpio 28 0>;
> +
> +		power-on-sequence {
> +			step0 {
> +				regulator =3D "power";
> +				enable;
> +			};
> +			step1 {
> +				delay =3D <10000>;
> +			};
> +			step2 {
> +				pwm =3D "backlight";
> +				enable;
> +			};
> +			step3 {
> +				gpio =3D "enable";
> +				enable;
> +			};
> +		};
> +
> +		power-off-sequence {
> +			step0 {
> +				gpio =3D "enable";
> +				disable;
> +			};
> +			step1 {
> +				pwm =3D "backlight";
> +				disable;
> +			};
> +			step2 {
> +				delay =3D <10000>;
> +			};
> +			step3 {
> +				regulator =3D "power";
> +				disable;
> +			};
> +		};
> +	};
> +
> +The first part lists the PWM, regulator, and GPIO resources used by the
> +sequences. These resources will be requested on behalf of the backlight =
device
> +when the sequences are built and are declared according to their own fra=
mework
> +in a way that makes them accessible by name.
> +
> +After the resources declaration, two sequences follow for powering the b=
acklight
> +on and off. Their names are specified by the pwm-backlight driver. Every=
 step
> +uses one of the "delay", "regulator", "pwm" or "gpio" properties to refe=
rence a
> +previously-declared resource. Additional "enable" or "disable" propertie=
s are
> +also used as needed.
> diff --git a/Documentation/power/power_seq.txt b/Documentation/power/powe=
r_seq.txt
> new file mode 100644
> index 0000000..3ab4f93
> --- /dev/null
> +++ b/Documentation/power/power_seq.txt
> @@ -0,0 +1,129 @@
> +Runtime Interpreted Power Sequences
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Problem
> +-------
> +One very common board-dependent code is the out-of-driver code that is u=
sed to
> +turn a device on or off. For instance, SoC boards very commonly use a GP=
IO
> +(abstracted to a regulator or not) to control the power supply of a back=
light,
> +disabling it when the backlight is not used in order to save power. The =
GPIO
> +that should be used, however, as well as the exact power sequence that m=
ay
> +also involve other resources, is board-dependent and thus unknown of the=
 driver.

"unknown to the driver"?

> +
> +This was previously addressed by having hooks in the device's platform d=
ata that
> +are called whenever the state of the device might reflect a power change=
=2E This
> +approach, however, introduces board-dependant code into the kernel and i=
s not
> +compatible with the device tree.
> +
> +The Runtime Interpreted Power Sequences (or power sequences for short) a=
ims at

"... Sequences [...] aim"?

> +turning this code into platform data or device tree nodes. Power sequenc=
es are
> +described using a simple format and run by a simple interpreter whenever=
 needed.
> +This allows to remove the callback mechanism and makes the kernel less
> +board-dependant.
> +
> +What are Power Sequences?
> +-------------------------
> +Power sequences are a series of sequential steps during which an action =
is
> +performed on a resource. The supported resources so far are:

Again, I don't see a need for "so far" here. It implies that new types
may be added. While it is quite possible and maybe even likely to happen
the new types can be added to the documentation at the same time.

> +- delay (just wait for the delay given in microseconds)
> +- GPIO (enable or disable)
> +- regulator (enable or disable)
> +- PWM (enable or disable)
> +
> +Every step designates a resource type and parameters that are relevant t=
o it.
> +For instance, GPIO and PWMs can be enabled or disabled.
> +
> +When a power sequence is run, each of its step is executed sequentially =
until

"each of its steps"

> +one step fails or the end of the sequence is reached.
> +
> +Power sequences can be declared as platform data or in the device tree.
> +
> +Platform Data Format
> +--------------------
> +All relevant data structures for declaring power sequences are located in
> +include/linux/power_seq.h.
> +
> +The platform data is a static instance of  simple array of
> +platform_power_seq_step instances, each
> +instance describing a step. The type as well as one of id or gpio members
> +(depending on the type) must be specified. The last step must be of type
> +POWER_SEQ_STOP. Regulator and PWM resources are identified by name. GPIO=
 are
> +identified by number. For example, the following sequence will turn on t=
he
> +"power" regulator of the device, wait 10ms, and set GPIO number 110 to 1:
> +
> +static struct platform_power_seq power_on_seq =3D {
> +		.nb_steps =3D 3,

I think num_steps would be more canonical.

> +		.steps =3D {
> +			{
> +				.type =3D POWER_SEQ_REGULATOR,
> +				.regulator.regulator =3D "power",
> +				.regulator.enable =3D 1,
> +			},

This may be easier to read as:

	.type =3D POWER_SEQ_REGULATOR,
	.regulator {
		.regulator =3D "power",
		.enable =3D 1,
	}

Also, why not rename the .regulator field to .name? That describes
better what it is and removes the redundancy of having the structure
named regulator and a regulator field within.

> +			{
> +				.type =3D POWER_SEQ_DELAY,
> +				.delay.delay_us =3D 10000,
> +			},
> +			{
> +				.type =3D POWER_SEQ_GPIO,
> +				.gpio.gpio =3D 110,
> +				.gpio.enable =3D 1,
> +			},

Same comments as for the regulator step above. Also, since enable is a
boolean field, maybe you should use true and false instead.

> +		},
> +};
> +
> +Device Tree
> +-----------
> +Power sequences can also be encoded as device tree nodes. The following
> +properties and nodes are equivalent to the platform data defined previou=
sly:
> +
> +		power-supply =3D <&power_reg>;
> +		switch-gpio =3D <&gpio 110 0>;
> +
> +		power-on-sequence {
> +			step0 {
> +				regulator =3D "power";
> +				enable;
> +			};
> +			step1 {
> +				delay =3D <10000>;
> +			};
> +			step2 {
> +				gpio =3D "switch";
> +				enable;
> +			};
> +		};
> +
> +See Documentation/devicetree/bindings/power_seq/power_seq.txt for the co=
mplete
> +syntax of the bindings.
> +
> +Usage by Drivers and Resources Management
> +-----------------------------------------
> +Power sequences make use of resources that must be properly allocated and
> +managed. The power_seq_build() function builds a power sequence from the
> +platform data. It also takes care of resolving and allocating the resour=
ces
> +referenced by the sequence if needed:
> +
> +  struct power_seq *power_seq_build(struct device *dev, struct list_head=
 *ress,
> +                                    struct platform_power_seq *pseq);
> +
> +The 'dev' argument is the device in the name of which the resources are =
to be
> +allocated.
> +
> +The 'ress' argument is a list to which the resolved resources are append=
ed. This
> +avoids allocating a resource referenced in several power sequences multi=
ple
> +times.
> +
> +On success, the function returns a devm allocated resolved sequence that=
 is
> +ready to be passed to power_seq_run(). In case of failure, and error cod=
e is
> +returned.
> +
> +A resolved power sequence returned by power_seq_build can be run by
> +power_run_run():
> +
> +  int power_seq_run(power_seq *seq);
> +
> +It returns 0 if the sequence has successfully been run, or an error code=
 if a
> +problem occured.
> +
> +There is no need to explicitly free the resources used by the sequence a=
s they
> +are devm-allocated.

I had some comments about this particular interface for creating
sequences in the last series. My point was that explicitly requiring
drivers to manage a list of already allocated resources may be too much
added complexity. Power sequences should be easy to use, and I find the
requirement for a separately managed list of resources cumbersome.

What I proposed last time was to collect all power sequences under a
common parent object, which in turn would take care of managing the
resources.

> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index c1892f3..4172fe4 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -312,4 +312,7 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
>  	  thermistor connected on BATCTRL ADC.
>  endif # POWER_SUPPLY
> =20
> +config POWER_SEQ
> +	bool
> +
>  source "drivers/power/avs/Kconfig"
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index ee58afb..828859c 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -45,3 +45,4 @@ obj-$(CONFIG_CHARGER_MAX8997)	+=3D max8997_charger.o
>  obj-$(CONFIG_CHARGER_MAX8998)	+=3D max8998_charger.o
>  obj-$(CONFIG_POWER_AVS)		+=3D avs/
>  obj-$(CONFIG_CHARGER_SMB347)	+=3D smb347-charger.o
> +obj-$(CONFIG_POWER_SEQ)		+=3D power_seq.o
> diff --git a/drivers/power/power_seq.c b/drivers/power/power_seq.c
> new file mode 100644
> index 0000000..1dcdbe0
> --- /dev/null
> +++ b/drivers/power/power_seq.c
> @@ -0,0 +1,420 @@
> +/*
> + * power_seq.c - A simple power sequence interpreter for platform devices
> + *               and device tree.
> + *
> + * Author: Alexandre Courbot <acourbot@nvidia.com>
> + *
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + */
> +
> +#include <linux/power_seq.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/pwm.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/gpio.h>
> +
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +
> +struct power_seq_step {
> +	/* Copy of the platform data */
> +	struct platform_power_seq_step pdata;
> +	/* Resolved resource */
> +	struct power_seq_resource *resource;
> +};
> +
> +struct power_seq {
> +	struct device *dev;
> +	unsigned int nb_steps;
> +	struct power_seq_step steps[];
> +};
> +
> +static char *res_names[POWER_SEQ_MAX] =3D {
> +	[POWER_SEQ_DELAY] =3D "delay",
> +	[POWER_SEQ_REGULATOR] =3D "regulator",
> +	[POWER_SEQ_GPIO] =3D "gpio",
> +	[POWER_SEQ_PWM] =3D "pwm",
> +};

static const?

> +
> +static int power_seq_step_run(struct power_seq_step *step)
> +{
> +	struct platform_power_seq_step *pdata =3D &step->pdata;
> +	int err =3D 0;
> +
> +	switch (pdata->type) {
> +	case POWER_SEQ_DELAY:
> +		usleep_range(pdata->delay.delay_us,
> +			     pdata->delay.delay_us + 1000);
> +		break;
> +#ifdef CONFIG_REGULATOR
> +	case POWER_SEQ_REGULATOR:
> +		if (pdata->regulator.enable)
> +			err =3D regulator_enable(step->resource->regulator);
> +		else
> +			err =3D regulator_disable(step->resource->regulator);
> +		break;
> +#endif
> +#ifdef CONFIG_PWM
> +	case POWER_SEQ_PWM:
> +		if (pdata->gpio.enable)
> +			err =3D pwm_enable(step->resource->pwm);
> +		else
> +			pwm_disable(step->resource->pwm);
> +		break;
> +#endif
> +#ifdef CONFIG_GPIOLIB
> +	case POWER_SEQ_GPIO:
> +		gpio_set_value_cansleep(pdata->gpio.gpio, pdata->gpio.enable);
> +		break;
> +#endif
> +	/*
> +	 * should never happen unless the sequence includes a step which
> +	 * type does not have support compiled in

I think this should be "whose type"? I also remember commenting on the
whole #ifdef'ery here. I really don't think it is necessary. At least
for regulators I know that the functions can be used even if the
subsystem itself isn't supported. The same seems to hold for GPIO and we
can probably add something similar for PWM.

It might also be a good idea to just skip unsupported resource types
when the sequence is built, accompanied by runtime warnings that the
type is not supported.

> +	 */
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (err < 0)
> +		return err;
> +
> +	return 0;

This can probably be collapsed to just "return err;", can't it?

> +}
> +
> +int power_seq_run(struct power_seq *seq)
> +{
> +	struct device *dev =3D seq->dev;
> +	int err, cpt;

Any reason why you call the loop variable cpt instead of something more
canonical such as i? Also it should be of type unsigned int.

> +
> +	if (!seq)
> +		return 0;
> +
> +	for (cpt =3D 0; cpt < seq->nb_steps; cpt++) {
> +		err =3D power_seq_step_run(&seq->steps[cpt]);
> +		if (err) {
> +			dev_err(dev, "error %d while running power sequence!\n",
> +				err);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(power_seq_run);
> +
> +#ifdef CONFIG_OF
> +static int of_power_seq_enable_properties(struct device *dev,
> +					  struct device_node *node,
> +					  bool *enable)

Maybe rename this to of_power_seq_parse_enable_properties() to make it
more obvious that it is actually parsing data. It's an awfully long name
for a function, though.

> +{
> +	if (of_find_property(node, "enable", NULL)) {
> +		*enable =3D true;
> +	} else if (of_find_property(node, "disable", NULL)) {
> +		*enable =3D false;
> +	} else {
> +		dev_err(dev, "missing enable or disable property!\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int of_parse_power_seq_step(struct device *dev, struct device_nod=
e *node,
> +				   struct platform_power_seq_step *step)
> +{
> +	struct property *res_id =3D NULL;
> +	int i, err;
> +
> +	/* Try to find a meaningful name property */
> +	for (i =3D 0; i < POWER_SEQ_MAX; i++) {

Maybe this should be renamed to POWER_SEQ_MAX_TYPE, POWER_SEQ_TYPE_MAX,
POWER_SEQ_NUM_TYPES or some such. I had assumed POWER_SEQ_MAX would mean
the maximum length of a power sequence.

> +		struct property *mprop;
> +
> +		mprop =3D of_find_property(node, res_names[i], NULL);
> +		if (mprop) {
> +			if (res_id) {
> +				dev_err(dev,
> +					"more than one resource in step!\n");
> +				return -EINVAL;
> +			}
> +			step->type =3D i;
> +			res_id =3D mprop;
> +		}
> +	}
> +	if (!res_id) {
> +		dev_err(dev, "missing resource property for power seq step!\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Now parse resource-specific properties */
> +	switch (step->type) {
> +	case POWER_SEQ_DELAY:
> +		err =3D of_property_read_u32(node, res_id->name,
> +					   &step->delay.delay_us);
> +		if (err)
> +			goto err_read_property;
> +
> +		break;
> +
> +	case POWER_SEQ_REGULATOR:
> +		err =3D of_property_read_string(node, res_id->name,
> +					    &step->regulator.regulator);
> +		if (err)
> +			goto err_read_property;
> +
> +		err =3D of_power_seq_enable_properties(dev, node,
> +						     &step->regulator.enable);
> +		if (err)
> +			return err;
> +
> +		break;
> +
> +	case POWER_SEQ_PWM:
> +		err =3D of_property_read_string(node, res_id->name,
> +					      &step->pwm.pwm);
> +		if (err)
> +			goto err_read_property;
> +
> +		err =3D of_power_seq_enable_properties(dev, node,
> +						     &step->pwm.enable);
> +		if (err)
> +			return err;
> +
> +		break;
> +
> +#ifdef CONFIG_OF_GPIO
> +	case POWER_SEQ_GPIO:
> +	{
> +		char prop_name[32]; /* max size of property name */
> +		const char *gpio_name;
> +		int gpio;
> +
> +		err =3D of_property_read_string(node, res_id->name, &gpio_name);
> +		if (err)
> +			goto err_read_property;
> +
> +		/* Resolve the GPIO name */
> +		snprintf(prop_name, 32, "%s-gpio", gpio_name);

I'm not sure if there's a limit on the length of DT property names, but
maybe using kasprintf would be a better idea here.

> +		gpio =3D of_get_named_gpio(dev->of_node, prop_name, 0);
> +		if (gpio < 0) {
> +			dev_err(dev, "cannot resolve gpio \"%s\"\n", gpio_name);
> +			return gpio;
> +		}
> +		step->gpio.gpio =3D gpio;
> +
> +		err =3D of_power_seq_enable_properties(dev, node,
> +						     &step->gpio.enable);
> +		if (err)
> +			return err;
> +
> +		break;
> +	}
> +#endif /* CONFIG_OF_GPIO */
> +
> +	default:
> +		dev_err(dev, "unhandled power sequence step type %s\n",
> +			res_names[step->type]);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +
> +err_read_property:
> +	dev_err(dev, "cannot read %s property!", res_names[step->type]);
> +	return -EINVAL;
> +}

Given the size of this function, I think it might become more readable
if it were split into separate parse functions for each type of
resource. It will also allow you to get rid of this #ifdef within the
function.

> +
> +struct platform_power_seq *of_parse_power_seq(struct device *dev,
> +					      struct device_node *node)
> +{
> +	struct device_node *child =3D NULL;
> +	struct platform_power_seq *pseq;
> +	int nb_steps =3D 0, size;
> +	int err;
> +
> +	if (!node)
> +		return ERR_PTR(-EINVAL);
> +
> +	nb_steps =3D of_get_child_count(node);
> +	size =3D sizeof(pseq) + sizeof(struct platform_power_seq_step) * nb_ste=
ps;

Shouldn't the first term be sizeof(*pseq)?

> +	pseq =3D devm_kzalloc(dev, size, GFP_KERNEL);
> +	if (!pseq)
> +		return ERR_PTR(-ENOMEM);
> +	pseq->nb_steps =3D nb_steps;
> +
> +	for_each_child_of_node(node, child) {
> +		unsigned int pos;
> +
> +		/* Check that the name's format is correct and within bounds */
> +		if (strncmp("step", child->name, 4)) {
> +			err =3D -EINVAL;
> +			goto parse_error;
> +		}
> +
> +		err =3D kstrtoint(child->name + 4, 10, &pos);
> +		if (err < 0)
> +			goto parse_error;

kstrtouint()? Also this is somewhat ugly. Perhaps adding #address-cells
and #size-cells properties isn't that bad after all.

> +
> +		if (pos >=3D nb_steps || pseq->steps[pos].type !=3D 0) {
> +			err =3D -EINVAL;
> +			goto parse_error;
> +		}
> +
> +		err =3D of_parse_power_seq_step(dev, child, &pseq->steps[pos]);
> +		if (err)
> +			return ERR_PTR(err);
> +	}
> +
> +	return pseq;
> +
> +parse_error:
> +	dev_err(dev, "invalid power step name %s!\n", child->name);
> +	return ERR_PTR(err);
> +}
> +EXPORT_SYMBOL_GPL(of_parse_power_seq);
> +#endif /* CONFIG_OF */
> +
> +static
> +struct power_seq_resource *power_seq_find_resource(struct list_head *res=
s,
> +					struct platform_power_seq_step *step)

I think it is customary to put the return value type on the same line as
the static modifier.

> +{
> +	struct power_seq_resource *res;
> +
> +	list_for_each_entry(res, ress, list) {
> +		struct platform_power_seq_step *pdata =3D res->pdata;
> +
> +		if (pdata->type !=3D step->type)
> +			continue;
> +
> +		switch (pdata->type) {
> +		case POWER_SEQ_REGULATOR:
> +			if (!strcmp(pdata->regulator.regulator,
> +				    step->regulator.regulator))
> +				return res;
> +			break;
> +		case POWER_SEQ_PWM:
> +			if (!strcmp(pdata->pwm.pwm, step->pwm.pwm))
> +				return res;
> +			break;
> +		case POWER_SEQ_GPIO:
> +			if (pdata->gpio.gpio =3D=3D step->gpio.gpio)
> +				return res;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static int power_seq_allocate_resource(struct device *dev,
> +				       struct power_seq_resource *res)
> +{
> +	struct platform_power_seq_step *pdata =3D res->pdata;
> +	int err;
> +
> +	switch (pdata->type) {
> +	case POWER_SEQ_DELAY:
> +		break;
> +#ifdef CONFIG_REGULATOR
> +	case POWER_SEQ_REGULATOR:
> +		res->regulator =3D devm_regulator_get(dev,
> +						    pdata->regulator.regulator);
> +		if (IS_ERR(res->regulator)) {
> +			dev_err(dev, "cannot get regulator \"%s\"\n",
> +				pdata->regulator.regulator);
> +			return PTR_ERR(res->regulator);
> +		}
> +		break;
> +#endif
> +#ifdef CONFIG_PWM
> +	case POWER_SEQ_PWM:
> +		res->pwm =3D devm_pwm_get(dev, pdata->pwm.pwm);
> +		if (IS_ERR(res->pwm)) {
> +			dev_err(dev, "cannot get pwm \"%s\"\n", pdata->pwm.pwm);
> +			return PTR_ERR(res->pwm);
> +		}
> +		break;
> +#endif
> +#ifdef CONFIG_GPIOLIB
> +	case POWER_SEQ_GPIO:
> +		err =3D devm_gpio_request_one(dev, pdata->gpio.gpio,
> +					 GPIOF_OUT_INIT_HIGH, "backlight_gpio");
> +		if (err) {
> +			dev_err(dev, "cannot get gpio %d\n", pdata->gpio.gpio);
> +			return err;
> +		}
> +		break;
> +#endif
> +	default:
> +		dev_err(dev, "invalid resource type %d\n", pdata->type);
> +		return -EINVAL;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +struct power_seq *power_seq_build(struct device *dev, struct list_head *=
ress,
> +				  struct platform_power_seq *pseq)
> +{
> +	struct power_seq *seq;
> +	struct power_seq_resource *res;
> +	int cpt, err;
> +
> +	seq =3D devm_kzalloc(dev, sizeof(*seq) + sizeof(struct power_seq_step) *
> +			   pseq->nb_steps, GFP_KERNEL);
> +	if (!seq)
> +		return ERR_PTR(-ENOMEM);
> +
> +	seq->dev =3D dev;
> +	seq->nb_steps =3D pseq->nb_steps;
> +
> +	for (cpt =3D 0; cpt < seq->nb_steps; cpt++) {
> +		struct platform_power_seq_step *pstep =3D &pseq->steps[cpt];
> +		struct power_seq_step *step =3D &seq->steps[cpt];
> +
> +		memcpy(&step->pdata, pstep, sizeof(step->pdata));
> +
> +		/* Delay steps have no resource */
> +		if (pstep->type =3D=3D POWER_SEQ_DELAY)
> +			continue;
> +
> +		/* create resource node if not referenced already */
> +		res =3D power_seq_find_resource(ress, pstep);
> +		if (!res) {
> +			res =3D devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
> +			if (!res)
> +				return ERR_PTR(-ENOMEM);
> +			res->pdata =3D &step->pdata;
> +
> +			err =3D power_seq_allocate_resource(dev, res);
> +			if (err < 0)
> +				return ERR_PTR(err);
> +
> +			list_add(&res->list, ress);
> +		}
> +		step->resource =3D res;
> +	}
> +
> +	return seq;
> +}
> +EXPORT_SYMBOL_GPL(power_seq_build);
> +
> +MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
> +MODULE_DESCRIPTION("Runtime Interpreted Power Sequences");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/power_seq.h b/include/linux/power_seq.h
> new file mode 100644
> index 0000000..d9dd277
> --- /dev/null
> +++ b/include/linux/power_seq.h
> @@ -0,0 +1,142 @@
> +/*
> + * power_seq.h
> + *
> + * Simple interpreter for defining power sequences as platform data or d=
evice
> + * tree properties.
> + *
> + * Power sequences are designed to replace the callbacks typically used =
in
> + * board-specific files that implement board-specific power sequences of=
 devices
> + * such as backlights. A power sequence is an array of resources (which =
can a
> + * regulator, a GPIO, a PWM, ...) with an action to perform on it (enabl=
e or
> + * disable) and optional pre and post step delays. By having them interp=
reted
> + * instead of arbitrarily executed, it is possible to describe these in =
the
> + * device tree and thus remove board-specific code from the kernel.
> + *
> + * Author: Alexandre Courbot <acourbot@nvidia.com>
> + *
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + */
> +
> +#ifndef __LINUX_POWER_SEQ_H
> +#define __LINUX_POWER_SEQ_H
> +
> +#include <linux/types.h>
> +
> +struct device;
> +struct regulator;
> +struct pwm_device;
> +struct device_node;
> +
> +/**
> + * The different kinds of resources that can be controlled during the se=
quences.
> + */
> +enum power_seq_res_type {
> +	POWER_SEQ_DELAY,
> +	POWER_SEQ_REGULATOR,
> +	POWER_SEQ_PWM,
> +	POWER_SEQ_GPIO,
> +	POWER_SEQ_MAX,
> +};
> +
> +struct platform_power_seq_delay_step {
> +	unsigned int delay_us;
> +};
> +
> +struct platform_power_seq_regulator_step {
> +	const char *regulator;
> +	bool enable;
> +};
> +
> +struct platform_power_seq_pwm_step {
> +	const char *pwm;
> +	bool enable;
> +};
> +
> +struct platform_power_seq_gpio_step {
> +	int gpio;
> +	bool enable;
> +};
> +
> +/**
> + * Platform definition of power sequences. A sequence is an array of the=
se,
> + * terminated by a STOP instance.
> + */
> +struct platform_power_seq_step {
> +	enum power_seq_res_type type;
> +	union {
> +		struct platform_power_seq_delay_step delay;
> +		struct platform_power_seq_regulator_step regulator;
> +		struct platform_power_seq_pwm_step pwm;
> +		struct platform_power_seq_gpio_step gpio;
> +	};
> +};
> +
> +struct platform_power_seq {
> +	unsigned int nb_steps;
> +	struct platform_power_seq_step steps[];
> +};
> +
> +/**
> + * We maintain a list of these to monitor which resources have already
> + * been met and allocated while building the sequences.
> + */
> +struct power_seq_resource {
> +	/* relevant for resolving the resource and knowing its type */
> +	struct platform_power_seq_step *pdata;
> +	/* resolved resource (if any) */
> +	union {
> +		struct regulator *regulator;
> +		struct pwm_device *pwm;
> +	};
> +	struct list_head list;
> +};
> +
> +struct power_seq_resource;
> +struct power_seq;
> +
> +#ifdef CONFIG_OF
> +/**
> + * Build a platform data sequence from a device tree node. Memory for the
> + * platform sequence is allocated using devm_kzalloc on dev and can be f=
reed
> + * by devm_kfree after power_seq_build is called.
> + */
> +struct platform_power_seq *of_parse_power_seq(struct device *dev,
> +					      struct device_node *node);
> +#else
> +struct platform_power_seq *of_parse_power_seq(struct device *dev,
> +					      struct device_node *node)
> +{
> +	return ERR_PTR(-EINVAL);
> +}
> +#endif
> +
> +/**
> + * Build a runnable power sequence from platform data, and add the resou=
rces
> + * it uses into ress. Memory for the sequence is allocated using devm_kz=
alloc
> + * on dev.
> + * @dev device that will use the power sequence. All resources will be
> + *      devm-allocated against it.
> + * @ress list that holds the power_seq_resources already used by this de=
vice.
> + *       Resources newly met in the sequence will be added to it.
> + * @pseq power sequence in platform format.
> + */
> +struct power_seq *power_seq_build(struct device *dev, struct list_head *=
ress,
> +				  struct platform_power_seq *pseq);

I believe kernel-doc comments should precede the implementation, not the
prototype. Also the kernel-doc comment doesn't correspond to what is
described in Documentation/kernel-doc-nano-HOWTO.txt.

Thierry

> +
> +/**
> + * Run the given power sequence. Returns 0 on success, error code in cas=
e of
> + * failure.
> + */
> +int power_seq_run(struct power_seq *seq);
> +
> +#endif
> --=20
> 1.7.11.4
>=20
>=20
>=20

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLKRoAAoJEN0jrNd/PrOhaH0P/A0nuz3Blb41t0P1WAFf+ihV
DOKamje2ORBpdxzXeLL9c7faNjPITvxf+Nq2dTOgFsjWIOh9pYSH3I8HcRXxorRx
Txcz+4H9a4IDnELKs+1J9RZ+f2gjxpRsnKxTReAWgFiUPDcH4fTikfR8CYGhbZ4i
0Ti4Bx6UF57aw3c0g0kyuZ3IyjswrhVGkWE265vvtBYRw67qDMZYwYPA056eUGC3
2qtnjaHPMfbhwRBrQLcMaDR8/d8iT11erJJkNAE6Z3BJFnxOoiLvMednKg8qrtc3
6JaoonGWG70H7hXs+gIA9NJrBo3q1C5w/azFGu2zORpcg4Ed6LjPFb2TwayFqiYm
70bBlPkQ5QRxt2Z+RGH5/KnF0cOaK3L2ptA3kcmxCJCEtJnFh5K6dztzuWKDKm8c
5a7Pq5V24M0J+G2R/iyiHJJzFd9+QbhEExxgaSJ3GJPxpNpzCS+CO+u2hlREYleH
s+6o+djaLT7zPVerQ1n6ZGCPodAi15ugyKVoxisi07+f+N9J10mdU31ZYG3p7WrN
E46v1N9DJ/gd5QXuQjHzhQaOgxFntWhmREGRBYT8zN1crgkp1p6wdRqMqd2X7ng8
Xz3ZiQ3F4ZoZ+p9W9xJPnhBRQWNiaxNGRrrZ+LSSXj6SFCrluBGutIH91LpQVxMu
zIeoMsyBM0mBHedX5uK7
=1308
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
