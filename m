Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab2AFBDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:03:33 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38704 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab2AFBDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:03:31 -0500
Date: Fri, 6 Jan 2012 12:03:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Govindraj.R" <govindraj.raja@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120106120317.500c45afe95ae20b4b6648a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_12_03_17_+1100__uBF06hiR6nr6FhK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_12_03_17_+1100__uBF06hiR6nr6FhK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/pm34xx.c between commit e6ab10af962d ("ARM: OMAP:
convert idle handlers from pm_idle to arm_pm_idle") from the arm tree and
commit 2fd149645eb4 ("") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/pm34xx.c
index df5c6bf,fc69875..0000000
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@@ -485,21 -416,12 +416,11 @@@ void omap_sram_idle(void
  	clkdm_allow_idle(mpu_pwrdm->pwrdm_clkdms[0]);
  }
 =20
- int omap3_can_sleep(void)
- {
- 	if (!omap_uart_can_sleep())
- 		return 0;
- 	return 1;
- }
-=20
  static void omap3_pm_idle(void)
  {
 -	local_irq_disable();
  	local_fiq_disable();
 =20
- 	if (!omap3_can_sleep())
- 		goto out;
-=20
 -	if (omap_irq_pending() || need_resched())
 +	if (omap_irq_pending())
  		goto out;
 =20
  	trace_power_start(POWER_CSTATE, 1, smp_processor_id());

--Signature=_Fri__6_Jan_2012_12_03_17_+1100__uBF06hiR6nr6FhK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBkhVAAoJEECxmPOUX5FEBn0P/3QHOHp+BHRutPrAYTBa7Nbs
D44jO/+F3UiBD6AuzBY3MUuwgrVP76t28cfHlfHrQGZTdo/ZeWlC3+1lqre9y3nK
Wdig7F3a8SXOIKtZyVuT5pmR7yEfxsRx1PAI9S6ShtSvUN8cKyp+mA0N8DnfYyw9
iYZNvp0BicnnGsldIdyPJQqQqSH3coEgj6yHu8GiSXPk+aIEaXzUKugBRBgacxN7
ZXpXCO/3+EiC9DwwarDjiA5M/9UwIaWp25u9uAvYy8tWu7eXxWkICAQySU39OupC
ubAeqSWdshBS79Am8AFPPfh41UOfmpZeteUki0IY+a3Eza8vjIAH0Ba1HKd5PRdU
nGZaaeTMgKYXGj4ZO8FIK3KcwL/WRfSyWFGCbSDOjYdPTuuMY3zhGTW640npO/4i
p6A8mFWevgj3PiJoI2MBgQdUU34M1ALdfTP7Ix38lsNc9Y0Y5uXUBT86N3az7dIi
tuvTfJoDMR2w3F/BTTpyvKAWw/JywISdB7gUk6VN3t7hKOJCVYvokKq2zxTSfFBt
d4KV0ukfLA1npL33CRbrJH6hIkbF8hN7hSpibOlChDTnBENkH4Dbwgl/TdMwFzjx
FBM5mSn8oDnkXWddKyrAx2NK1Pv7clKF+k9nhFww1A2ICIUor6mh8K/WT7KDOA2G
lHDYvC30k5/UvJ8X0+W6
=Zwps
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_12_03_17_+1100__uBF06hiR6nr6FhK--
