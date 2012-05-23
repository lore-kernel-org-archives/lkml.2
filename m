Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2EWJcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:32:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35528 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758537Ab2EWJcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:32:11 -0400
Date: Wed, 23 May 2012 10:32:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
Message-ID: <20120523093208.GB4085@opensource.wolfsonmicro.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au>
 <4FBBAF1B.1070702@xenotime.net>
 <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 22, 2012 at 11:57:30PM -0700, David Rientjes wrote:

> regmap: REMAP_IRQ should select IRQ_DOMAIN itself
>=20
> CONFIG_REGMAP_IRQ relies on CONFIG_IRQ_DOMAIN since 4af8be67fd99 ("regmap=
:=20
> Convert regmap_irq to use irq_domain").
>=20
> Instead of ensuring all options that select REGMAP_IRQ also select=20
> IRQ_DOMAIN, just make the former select the latter itself.

The reason we're selecting things from the users is that multi-level
selects have never seemed to be terribly robust, they've been a
noticable source of breakage with this sort of randconfig stuff in the
past which is painful and annoying, especially given the strange fixes
that tend to come from randconfig reports.

That said a "select X if Y" construct doesn't ever seem to have this
problem...  I'm just sending a patch doing that now.

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvK6EAAoJEBus8iNuMP3d/eAQAJn6ZsGjkDYX48Vyk/H0okFH
Sue2UdeK7sfZUwfaWtMkHo+XVgJuznM7ZmOSsjWsNw+zgGi0TiY6ULGxaQdXljna
Mv51vh6rLV+uTmEeLKroHmGdwVdzDF1k4PTVgGSJjHKTEXj2dsc5zBhzsrWFwmnV
bthpyrQDV4za6oMUj9J0H0hFRhf3fOKPHLTt1m2olYYTvIWLhYFxxYJa8AVcPfGw
7IRPqpUyTmyHtgsdCno/Ap/baA05bkzeuscZBbsntQFWc0yNx4iPQg4XuzvvS2n0
kLqOdJvlZUncTYW6LJg74xeG1NVdNH2HoINUviZg2XNnjrR9VnnBveC3IwGkxspb
akMu85pLliE4Ql+t5vFmlMwtgZvzIwGHaNdxuYioQYM14hBPJ02glCN8c7e5AbiA
cvp52f5L82kAtEBDYGV+enNBskWUNnHgqUgbtO9gj46CWUoE+/KpEW7AbdNRwniq
7r2F/DV1zJogA97Grz+sX037DyPXrLK8bepMS7zPBsinRgFGc8x8fqPQ5UGw9oyx
ZS4CDmxcxRUMBTuqjPDY6uJ9dsBJ3ToppB73jNpwdXeCwB0ninYmcEt+r2TR7Iag
9ZYJ5DkIZciReduhTeb25RsLe71D/a7vmtdH01ISJx0NQPb8OztLOFtLJjTNXOOJ
1pomSRQty+aOm3q+Rz9I
=xCl9
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
