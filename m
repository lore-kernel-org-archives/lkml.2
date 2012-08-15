Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2HOOCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:02:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59580 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823Ab2HOOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:02:52 -0400
Message-ID: <1345039364.824.217.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 06/44] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@linaro.org>, Shan Kang <kangshan0910@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Wed, 15 Aug 2012 15:02:44 +0100
In-Reply-To: <20120813220142.690510091@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
	 <20120813220142.690510091@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9KwQrPNbqgacHMoXHYUo"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9KwQrPNbqgacHMoXHYUo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:02 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Will Deacon <will.deacon@arm.com>
>=20
> commit a76d7bd96d65fa5119adba97e1b58d95f2e78829 upstream.
>=20
> The open-coded mutex implementation for ARMv6+ cores suffers from a
> severe lack of barriers, so in the uncontended case we don't actually
> protect any accesses performed during the critical section.
>=20
> Furthermore, the code is largely a duplication of the ARMv6+ atomic_dec
> code but optimised to remove a branch instruction, as the mutex fastpath
> was previously inlined. Now that this is executed out-of-line, we can
> reuse the atomic access code for the locking (in fact, we use the xchg
> code as this produces shorter critical sections).
>=20
> This patch uses the generic xchg based implementation for mutexes on
> ARMv6+, which introduces barriers to the lock/unlock operations and also
> has the benefit of removing a fair amount of inline assembly code.
[...]

This should be deferred, same as in 3.4.y and 3.5.y.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-9KwQrPNbqgacHMoXHYUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCusBOe/yOyVhhEJAQpwrg//ekTUO+KWfGWdRRot1bOewLPB+Rq3iuze
KaER7b0giI05bULzed0iWBQfCRCQW8ShUZgL6DIpoChW3VEFFJfCQTy7qkoWNWwo
ByCSeOwCGsgawqGRTEIfC3mYPkXWIs2LFmJQrfbLes8U2cynEJSGSp7IrvO5HRH2
+OGmbAhjxq8kIKgaCsjCjX/Q4GsjSWVsvxUmCQXQOak0Eo7ppbyujZsaveeEbUGL
g+A6ZNb2DgBNmxPvsSGNdx9XlnrdbBKBveEsQ1AIzVIG+ReeyxlWd47DLCwN9otT
0uLPmrf9XzHdeSNP7DodBFPFsMxxBrE2bRu4USXPCMK7qSL9ak5IPlJrwl+d2Svz
GOUEACNlasNflh7dAdsfHy8FKzp/Pbgm+RRb25rQ/L29YhUDdFeO3m2aZ+p79jf+
PFGABXQjlK/muLyiQ7s3Wf1YTETX5P3hB/FhsKm/ubAPLvqVAP+1zWNB1yomsQBV
AI6tunUeOz3UyXMP3YswV2dK7g9Be10bTGAOHu8aslGZJKYpGgnqvtYo65razzFs
P9Pg1Kci5H3y2CcEe2poYriCWx9W7ReQT/RVdM1V1ckH0bR1B8KK5I2qgvWsZ/tu
neX+LYvF6JWhmv3oa3df1Kf/3qg6BMf4cMwdDXcLiKtoj59zUpjj32xrA+mu71CK
poaDEu0AK3o=
=QDR/
-----END PGP SIGNATURE-----

--=-9KwQrPNbqgacHMoXHYUo--
