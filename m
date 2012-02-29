Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab2B2QIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:08:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37391 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2B2QIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:08:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.43.51.135 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330531826.3545.128.camel@sauron.fi.intel.com>
Subject: Re: [patch] Move CRC computation to separate function
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Wed, 29 Feb 2012 18:10:26 +0200
In-Reply-To: <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sITxPpcgRQ9Xzto0rYxK"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sITxPpcgRQ9Xzto0rYxK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-20 at 21:15 +0100, Joel Reardon wrote:
> This patch moves the computation of CRCs for data nodes from=20
> within ubifs_prepare_node to a separate function ubifs_set_datanode_crc,=
=20
> which takes a data node, and computes and sets the CRC. This is to avoid=
=20
> duplication of the CRC computation code in other places where it may be=
=20
> needed.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
> diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff=20
> linux-3.2.1-vanilla/fs/ubifs/io.c linux-3.2.1-ubifsec/fs/ubifs/io.c
> --- linux-3.2.1-vanilla/fs/ubifs/io.c   2012-01-12 20:42:45.000000000=20
> +0100
> +++ linux-3.2.1-ubifsec/fs/ubifs/io.c   2012-02-20 20:17:48.796684293=20
> +0100
> @@ -367,6 +367,18 @@ static unsigned long long next_sqnum(str
>   }

This patch is line-wrapped and cannot be applied. Would you please send
a non-wrapped version. You may experiment by sending to yourself, then
saving, and then applying using "git am".

>=20
>   /**
> + * ubifs_set_datanode_crc - writes the crc for a data node to the common
> + * header.
> + * @node: the data node
> + */
> +void ubifs_set_datanode_crc(void *node)
> +{
> +       struct ubifs_ch *ch =3D (struct ubifs_ch *) node;
> +       int len =3D le32_to_cpu(ch->len);
> +       ch->crc =3D cpu_to_le32(crc32(UBIFS_CRC32_INIT, node + 8, len - 8=
));
> +}

This changes is not needed unless there is other code which needs this
function. So once I get a non-wrapped patch I can create a branch for
you in the UBIFS tree and collect your patches. Once they are ready,
they can be merged.

--=20
Best Regards,
Artem Bityutskiy

--=-sITxPpcgRQ9Xzto0rYxK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTk3yAAoJECmIfjd9wqK0n6oP/R7Pn1CXx1QyTjsyZiO1JcHo
joWMErZwZ4+UB5lC0A/XZOfiG80Po0QpG0vEIOEw4q+ppA4DdccrqWZ1WwdE+a3I
ZYcpH/aFZuThjXAXfW6wsOXpMQZcD1KHwT92W1ajXn5NeQ07EiEL4Z3+XZNoTtqL
L9vaUfRyLZNXnTEtw0DaSn4VDMUpWrJwvGRzM6bzxPZ5LEbkycenTZ1T6nmTSRWd
RB41efS9ck9QViZZBve2LRzWFdqQKX8aCOpCnXArXA6y5Q6e/b5KMqdCutWt1IaJ
mskt4+U4hAo2qoksI9a37AG7ncEl1YZP+iMEA3wp7hfrS6c9UOpumkRC/hQdoPHj
WViJK9uh26dJ/yGshDB4a7x2nmHIJmmvJpo5rTGz36PP3MG3tjJ/nzJNxASvBX09
zmvln3gUu2ekMI7jyPwVpM6IPNRo7QGT0sYSkY009oWX2X2+IAD4MU6oL/id9O/G
2UHxcCYKbxuZsrNdub8qEcp7J9M0PDKeFOK+KOYgFJuRHdqf+1rFdCWQTCJQKjJo
ftKdS9RakR4KfpBtQ1mWyLGX6syqcfyHAa7zi80/hkHlvCZSj8YPYXFc3qxpaEb+
Q0wFVP0suR8lQrVoPLSRvn7YVy5jKB8BeBsDqkyrWI65o+It62qEsc1r89z7ptrD
oQI1Fymhrwb3uFgChBnY
=xntw
-----END PGP SIGNATURE-----

--=-sITxPpcgRQ9Xzto0rYxK--

