Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0FLODA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 10:03:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649Ab0FLOC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 10:02:58 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>, 584846@bugs.debian.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100612060322.29053.94187.reportbug@feather>
References: <20100612060322.29053.94187.reportbug@feather>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KrciiS4RpEGPUjkwyN1X"
Date: Sat, 12 Jun 2010 14:58:40 +0100
Message-ID: <1276351120.14011.194.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KrciiS4RpEGPUjkwyN1X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Josh Triplett reported this problem with memory sizing:

On Fri, 2010-06-11 at 23:03 -0700, Josh Triplett wrote:
> Package: linux-2.6
> Severity: normal
>=20
> I managed to reproduce the problem using stock upstream kernels and
> defconfig, and with defconfig (and no initramfs) the kernel managed to
> use little enough memory that it booted successfully with <64MB of RAM.
>=20
> Investigating, I found that Linux decided not to use e820, and instead
> decided to use the older BIOS function 0x88, which cannot report more
> than 64MB of RAM.
>=20
> With some investigation and bisection, I managed to track the problem
> down to the following commit:
>=20
> commit c549e71d073a6e9a4847497344db28a784061455
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Sat Mar 28 13:53:26 2009 -0700
>=20
>     x86, setup: ACPI 3, BIOS workaround for E820-probing code
>=20
>     Impact: ACPI 3 spec compliance, BIOS bug workaround
>=20
>     The ACPI 3 spec added another field to the E820 buffer -- which is
>     backwards incompatible, since it contains a validity bit.
>     Furthermore, there has been at least one report of a BIOS which
>     assumes that the buffer it is pointed at is the same buffer as for th=
e
>     previous E820 call.  Therefore, read the data into a temporary buffer
>     and copy the standard part of it if and only if the valid bit is set.
>=20
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>=20
>=20
> A kernel built from c549e71d073a6e9a4847497344db28a784061455 finds <64MB
> of RAM; a kernel built from c549e71d073a6e9a4847497344db28a784061455^
> successfully finds all 4GB of RAM.
>=20
> Also note that newer upstream kernels, including v2.6.35-rc3, fail as
> well.  Since later kernels revert part of the above commit, the issue
> must lie with the parts of the commit not reverted.
>=20
> And, again, I can reproduce this using the stock upstream GRUB2 1.98
> release built from source, by booting it from a USB key, and then
> booting the disk MBR via:
>=20
> set root=3D(hd1)
> drivemap (hd1) (hd0)
> chainloader +1
> boot
>=20
>=20
> Nothing special about drivemap here; anything that uses grub's mmap
> module to reserve memory via e820 (GRUB_MACHINE_MEMORY_RESERVED) will
> cause grub to hook e820 and trigger this bug.  However, in stock grub,
> only drivemap does this.
>=20
> - Josh Triplett
>=20
>=20
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-KrciiS4RpEGPUjkwyN1X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATBOSj+e/yOyVhhEJAQJNYhAAxaXH55fM+5OgPW8spPwMAEJwZzydlVxT
0sZWxMsvc3HIVsZ0ZtUzANrMwPZL5+mo3PRDIMGXAuo+B8j0HzD0AJ7yFA6ci7hO
CzXuf2V3VEyXBR6w6ifoYWuhWCEngpl5xtW+TvvMUVJy5vslMbYW12LJBbVsQQtM
B1dO6pUyooik623NxPt9RPsDt1EjMGonMM/Ec83E9tTIG6XvgVtf3GW4clSS5VuS
dYUL4rsRg0JnRjhGg65J6dgVOL98fcpNfZ2ppVbKpq6i7xsVeagrU6ALbZ0R5d9g
UzG3s3mRGut7BCXtoZDUSQmnDKfj4WnLY6a+WflksmTVzfJyCbrJ1xDbZupLvw8+
rFePyEsr6kQcpaLHzz1P7nIpewIk2+2zVjsiKMDS83I3rXgp8YHdAQeYb0hzxmzk
2H8hN4t1lNCehX8FwRh3uSbz0FnocA3oilVVaWBcHFS/QcKknlBuGNo/Qqehgp+t
0zojmYfGvEMY+DxpyFU89n4Ka6ajOrH758zQfyuGP4ajwG+JFzdhL+yl+DHI07Eg
QKUs+TL0qDJ3gG5S+X270D7F45kD4ao0Pmm0ygn+4IqK56jXoEvFIO+d6pY8h5Tn
68zam0r2NF3BOyCFTs41Dcbhtdny8X8Nk/fr6R57+CvavTgKXsqL02HMlfLEp73e
7XHqvdYxWKE=
=QCJf
-----END PGP SIGNATURE-----

--=-KrciiS4RpEGPUjkwyN1X--
