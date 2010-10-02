Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab0JBQuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:50:05 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44670 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab0JBQuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:50:02 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Swsusp patches applied to suspend-2.6#linux-next
Date: Sat, 2 Oct 2010 18:49:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069-dirty; KDE/4.5.1; i686; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> (sfid-20100927_095229_965698_B1F8A253)
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2714820.usHeie2QTy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010021849.54682.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2714820.usHeie2QTy
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Montag 27 September 2010 schrieb Nigel Cunningham:
> Hi again Rafael.

Hi Nigel and Rafael,

> As discussed, here are the patches, modified to apply against your
> current linux-next tree. A new first patch splits compression support
> out into its own file, removing the need to have two versions of the
> load_image and save_image routines, minimising the changes to the
> remainder of the patches and making things cleaner than would
> otherwise be the case.
>=20
> On my laptop, single-threaded compression actually slows writing down
> from 175MB/s to around 100-120MB/s (depending on how well the image
> compresses). Reading speed improves from 218MB/s to around 245MB/s. I
> expect that multithreaded writing would bring the writing (and
> reading) speeds back up. It's on my swsusp to do list :)

Testing this now (2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069-
dirty).

So far so fast:

shambhala:~> grep Image /var/log/syslog | tail -30
Sep 29 09:11:07 shambhala kernel: PM: Image restored successfully.
Sep 29 09:11:07 shambhala kernel: PM: Image written at 47 MB/s.
Sep 29 09:11:07 shambhala kernel: PM: Image read at 45 MB/s.
Sep 29 20:59:32 shambhala kernel: PM: Image restored successfully.
Sep 29 20:59:32 shambhala kernel: PM: Image written at 42 MB/s.
Sep 29 20:59:32 shambhala kernel: PM: Image read at 43 MB/s.
Sep 30 19:17:57 shambhala kernel: PM: Image restored successfully.
Sep 30 19:17:57 shambhala kernel: PM: Image written at 62 MB/s.
Sep 30 19:17:57 shambhala kernel: PM: Image read at 42 MB/s.
Oct  1 11:26:19 shambhala kernel: PM: Image restored successfully.
Oct  1 11:26:19 shambhala kernel: PM: Image written at 18 MB/s.
Oct  1 11:26:19 shambhala kernel: PM: Image read at 45 MB/s.
Oct  2 10:30:24 shambhala kernel: PM: Image restored successfully.
Oct  2 10:30:24 shambhala kernel: PM: Image written at 65 MB/s.
Oct  2 10:30:24 shambhala kernel: PM: Image read at 42 MB/s.
Oct  2 17:44:33 shambhala kernel: PM: Image restored successfully.
Oct  2 17:44:33 shambhala kernel: PM: Image written at 74 MB/s.
Oct  2 17:44:33 shambhala kernel: PM: Image read at 116 MB/s.
Oct  2 17:56:18 shambhala kernel: PM: Image restored successfully.
Oct  2 17:56:18 shambhala kernel: PM: Image written at 68 MB/s.
Oct  2 17:56:18 shambhala kernel: PM: Image read at 125 MB/s.
Oct  2 17:57:40 shambhala kernel: PM: Image restored successfully.
Oct  2 17:57:40 shambhala kernel: PM: Image written at 67 MB/s.
Oct  2 17:57:40 shambhala kernel: PM: Image read at 121 MB/s.
Oct  2 17:58:47 shambhala kernel: PM: Image restored successfully.
Oct  2 17:58:47 shambhala kernel: PM: Image written at 67 MB/s.
Oct  2 17:58:47 shambhala kernel: PM: Image read at 124 MB/s.
Oct  2 18:43:40 shambhala kernel: PM: Image restored successfully.
Oct  2 18:43:40 shambhala kernel: PM: Image written at 68 MB/s.
Oct  2 18:43:40 shambhala kernel: PM: Image read at 122 MB/s.
shambhala:~>

The read ahead patches bring a pretty nice performance upgrade ;).

I wonder a bit about:

Oct  1 11:26:19 shambhala kernel: PM: Image written at 18 MB/s.

This has been without read ahead patches which shouldn't interfere with=20
writing anyway.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2714820.usHeie2QTy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkynYqsACgkQmRvqrKWZhMf+DwCfZEMoMzjine9tDmp2Y6Xmatan
dTEAoLADpnKO39ebARr1C4itVOhVXA3o
=aKpJ
-----END PGP SIGNATURE-----

--nextPart2714820.usHeie2QTy--
