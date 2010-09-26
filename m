Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab0IZPTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:19:50 -0400
Received: from vps.mortis.eu ([79.99.135.181]:44189 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0IZPTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:19:49 -0400
Date: Sun, 26 Sep 2010 17:19:47 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] watchdog: add f71862fg support
Message-ID: <20100926151947.GD7185@salidar.me.mortis.eu>
References: <20100926143241.GC2150@kreios.titan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <20100926143241.GC2150@kreios.titan>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 26, 2010 at 04:32:41PM +0200, Lutz Ballaschke wrote:
> ioctl WDIOC_GETTIMELEFT and helper function added to watchdog driver=20
> for common usage.
>=20
> ... snip ...
>=20
> +static int watchdog_time_left(void)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&watchdog.lock);
> +	ret =3D superio_enter(watchdog.sioaddr);
> +	if (ret)
> +		goto exit_unlock;
> +
> +	superio_select(watchdog.sioaddr, SIO_F71808FG_LD_WDT);
> +	ret =3D superio_inb(watchdog.sioaddr, F71808FG_REG_WD_TIME);
> +	superio_exit(watchdog.sioaddr);
> +
> +exit_unlock:
> +	mutex_unlock(&watchdog.lock);
> +	return ret;
> +}

This function still has the problem I described earlier, namely that of
returning minutes to userspace (which expects seconds) when minutes_mode
is true.

I would thus suggest not to commit this patch as it violates the
Watchdog API.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"There are only two kinds of languages: the ones people complain about
 and the ones nobody uses."
  -- Bjarne Stroustrup

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyfZJMACgkQZBYm/87l50J82gCfWog/Uh/IbMVWO0c7bCShu7SH
SfgAn3XakqbSitpVCnZpxNjTA5Qy7xr4
=ISkq
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
