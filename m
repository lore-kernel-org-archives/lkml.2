Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1FPP1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:27:46 -0400
Received: from bohort.kerlabs.com ([90.80.97.101]:39925 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1FPP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:27:45 -0400
Date: Thu, 16 Jun 2011 17:27:33 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110616152733.GB15328@hawkmoon.kerlabs.com>
Mail-Followup-To: Greg Kurz <gkurz@fr.ibm.com>,
	Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
	ebiederm@xmission.com, containers@lists.osdl.org,
	akpm@linux-foundation.org, xemul@openvz.org
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615184625.GA15573@redhat.com> <1308222107.8230.49.camel@bahia.local> <20110616123554.GA7230@hawkmoon.kerlabs.com> <1308229251.8230.77.camel@bahia.local> <20110616132551.GB7230@hawkmoon.kerlabs.com> <1308236499.8230.89.camel@bahia.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-27127-1308237968-0001-2"
Content-Disposition: inline
In-Reply-To: <1308236499.8230.89.camel@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-27127-1308237968-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16/06/11 17:01 +0200, Greg Kurz wrote:
> On Thu, 2011-06-16 at 15:25 +0200, Louis Rilling wrote:
> > > Ok. You're right, the RCU grace period is just what I need to ensure
> > I
> > > won't dereference a stale pointer. So I don't even have to bother
> > with
> > > ->siglock and just check pid_alive() before peeking into
> > pid->numbers.
> >=20
> > It ends like open-coding an optimized version of task_pid_vnr(). If
> > the
> > optimization is really important (I guess this depends on the depth of
> > recursive
> > pid namespaces), it would be better to re-write task_pid_vnr().
> > Otherwise, just
> > use task_pid_vnr() as it is.
> >=20
> > Thanks,
> >=20
> > Louis
> >=20
> Hmm, sorry Louis but I'm looking for the pid number from the task active
> pid_ns (AKA. the return value of getpid() if called by this task), so
> task_pid_vnr() doesn't fit.

Yup, I should have somewhat recalled that _vnr() means "in the caller's pid
namespace". Sorry for the wrong argument.

>=20
> About the open-coding argument, that's why I used task_pid_nr_ns() and
> task_active_pid_ns() at first...

Sure. I still think that if you end accessing pid->numbers[pid->level].nr, =
then
you're close to coding some (optimized) task_active_pid_nr() that could als=
o be
used by getpid(), using some task_active_tgid_nr() instead of task_tgid_vnr=
().
Anyway, optimization is not a relevant point here AFAICS.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-27127-1308237968-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk36IOUACgkQVKcRuvQ9Q1QipgCeKhrkBcIpPtTwvxVkbxLNr4DQ
Ut4Anj1AyloYA+R4oRjivRBvcBb+zPv1
=Ay+q
-----END PGP SIGNATURE-----

--=_bohort-27127-1308237968-0001-2--
