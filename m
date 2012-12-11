Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2LKHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:25:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2LKHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:25:57 -0500
Date: Tue, 11 Dec 2012 08:25:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v3 4/4] leds: leds-pwm: Add device tree bindings
Message-ID: <20121211072545.GD8294@avionic-0098.adnet.avionic-design.de>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
 <1355133637-2784-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Content-Disposition: inline
In-Reply-To: <1355133637-2784-5-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NwcVFo8EcmkVNGdVKX/JWlXzf1MGKSWC17ahPTlhHlj
 3GT/3wNPv/mNB9YP2uFAkczJxfchDNyFwy2oTaLq2zLot4qdnn
 S2y5bt8/zaFDRH8CjUX83kr0lRYOm91IMoCdF+C0FQ3EyQYyLx
 aC65aebiZV4FtgqQoEfg4hm6RIS+erhm3sdFyTXJtM5cYvJZOD
 bFs4bm3F5wZYESibyDKbsLPgChJil4mze9zuuBCHBRaE9GDSYi
 TVvMByZto3dzsd6IlsvY2Quzg8+0PXXWGs7e0IJZcL9PzSLfTY
 inbslU/OJw4XFJ9VPNbzOfFQImBWaooatoBMze6eQ1sA8cGDw1
 jTXtf37GWFhTr0F9ZhjX4iwBqCtbON4mL1dOLkuAzwISzBBBSA
 PUC59pEVfTOdUW8PsVym8hSN1pZy0A8Sto=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2012 at 11:00:37AM +0100, Peter Ujfalusi wrote:
[...]
> +LED sub-node properties:
> +- pwms : PWM property, please refer to:=20
> +  Documentation/devicetree/bindings/pwm/pwm.txt

Instead of only referring to the generic PWM binding document, this
should probably explain what the PWM device is used for.

> +err:
> +	if (priv->num_leds > 0) {
> +		for (count =3D priv->num_leds - 1; count >=3D 0; count--) {
> +			led_classdev_unregister(&priv->leds[count].cdev);
> +			pwm_put(priv->leds[count].pwm);
> +		}
> +	}

Can this not be written more simply as follows?

	while (priv->num_leds--) {
		...
	}

>  static int led_pwm_remove(struct platform_device *pdev)
>  {
> +	struct led_pwm_platform_data *pdata =3D pdev->dev.platform_data;
>  	struct led_pwm_priv *priv =3D platform_get_drvdata(pdev);
>  	int i;
> =20
> -	for (i =3D 0; i < priv->num_leds; i++)
> +	for (i =3D 0; i < priv->num_leds; i++) {
>  		led_classdev_unregister(&priv->leds[i].cdev);
> +		if (!pdata)
> +			pwm_put(priv->leds[i].pwm);
> +	}

Perhaps while at it we can add devm_of_pwm_get() along with exporting
of_pwm_get() so that you don't have to special-case this?

> +static const struct of_device_id of_pwm_leds_match[] =3D {
> +	{ .compatible =3D "pwm-leds", },
> +	{},
> +};

Doesn't this cause a compiler warning for !OF builds?

Thierry

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxt/5AAoJEN0jrNd/PrOh4bgP/3MkJAdYjS3hh62DIIa51Hk3
V5lSueX3Nwmf5Dsa2pC+JbufN2DGt53DLoioHXk1MA9Ad5Q6DCUwNM7S3I1zy94e
NfDCOKzOoaVp3e854McCBmFgLQxkDgoWbmROkH3ptDWWNLqNIJukqPaz+fLRuk35
cnDNY6NylItflxZlV7bfwYjI+V7/ybsT1T7ma0xSAICKGkuG8qBE7B0xG9m2OG58
Osou1jE0dIpWGy7IaUTbEhqD/JUrgP+lAahAuOg92FqnqKvNO89L40mQo4OO4ehB
XgQ1vtBxE3FLo7Zmu/6i7AAAunjG03z8DEthfqMuDjwOGiKC9Puou8ngaF80iYCo
eRO8Qu8XtFtO5SPVwrW8zrf70Bp2f7JE4OGvNCsjEjqYcv4wdzUMauy1X5Ko8oK9
6GXdJKf+oE4TumazXjwxEd/Ho6olkObDp1qo8T8d+AMRG63fxZeO4qBjllomzb1u
3vx3osOu0C11fZxuqdWGP03g2dVKJIX5uSfI+8+bTkVIG57tG9SEcX3mQjVzcMNv
ZUH4BTs+r0tcGChLai9ETadoWvDd2xb3K6xinejoTWlgdsW3XyoGcc3kywY7j7Qa
htVwQfdnqvjfFss056+cCQfjsUBG8pGYkBOrstEFYAVyBcLO2AyJgW3Si1uqS7EP
BjL9voO5+ZWYcXI0qFm4
=aTSb
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
