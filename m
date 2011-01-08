Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1AHWJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:09:39 -0500
Received: from quamquam.org ([88.198.196.3]:48378 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1AHWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:09:38 -0500
X-Greylist: delayed 1169 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jan 2011 17:09:37 EST
Message-ID: <4D28DC01.2010901@poelzi.org>
Date: Sat, 08 Jan 2011 22:49:53 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
X-Enigmail-Version: 1.1.2
OpenPGP: id=0A7B003D;
	url=http://files.poelzi.org/poelzi.asc
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE8BF02DA8AE796A56C3A94C8"
X-SA-Exim-Connect-IP: 91.64.130.10
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: poelzi@poelzi.org
Subject: ANN: ulatencyd
X-SA-Exim-Version: 4.2.1 (built Sat, 07 Nov 2009 20:03:47 +0000)
X-SA-Exim-Scanned: Yes (on quamquam.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE8BF02DA8AE796A56C3A94C8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I'm proud to announce ulatencyd [1]. A scriptable daemon to dynamically
adjust Linux scheduling parameters and other things.

It is not ready for a release yet, but it works to a point I started to
get satisfied. I'm able to run a make -j 40 on my dual core machine
while looking a full hd movie without problems and the ui from kde still
feels good :-)

The architecture looks like this:

https://github.com/poelzi/ulatencyd/raw/master/docs/architecture.png

The rules usually only mark processes with flags that the scheduler uses
for his decision how to set the parameters of the process.
In special cases, the rule can enforce itself to schedule the process
itself, which is useful for reacting to attacks, for example.

There is still a lot of work to do. The scheduler itself was a quick
hack that needs a lot of work. There are currently no rules for swap of
death, fork-bombs, amok running processes,... and the scheduler has to
handle them of course.
There are already lots of optimization that minimize the amount of lua
code running, but the load on ulatencyd is high when a lot of processes
are spawned. This will be optimized soon.

[1] https://github.com/poelzi/ulatencyd/

PS: please CC if possible :-)

kind regards
 Daniel Poelzleithner


--------------enigE8BF02DA8AE796A56C3A94C8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNKNwHAAoJEFYpgV2RoepcJxMQAK9tJ614dZRZO69/O3bBy1Ps
CVIdOx0GRgSAyJFwhgjgJDWfIXfOxLs7gfX3K6jDc5esrksLbNxN6TnmP1iIrhOl
8Kjh+xKt9+Vz6STrePL8wG+UfZDrmUABIONUYiC/MB+dxdRrRUjNvSmhR/QlfZhX
Pad2/8IHbRPj7sV/AKVpmdOfDVj7eM7ogAaLT9XIpA/Li7TanIbGoKEgaYCwMbJD
j5okslWVGwK4QTcDg9wcr3PwSvZoeoHxCAZEUdShqjdGEUZsrm9/p9h5m7H2QyG4
A8SqltgbgFv5sAez68Dgf96kwlpAUWicDxs0+XYGKYwIOB557uKlyjS5YowhpoXl
ZuHMzajphDlStNG+gUdoLqlK1ykp5pzt0mbF1vFW+UzXsbswtNndKQVPFv0xp5ct
SJv4tmI7b0nIXKkpiTUwMah+ShnCLK+aG/MSydj9Ea8f91CXusBnxZSAg9iMU5BS
XP3g8J6k6oN5YDLcIbnOl3+yo2u3z01n9xgM04Zv6xqllKeqcwiqMHGwC/iBKVSh
2VCGVM2OUdsqQd2pAkFCfN+EQvvIa10tFYrv4sHY+nLOAeQRUZnBC/UmxidcR8PZ
WSVxJHWrjnBusKIQ+wMYZaE9kjK8GGAZSu9d11jA30231I3fJRvSl2sP15FZSRBs
7oYG0UMbfM1+XptzDO3M
=qdGD
-----END PGP SIGNATURE-----

--------------enigE8BF02DA8AE796A56C3A94C8--
