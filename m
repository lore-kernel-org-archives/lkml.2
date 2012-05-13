Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab2EMJwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 05:52:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab2EMJwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 05:52:05 -0400
Message-ID: <4FAF843F.2010704@nod.at>
Date: Sun, 13 May 2012 11:51:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Joel Reardon <joel@clambassador.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] UBI: add means to clear ubi work queue for particular
 lnums
References: <alpine.DEB.2.00.1205121712410.24689@eristoteles.iwoars.net> <alpine.DEB.2.00.1205131043370.654@eristoteles.iwoars.net>
In-Reply-To: <alpine.DEB.2.00.1205131043370.654@eristoteles.iwoars.net>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig43BCCD732AEC588011752858"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig43BCCD732AEC588011752858
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 13.05.2012 10:47, schrieb Joel Reardon:
> +int ubi_wl_flush_lnum(struct ubi_device *ubi, int lnum)
> +{
> +	int err =3D 0;
> +	struct ubi_work *wrk, *tmp;
> +
> +	/* For each pending work, if it corresponds to the parameter @lnum,
> +	 * then execute the work.
> +	 */
> +	dbg_wl("flush lnum %d", lnum);
> +	list_for_each_entry_safe(wrk, tmp, &ubi->works, list) {
> +		if (wrk->lnum =3D=3D lnum) {
> +			spin_lock(&ubi->wl_lock);
> +			list_del(&wrk->list);
> +			ubi->works_count -=3D 1;
> +			ubi_assert(ubi->works_count >=3D 0);
> +			spin_unlock(&ubi->wl_lock);
> +
> +			err =3D wrk->func(ubi, wrk, 0);
> +			if (err)
> +				ubi_err("work failed with error code %d", err);
> +		}
> +	}
> +
> +	return err;
> +}

I think you also have to grab ubi->work_sem in read mode here.

Thanks,
//richard


--------------enig43BCCD732AEC588011752858
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPr4Q/AAoJEN9758yqZn9eYJMIAJ7t852VD4KmliYrCdLGnhN0
pp/8DppEkZ11H+eqmpLcP+NHBKEiAlsQ9n60hORNvcyPHoqvvTDDp+w8N+2Xr/pk
Mf8BKgimvUkCcxzXX6pOE2HmcyGhB5U/wDu4PPUn/0V7FQV645dPT3ymoQ524AXi
0ZwURw2/Ij5Z5qTKKaHYnVLdOYw7zaFckJr/eOk7wlDESIr3opRl6rFOtJaC6H9V
yH0H9MHge57wwMgtlualMiB3xVbIQig8h0WUEFUTVQJ3F1+ATfZHiOHZZV+g8iV5
Rcvindu9W1WouB9KiWsRzCqLSuG1Glzjz5WoLSw+ZYycyTdJBoYIWPBY4gZvdbs=
=IFlB
-----END PGP SIGNATURE-----

--------------enig43BCCD732AEC588011752858--
