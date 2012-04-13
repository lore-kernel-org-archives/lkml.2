Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2DMSZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:25:01 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:36917 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab2DMSY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:24:59 -0400
Date: Fri, 13 Apr 2012 20:18:56 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz
Subject: suspected regression in 3.0.28 - applications having problems
 binding to ports
Message-ID: <20120413181856.GA2286@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7416020 records (last update: 20120413)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'd like to report following suspicious behaviour of 3.0.27 kernel.

On one of our production boxes, after upgrading from 3.0.26 to 3.0.27,
applications started to behave weird after ~1 day uptime.
Squid started reporting problems binding to port, nagios misbehaved, etc.
I was forced to revert to 3.0.26. We tried to reproduce the problem but wer=
e unsuccessful.
After ~1 week without problems with 3.0.26, I tried upgrading this producti=
on box to 3.0.27
again to see what happens and the problem appeared again after about one da=
y.

imap started reporting problems:
EMAIL DELIVERY CRITICAL - imap failed: IMAP RECEIVE CRITICAL - Could not co=
nnect to A.B.C.D port 993: IO::Socket::INET6 configuration

same for squid:
commBind: Cannot bind socket FD 21 to 0.0.0.0: (98) Address already in use

nagios processes went totally nuts.

There was no other change except for the kernel upgrade.
The box is x86_64 quad CPU 4GB machine, what might be important, we're using
IPv6 as well.
I don't see any suspicious (at least to me) patch between 3.0.26 and 3.0.27.
Since it seems to take quite a long to reproduce, I haven't tried bisect ye=
t, first
wanted to ask - hasn't anyone experienced similar problems?

thanks a lot in advance!

with best regards

nik


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+IbhAACgkQ3xdJJrLygV4KYQCgv2Z0pNFTP0+DLz0MCoQ6DEmJ
gBUAn2NIvdHQjvkHrK98L1yHOYwjlvwD
=/guM
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
