Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab2JWJwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:52:40 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:58882 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab2JWJwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:52:37 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 05:52:37 EDT
Date: Tue, 23 Oct 2012 11:43:51 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz
Subject: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121023094351.GC27919@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7874937 records (last update: 20121023)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

while trying to create consistent backups of KVM guest, I've discovered
that fsfreeze always hangs.. deeper investigation revealed psacct to be the=
 culprit.
When psacct is disabled, fsfreeze works fine, when enabled, the command nev=
er returns.
I suppose that the problem is /var is not on separate partition (ie it's sa=
me volume
as /) and psacct isn't able to dump process exit information about fsfreeze=
 command
thus creating deadlock..
problem is 100% reproducible on both latest 3.0.x kernel and 3.7-r1c.

Should more debugging information be needed, I'll be glad to provide whatev=
er I can..

BR

nik

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlCGZtcACgkQ3xdJJrLygV4RngCgiDwK0gQxqNx528p2/+nmP00f
WRsAn2+tZXOUn4u33DbwQZShYn8HMeJF
=0+d0
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
