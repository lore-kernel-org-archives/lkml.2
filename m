Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1AFES0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:18:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55462 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab1AFESZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:18:25 -0500
Date: Thu, 6 Jan 2011 15:18:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the percpu tree
Message-Id: <20110106151815.9e5c2a1e.sfr@canb.auug.org.au>
In-Reply-To: <20110104051314.GA6748@mtj.dyndns.org>
References: <20110104152105.5cc7c3a9.sfr@canb.auug.org.au>
	<20110104051314.GA6748@mtj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Jan_2011_15_18_15_+1100_=L4SgHQHIKYoFWP4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jan_2011_15_18_15_+1100_=L4SgHQHIKYoFWP4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 4 Jan 2011 06:13:14 +0100 Tejun Heo <tj@kernel.org> wrote:
>
> On Tue, Jan 04, 2011 at 03:21:05PM +1100, Stephen Rothwell wrote:
> > After merging the percpu tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > arch/x86/kernel/cpu/mcheck/therm_throt.c: In function 'intel_thermal_in=
terrupt':
> > arch/x86/kernel/cpu/mcheck/therm_throt.c:368: error: implicit declarati=
on of function 'this_cpu_has'
> >=20
> > Caused by commit 6ac0bb7148b93fb40bccba5dff06d51a3e3ea283 ("x86: use
> > this_cpu_has for thermal_interrupt").
> >=20
> > this_cpu_has() does not exist anywhere except in this introduced usage.
> >=20
> > I have used the percpu tree from next-20101231 for today.
>=20
> My apologies.  I forgot an earlier patch to introduce this_cpu_has()
> macro.  I've reverted the offending commit.

But that revert is not in your published for-next branch yet.  I have
manually reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Jan_2011_15_18_15_+1100_=L4SgHQHIKYoFWP4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJUKHAAoJEDMEi1NhKgbsi0IIAJ4wl3B0O/gRcrms4rTXKT+v
BRY2sjLFJ898QbFhYyKicaovioM3RWJu4aO9PtLUpAbFF1X7VFhmfQixl/TfIteP
h14KryAoS/YgS9er5vWtKbMlMjwGpQ5pg53des5SwKVdzU1FpK1c9e1LUNBkP0AD
kOCJqCe3pdSyxaqGvoV+G7GeAoLWKCPt9hZFYltDhJYRevITSRC7S78vLW3C6y2D
gPeJgs2ZYnTuNmsfOEZk6vjrYRB70sLPjUWIidg8+34cZ1HljBqBB+e0o4i53K4O
sjPhSixMHstgFiVfqzeXBIDob/DOKdSrbWFSKWqN281k+JxkFlbvVfbRGrBT6Ms=
=EuyS
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jan_2011_15_18_15_+1100_=L4SgHQHIKYoFWP4--
