Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0LFT0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:26:10 -0500
Received: from vps.mortis.eu ([79.99.135.181]:32786 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab0LFT0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:26:08 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 14:26:08 EST
Date: Mon, 6 Dec 2010 20:19:30 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Michel Arboi <michel@arboi.fr.eu.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Patch for Fintek F71869 watchdoh
Message-ID: <20101206191930.GA3188@salidar.me.mortis.eu>
References: <4CFCB76D.2060405@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <4CFCB76D.2060405@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2010 at 11:14:05 +0100, Hans de Goede wrote:
>> -------- Original Message --------
>> Subject: Patch for Fintek F71869 watchdoh
>> Date: Mon, 6 Dec 2010 00:40:43 +0100
>> From: Michel Arboi <michel@arboi.fr.eu.org>
>> Organization: Compilo ergo sum
>> To: Hans de Goede <hdegoede@redhat.com>
>>=20
>> I'm not sure that you are the right person, but actually I do not know
>> who I should contact. I saw that you were working on the support of
>> the Fintek F71869 sensors.

These are the e-mail addresses to send patches for that driver to:
> ~/git/linux-2.6 $ scripts/get_maintainer.pl -f drivers/watchdog/f71808e_w=
dt.c
> Wim Van Sebroeck <wim@iguana.be>
> Giel van Schijndel <me@mortis.eu>
> linux-watchdog@vger.kernel.org
> linux-kernel@vger.kernel.org

>> I have a Jetway NC9C-550-LF mobo, I quickly hacked this to support the
>> watchdog. It seems to work.
>=20
> Here is a patch send to me to add support for the F71869 to the Fintek
> superio watchdog driver.
>=20
> Michel, I've forwarded you're patch to Giel, who is the author and
> maintainer of the Fintek superio watchdog driver.

> --- ./drivers/watchdog/f71808e_wdt.c	2010-10-20 22:30:22.000000000 +0200
> +++ /tmp/f71808e_wdt.c	2010-12-05 01:19:48.819567802 +0100
> @@ -52,6 +52,8 @@
>  #define SIO_F71882_ID		0x0541	/* Chipset ID */
>  #define SIO_F71889_ID		0x0723	/* Chipset ID */
> =20
> +#define SIO_F71869_ID		0x0814
> +
>  #define	F71882FG_REG_START		0x01
> =20
>  #define F71808FG_REG_WDO_CONF		0xf0

Please insert that constant in the list of other Chipset ID's
alphabetically sorted (to keep that list consistent).

> @@ -98,7 +100,7 @@
>  MODULE_PARM_DESC(start_withtimeout, "Start watchdog timer on module load=
 with"
>  	" given initial timeout. Zero (default) disables this feature.");
> =20
> -enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg };
> +enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg, f71869 };
> =20
>  static const char *f71808e_names[] =3D {
>  	"f71808fg",
> @@ -106,6 +108,7 @@
>  	"f71862fg",
>  	"f71882fg",
>  	"f71889fg",
> +	"f71869",
>  };
> =20
>  /* Super-I/O Function prototypes */
> @@ -308,6 +311,10 @@
>  		superio_set_bit(watchdog.sioaddr, 0x29, 1);
>  		break;
> =20
> +	case f71869:
> +		/* GPIO14 --> WDTRST# */
> +		superio_clear_bit(watchdog.sioaddr, 0x29, 4);
> +		break;
>  	default:
>  		/*
>  		 * 'default' label to shut up the compiler and catch
> @@ -708,6 +715,9 @@
>  	case SIO_F71882_ID:
>  		watchdog.type =3D f71882fg;
>  		break;
> +	case SIO_F71869_ID:
> +		watchdog.type =3D f71869;
> +		break;
>  	case SIO_F71862_ID:
>  	case SIO_F71889_ID:
>  		/* These have a watchdog, though it isn't implemented (yet). */

The rest of that patch looks fine.  So if you perform the above
modification you'll get my Ack.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Measuring programming progress by lines of code is like measuring
 aircraft building progress by weight."
  -- Bill Gates

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkz9Nz8ACgkQZBYm/87l50LAEQCfYUSkJKamhphUDHUJSb0mATL7
hP8An0Ym8U9CuA42hmj2yoJF1cTQYwCY
=83HV
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
