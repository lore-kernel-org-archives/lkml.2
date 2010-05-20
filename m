Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0ETJ3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:29:54 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58860 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0ETJ3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:29:52 -0400
Date: Thu, 20 May 2010 11:29:45 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100520112945.61bf9705@mjolnir.ossman.eu>
In-Reply-To: <4BF4F979.4070903@kernel.org>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
	<20100519232906.3be82279@mjolnir.ossman.eu>
	<20100519233408.7436bd9b@mjolnir.ossman.eu>
	<20100520091429.192d560c@mjolnir.ossman.eu>
	<4BF4F979.4070903@kernel.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-3709-1274347789-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-3709-1274347789-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 May 2010 10:57:29 +0200
Tejun Heo <tj@kernel.org> wrote:

> On 05/20/2010 09:14 AM, Pierre Ossman wrote:
> > Note that this is a live system, so there is some chance that something
> > wrote to than area, then restored it to the previous state. I'm not
> > sure how likely that is.
> >=20
> > If not, then it would seem that this is a problem in either the disks,
> > the controller or the controller driver. The components are WD
> > WD1002FAEX, sil3132 and sata_sil24 respectively.
>=20
> There is a report that sil3124/32 recognizes FIS corruption but keeps
> using the payload anyway thus leading to data corruption when the bus
> condition on pci-e side isn't ideal.  Does moving the controller to
> different slot make difference?
>=20

The machine is rather crammed right now, with one controller in each of
the three available pci-e slots (5 disks). I am running continuous tests
on the disks right now though to see if the problems is on all disks or
just some. If just one slot is causing problems then we should see some
results there.

When you say FIS corruption, do you mean corruption in the sense of
randomly flipped bits? I don't know if you saw the first couple of
mails (before linux-ide was added), but the problem is data being moved
around, not just randomly changed.

Another note is that the problem seems to worsen under load. I'm
running the dd thing in the background, which seems to make read errors
more common on my test files on the filesystem level.

I also tried disabling NCQ without any noticeable change.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-3709-1274347789-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv1AQwACgkQ7b8eESbyJLjRbACgyHRN81yFOg20dy+r60eXBVkT
diAAoKB1wj/AMnJN/jQaxvXooraseGJf
=pf+E
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-3709-1274347789-0001-2--
