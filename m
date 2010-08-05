Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab0HEMsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:48:40 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:39015 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab0HEMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:48:38 -0400
X-Spam-ASN: 
Date: Thu, 5 Aug 2010 16:48:29 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv3 15/16] pps: add parallel port PPS client
Message-ID: <20100805164829.33855c7a@desktopvm.lvknet>
In-Reply-To: <20100804163430.a87027c6.akpm@linux-foundation.org>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<5d5d3c3916cb79104160467035603093ea4f623f.1280952801.git.lasaine@lvk.cs.msu.su>
	<20100804163430.a87027c6.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/ZrCLF8NcsYL38XS0zaTvjX0"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZrCLF8NcsYL38XS0zaTvjX0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 4 Aug 2010 16:34:30 -0700
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu,  5 Aug 2010 01:06:52 +0400
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > Add parallel port PPS client. It uses a standard method for capturing
> > timestamps for assert edge transitions: getting a timestamp soon after
> > an interrupt has happened. This is not a very precise source of time
> > information due to interrupt handling delays. However, timestamps for
> > clear edge transitions are much more precise because the interrupt
> > handler continuously polls hardware port until the transition is done.
> > Hardware port operations require only about 1us so the maximum error
> > should not exceed this value. This was my primary goal when developing
> > this client.
> > Clear edge capture could be disabled using clear_wait parameter.
> >=20
> >
> > ...
> >
> > +
> > +#define SIGNAL_IS_SET(port) \
> > +	((port->ops->read_status(port) & PARPORT_STATUS_ACK) !=3D 0)
>=20
> This could (and hence should) be implemented in a regular old C
> function.

Ok, thanks!

> >
> > ...
> >
> > +{
> > +	struct pps_client_pp *device;
> > +	struct pps_source_info info =3D {
> > +		.name		=3D DRVNAME,
> > +		.path		=3D "",
> > +		.mode		=3D PPS_CAPTUREBOTH | \
> > +				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> > +				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
> > +				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
> > +		.echo		=3D pps_echo,
> > +		.owner		=3D THIS_MODULE,
> > +		.dev		=3D NULL
> > +	};
> > +
> > +	device =3D kzalloc(sizeof(struct pps_client_pp), GFP_KERNEL);
> > +	if (!device) {
> > +		pr_err(DRVNAME ": memory allocation failed, not attaching\n");
> > +		return;
>=20
> eww.  parport_driver.attach() returns void so there's no way to
> propagate the error code back.  That sucks a bit.

IMHO, the whole parport thing currently sucks quite a bit.

--=20
  Alexander

--Sig_/ZrCLF8NcsYL38XS0zaTvjX0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMWrMdAAoJEElrwznyooJbM0YH/iNEuNj+w9L+Po0tn5B85wiH
mViUR0lvJis+vk+ptX7WACLYeTk6+AQ9l5yVbQBC7cr6D9ra45KVvo+QdAcasc0h
4PEsQmBhZCnIKmTj5Zck2t8b83sORhfnF/58E9FB8/86VGHYQ1QwvCYhpviA5gIv
uTeWogOIP7SwhAXNlAlqa+aXf0qT3wBu0nhvwtZKdSvlMhAnRV9CXsDC+cMqppqP
S3LrTB9Iuq916/kEXiZYaZwl8hg0JFK3T2DG9xh/IpmsNdVHeeJFSIfVrjvN29IW
fCY+V1aiOEt7WLvSCFiKONIwBMprew6QdKaS91hZhLlckbFYRo8WYZKNunAdnNw=
=r0Tv
-----END PGP SIGNATURE-----

--Sig_/ZrCLF8NcsYL38XS0zaTvjX0--
