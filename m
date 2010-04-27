Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0D0Ftp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:49:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46029 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0D0Ftb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:49:31 -0400
Date: Tue, 27 Apr 2010 15:49:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Ball <cjb@laptop.org>
Subject: linux-next: build failure after merge of the final tree (viafb tree
 related)
Message-Id: <20100427154925.7315ed67.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_15_49_25_+1000_Rkw=rHd8kMdvziV7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_15_49_25_+1000_Rkw=rHd8kMdvziV7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jon,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/video/via/hw.c:21:22: error: asm/olpc.h: No such file or directory
drivers/video/via/lcd.c:21:22: error: asm/olpc.h: No such file or directory
drivers/video/via/hw.c: In function 'init_tmds_chip_info':
drivers/video/via/hw.c:2043: error: implicit declaration of function 'machi=
ne_is_olpc'
drivers/video/via/lcd.c: In function 'viafb_lvds_trasmitter_identify':
drivers/video/via/lcd.c:179: error: implicit declaration of function 'machi=
ne_is_olpc'

Caused by commit 78af0539da7b8069cb30023a3ec648e353849d3c ("viafb: Do not
probe for LVDS/TMDS on OLPC XO-1.5") from the viafb tree.

I have reverted that commit (and ab73d3d6066b57963ead15f3c1d1a55b16520e14
"viafb: rework the I2C support in the VIA framebuffer driver",
b3af18ed0ed5161801545f40705b9ec50bd9ebb6 "suppress verbose debug
messages: change printk() to DEBUG_MSG()" and
81b7734bd9f0a25e29d9d943e020fa57aee738b4 "viafb: Only establish i2c
busses on ports that always had them" that conflicted with the revert)
for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_15_49_25_+1000_Rkw=rHd8kMdvziV7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWeuUACgkQjjKRsyhoI8w7lQCgqSdAvRdh5XslgGr8QGRrzyAB
Ht8AniPQo5Z9FdzQCT/Xnth3qkXrX4kW
=maK/
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_15_49_25_+1000_Rkw=rHd8kMdvziV7--
