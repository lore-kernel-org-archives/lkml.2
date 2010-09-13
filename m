Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0IMD1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:27:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45645 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab0IMD1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:27:31 -0400
Date: Mon, 13 Sep 2010 13:27:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build warnings after merge of the final tree (tip treee
 related)
Message-Id: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Sep_2010_13_27_21_+1000_Yqw_V2bT.5qnRvRn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Sep_2010_13_27_21_+1000_Yqw_V2bT.5qnRvRn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the scsi-post-merge tree, today's linux-next build (powerpc
allnoconfig, i386 defconfig and others) produced these warnings (I build
with CONFIG_DEBUG_SECTION_MISMATCH=3Dy):

WARNING: mm/built-in.o(.text+0x25910): Section mismatch in reference from t=
he function memblock_find_in_range() to the function .init.text:memblock_fi=
nd_base()
The function memblock_find_in_range() references
the function __init memblock_find_base().
This is often because memblock_find_in_range lacks a __init=20
annotation or the annotation of memblock_find_base is wrong.

WARNING: mm/built-in.o(.text+0x25bfc): Section mismatch in reference from t=
he function memblock_double_array() to the function .init.text:memblock_fre=
e()
The function memblock_double_array() references
the function __init memblock_free().
This is often because memblock_double_array lacks a __init=20
annotation or the annotation of memblock_free is wrong.

WARNING: mm/built-in.o(.text+0x25c5c): Section mismatch in reference from t=
he function memblock_double_array() to the function .init.text:memblock_fin=
d_base()
The function memblock_double_array() references
the function __init memblock_find_base().
This is often because memblock_double_array lacks a __init=20
annotation or the annotation of memblock_find_base is wrong.

WARNING: mm/built-in.o(.text+0x26194): Section mismatch in reference from t=
he function memblock_reserve_reserved_regions() to the function .init.text:=
memblock_reserve()
The function memblock_reserve_reserved_regions() references
the function __init memblock_reserve().
This is often because memblock_reserve_reserved_regions lacks a __init=20
annotation or the annotation of memblock_reserve is wrong.

WARNING: mm/built-in.o(.text+0x2630c): Section mismatch in reference from t=
he function memblock_free_reserved_regions() to the function .init.text:mem=
block_free()
The function memblock_free_reserved_regions() references
the function __init memblock_free().
This is often because memblock_free_reserved_regions lacks a __init=20
annotation or the annotation of memblock_free is wrong.

WARNING: vmlinux.o(.text+0x10190): Section mismatch in reference from the f=
unction setup_initial_memory_limit() to the function .init.text:memblock_se=
t_current_limit()
The function setup_initial_memory_limit() references
the function __init memblock_set_current_limit().
This is often because setup_initial_memory_limit lacks a __init=20
annotation or the annotation of memblock_set_current_limit is wrong.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Sep_2010_13_27_21_+1000_Yqw_V2bT.5qnRvRn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjZoZAAoJEDMEi1NhKgbsOjkH/RnmET4cKNni/2VdIYsGTZft
VPgLjLYjntYCCkOFqhrBU8VB7UCTyXmSG18H7DkA8bzDeUD1ZnRzpO4sFNZMo4mN
hxPL9xo04TOs5waQDmPkOD1B5oc5luARt9iMWu4uRiMa8hghTHhuO8HLDY3da8bT
XDso6gaEaVGtdRQOfHIiswMjnxsOAUqXjxAE4ArEraOUhDrFVdGDVFNupmZEh0xQ
wMjLkcnX9uYcQGZhT5mFVVYoaGLPS/kNXPJAIcZyQTjbPAfO/UCV8lnqq6QEclih
Ar34c8LHy192jl07gNfRlnAWNDHBdgNjLHg32b1FBjT3zGW3B7XYWp/pCz544XY=
=8Of3
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Sep_2010_13_27_21_+1000_Yqw_V2bT.5qnRvRn--
