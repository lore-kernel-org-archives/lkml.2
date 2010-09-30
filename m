Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0I3H4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:56:33 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43871 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab0I3H4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:56:32 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Nigel's current for-rafael queue
Date: Thu, 30 Sep 2010 09:56:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-tp42-hiber-wri-accel-vmembase-0-00133-g3394a84-dirty; KDE/4.5.1; i686; ; )
Cc: tuxonice-devel@tuxonice.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> <201009282145.46948.Martin@lichtvoll.de> <4CA25D59.2040409@tuxonice.net> (sfid-20100928_235754_260042_ABDA5030)
In-Reply-To: <4CA25D59.2040409@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2337030.qsCe9eA7Cs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009300956.29993.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2337030.qsCe9eA7Cs
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 28 September 2010 schrieb Nigel Cunningham:
> Hi Martin.

Hi Nigel.

> On 29/09/10 05:45, Martin Steigerwald wrote:
> > Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> >> Hi Rafael.
> >=20
> > Hi Nigel,
> >=20
> >> Please find attached a slightly updated version of the patchset I
> >> sent a few months ago. The main change is that I've prepended and
> >> additional patch which lets the user see the speed at which the
> >> image is being read and written. This is accomplished by recording
> >> the MB/s in a single byte in the image header, and using a couple
> >> of __nosavedata variables to get the data back through the atomic
> >> restore. I realise the char limits us to 255MB/s at the moment. In
> >> future patches, I intend to address this by storing the data in a
> >> 'proper' image header (it's a real problem - TuxOnIce reads and
> >> writes on the same set up at speeds around 250MB/s).
> >=20
> >> Results on my Dell XPS M1530, which has an SSD hard drive are:
> > I found one issue with this patchset or more precise I think with the
> > state of in-kernel-suspend before:
> >=20
> > I accidentally booted a kernel without your patches and it didn't
> > seem to stop on the hibernation image from the kernel with your
> > patches. Well I let my laptop unattended for a little while, so when
> > there has been a (short) timeout, I might have missed that message.
> >=20
> > I lost a hibernation image this way which caused successful journal
> > replay on my Ext4 filesystems.
> >=20
> > Does a kernel without your patches offer to reboot into the correct
> > kernel, then it finds a hibernation image from a kernel with your
> > patches?
> >=20
> > If not, I think for the future it should give a warning with a quite
> > high timeout, and offer to reboot into the right kernel.
>=20
> My patches only focus on the I/O code in swsusp at the moment. I know
> there are still tons of things from TuxOnIce that could be put into
> swsusp, but at the moment I'm just focusing on I/O code.
>=20
> The answer at the moment is therefore "I'm sorry, but if you're going
> to try out this code, you're going to have to live without some of
> TuxOnIce's nice features until I can split them into nice little
> patches, and start trying to persuade Rafael they're a good idea to
> merge."
>=20
> Sorry!

No problem. I wasn't aware that in kernel suspend does not have any checks=
=20
like that, cause TuxOnIce and Userspace Software Suspend both have them.=20
Thus I thought, that the check somehow did not trigger while it should.=20
But if no check was in there, this is no problem with your patches.

I try to avoid booting from kernels without your patches when I suspend=20
from one with your patches by making sure that the kernel with your=20
patches is the first in grub menu ;).

I think a check should go in as soon as possible tough. Cause anything=20
else just asks for filesystem corruption. I still have a "sync" in my pre=20
hibernate script that calls the hibernate script. And Ext4 is good at=20
recovering from journals. But still...

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2337030.qsCe9eA7Cs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkykQq0ACgkQmRvqrKWZhMdKcgCfSSWscY98PzJMiMDknz3cbt8x
S78AoKYPAWv96R7zDcov07XX4r8pyzFR
=SrI7
-----END PGP SIGNATURE-----

--nextPart2337030.qsCe9eA7Cs--
