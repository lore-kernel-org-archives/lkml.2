Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2CIHHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:07:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58533 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2CIHHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:07:10 -0500
Date: Fri, 9 Mar 2012 18:06:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>, Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120309180647.a27cc03a8997f9b38eb8ad0e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_18_06_47_+1100_Uj+.7.L.zLAd5e+p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_18_06_47_+1100_Uj+.7.L.zLAd5e+p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/mach-imx/mm-imx3.c and arch/arm/mach-imx/mm-imx5.c between
commit 3bc34a614335 ("ARM: imx: convert audmux to a platform driver")
from the sound tree and commits 38bb3630bcba ("ARM: mx35: Setup the AIPS
registers") and aa6a9fa1f274 ("ARM: mx5: Use common function for
configuring AIPS") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mm-imx3.c
index 9c9b7f9,1646991..0000000
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@@ -177,8 -175,9 +179,12 @@@ void __init imx31_soc_init(void
  	}
 =20
  	imx_add_imx_sdma("imx31-sdma", MX31_SDMA_BASE_ADDR, MX31_INT_SDMA, &imx3=
1_sdma_pdata);
+=20
+ 	imx_set_aips(MX31_IO_ADDRESS(MX31_AIPS1_BASE_ADDR));
+ 	imx_set_aips(MX31_IO_ADDRESS(MX31_AIPS2_BASE_ADDR));
++
 +	platform_device_register_simple("imx31-audmux", 0, imx31_audmux_res,
 +					ARRAY_SIZE(imx31_audmux_res));
  }
  #endif /* ifdef CONFIG_SOC_IMX31 */
 =20
@@@ -267,8 -262,9 +273,13 @@@ void __init imx35_soc_init(void
  	}
 =20
  	imx_add_imx_sdma("imx35-sdma", MX35_SDMA_BASE_ADDR, MX35_INT_SDMA, &imx3=
5_sdma_pdata);
+=20
+ 	/* Setup AIPS registers */
+ 	imx_set_aips(MX35_IO_ADDRESS(MX35_AIPS1_BASE_ADDR));
+ 	imx_set_aips(MX35_IO_ADDRESS(MX35_AIPS2_BASE_ADDR));
++
 +	/* i.mx35 has the i.mx31 type audmux */
 +	platform_device_register_simple("imx31-audmux", 0, imx35_audmux_res,
 +					ARRAY_SIZE(imx35_audmux_res));
  }
  #endif /* ifdef CONFIG_SOC_IMX35 */
diff --cc arch/arm/mach-imx/mm-imx5.c
index dc7c4ed,92efece..0000000
--- a/arch/arm/mach-imx/mm-imx5.c
+++ b/arch/arm/mach-imx/mm-imx5.c
@@@ -201,9 -185,10 +201,14 @@@ void __init imx51_soc_init(void
 =20
  	/* i.mx51 has the i.mx35 type sdma */
  	imx_add_imx_sdma("imx35-sdma", MX51_SDMA_BASE_ADDR, MX51_INT_SDMA, &imx5=
1_sdma_pdata);
+=20
+ 	/* Setup AIPS registers */
+ 	imx_set_aips(MX51_IO_ADDRESS(MX51_AIPS1_BASE_ADDR));
+ 	imx_set_aips(MX51_IO_ADDRESS(MX51_AIPS2_BASE_ADDR));
++
 +	/* i.mx51 has the i.mx31 type audmux */
 +	platform_device_register_simple("imx31-audmux", 0, imx51_audmux_res,
 +					ARRAY_SIZE(imx51_audmux_res));
  }
 =20
  void __init imx53_soc_init(void)
@@@ -219,7 -204,8 +224,12 @@@
 =20
  	/* i.mx53 has the i.mx35 type sdma */
  	imx_add_imx_sdma("imx35-sdma", MX53_SDMA_BASE_ADDR, MX53_INT_SDMA, &imx5=
3_sdma_pdata);
+=20
+ 	/* Setup AIPS registers */
+ 	imx_set_aips(MX53_IO_ADDRESS(MX53_AIPS1_BASE_ADDR));
+ 	imx_set_aips(MX53_IO_ADDRESS(MX53_AIPS2_BASE_ADDR));
++
 +	/* i.mx53 has the i.mx31 type audmux */
 +	platform_device_register_simple("imx31-audmux", 0, imx53_audmux_res,
 +					ARRAY_SIZE(imx53_audmux_res));
  }

--Signature=_Fri__9_Mar_2012_18_06_47_+1100_Uj+.7.L.zLAd5e+p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWawHAAoJEECxmPOUX5FE9JMP/0r5ied+a0KS99lpjMcKJWLE
gmBA2+t7yoT3G20o9/ySRJvOyvz2sVtk3DcU59iEdHlzGz5kIQJ+5XW9wzuEMUcP
izapBPqZD3IIrhUbh1LJfQYgVszoqsAkoflfpPQ5kZiRz/2Aob37oPQbD41vbKqA
9TmX5Je10Sjrq6oNUS+5ET+derY/yis5CLl2lbfzvbYppQ0K40BV1pUAmMqDmiuT
312kMi5W2wmlA6tKbm0l74A+Sb8j3vOnlWqBxEltCMJcNFvez9XdPurDH/xqz8QJ
f7+FXGRIjQPYv2e8/vRV3S9baL1erILkyNyidadR7nu7gRpxB0/L+k/rQrH+deK3
ASlQvQQ68pF/Qq5gbnTJqmny3XGCioAQiMYahnQOAEVOLS42HP6UNNpSNYi6/Xe1
l0PkXiHnvvxCVWNEW7OaijVyNCT2ndWgWTVLpxHyJVdEipoO+q0bFcpMm82KvKmz
PjaAQ3K/DOsTffX6qRHnQyvoFN2aOkOHVqMbae9Xpp3RlLKf2Vde9Bj1OYIYRjGh
9vvQ0p+AoZwXOLKN+oSA8SwGoaRm0FJu5fHi5n9mKJ4id+jiwhlXhAAnDpT5LzQ4
t2NAFI4mb7RowEe5rdDl0vPKnVNsYmSCt1cRB97MfmkYSRV7tMv2uf0SFNIST+go
tRFmLP68kkHgGU1qWlHL
=6THz
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_18_06_47_+1100_Uj+.7.L.zLAd5e+p--
