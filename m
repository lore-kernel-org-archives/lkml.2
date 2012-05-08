Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2EHUwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:52:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab2EHUwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:52:15 -0400
Date: Wed, 9 May 2012 06:52:02 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice
 level-triggered interrupts.
Message-ID: <20120509065202.3b3b0436@notabene.brown>
In-Reply-To: <alpine.LFD.2.02.1205041759540.6271@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.85239.stgit@notabene.brown>
	<alpine.LFD.2.02.1204251018530.2542@ionos>
	<20120425193916.0db1b4b1@notabene.brown>
	<alpine.LFD.2.02.1204251402360.2542@ionos>
	<20120504151221.6998d4e5@notabene.brown>
	<alpine.LFD.2.02.1205041759540.6271@ionos>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bnFpQlIocs+JsmTzCeWFC.M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bnFpQlIocs+JsmTzCeWFC.M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 May 2012 18:01:22 +0200 (CEST) Thomas Gleixner <tglx@linutronix.d=
e>
wrote:

> Neil,
>=20
> On Fri, 4 May 2012, NeilBrown wrote:
>=20
> > On Wed, 25 Apr 2012 14:54:54 +0200 (CEST) Thomas Gleixner
> > <tglx@linutronix.de> wrote:
> >=20
> > > Why not simply managing the pending bit for level irqs ?
> > >=20
> >=20
> > Hi Thomas,
> >  thanks again for the patch.  I finally made time to test it and it wor=
ks as
> > expected.  I've included it below with a change-log entry and tested-by:
> > in case that helps.
>=20
> thanks for testing. The changelog is great. You know how to make the
> live of lazy buggers easier :)

Just buttering you up so any future patches slip past easily :-)

I think I'll need to ask for IRQS_PENDING to be set for nested interrupts t=
oo
but I'll be a little while before  I an look at that issue properly and
propose a patch.

Thanks for your help,
NeilBrown



>  =20
> >  	for_each_irq_desc(irq, desc) {
> > -		if (irqd_is_wakeup_set(&desc->irq_data)) {
> > +		if (desc->depth =3D=3D 1 &&
> > +		    irqd_is_wakeup_set(&desc->irq_data)) {
> >  			if (desc->istate & IRQS_PENDING)
> >  				return -EBUSY;
> >  			continue;
>=20
> I split that part into a separate patch, as it's really a different
> issue.
>=20
> Thanks,
>=20
> 	tglx


--Sig_/bnFpQlIocs+JsmTzCeWFC.M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6mHcjnsnt1WYoG5AQL/gA//aM7YSRAL5BFJ0pGUY3tOvdIAobnkX3bl
f6sD/maT3YJFXQKm1vub+f6YQsPsYROiZAjZADRHXbkQe/SR+QrGLOX14KzoxUyd
Bw6OXhQb6oqwJMFLGTHrG3kCfJzQm4gcJ1DR6WNra97p2csRWc6NIr/twgSOA/P9
sEB1m+C94UMlRB4scdrlSePwDxyXHxcs+2Y8xT5OOGvBnKGGNzdYNDYUN50/rc1f
dthZOUfIQlDv1JDtfXX1uq4sC3ANTW6CXjJMU91ayhUdNWBCCiPjUCxMXxATGr2o
xA7GoGnCWrBg7Z/vpGkqqtkW7OKo45nB3C9H+GXiNkWFk8x4YwDlldQd5EO6AzaH
3osTizf4QoWL3KoQYJwp4ZBfU7qntQfWY6rIs6IMps1LHDYmpSyfIKslf3HTfycF
G+XrCNjsF6Qntxr7nuYcIkim0qOtJqZIPwGK/TPbIETfn4jKdnC60huPiZ79ggKx
ucRy+Bp2cIBJsnzForyNyDtagMbxMtfH9QPQuv+mQmE+ElihA5SLF7KIqKANX8EE
AWlMOAiyhrLOfQxvNiveXfW8mGrmq4grSaGcCbLB6KSK7MmbyNMFof6BE++eidHS
xGrz8nSwFzGHVM9Zw1aUz7fIltHfkTnLEfgUJ9Kw7vm1stI+v7OvyTszf3nrs8vO
gOZoSPny0Fk=
=2Uxf
-----END PGP SIGNATURE-----

--Sig_/bnFpQlIocs+JsmTzCeWFC.M--
