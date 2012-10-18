Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JRDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:16:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57254 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2JRDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:16:56 -0400
Date: Thu, 18 Oct 2012 14:16:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20121018141644.d4051cafdeeb128dc3250661@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Oct_2012_14_16_44_+1100_LbbJ8fb=/N3i3WR="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Oct_2012_14_16_44_+1100_LbbJ8fb=/N3i3WR=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from sound/pci/ice1712/psc724.c:29:0:
sound/pci/ice1712/ice1712.h: In function 'snd_ice1712_write':
sound/pci/ice1712/ice1712.h:501:2: error: implicit declaration of function =
'outb' [-Werror=3Dimplicit-function-declaration]
sound/pci/ice1712/ice1712.h: In function 'snd_ice1712_read':
sound/pci/ice1712/ice1712.h:508:2: error: implicit declaration of function =
'inb' [-Werror=3Dimplicit-function-declaration]

Caused by commit 77b0b254af72 ("ALSA: ice1712: Add Philips PSC724
Ultimate Edge").  Probably some Kconfig dependency missing?

I have reverted that commit (and the following commit a2af050f8df6 "ALSA:
ice17xx: Constify strings and string arrays") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Oct_2012_14_16_44_+1100_LbbJ8fb=/N3i3WR=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQf3ScAAoJEECxmPOUX5FEf1YP/juA5nbUfZZ9Jfi/opTtyGRO
eNgr/M1AXUxujoetq6taEjuYarzi5hsl7e17WeuypUxbnCQ+E0tSU10kCXBqGScR
JCgLAFIFxAa9Ijzx65whZqjDTi3FS0ZRDKhpgyVDbSrmRAyvWXT+XjypjSRuq+T8
Cj5Z0+Q8C8OC4C+QVd5/rgMDz8AA+C8BDXI4B2e9KHHbaacR3IHQ6ORt6u2wwSfW
4PKxqa9kk8vM9kmbeU2pBiBZd/MQBEds9vyUtHE2CDE1hKOl9zthm5kLQ+dbNrBK
gRLVNyWZ3/Vggemm2Yq1MefLrH/oWjcIz8S8VceP+fwLVvgrkizzJHn0bWTK+1D5
Rp92cT4q2/7+rEfdMSPAA2ra/jzNbae/SHQxL4JrY3FfoA7MxkILlUh+H4U7Cg0t
B7q93RjY/Pb4WxE+piY3E4G0IGhxDy7YkKCT8gq6twIceco/lCGyydKxv1Kf2O6G
xX5WfwJp8Kc9sc2hAO9VyUtDpUkbxjswLE8BBcQKDhFkaLnh4UIM/upOMkX5sMA7
7Qg98ZP6KiQv8EQ8nshArFCCr0Lhr/9DJc0V5G6dPcy+c8T/jemKhbq1TDeuVAHP
a1elAt3+B+bXyPAlhYPUkzLSyWiuUnaKbFBBMB1h35qQrDhiWuHY7Zd2o536Vf+U
deFtxkGc2pKmsPirAe+b
=VdPu
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Oct_2012_14_16_44_+1100_LbbJ8fb=/N3i3WR=--
