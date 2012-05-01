Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2EAX37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:29:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61700 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2EAX36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:29:58 -0400
MIME-Version: 1.0
In-Reply-To: <4FA056A1.1040209@us.ibm.com>
References: <4FA056A1.1040209@us.ibm.com>
From: Nicolas Dechesne <ndec13@gmail.com>
Date: Wed, 2 May 2012 01:29:36 +0200
Message-ID: <CAOT3miKZ7daBum7FKntbUHwsK7TAdyT4HG3X_bs9TDjwEEnhUw@mail.gmail.com>
Subject: Re: omap-usb-host.c compile error
To: John Stultz <johnstul@us.ibm.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "Bergmann, Arnd" <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 11:33 PM, John Stultz <johnstul@us.ibm.com> wrote:
> I've been seeing the following compile issue for a few -rcs now:
> drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of function
> 'cpu_is_omap3430'
> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of function
> 'omap_rev'
> drivers/mfd/omap-usb-host.c:524: error: 'OMAP3430_REV_ES2_1' undeclared
> (first use in this function)
> drivers/mfd/omap-usb-host.c:524: error: (Each undeclared identifier is
> reported only once
> drivers/mfd/omap-usb-host.c:524: error: for each function it appears in.)
>
> Reverting 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 seems to resolve it.
>
> This still isn't fixed in Linus' HEAD. Any plans here?

in fact the problem is related to this part of 1fcb57d0f6

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 95a2e54..c8aae66 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -25,7 +25,6 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
-#include <linux/gpio.h>
 #include <plat/usb.h>
 #include <linux/pm_runtime.h>

by removing linux/gpio.h, we remove the inclusion of plat/cpu.h which
has the definition of cpu_is_omap3430()
