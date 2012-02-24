Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2BXFa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:30:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46663 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2BXFa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:30:57 -0500
Date: Fri, 24 Feb 2012 16:30:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: manual merge of the irqdomain tree with the powerpc
 tree
Message-Id: <20120224163042.4cc2633945c9799b997ff4e7@canb.auug.org.au>
In-Reply-To: <20120224162504.49480de981431c3fd95601a2@canb.auug.org.au>
References: <20120224162504.49480de981431c3fd95601a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Feb_2012_16_30_42_+1100_rry5wsoH8ZSGPnTX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Feb_2012_16_30_42_+1100_rry5wsoH8ZSGPnTX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just adding the PPC guys]

On Fri, 24 Feb 2012 16:25:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Grant,
>=20
> Today's linux-next merge of the irqdomain tree got a conflict in
> arch/powerpc/sysdev/mpic.c between commits 3a7a7176e840 ("powerpc/mpic:
> Fix use of "flags" variable in mpic_alloc()") and c1b8d45db4db
> ("powerpc/mpic: Add "last-interrupt-source" property to override
> hardware") from the powerpc tree and commit a8db8cf0d894 ("irq_domain:
> Replace irq_alloc_host() with revmap-specific initializers") from the
> irqdomain tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary.
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/powerpc/sysdev/mpic.c
> index b9b989d,c83a512..0000000
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@@ -1351,9 -1345,9 +1351,8 @@@ struct mpic * __init mpic_alloc(struct=20
>   	mpic->isu_shift =3D 1 + __ilog2(mpic->isu_size - 1);
>   	mpic->isu_mask =3D (1 << mpic->isu_shift) - 1;
>  =20
> - 	mpic->irqhost =3D irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
> - 				       mpic->isu_size, &mpic_host_ops,
> - 				       intvec_top + 1);
> + 	mpic->irqhost =3D irq_domain_add_linear(mpic->node,
>  -				       isu_size ? isu_size : mpic->num_sources,
>  -				       &mpic_host_ops, mpic);
> ++				       mpic->isu_size, &mpic_host_ops, mpic);
>  =20
>   	/*
>   	 * FIXME: The code leaks the MPIC object and mappings here; this

--Signature=_Fri__24_Feb_2012_16_30_42_+1100_rry5wsoH8ZSGPnTX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRyCCAAoJEECxmPOUX5FEtHAP/iUKG3bxrEgZBOX26nxQFsKH
44vzuO6jahrDV9c4cwKaCXrFxzt2Qj8fXaqDFvfVNaEGZsxmE+rr7rE4DUpky0r/
278qQiSTj3r0VB8HG+lnxNL8mf+Ml1wcs1avefwY/Oxdrm8Gpc+BZBnyFmrG3y/l
/PWuTs3Z7w0cdDh6a9Ljr1L8sl73/cab4cc3WHK9M2HKdPihsj1h50K4BSMpObBV
p3AP6NHFfVI0E1DGmAwtWkOPgYoqSm7KsorcLTVkh5xtn5onVrnTsILRcjRNXM3C
2PdqkCuPtavPSRyCXVUO8kUGvdna7mwJE/5krvfqFY4gPsMm7ZPKrooyz5ZRTZ6j
bEmM4LCYBDUIoaMo+5od4cXIMDYSxu1GgmRtmHYc6seSUYwktQPMKRPrAvzZcXlD
Yfo5rEvZUWpDGLcQ11RwBL5atLAa9LtPmHICr9Ftkaz4qVcVil6s4tUwntBJWEHo
xo0SAr84FytUU96d01Fdqbmw+vNkbpvVk9zbVzGTxkRO4r3KELmOH00TQJDy7mM2
oy2+6d8NMLkItKimvNbHdhyRWcbzG2Je72kilwkTDE9g17ZxJA1hv13mcWkJzLiY
tkPWpLGnvTQf/nOjS/NbIMlJH3RbCnWgLLeaEZAUGVmdaYOvVb+bcqqWKOnVH6fT
acaC0KILN9PpLb7Q+0mN
=KWLG
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Feb_2012_16_30_42_+1100_rry5wsoH8ZSGPnTX--
