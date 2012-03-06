Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2CFXuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:50:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44500 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab2CFXuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:50:01 -0500
X-Sasl-enc: vEzTP6o2L+wB34ONa/Ila41ISud5TF5tF14mhWagBB5E 1331077800
Message-ID: <4F56A2A5.7010707@imap.cc>
Date: Wed, 07 Mar 2012 00:49:57 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.27) Gecko/20120215 SUSE/3.1.19 Thunderbird/3.1.19
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 05/68] TTY: remove re-assignments to tty_driver members
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz> <1330955575-26641-6-git-send-email-jslaby@suse.cz>
In-Reply-To: <1330955575-26641-6-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2BAF635A396B50ECE937EA81"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2BAF635A396B50ECE937EA81
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 05.03.2012 14:51, schrieb Jiri Slaby:
> All num, magic and owner are set by alloc_tty_driver. No need to
> re-set them on each allocation site.

Nice.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

For drivers/isdn/gigaset:

Acked-by: Tilman Schmidt <tilman@imap.cc>

> diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/in=
terface.c
> index b826dac..7e54577 100644
> --- a/drivers/isdn/gigaset/interface.c
> +++ b/drivers/isdn/gigaset/interface.c
> @@ -669,17 +669,15 @@ EXPORT_SYMBOL_GPL(gigaset_if_receive);
>  void gigaset_if_initdriver(struct gigaset_driver *drv, const char *pro=
cname,
>  			   const char *devname)
>  {
> -	unsigned minors =3D drv->minors;
>  	int ret;
>  	struct tty_driver *tty;
> =20
>  	drv->have_tty =3D 0;
> =20
> -	drv->tty =3D tty =3D alloc_tty_driver(minors);
> +	drv->tty =3D tty =3D alloc_tty_driver(drv->minors);
>  	if (tty =3D=3D NULL)
>  		goto enomem;
> =20
> -	tty->magic =3D		TTY_DRIVER_MAGIC;
>  	tty->type =3D		TTY_DRIVER_TYPE_SERIAL;
>  	tty->subtype =3D		SERIAL_TYPE_NORMAL;
>  	tty->flags =3D		TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
> @@ -687,9 +685,6 @@ void gigaset_if_initdriver(struct gigaset_driver *d=
rv, const char *procname,
>  	tty->driver_name =3D	procname;
>  	tty->name =3D		devname;
>  	tty->minor_start =3D	drv->minor;
> -	tty->num =3D		drv->minors;
> -
> -	tty->owner =3D		THIS_MODULE;
> =20
>  	tty->init_termios          =3D tty_std_termios;
>  	tty->init_termios.c_cflag  =3D B9600 | CS8 | CREAD | HUPCL | CLOCAL;

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2BAF635A396B50ECE937EA81
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk9WoqYACgkQQ3+did9BuFtxcQCfQ8YyyiG8DpVdSV/2F4XyzrvF
r2AAn0MheuJ1Bbe+RqNBzFWvLNEEEtGl
=GYDf
-----END PGP SIGNATURE-----

--------------enig2BAF635A396B50ECE937EA81--
