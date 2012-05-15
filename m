Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2EOLoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:44:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:13863 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451Ab2EOLoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:44:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="166514736"
Message-ID: <1337082481.2528.186.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] UBI: add lnum to struct ubi_work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 14:48:01 +0300
In-Reply-To: <alpine.DEB.2.00.1205142046080.12448@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205142046080.12448@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hGuWCr+NyIv9tv5mSl83"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hGuWCr+NyIv9tv5mSl83
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-14 at 20:47 +0200, Joel Reardon wrote:
> This is part of a multipart patch to allow UBI to force the erasure of
> particular logical eraseblock numbers. In this patch, the logical erase b=
lock
> number is added to ubi_work data structure, and it is also passed as a
> parameter to schedule erase to set it appropriately. Whenever ubi_wl_put_=
peb
> is called, the lnum is also passed to be forwarded to schedule erase. Lat=
er,
> a new ubi_sync_lnum will be added to execute immediately all work related=
 to
> that lnum.

Hmm, I've just checked your patch with Aiaiai and it complains about
your changes - and the complaints are correct - you introduce a bug.

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/ubi/wl.c:1023 erase_worker() error: dereferencing freed memory=
 'wl_wrk' [smatch]
+drivers/mtd/ubi/wl.c:1023:35-41: ERROR: reference preceded by free on line=
 1016 [coccinelle]

--=20
Best Regards,
Artem Bityutskiy

--=-hGuWCr+NyIv9tv5mSl83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPskJxAAoJECmIfjd9wqK0nbgQALNc7iOZ91BwMzMRMj9ygmFI
/g89oodxCUf+Xc0V57KOy+ZZqiRkC0MRLpLzWf9cr5uUJC9Czk2c+/A4syq9Kv0H
MdT9IEyZwhqDrApqhEUDftrzqxNvGtTNA8+jnAnP+62RZA1tij891Y49SUGXvxah
WAblbiIapcmDTjP+F8gYBNL4YDZOCb5YHOmC2vUZOxCtAqUuaB8w4gtKOmys/CDv
qZfV/a4kvlfwrY/4Evhb2mXXZ6TDawlY0bDdlaZWJLXM1z59UrKlE4UJ2GcWG6SB
3ajmnRM4cfzrWqGCHGtRt2WfzZc5slcluEf28l46wqvCqLuTzUPcTwSzT/xwaAI5
hgaSKS5kV5MO++jr0zvSMLmHUKF9jxecBkM39icNQwRuG+xKCq05YfVrbQgfU1/H
ou/CIX4OziBeE6cofFzpciL0J7bGPAcxirAsREzp+S85DmNGT+OVnsfXbXf9Tk1w
Bu0fAOvguhcX5MFcEPphebsn0TGT4mIfVeGvR3tkq3/nUplFJgvksaOdfFbbmFQd
9qrkJgpg6x/32FjYIdrYsGntqEWH/kkliIHF9cUKNK74x6VEjoIyL1pKYR0WGmr/
XFU/bVueffCuCbk2qofBD5y6jNXXA7yn3WeKMvYqmBacYEHEMR6wR1hnPpU/ODGh
vDtNg2qjFlbKDQ1DH0lN
=mY1p
-----END PGP SIGNATURE-----

--=-hGuWCr+NyIv9tv5mSl83--

