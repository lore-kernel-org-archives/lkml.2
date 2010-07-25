Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0GYDei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 23:34:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34891 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0GYDeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 23:34:36 -0400
Date: Sun, 25 Jul 2010 13:34:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/device: Make of_device_make_bus_id() usable by other
 code.
Message-Id: <20100725133430.4c1d38a3.sfr@canb.auug.org.au>
In-Reply-To: <20100724160111.7072.68144.stgit@angua>
References: <20100724160111.7072.68144.stgit@angua>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__25_Jul_2010_13_34_30_+1000_nXz58B.vnmxVYCYw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__25_Jul_2010_13_34_30_+1000_nXz58B.vnmxVYCYw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Sat, 24 Jul 2010 10:01:11 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
> index e11a0be..249bc11 100644
> --- a/include/linux/of_device.h
> +++ b/include/linux/of_device.h
> @@ -27,6 +27,9 @@
> =20
>  extern const struct of_device_id *of_match_device(
>  	const struct of_device_id *matches, const struct device *dev);
> +#if !defined(CONFIG_SPARC)
> +extern void of_device_make_bus_id(struct device *dev);
> +#endif

You don't really need the protection here - it does not clash with
anything on SPARC, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__25_Jul_2010_13_34_30_+1000_nXz58B.vnmxVYCYw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMS7DGAAoJEDMEi1NhKgbs5VMH/RerPDpTw5xiodVs8cJl3aiP
X4Nwxd2naa0Xh6ZXlbSVhRNo8zvR+N6CMFEaEOrR2aWOgvWidRwkhlZ61kugDIl2
lbhEGmmtopBQe9M06p2Lr50HaJy3kLTQ6H2ZwGC7J8GwheKPEyG5RdZRQzY1oRb3
zFdYDhyXgX6UcPE7S4OMNuD96Z5dvXJKlXnKgukz91TwwbhmJGKZLZIpLuY5K1eJ
0dL8HzRWD59PEbs0d92Z1ozVKYdAXrrK+8xWcQXDbBlFi8e+gOeyRjIFK+N6+PZa
l3SKQwpZOFauypOomiy4hB0g3bwGoHYpuD4x80MMEAKq/P0u9KzsS4j2xkAJ1Pg=
=z+b/
-----END PGP SIGNATURE-----

--Signature=_Sun__25_Jul_2010_13_34_30_+1000_nXz58B.vnmxVYCYw--
