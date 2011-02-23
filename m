Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1BWOLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:11:19 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40405 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1BWOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:11:18 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: does hibernate to disk try hard enough to free memory?
Date: Wed, 23 Feb 2011 15:10:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tp42-rtime-00004-g9eb63ce; KDE/4.5.3; i686; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201102222159.58546.Martin@lichtvoll.de> <201102222307.41499.Martin@lichtvoll.de> <201102222332.43864.rjw@sisk.pl> (sfid-20110222_235917_178098_58EF243B)
In-Reply-To: <201102222332.43864.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2760788.Nz7BMqQCQB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201102231511.15683.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2760788.Nz7BMqQCQB
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

Am Tuesday 22 February 2011 schrieb Rafael J. Wysocki:
> On Tuesday, February 22, 2011, Martin Steigerwald wrote:
> > Am Tuesday 22 February 2011 schrieb Rafael J. Wysocki:
> > > On Tuesday, February 22, 2011, Martin Steigerwald wrote:
> > > > Hi!
> > > >=20
> > > > Since Radeon KMS I often have it that my ThinkPad T42 with 2 MiB
> > > > of RAM is not able to allocate memory for the hibernation image.
> > > > Before KMS hibernation only very rarely failed for that reason.
> > > >=20
> > > > Often I run without compositing at all as I believe this might
> > > > spare some pages as well. But this doesn't always help.
> > > >=20
> > > > It complains that to less pages could be freed. For example with
> > > > kernel 2.6.37:
> > > >=20
> > > > Feb 16 00:15:00 shambhala kernel: PM: Creating hibernation image:
> > > > Feb 16 00:15:00 shambhala kernel: PM: Need to copy 186577 pages
> > > > Feb 16 00:15:00 shambhala kernel: PM: Normal pages needed: 114411
> > > > + 1024, available pages: 112767
> > > > Feb 16 00:15:00 shambhala kernel: PM: Not enough free memory
> > > > Feb 16 00:15:00 shambhala kernel: PM: Error -12 creating
> > > > hibernation image Feb 16 00:15:00 shambhala kernel: Extended
> > > > CMOS year: 2000 Feb 16 00:15:00 shambhala kernel: ACPI: Waking
> > > > up from system sleep state S4
> > > > Feb 16 00:15:00 shambhala kernel: PM: early recover of devices
> > > > complete after 0.376 msecs
> > >=20
> > > What's the value in /sys/power/image_size?
> >=20
> > shambhala:~> cat /sys/power/image_size
> > 844206080
> >=20
> > Should I try with less?
>=20
> Yes, please.  Try with 700000000 for example.

I replaced dropping by settings image_size to this valua and the ThinkPad=20
hibernated with KMail open. Thus seems to work, but I will test a bit=20
further.

Where does the higher value previously set come from? Autotuning? Is there=
=20
anything that can be improved with autotuning? If yes, I can file a bug=20
report. Otherwise I just try to find a good value for image size and be=20
done with it.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2760788.Nz7BMqQCQB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1lFWcACgkQmRvqrKWZhMf8kQCglNEiA5KmveZ2pXb7eYDFXhKy
KO0AnRYNpFKTkV2XOgbZb7cgjlJsy9/l
=T3Gf
-----END PGP SIGNATURE-----

--nextPart2760788.Nz7BMqQCQB--
