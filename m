Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0HBEKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:10:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0HBEKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:10:42 -0400
Date: Mon, 2 Aug 2010 14:10:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build warnings after merge of the final tree
Message-Id: <20100802141035.f84f9132.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_14_10_35_+1000_I=XGqEgkTrk.17vY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_14_10_35_+1000_I=XGqEgkTrk.17vY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig with CONFIG_DEBUG_SECTION_MISMATCH=3Dy) produced these warnings:

WARNING: mm/built-in.o(.text+0x24324): Section mismatch in reference from t=
he function memblock_find_in_range() to the function .init.text:memblock_fi=
nd_base()
The function memblock_find_in_range() references
the function __init memblock_find_base().
This is often because memblock_find_in_range lacks a __init=20
annotation or the annotation of memblock_find_base is wrong.

WARNING: mm/built-in.o(.text+0x24610): Section mismatch in reference from t=
he function memblock_double_array() to the function .init.text:memblock_fre=
e()
The function memblock_double_array() references
the function __init memblock_free().
This is often because memblock_double_array lacks a __init=20
annotation or the annotation of memblock_free is wrong.

WARNING: mm/built-in.o(.text+0x24670): Section mismatch in reference from t=
he function memblock_double_array() to the function .init.text:memblock_fin=
d_base()
The function memblock_double_array() references
the function __init memblock_find_base().
This is often because memblock_double_array lacks a __init=20
annotation or the annotation of memblock_find_base is wrong.

WARNING: vmlinux.o(.text+0x10264): Section mismatch in reference from the f=
unction setup_initial_memory_limit() to the function .init.text:memblock_se=
t_current_limit()
The function setup_initial_memory_limit() references
the function __init memblock_set_current_limit().
This is often because setup_initial_memory_limit lacks a __init=20
annotation or the annotation of memblock_set_current_limit is wrong.

Introduced by the memblock series in the tip tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_14_10_35_+1000_I=XGqEgkTrk.17vY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVkU7AAoJEDMEi1NhKgbsr5sIAJOQEL/NTEoJCq0Qdo5PnusC
7+/Vz1APem8ZdiTeUxn6XeELN4y91dPK4g5kbILBh9NaS5o6B978M1pWvBCeuyjj
hbAm07lq3ZtXR6S0JMlQXJ8p4DnMnDcwziniPBou8RH5aRJSJRvzWvQ/eFzQsx00
eqCKAW3b8VJOPKR8OPODrrMve9ExPXvHviBia31QZMH/kRuHTTRCd6q7+LsXJ0lq
iH5WMJakmh1RI9ZaLkybSfOBb2k5Lb/KKYahh8ncfzlp9g+4NvjzANZbE0vbPcBe
zlHZkG2QvaKvQtRKGIdD9Vpm9iEMEAZsMV4RDWf6lnR6yooFv2y2SN/Mjbb8Sps=
=+ZjI
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_14_10_35_+1000_I=XGqEgkTrk.17vY--
