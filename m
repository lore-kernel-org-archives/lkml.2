Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2ICHQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 03:16:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:14061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2ICHQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 03:16:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="asc'?scan'208";a="195703681"
Message-ID: <1346656863.3061.11.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/3] mtd: cmdlinepart: sort the unsorted partitions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, shmulik.ladkani@gmail.com
Date: Mon, 03 Sep 2012 10:21:03 +0300
In-Reply-To: <1346001700-26895-2-git-send-email-shijie8@gmail.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
	 <1346001700-26895-2-git-send-email-shijie8@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zdNleoNaf9VFmibJimfH"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zdNleoNaf9VFmibJimfH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-26 at 13:21 -0400, Huang Shijie wrote:
> +/* There are only several partitions, so the Bubble sort is enough. */
> +static inline void sort_partitons(struct mtd_partition *parts, int num_p=
arts)
> +{
> +	int i, j;
> +
> +	if (num_parts < 2)
> +		return;

Not necessary, the for loop should work for this case.
> +
> +	if (parts[0].offset =3D=3D OFFSET_CONTINUOUS)
> +		return;

Hmm, I guess the sorting function should not have this check. You
probably can just sort normally these ones, they will be the last ones.

And then we can do a separate pass where we check for overlapping
partitions and multiple OFFSET_CONTINUOUS.

> +
> +	/* sort by the offset */
> +	for (i =3D 0; i < num_parts - 1; i++) {
> +		for (j =3D 1; j < num_parts - i; j++) {
> +			if (parts[j - 1].offset > parts[j].offset) {
> +				struct mtd_partition tmp;
> +
> +				tmp =3D parts[j - 1];
> +				parts[j - 1] =3D parts[j];
> +				parts[j] =3D tmp;
> +			}
> +		}
> +	}
> +	return;
> +}


--=20
Best Regards,
Artem Bityutskiy

--=-zdNleoNaf9VFmibJimfH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRFpfAAoJECmIfjd9wqK0WxgQALleSpzV6QLNlqyrVU95eHvF
bX2FsqqU7y4Y4y5q52YaCAZxhBwjFCx37pUSpzc9rum96P1vurVG25jgIScKcaNT
MC36LPC8jxhZ9kDjraXRaWvBqXonTfj7OFj7zxAxYqE46FFeWrCWAAL94dMDGwx5
EKosvadYStw2epqwMhOhcaNzOk2X+9AZj/rUWzfvi8jKs2vTO0WYszhiUuD/hQf7
+VZU72nYZ9/2It+hR2t1nhnrrK7XVlGnF2oYXE1LtOLloWiBo5Ty7aTF0bzmJLBt
5EwRCTRCWx+KOaYkIr9eg957qRbAtBsQqXyF2hhGL35mRToJdUR1TTZWeqH5gH/A
/BSHMbyuVV7RulCGWKY1HAerWR1q+9K+vu+Uw6XSlMvTMuhgBVu4gE9DxC3tCo9g
jGbNxp4l3JjAxPLF1RjXSevGhnNHbTfEpGN/wIh31L6QlCEqGazcZcG85eGsE4yg
B/OmUoWWXSVAkaxvnKWtNDsnlI7EfcLP1x3qa+CmeROBkg7HkY9QIYEF6bYOaEpN
msaGSNKLQ89J/5N5beyEBAN0ZlrwoE0hwcwTA/84pOOmFmR/YJD7fnTeAgdKMmov
b8HWkbIEuziH5TWviiyVzokhCkBTFrEaMiBvbji4ehmRJhXSawf2etbg3d31Y5Wt
pV2WYxDCAd35x/pbcM8g
=FkGW
-----END PGP SIGNATURE-----

--=-zdNleoNaf9VFmibJimfH--

