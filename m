Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1COObu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:31:50 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:9514
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757946Ab1COObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:31:47 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz4015Lzz1202hzz8275eh8275bh8275dha1495iz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI3SCP-02-BW9-02
X-M-MSG: 
Date: Tue, 15 Mar 2011 15:31:37 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Wang Lei <f3d27b@gmail.com>
Subject: [PATCH] x86, quirk: Fix SB600 revision check
Message-ID: <20110315143137.GD29499@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
(x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems)
introduced a regression. It removed some SB600 specific code
to determine the revision ID without adapting a corresponding
revision ID check for SB600.

See this mail thread
http://marc.info/?l=linux-kernel&m=129980296006380&w=2

This patch adapts the corresponding check to cover all SB600
revisions.

Cc: stable@kernel.org # 38.x, 37.x, 32.x
Tested-by: Wang Lei <f3d27b@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/early-quirks.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


Mea culpa!
A fix for a BIOS issue on some Lenovo systems introduced a regression
on another set of boxes (older HP Laptops) that have other BIOS
trouble.

Sorry for introducing this regression in .38.

Patch is on top of 2.6.38. Please apply.


Thanks,

Andreas


diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 9efbdcc..3755ef4 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -159,7 +159,12 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)
-- 
1.7.4.1


