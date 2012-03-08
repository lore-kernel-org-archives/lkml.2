Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2CHCj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:39:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57098 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2CHCjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:39:53 -0500
Date: Thu, 8 Mar 2012 13:39:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Kevin Hilman <khilman@ti.com>,
        =?UTF-8?B?IkhlaWtvIFN0w7xibmVyIg==?= <heiko@sntech.de>
Subject: linux-next: manual merge of the cpufreq tree with the
 cpufreq-current tree
Message-Id: <20120308133942.45065b61e8a8a6bf0e2aa2ed@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_13_39_42_+1100_/eRjWi6gvuS8Ic.u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_13_39_42_+1100_/eRjWi6gvuS8Ic.u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the cpufreq tree got a conflict in
drivers/cpufreq/Kconfig.arm between commit b09db45c56c2 ("cpufreq: OMAP
driver depends CPUfreq tables") from the cpufreq-current tree and commit
34ee55075265 ("[CPUFREQ] Add S3C2416/S3C2450 cpufreq driver") from the
cpufreq tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpufreq/Kconfig.arm
index 82f1aa9,dc59abf..0000000
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@@ -2,11 -2,28 +2,33 @@@
  # ARM CPU Frequency scaling drivers
  #
 =20
 +config ARM_OMAP2PLUS_CPUFREQ
 +	bool "TI OMAP2+"
 +	default ARCH_OMAP2PLUS
 +	select CPU_FREQ_TABLE
 +
+ config ARM_S3C2416_CPUFREQ
+ 	bool "S3C2416 CPU Frequency scaling support"
+ 	depends on CPU_S3C2416
+ 	help
+ 	  This adds the CPUFreq driver for the Samsung S3C2416 and
+ 	  S3C2450 SoC. The S3C2416 supports changing the rate of the
+ 	  armdiv clock source and also entering a so called dynamic
+ 	  voltage scaling mode in which it is possible to reduce the
+ 	  core voltage of the cpu.
+=20
+ 	  If in doubt, say N.
+=20
+ config ARM_S3C2416_CPUFREQ_VCORESCALE
+ 	bool "Allow voltage scaling for S3C2416 arm core (EXPERIMENTAL)"
+ 	depends on ARM_S3C2416_CPUFREQ && REGULATOR && EXPERIMENTAL
+ 	help
+ 	  Enable CPU voltage scaling when entering the dvs mode.
+ 	  It uses information gathered through existing hardware and
+ 	  tests but not documented in any datasheet.
+=20
+ 	  If in doubt, say N.
+=20
  config ARM_S3C64XX_CPUFREQ
  	bool "Samsung S3C64XX"
  	depends on CPU_S3C6410

--Signature=_Thu__8_Mar_2012_13_39_42_+1100_/eRjWi6gvuS8Ic.u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWBvuAAoJEECxmPOUX5FEX4IQAKkgBzmGxcdPzXwe3+uIuutt
rT9M0uzmMM1CAtirxad9XoOKL3/LNyIOhEc8hcnwkcblMl8SZCqNpznaz4YUMhZ+
rO+sP7LTxrycYiFv6a8I4IlzQXWZydPG3JiiFbUsg7cHMsBmpr+Y1EH7W/yBWjfI
qDQ7QL4Sy8vQk/qDWxeN4iHiBiMWJlG3USo5gqcyEGrGA6j2brzkov3NUcr9E/uE
S0asexAx9I65Q4xvXCa5S8uw2qxWu6IlK8Cn1GSeWKBzYdd6Pl194dxIxUQ7eHZx
Sd0BPv1PpLFvr3NO3yL7eyPEfq5GU/pUUCh7ACmmARNl2B6MCCTsknip0MGXHQsh
QvRAY+shkKcBpPIEdExf1b3tXhhOQUUIeqrM+xQZcHJDjVmG57Ia9GvEQAHy/+n9
a99g/zzZM9owYbkf4RtKjTIYoMIqQ1YFLPbLoWC9AoSlAq04dEktpR8shhowMBEa
4x8JMcvQt5g4P1+ZQ6gZND/IMvG/kLcTf9t1QC+XDFwCFqvbnQk1f3nIdMiJ1CRT
r55gWYGmTjCU9vJAkY5i84J8u7K7Xy9cz/svHVfy17fUM01IgPGMTI/TPWDoK+Qq
utCEyXc8i3R8j4Yj/o/IvhvlN8XWaVnIvfwuSAd7fBxsK9+FDUm8JAEcSHUzaKLc
hk2ZudbmT3Bjot0UumDk
=IMuY
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_13_39_42_+1100_/eRjWi6gvuS8Ic.u--
