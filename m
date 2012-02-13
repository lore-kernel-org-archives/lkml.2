Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab2BMTnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:43:15 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32658 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2BMTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:43:14 -0500
Date: Mon, 13 Feb 2012 22:44:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christoph Lameter <cl@linux.com>
Cc: Xi Wang <xi.wang@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Message-ID: <20120213194446.GD26353@mwanda>
References: <20120208142513.4db2493a.akpm@linux-foundation.org>
 <4F33BF05.208@gmail.com>
 <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
 <4F33C7D7.1060801@kernel.dk>
 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
 <4F33CEAE.60400@gmail.com>
 <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org>
 <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
 <alpine.DEB.2.00.1202130958470.23562@router.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AjmyJqqohANyBN/e"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202130958470.23562@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F3967C1.00E1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2012 at 10:01:42AM -0600, Christoph Lameter wrote:
> Well I think the best is just not do any of this. One can already do
> k[zm]alloc(x * sizeof(struct whatever)). Do x*x for 2 dimensions etc etc.
> No need to change the API.
>=20

The point was that there are a bunch of places where we have had
integer overflows caused by doing kmalloc(x * sizeof(struct whatever)).
For kzalloc(x * sizeof(struct whatever)), you just write it like
kcalloc(x, sizeof(struct whatever)) and avoid the overflow, but we
don't have a non-zeroing version of kcalloc() to do that.

Probably once we have the kmalloc_array() and people start using it,
we get a bunch of overflow checking automatically and it's a kernel
hardenning thing.  As well we could remove the duplicative checking
so it's a cleanup.

> If you add these variants then please think
> about the necessity to add other variants (like the kmalloc_node() NUMA
> call) etc in the future.
>=20

We don't have a kcalloc_node(), so I don't think this is likely to
be a big issue.

regards,
dan carpenter

--AjmyJqqohANyBN/e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOWguAAoJEOnZkXI/YHqRyx8P/1ze6Oc8AWUJYBwS82KdtStO
QWCXapv6zyPEITYpzegBXLjZbiE2SA+sv1Ue/n3M5lUMkf/TwvmkBWl6UReksL6z
3SRML3UN5bTioC1+ov3FBz5+YDJgu62bMecgXH8OboaQk6dtv2nc8df8y9jFUge8
AL8tdtaSeEqBU2uPvNYuIo2+89AvbLlsSGwulJVOguiS0hylDQ4iFBMLStnITi1T
6tpklzxLhNAIqpEpg3uKlHCDSjigwqYfApqqWw3FkMpuObyJW0P6tBP+g49OQ4G/
EjbFBrF2C0uCXrvq23xiTNxWwPMZ7DORJ9UKsJW4rwTqL1HykoHUgtV/YxD5r1wE
zDKlMSjhnyOmY62RD259b38BwAqOwozNMB1UB/36/itcr3ie0b2nf0mvh4K9zcOy
+jKQFiof4rV6C5lbm83UAT9kLdPA2WYq50M5zUjNSDphGmRt98mxa7Vx4oUh+mJo
P84YB4+m9MOhUTaekbCnqPemlk37JCW34TDWX7wJGUNfDFknHWavsmOgnNP52TCX
zJaf9mYJCcQzLxcjqww4II2QnnlZv3SApFVpTOQ0TwEbI6vNEfGQdI0wQE18gq/N
FPXkoRJMHUgI+E61bh0AvOjSLDzRHJzZz+DcknoEla7DcYwf3y6sHvzZIDpPfJLw
mZ9QV6o5QoYB0R/M+v4C
=0lnz
-----END PGP SIGNATURE-----

--AjmyJqqohANyBN/e--
