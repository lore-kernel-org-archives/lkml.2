Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2HNCE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:04:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44910 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329Ab2HNCE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:04:56 -0400
Message-ID: <1344909891.824.169.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 2/6] floppy: do put_disk on current dr if
 blk_init_queue fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 14 Aug 2012 03:04:51 +0100
In-Reply-To: <1344881787-6422-3-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
	 <1344881787-6422-3-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IgUzsYVzJrm5DSYRJlEF"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IgUzsYVzJrm5DSYRJlEF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> If blk_init_queue fails, we do not call put_disk on the current dr
> (dr is decremented first in the error handling loop).
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

> ---
>  drivers/block/floppy.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index c8d9e68..1e09e99 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4151,6 +4151,7 @@ static int __init do_floppy_init(void)
> =20
>  		disks[dr]->queue =3D blk_init_queue(do_fd_request, &floppy_lock);
>  		if (!disks[dr]->queue) {
> +			put_disk(disks[dr]);
>  			err =3D -ENOMEM;
>  			goto out_put_disk;
>  		}

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-IgUzsYVzJrm5DSYRJlEF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCmyQ+e/yOyVhhEJAQpLkw/9FKdnIHhQQ3qU8qtrBOxXZRZrK4gL9RMS
RY/gAWkdrIWCq3OBD14CMw8wWE1bSGz3NL3W6JF4Eae5/J3wofW+yecDBL60lnkD
CAKIjACvU2Y/wkOs2f70rcbVIWjfojOWyu7fHHxaJ9GMLhlG2QWlEwXT/ws77oaH
wm+MwVQsYUyxR1fopMnFT3kXyH049Ox0OhOe2AeA0Pc70CEgJzm+ZSDC+0+o0YTW
4WpXfGhe2l+8+Y++38IN5XnX2GdNIzPAL5hHKUJmi6OmXmDMg7V0VzuSeTTyxDXw
mZxWrYhAiO2pLUfRDgurhqXsPGt23c/y72+6vj7/eU2DxmsEGhQukgSQeC2D6qCn
iot2El9m240UtvoQvO9BBKRkpvvvTn9AXDAPIIefdw1xbrRFEMzVszyqKc2tEhQo
vTdzzOGxU+tQwlpuBVSLvnap9HT/PYDT1yZSvjj6nQ1OalFE7r2TLHy05zSI/1zc
o1I8nVEQDLWgGtyZC/xzbyNJkUgYKd1njbbanZ2N1Ks0onu2/bfjGuyPBnzITdIQ
sZGvqJxsUvN+8z8CRzdCoRFxp6T7OrsRH1G3XVK4X6E2hgr1ZRwjvK+84XkcVvV6
aaK+QThRX22TWYUJC00NfaV9BDQeCtTpd5qSnaOan7cYSdelYgvjT6TigkbhlUTv
reQbmDI59XM=
=J0iN
-----END PGP SIGNATURE-----

--=-IgUzsYVzJrm5DSYRJlEF--
