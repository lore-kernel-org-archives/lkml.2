Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0ESBZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:25:48 -0400
Received: from ozlabs.org ([203.10.76.45]:47916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0ESBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:25:47 -0400
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       Doug Maxey <doug.maxey@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4BF31322.5090206@us.ibm.com>
References: <4BF30793.5070300@us.ibm.com>
	 <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4lkiPNYo67gNjmCGq6H0"
Date: Wed, 19 May 2010 11:25:24 +1000
Message-ID: <1274232324.29980.9.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4lkiPNYo67gNjmCGq6H0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
> On 05/18/2010 02:52 PM, Brian King wrote:
> > Is IRQF_NODELAY something specific to the RT kernel? I don't see it in =
mainline...
>=20
> Yes, it basically says "don't make this handler threaded".

That is a good fix for EHEA, but the threaded handling is still broken
for anything else that is edge triggered isn't it?

The result of the discussion about two years ago on this was that we
needed a custom flow handler for XICS on RT.

Apart from the issue of loosing interrupts there is also the fact that
masking on the XICS requires an RTAS call which takes a global lock.

cheers



--=-4lkiPNYo67gNjmCGq6H0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkvzPgQACgkQdSjSd0sB4dJlNgCgsmZ8ujLaiur6wY9QHfb3QAMk
HA4An2SFFJuOSG6pUuRhYEQNLy3sCCy1
=uh9A
-----END PGP SIGNATURE-----

--=-4lkiPNYo67gNjmCGq6H0--

