Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0D2AlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:41:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:52804 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752232Ab0D2AlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:41:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18w3+YoT30w2+80YgIruOXMoITDqb4GcQyJfzzDph
	I0vqkGW8kNRMUt
From: Peter Huewe <PeterHuewe@gmx.de>
To: David Brown <davidb@codeaurora.org>
Subject: [PATCH] arm/mach-msm: Add CONFIG conditional for board-trout
Date: Thu, 29 Apr 2010 02:41:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290241.23068.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch adds a conditional for CONFIG_MSM_DEBUG_UART to prevent a
build failure[1], this is done the same way as for every board in mach-msm.

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2448102/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100429

 arch/arm/mach-msm/board-trout.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 9793ff4..b88aec2 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -82,8 +82,10 @@ static void __init trout_map_io(void)
 }
 
 MACHINE_START(TROUT, "HTC Dream")
+#ifdef CONFIG_MSM_DEBUG_UART
 	.phys_io	= MSM_DEBUG_UART_PHYS,
 	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
+#endif
 	.boot_params	= 0x10000100,
 	.fixup		= trout_fixup,
 	.map_io		= trout_map_io,
-- 
1.6.4.4

