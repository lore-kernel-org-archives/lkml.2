Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153Ab1J3PZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:25:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58414 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab1J3PZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:25:54 -0400
Message-ID: <1319988329.6759.88.camel@deadeye>
Subject: CPU hyperthreading turned on after soft power-cycle
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Polach <clarinet@atlas.cz>, 647095@bugs.debian.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 30 Oct 2011 15:25:29 +0000
In-Reply-To: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-x9L1y+NmlxB+TG+ycNe/"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x9L1y+NmlxB+TG+ycNe/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-10-30 at 07:05 -0400, Jiri Polach wrote:
> Package: linux-2.6
> Version: 2.6.39-3~bpo60+1
> Severity: normal
>=20
>=20
> When the computer is turned off using "shutdown -h" or "halt" command,
> the hypertherading BIOS setting is changed - even if hypertherading is
> disabled in BIOS, the kernel detects twice as many "processors" on
> next boot as if hyperthreading was enabled. Please see details below.
>=20
> I have observed the problem on several Supermicro platforms with
> various Intel Xeon processors. The particular case I report was
> observed on Supermicro X8DTT-F mainboard with two Intel Xeon E5645
> processors (6core). The problem can be reproduced the following way:

By my understanding of how hyperthreading is controlled, this has to be
a BIOS bug, as you seem to have suspected.  But if the BIOS behaviour is
kernel version-dependent, then presumably there is something the kernel
can do to work around it.

> 1. Turn on the computer, go to BIOS setup and turn "Simultaneous
> multithreading" to "Disabled". Boot Debian.
>=20
> 2. Check with "cat /proc/cpuinfo" that the system reports 12 CPUs (2 x
> six-core processor).
>=20
> 3. (optionally) Reboot the system (shutdown -r) and check that there
> are still 12 CPUs detected and reported.
>=20
> 4. Halt the system using "shutdown -h" or "halt", turn it on again,
> and boot Debian.

I assume from this that shutdown -h is configured to turn the system
off.

> 5. Check the number of CPUs reported - it will show you that there are
> 24 CPUs as if hyperthreading was enabled.
>=20
> 6. Reboot and go to BIOS setup - it still shows that "Simultaneous
> multithreading" is set to "Disabled". Do not change anythig, just
> select "Save and Exit". Boot Debian and check the number of CPUs - it
> now shows 12 CPUs again.
>=20
> I have tested several kernel versions and it seems that this behavior
> appeared for the first time somewhere between 2.6.35.7 and 2.6.38.6
> versions (ok =3D does not show the decribed behavior, not ok =3D does
> show):
>=20
> * linux-image-2.6.32-5-amd64 official Debian - ok
> * linux-image-2.6.39-bpo.2-amd64 official Debian from backports - not
> ok
>=20
> * linux 2.6.35.7 - custom compiled from source - ok
> * linux 2.6.38.6 - custom compiled from source - not ok
> * linux 2.6.39.4 - custom compiled from source - not ok
> * linux 3.0.4 - custom compiled from source - not ok

That might be too large a range for developers to consider.  Can you
test some versions between 2.6.35.7 and 2.6.38.6 (bisection)?

Ben.

> I have exchnged many e-mails with Supermicro distributor who
> apparently is in direct contact with Supermicro technicians. They more
> or less deny any responsibility for this problem and repeatedly point
> to the fact that some (older) kernels do not exhibit this behavior so
> it must be a kernel problem. Their representative writes:
>=20
> "I discussed this with supermicro and they informed me that the Kernel
> itself is causing the issue, that it may be sending the hyperthreading
> command code to the BIOS."
>=20
> Although I do not completely agree with their arguments, my knowledge
> is not deep enough to recognize where exactly the core of the problem
> is so I report this as a bug in a hope that someone will know what
> happens when a kernel turns a computer off and what has changed in
> kernel somewhere between the versions I mention above. I have asked
> Supermicro distributor for more information on what they think happens
> there and what exactly they mean by "hyperhreading command code" and I
> am waiting for their response.
>=20
> -- Package-specific info:
> ** Version:
> Linux version 2.6.39-bpo.2-amd64 (Debian 2.6.39-3~bpo60+1) (norbert@tretk=
owski.de) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Tue Jul 26 10:35:23 =
UTC 2011
[...]
> ** Model information
> sys_vendor: Supermicro
> product_name: X8DTT
> product_version: 1234567890
> chassis_vendor: Supermicro
> chassis_version: 1234567890
> bios_vendor: American Megatrends Inc.
> bios_version: 080016=20
> board_vendor: Supermicro
> board_name: X8DTT
> board_version: 2.0      =20
[...]

--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source

--=-x9L1y+NmlxB+TG+ycNe/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATq1saee/yOyVhhEJAQoS4Q/9GdXGVDUazBlt5XAcXP66M1SKB2FGcyOY
BhgJJfMK2KH+aVEfwy5+yz8FORHdMRLioxIgcAQisK1eGjSG305Nm9CoYO0Hn4k3
DQM+ZuEtHVxOWXtmRHDHK5Cb940V/CgDsv4OFqol0miNHNX5RMFPpRKGTxdq2L0b
COWMm1qoaUbfn8bVi/KXB2xRMzN+xHkJNzQo5mraAqAC/4HwI7iug7MaV45i1jjL
KWVbwi6n1oWx5xiG8m3PkTpitVF8QMoYKIEyTdDuFh8bFUKb54Ht/RL8UdLZALwl
2kDb+kzPd6rU2gHkwDoor9fV5F/DWhQuHMZsgsPrFiKgXJ3IaLay3aajT9aevq08
/mMM7NfB0+dTcqUriYx1Gz1363i22sXf7NVbN1gXQQ9LZCUBUcy1vZSVoDSPxfnp
Fh7apyqJ27ENLENquf3vMcYQ8hqqjkNCsXzB5P76qYSIvESbuJnZz1+Pj0lVcFbK
LYYjyrnc9p8uKdfezpl+n/wr4TRPxowEO0lsjgUW/4c/3UThGDXY7frBvgV1l0rD
Qo7kANH14WCqXf4nyXSa7tAVb6BDqGEWhaTHwHaEqHWjm/MTlIj9oG4ByjuhggSG
+b4MdK+ISk5xolnOybjeDZyErs3tlhmJ851J4q/uMmTZtVqlBL17emoqImTtoWdd
p6LY7itsGs4=
=anLg
-----END PGP SIGNATURE-----

--=-x9L1y+NmlxB+TG+ycNe/--
