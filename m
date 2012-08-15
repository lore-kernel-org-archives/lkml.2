Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2HOE3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 00:29:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55644 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab2HOE3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 00:29:43 -0400
Message-ID: <1345004966.824.214.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 10/65] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
From: Ben Hutchings <ben@decadent.org.uk>
To: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@linaro.org>, Shan Kang <kangshan0910@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 15 Aug 2012 05:29:26 +0100
In-Reply-To: <20120813221415.872342783@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
	 <20120813221415.872342783@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6rNr8/vYg6FZb9d/gjQ3"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6rNr8/vYg6FZb9d/gjQ3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:13 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
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

I understand that a further fix is needed on top of this
<http://article.gmane.org/gmane.linux.ports.arm.kernel/181693> but it's
not in Linus's tree yet.  Is it better to apply this on its own or to
wait for the complete fix?

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-6rNr8/vYg6FZb9d/gjQ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCslpue/yOyVhhEJAQpBYg//WvdyqHBnS7Qk5BvpMDiI9eIq3kPLvvOz
mjCc0Qe9aZ3WXwgWMou5phVCpkXfpm9jj5sdn6km/oIpY8AdU7hMJ+xhzqKgKeFR
+idbgSPAn2taT+RKVCbPfhfi7VgRMcQBOeKOOBqUKeTSUSx1JImPU3G+1AHOtlCd
UX/ZqxlFXtaq7okWC76lUvmo/8fY9HD+8AOG9ipWPqml1+KoTgsTOa7OSBBNBbnU
G8XGPYw7cbdl2xCRccjGW1h6khHeYxve4EV0J3/xV77qbdGafUCPnvd5eQitAc8t
y8mTCcs0qeo0Tcv8DtKf9lFCWpRpaGb3ZAFRZaq6/pXkfiwbzbXXaYs2f3Tc9FdL
mn5RRZf8Dxv4mgEM0i5MMAgFcgU2h9FqdsQM5tUUc+9FxlgSgXCDrsVqXadMHQb2
9o5e4++2SMEteXqFbqLQ83bCtfjPw/Ufx1MCnb8xMrMxKVSYPqLaXbOCnbAem50o
c3+D2XmJ12ebi0SWkAjWFTe8ywIcPEK5aI8/cpsDratuMdIk09oeY3dHOEc4KMhF
7d5eGYyi2LsrwzezLWKhnN25JZ/3sNimnnyIO4sPJGg5wMV6naZYWlxV0Z4LnMSA
C7u0utfMtDxiptcPPiCcD4zkeNFJsnBi6XIVb+JGWlduP4vxJyEFDvdES2pqDmaW
qIK9vzwisv0=
=aNmX
-----END PGP SIGNATURE-----

--=-6rNr8/vYg6FZb9d/gjQ3--
