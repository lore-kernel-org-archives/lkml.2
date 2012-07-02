Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2GBFzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 01:55:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab2GBFzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 01:55:37 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "tony@atomide.com" <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: OMAP AM35x: clockdomain data: fix resolving dependency
 problem
Thread-Topic: [PATCH] ARM: OMAP AM35x: clockdomain data: fix resolving
 dependency problem
Thread-Index: Ac1YFzSz7oPLHyT4Q46Oe8rXkWtZLw==
Date: Mon, 2 Jul 2012 05:54:57 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FCB33@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In am35x board , iva2 clock domain doesn't be used.
So mpu_am35x_clkdm should be used rather than mpu_3xxx_clkdm.
OMAP3430 : mpu_3xxx_clkdm (with iva2 clkdm)
AM35x    : mpu_am35x_clkdm (without iva2 clkdm)

For the compatibility with omap3430, this patch has no conflict because mpu_3xxx_clkdm was already defined in clock domains for omap3430.
So this can be removed from common clock domain.

Below error can be fixed with this patch.

[    0.000000] AM3517 ES1.1 (l2cache sgx neon )
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/arm/mach-omap2/clockdomain.c:237 _resolve_clkdm_deps+0x68/0x108()
[    0.000000] clockdomain: mpu_clkdm: could not find clkdm iva2_clkdm while resolving dependencies - should never happen
[    0.000000] Modules linked in:
[    0.000000] [<c001bd3c>] (unwind_backtrace+0x0/0xf4) from [<c0040c2c>] (warn_slowpath_common+0x4c/0x64)
[    0.000000] [<c0040c2c>] (warn_slowpath_common+0x4c/0x64) from [<c0040cd8>] (warn_slowpath_fmt+0x30/0x40)
[    0.000000] [<c0040cd8>] (warn_slowpath_fmt+0x30/0x40) from [<c003256c>] (_resolve_clkdm_deps+0x68/0x108)
[    0.000000] [<c003256c>] (_resolve_clkdm_deps+0x68/0x108) from [<c0032640>] (clkdm_complete_init+0x34/0x90)
[    0.000000] [<c0032640>] (clkdm_complete_init+0x34/0x90) from [<c06d7600>] (omap3_init_early+0x20/0x30)
[    0.000000] [<c06d7600>] (omap3_init_early+0x20/0x30) from [<c06d3230>] (setup_arch+0x834/0x94c)
[    0.000000] [<c06d3230>] (setup_arch+0x834/0x94c) from [<c06cf6b0>] (start_kernel+0x88/0x2fc)
[    0.000000] [<c06cf6b0>] (start_kernel+0x88/0x2fc) from [<80008044>] (0x80008044)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 arch/arm/mach-omap2/clockdomains3xxx_data.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomains3xxx_data.c b/arch/arm/mach-omap2/clockdomains3xxx_data.c
index d625844..56089c4 100644
--- a/arch/arm/mach-omap2/clockdomains3xxx_data.c
+++ b/arch/arm/mach-omap2/clockdomains3xxx_data.c
@@ -454,7 +454,6 @@ static struct clkdm_autodep clkdm_am35x_autodeps[] = {
 
 static struct clockdomain *clockdomains_common[] __initdata = {
 	&wkup_common_clkdm,
-	&mpu_3xxx_clkdm,
 	&neon_clkdm,
 	&core_l3_3xxx_clkdm,
 	&core_l4_3xxx_clkdm,
-- 
1.7.2.5


Thanks & BR
Milo -


