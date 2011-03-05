Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1CEEtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 23:49:22 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38032 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab1CEEtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 23:49:20 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 23:49:20 EST
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Spang <mspang@csclub.uwaterloo.ca>
Subject: [PATCH 1/2] ARM: Add TS-7800 revisions 6-9
Date: Fri,  4 Mar 2011 23:39:16 -0500
Message-Id: <1299299957-13018-1-git-send-email-mspang@csclub.uwaterloo.ca>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTC, NAND, and RNG devices are not enabled on current TS-7800s.
The manufacturer is at revision 9 (at least), and they do support
these devices. We'll assume revisions 6 through 8 do as well.

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
---
 arch/arm/mach-orion5x/ts78xx-fpga.h  |    4 ++++
 arch/arm/mach-orion5x/ts78xx-setup.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-orion5x/ts78xx-fpga.h b/arch/arm/mach-orion5x/ts78xx-fpga.h
index 37b3d48..791f754 100644
--- a/arch/arm/mach-orion5x/ts78xx-fpga.h
+++ b/arch/arm/mach-orion5x/ts78xx-fpga.h
@@ -11,6 +11,10 @@ enum fpga_ids {
 	TS7800_REV_3	= FPGAID(0x00b480, 0x03),
 	TS7800_REV_4	= FPGAID(0x00b480, 0x04),
 	TS7800_REV_5	= FPGAID(0x00b480, 0x05),
+	TS7800_REV_6	= FPGAID(0x00b480, 0x06),
+	TS7800_REV_7	= FPGAID(0x00b480, 0x07),
+	TS7800_REV_8	= FPGAID(0x00b480, 0x08),
+	TS7800_REV_9	= FPGAID(0x00b480, 0x09),
 
 	/* Unaffordable & Expensive */
 	UAE_DUMMY	= FPGAID(0xffffff, 0x01),
diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index c1c1cd0..7bed418 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -334,6 +334,10 @@ static void ts78xx_fpga_supports(void)
 	case TS7800_REV_3:
 	case TS7800_REV_4:
 	case TS7800_REV_5:
+	case TS7800_REV_6:
+	case TS7800_REV_7:
+	case TS7800_REV_8:
+	case TS7800_REV_9:
 		ts78xx_fpga.supports.ts_rtc.present = 1;
 		ts78xx_fpga.supports.ts_nand.present = 1;
 		ts78xx_fpga.supports.ts_rng.present = 1;
-- 
1.7.2.3

