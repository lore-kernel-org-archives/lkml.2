Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623Ab1LQBFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 20:05:53 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55799 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1LQBFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 20:05:45 -0500
Date: Sat, 17 Dec 2011 12:05:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] genalloc: add support of named pool
Message-Id: <20111217120526.29aa2b0b35a70c8038727300@canb.auug.org.au>
In-Reply-To: <1323359408-24407-1-git-send-email-plagnioj@jcrosoft.com>
References: <1323359408-24407-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Dec_2011_12_05_26_+1100_I=pBjSSIqBaHsrJS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Dec_2011_12_05_26_+1100_I=pBjSSIqBaHsrJS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu,  8 Dec 2011 16:50:08 +0100 Jean-Christophe PLAGNIOL-VILLARD <plagni=
oj@jcrosoft.com> wrote:
>
>  struct gen_pool {
> +	char *name;			/* pool name */

Any reason that this can't be "const char *"?

> +extern struct gen_pool *gen_pool_create_byname(char*, int, int);

const char *

> +extern struct gen_pool* gen_pool_byname(char *name);


const char *

> +/**
>   * gen_pool_create - create a new special memory pool

gen_pool_create_byname

> +struct gen_pool *gen_pool_create_byname(char *name, int min_alloc_order,=
 int nid)

const char *

>  {
>  	struct gen_pool *pool;
> =20
> +	if (gen_pool_byname(name))
> +		return NULL;
> +
>  	pool =3D kmalloc_node(sizeof(struct gen_pool), GFP_KERNEL, nid);
>  	if (pool !=3D NULL) {
>  		spin_lock_init(&pool->lock);
>  		INIT_LIST_HEAD(&pool->chunks);
>  		pool->min_alloc_order =3D min_alloc_order;
>  	}
> +
> +	list_add_tail(&pool->list, &pools);
>  	return pool;
>  }

I don't see where you assign pool->name to anything ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Dec_2011_12_05_26_+1100_I=pBjSSIqBaHsrJS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6+rWAAoJEECxmPOUX5FEhOsP/2/QZrKseJK+wxENZMfJj2Rc
jfebwFNdA9pcdL0MXRRLdxNexvgeXq29fK/yHLxTwGOQeOlB/DgQ/1aG4+78ZDdC
p281+dZOpVh+XE/RzjB6+dM3IloNGBgNPH/vqVRAbGEKG7OyKQImSoN8LSRyxIpN
W2reZCpPR4DUQgOWG2zq0LALx9yCydrYGzWFpRvLbo/uhpaZNCwoNramrqC50pLW
gsAfPO0fE/vByobAQ/lFbyl+lZtg7IikHgW/hxNUhalZf4/IHF93GP+mdTGRymjE
sShgx/RjtelmPYUk0br39bZ3eJ/YKOReCv7MKZ7B6u96ev/6R/65ube5gn1ZUkEW
vtOSx1jVXnxIglwTpLNyQGqqcxyNavIFxiEGXaD0pXU4Lj/q8SiT93/5/423NmBO
YP6hXnOj99fUK/SmC9OyhAezK5GQpPPZh1CcoyDh/xOCf/novquAnRCaYBjr/KpB
XRm9NY+U2kLU0u/BZUUVavDBpr3po5i19AYFoaXy1t6iHrOfq68mDGEn9QQ5OwT7
59FbfH60nbhm8EBf56OZ5GakHNEemBEoX/GURPhtGOGujyMa+S3sFf7aW8r0MIVn
aaLtt+UX+3dYpgdPbMBTzsa/zaIa2Hm2p88SgAfaluSMUD00LAiKLpx6iiKymfnH
cXYnLgg5U1owAdXJH5Xm
=UtQk
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Dec_2011_12_05_26_+1100_I=pBjSSIqBaHsrJS--
