Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2EHI6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:58:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:48934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab2EHI6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:58:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="141318473"
Message-ID: <1336467723.23308.23.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Replace yield() with cond_resched()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Date: Tue, 08 May 2012 12:02:03 +0300
In-Reply-To: <1336465602-12627-1-git-send-email-richard@nod.at>
References: <1336465602-12627-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qU9F2YOvAdcoXPhHjZ4z"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qU9F2YOvAdcoXPhHjZ4z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-08 at 10:26 +0200, Richard Weinberger wrote:
> The comment above yield()'s definition says:
>  * If you want to use yield() to wait for something, use wait_event().
>  * If you want to use yield() to be 'nice' for others, use cond_resched()=
.
>  * If you still want to use yield(), do not!
>=20
> The yield() usage of UBI really looks like the "be nice for others" case,
> so use cond_resched().
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> CC: peterz@infradead.org

I guess we would better sleep for a couple of hundreds of milliseconds
instead.

The purpose was different. If we have I/O error, we hope it is a
transient failure. E.g., the HW is temporary unavailable because of an
internal issue. And with yield() we hoped to schedule away for longer
time than usual and let other processes which may affect that HW go
forward and do something.

But whole this thing does not have any solid real-case basis, just
something which looked sane to do to me.

Someone on the list also questioned the entire re-tries, but he did not
care enough to send a tested patch. But this is a separate and
independent issue.

--=20
Best Regards,
Artem Bityutskiy

--=-qU9F2YOvAdcoXPhHjZ4z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqOELAAoJECmIfjd9wqK0txsQALC0dTOz5zqAmf3NQS7O2iS8
65o1oYrxmPBWKacSN5bpFL45e69/KjU2HbiouthlilKkZQNVxAs/UCI905DJI/mG
qMXoTeqyd7WykeVJEZ8WM2Warq6Z31G9BxM4WJFktBFplcf94AxhLGcU6YdyaUSh
Wz+NPBXjvujQAlVaNQfrhFjWt2RMvgVIov05KppCh3yAvKEzc/kShbtyRjXOEjow
3wH5gJl4W3t/yfl6hVAyO1tXMbvJpr8zuVIZKiGXHKrM49or0mCGKW7j6NR3V34G
iyHQkeXf0FqbEbKbQ6RNz+5FhDdSVluUQSwtiVjNukPkboka2XCcJBwziQhsNx9M
OasvUMc0m7yf/uXS8NZ/hIcv18ENQaNcv8Ikc2VkLqsEWmRAcHZcdIFPI6JXGvHA
n5sX6dRn4yiVUAo4WKFfuZdpmDzz5EMt1Gl/Z8X4umwS2QyB9L22AnSMZBLgK9Oz
hd6ydUpC54qXLoAscYfd5VWe2O40BQIKIV/aGczRs4C29H1mijOZFv7sA+m9wicC
CB7T2cuVhiF4VLtpv/5gMKgYHGPf8af8RmUolFZWCY2HakJUY/TCntDBDx+pedoy
SPjj1jPlEyRLfGa14w8hRBemUrsFFT808rGN3S9Xn4eZ5YTdHFP7reLFXJ8k2MD7
bhUvP45+NKy7QdzW+vzi
=ERFN
-----END PGP SIGNATURE-----

--=-qU9F2YOvAdcoXPhHjZ4z--

