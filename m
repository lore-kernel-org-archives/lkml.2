Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab2KFLbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:31:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42611 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2KFLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:31:06 -0500
Message-ID: <5098F4F0.8020907@ti.com>
Date: Tue, 6 Nov 2012 13:30:56 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: <FlorianSchandinat@gmx.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] OMAPDSS: DISPC: Fix the usage of wait_for_completion_timeout
References: <1352222317.15558.1584.camel@cliu38-desktop-build> <1352222480.15558.1587.camel@cliu38-desktop-build>
In-Reply-To: <1352222480.15558.1587.camel@cliu38-desktop-build>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig463E2FBB987A4F7AA9316E14"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig463E2FBB987A4F7AA9316E14
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012-11-06 19:21, Chuansheng Liu wrote:
>=20
> The return value of wait_for_completion_timeout() is always
>> =3D 0 with unsigned int type.
>=20
> So the condition "ret < 0" or "ret >=3D 0" is pointless.
>=20
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/video/omap2/dss/dispc.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/=
dispc.c
> index b43477a..9858869 100644
> --- a/drivers/video/omap2/dss/dispc.c
> +++ b/drivers/video/omap2/dss/dispc.c
> @@ -3893,9 +3893,6 @@ int omap_dispc_wait_for_irq_timeout(u32 irqmask, =
unsigned long timeout)
>  	if (timeout =3D=3D 0)
>  		return -ETIMEDOUT;
> =20
> -	if (timeout =3D=3D -ERESTARTSYS)
> -		return -ERESTARTSYS;
> -
>  	return 0;
>  }

Thanks. I'll apply this to omapdss tree to avoid any conflicts.

 Tomi




--------------enig463E2FBB987A4F7AA9316E14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQmPT1AAoJEPo9qoy8lh71WzYP/3DYvLJPQe+g4sOEzZTr4PU8
d/lpIXimJGLnXSB5q4PgKpzcHosZSv8PLT025CPqP6DeMvmWP3OUM5oU1/ekYfzM
DF9oxfwmGvP6IlZGRMtxK1VDOOQrReGtG9qoo8Na8K34jQW+VjordeO0OFSeYAQw
TE4kmhK1xdcoI3lTWG8eKQa1NX/e5R4AcJzQkY98Wx0BiZmM+jdfUtDEKbBF76NR
MrRMBNaR/UK0g8XkyCc5djKCe/G40OmiPAVh9scFDNDhNn2971BSUCnpsOg/178p
2BkKMERSFrHtrr/Lm7GsTOIOHmMdpMku33ec4DbcuzKtc4vTIYBw//mJ0u0Vtb7G
W89XBEa/vnxg+KlK7zhxHit15BDD/MHOUWPYyx8mtXXMb+mxng6uFRbEAlxMmdAD
vZ7n+EymqDN7tXOVjeDx7Z40HfoOSBiF7BWFekOLFpITD1QY8k7ZcQ0B9A3J18tl
myYpLeEGVWfIkmJrq5cTNXPLYNqxKSXCA2ez4CU6Up9zy2xWSCz2mQMcb8hRjZN2
wK4mb+ukK9VGZfxltR8uokbTUDY8X6Wg2ZtHmwNRFquIyfCrZX/mkVOsWiUBHEVl
+ubuvkDaw45s2NjpENru+FLcIGg+GbeTs3zF9uF9qygEOWa/Rmz6hPB+DCgea0Gf
p7uq3BZU99OvGlJURicw
=aXq0
-----END PGP SIGNATURE-----

--------------enig463E2FBB987A4F7AA9316E14--
