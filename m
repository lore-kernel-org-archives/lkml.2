Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0G1DnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:43:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0G1DnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:43:04 -0400
Date: Wed, 28 Jul 2010 13:42:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: hpa@linux.intel.com
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [tip:x86/build] x86, vdso: Error out if the vdso contains
 external references
Message-Id: <20100728134252.2e4c27cf.sfr@canb.auug.org.au>
In-Reply-To: <tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org>
References: <tip-*@vger.kernel.org>
	<tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_13_42_52_+1000_hT=ruXfas0NS_LZy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_13_42_52_+1000_hT=ruXfas0NS_LZy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 18 Jun 2010 22:16:05 GMT "tip-bot for H. Peter Anvin" <hpa@linux.in=
tel.com> wrote:
>
> diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
> new file mode 100755
> index 0000000..490be1c
> --- /dev/null
> +++ b/arch/x86/vdso/checkundef.sh
> @@ -0,0 +1,10 @@
> +#!/bin/sh
> +nm=3D"$1"
> +file=3D"$2"
> +"$nm" "$file" | grep '^ *U' > /dev/null 2>&1

Quoting $nm here doesn't work if you are building with ccache like this:

make CROSS_COMPILE=3D"ccache ...."
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_13_42_52_+1000_hT=ruXfas0NS_LZy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT6c8AAoJEDMEi1NhKgbsbM0IAIsjBwAkBhBKGsYjdyS3Qwgz
BK1dprgZCvMfGo/xiQrwfVWnh6h2q769eROIoaqs25qUcZRlArqftMdecL1GeGO4
+1tpoey+gcTee+7C+ia8GnnZiAZ1T+HiRV3DmpP70nGaHXTpV5EBW6j40L8RNVMU
vX4GJsycLxDdx039fa2iU2KsxpEwymYw/vzTc8J6Pctw00KYpcaleOZXmCs2bgy0
J8DnD3oVeWRMyd244X01tgn+jm76E0zQs0JfUxpriPf6j2OhCUD16w2hM8GlIKMn
6+avIwU0F9zjztOz5Dgm70Tq/ZqDlq6xRHCZUAz5hew/ij4ARyHlHGlmO0VF12A=
=oU2y
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_13_42_52_+1000_hT=ruXfas0NS_LZy--
