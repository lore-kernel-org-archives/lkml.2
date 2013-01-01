Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3AAOVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 09:21:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab3AAOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 09:21:04 -0500
Message-ID: <1357050056.31299.10.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 032/173] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 01 Jan 2013 14:20:56 +0000
In-Reply-To: <87vcbh112s.wl%satoru.takeuchi@gmail.com>
References: <20121228190330.025298996@decadent.org.uk>
	 <20121228190336.653264206@decadent.org.uk>
	 <87vcbh112s.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RpKa2nAXq8KutnXrwKlJ"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RpKa2nAXq8KutnXrwKlJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-01 at 22:31 +0900, Satoru Takeuchi wrote:
> Hi Ben,
>=20
> At Fri, 28 Dec 2012 20:04:02 +0100,
> Ben Hutchings wrote:
> >=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Tejun Heo <tj@kernel.org>
> >=20
> > commit 5edee61edeaaebafe584f8fb7074c1ef4658596b upstream.
[...]
> I failed to compile 3.2.36-rc1 with my x86_64 box with enabling cgroup.
>=20
> build log:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> ...
>   CC      kernel/cgroup.o
> kernel/cgroup.c: In function =E2=80=98cgroup_post_fork=E2=80=99:
> kernel/cgroup.c:4540:5: warning: passing argument 1 of =E2=80=98ss->fork=
=E2=80=99 from incompatible pointer type [enabled by default]
> kernel/cgroup.c:4540:5: note: expected =E2=80=98struct cgroup_subsys *=E2=
=80=99 but argument is of type =E2=80=98struct task_struct *=E2=80=99
> kernel/cgroup.c:4540:5: error: too few arguments to function =E2=80=98ss-=
>fork=E2=80=99
> make[2]: *** [kernel/cgroup.o] Error 1
> make[1]: *** [kernel] Error 2
> make[1]: Leaving directory `/home/sat/src/linux-stable'
> make: *** [debian/stamp/build/kernel] Error 2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> It comes from the ss->fork()'s API change introduced by commit 761b3ef50e=
1c2.
[...]
> I found you mentioned this difference in the desctiption as follows.
>=20
> >  - cgroup_subsys::fork takes cgroup_subsys pointer as first parameter]
>=20
> I guess you attached the wrong patch, or you forgot to modify the
> original patch. Here is the correct patch for the latter case. It just
> change "ss->fork(child)" to "ss->fork(ss, child)" as your description.
[...]

The correct version is in the combined patch, but I somehow missed
refreshing this individual patch.  Thanks for pointing this out.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-RpKa2nAXq8KutnXrwKlJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUOLwyOe/yOyVhhEJAQqClBAAhXItN2YYFfDRXuxqwulFnTO24o8FN4e1
4RO1lDL6LIuHTVl1G4omVz6L48qgOM1MrjYd0nFMLfzyscEXTzvx2FuGgT0FXRz1
FNB3WZmwDnC9ysA63/f4MlX86Tgv9jXNIbDzioc2HalsCuSVE8n9nP8D49b7yCxb
uhmaz56pSLmnPXipfCMk52/8LCsAiAD3vvlw7vdGrMs59Ek9qt/Ngo608NVH07Xd
dA8gSm7OOld6Jxn6XZF0LRJCCQJb5IQ7tFBy7TkbiV7wdIgSA0Ds3bi5yYYvCkZm
W/u6tY2E/DyB6EHZGFevlFz247cUO+aFHoxKuQztq4GCCo0DK2bKg44fV9EGJuXv
SNXXHmbk3py1YWa53BC8hJxS93lhbi1aSRV/turhK2oPI4lJdU6fFuBiKjZXElQc
jApAcVVJ6VaqpczPwaLGsYu/B9zmNSoViFKHvxU6QwwIignaR/7s635DM5d3IXzN
KgXY5Y1PC9szo6dqbSM4tBeKvYqIOOct/tpxXJhQ6s4ynvos+AXut2eXLpjDem4E
o1FxRnbawT44JrqnO4VsEUkZiXI3qVsv3j+OWDWntbs0PUYbWHcfi0pf2mPRkg/e
mPviHlNoY3g4/7pbBWrsswz5EB4rcQEk58sQ1TK6mYgvllxgHMGlreezAr4ei5GO
ruC6xDDDBdE=
=WiCI
-----END PGP SIGNATURE-----

--=-RpKa2nAXq8KutnXrwKlJ--
