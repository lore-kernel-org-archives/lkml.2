Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0DUOHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:07:54 -0400
Received: from atreides.gradator.net ([212.85.155.42]:32779 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0DUOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:07:52 -0400
Date: Wed, 21 Apr 2010 16:07:50 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20100421140750.GA29137@gradator.net>
References: <20100407202339.GB4830@gradator.net> <20100408134705.GA983@gradator.net> <20100420051125.GB7798@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20100420051125.GB7798@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: Re: PROBLEM: 2.4.37.9 destroying an Ethernet interface with permanent NUD leaves the kernels with undestroyable interfaces when ATM is compiled in
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Willy,

On Tue, Apr 20, 2010 at 07:11:25AM +0200, Willy Tarreau wrote:
> Hi Sylvain,
>=20
> indeed, you've hit a real bug. It reminds me of the sad days I
> was forced to use IPoA over a USB modem to access the net. The
> tiniest config error required a reboot to fix it :-/
>=20
> Your fix looks right at first glance, but I'll review it deeper
> before merging it, though it should be OK since 2.6 is similar.
>=20
> BTW, is there any reason why you're stuck on 2.4 ? Are you using
> some vendor-specific drivers which are not in 2.6, did you not
> have the time to upgrade yet, or did you not find a long enable
> support for 2.6 releases ? Or anything else ?
>=20
> I'm asking because whatever keeps users in 2.4 should be addressed
> one way or another (probably via some doc to add in 2.4 BTW).

Well, if that were only me, this would be a 2.6 kernel, actually one of=20
our new xDSL collect provider use Linux routers on operator customer=20
edge and they are still using 2.4 kernels. This is going to change=20
soon, but well, I discovered that there was this bug, I could not left=20
it uncorrected, even on the 2.4 kernel ;-)

I am not sure if collect routers are also used elsewhere than in France.=20
This is the server where PPP/L2TP tunnels or VP/VC ATM are ended, so=20
that all operators use the same national networks and simply use PPP=20
tunnels from xDSL customer to Internet operator router, using Radius,=20
PPPoE, PPPoA, L2TP, and PPP protocol to do the authentication, find and=20
reach the endpoint.

By the way, the patch also fix another issue, when an interface with=20
dynamic NUDs is set to link down sate, you have to wait that NUDs=20
entries expire before setting the interface back to link up state. This=20
is obvious because dynamic NUDs entries are not cleared when=20
neigh_ifdown() is called.

Regards,
Sylvain

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLzwa2DFub3qtEsS8RAqPNAJ47ATULeyiTz9lR8ccDmDSi8iB8mQCeM2FN
uZpWx8uG6T+fux+5yK8gKNs=
=vJX5
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
