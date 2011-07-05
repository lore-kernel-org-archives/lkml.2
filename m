Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1GELWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:22:53 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51758 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173Ab1GELWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:22:52 -0400
Date: Tue, 5 Jul 2011 14:22:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/5] MFD: twl6040: Add irq variable for slave devices
Message-ID: <20110705112245.GA2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com>
 <1309857266-3663-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U58U7wle/RT11wuz"
Content-Disposition: inline
In-Reply-To: <1309857266-3663-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U58U7wle/RT11wuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 12:14:22PM +0300, Peter Ujfalusi wrote:
> Add new variable to pass the irq number for the slaves
> devices of twl6040.
> The irq number configuration is done in the twl6040-core
> at probe time, so machine drivers do not need to be
> modified.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040-core.c |    2 ++
>  include/linux/i2c/twl.h    |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
> index cfaedb5..8607793 100644
> --- a/drivers/mfd/twl6040-core.c
> +++ b/drivers/mfd/twl6040-core.c
> @@ -501,6 +501,7 @@ static int __devinit twl6040_probe(struct platform_de=
vice *pdev)
>  	if (pdata->codec) {
>  		cell =3D &twl6040->cells[children];
>  		cell->name =3D "twl6040-codec";
> +		pdata->codec->plug_irq =3D twl6040->irq_base + TWL6040_IRQ_PLUG;

are the slave devices platform_devices ?? If so, you could use struct
resource to pass IRQs as that's the "approved" way to do so. Then, on
child driver, you could either rely on a particular order of the
resources or assign them names and use platform_get_irq_byname() to
fetch the correct one (if you have more than one, that is).

--=20
balbi

--U58U7wle/RT11wuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEvQFAAoJEAv8Txj19kN1hQAH/1TxayhLhvN0b21Qd5nkw0/q
U3dXUCXq3jQ/jbiPFhY3zkdJMbwbiKIQhWGafOxpDwePKLG8AfLeCk70GVoStz8/
LuAsDUbnsri2j5BeJcUEWMMZOm8W8sIBKfQzuF8GggRjInfKYCN2l8UssKK3/FyA
DAF/iTETbB3bre2mX4mgG15Dhxq3Tl41rSOaINJFAheKYOudFrPWEmm0vN6XRZ+s
SJB9iZUQjY6viatt+5qELpYGc5K7WiOcc+1PIZbHb7MpwMEHou5bvRBUt9dQx7Rh
C5Ukr9FKvQ7e407of1zo/tna3krNjyckMJ75j+AhZn8iVFDEDFEYw6JA3yEr/Mc=
=3Umx
-----END PGP SIGNATURE-----

--U58U7wle/RT11wuz--
