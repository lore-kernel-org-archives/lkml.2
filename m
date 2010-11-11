Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0KKSkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:40:40 -0500
Received: from mailsrv1.zmi.at ([212.69.164.54]:59687 "EHLO mailsrv14.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0KKSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:40:39 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 13:40:38 EST
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: linux-kernel@vger.kernel.org
Subject: Regression 2.6.36 - driver rtl8169 crashes kernel, triggered by user app
Date: Thu, 11 Nov 2010 19:33:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.5-desktop; KDE/4.4.4; x86_64; ; )
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2438180.0ZLtrkFrBO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201011111933.04343@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2438180.0ZLtrkFrBO
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Dear list, I've hunted down a bug which does *NOT* occur in kernel=20
2.6.34.7-0.5-desktop from openSUSE 11.3, but crashes stock kernel 2.6.36=20
triggered by a user!

It's actually very simple. From my desktop (kernel 2.6.36) I "cd" to an=20
NFS4 share, where a xz compressed image of Win7-64.iso.xz is located.

# cd /q/iso-images

and then I try to uncompress it there (as user, not root!):

# xz -kv Win7-64.iso.xz

With kernel 2.6.34.7-0.5-desktop, this runs with ~41MiB/s without=20
problems.

With kernel 2.6.36, it runs at ~26MiB/s, and while doing so, dmesg shows=20
a lot of noise about r8169 complaining:
http://zmi.at/x/kernel2.6.36-crash86.jpg

Here are 2 pictures of different crashes:
http://zmi.at/x/kernel2.6.36-crash84.jpg
http://zmi.at/x/kernel2.6.36-crash85.jpg

Neither the dmesg-messages nor the crash happens with kernel=20
2.6.34.7-0.5-desktop as delivered by openSUSE 11.3, but it always fully=20
crashes 2.6.36. I've retried about 10 times, it *never* finished to=20
uncompress the ~3GB image. At around 500-1000MB the kernel was gone.

I'm sure someone knows how to fix it. :-)

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2438180.0ZLtrkFrBO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzcNuAACgkQzhSR9xwSCbQ9sACfQpVrOihap/EXBpa0FkcfhnvY
67MAoJl5DZy5wHmijRrRzdY/J7Hvj4FB
=HC7Y
-----END PGP SIGNATURE-----

--nextPart2438180.0ZLtrkFrBO--
