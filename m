Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2ESNLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:11:31 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48137 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751770Ab2ESNLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:11:30 -0400
Message-ID: <1337433062.7075.9.camel@Abyss>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Dario Faggioli <raistlin@linux.it>
To: Colin Cross <ccross@android.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Date: Sat, 19 May 2012 15:11:02 +0200
In-Reply-To: <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	 <1337331395.573.3.camel@twins>
	 <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
	 <1337366237.573.106.camel@twins>
	 <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/gl7RhcQZWhQfM/N/PWD"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/gl7RhcQZWhQfM/N/PWD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-18 at 17:13 -0700, Colin Cross wrote:=20
> Even with this patch, scheduling of SCHED_RR tasks in cgroups is a
> little odd.  Each cgroup is treated as a schedulable entity alongside
> the tasks in the same parent cgroup, and then the tasks inside the
> child cgroup round robin through the child cgroup's time slices.  So
> in the setup:
> root_cgroup
>    task 1
>    cgroup
>       task 2
>       task 3
>=20
> The RR will be:
> task 1, cgroup(task 2), task 1, cgroup(task 3), ...
>=20
> task 1 will run twice as often, for a full RR_TIMESLICE each time, as
> tasks 2 and 3.
>=20
That looks right to me...

> Is that the way SCHED_RR is intended to interact with cgroups?
>
I would say it is. That's what you get because of putting task1 and
cgroup at the same level in the "hierarchy". I'm curious, what kind of
behaviour were you expecting?

Of course, the actual schedule also depends on the real-time priority of
the various tasks (groups don't have a priority, they inherit it from
their tasks, or at least it was like this when I used to work with
it :-P), but I guess you're putting all the tasks in the same queue
(i.e., same rt-prio), is it that the case?

Dario

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://retis.sssup.it/people/faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://retis.sssup.it/people/faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)



--=-/gl7RhcQZWhQfM/N/PWD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+3m+YACgkQk4XaBE3IOsTFkgCfS9eSjo3fl1g4MyevR/wPyMQR
iT8An0Pz9ppMXX/zo+PWvPdGtZbfTfWI
=TI1Z
-----END PGP SIGNATURE-----

--=-/gl7RhcQZWhQfM/N/PWD--

