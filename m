Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1JLDPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:15:52 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39104 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1JLDPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:15:51 -0400
Date: Wed, 12 Oct 2011 14:15:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Girish K S <girish.shivananjappa@linaro.org>
Subject: linux-next: manual merge of the mmc tree with the mips tree
Message-Id: <20111012141543.fb3319f1b5345f5dcb9cdc52@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_14_15_43_+1100_D0F/4zQfvTbdwQa/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_14_15_43_+1100_D0F/4zQfvTbdwQa/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the mmc tree got a conflict in
drivers/mmc/host/au1xmmc.c between commit 404b3fb0b766 ("MMC: au1xmmc:
Remove Alchemy CPU subtype dependencies") from the mips tree and commit
a0c8202a148f ("mmc: replace printk with appropriate display macro") from
the mmc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/au1xmmc.c
index 56e7834,707bc7d..0000000
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@@ -1036,12 -1028,11 +1036,11 @@@ static int __devinit au1xmmc_probe(stru
  	tasklet_init(&host->finish_task, au1xmmc_tasklet_finish,
  			(unsigned long)host);
 =20
 -#ifdef CONFIG_SOC_AU1200
 -	ret =3D au1xmmc_dbdma_init(host);
 -	if (ret)
 -		pr_info(DRIVER_NAME ": DBDMA init failed; using PIO\n");
 -#endif
 +	if (has_dbdma()) {
 +		ret =3D au1xmmc_dbdma_init(host);
 +		if (ret)
- 			printk(KERN_INFO DRIVER_NAME ": DBDMA init failed; "
- 						     "using PIO\n");
++			pr_info(DRIVER_NAME ": DBDMA init failed; using PIO\n");
 +	}
 =20
  #ifdef CONFIG_LEDS_CLASS
  	if (host->platdata && host->platdata->led) {
@@@ -1189,15 -1181,15 +1188,15 @@@ static struct platform_driver au1xmmc_d
 =20
  static int __init au1xmmc_init(void)
  {
 -#ifdef CONFIG_SOC_AU1200
 -	/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
 -	 * of 8 bits.  And since devices are shared, we need to create
 -	 * our own to avoid freaking out other devices.
 -	 */
 -	memid =3D au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
 -	if (!memid)
 -		pr_err("au1xmmc: cannot add memory dbdma dev\n");
 -#endif
 +	if (has_dbdma()) {
 +		/* DSCR_CMD0_ALWAYS has a stride of 32 bits, we need a stride
 +		* of 8 bits.  And since devices are shared, we need to create
 +		* our own to avoid freaking out other devices.
 +		*/
 +		memid =3D au1xxx_ddma_add_device(&au1xmmc_mem_dbdev);
 +		if (!memid)
- 			printk(KERN_ERR "au1xmmc: cannot add memory dbdma\n");
++			pr_err("au1xmmc: cannot add memory dbdma dev\n");
 +	}
  	return platform_driver_register(&au1xmmc_driver);
  }
 =20

--Signature=_Wed__12_Oct_2011_14_15_43_+1100_D0F/4zQfvTbdwQa/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlQZfAAoJEECxmPOUX5FEk0sP/1xZ2OmT5Y/qTUxt7cz8whtP
9yrWBmRGow9x2sYisxqJYaZd839ygO9KBpX6EdzC6eC8oH+U/inEkCPt8DXjV8Q3
677rybFfNV4IOsInzJy4SO67KmBfBumE31Rewudt5XXQYRhCPNbDbb6K+z5f5Ohw
Kr1j9PvjPGnl+CxOgl3S5bK7Ae9tL1GbuWJBWcXtsKVO5ZaFPHGHKodE2NPeV3JA
EfK2KM3nuKHafz8z8A9o3BK4g4OiCAgzh6ZHpIfsPUgXbdE65AlpDGHuRrZ6t4oQ
1NY86SpB++W2B+eCIcRp8NdLzkOO0ekEKuSgldAL9MjQKajMIfvPpGPNBwP4Hssy
iqCBb9144a3qeZiNmYeTQJWAPSdJCF33I4N9nq1bcWW4o5UgEYO7OWle7j+uptzD
Vnv19lC/0NgPziLJnR8qtxGWEK7nRpnFFKlH5GA2/rHJ7cPOM90MJaOvdkFAO0fK
QXYW5cP9URz65gTDtV2lILUDfhTpv7pbA3H65QNfBdqgyTeOQ5rCin0k04O02s0E
5cqBw31txHEeSPOECbOSxPSuVtRKQyOzxknuxRm+FoDhaNw+Wc5ZeHR3NHRj6e3s
EFzZJGyG+OchSgVmAvpzn/JIm/WaCZ46pF0wOL4v1RRS4bE68fJHimED2qE9pBMT
QQ4xo6MG8Hk/jLsIRL3h
=k8Ax
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_14_15_43_+1100_D0F/4zQfvTbdwQa/--
