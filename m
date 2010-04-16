Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0DPMil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:38:41 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:14744 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab0DPMij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:38:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEL3x0tbstep/2dsb2JhbACbcXK+HA2FAQQ
Date: Fri, 16 Apr 2010 14:38:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>,
       Marc Zyngier <maz@misterjones.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [WATCHDOG] v2.6.34-rc4 watchdog fixes
Message-ID: <20100416123837.GA30005@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig       |    8 ++++----
 drivers/watchdog/booke_wdt.c   |    2 +-
 drivers/watchdog/max63xx_wdt.c |    7 ++++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

with these Changes:

Author: Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed Apr 7 19:57:02 2010 +0200

    [WATCHDOG] max63xx driver depends on ioremap()
    
    Correct fix for the "ioremap() causes build failure on S390" should have been
    a dependancy on HAS_IOMEM. So we add this dependancy also (and leave the driver
    in the ARM section for now).
    
    Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Marc Zyngier <maz@misterjones.org>
Date:   Fri Apr 9 17:43:33 2010 +0100

    [WATCHDOG] max63xx: be careful when disabling the watchdog
    
    When shutting down the watchdog timer, special care must be taken
    not to overwrite other bits in the register, as it may be shared
    with other peripherals.
    
    For example, on the Arcom Vulcan, the register is shared between
    the watchdog and the PCI reset line...
    
    Signed-off-by: Marc Zyngier <maz@misterjones.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
Date:   Thu Apr 15 15:59:10 2010 +1200

    [WATCHDOG] fixed book E watchdog period register mask.
    
    A previous fix changed the WDTP function to use the period directly,
    rather than subtracting from 63.  However the mask generation was
    not changed, so the mask was coming out as 0.  This patch fixes it.
    
    Signed-off-by: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date:   Wed Apr 7 13:17:22 2010 +0530

    [WATCHDOG] omap4: Fix WDT Kconfig
    
    This patch allows Watchdog timer to be selected for OMAP4 by fixing
    Kconfig entry
    
    Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 0e8468f..0bf5020 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -194,10 +194,10 @@ config EP93XX_WATCHDOG
 
 config OMAP_WATCHDOG
 	tristate "OMAP Watchdog"
-	depends on ARCH_OMAP16XX || ARCH_OMAP2 || ARCH_OMAP3
+	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS
 	help
-	  Support for TI OMAP1610/OMAP1710/OMAP2420/OMAP3430 watchdog.  Say 'Y'
-	  here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430 watchdog timer.
+	  Support for TI OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog.  Say 'Y'
+	  here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog timer.
 
 config PNX4008_WATCHDOG
 	tristate "PNX4008 Watchdog"
@@ -302,7 +302,7 @@ config TS72XX_WATCHDOG
 
 config MAX63XX_WATCHDOG
 	tristate "Max63xx watchdog"
-	depends on ARM
+	depends on ARM && HAS_IOMEM
 	help
 	  Support for memory mapped max63{69,70,71,72,73,74} watchdog timer.
 
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 8b724aa..500d383 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -44,7 +44,7 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
 #define WDTP(x)		((((x)&0x3)<<30)|(((x)&0x3c)<<15))
-#define WDTP_MASK	(WDTP(0))
+#define WDTP_MASK	(WDTP(0x3f))
 #else
 #define WDTP(x)		(TCR_WP(x))
 #define WDTP_MASK	(TCR_WP_MASK)
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 75f3a83..3053ff0 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -154,9 +154,14 @@ static void max63xx_wdt_enable(struct max63xx_timeout *entry)
 
 static void max63xx_wdt_disable(void)
 {
+	u8 val;
+
 	spin_lock(&io_lock);
 
-	__raw_writeb(3, wdt_base);
+	val = __raw_readb(wdt_base);
+	val &= ~MAX6369_WDSET;
+	val |= 3;
+	__raw_writeb(val, wdt_base);
 
 	spin_unlock(&io_lock);
 
