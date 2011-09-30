Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab1I3N3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:29:22 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33258 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab1I3N3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:29:21 -0400
Date: Fri, 30 Sep 2011 16:29:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110930132914.GA877@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 15, 2011 at 04:51:22PM +0200, Sebastian Andrzej Siewior wrote:
> If id_entry is available then it is used. However if we remove first the
> driver followed by the device, then the id_entry is pointing to driver's
> memory which is long gone.
> Since id->name and plat->name are equal there is no point in
> distinguishing them.
>=20
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/base/platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 0cad9c7..cd71575 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct=
 kobj_uevent_env *env)
>  		return rc;
> =20
>  	add_uevent_var(env, "MODALIAS=3D%s%s", PLATFORM_MODULE_PREFIX,
> -		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> +			pdev->name);
>  	return 0;
>  }
> =20

Just a gentle reminder on this patch. Greg, has this one been queued to
your drivers-core tree ? Should it go on -rc or now it's already too
late and going on merge window ?

thanks

--=20
balbi

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhcQqAAoJEAv8Txj19kN1fdYH/2ZAqNjWyM3U2ziid1jOnT2L
kIzCtdAHO5+XpOhjznyumJ+Lzmk3uYy3U9DYDYuE5lJugz6/l1j2JGDpBD4sxJpe
O85fUrfZwXjPkt8hJOrIJglfXmbTZq75GKoJ23WtLg0KVE9SpcKiEsUUnYC895ND
Hy5WC+HfY+8G3zAL4T0taupzTICqFYJmQx8PhAswLdGy8sNOr+388SEdHX/uBhhP
TkPI0eT3If39Zj7KFIv8nVKXKz31rpK8ak0+fJ135nKg1fILiP+tBhR/XiCB8Qa/
Dtl5sFjCf/1yKP4twIfAgdXlcxWIffWpgf/fO38Y7dPWtHd1Yu0IsPe8axumF/I=
=+qK2
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
