Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0EZPNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:13:53 -0400
Received: from ozlabs.org ([203.10.76.45]:58164 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab0EZPNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:13:50 -0400
Subject: Re: [Patch 1/4] Allow arch-specific cleanup before breakpoint
 unregistration
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Howells <dhowells@redhat.com>
Cc: prasad@linux.vnet.ibm.com, Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, shaggy@linux.vnet.ibm.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Millton Miller <miltonm@bga.com>, David Gibson <dwg@au1.ibm.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <4250.1274867681@redhat.com>
References: <20100526065129.GA3746@in.ibm.com>
	 <20100525083055.342788418@linux.vnet.ibm.com>
	 <20100525091356.GB29003@in.ibm.com> <1274787559_8162@mail4.comsite.net>
	 <4250.1274867681@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sITQZ3Vd3QfXmc/pnC1h"
Date: Thu, 27 May 2010 01:13:47 +1000
Message-ID: <1274886827.21113.15.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sITQZ3Vd3QfXmc/pnC1h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-05-26 at 10:54 +0100, David Howells wrote:
> K.Prasad <prasad@linux.vnet.ibm.com> wrote:
>=20
> > > My understanding is weak function definitions must appear in a differ=
ent C
> > > file than their call sites to work on some toolchains.
> > >=20
> >=20
> > Atleast, there are quite a few precedents inside the Linux kernel for
> > __weak functions being invoked from the file in which they are defined
> > (arch_hwblk_init, arch_enable_nonboot_cpus_begin and hw_perf_disable to
> > name a few).
> > Moreover the online GCC docs haven't any such constraints mentioned.
>=20
> I've seen problems in this area.  gcc sometimes inlines a weak function t=
hat's
> in the same file as the call point.

See the functions in kernel/softirq.c for example, and commits 43a256322
and b2e2fe996 - though unhelpfully they don't mention the gcc version. A
bit of googling suggests it was probably "gcc version 4.1.1 20060525
(Red Hat 4.1.1-1)" in that case.

But the example of hw_perf_enable() (which is weak in the same unit),
suggests maybe this isn't a bug many people are hitting in practice
anymore.

Having said that the #define foo foo pattern is reasonably neat and
avoids the problem altogether, see eg. arch_setup_msi_irqs.

cheers

--=-sITQZ3Vd3QfXmc/pnC1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkv9OqsACgkQdSjSd0sB4dIigACfZ6ANrhysTgd0P8eIneI9VPku
02cAnRfpBmP+MD6RZpH6EMImEjSexTcg
=6Ji2
-----END PGP SIGNATURE-----

--=-sITQZ3Vd3QfXmc/pnC1h--

