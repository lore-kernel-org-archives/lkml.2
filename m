Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2KTPIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:08:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2KTPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:08:15 -0500
Date: Tue, 20 Nov 2012 16:07:55 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH v2] pwm: Device tree support for PWM polarity.
Message-ID: <20121120150755.GB24545@avionic-0098.adnet.avionic-design.de>
References: <1353347472-26863-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <1353347472-26863-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1c3ml663vo6INhXjGwDks2aJdJStyedcMyYlIQ0mU9U
 M93FPXX0QFyuwpLtWZwkpiUVlHlY7m1xOCbguAb6QxSwaucnNC
 wr3dcDQH1Gh2CcaY+va6+Q10qvD9Uw91bndxKBcGhx0LNJjPdb
 nh9s6BoSYr2/h2PRo9pk2Be0jPISzaMtYhAiMyGL6RX3oLWkRI
 aBwdepmvMw8mR4vsTJ5AUjIJR2DDdl9rNI3i7dPnOvpcNDuo0N
 +cEAXd1+D61SGvPpDXQoLxThVAt/nbguGXjmm4DjXzICbL5PWZ
 g98DkOD0A9GblTTBuO2cYEK9bene85Tkc/yHuLTZ2ZaUFOFGpa
 1puc4oNLBbZ8+rmBvoo696LEPae2PwqovMlD0Ayb7BBF9vUeAj
 NohKPogGSPKYaQInyFT2g7TtMG7koKZwDKZpF0wiY9qDtVeHO6
 iv9/q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 11:21:12PM +0530, Philip, Avinash wrote:
[...]
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 112b314..70756f2 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -78,6 +78,10 @@ enum {
>  	PWMF_ENABLED =3D 1 << 1,
>  };
> =20
> +/* flags in the third cell of the DT PWM specifier */
> +#define PWM_SPEC_POLARITY	(1 << 0)
> +
> +

This doesn't belong in this header. It should go into core.c in
drivers/pwm.

>  struct pwm_device {
>  	const char		*label;
>  	unsigned long		flags;
> @@ -176,6 +180,8 @@ void pwm_put(struct pwm_device *pwm);
> =20
>  struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer=
);
>  void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
> +struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
> +		const struct of_phandle_args *args);

The placement of this prototype is odd. I think a better place would be
between pwm_request_from_chip() and pwm_get(), separated by blank lines
to make it stand out as an OF specific function.

>  #else
>  static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
>  {
> @@ -223,6 +229,12 @@ static inline struct pwm_device *devm_pwm_get(struct=
 device *dev,
>  static inline void devm_pwm_put(struct device *dev, struct pwm_device *p=
wm)
>  {
>  }
> +
> +static inline struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip=
 *pc,
> +		const struct of_phandle_args *args)
> +{
> +	return ERR_PTR(-ENODEV);
> +}

This function should only be used by PWM drivers and therefore doesn't
need to have a dummy implementation such as this.

Thierry

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQq5zLAAoJEN0jrNd/PrOhsz4P/39+Q2nTGeMPGW/4/vcQ8Abd
tV6jOyB5XZupn38FKj3Ihb0Qy4Fp8fkPJ15k1MSjt3/Ea8HWDW6yf+K/ECVcJLH0
JN0sKJL2foSyvdqPE69eYdLRY31Q79AT/W0gzqiuLtuWs4HUKVWitmvGEU9053+J
oAgzp0eLXLQlmeOxUDoX7OC9G7+hu++4lRUwTBIB6K5FcR5th7iWXBrPT7LSGv6p
FcQ4acI1I2qS8u2Z7VCwugc7DYw0XzaRgNKx+B4c5b0O+q7BHYfIeQVPPVwKCa/5
TmewKZ03wkwCsXxMRMUlB4fKnGUg78sCC/vY4fn4gwvPVym3UVC/HAnsYEmqWs4A
S3LceJ5Oo2ATK7z+jH+vZ82qLU7lB/Y4Qe9pOxftm2SINwWXpLet7VZ1IG6hSr04
lNFxIiqT79CtbpZJJPbzCyFGVQbMX7EktZFZF+CKn7+K4kjVmzIhYsp4ID6JCcRy
5S5to3ORBtUFqmHuL0oHIQYLBytYNgyHAcL3k3a1yfiw21F9bZmkVq5quL3oNmfC
lH7V4OeXpEbemnbSDHTBNOTN0TMBlblDAiBxqLGDrdNPJlU5Rh7FnaXHOzTbIM0W
fq2Hi1IhXmEeTiKE8vp5eg8pye02J6KDHxKuV/hfDxRQ7jBFbeQqu8rOTYiZsL2j
pJc19LBvYtYCjpYwNCCQ
=rVU2
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
