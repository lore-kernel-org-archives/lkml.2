Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab2FQSXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:23:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50355 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758472Ab2FQSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:56 -0400
Message-Id: <20120617175946.412420440@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 36/69] ARM i.MX imx21ads: Fix overlapping static i/o mappings
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>

commit 350ab15bb2ffe7103bc6bf6c634f3c5b286eaf2a upstream.

The statically defined I/O memory regions for the i.MX21 on chip
peripherals and the on board I/O peripherals of the i.MX21ADS board
overlap. This results in a kernel crash during startup. This is fixed
by reducing the memory range for the on board I/O peripherals to the
actually required range.

Signed-off-by: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-imx/mach-mx21ads.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mach-mx21ads.c b/arch/arm/mach-imx/mach-mx21ads.c
index e432d4a..4460d25 100644
--- a/arch/arm/mach-imx/mach-mx21ads.c
+++ b/arch/arm/mach-imx/mach-mx21ads.c
@@ -32,7 +32,7 @@
  * Memory-mapped I/O on MX21ADS base board
  */
 #define MX21ADS_MMIO_BASE_ADDR   0xf5000000
-#define MX21ADS_MMIO_SIZE        SZ_16M
+#define MX21ADS_MMIO_SIZE        0xc00000
 
 #define MX21ADS_REG_ADDR(offset)    (void __force __iomem *) \
 		(MX21ADS_MMIO_BASE_ADDR + (offset))


