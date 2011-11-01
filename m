Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1KAVdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:33:25 -0400
Received: from plexity.net ([206.123.115.38]:42172 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab1KAVdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:33:16 -0400
Date: Tue, 1 Nov 2011 14:25:01 -0700
From: Deepak Saxena <dsaxena@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, patches@linaro.org
Subject: [PATCH] Remove CLOCK_TICK_RATE from acpi_pm clocksource driver
Message-ID: <20111101212501.GA31143@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi_pm clocksource driver uses CLOCK_TICK_RATE which is
defined as PIT_TICK_RATE on x86. This patch cleans it up to
just use the later so that CLOCK_TICK_RATE can be depecrated.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
---
 drivers/clocksource/acpi_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index effe797..6b5cf02 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -143,7 +143,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
 #ifndef CONFIG_X86_64
 #include <asm/mach_timer.h>
 #define PMTMR_EXPECTED_RATE \
-  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
+  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (PIT_TICK_RATE>>10))
 /*
  * Some boards have the PMTMR running way too fast. We check
  * the PMTMR rate against PIT channel 2 to catch these cases.
-- 
1.7.4.1

