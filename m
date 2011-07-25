Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1GYM7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:59:55 -0400
Received: from fsing.rootsland.net ([62.141.37.30]:59528 "EHLO
	fsing.rootsland.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1GYM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:59:48 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jul 2011 08:59:48 EDT
X-DKIM: OpenDKIM Filter v2.1.3 fsing.rootsland.net 1998C12FC8033
Date: Mon, 25 Jul 2011 14:51:24 +0200
From: Stephan Seitz <stse+lkml@fsing.rootsland.net>
To: linux-kernel@vger.kernel.org
Subject: IP forwarding regression since 3.0-rc6
Message-ID: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
Mail-Followup-To: Stephan Seitz <stse+lkml@fsing.rootsland.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
Organization: Minas Tirith, Gondor
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Since 3.0-rc6 I see that my Linux router is losing packets. I can see=20
them tracing the internal interface, but I don=E2=80=99t see them on the ex=
ternal=20
interface. I can reproduce the problem while using tin with=20
news.individual.de. At the startup when tin checks every newsgroup from=20
the server, many packets are suddenly not routed anymore but are dropped,=
=20
so tin hangs until it quits with a NNTP error.
All kernels until 3.0-rc5 are working.

Hardware:
- 2x Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit=20
   Ethernet controller

Sofware:
- Debian Testing, 64bit, with Xen 4.1.0

System:
Dom0 (Debian Testing, 64bit) is my working system. The two NICs have each=
=20
their own bridge interface. One bridge interface (A) has an internal IP=20
address (IPv4 and IPv6) of my internal network. The other bridge (B)=20
doesn=E2=80=99t have a IP address in Dom0. The DomU is connected to the two=
=20
bridges.
DomU (Debian Testing, 64bit) is my iptables firewall system with Bind,=20
Squid, and other services. The interface connected to bridge A has an=20
internal IP addresses (gateway for my internal network). The interface=20
connected to bridge B is used for PPPoE (the NIC is directly connected to=
=20
my DSL modem).

Kernels:
Dom0 has had all kernel versions from 3.0-rcX and is running 3.0 at the=20
moment.
DomU has had the same kernel versions but is running 3.0-rc5 at the=20
moment because of the network problems in newer kernels.

Long problem description:
 From Dom0 I use tin to read different newsserver. One of them is=20
news.individual.de. The first time after DomU switched kernel to -rc6=20
I started tin (connecting to the mentioned news server) and tin hung=20
while reading groups from the newsrc and stopped with a NNTP connection=20
error.
Since the problem didn=E2=80=99t vanish, I wrote a mail to the support team=
 of=20
the news server. They told me that I was the only one with a connection=20
problem and asked me to try the connection from another client. I tried=20
it from my vServer, and it worked. So the problem had to be in my setup.

I traced in Dom0 (bridge A), DomU (bridge A) und DomU (ppp0) and noticed=20
that all packets generated in Dom0 were visible in DomU bridge A. But not=
=20
all of the packets were visisble at the ppp0 interface. So my DomU was=20
dropping packets and the connection between tin in Dom0 and the news=20
server failed.

So I tried older kernels and noticed that 3.0-rc5 in DomU was working,=20
but rc6 and newer were not. The kernel configuration was the same for all=
=20
3.0 kernels.

Since I don=E2=80=99t know which maintainer I should contact with my proble=
m,=20
I=E2=80=99ll write directly to lkml.

Thanks for your help.

Shade and sweet water!

	Stephan

PS: Please CC me, because I=E2=80=99m not subscribed.

--=20
| Stephan Seitz             E-Mail: stse@fsing.rootsland.net |
| PGP Public Keys: http://fsing.rootsland.net/~stse/pgp.html |

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4tZswACgkQXse+NwPOAZ6huwCeNupLVUCYi60+PImhbBlX+Ict
suEAnR2oSBAPV9ddIFYR9S/Fz8SCdNlf
=TGIT
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
