Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1AaGBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 01:01:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54038 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1AaGBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 01:01:33 -0500
Date: Mon, 31 Jan 2011 17:01:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-net-drivers@solarflare.com, Tom Herbert <therbert@google.com>
Subject: linux-next: build failure after merge of the final tree (net and
 tip tree related)
Message-Id: <20110131170123.9ee51a40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_17_01_23_+1100__m0n40exP0oGnQ0y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_17_01_23_+1100__m0n40exP0oGnQ0y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

kernel/irq/manage.c: In function 'irq_affinity_notify':
kernel/irq/manage.c:182: error: 'struct irq_desc' has no member named 'affi=
nity'

Caused by commit cd7eab44e9946c28d595abe3e9a43e945bc49141 ("genirq: Add
IRQ affinity notifiers").  This build has
CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED=3Dy.

I have just left it broken for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_17_01_23_+1100__m0n40exP0oGnQ0y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRlAzAAoJEDMEi1NhKgbsVnYIAJq2+t92If/U59zDFsPv8lKx
6wPf404DUYV7AcAb+doQKt4gDqZCatUnrz7dch5cray4P+dKK9DzcCyhbAC/MOU9
Gzk2ylofFWKfiwKMuEPYrMtjneRfRR4qy1BCLBiWP9fbT9AYCo0uZdc/Qe3BMuVI
lfr49Hg3jkde3TnPCiBkP5kcBODN/kzmRLIrgquxNns+kItgTwnP6Y0mHfK7VSjQ
YAoL2TxOXRNpzRVi4gTuHMb4YLAz9FKxwpKvP61E+Dvdw/EozJEQiQtxLOpvMSE1
oD+qie9lHKNEcWjAjhXhVJQmrMLYkBdQqKKl2CDdUKd524IxNOJKIVr4m4218j4=
=H4Kt
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_17_01_23_+1100__m0n40exP0oGnQ0y--
