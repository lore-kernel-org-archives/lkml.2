Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0INEue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:50:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34685 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab0INEud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:50:33 -0400
Date: Tue, 14 Sep 2010 14:50:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warnings after merge of the final tree (tip
 treee related)
Message-Id: <20100914145025.977ec2a6.sfr@canb.auug.org.au>
In-Reply-To: <4C8DDFB4.1020508@kernel.org>
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>
	<4C8DA517.9000603@kernel.org>
	<20100913143942.7344ada4.sfr@canb.auug.org.au>
	<4C8DDFB4.1020508@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_14_50_25_+1000_uL/CVplq9TRXS./6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_14_50_25_+1000_uL/CVplq9TRXS./6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yinghai,

On Mon, 13 Sep 2010 01:24:20 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
>
> On 09/12/2010 09:39 PM, Stephen Rothwell wrote:
> >=20
> > Your patch fixes some of the warnings, but still leaves these for a
> > powerpc allnoconfig build:
> >=20
> > WARNING: mm/built-in.o(.text+0x25d80): Section mismatch in reference fr=
om the function memblock_double_array() to the function .init.text:memblock=
_free()
> > The function memblock_double_array() references
> > the function __init memblock_free().
> > This is often because memblock_double_array lacks a __init=20
> > annotation or the annotation of memblock_free is wrong.
> >=20
> > WARNING: mm/built-in.o(.text+0x26318): Section mismatch in reference fr=
om the function memblock_reserve_reserved_regions() to the function .init.t=
ext:memblock_reserve()
> > The function memblock_reserve_reserved_regions() references
> > the function __init memblock_reserve().
> > This is often because memblock_reserve_reserved_regions lacks a __init=
=20
> > annotation or the annotation of memblock_reserve is wrong.
> >=20
> > WARNING: mm/built-in.o(.text+0x26490): Section mismatch in reference fr=
om the function memblock_free_reserved_regions() to the function .init.text=
:memblock_free()
> > The function memblock_free_reserved_regions() references
> > the function __init memblock_free().
> > This is often because memblock_free_reserved_regions lacks a __init=20
> > annotation or the annotation of memblock_free is wrong.
>=20
> v1 already changed them all to __init_memblock, so we should not have tho=
se warnings.

They are still marked as __init in include/linux/memblock.h.  I don't
think that they need to be marked at all there.

> > And these for a i386 defconfig build:
> >=20
> > WARNING: mm/built-in.o(.text+0x1e261): Section mismatch in reference fr=
om the function memblock_is_memory() to the variable .init.data:memblock
> > The function memblock_is_memory() references
> > the variable __initdata memblock.
> > This is often because memblock_is_memory lacks a __initdata=20
> > annotation or the annotation of memblock is wrong.
> >=20
> > WARNING: mm/built-in.o(.text+0x1e27f): Section mismatch in reference fr=
om the function memblock_is_region_memory() to the variable .init.data:memb=
lock
> > The function memblock_is_region_memory() references
> > the variable __initdata memblock.
> > This is often because memblock_is_region_memory lacks a __initdata=20
> > annotation or the annotation of memblock is wrong.
>=20
> you must have old gcc, those functions are not used with i386.

I am not sure what the compiler version has to do with it, but I am using
gcc 4.4.4 which is fairly recent.  The X86 Kconfig selects HAVE_MEMBLOCK
unconditionally, so mm/memblock.c is built on i386.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_14_50_25_+1000_uL/CVplq9TRXS./6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjv8RAAoJEDMEi1NhKgbsw5QH/25XOrKNFybBSAnq4AwtfEvr
ndAUSv2zF8PSzoObfNSpubddyZrkWaSxJPoFy6srXU2jkuhJRVS/JsXd5ZBkwZ7S
K3R/OTK6+JuFk/6utGN7ua564Z0XSdgz6VMgR/dlG9DB95lsbLg/wjrQ9heeGr+l
s7bvJsqb/1pOQLMCWvKfItwKYm6o6P/SY16k0a47ktcU7OipNrUPWysCm3bpmGUE
syY7fZS1H4+68wi5zT/IqAgMhzzUqZd05a+n4b9KlgQeYpHKdt/zoyPDHiDyPdHv
j4ny2nZl40zKdk3cBvKYVQdtnDn1pRtCxf23GmtPHd8+1473njIpx/XmHch0GcA=
=EcLo
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_14_50_25_+1000_uL/CVplq9TRXS./6--
