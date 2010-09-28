Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0I1Tpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:45:51 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49399 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0I1Tpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:45:50 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tuxonice-devel@tuxonice.net
Subject: Re: [TuxOnIce-devel] Nigel's current for-rafael queue
Date: Tue, 28 Sep 2010 21:45:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-tp42-hiber-wri-accel-vmembase-0-00133-g3394a84-dirty; KDE/4.5.1; i686; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> (sfid-20100925_095651_884433_67642C74)
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1949636.cTmNjiBp7y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009282145.46948.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1949636.cTmNjiBp7y
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 25 September 2010 schrieb Nigel Cunningham:
> Hi Rafael.

Hi Nigel,

> Please find attached a slightly updated version of the patchset I sent
> a few months ago. The main change is that I've prepended and additional
> patch which lets the user see the speed at which the image is being
> read and written. This is accomplished by recording the MB/s in a
> single byte in the image header, and using a couple of __nosavedata
> variables to get the data back through the atomic restore. I realise
> the char limits us to 255MB/s at the moment. In future patches, I
> intend to address this by storing the data in a 'proper' image header
> (it's a real problem - TuxOnIce reads and writes on the same set up at
> speeds around 250MB/s).
>=20
> Results on my Dell XPS M1530, which has an SSD hard drive are:

I found one issue with this patchset or more precise I think with the=20
state of in-kernel-suspend before:

I accidentally booted a kernel without your patches and it didn't seem to=20
stop on the hibernation image from the kernel with your patches. Well I=20
let my laptop unattended for a little while, so when there has been a=20
(short) timeout, I might have missed that message.

I lost a hibernation image this way which caused successful journal replay=
=20
on my Ext4 filesystems.=20

Does a kernel without your patches offer to reboot into the correct kernel,=
=20
then it finds a hibernation image from a kernel with your patches?

If not, I think for the future it should give a warning with a quite high=20
timeout, and offer to reboot into the right kernel.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1949636.cTmNjiBp7y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyiReIACgkQmRvqrKWZhMedSwCgtODcl0S2Mwv+qlU3V8KfA3YY
b9oAn1eAPwnsmKX9+yVndhWpGD6A9AkB
=CyH4
-----END PGP SIGNATURE-----

--nextPart1949636.cTmNjiBp7y--
