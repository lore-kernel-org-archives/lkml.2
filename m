Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab0HLAN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:13:26 -0400
Received: from kroah.org ([198.145.64.141]:47892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab0HLAIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:41 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:16 2010
Message-Id: <20100812000616.724184620@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [44/67] ARM: 6280/1: imx: Fix build failure when including <mach/gpio.h> without <linux/spinlock.h>
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 868003ca7ad17ac6c1606dc36101f10a7825b399 upstream.

This is a follow up to

	14cb0de (arm/imx/gpio: add spinlock protection)

and fixes the following build failure:

	  CC      arch/arm/mach-imx/pcm970-baseboard.o
	In file included from arch/arm/include/asm/gpio.h:6,
			 from include/linux/gpio.h:8,
			 from arch/arm/mach-imx/pcm970-baseboard.c:20:
	arch/arm/plat-mxc/include/mach/gpio.h:40: error: expected specifier-qualifier-list before 'spinlock_t'

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

---
 arch/arm/plat-mxc/include/mach/gpio.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -19,6 +19,7 @@
 #ifndef __ASM_ARCH_MXC_GPIO_H__
 #define __ASM_ARCH_MXC_GPIO_H__
 
+#include <linux/spinlock.h>
 #include <mach/hardware.h>
 #include <asm-generic/gpio.h>
 


