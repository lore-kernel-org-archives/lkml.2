Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab0I0OXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:23:23 -0400
Received: from uucp.gnuu.de ([83.246.114.63]:4348 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759477Ab0I0OXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:23:21 -0400
X-Greylist: delayed 1667 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 10:23:21 EDT
Date: Mon, 27 Sep 2010 14:50:37 +0200
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Oops in trace_hardirqs_on (powerpc)
Message-ID: <20100927125037.GA4497@alea.gnuu.de>
References: <20100806233157.GA7117@alea.gnuu.de>
 <1285184671.26872.127.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1285184671.26872.127.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Steven,

Steven Rostedt hat am Wed 22. Sep, 15:44 (-0400) geschrieben:
> Sorry for the late reply, but I was on vacation when you sent this, and
> I missed it while going through email.
>=20
> Do you still have this issue?

No. I've rebuild my kernel without TRACE_IRQFLAGS and the problem
vanished, as expected. The problem is, that in some cases the stack is
only two frames deep, which causes the macro CALLER_ADDR1 makes an
invalid access. Someone told me, there a workaround for the problem on
i386, too.

% sed -n 2p arch/x86/lib/thunk_32.S
 * Trampoline to trace irqs off. (otherwise CALLER_ADDR1 might crash)

Bye, J=F6rg.
--=20
Angenehme Worte sind nie wahr,
wahre Worte sind nie angenehm.

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkygkx0ACgkQwe0mZwH1VICMRACfS1qucjIyFj+p8CB55kopPB3Q
oHwAoJmA2XysgTSHqoBhVchfOs7Fdm8J
=zPt1
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
