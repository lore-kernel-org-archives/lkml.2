Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0HRBA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:00:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44398 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab0HRBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:00:55 -0400
Date: Wed, 18 Aug 2010 11:00:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Fix AppArmor build warnings after merge of the
 security-testing tree
Message-Id: <20100818110047.3fd21e1a.sfr@canb.auug.org.au>
In-Reply-To: <20100818105609.642a5e61.sfr@canb.auug.org.au>
References: <20100802121601.363af4a9.sfr@canb.auug.org.au>
	<4C57819F.4000405@canonical.com>
	<20100818105609.642a5e61.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Aug_2010_11_00_47_+1000_Oq=aFslis_sx=t+x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Aug_2010_11_00_47_+1000_Oq=aFslis_sx=t+x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, 18 Aug 2010 10:56:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 02 Aug 2010 19:40:31 -0700 John Johansen <john.johansen@canonical=
.com> wrote:
> >
> > From: John Johansen <john.johansen@canonical.com>
> > Date: Mon, 2 Aug 2010 19:31:57 -0700
> > Subject: [PATCH] AppArmor: Fix build warnings from linux-next merge
> >=20
> > Patch AppArmor to fix build warnings for changes that exist in the
> > linux-next tree.
> >=20
> > Signed-off-by: John Johansen <john.johansen@canonical.com>
> 	.
> 	.
> > diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> > index d5666d3..f56978a 100644
> > --- a/security/apparmor/lsm.c
> > +++ b/security/apparmor/lsm.c
> > @@ -607,9 +607,11 @@ static int apparmor_setprocattr(struct task_struct=
 *task, char *name,
> >  	return error;
> >  }
> > =20
> > -static int apparmor_task_setrlimit(unsigned int resource,
> > +static int apparmor_task_setrlimit(struct task_struct *tsk,
> > +				   unsigned int resource,
> >  				   struct rlimit *new_rlim)
> >  {
> > +	/* Use current profile instead of profile on @tsk */
> >  	struct aa_profile *profile =3D aa_current_profile();
> >  	int error =3D 0;
>=20
> This last change seems to have been lost along the way.

Sorry, my mistake, this change is sitting in the security-testing tree in
linux-next still.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__18_Aug_2010_11_00_47_+1000_Oq=aFslis_sx=t+x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMazC/AAoJEDMEi1NhKgbs7E4H/jjf7qWrBOmOBGC6ayhFzHZQ
pGu3BSBPo1yDVvp6Ds/msfVEdSlHuUWS8t5VMuXi36awmf3y7aWHk89AVil4Nsuw
Rh0idMR/jI08Ps8SWcgimxAZ0psCLDZ+XKGqOhLJ5y9RQmAl880oLkkmNWJS+qm2
XVLbs4xxS1k108LyeSMCCRxg9Rdj55lB0RfdypPImPPKbaALeAeYGbNKoLFQHCR2
QCDtWYW7hO7ruJ9pPAEpErumUx4F2fkJzEsLgsHD8QjtDXZikY4sjYehKcuT/YCd
1IGFX8MxT3nF9kKR0m+xNFnq+32Ed/WQXFQ5uug2jDKVx8W1l0uXndxvbvAlgqM=
=90A8
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Aug_2010_11_00_47_+1000_Oq=aFslis_sx=t+x--
