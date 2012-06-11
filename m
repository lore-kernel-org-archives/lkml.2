Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2FKLDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:03:18 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:49083 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215Ab2FKLCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:02:53 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 14/14] ARM: LPC32xx: Remove mach specific ARCH_NR_GPIOS, use default
Date: Mon, 11 Jun 2012 13:02:17 +0200
Message-Id: <1339412537-24485-15-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339412537-24485-1-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_NR_GPIOS was defined statically to include exactly all SoC specific GPIOs.
Now if additional GPIOs need to be added dynamically, e.g. via DT, none are
available. Removing the mach specific setting, leaving ARCH_NR_GPIOS to the
default of 256 (currently in include/asm-generic/gpio.h).

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/include/mach/gpio.h |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/include/mach/gpio.h
+++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/gpio.h
@@ -3,6 +3,4 @@
 
 #include "gpio-lpc32xx.h"
 
-#define ARCH_NR_GPIOS (LPC32XX_GPO_P3_GRP + LPC32XX_GPO_P3_MAX)
-
 #endif /* __MACH_GPIO_H */
