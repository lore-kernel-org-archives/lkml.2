Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2DQE17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 00:27:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59622 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2DQE15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 00:27:57 -0400
Date: Tue, 17 Apr 2012 14:27:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: build failure after merge of the final tree (regulator
 tree related)
Message-Id: <20120417142748.d42daa09958086a6e2ab4878@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_14_27_48_+1000_iCds5uwYkcIXDM3Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_14_27_48_+1000_iCds5uwYkcIXDM3Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/misc/max8997-muic.c: In function 'max8997_muic_irq_work':
drivers/misc/max8997-muic.c:313:34: error: 'struct max8997_platform_data' h=
as no member named 'irq_base'
drivers/misc/max8997-muic.c: In function 'max8997_muic_probe':
drivers/misc/max8997-muic.c:434:35: error: 'struct max8997_platform_data' h=
as no member named 'irq_base'
drivers/misc/max8997-muic.c: In function 'max8997_muic_remove':
drivers/misc/max8997-muic.c:474:17: error: 'struct max8997_platform_data' h=
as no member named 'irq_base'

Caused by commit 98d8618af377 ("mfd: add irq domain support for max8997
interrupts").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_14_27_48_+1000_iCds5uwYkcIXDM3Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjPFEAAoJEECxmPOUX5FECQ0QAIk19UjtbZ3IDPdnxJZqKV9a
0XeJWVgNdNG97F7uoBkR9s0WrC3wgsO6OXM/K1V6Euqo1wutS++QE2pOTKSwfMIf
EINOMB/pw8Jkb8OjzPcNfmP1s7x4jPUbZjAD7W/wJg282/lc2nopebbX35BhRmSK
efVVUAWxmkF2pzx8iwktzYUcLRMJPVUIDik2ymeoAJOSfdow21iNSczOEPOLuGTU
Sj9gMKZmDW0ucI5/TeMmkMmglPCGWdHQTB+9MEvEsdA3p8sNRBEHMypL0C9M8NvV
VTQ27cV/WVe8ba8NeBJ9d+uKBKSU9tS2D2O0dvNszxVOolHE2MC32BCSyjIRrtac
wQcPpZkA2lCc1XxTVzHtT0E6hHr9fkGkcZS+VTtq4l8yv6goccJBW0Dj4t6vVa7n
fegBuN5ats92Y+VDSs20W/lIaOS9j8iX1+Jwip7MAkXbq2uXMAEPB2IJsuQsJln4
sY6ckkb6N8vx+yxU7MN4biO7LcqxLF2xsLHPOdoC10xictWoQiHqGeEEPwU7k+q7
AjhpI7yhZbkQSO4NwjxI7SZ8SASbZQuzhx/nZSlrf6J3Zfp3bZuP51MjziLCPSIW
HGOZhD9hCP17z5p6FlFty6NICbm7mbp7NaYTq4wE47XVG+P9ORzc+9kzMMBGkKYF
YRoSZ0+/k00T2A8mSeby
=9s+q
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_14_27_48_+1000_iCds5uwYkcIXDM3Q--
