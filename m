Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2BFEj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 23:39:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39443 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2BFEj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 23:39:27 -0500
Date: Mon, 6 Feb 2012 15:39:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry Huang <Chang-Ming.Huang@freescale.com>,
        Jiang Yutang <b14898@freescale.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: linux-next: build failure after merge of the final tree (mmc tree
 related)
Message-Id: <20120206153916.48adb1f48711f665274909b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Feb_2012_15_39_16_+1100_6R0ZlO6LWvqvuMmF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Feb_2012_15_39_16_+1100_6R0ZlO6LWvqvuMmF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mmc/host/sdhci-of-esdhc.c:143:2: error: unknown field 'platform_sus=
pend' specified in initializer
drivers/mmc/host/sdhci-of-esdhc.c:143:2: warning: initialization from incom=
patible pointer type [enabled by default]
drivers/mmc/host/sdhci-of-esdhc.c:143:2: warning: (near initialization for =
'sdhci_esdhc_ops.get_timeout_clock') [enabled by default]
drivers/mmc/host/sdhci-of-esdhc.c:144:2: error: unknown field 'platform_res=
ume' specified in initializer
drivers/mmc/host/sdhci-of-esdhc.c:144:2: warning: initialization from incom=
patible pointer type [enabled by default]
drivers/mmc/host/sdhci-of-esdhc.c:144:2: warning: (near initialization for =
'sdhci_esdhc_ops.platform_8bit_width') [enabled by default]

Caused by commit 4f6eeb41eee9 ("mmc: esdhc: Implement power management
for ESDHC").  I can't see how that was ever even build tested ..

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Feb_2012_15_39_16_+1100_6R0ZlO6LWvqvuMmF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPL1l0AAoJEECxmPOUX5FEfekP/j52tDzMZZnWQidR/4I5Fjxi
ioStWPkse5f914T27lTKL7deX3FR5gNcJj1eLxfmEr9PrbR2SeBuOvtZroD7bAdb
SchpUpvSBzXjFWtTycFKh7xsTzZAHzY46XVYImIcruP7IVS8+rY5I5u0vBsX99+T
czza6R38clzVM5CuphzS6HpvoFaC0JrXKMv6x6lwGLMU0OfVDqn0rMvcrF/lYlFp
Q+nDz98PB1U4kWkGoB+nc3TEOu11tuhU4YhllLWO2KdRDytfmm+X1Ml42v90d0a+
oIpeLIT6XALiPWNmlGKARkqMBa7IwIyOxsylzdt2ruR0uAHf83io9EjgrbFxHXcU
gHS4GPIy26+Cit+IA5FPdKIwiPz3a4hyH0J68gekcTLLKRpOyR+Sa1Y1x8kG4Yfn
6ERLLxtPZ3VQwlPzgmV/wusVWrTHJj65u3g3HS6qLeH61gSX25r2uNkTaqSnU07v
G9VtOufV9pAHWO/3fvqyXRcMP/1JcECih/3nONeBw57Wn8hvP6VaL7+4nsQZAjPc
C8IKqq9VFbo8fafYeGSo03p6N7hBkIoB1yCrp1zB5nC15XuM54gljRLU9frSuMZw
jgQPmycwtPIcjiKGYg9oTnxZgdXRHBY05n4YuBel488r+xRFBcb+UFkCF3Ap2y7I
1lq7qIqCfvra8l4p+Elz
=H92E
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Feb_2012_15_39_16_+1100_6R0ZlO6LWvqvuMmF--
