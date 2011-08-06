Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1HFTk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 15:40:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52042 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab1HFTkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 15:40:25 -0400
Date: Sat, 6 Aug 2011 22:39:14 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: select_task_rq_fair: WARNING: at kernel/lockdep.c match_held_lock
Message-ID: <20110806193914.GA4008@swordfish>
References: <20110804141306.GA3536@swordfish.minsk.epam.com>
 <1312470358.16729.25.camel@twins>
 <20110804153752.GA3562@swordfish.minsk.epam.com>
 <1312472867.16729.38.camel@twins>
 <20110804155347.GB3562@swordfish.minsk.epam.com>
 <1312547780.28695.1.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1312547780.28695.1.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/05/11 14:36), Peter Zijlstra wrote:
> The below is what I've come up with.
>

Hello,
Without any problems so far (using qemu quite often these days).=20
Feel free to add my
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	Sergey

=20
> ---
> Subject: lockdep: Fix wrong assumption in match_held_lock
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Aug 05 14:26:17 CEST 2011
>=20
> match_held_lock() was assuming it was being called on a lock class
> that had already seen usage.=20
>=20
> This condition was true for bug-free code using lockdep_assert_held(),
> since you're in fact holding the lock when calling it. However the
> assumption fails the moment you assume the assertion can fail, which
> is the whole point of having the assertion in the first place.
>=20
> Anyway, now that there's more lockdep_is_held() users, notably
> __rcu_dereference_check(), its much easier to trigger this since we
> test for a number of locks and we only need to hold any one of them to
> be good.
>=20
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/lockdep.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> Index: linux-2.6/kernel/lockdep.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -3111,7 +3111,13 @@ static int match_held_lock(struct held_l
>  		if (!class)
>  			class =3D look_up_lock_class(lock, 0);
> =20
> -		if (DEBUG_LOCKS_WARN_ON(!class))
> +		/*
> +		 * If look_up_lock_class() failed to find a class, we're trying
> +		 * to test if we hold a lock that has never yet been acquired.
> +		 * Clearly if the lock hasn't been acquired _ever_, we're not
> +		 * holding it either, so report failure.
> +		 */
> +		if (!class)
>  			return 0;
> =20
>  		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
>=20

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk49mGIACgkQfKHnntdSXjSVoQP/SskLl5es7BEGMx0zahr9K6lS
PmKjXqwlqqCcAXb7V2V9SWyPQ+D256wDHQUcgh3B1EcbON/p7GduIpe3LAHG1PFN
srWrbmHOoi5cM0YPAYDMc2n2w5JvWuHYxIt24TS2a2/zTqNoPIR1e8EPmjuSfDRF
RLhTqEBwWQSiWeHRJQ8=
=HXc2
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
