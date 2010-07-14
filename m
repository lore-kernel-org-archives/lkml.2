Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0GNLcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:32:18 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40393 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab0GNLcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:32:14 -0400
Date: Wed, 14 Jul 2010 13:32:12 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/3] usb/host || arch/arm: Remove dead CONFIG_ARCH_KARO
Message-ID: <9df7166bb950e7fbc12d1be9f2b9f9cbb9961187.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_ARCH_KARO doesn't exist in Kconfig and is never defined anywhere
else, therefore removing all references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/arm/tools/mach-types  |    1 -
 drivers/usb/host/isp1362.h |   24 +-----------------------
 2 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 8f10d24..3d86318 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -204,7 +204,6 @@ omaha			ARCH_OMAHA		OMAHA			186
 ta7			ARCH_TA7		TA7			187
 nova			SA1100_NOVA		NOVA			188
 hmk			ARCH_HMK		HMK			189
-karo			ARCH_KARO		KARO			190
 fester			SA1100_FESTER		FESTER			191
 gpi			ARCH_GPI		GPI			192
 smdk2410		ARCH_SMDK2410		SMDK2410		193
diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
index d995351..0f97820 100644
--- a/drivers/usb/host/isp1362.h
+++ b/drivers/usb/host/isp1362.h
@@ -8,29 +8,7 @@
 /*
  * Platform specific compile time options
  */
-#if defined(CONFIG_ARCH_KARO)
-#include <asm/arch/hardware.h>
-#include <asm/arch/pxa-regs.h>
-#include <asm/arch/karo.h>
-
-#define USE_32BIT		1
-
-
-/* These options are mutually eclusive */
-#define USE_PLATFORM_DELAY	1
-#define USE_NDELAY		0
-/*
- * MAX_ROOT_PORTS: Number of downstream ports
- *
- * The chip has two USB ports, one of which can be configured as
- * an USB device port, so the value of this constant is implementation
- * specific.
- */
-#define MAX_ROOT_PORTS		2
-#define DUMMY_DELAY_ACCESS do {} while (0)
-
-/* insert platform specific definitions for other machines here */
-#elif defined(CONFIG_BLACKFIN)
+#if defined(CONFIG_BLACKFIN)
 
 #include <linux/io.h>
 #define USE_32BIT		0
-- 
1.7.0.4

