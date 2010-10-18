Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0JRHfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:35:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab0JRHft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:35:49 -0400
Date: Mon, 18 Oct 2010 18:35:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: build failure after merge of the final tree (mmc tree
 related)
Message-Id: <20101018183540.2a7dfc8f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_18_35_40_+1100__pXb266gHuZ1cmUQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_18_35_40_+1100__pXb266gHuZ1cmUQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the scsi-post-merge tree, today's linux-next build ()
failed like this:

drivers/mmc/host/sdhci-of-esdhc.c:21:25: error: sdhci-esdhc.c: No such file=
 or directory
drivers/mmc/host/sdhci-of-esdhc.c: In function 'esdhc_writeb':
drivers/mmc/host/sdhci-of-esdhc.c:51: error: 'ESDHC_HOST_CONTROL_RES' undec=
lared (first use in this function)
drivers/mmc/host/sdhci-of-esdhc.c:51: error: (Each undeclared identifier is=
 reported only once
drivers/mmc/host/sdhci-of-esdhc.c:51: error: for each function it appears i=
n.)
drivers/mmc/host/sdhci-of-esdhc.c: In function 'esdhc_of_enable_dma':
drivers/mmc/host/sdhci-of-esdhc.c:57: error: 'ESDHC_DMA_SYSCTL' undeclared =
(first use in this function)
drivers/mmc/host/sdhci-of-esdhc.c:57: error: 'ESDHC_DMA_SNOOP' undeclared (=
first use in this function)
drivers/mmc/host/sdhci-of-esdhc.c: At top level:
drivers/mmc/host/sdhci-of-esdhc.c:76: error: 'ESDHC_DEFAULT_QUIRKS' undecla=
red here (not in a function)
drivers/mmc/host/sdhci-of-esdhc.c:84: error: 'esdhc_set_clock' undeclared h=
ere (not in a function)

Caused by commit a2fe088a5aaa51b54c018cf309cdc728d5f4e540 ("mmc:
sdhci-of-esdhc: factor out common stuff").

This was clearly never build tested ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_18_35_40_+1100__pXb266gHuZ1cmUQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu/jMAAoJEDMEi1NhKgbsN4EH/3lU57EcGJvbCzGF6A7Vgy9g
ZKCEHh6vb49ro7pCQ3Q52fhuatbEdcCHs8MQgJG6jz3VTKNgfnreJLxgKzZ7cm/Y
1xgtk74rCZc9/ap+PBB1NIVxre7WylrAd0qHKY8toKtO4gTRk+2hAux1yaxvPrUq
wzAtDkj73HOyUf+rjzo960QuFrWYhxzrO2xgo8hB9k1/V2TylN9+fT0s7ZWUeHHl
sQKr9hEMFmDBT+KPknHgIwH63tflUxkGeE0euOJW9Rq0p/NVGCltGQxWmB3lcbmt
uWfhtav4E5hUdQdZuVDe6B9rLQGIdIn3YYtWfcEyELAY4Vxid9ct+XPQcj77yO4=
=L1JX
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_18_35_40_+1100__pXb266gHuZ1cmUQ--
