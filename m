Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1LACQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:16:21 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47467 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1LACQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:16:19 -0500
Date: Thu, 1 Dec 2011 13:16:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tanmay Inamdar <tinamdar@apm.com>, Josh Boyer <jwboyer@gmail.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: linux-next: manual merge of the trivial tree with the 4xx tree
Message-Id: <20111201131604.fa4e2fe14d5f370924592939@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Dec_2011_13_16_04_+1100_mY9YfupVwUnIju5Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Dec_2011_13_16_04_+1100_mY9YfupVwUnIju5Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/powerpc/platforms/40x/Kconfig between commit d5b9ee7b514e
("powerpc/40x: Add APM8018X SOC support") from the 4xx tree and commit
ff5f483f3091 ("powerpc: 4xx: remove commented out Kconfig entries") from
the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/platforms/40x/Kconfig
index 8883f2c,bd69cf8..0000000
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@@ -172,28 -148,3 +148,12 @@@ config IBM405_ERR7
  # All 40x-based cores, up until the 405GPR and 405EP have this errata.
  config IBM405_ERR51
  	bool
 +
- #config BIOS_FIXUP
- #	bool
- #	depends on BUBINGA || EP405 || SYCAMORE || WALNUT
- #	default y
-=20
- #config PPC4xx_DMA
- #	bool "PPC4xx DMA controller support"
- #	depends on 4xx
-=20
- #config PPC4xx_EDMA
- #	bool
- #	depends on !STB03xxx && PPC4xx_DMA
- #	default y
- #
-=20
 +config APM8018X
 +	bool "APM8018X"
 +	depends on 40x
 +	default n
 +	select PPC40x_SIMPLE
 +	help
 +	  This option enables support for the AppliedMicro APM8018X evaluation
 +	  board.
-=20

--Signature=_Thu__1_Dec_2011_13_16_04_+1100_mY9YfupVwUnIju5Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1uNkAAoJEECxmPOUX5FEY2oP/jGALnnEPdWU/HklxTY8K2vi
R4k+gEesBRy0Vo8mBzPY9cxIU/NZQRtkhJETc2P6PSXnNGMuTj/Eqg2dFfTBknNS
AuBW6tr73Ey087qV+Q+c7U6ckSix3VjSduDHgC46CjndbEkax0azeAsGTgNP1YHp
MtqLA4oBLI/dRURP808t+XSrAY7KWqEwYe2VABLLafz2h06z9iMp7msnFky4IFJV
t2OPTH+LBPirvByzuGtTBx4x16vWwMA5SiP0lliC8AYvly0tUsqKgx8H4nn5Lu6c
4yLbDPq8fpTn4w9I7MD0z8G+Z6l7XnAwS5JYvG72vw2k1CII+jr1zQbTwD0fITVD
cB5oQg4CjFcrwdPK0bWFHI31TlfROFOiaLWcoloFMltG68cAConqaojORi71PFIx
QYFUYCjUTXmamQ5UfpKKkPmtJT36E7FqQ1ItqBNXOjZNR5iM52SQzfbtfe0QxE56
XmeZZXb8E72cvNjVML3EVVnad+sSa3hiriOh8GVYkvitViVKyuzXoTrgrXAswqWP
uESU5tstpVxo65J/3jr5WfTq0QNZlH5+6MksC7QKBFPsWCbMjs73Jxc334VBlRgp
gh8IfdX5BKq1TDOKI18AFF2PjcWlSacbQeVFBvg64L4egoNXEi2+s1T+W2TrC1jT
8qT8b0OYIKZ8jDP8YEUR
=7ZE+
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Dec_2011_13_16_04_+1100_mY9YfupVwUnIju5Q--
