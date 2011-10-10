Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1JJXK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 19:10:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43464 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750826Ab1JJXK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 19:10:57 -0400
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX1+AfAFe9f+A0MNHp9BVsqgy/51oBMV5nns+GWBaU4
	Wcb8vj8n4DrXbf
Message-ID: <1318288249.12675.6.camel@LAPJFS>
Subject: [PATCH] Fix file references in Kconfig files
From: Johann Felix Soden <johfel@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Oct 2011 01:10:49 +0200
In-Reply-To: <alpine.LNX.2.00.1110102350170.14768@pobox.suse.cz>
References: <1317683499.5990.2.camel@LAPJFS> <4E934066.80109@xenotime.net>
	 <alpine.LNX.2.00.1110102350170.14768@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

This patch fixes file references to moved or deleted files
outside of Documentation/.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>

---
This patch fixes references that are not in the big patch from 
Paul Bolle or in my drivers/ide/Kconfig patch (both in trivial.git).

 arch/cris/Kconfig          |    4 ++--
 arch/cris/arch-v10/Kconfig |   12 ++++++------
 drivers/net/irda/Kconfig   |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 17addac..408b055 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -282,8 +282,8 @@ config ETRAX_RTC
 	  Enables drivers for the Real-Time Clock battery-backed chips on
 	  some products. The kernel reads the time when booting, and
 	  the date can be set using ioctl(fd, RTC_SET_TIME, &rt) with rt a
-	  rtc_time struct (see <file:include/asm-cris/rtc.h>) on the /dev/rtc
-	  device.  You can check the time with cat /proc/rtc, but
+	  rtc_time struct (see <file:arch/cris/include/asm/rtc.h>) on the
+	  /dev/rtc device.  You can check the time with cat /proc/rtc, but
 	  normal time reading should be done using libc function time and
 	  friends.
 
diff --git a/arch/cris/arch-v10/Kconfig b/arch/cris/arch-v10/Kconfig
index adc164e..df9a38b 100644
--- a/arch/cris/arch-v10/Kconfig
+++ b/arch/cris/arch-v10/Kconfig
@@ -24,8 +24,8 @@ config ETRAX_PA_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent.  It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on port PA.  Some products
 	  put the leds on PB or a memory-mapped latch (CSP0) instead.
 
@@ -34,8 +34,8 @@ config ETRAX_PB_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent.  It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on port PB.  Some products
 	  put the leds on PA or a memory-mapped latch (CSP0) instead.
 
@@ -44,8 +44,8 @@ config ETRAX_CSP0_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent. It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on a memory-mapped latch
 	  using chip select CSP0, this is mapped at 0x90000000.
 	  Some products put the leds on PA or PB instead.
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 25bb2a0..a40fab4 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -183,7 +183,7 @@ config OLD_BELKIN_DONGLE
 	  Say Y here if you want to build support for the Adaptec Airport 1000
 	  and 2000 dongles.  If you want to compile it as a module, choose
 	  M here. Some information is contained in the comments
-	  at the top of <file:drivers/net/irda/old_belkin.c>.
+	  at the top of <file:drivers/net/irda/old_belkin-sir.c>.
 
 config ACT200L_DONGLE
 	tristate "ACTiSYS IR-200L dongle"
-- 
1.7.6.3



