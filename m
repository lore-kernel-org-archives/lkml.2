Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1CEEtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 23:49:22 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59000 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab1CEEtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 23:49:21 -0500
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Spang <mspang@csclub.uwaterloo.ca>
Subject: [PATCH 2/2] ARM: Enable TS-78XX features in unknown revisions
Date: Fri,  4 Mar 2011 23:39:17 -0500
Message-Id: <1299299957-13018-2-git-send-email-mspang@csclub.uwaterloo.ca>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299299957-13018-1-git-send-email-mspang@csclub.uwaterloo.ca>
References: <1299299957-13018-1-git-send-email-mspang@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the manufacturer increases the revision number the platform
devices for the RTC, NAND, and RNG disappear. We should assume
new revisions have these devices instead of assuming they do not.

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
---
 arch/arm/mach-orion5x/ts78xx-setup.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index 7bed418..13d1fc5 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -343,9 +343,11 @@ static void ts78xx_fpga_supports(void)
 		ts78xx_fpga.supports.ts_rng.present = 1;
 		break;
 	default:
-		ts78xx_fpga.supports.ts_rtc.present = 0;
-		ts78xx_fpga.supports.ts_nand.present = 0;
-		ts78xx_fpga.supports.ts_rng.present = 0;
+		printk(KERN_WARN "Unrecognized TS-78XX FPGA ID 0x%02x",
+		       ts78xx_fpga.id);
+		ts78xx_fpga.supports.ts_rtc.present = 1;
+		ts78xx_fpga.supports.ts_nand.present = 1;
+		ts78xx_fpga.supports.ts_rng.present = 1;
 	}
 }
 
-- 
1.7.2.3

