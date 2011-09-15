Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab1IONCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:02:20 -0400
Received: from www17.your-server.de ([213.133.104.17]:50866 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535Ab1IONCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:02:18 -0400
Subject: Re: a question regarding sys_poll() on x86_64 via tha ia32 layer
From: Thomas Meyer <thomas@m3y3r.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, mingo@redhat.com
Date: Thu, 15 Sep 2011 15:00:55 +0200
In-Reply-To: <1316089435.2893.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1316086860.6545.66.camel@localhost.localdomain>
	 <1316089435.2893.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3+K4PgSt/mYLYMrm10T0"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1316091669.6545.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3+K4PgSt/mYLYMrm10T0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 15.09.2011, 14:23 +0200 schrieb Eric Dumazet:
> Its a plain bug, please submit a formal patch.
>=20
> Probably not noticed because timer is set to more than 24 days.
>=20

okay. I think a similar problem exists for sys_truncate() in ia32 layer
on x86_64:

the ia32 syscall is directly wired to sys_truncate(char *, long).

signed long will use %rbx on x86_64 and %ebx on x86.

call sys_truncate on x86_64 from x86 userspace will handle length
0xffffffff not as -1.

maybe an easy fix would be to change long to unsigned long for
sys_truncate(), like sys_ftruncate(). what do you think?

with kind regards
thomas

--=-3+K4PgSt/mYLYMrm10T0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOcfcHAAoJEK2Y/UtDbsHsAWIH/2wcu6P1PTZk188X1MUZ9juy
JGBc6PcJXGBSdzCL79po8O7Z3GCzs3Fft3ToH5bsDXPzJIabfdT1dzJ1alJRAcja
m2FqZ9UaEXg+cnuzXM41FxOQsOkQwwYqHlhJKmzRvUF6156C+IfooBaxiQ2AlfgG
rsZNGz+1Rjomy/ciTIc9r19p52hpDoiCHmI6Mh3E/NP4j2/Cc1KEgwzaBbZHnIE8
7Q4Hkts8OtIUmiOd7o3dw2QLO2tBRSX0S7b4PUPfB27+8qLc45OHvGLrdJpasnfw
5Al3xrbBhZ2kY7jF/WCgckyCfwQ0hTJZqPR8PjwvECUnF8kLOj5fG3pv7TCkuzc=
=9at+
-----END PGP SIGNATURE-----

--=-3+K4PgSt/mYLYMrm10T0--

