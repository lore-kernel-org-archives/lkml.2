Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898Ab0KRXqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:46:33 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:53342 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0KRXqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:46:32 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h67dh685h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH] ARM: imx: Return the correct chip version instead of zero for mx51 and mx53
Date: Thu, 18 Nov 2010 17:51:41 -0600
Message-ID: <1290124301-6286-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

get_mx51_srev() and get_mx53_srev() are returning zero so cpu_silicon_rev
becomes zero instead of the correct chip version.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/cpu.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
index 974a22f..0949251 100644
--- a/arch/arm/mach-mx5/cpu.c
+++ b/arch/arm/mach-mx5/cpu.c
@@ -22,22 +22,20 @@ static int cpu_silicon_rev = -1;
 
 #define SREV 0x24
 
-static int get_mx51_srev(u32 rev)
+static void get_mx51_srev(u32 rev)
 {
 	if (rev == 0x0)
 		cpu_silicon_rev = IMX_CHIP_REVISION_2_0;
 	else if (rev == 0x10)
 		cpu_silicon_rev = IMX_CHIP_REVISION_3_0;
-	return 0;
 }
 
-static int get_mx53_srev(u32 rev)
+static void get_mx53_srev(u32 rev)
 {
 	if (rev == 0x0)
 		cpu_silicon_rev = IMX_CHIP_REVISION_1_0;
 	else if (rev == 0x10)
 		cpu_silicon_rev = IMX_CHIP_REVISION_2_0;
-	return 0;
 }
 
 static void query_silicon_parameter(void)
@@ -54,9 +52,9 @@ static void query_silicon_parameter(void)
 
 	cpu_silicon_rev = 0;
 	if (cpu_is_mx51())
-		cpu_silicon_rev = get_mx51_srev(rev);
+		get_mx51_srev(rev);
 	else if(cpu_is_mx53())
-		cpu_silicon_rev = get_mx53_srev(rev);
+		get_mx53_srev(rev);
 }
 
 /*
-- 
1.6.0.4


