Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2EULh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:37:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:19755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2EULh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="155132853"
Message-ID: <1337600494.2483.67.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V4] UBI: modify ubi_wl_flush function to clear work
 queue for a lnum
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 14:41:34 +0300
In-Reply-To: <alpine.DEB.2.00.1205202126480.29205@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150943470.17750@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1205201309390.26953@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1205202126480.29205@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-olgWcxlo9jjiKPsq6Gsp"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-olgWcxlo9jjiKPsq6Gsp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-20 at 21:27 +0200, Joel Reardon wrote:
> This patch modifies ubi_wl_flush to force the erasure of
> particular volume id / logical eraseblock number pairs. Previous function=
ality
> is preserved when passing UBI_UNKNOWN for both values. The locations wher=
e ubi_wl_flush
> were called are appropriately changed: ubi_leb_erase only flushes for the
> erased LEB, and ubi_create_volume forces only flushing for its volume id.
> External code can call this new feature via the new function ubi_flush() =
added
> to kapi.c, which simply passes through to ubi_wl_flush().
>=20
> This was tested by disabling the call to do_work in ubi thread, which res=
ults
> in the work queue remaining unless explicitly called to remove. UBIFS was
> changed to call ubifs_leb_change 50 times for four different LEBs. Then t=
he
> new function was called to clear the queue: passing wrong volume ids / ln=
um,
> correct ones, and finally UBI_UNKNOWN for both to ensure it was finally a=
ll
> cleard. The work queue was dumped each time and the selective removal
> of the particular LEB numbers was observed. Extra checks were enabled and
> ubifs's integck was also run. Finally, the drive was repeatedly filled an=
d emptied to
> ensure that the queue was cleared normally.

I've amended this patch to use UBI_ALL instead, and pushed to
linux-ubi.git tree, and in your branch as well. I'll send it to Linus
this merge window as well. Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-olgWcxlo9jjiKPsq6Gsp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPuinuAAoJECmIfjd9wqK0/Z8P/2uxoRjDwwz6OHS/9o6kxgpR
HnZ/j15nH3l565gRFeAJ+Sy1WXKz6Zw0DcBvOTiHb4W3NgjkMvSTKwLSF5Rl7hdX
Xciome670oDClEUm9Wti9LRQE8AEy7HFKMp4IvmSGaoLsZl7zFRO4p6kOj97SKIJ
f2bqgZrkw5S20ZI7MCBr21W1dSKVtKRkGzSfDCr57eYgwdco78KaBi7Dm3Le1Uru
1GU5h5scJlt2ub75W2MAUuMtT5fOwexQ2wqRlLgm2xWfx2iMOU4ZLg6ofrdb6R2k
JYhkiOSn8l8yuqUuScGKnHq8479tfC1lXBNCJxZXXgdT3O+2dM8kWpeZkoEuGGuR
a3ZrKDqNuO4TgmQQ0sVOKiJ0Ux80Ruy1fo7padaz91CamHemFMbFxbz2FawVb0Ge
/pJFcubjJUKRF9KCc3hn7eclYkR4U1LSd66S1IsmKUEAjM8eS6UbrnpYFogp9XR8
D6s5OF3NMDIitS1bYGIPBkTPNYrRX/gebCPaHuhdOcgE2HDkjCNd8TSHJhh7H0sG
wSvFH3qJDu98AqTBSqqvxmlHP+/54JAWub4EXUeX3S3Zw8dDlBnKZlUNAbI56Q1l
z5RvbMY/5gXGYKz5xUbeESxzKOMkqjRrNzDcWD7HNCk/t4ovjUgXwj5NK+vKxh8g
o8bcU5gEgTfQuZgSQ91U
=SvPg
-----END PGP SIGNATURE-----

--=-olgWcxlo9jjiKPsq6Gsp--

