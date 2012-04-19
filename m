Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2DSLlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:41:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37058 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873Ab2DSLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:40:57 -0400
Date: Thu, 19 Apr 2012 12:40:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v8 2/6] Extcon: support generic GPIO extcon driver
Message-ID: <20120419114053.GB3046@opensource.wolfsonmicro.com>
References: <20120418214703.GA31606@kroah.com>
 <1334803298-24260-1-git-send-email-myungjoo.ham@samsung.com>
 <1334803298-24260-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <1334803298-24260-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2012 at 11:41:34AM +0900, MyungJoo Ham wrote:
> The generic GPIO extcon driver (an external connector device based on
> GPIO control) and imported from Android kernel.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +	ret = gpio_request(extcon_data->gpio, pdev->name);
> +	if (ret < 0)
> +		goto err_request_gpio;
> +
> +	ret = gpio_direction_input(extcon_data->gpio);
> +	if (ret < 0)
> +		goto err_set_gpio_input;

Incrementally (or in future versions) I'd suggest replacing with
gpio_request_one() which combines the above and is generally nicer.

> +static int __devexit gpio_extcon_remove(struct platform_device *pdev)
> +{
> +	struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
> +
> +	cancel_delayed_work_sync(&extcon_data->work);
> +	gpio_free(extcon_data->gpio);
> +	extcon_dev_unregister(&extcon_data->edev);
> +	devm_kfree(&pdev->dev, extcon_data);

The whole point of using devm_ is that you don't need to explicitly free
for this usage pattern.  On the other hand it does no harm.

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPj/m/AAoJEBus8iNuMP3dW2UP/2Mw7jmUPjOYM04LxOe8NarM
vYxZr2GX6bCTRRFa2VbZF/AlxmxKwdW7A8u4r+0cik9QlHeQNW5s0degErYLxmy/
wiCrjA9HTPBReB8WPdzUeegHx+XM6wnF4GZ6zDEyv/iSWvRJq3ZydY+/syg/gEO1
3JMRzf9vryebAbCTWlqpTaX5xK6I7NzYMsW6IZA8SFHZWBWBh/n9Jk0FDf3KvdPb
1NACdeTBTOvxaVFZjOP0GaPikIBUMOHiJKAd9PEFGh2CjDedipQOVnSQB5Z50VTe
31RfsHbSVJGCUMRBO+N4sTXWT+gnI2E2JvSmUg6J0qZmtTo2AIYLXGejEolRxitH
NtsSsVitKPxNcsS4OyCxk1zlSuSm+9AZa6pBx1i/jrDGZd6uqdksn+hT2pXm3eb4
SqDJ/bGnLTomXzVkNNoKJOYn+L9QgBfQTuX+s7FDFrR8X4u/MGTrFzq7X06HdvUO
zH82OLw4EE7uG0GGnI6yoS5nweIYYB2zto/xuKMzCHdbYAOEPrT0E8Bz9RkYeIZ3
wuLFh2bptvC4JAlEFwGaskM9Rcj6OWWudWdL5IRNKH6bA9gatK3Mle6fm3ap8MU+
Eh+KqqxipILmt2ao/29vqTftYmivB+sQBR/0jG9v6LHdC+MX/+qN0rk5ZPeLbPQk
V9w2xLbutR5Bsq3ogR/0
=BqSJ
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
