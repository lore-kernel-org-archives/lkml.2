Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639Ab2FVR6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:58:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2FVR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:58:16 -0400
Date: Fri, 22 Jun 2012 10:58:09 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] eCryptfs: Gracefully refuse miscdev file ops on
 inherited/passed files
Message-ID: <20120622175808.GA24984@boyd>
References: <1338061161.4284.16.camel@lappy>
 <1339545940-11736-1-git-send-email-tyhicks@canonical.com>
 <1339545940-11736-2-git-send-email-tyhicks@canonical.com>
 <CA+1xoqeJ8j5Dp1C6QtEvHhQVcVUKsCVCGhXVcceH9b669nEYAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CA+1xoqeJ8j5Dp1C6QtEvHhQVcVUKsCVCGhXVcceH9b669nEYAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-06-22 19:47:35, Sasha Levin wrote:
> On Wed, Jun 13, 2012 at 2:05 AM, Tyler Hicks <tyhicks@canonical.com> wrot=
e:
> > File operations on /dev/ecryptfs would BUG() when the operations were
> > performed by processes other than the process that originally opened the
> > file. This could happen with open files inherited after fork() or file
> > descriptors passed through IPC mechanisms. Rather than calling BUG(), an
> > error code can be safely returned in most situations.
> >
> > In ecryptfs_miscdev_release(), eCryptfs still needs to handle the
> > release even if the last file reference is being held by a process that
> > didn't originally open the file. ecryptfs_find_daemon_by_euid() will not
> > be successful, so a pointer to the daemon is stored in the file's
> > private_data. The private_data pointer is initialized when the miscdev
> > file is opened and only used when the file is released.
> >
> > https://launchpad.net/bugs/994247
> >
> > Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
> > Reported-by: Sasha Levin <levinsasha928@gmail.com>
> > Cc: Sasha Levin <levinsasha928@gmail.com>
> > ---
>=20
> I've been running it a while now and haven't seen the problem I've
> reported reproducing.

Thanks for the testing!

>=20
> Is it possible to merge this fix into 3.5?

That's my plan. I'll target this bug fix and the 2nd patch that removes
unused code for 3.5. I'll wait for 3.6 to merge the third patch.

Tyler

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJP5LIwAAoJENaSAD2qAscKdPgP/RKsLw6qzT3TNBGYbtsqAM/k
bDViFcLvHS1ZdcPRh5XFFadFBuoZtqdNrpWhQfTDvQUDadzgUQLbPUiXGgspvXS5
F1Nderj+nG/uvXDMaUXm9E5CW/kF5gMJ5Vs7Y1mvypkT01VNdfeSvFUROT097Vot
RopVNU/zxyM+MUzs20Iyvdy6h7H0GeiKfaCLHxA5T+4XR1Y1IUjuxfqpdhWF+KsQ
SudbrfrKT/eNhNOlBb07xsotTn4PxXUuIMQKROs78twP1dJnvPIog2hThR8HRbPD
ewbn8jDHudEpKherzPmUSOVf+FxWkQmyyZMO1LBAdoHQ3EgEKaoc9vSsPvJtXMdz
xVJoAtMDJyRWqs/2gE5TiKjlwlJQqBCYCZ4GiJmoXZNmdKfX4Cr61X+FzOXpo6C2
9kRfy7umw1nkTEJGQ0ZcRDdif45MOijElda+EsQFy6AL+LnJy/08qKMTecIE7/T7
JsWCJoF0Zs/H557UYf01cNYtUIgPtVrZIaQtFwEU6PWqJmJkWfypCRkQwcV4WHN6
u+RkDbNdWFU7aU+pAMtawHZ+HnuyoHb2XeUU07s3BCqfhSMel/4QE9iBPGVs5QKP
VFSxTJMZbaI9lbect1us5plNsk9cIJnyTUgP1qT/cpkanj/iDPsEmDYsLx20v+As
kHNy8UH+4mxB7ymDHkSF
=XSiX
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
