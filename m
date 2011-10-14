Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1JNQHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:07:36 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56089 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754250Ab1JNQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:07:34 -0400
Date: Fri, 14 Oct 2011 09:07:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        Koji Matsumuro <matsumur@nts.ricoh.co.jp>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Always check for lower base frequency quirk for
 Ricoh 1180:e823
Message-ID: <20111014090727.2ad3d774@jbarnes-desktop>
In-Reply-To: <20111005154449.GA2479@zod.bos.redhat.com>
References: <20111005154449.GA2479@zod.bos.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/i8BdW9ooG3Rup.N6E4PEV+k"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/i8BdW9ooG3Rup.N6E4PEV+k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Oct 2011 11:44:50 -0400
Josh Boyer <jwboyer@redhat.com> wrote:

> Commit 15bed0f2f added a quirk for the e823 Ricoh card reader to lower the
> base frequency.  However, the quirk first checks to see if the proprietary
> MMC controller is disabled, and returns if so.  On some devices, such as =
the
> Lenovo X220, the MMC controller is already disabled by firmware it seems,
> but the frequency change is still needed so sdhci-pci can talk to the car=
ds.
> Since the MMC controller is disabled, the frequency fixup was never being=
 run
> on these machines.
>=20
> This moves the e823 check above the MMC controller check so that it always
> gets run.
>=20
> This fixes https://bugzilla.redhat.com/show_bug.cgi?id=3D722509
>=20

Applied to linux-next, thanks.  I forgot to cc stable on it though;
once it hits Linus's tree you may want to make sure it gets backported
to 3.0.x and 3.1.x.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/i8BdW9ooG3Rup.N6E4PEV+k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOmF4/AAoJEIEoDkX4Qk9hrGgP/0pItQ8b1wKssBGHcjxpUkD2
mITCoZJvb4FBkRqn2x15nBKHyQThbssTXhRGZ1Ma396o5d7HHmbVvlphky1ip7hx
2Eg1+ZTcwyjE3ZD/krgb4kl6IY/uHEWfXb6/GLU4ZrPc6JYVBl9OjVS6ywyhD2Oo
vliGqwogUnEPQzpoC1QsrDRFLmYYiyofsQj5hzaNT37FBinSnRQ7SU48kvtAPyL4
4+QjFkbq0T68Psk/M1Xi/4yBj35uETMM/dSUe5AH4qepC4B7liWEoI0QYrmjQj2U
3nXeaiJaTMU/lqXWkUXYO9XEsSqglUfychcGZVMj8FVl50TVYZ9eQEhABtGZUS/x
SLXj7/jIayjDp2dV7/Cy7iMvbosfAinDI0RWVImUTYBSr8PoTV2Q1rIj+QjgtvnD
z0MgCamXWZz1uO8w8a4OnfLLQSp5Tfb/NpiJwXJgnjkWwoFNPPLgU9PpILdz16oy
xreK6I8Ar/azIxilXBLi5hw0cTxp314fY7NUBREJEpmS2A0V5Q9I/x1m/mfWGGFQ
Qcfa3dRtwk3wyZHSu1J0mmSW4ug5K+l6JoZNvbCf4AMLCkieqMBXkz71VuH00sbp
9yrMUqUao4AnzDMcjnHQHKfEnNtauWL3Uu1oceApcfZ6hCGzYog/bEKLUQhO6dVA
qKbkttfqaYHb0jA0OzEq
=cq2J
-----END PGP SIGNATURE-----

--Sig_/i8BdW9ooG3Rup.N6E4PEV+k--
