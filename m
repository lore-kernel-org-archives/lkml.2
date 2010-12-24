Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0LXQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 11:40:49 -0500
Received: from virgo.iok.hu ([212.40.97.103]:36779 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab0LXQkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 11:40:47 -0500
Date: Fri, 24 Dec 2010 17:40:43 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, shenghui <crosslonelyover@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Greg KH <greg@kroah.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] sched, cgroup: Use exit hook to avoid use-after-free
 crash
Message-ID: <20101224164043.GA10557@genesis.frugalware.org>
References: <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
 <1293106330.2170.618.camel@laptop>
 <1293107624.2170.642.camel@laptop>
 <1293128670.2170.748.camel@laptop>
 <1293132304.6798.6.camel@marge.simson.net>
 <1293132862.25981.22.camel@laptop>
 <1293187425.7138.2.camel@marge.simson.net>
 <1293188091.25981.200.camel@laptop>
 <1293192999.18035.4.camel@marge.simson.net>
 <1293206353.29444.205.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9lH2i8s2YEs6mH7"
Content-Disposition: inline
In-Reply-To: <1293206353.29444.205.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R9lH2i8s2YEs6mH7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Subject: sched, cgroup: Use exit hook to avoid use-after-free crash
>=20
> By not notifying the controller of the on-exit move back to
> init_css_set, we fail to move the task out of the previous cgroup's
> cfs_rq. This leads to an opportunity for a cgroup-destroy to come in and
> free the cgroup (there are no active tasks left in it after all) to
> which the not-quite dead task is still enqueued.
>=20
> Cc: stable@kernel.org
> Reported-by: Miklos Vajna <vmiklos@frugalware.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

Thanks! :)

Reported-and-tested-by: Miklos Vajna <vmiklos@frugalware.org>

--R9lH2i8s2YEs6mH7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0UzQsACgkQe81tAgORUJblcgCdHzQ5v5Vm7NagiMqgkY640ZMu
o4wAoJyhLT2sIkJKQsHBLUeO2m1j7rhY
=6H09
-----END PGP SIGNATURE-----

--R9lH2i8s2YEs6mH7--
