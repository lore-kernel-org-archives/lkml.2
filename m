Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0ESKe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:34:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0ESKez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:34:55 -0400
Date: Wed, 19 May 2010 12:34:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media/dvb/dvb-usb/dib0700: fix return values
Message-ID: <20100519103448.GH5202@pengutronix.de>
References: <1274264772-19292-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4C6bbPZ6c/S1npyF"
Content-Disposition: inline
In-Reply-To: <1274264772-19292-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4C6bbPZ6c/S1npyF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 19, 2010 at 12:26:12PM +0200, Daniel Mack wrote:
> Propagte correct error values instead of returning -1 which just means
> -EPERM ("Permission denied")
>=20
> While at it, also fix some coding style violations.
>=20
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Just minor nits. You decide if it is worth a resend ;)

> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/dvb/dvb-usb/dib0700_core.c |   47 ++++++++++++++----------=
-----
>  1 files changed, 23 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb=
/dvb-usb/dib0700_core.c
> index d5e2c23..c73da6b 100644
> --- a/drivers/media/dvb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
> @@ -111,23 +111,24 @@ int dib0700_set_gpio(struct dvb_usb_device *d, enum=
 dib07x0_gpios gpio, u8 gpio_
> =20
>  static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_=
packets)
>  {
> -    struct dib0700_state *st =3D d->priv;
> -    u8 b[3];
> -    int ret;
> -
> -    if (st->fw_version >=3D 0x10201) {
> -	b[0] =3D REQUEST_SET_USB_XFER_LEN;
> -	b[1] =3D (nb_ts_packets >> 8)&0xff;
> -	b[2] =3D nb_ts_packets & 0xff;
> -
> -	deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
> -
> -	ret =3D dib0700_ctrl_wr(d, b, 3);
> -    } else {
> -	deb_info("this firmware does not allow to change the USB xfer len\n");
> -	ret =3D -EIO;
> -    }
> -    return ret;
> +	struct dib0700_state *st =3D d->priv;
> +	u8 b[3];
> +	int ret;
> +
> +	if (st->fw_version >=3D 0x10201) {
> +		b[0] =3D REQUEST_SET_USB_XFER_LEN;
> +		b[1] =3D (nb_ts_packets >> 8)&0xff;

Spaces around operators?

> +		b[2] =3D nb_ts_packets & 0xff;
> +
> +		deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
> +
> +		ret =3D dib0700_ctrl_wr(d, b, 3);
> +	} else {
> +		deb_info("this firmware does not allow to change the USB xfer len\n");
> +		ret =3D -EIO;
> +	}
> +
> +	return ret;
>  }
> =20
>  /*
> @@ -642,7 +643,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
>  	i =3D dib0700_ctrl_wr(d, rc_setup, 3);
>  	if (i<0) {

Spaces around operators?

>  		err("ir protocol setup failed");
> -		return -1;
> +		return i;
>  	}
> =20
>  	if (st->fw_version < 0x10200)
> @@ -652,7 +653,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
>  	purb =3D usb_alloc_urb(0, GFP_KERNEL);
>  	if (purb =3D=3D NULL) {
>  		err("rc usb alloc urb failed\n");
> -		return -1;
> +		return -ENOMEM;
>  	}
> =20
>  	purb->transfer_buffer =3D usb_buffer_alloc(d->udev, RC_MSG_SIZE_V1_20,
> @@ -661,7 +662,7 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
>  	if (purb->transfer_buffer =3D=3D NULL) {
>  		err("rc usb_buffer_alloc() failed\n");
>  		usb_free_urb(purb);
> -		return -1;
> +		return -ENOMEM;
>  	}
> =20
>  	purb->status =3D -EINPROGRESS;
> @@ -670,12 +671,10 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
>  			  dib0700_rc_urb_completion, d);
> =20
>  	ret =3D usb_submit_urb(purb, GFP_ATOMIC);
> -	if (ret !=3D 0) {
> +	if (ret !=3D 0)

if (ret)

>  		err("rc submit urb failed\n");
> -		return -1;
> -	}
> =20
> -	return 0;
> +	return ret;
>  }
> =20
>  static int dib0700_probe(struct usb_interface *intf,
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--4C6bbPZ6c/S1npyF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvzvsgACgkQD27XaX1/VRs5VQCePmurfL6pe8838yyj/MV8DOzC
eDUAnRl6ges/zmwrLUi1K77AM6vhvzLY
=PdD+
-----END PGP SIGNATURE-----

--4C6bbPZ6c/S1npyF--
