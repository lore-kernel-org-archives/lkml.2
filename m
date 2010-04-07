Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0DGDjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 23:39:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37687 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab0DGDjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 23:39:24 -0400
Date: Wed, 7 Apr 2010 13:39:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Risto Suominen <Risto.Suominen@gmail.com>
Subject: linux-next: build failure after merge of the sound tree
Message-Id: <20100407133919.94b44bf1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Apr_2010_13_39_19_+1000_nj6+M+JRERoLuB2r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Apr_2010_13_39_19_+1000_nj6+M+JRERoLuB2r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the sound tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

sound/ppc/tumbler.c: In function 'tumbler_find_device':
sound/ppc/tumbler.c:1143: error: implicit declaration of function 'machine_=
is_compatible'

Caused by commit 819ef70b135ba66cd1659c913255686bf931e3d4 ("ALSA:
powermac - Reverse HP detection on G4 DA").  machine_is_compatible was
renamed to of_machine_is_compatible by commit
71a157e8edca55198e808f8561dd49017a54ee34 ("of: add 'of_' prefix to
machine_is_compatible()") in Linus' tree since Feb 26, 2010 (and is in
v2.6.34-rc1).

I have used the version of the sound tree from next-20100401 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Apr_2010_13_39_19_+1000_nj6+M+JRERoLuB2r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku7/mcACgkQjjKRsyhoI8yDWwCfVbKiae0E2LPZaW01/29CfBa/
lLsAoLg0BABHvTiAIB3STDX9YywcYfCx
=x/dj
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Apr_2010_13_39_19_+1000_nj6+M+JRERoLuB2r--
