Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab2GTSTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:19:12 -0400
Received: from alfa.cardwellit.com ([178.79.145.246]:36566 "EHLO
	alfa.cardwellit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GTSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:19:10 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2012 14:19:10 EDT
Message-ID: <50099F72.8020901@lists.grepular.com>
Date: Fri, 20 Jul 2012 19:12:02 +0100
From: Mike Cardwell <linux-kernel@lists.grepular.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Procfs race condition bug
OpenPGP: url=https://grepular.com/0018461F.pub.asc
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig563AD453FDE3E003390B0019"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig563AD453FDE3E003390B0019
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I *think* I've uncovered a race condition bug in procfs. If I attempt to
open a file in /proc/net, eg "/proc/net/tcp" it works fine, but if I
spawn a POSIX thread and attempt to do it from there, it *usually* fails
with a "No such file or directory", but some times succeeds. If I do a
system call inside the thread to look up the thread ID and then open
"/proc/THREADID/net/tcp" instead, it works fine.

There are more details and  some example code so you can replicate the
problem on a stack overflow question I asked earlier today here:
http://stackoverflow.com/questions/11580020/opening-proc-net-tcp-in-c-fro=
m-a-posix-thread-fails-most-of-the-time

This is the first time I have attempted to report a (suspected) Linux
kernel bug, so I apologise if I have made any mistakes. I am not
subscribed to the list, so please Cc me in on any responses.

Regards,

--=20
Mike Cardwell  https://grepular.com/     http://cardwellit.com/
OpenPGP Key    35BC AF1D 3AA2 1F84 3DC3  B0CF 70A5 F512 0018 461F
XMPP OTR Key   8924 B06A 7917 AAF3 DBB1  BF1B 295C 3C78 3EF1 46B4


--------------enig563AD453FDE3E003390B0019
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGGBAEBCgBwBQJQCZ90MBSAAAAAACAAB3ByZWZlcnJlZC1lbWFpbC1lbmNvZGlu
Z0BwZ3AuY29tcGdwbWltZTgUgAAAAAAVABpwa2EtYWRkcmVzc0BnbnVwZy5vcmdt
aWtlLmNhcmR3ZWxsQGdyZXB1bGFyLmNvbQAKCRCdJiMBwdHnBGJiB/9E6gpgbGgb
iYrKjUOLIKx2uzvZvJJn+Ls7TQuT3G/sKqXdttlRE1cOQ6yEnLF7+qqldxGjWLkj
MLEWsYB7JwBiFRZn3Cz7gPPNcZTPJTifq+tJaT16XqZj21jG6JEEfwF+Wsff/nQc
qGWBprDzcuUwe/sYHnGwuwzHEhdS43nPMg8XxvIFOjUQYgBJLFc1PGUjgr4oCmZJ
Fu1rsKXrumuYvaeCJ4h+hd8gDp3FVRNiTFANm0j75LiItc4nfyzsmA7IS+E608Mt
OevxRF4iwvZVVg7sc5OZb7Go4Shoue1gIMh8s+Kn4lZBHeplrVmAR+NH0BYGzZWU
QIqbwlZ49Dwe
=eeaa
-----END PGP SIGNATURE-----

--------------enig563AD453FDE3E003390B0019--
