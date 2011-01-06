Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1AFCbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:31:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35115 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1AFCbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:31:13 -0500
Date: Thu, 6 Jan 2011 13:31:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Eric Miao <eric.y.miao@gmail.com>
Subject: linux-next: manual merge of the bjdooks-i2c tree with the arm tree
Message-Id: <20110106133107.463c3e60.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Today's linux-next merge of the bjdooks-i2c tree got a conflict in
arch/arm/mach-pxa/pxa27x.c, arch/arm/mach-pxa/pxa3xx.c and
arch/arm/mach-pxa/trizeps4.c between commit
ad68bb9f7a3cd47396635a5e3895215af57579da ("ARM: pxa: Access SMEMC via
virtual addresses") from the arm tree and commit
0a56f28ec486273d84d25571573908344aa67176 ("arm/pxa2xx: reorganize I2C
files") from the bjdooks-i2c tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-pxa/pxa27x.c
index b2130b7,1c77e89..0000000
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@@ -17,9 -17,8 +17,10 @@@
  #include <linux/suspend.h>
  #include <linux/platform_device.h>
  #include <linux/sysdev.h>
 +#include <linux/io.h>
+ #include <linux/i2c/pxa-i2c.h>
  
 +#include <asm/mach/map.h>
  #include <mach/hardware.h>
  #include <asm/irq.h>
  #include <mach/irqs.h>
@@@ -29,10 -28,7 +30,8 @@@
  #include <mach/ohci.h>
  #include <mach/pm.h>
  #include <mach/dma.h>
 +#include <mach/smemc.h>
  
- #include <plat/i2c.h>
- 
  #include "generic.h"
  #include "devices.h"
  #include "clock.h"
diff --cc arch/arm/mach-pxa/pxa3xx.c
index e14818f,c9d9729..0000000
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@@ -21,8 -21,8 +21,9 @@@
  #include <linux/irq.h>
  #include <linux/io.h>
  #include <linux/sysdev.h>
+ #include <linux/i2c/pxa-i2c.h>
  
 +#include <asm/mach/map.h>
  #include <mach/hardware.h>
  #include <mach/gpio.h>
  #include <mach/pxa3xx-regs.h>
@@@ -31,8 -31,6 +32,7 @@@
  #include <mach/pm.h>
  #include <mach/dma.h>
  #include <mach/regs-intc.h>
 +#include <mach/smemc.h>
- #include <plat/i2c.h>
  
  #include "generic.h"
  #include "devices.h"
diff --cc arch/arm/mach-pxa/trizeps4.c
index 43fc9ca,995e671..0000000
--- a/arch/arm/mach-pxa/trizeps4.c
+++ b/arch/arm/mach-pxa/trizeps4.c
@@@ -47,8 -47,6 +47,7 @@@
  #include <mach/mmc.h>
  #include <mach/irda.h>
  #include <mach/ohci.h>
 +#include <mach/smemc.h>
- #include <plat/i2c.h>
  
  #include "generic.h"
  #include "devices.h"
