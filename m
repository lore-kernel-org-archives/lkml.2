Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1KYOQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:16:46 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:37018 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755724Ab1KYOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:16:45 -0500
Date: Fri, 25 Nov 2011 16:16:41 +0200
From: Felipe Balbi <balbi@ti.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111125141640.GB13747@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/gpio/gpiolib.c     |   44 ++++++++++++++++++++++++++++++++++++++=
++++++
>  include/asm-generic/gpio.h |    4 ++++
>  include/linux/gpio.h       |    5 +++++
>  3 files changed, 53 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a971e3d..b7e5e75 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1519,6 +1519,50 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(gpio_set_debounce);
> =20
> +/**
> + * gpio_set_pullup - sets @pullup for a @gpio
> + * @gpio: the gpio to set pullup
> + * @pullup: pullup level
> + */
> +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> +{
> +	unsigned long		flags;
> +	struct gpio_chip	*chip;
> +	struct gpio_desc	*desc =3D &gpio_desc[gpio];
> +	int			status =3D -EINVAL;
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +
> +	if (!gpio_is_valid(gpio))
> +		goto fail;
> +	chip =3D desc->chip;
> +	if (!chip || !chip->set_pullup)
> +		goto fail;
> +	gpio -=3D chip->base;
> +	if (gpio >=3D chip->ngpio)
> +		goto fail;
> +	status =3D gpio_ensure_requested(desc, gpio);
> +	if (status < 0)
> +		goto fail;
> +
> +	/* now we know the gpio is valid and chip won't vanish */
> +
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	might_sleep_if(chip->can_sleep);
> +
> +	return chip->set_pullup(chip, gpio, pullup);
> +
> +fail:
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +	if (status)
> +		pr_debug("%s: gpio-%d status %d\n",
> +			__func__, gpio, status);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_set_pullup);

Maybe I'm missing something, but isn't it essentially what
gpio_set_value() does ? I mean, you set a pullup and you get '1' value
and set a pulldown and you get a '0' value ??

Without a proper description of the necessity for this change, I can't
easily tell them apart :-(

--=20
balbi

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOz6NIAAoJEIaOsuA1yqREb20QAJcMsdTzhTMGeZf2esdcUJdG
Y7lZfyEba0i05Ci2P3bk5L4fgTL0GkTUooOqkvOY+dHOPECrsqu+KBe5CduxfT6B
brp4m+kopQfpxk3caPI9XVGFmkMQvyVuQPZ/hRhbK4Z5473BhEscQwaQVNamsZKg
Odcws/qtAXJo89vtQ03mmyVVsafMwR2iWsesZ+zUZfS5ou1g6Ocof/WsA3cqwpLj
Xajy0cSxycMiB23hV2qDtH1oHtx+FDs5pDkjiK8KJAAbHHtC06tcKyZSs5CpahiR
vr7boGX9aAUeQMI0flfktTAx4oGaHnrZIWgkemd0B2LknPAIOC69rRrH1SuI2Gf1
pWFG1QKPvVp5YknG7J8+HIOr6df7LhHN67GGfO9QKEcUP4AzVfzHlTyxKw61hl0i
WFDb3oy/fDXj87b/zjHf4Y/E0qwSVjDtLBJNfsUKnI3yhi/amLS5pwUDCPWLJmH1
ZuBGp0qjIYhlvt63RIxfxW7pKE1pKZ2QE+CkPD+1OJPjixT288qPY/wxdxyF98Oz
WYQ/f1XtSkIyWhuihZABgf9fVlFiP3UtLHNOC30f+SvZN1vIJs/9Ip/xm5hfGOrq
U60n6ei8TgG/CW9saXtKrRBWq5Ujnz4ZVhiUrkao1Wj0uLMiAbrI9Mw75Ie6nCg7
VFF5NduuDMy3Olanr/cy
=+jkS
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
