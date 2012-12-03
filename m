Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2LCNgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:36:06 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52281 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2LCNgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:36:04 -0500
MIME-Version: 1.0
Date: Mon, 3 Dec 2012 08:36:03 -0500
Message-ID: <CAPgLHd_esknTwVv4EeehwSJz6ee5eFJ+zf6xntH-vaNwdxkrvg@mail.gmail.com>
Subject: [PATCH -next] powerpc/85xx: use for_each_compatible_node() macro
From: Wei Yongjun <weiyj.lk@gmail.com>
To: galak@kernel.crashing.org, benh@kernel.crashing.org, paulus@samba.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_compatible_node() macro instead of open coding it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/powerpc/platforms/85xx/mpc85xx_mds.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index bd12588..a7b3621 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -206,9 +206,7 @@ static void __init mpc85xx_mds_reset_ucc_phys(void)
 		setbits8(&bcsr_regs[7], BCSR7_UCC12_GETHnRST);
 		clrbits8(&bcsr_regs[8], BCSR8_UEM_MARVELL_RST);
 
-		for (np = NULL; (np = of_find_compatible_node(np,
-						"network",
-						"ucc_geth")) != NULL;) {
+		for_each_compatible_node(np, "network", "ucc_geth") {
 			const unsigned int *prop;
 			int ucc_num;
 

