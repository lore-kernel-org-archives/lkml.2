Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0F3QCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:02:37 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40099 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295Ab0F3QCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:02:35 -0400
Date: Wed, 30 Jun 2010 18:02:32 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       Mike Rapoport <mike@compulab.co.il>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Marek Vasut <marek.vasut@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 27/33] Removing dead IDE_PXA_CF
Message-ID: <a332e637ee15cb15f7099f5dfc19a384b2bf772b.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IDE_PXA_CF doesn't exist in Kconfig, therefore removing all references
for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-pxa/trizeps4.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
index 6968911..0acff17 100644
--- a/arch/arm/mach-pxa/trizeps4.c
+++ b/arch/arm/mach-pxa/trizeps4.c
@@ -530,13 +530,9 @@ static void __init trizeps4_init(void)
 	i2c_register_board_info(0, trizeps4_i2c_devices,
 					ARRAY_SIZE(trizeps4_i2c_devices));
 
-#ifdef CONFIG_IDE_PXA_CF
-	/* if boot direct from compact flash dont disable power */
-	trizeps_conxs_bcr = 0x0009;
-#else
 	/* this is the reset value */
 	trizeps_conxs_bcr = 0x00A0;
-#endif
+
 	BCR_writew(trizeps_conxs_bcr);
 	board_backlight_power(1);
 }
-- 
1.7.0.4

