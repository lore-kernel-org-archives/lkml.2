Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2JONHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:07:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42523 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2JONHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:07:23 -0400
Date: Mon, 15 Oct 2012 16:01:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH RESEND] usb: gadget: lpc32xx_udc: Fix compatibility with
 STOTG04
Message-ID: <20121015130150.GQ24333@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aX6oBa4COn3eIhlv"
Content-Disposition: inline
In-Reply-To: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aX6oBa4COn3eIhlv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 15, 2012 at 09:47:35AM -0300, Alexandre Pereira da Silva wrote:
> The STOTG04 is an replacement for ISP1301.
>=20
> Most of the registers on STOTG04 are the same as on ISP1301, but the
> register ISP1301_I2C_OTG_CONTROL_2 (address 0x10) doesn't exist on the
> ST part.
>=20
> This is a work around for this by using the interrupt source register that
> should behave the same on both parts and has the needed information.
>=20
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
>=20
> This patch is very important to LPC32xx users. IMHO this should go in for=
 3.7-rc2.
>=20
>  drivers/usb/gadget/lpc32xx_udc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32x=
x_udc.c
> index f696fb9..21a9861 100644
> --- a/drivers/usb/gadget/lpc32xx_udc.c
> +++ b/drivers/usb/gadget/lpc32xx_udc.c
> @@ -2930,10 +2930,10 @@ static void vbus_work(struct work_struct *work)
> =20
>  		/* Get the VBUS status from the transceiver */
>  		value =3D i2c_smbus_read_byte_data(udc->isp1301_i2c_client,
> -						 ISP1301_I2C_OTG_CONTROL_2);
> +						 ISP1301_I2C_INTERRUPT_SOURCE);
> =20
>  		/* VBUS on or off? */
> -		if (value & OTG_B_SESS_VLD)
> +		if (value & INT_SESS_VLD)

why isn't this using a PHY driver instead ?

>  			udc->vbus =3D 1;
>  		else
>  			udc->vbus =3D 0;
> --=20
> 1.7.10
>=20

--=20
balbi

--aX6oBa4COn3eIhlv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfAk+AAoJEIaOsuA1yqREquoQAIxdQN2kR2IoG/jWoYGb7wyY
XdNma+IkVWO3dNpimEyt9p9pIVXlla1pZvnhT9u1uz1htARqIWBe7d4D8M0hxFj/
8Ztn80S4ODHpC/oaTLciHP5w5GL7WELGtHJcvGKvW88TqZL1SO7SLq6FtzfWQUzo
96mMitzG5LcHThN6QQzkVY3Eaf4sK25q2gX27Hk2yTC0A6ffeHxGL88nnxNc9yEj
msE2b7q9Byh7KrRSS+5pI3lrmJmJwNrRmye1SxdWswWf6U5ptzdLMkIhMCUl5XI9
xGT98WknMzQcYmwUW/kcI7WEnHd6EPSgx6rjBuD+FvlbtRRrqyk4Pg7oyfX33IY5
8yvdMchJVSgBEDLL/Z6RH89IQt9glDJCrLY/iHw8LkczRaNJj3b7RMb7kyjRn3Gb
j9HaUK8igQfZPzJ+r2eeu0O5S+ylNf3b4SVXNe4XMe+Rq1EJmGuNGf3qXEuGZliu
Yi7DardttTi3IG/vSomUR/iJBcXexldIuRrWgRFKpVk+Kz79qP+wowInFCmqg3N3
XNn/cNbadZK770Jj+XVx8bdBRF/dzJW5L5sMRqX/jGUCY3Sf073gS8YT1crK7m5i
AsGirQL1EqBMLVvw6zrZLxEw5PdMbB4mZNu2PHdrdUTrHG3KiM1jT4uciWtJTdyF
n4GDYbcz267PC3Jf4sjW
=uGrd
-----END PGP SIGNATURE-----

--aX6oBa4COn3eIhlv--
