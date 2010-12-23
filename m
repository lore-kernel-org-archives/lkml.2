Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0LWNRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:17:52 -0500
Received: from ms01.sssup.it ([193.205.80.99]:33553 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752717Ab0LWNRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:17:51 -0500
Subject: Re: Sending some form of notifaction when sched_fifo throttling
 kicks in...
From: Dario Faggioli <raistlin@linux.it>
To: torbenh <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20101223113926.GH14960@siel.b>
References: <20101223113926.GH14960@siel.b>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zzgdzrh6Z2wZ3hPlpwwF"
Date: Thu, 23 Dec 2010 14:17:37 +0100
Message-ID: <1293110258.3390.41.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zzgdzrh6Z2wZ3hPlpwwF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-12-23 at 12:39 +0100, torbenh wrote:=20
> hi...
>=20
Hi,

> when the rt_runtime budget is exceeded, the kernel silently stops
> scheduling RT tasks. there is no way to distinguish this from=20
> a task taking very long to complete.
>=20
Well, this depends on how you do the accounting in your (user-level)
code.

> it would be very nice, if the kernel would send some form of notifaction
> when it starts throttling things.
>=20
This might be tricky, if the meaning is signals or something to the
throttled tasks, since you can have a (or more!) runqueue full of
them... Are we signalling them all? Moreover, they'll get the
notification only after resuming, and it's not guaranteed that this
helps in finding out who is "responsible for" the throttling and... By
the way...

> recording the timestamp of the last occurence of throttling
> in a /proc file would be sufficient, if there were no cgroups.
>=20
> would it be possible to add a readonly property to the cpu subsystem ?
>
... If you think you're fine with some /proc (and perhaps cpuacct, if
cgroups are being used) readable, I can try to come up with something.

I think that the number of times that throttling fired and the last
throttling instant could be exported this way without much issues.

Do others have some idea and/or comments about that? This is
ABI/interface, and that really scares me! :-P

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-Zzgdzrh6Z2wZ3hPlpwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0TS/EACgkQk4XaBE3IOsTBagCfQ4EUw70ITrpr784gTx81Nc2r
vMEAnR8SBI/PBaz7T61ecUEa7j4YsE7X
=5xjs
-----END PGP SIGNATURE-----

--=-Zzgdzrh6Z2wZ3hPlpwwF--

