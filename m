Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2IPPuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 11:50:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57979 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab2IPPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 11:49:59 -0400
Message-ID: <1347810587.13258.279.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable] workqueue: UNBOUND -> REBIND morphing in
 rebind_workers() should be atomic
From: Ben Hutchings <ben@decadent.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Sun, 16 Sep 2012 16:49:47 +0100
In-Reply-To: <20120904235812.GA2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
	 <1346516916-1991-2-git-send-email-laijs@cn.fujitsu.com>
	 <20120904233901.GC9092@dhcp-172-17-108-109.mtv.corp.google.com>
	 <20120904235812.GA2836@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ubLk9UOtOd7cw3rJamOK"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ubLk9UOtOd7cw3rJamOK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-04 at 16:58 -0700, Tejun Heo wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>=20
> The compiler may compile the following code into TWO write/modify
> instructions.
>=20
>         worker->flags &=3D ~WORKER_UNBOUND;
>         worker->flags |=3D WORKER_REBIND;
>=20
> so the other CPU may temporarily see worker->flags which doesn't have
> either WORKER_UNBOUND or WORKER_REBIND set and perform local wakeup
> prematurely.
>=20
> Fix it by using single explicit assignment via ACCESS_ONCE().
>=20
> Because idle workers have another WORKER_NOT_RUNNING flag, this bug
> doesn't exist for them; however, update it to use the same pattern for
> consistency.
>=20
> tj: Applied the change to idle workers too and updated comments and
>     patch description a bit.
>=20
> stable: Idle worker rebinding doesn't apply for -stable and
>         WORKER_UNBOUND used to be WORKER_ROGUE.  Updated accordingly.
[...]

Added to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-ubLk9UOtOd7cw3rJamOK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFX1G+e/yOyVhhEJAQrPkhAA0V6RtM+9fG4rtil1Ljfl3hQ5OCjud0nR
pr7cNOefVxwwA5dau8w8df/zWHI3D2TnU9tObkDg8jbXiJklCFceC9Ew2ehv9jW9
WaNVa3QGCJnEC3f6U8IvpwbsDjcdhrvBa1eQdRyjnAHKYZUDQkWUTMI6z3IpQArP
7UPdkqz23loNrA5H8ACtou2F0EJPPtJKbkpvlF26eExUXApwxEPFm/+oqo0uB7eU
dxiQM8hc/IUNayLzrDh1Pyyw5zVcdmIyO4LpBjkkaT/lLYx7Ap2HCyAl4Twv4p0w
QfJLKwFnl5CTFKGOC0qxQIP9Wvn+0reR/R0wrQVALtw5FAdPpFxvwXvJQNSDukHB
Ru0N1vFPGI6AySeA6s4X7Eh1tZEFTeOe49wPyNWh6FTe4MS6flByl1i6WdnoAQLG
SxBXuRADe/91RKIrhm3fC81DUuJJkmtoTlbfjZQzXi39/Nt9bN0op+WqJt6+84MD
X0u8z2lLQt/7zimuYtmZSuG+gNd2q812ezBESgeUmRkzk7bExvE3qpa1NBvLFAw+
5/FWDM/ILmxmIl8dZ4r1rWPuY1TMRN46odXfQkHMh3+z1s1OK6XVd7WVCfUT3CdK
ucKEsphN26eEGPSRKdZreMWUOFI9wqCG4/Lm0zQ/m1nIWKO/WP8dZwkU5GB9PWCB
rHA1dkUjkPQ=
=X545
-----END PGP SIGNATURE-----

--=-ubLk9UOtOd7cw3rJamOK--
