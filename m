Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0GVWwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:52:19 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:53658 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0GVWwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:52:18 -0400
Date: Fri, 23 Jul 2010 00:52:12 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: linux-kernel@vger.kernel.org
Subject: b43 wireless driver inhibits access to /dev/hwrng
Message-ID: <20100722225212.GA19361@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

the b43 wireless driver inhibits access to /dev/hwrng while the wireless
network interface is down. When the interface is up, /dev/hwrng is
accessible:

	root@ideapad ~ # uname -a
	Linux ideapad 2.6.35-rc5-686 #1 SMP Tue Jul 13 16:16:00 UTC 2010 i686 GNU/=
Linux
	root@ideapad ~ # grep name /proc/cpuinfo
	model name	: VIA Nano processor U2250 (1.6GHz Capable)
	root@ideapad ~ # lsmod | grep via.rng
	via_rng                 1243  0
	rng_core                2912  2 via_rng,b43
	root@ideapad ~ # hexdump -n 10 /dev/hwrng
	0000000 81f2 8497 71bb d900 f89f
	000000a
	root@ideapad ~ # ifconfig wlan0 down
	root@ideapad ~ # hexdump -n 10 /dev/hwrng
	hexdump: /dev/hwrng: No such device
	root@ideapad ~ # ifconfig wlan0 up
	root@ideapad ~ # hexdump -n 10 /dev/hwrng
	0000000 86fc 5d33 4dec d97d da7b
	000000a
	root@ideapad ~ #

Aside from such a side-effect being heavily unexpected, this effect is
particularly annoying because it renders rngd failing to start at boot
time - especially when using NetworkManager which is usually started
later than the classic ifupdown methods.

I have no idea whether this issue belongs to the b43 driver or to the
rng core.


Thanks for your work & best regards
   Mario
--=20
The only thing to be scared of, son, is tomorrow.
I don't live for tomorrow. Never saw the fun in it.
                       -- Denny Crane, Boston Legal

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTEjLnBS+e2HeSPbpAQJDMQgAkIyn0t1fDtPFSJ4Pq/5obmeu8MPcat9p
t6JMIzZS/3bda8FERe/isgQPGN1GDrzsBJ54JVUw+T+4Mco+d33nzswy2UIojz0C
yMJDXsKV2MdHihPl894ZzwgmHjdtYHuOGAcs+6Wa3C/l7bNs1BhmZxoMGbLQZgDH
ghNDgYmI1tT9sfbkMpKemkSo+2B1jyxBFHbxBETPr6ruTizS0CG4oao0WQnUqoWk
BegtwyjDIzg754IHTIBIAywL1s3RlXE9xQQekOJJtXDIkO/W009C6l3+gXn+wBbR
8CtztkzusjRZJ+A5SWCiKUYFZH2RcowakZBE15+pcfNxvmspWnZEwg==
=ugHI
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
