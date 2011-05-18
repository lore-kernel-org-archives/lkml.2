Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1ERSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:09:59 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56337 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab1ERSJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:09:58 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of memory for drivers
Date: Wed, 18 May 2011 20:09:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5-tp42-snap-debug+resv-size-dirty; KDE/4.6.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105100059.25372.rjw@sisk.pl> <201105150056.55601.rjw@sisk.pl> <20110518172717.GA5734@elf.ucw.cz> (sfid-20110518_200202_152055_05CC21F2)
In-Reply-To: <20110518172717.GA5734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6467563.Ap0r3smVlW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105182009.55813.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6467563.Ap0r3smVlW
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, 18. Mai 2011 schrieb Pavel Machek:
> Hi!
>=20
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > Martin reports that on his system hibernation occasionally fails
> > > due to the lack of memory, because the radeon driver apparently
> > > allocates too much of it during the device freeze stage.  It turns
> > > out that the amount of memory allocated by radeon during
> > > hibernation (and presumably during system suspend too) depends on
> > > the utilization of the GPU (e.g. hibernating while there are two
> > > KDE 4 sessions with compositing enabled causes radeon to allocate
> > > more memory than for one KDE 4 session).
> > >=20
> > > In principle it should be possible to use image_size to make the
> > > memory preallocation mechanism free enough memory for the radeon
> > > driver, but in practice it is not easy to guess the right value
> > > because of the way the preallocation code uses image_size.  For
> > > this reason, it seems reasonable to allow users to control the
> > > amount of memory reserved for driver allocations made after the
> > > preallocation, which currently is constant and amounts to 1 MB.
> > >=20
> > > Introduce a new sysfs file, /sys/power/reserved_size, whose value
> > > will be used as the amount of memory to reserve for the
> > > post-preallocation reservations made by device drivers, in bytes.
> > > For backwards compatibility, set its default (and initial) value to
> > > the currently used number (1 MB).
> > >=20
> > > References: https://bugzilla.kernel.org/show_bug.cgi?id=3D34102
> > > Reported-by: Martin Steigerwald <Martin@Lichtvoll.de>
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >=20
> > OK, there are no comments, so my understanding is that everyone is
> > fine with this patch and I can add it to my linux-next branch.
>=20
> Actually no, I don't like it. Yes, knob might be useful for debugging,
> but having it as part of official kernel interface...

Well I and people with similar setups it is actually quite useful. It=20
makes the difference between does hibernate *every time* versus does not=20
hibernate sometimes. And I don't see why it can't go again, when the issue=
=20
is taken care of elsewise in the future. I think that autotuning / drivers=
=20
allocating their memory via whatnot is better, but until such a mechanism=20
is agreed, developed and included in official kernel I do think that this=20
knob does help.

So or so I will patch this in for the kernels for my ThinkPad T42, whether=
=20
its part of the official kernel or not. And I build my own kernels anyway.=
=20
So when described issue really only happens on my setup and nowhere=20
else...

I think missing is some documentation so that the advanced user can figure=
=20
out this knob.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart6467563.Ap0r3smVlW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3UC2sACgkQmRvqrKWZhMc1WgCfUKdKpMycFTloDAkyFKNng4p+
RuEAoKGugI/YsMNh1Zj4+y0dl04akJuz
=B+vn
-----END PGP SIGNATURE-----

--nextPart6467563.Ap0r3smVlW--
