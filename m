Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0JNB4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:56:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39912 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0JNB4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:56:04 -0400
Date: Thu, 14 Oct 2010 12:55:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingkai Hu <Mingkai.hu@freescale.com>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20101014125553.dc4ea7be.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Oct_2010_12_55_53_+1100_4D=H=19eIRnkiBWa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Oct_2010_12_55_53_+1100_4D=H=19eIRnkiBWa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mtd/devices/m25p80.c: In function 'm25p_probe':
drivers/mtd/devices/m25p80.c:927: error: 'struct device' has no member name=
d 'of_node'
drivers/mtd/devices/m25p80.c:929: error: 'struct device' has no member name=
d 'of_node'

Caused by commit 2bf990280d6074228f6e4c18ad01c0674c5c11c8 ("mtd/m25p80:
add support to parse the partitions by OF node"). CONFIG_OF is not set
for this build.

I have used the spi tree form next-20101013 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_Oct_2010_12_55_53_+1100_4D=H=19eIRnkiBWa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMtmMpAAoJEDMEi1NhKgbssxMH/1xLNYuQ8dqjDBW0Ww8716K+
PVx44XZV5lltUfqHuz0xJQSX/hqwIIBIWepm2zLZuXNZpFtIrR2DBdBYJLtt6Qpr
7+8pKikVFNfiPlB3rRtAIq5H6dn/mK7ED29ZXi0QrX/uiSbwAKo2XcOrBf2Fn3HI
Bu+o8jc053mlgCACooZ9kVXN3q3anl5ogn57uq/YI/hdgpTV7MReXmBKnpuCsl/F
RjBnbff5zPa6r/bLx+g45EfjGNdurp2yoLPaVVk1q74+u5Ie4eO5pt5tBeFVq3X8
wQRX+eT8mWwLTDDLZKCQvEYTqvtr+DyY3r3i7K79DFtstTnYNIS8wDjAV/GVrEE=
=16Vt
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Oct_2010_12_55_53_+1100_4D=H=19eIRnkiBWa--
