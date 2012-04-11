Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2DKMZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:25:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:33524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2DKMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:25:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="129605320"
Message-ID: <1334147205.13842.8.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: allow atomic updates to sychronously erase old PEB
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Apr 2012 15:26:45 +0300
In-Reply-To: <alpine.DEB.2.00.1203301709080.10066@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
	   <4F748CD6.4080704@parrot.com>
	   <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>
	  <1333110503.5440.24.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
	 <1333111321.5440.29.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203301709080.10066@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nQM9LBMot3NxZJ+7SvxP"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nQM9LBMot3NxZJ+7SvxP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

sorry for long delay.

First of all - please, make UBI and UBIFS changes in separate patches -
we consider these to be separate subsystems.

On Fri, 2012-03-30 at 17:11 +0200, Joel Reardon wrote:
> @@ -629,12 +628,13 @@ static int erase_worker(struct ubi_device *ubi, str=
uct ubi_work *wl_wrk,
>   * @ubi: UBI device description object
>   * @e: the WL entry of the physical eraseblock to erase
>   * @torture: if the physical eraseblock has to be tortured
> + * @sync: schedule the work immediately and return after completion
>   *
>   * This function returns zero in case of success and a %-ENOMEM in case =
of
>   * failure.
>   */
>  static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e=
,
> -			  int torture)
> +			  int torture, int sync)
>  {
>  	struct ubi_work *wl_wrk;
>=20
> @@ -649,7 +649,11 @@ static int schedule_erase(struct ubi_device *ubi, st=
ruct ubi_wl_entry *e,
>  	wl_wrk->e =3D e;
>  	wl_wrk->torture =3D torture;
>=20
> -	schedule_ubi_work(ubi, wl_wrk);
> +	if (sync)
> +		erase_worker(ubi, wl_wrk, 0);
> +	else
> +		schedule_ubi_work(ubi, wl_wrk);
> +
>  	return 0;
>  }

Please, do not modify this function. You only need to do "if (sync)"
in 'ubi_wl_put_peb()' and nowhere else, so do it directly there.

You will have no "what if sync fails" issues then. Also, just from
common sense point of view, "schedule_erase" should schedule, not erase.

Otherwise looks good - I can take this to the ubifs tree straight
away even without your security stuff.

--=20
Best Regards,
Artem Bityutskiy

--=-nQM9LBMot3NxZJ+7SvxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPhXiFAAoJECmIfjd9wqK08UkP/3mj/OuC1nF/ocfp22xYwB2m
opwxAFVK2JGLRuDYSrim72aEDw6YubNye4HL6gmbIeVuyvhJlMb2oFUcZ7q7pTaF
68y08/u/3ow0x6lcRJokHCdEscOBuCS2e/VGtw73N/xG1tKKJneLLcqpiaR58tl2
7Uo90GhjwZFRd4KpSq3h+6Uuht91GZV2Ak9NBSmH2BSLvyTqwbIwQNX8gDUUmjAZ
L8ab586xi7MT+ri7Oxt/TRLfdvQiGgJ2FWg/lMyNf8oeU27HzhtrYj4omYjWBPXU
Snp4cUeELbmCouSoV9F9F9KQT5OcBuWIWvaz8Db7MGAmYbbFiEyyEMLYR+l1JsnE
Zx4321NwB2ErjzARKhpK8ZtQrIBqa54c6xLNg+fAK3rkFfQUw2WfxIjkNau1Xauw
o2RYmK1+vMPdoCDHk/+eoc345s0yxkInFC8QvqN0TSYJmQlZqAGKYAJEeBWGGuZr
xJwRTP4HA4ZANpVhYxpZXM8TzsaMe0cqvwpOi3oqk2MwSZG38c7Ra+YM8ZiUUeXP
n1WUyNEBYDPuq+ow34AnDvPKOSDJfz826EFpNQa+36qRmRZSAvEa3woBuItYdfU2
1LU1TkKlPgoQlQOk0xIp3N9U7kM0LQNPfL91/PFi7wrsa16gEig85VqKVe2FEezg
/mpB58hfOIGiYZF+xHVo
=XIsO
-----END PGP SIGNATURE-----

--=-nQM9LBMot3NxZJ+7SvxP--

