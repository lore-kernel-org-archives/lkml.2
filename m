Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2JBGLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:11:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2JBGLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:11:48 -0400
Date: Tue, 2 Oct 2012 08:11:43 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH 2/2] pwm: pwm-tiehrpwm: Add device-tree binding support
 for EHRPWM driver
Message-ID: <20121002061143.GB4298@avionic-0098.mockup.avionic-design.de>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-3-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <1348658863-29428-3-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5onJtNpzFZ/qs8nX+/vwM9FIdpp4P8/Gq0qBnJG8KpR
 5B4Of7+b8hw5U6v+kwNdR9qJ2NQIVeBfHPcBVGpS5xxU627hAU
 KlReCUpELwgEkrHOy6ggOHGICB1qmpUUgqITipppXFQyeWl/8/
 PJ74nim5Qb/xsj1mS9aKGlZ35T9Wxi2D8rjLIe5au2kFhlpVbJ
 w1+XwKZ5VuiNUzbF5ZLSpwsnApsf+m+STA0T1No2zij+CnVzd4
 MrkeSfOflZXNrUiwT99GCvcZiAwa/L4X3K2lunzKekwyXu+D8+
 gHcIo9rmKppN1QnURNpffwUwtPCKB2XNvIR69rtTg8p80b5Z6J
 rOM+tYVXU7M1UNYNJrGk6eHMHcTr8Hu3b1t22SqrhQvJx+fDCw
 ldteHipIQ5q5wbLGqzSF9QWkgsLkjQ47LM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 26, 2012 at 04:57:43PM +0530, Philip, Avinash wrote:
> Add support for device-tree binding and of_xlate for EHRWPM driver.
> of_xlate provides EHRPWM polarity configuration from client driver
> device-tree.
> Also size of pwm-cells set to 3 to support pwm channel number, pwm
> period & polarity configuration from device tree.

Oh, I forgot to mention this in my reply to the previous patch, but you
should consistently use PWM to refer to PWM devices, so the above should
be "PWM channel number" and "PWM period & polarity". And the property is
named "#pwm-cells".

> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> :000000 100644 0000000... 05d9d63... A	Documentation/devicetree/bindings/=
pwm/pwm-tiehrpwm.txt
> :100644 100644 caf00fe... ae23c2b... M	drivers/pwm/pwm-tiehrpwm.c
>  .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   26 +++++
>  drivers/pwm/pwm-tiehrpwm.c                         |  107 ++++++++++++++=
++++++
>  2 files changed, 133 insertions(+), 0 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Doc=
umentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
> new file mode 100644
> index 0000000..05d9d63
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
> @@ -0,0 +1,26 @@
> +TI SOC EHRPWM based PWM controller
> +
> +Required properties:
> +- compatible : Must be "ti,am33xx-ehrpwm"
> +- #pwm-cells: Should be 3. Number of cells being used to specify PWM pro=
perty.
> +  First cell specifies the per-chip index of the PWM to use, the second
> +  cell is the period cycle in nanoseconds and the third cell is the

"period cycle" doesn't make much sense. It should be "period" only. This
also applies to the previous patch.

> +  polarity of PWM output. Polarity 0 gives normal polarity and 1 gives
> +  inversed polarity (inverse duty cycle)

I don't think "inversed" exists. It should be either "inverted polarity"
or "inverse polarity".

> +- reg: physical base address and size of the registers map. For am33xx,
> +  2 register maps are present (EHRPWM register space & PWM subsystem com=
mon
> +  config space). Order should be maintained with EHRPWM register map as =
first
> +  entry & PWM subsystem common config space as second entry.
> +
> +Optional properties:
> +- ti,hwmods: Name of the hwmod associated to the EHRPWM:
> +  "ehrpwm<x>", <x> being the 0-based instance number from the HW spec

I don't see where this property is used. There is no code in this patch
that parses it.

> +static struct pwm_device *of_ehrpwm_xlate(struct pwm_chip *chip,
> +		const struct of_phandle_args *args)
> +{
> +	struct pwm_device *pwm;
> +
> +	if (chip->of_pwm_n_cells < PWM_CELL_SIZE)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (args->args[0] >=3D chip->npwm)
> +		return ERR_PTR(-EINVAL);
> +
> +	pwm =3D pwm_request_from_chip(chip, args->args[0], NULL);
> +	if (IS_ERR(pwm))
> +		return pwm;
> +
> +	pwm_set_period(pwm, args->args[1]);
> +	pwm_set_polarity(pwm, args->args[2]);
> +	return pwm;
> +}

This is an exact duplicate of the ECAP's of_xlate(). Maybe we should
make this part of the PWM core. If so it is probably safer to define the
values for the third cell as flags, where the polarity is encoded in bit
0, and make the function handle this accordingly to allow other bits to
be added in the future.

The same comments as for patch 1 apply to the rest of this patch as
well.

Thierry

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQaoWfAAoJEN0jrNd/PrOhMjoP/jskEvA+YGj9ja3H9l9GlVEj
R+LVwaSi/jZeIAk5godM8bZoof+AjIZRbOuCWoUMvNVmJzZk8DXZjr/H4oQiZykw
vHRN4nSv563agghkraE+xzVtjhdSBZaa1MoyE8pM9aXapsM+ZQ9siijAA0dyj5+A
Lnh54viM0R6RbUV3y5se/GtmTk6mZ1vz0EWCDhsW5yyLdMibTuEgC/kfsR/2rWlo
5SZFtAROZiPDn8xqk05nsXUByJ91dVvkZtOsjcj4XENG877wh84IObzXTy87vKVi
g5DvIJ63f9jQifwhzQ2N0u7rv6n0f2bE1D9M2M5uswdUZlyd5nZrfeuzoXDp88Dq
5rZOtABgVLzTCiLOHwqWORCj7tZiWQce5y7omn5cOnEMA7OktAHSIS8yloJvo5xP
tqE/mLfpMmTIYdqAqosSx3xlkDeFVTcJN1zDYLQHDx4nmIdaohVVXBbVI5K8AsFm
Dk9Q++flCc9G0SwoZQ/S0mLeOYMPRgsQxIDMnLQSqA0JdWXf1IhWmb1gyOn7crcv
TNNfAzaBb7KWohS9Mwu6OYSaNOlfAMxFNMuqXx7UN/wT+UDjwLpUufYnqxgwa89s
X37KOK1J0L3bF0wUwVZSQeG+o51dfWERdec9b+8KJ/uFKBA4uRXf4dElcGNGdFMp
5RZp9thqd5d+eF4Z3eY2
=EDZa
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
