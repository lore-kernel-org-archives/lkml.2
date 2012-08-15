Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2HON4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:56:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab2HON4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:56:34 -0400
Message-ID: <1345038982.824.216.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 20/82] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@linaro.org>, Shan Kang <kangshan0910@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Wed, 15 Aug 2012 14:56:22 +0100
In-Reply-To: <20120813201748.202917513@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
	 <20120813201748.202917513@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bTQsdjREUCQctVQ8MOEy"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bTQsdjREUCQctVQ8MOEy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 13:18 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.5-stable review patch.  If anyone has any objections, please let me kno=
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

Here also, I think this should be deferred.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-bTQsdjREUCQctVQ8MOEy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCuqhue/yOyVhhEJAQroNxAAvRR27KZHp7xN4FOD7lHCczWA8YHRBYeo
2KUtZ2HrXgWgQ6HE+upyJO1GbWnMHr0+YSElYuQAT2Gk/eTXVpv6II84pMr4c/Ko
JuIuXDFs5NQ2wYkV9k86Wa64UY4I9oiYgcVt1BUhwHisW7oRhj0VyQ1LDWESFAqt
qlPM6TvuRVaQ4RVVuwCcp6LHbmPF6KHFeTULVlRKMNzZ6C5gghr28mWrXCCLZjqK
EKEibLA3+bt6r3mFXnqLq+kqipVgk7Attv9KcssUjSe7SwEBkeKtzC8KTKsN9VqW
of0jE6uWpLt9ZxMTX9/AP9wRRLSunBNn4IYPMUOEI4e52KVaDF9JXDsG2IQtpNb8
9thgKvdhG81cJQ4XjZKua+u+RFT3EFIIUnQvp2dMhLtY/IG9vnjEv5QbOff1n+Zb
FUm6rp6JS+u5HcSSmJhI5hfF8k9KZmc8ktYzew5YrWc2CwJgok2qXXAfkkq/11nl
6ViGjZKnDW+0fA9IJZ5xdjbLnPy/9A6aV+Cz6OscTEyvf4f3XXOlJgWYhLjzuVpH
iz3zCIJvki/io9MX6dqybQqkRXDvknBgEjSSnMxYzGRDwP3sVBsyFPSBX8/sKJIo
P61S0uJlDYilDJaRy+7TOAqurFTCMFRHJ9tXN/y45N/OvpmZ1JfzPdhrTRvzWQoM
QP+T7raoH1c=
=NLYj
-----END PGP SIGNATURE-----

--=-bTQsdjREUCQctVQ8MOEy--
