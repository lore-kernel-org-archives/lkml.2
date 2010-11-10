Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0KJBps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:45:48 -0500
Received: from ozlabs.org ([203.10.76.45]:42490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KJBps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:45:48 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTin_VixECn4AdQW_xC=_5ZNY5wBsif6cW5dDEJFe@mail.gmail.com>
References: <1289339119.2191.92.camel@laptop>
	 <20101109221338.GA19947@suse.de> <1289345811.10536.8.camel@concordia>
	 <AANLkTi=UftgQn0ydRd2wszqFtpRrkEcW7dzfapKKix_V@mail.gmail.com>
	 <1289350360.22787.9.camel@concordia>
	 <AANLkTikGHNkUN6t9rPhdE6XOQiqb5xAzH_9eY6L9h2H2@mail.gmail.com>
	 <1289351423.22787.22.camel@concordia>
	 <AANLkTin_VixECn4AdQW_xC=_5ZNY5wBsif6cW5dDEJFe@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-750ChZgWq/OAcNBN+EUX"
Date: Wed, 10 Nov 2010 12:45:44 +1100
Message-ID: <1289353544.22787.49.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-750ChZgWq/OAcNBN+EUX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 02:19 +0100, Kay Sievers wrote:
> On Wed, Nov 10, 2010 at 02:10, Michael Ellerman <michael@ellerman.id.au> =
wrote:
> > On Wed, 2010-11-10 at 01:57 +0100, Kay Sievers wrote:
> >> Stay on the list please, with any possible reply. Thanks!
> >
> > You dropped the CC when you replied, or is my mailer being weird?
>=20
> You replied to me only:
>   From: Michael Ellerman <michael@ellerman.id.au>
>   To: Kay Sievers <kay.sievers@vrfy.org>

Because you replied to me only, or at least that's what I see at my end.

> >> On Wed, Nov 10, 2010 at 01:52, Michael Ellerman <michael@ellerman.id.a=
u> wrote:
> >> > On Wed, 2010-11-10 at 00:45 +0100, Kay Sievers wrote:
> >> The pseudo-convenience device_register/device_unregister should also
> >> not be used.
> >
> > Why are they in the tree if they shouldn't be used?
>=20
> Because they save one line and do improper error handling.
> They should all be converted to device_init+device_add/device_del/device_=
put.

I don't see device_init(), or do you mean device_initialize()? It
returns void?

> > So far you are failing to dispel my notion that sysfs is a place where
> > mortals dare not tread ;)
>=20
> Oh, you are welcome to join the endless fixing rounds. Most of the
> weird stuff if from people who moved to islands far away and never
> touched any Linux code anymore (no kidding). :)

Yeah fair enough :)

It is a pet peeve of mine when APIs are "deprecated" but no where is
that documented, least of all by using __deprecated. I guess that's
because it spews warnings, maybe we need __future_deprecated or
something.

> >> > And I'm looking at eg. drivers/usb/serial/bus.c as an example bus.
> >> >
> >> > But in my case (and I think perf too), we don't need a bus that prob=
es
> >> > etc. it's just a virtual bus that groups things, so it seems like it
> >> > should be simple.
> >> >
> >> > Anyway I feel like I'm missing something, so hopefully you can clue =
me
> >> > in :)
> >>
> >> Buses without drivers do not probe at all, they behave like classes.
> >
> > OK, good, that would seem to be a prerequisite for replacing the latter
> > with the former.
> >
> > I'm just not clear on how that actually works in the code. For example =
I
> > have a device which is on a bus (that's how it got probed), how do I
> > also put it on another bus (my virtual bus replacing my class) ?
>=20
> Nothing gets probed ever, if no driver is registered. To get a device
> on a bus, just assign the bus to the 'struct device' before calling
> device_add, that's all.

Cool, that sounds simple enough.

> Devices can never be on two subsystems at the same time. Not with
> classes, not with buses, that was never, and probably will never be
> possible.

OK, I guess I'm getting my terminology wrong. My devices, which show up
in /sys/class/foo are symlinks into /sys/devices/virtual/foo, so they
_appear_ to be in two places.

I also see entries for example in /sys/class/scsi_disk that link
into /sys/devices/pci.

cheers


--=-750ChZgWq/OAcNBN+EUX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzZ+UgACgkQdSjSd0sB4dJQbgCdGiPX83Ep1MSjDRwaXZZ/Ikov
v8kAnjYmdQdqN/kx5gGQjo7pv1B8kFCb
=DHez
-----END PGP SIGNATURE-----

--=-750ChZgWq/OAcNBN+EUX--

