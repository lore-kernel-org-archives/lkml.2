Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0DUVSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:18:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:22545 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0DUVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:18:38 -0400
Date: Thu, 22 Apr 2010 00:17:07 +0300
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux@arm.linux.org.uk
Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fix build error for i.MX51 (mx51_defconfig)
Message-ID: <20100421211707.GC2951@matterhorn.lan>
Mail-Followup-To: linux@arm.linux.org.uk,
	Dinh Nguyen <Dinh.Nguyen@freescale.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Please apply the following patch to fix build failure for i.MX51 in
2.6.34-rc5.

Regards,
Amit


>From 3a30bc0788e02ba069c003d194680a2d39ef1c1a Mon Sep 17 00:00:00 2001
Message-Id: <3a30bc0788e02ba069c003d194680a2d39ef1c1a.1271883980.git.amit.kucheria@canonical.com>
From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Date: Tue, 13 Apr 2010 14:05:08 -0500
Subject: [2.6.34-fixes 1/1] mx5: Fix build error for mx51_defconfig

Need to include <asm/div64.h> for do_div calls. Fixes the following error:

arch/arm/mach-mx5/clock-mx51.c: In function 'clk_pll_get_rate':
arch/arm/mach-mx5/clock-mx51.c:149: error: implicit declaration of function
'do_div'
make[1]: *** [arch/arm/mach-mx5/clock-mx51.o] Error 1

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/mach-mx5/clock-mx51.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
index 8f85f73..1ee6ce4 100644
--- a/arch/arm/mach-mx5/clock-mx51.c
+++ b/arch/arm/mach-mx5/clock-mx51.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 
 #include <asm/clkdev.h>
+#include <asm/div64.h>
 
 #include <mach/hardware.h>
 #include <mach/common.h>
-- 
1.7.0.4


-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
