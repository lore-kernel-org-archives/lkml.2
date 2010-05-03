Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0ECABq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 20:01:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39324 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0ECABo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 20:01:44 -0400
Date: Mon, 3 May 2010 10:01:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: linux-next: build warnings after merge of the driver-core.current
 tree
Message-Id: <20100503100137.a05c9098.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_May_2010_10_01_37_+1000_RXy9i_6=8Cy+iHrL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_May_2010_10_01_37_+1000_RXy9i_6=8Cy+iHrL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core.current tree, today's linux-next build (power=
pc
ppc64_defconfig and x86_64 allmodconfig) produced these warning:

drivers/pcmcia/ds.c: In function 'pcmcia_load_firmware':
drivers/pcmcia/ds.c:761: warning: passing argument 1 of 'release_firmware' =
discards qualifiers from pointer target type
include/linux/firmware.h:46: note: expected 'struct firmware *' but argumen=
t is of type 'const struct firmware *'
drivers/net/cxgb3/cxgb3_main.c: In function 't3_get_edc_fw':
drivers/net/cxgb3/cxgb3_main.c:1084: warning: passing argument 1 of 'releas=
e_firmware' discards qualifiers from pointer target type
include/linux/firmware.h:46: note: expected 'struct firmware *' but argumen=
t is of type 'const struct firmware *'

and *lots* more similar warnings ...

Caused by commit d5ae47f7d90f94a15e668f389c12211a11798b6f
("firmware_class: fix memory leak - free allocated pages").  This patch
was modified from an earlier version that produced different (though many
fewer) warnings.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_May_2010_10_01_37_+1000_RXy9i_6=8Cy+iHrL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkveEmEACgkQjjKRsyhoI8xGogCfZ+b7yHUBkOZ67kuvGuAZQnyB
LYYAnAuIOYY+jqL2Wyy6ZZeIwFjpD4Lg
=80aF
-----END PGP SIGNATURE-----

--Signature=_Mon__3_May_2010_10_01_37_+1000_RXy9i_6=8Cy+iHrL--
