Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2EWNcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:32:46 -0400
Received: from ms01.sssup.it ([193.205.80.99]:59907 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759718Ab2EWNco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:32:44 -0400
Message-ID: <1337779944.27368.94.camel@Solace>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Dario Faggioli <raistlin@linux.it>
To: Colin Cross <ccross@android.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Date: Wed, 23 May 2012 15:32:24 +0200
In-Reply-To: <CAMbhsRQYgOQA7NB-mdMDi8GxtTaZDQhED2J2X9YmyiYjAzXx4w@mail.gmail.com>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	 <1337331395.573.3.camel@twins>
	 <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
	 <1337366237.573.106.camel@twins>
	 <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
	 <1337433062.7075.9.camel@Abyss>
	 <CAMbhsRQYgOQA7NB-mdMDi8GxtTaZDQhED2J2X9YmyiYjAzXx4w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WuQboxs6F99tTFSJXM3E"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WuQboxs6F99tTFSJXM3E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-19 at 13:37 -0700, Colin Cross wrote:
> > I would say it is. That's what you get because of putting task1 and
> > cgroup at the same level in the "hierarchy". I'm curious, what kind of
> > behaviour were you expecting?
>=20
> That behavior matches exactly with scheduling of normal tasks and
> cgroups with default cpu.shares, but doesn't match too well with what
> I can see of the posix SCHED_RR description, which suggests all the
> SCHED_RR threads go into a single queue.  I was just curious if the
> behavior my patch restored was correct, since it can't be adjusted by
> tweaking any parameters like cpu.shares.
>=20
Again, I really think it is the intended behaviour, and yes, real-time
group scheduling "breaks" the POSIX specification of the SCHED_{FIFO,RR}
policies intentionally (and _proudly_, as Peter would say it, am I
wrong? :-P).

Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://retis.sssup.it/people/faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-WuQboxs6F99tTFSJXM3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+85ugACgkQk4XaBE3IOsRcKwCeMXa8PZEIRblI1J5IpgLTCbT4
ZxgAn3LlICgHW7Oe+ryICGEgSPAujCmG
=nmYa
-----END PGP SIGNATURE-----

--=-WuQboxs6F99tTFSJXM3E--

