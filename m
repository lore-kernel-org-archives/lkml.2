Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2DGHqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 03:46:53 -0400
Received: from ms01.sssup.it ([193.205.80.99]:55615 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008Ab2DGHqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 03:46:52 -0400
Message-ID: <1333784800.3170.4.camel@Abyss>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Dario Faggioli <raistlin@linux.it>
To: Hillf Danton <dhillf@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fcheccon@jasper.es
Date: Sat, 07 Apr 2012 09:46:40 +0200
In-Reply-To: <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	 <4F7F285A.1010703@gmail.com>
	 <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
Face: 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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Th/2Mcw/CiIEyR20FeUr"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Th/2Mcw/CiIEyR20FeUr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-07 at 10:32 +0800, Hillf Danton wrote:=20
> On Sat, Apr 7, 2012 at 1:31 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
> >>>
> >>>  kernel/sched_dl.c |  912
> >>>  kernel/sched_rt.c |    2 +-
>=20
> You are working on 2.6.3x, x <=3D 8 ?
>
Not really. Why saying so? :-O

> If so, what is the reason(just curious)?
> Already planned to add in 3.3 and above?
>
The n.0 mail of this series "[RFC][PATCH 00/16] sched: SCHED_DEADLINE
v4" says:
<<  - this time we sit on top of PREEMPT_RT (3.2.13-rt23); we continue
      to aim at mainline inclusion, but we also see -rt folks as
      immediate and interested users.

    ...

    As said, patchset is on top of PREEMPT_RT (as of today). However,
    Insop Song (from Ericsson) is maintaining a parallel branch for the
    current tip/master (https://github.com/insop/sched-deadline2).>>

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://retis.sssup.it/people/faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)



--=-Th/2Mcw/CiIEyR20FeUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk9/8OAACgkQk4XaBE3IOsSr7QCffTU6T9lLiKehqGLc79r56SEs
0O0An0ZWTORiH2D6/SsFvh1c4u4B/ejb
=dKka
-----END PGP SIGNATURE-----

--=-Th/2Mcw/CiIEyR20FeUr--

