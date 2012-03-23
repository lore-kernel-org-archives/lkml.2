Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2CWOHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:07:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:29343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab2CWOHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="120901555"
Message-ID: <1332511796.18717.72.camel@sauron.fi.intel.com>
Subject: Re: [patch] Move CRC computation to separate function
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Fri, 23 Mar 2012 16:09:56 +0200
In-Reply-To: <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	  <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
	 <1330531826.3545.128.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kw5F36rQQiw9GF+qjPv+"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kw5F36rQQiw9GF+qjPv+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-19 at 23:46 +0100, Joel Reardon wrote:
>  /**
> + * ubifs_set_datanode_crc - writes the crc for a data node to the common
> + * header.
> + * @node: the data node
> + */
> +void ubifs_set_datanode_crc(void *node)
> +{
> +	struct ubifs_ch *ch =3D (struct ubifs_ch *) node;
> +	int len =3D le32_to_cpu(ch->len);
> +	ch->crc =3D cpu_to_le32(crc32(UBIFS_CRC32_INIT, node + 8, len - 8));
> +}

Will this be used by other code, outside of io.c? Because currently
there is only one user in the same file, which does not justify
introducing it and making non-static. If answers are "yes", then it is
better to make it static inline and put to misc.h instead, because it is
very small.

>  void ubifs_prepare_node(struct ubifs_info *c, void *node, int len, int p=
ad)
>  {
> -	uint32_t crc;
>  	struct ubifs_ch *ch =3D node;
>  	unsigned long long sqnum =3D next_sqnum(c);
>=20
> @@ -390,8 +401,7 @@ void ubifs_prepare_node(struct ubifs_info *c, void *n=
ode, int len, int pad)
>  	ch->group_type =3D UBIFS_NO_NODE_GROUP;
>  	ch->sqnum =3D cpu_to_le64(sqnum);
>  	ch->padding[0] =3D ch->padding[1] =3D 0;
> -	crc =3D crc32(UBIFS_CRC32_INIT, node + 8, len - 8);
> -	ch->crc =3D cpu_to_le32(crc);
> +	ubifs_set_datanode_crc(node);

But ubifs_prepare_node() is generic and works for any node type, not
just data nodes, which means that using 'datanode' in the name is not a
good idea.

--=20
Best Regards,
Artem Bityutskiy

--=-kw5F36rQQiw9GF+qjPv+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPbIQ0AAoJECmIfjd9wqK0NTMP/jRWltCaEzocqgb78yuh/kSl
H1kk3Rky6SJUDM36pngTkMdy0x+373nIJqTlQbXi21OeJ+aVNnSw4sdIf029v6U3
TgNUx8EBkpZRHu3vVQhSJyQQ03E81ZnYcaHCIAnoOk4Kb0bMW1H3yMez+ZZaE5Ax
hMPi7f+i6ZYG/GQ+D0wJQv2tO9AV+OMeltI3nVkRtWHYOFxQ/bkvf1tgMDtt8DWY
3n55aNc8u470/HqMHlhdY2LLetml840IqcWrawbRxCem8X63NgsU4uGA67+cNDZR
GM+7cprcxjeHFyvbLmg4ZfVTjQjaqZ3FEcKzoyHgx7B9sPygEabdUoct09M2XAQO
VhZFGlVrcJRPQ/33Be5WzlAg6JLKACpI7bsFbCYruL5OXO6AC2o62u2DHqAA6fzD
MN+Wr00gPBZDZsCQH/gjdisZBkgRXUY+OQeKWLIHmPTHGRo43R3qBAbwbDC0jt/x
dSKPtCA8LUvjwG6tZ45X/t84Xm4IXmqN/5ATud7IZh0A4gjWBQeiblianlJGRS9F
y4pyffDvkOdgTJvMopll3bnqXAxeO59S8nbJfPqq1btaAStysBDQwSFNI+jRaMJe
JCkg4g2f+qj3qbqqNY4ic3Wu4YaAScfDPVmcEQOkTPlTkY/VKfk+XKDt23Gk+NpN
7M8BobzuMHw4w/FlG3J/
=PC7Y
-----END PGP SIGNATURE-----

--=-kw5F36rQQiw9GF+qjPv+--

