Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2BGOZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:25:25 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:51596 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab2BGOZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:25:24 -0500
Date: Tue, 7 Feb 2012 09:25:21 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, imunsie@au1.ibm.com,
        eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
Message-ID: <20120207142521.GA5840@mgebm.net>
References: <20120207145535.71b9f22d@kryten>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20120207145535.71b9f22d@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Feb 2012, Anton Blanchard wrote:

>=20
> A perf annotate of a kernel function written in assembly shows
> very strange percentages:
>=20
>          :      _GLOBAL(__copy_tofrom_user_base)
>=20
> ...
>=20
>          :              addi    r3,r3,1
>    99.67 :      c00000000004d78c:       addi    r3,r3,1
>          :
>     0.00 :      1:      bf      cr7*4+2,2f
>     0.07 :      c00000000004d790:       bne-    cr7,c00000000004d7a4
>          :      err1;   lhz     r0,0(r4)
>     0.00 :      c00000000004d794:       lhz     r0,0(r4)
>          :              addi    r4,r4,2
>     0.00 :      c00000000004d798:       addi    r4,r4,2
>          :      err1;   sth     r0,0(r3)
>     0.00 :      c00000000004d79c:       sth     r0,0(r3)
>          :              addi    r3,r3,2
>    99.60 :      c00000000004d7a0:       addi    r3,r3,2
>          :
>     0.00 :      2:      bf      cr7*4+1,3f
>     0.12 :      c00000000004d7a4:       ble-    cr7,c00000000004d7b8
>          :      err1;   lwz     r0,0(r4)
>     0.00 :      c00000000004d7a8:       lwz     r0,0(r4)
>          :              addi    r4,r4,4
>     0.00 :      c00000000004d7ac:       addi    r4,r4,4
>          :      err1;   stw     r0,0(r3)
>     0.00 :      c00000000004d7b0:       stw     r0,0(r3)
>          :              addi    r3,r3,4
>    99.48 :      c00000000004d7b4:       addi    r3,r3,4
>=20
> ~300% in one function. Urgh.
>=20
> This is caused by the way we parse objdump -S output, eg:
>=20
>         addi    r3,r3,1
> c00000000004d78c:       addi    r3,r3,1
>=20
> 1:      bf      cr7*4+2,2f
> c00000000004d790:       bne-    cr7,c00000000004d7a4=20
>=20
> We assume the asm label (1:) is an address, compute a bogus offset
> into the function and then screw up the matching of samples to lines.
> I notice this also fails with c inline assembly in a similar
> manner.
>=20
> We already have a sanity check that the address is not beyond the end
> of the function, so add a check against the start too.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Eric B Munson <emunson@mgebm.net>

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMTRRAAoJEKhG9nGc1bpJtMkP/A5PKfYWTmwcuEVSNHqWOcQk
NxeWEiB2/tcP08lhSQ4HqRFNJz/ax1wSi/Oxhgz5t/PDqO6Fsp6DnCKxuzIe6byB
L70bSh4LVUYY0ITuAs6PU3sV40SU/cXaUXCpZEuoXp4/Svb2UAholLW7KBS/mLGI
YstA4YbSifDMe7NuPFe3g/9W3V7St0db/fByKsq50mKwbFKjLPkUPuwmzT+rQWXP
V3HmD23Jt6HTYh2gH4ojgxSg2TtIvvXKxDgmfUtH7+TzJou13sVoK43vwn1HmDOR
ajXiIf6meqAFrAFwFfVKvemnu/r9tNofeJknj/EFflR7FKRH7Ulkn2BT//yDK9ZV
aW4jYEUilcy7UpvvAJOFi6p7ePCAXeRKifRctrN9POWUNdo/JKo1p32PxH1VX+Hg
V00WKJkHF5/SqwHwvP6k4DwFGAsleJYMUl07HMz6mhzxyWpe7dtbjYiPcttrO1Oo
Ifd5C8xDRSx5hSBdny5Rs8sOKVPXN1ZGT79fnnFrNeddGOUYR98hLS2aYME52U5P
yzYKgt4Kcp4NEYHz9B56rM9aAgpIcab03sTDGPlG17PQtpqofXPMXykCrTjUTOzk
HQi1oU+TqXpYLKRn6mjHw9O4MRjIslcpTMFJKaWLH8yve4ZfS1C2HHR+O+1uvu5X
fnv09eCTKO0zuchENxQn
=7JTn
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
