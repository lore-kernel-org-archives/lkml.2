Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1IVGOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:14:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54013 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1IVGN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:13:58 -0400
Date: Thu, 22 Sep 2011 16:13:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: linux-next: build failure after merge of the mmc tree
Message-Id: <20110922161350.a3a0f41a56dd99760f688e3a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_16_13_50_+1000_Y4OOR032fEEbhH1F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_16_13_50_+1000_Y4OOR032fEEbhH1F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mmc/core/core.c: In function 'mmc_do_hw_reset':
drivers/mmc/core/core.c:1848:11: error: 'struct mmc_ios' has no member name=
d 'ddr'

Caused by commit a0721d241b06 ("mmc: core: add eMMC hardware reset
support"). ddr was removed by commit 7fd781e8f9b7 ("mmc: remove unused
"ddr" parameter in struct mmc_ios") before v3.1-rc2.

Please build test ...

I have used the mmc tree from next-20110921 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Sep_2011_16_13_50_+1000_Y4OOR032fEEbhH1F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOetIeAAoJEDMEi1NhKgbsCukH/jaWKhptTC4pfnp129Bp6FGf
yktmUenXzCjAnlTMkqNhEbCIHS/PC2FKw/lTXIT7DxF1V9FdO/P0h25CTD403Ptv
nSctnzEOo8bfjhg2s46bs6AvJvdAXWXyG4gdiYN18ooLXdeLCaqk/W6PljuPVMuG
Ao170gtY///wezcI1g9/e3KYA/Q2RS1HTjkAVsM7Go2PTwT12K+W6XhbgvykLOap
CbtkavWGW6Shbwc9tVaSHWPpH0ssi/LnWZZnVuNzQSk22un3x5z2ioEViOKXTy3n
Qd/RSbFX2gQlIZiUu+qvXQXk+0BG/ljdKhG4iYeILq6MMgauG5Zf+Sf53VMSv5I=
=9J8T
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_16_13_50_+1000_Y4OOR032fEEbhH1F--
