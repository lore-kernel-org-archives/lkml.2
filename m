Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2I1X2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:28:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59674 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758776Ab2I1X16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:27:58 -0400
Message-ID: <1348874861.6858.12.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 035/218] vfs: make O_PATH file descriptors usable for fstat()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?Q?=D0=BE=D0=BB=D1=8C=D0=B3=D0=B0_?=
	 =?UTF-8?Q?=D0=BA=D1=80=D1=8B=D0=B6=D0=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA?=
	 =?UTF-8?Q?=D0=B0=D1=8F?= <olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 29 Sep 2012 01:27:41 +0200
In-Reply-To: <20120928201505.430974605@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
	 <20120928201505.430974605@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cBAwHRrV0ifNsvDcuVXj"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cBAwHRrV0ifNsvDcuVXj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 13:14 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> commit 55815f70147dcfa3ead5738fd56d3574e2e3c1c2 upstream.
>=20
> We already use them for openat() and friends, but fstat() also wants to
> be able to use O_PATH file descriptors.  This should make it more
> directly comparable to the O_SEARCH of Solaris.
>=20
> Note that you could already do the same thing with "fstatat()" and an
> empty path, but just doing "fstat()" directly is simpler and faster, so
> there is no reason not to just allow it directly.
>=20
> See also commit 332a2e1244bd, which did the same thing for fchdir, for
> the same reasons.
>=20
> Reported-by: =D0=BE=D0=BB=D1=8C=D0=B3=D0=B0 =D0=BA=D1=80=D1=8B=D0=B6=D0=
=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA=D0=B0=D1=8F <olga.kryzhanovska@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The upstream version exchanges fget_light() for fget_raw_light().  Since
3.2 (and likewise 3.4) have fget() here, I cherry-picked e994def 'VFS:
make vfs_fstat() use f[get|put]_light()' before this.  Was that a
bad/good/neutral idea?

Ben.

> ---
>  fs/stat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -57,7 +57,7 @@ EXPORT_SYMBOL(vfs_getattr);
> =20
>  int vfs_fstat(unsigned int fd, struct kstat *stat)
>  {
> -	struct file *f =3D fget(fd);
> +	struct file *f =3D fget_raw(fd);
>  	int error =3D -EBADF;
> =20
>  	if (f) {

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-cBAwHRrV0ifNsvDcuVXj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGYybee/yOyVhhEJAQpsxA//Qm/eXfv3LsmQySuwezX64SEqoF7NRQ0c
0G0zV9td7HXfZ5wk+geu7rRoDfBdzJwItjfypAgEMx+ao3YAVN/FouKwjNmIJR0m
7F06zmSZlnyq9Z2mUSdpEH5z5pa5iRFvGyMMdmoch73wqVbZNROrqYoKrPU4x8Tr
4V2gccw5iHSGD3OyTDJbUkU+xEXQK7gYTz5uHpDfSbIyTom7Po78j6njIyHynXui
PpsFh4QN1i6iKn7/EgFpJX1cBxItVdsRuxzHMbhchiBDtAujvfQbrdYjuPx5kBXc
OZsUdw4q5GwP4S9/X/wI5UB/jhnvLNgnCv3roe63Ql46qGTXCDRaRoscNI6wL025
Qst/trj1aLfrGLijS4haF4yk027OydcNnQ/nl5xZEIU1ReUW0BVGri8UYnNieB5t
dGIRhb8Z1SDIR1+QalnafV7x9aGc4zoDr4U/E52qoDlYt/qKj2ZLs2wIWnPlrsR0
PqCSg+2GwZtVWyzLDFs9kvbvfSIECwZoW5ZmnA+DPPa7t/wBtZ6SWvRu+Imc84eY
E6gwK3LQVtHT8w79OdChvDb6L0f8b2++hhJgnJtJpCIEFatKR2IFK9EwbSpD/3iM
5Cs19vnDrzY44P+HY6td0H0ZiC2udOO20z3M8Xlh/FgBc+Tfks60eIHDY6cTJ15M
Czeab9N/PsE=
=v+1V
-----END PGP SIGNATURE-----

--=-cBAwHRrV0ifNsvDcuVXj--
