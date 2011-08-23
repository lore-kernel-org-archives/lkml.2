Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1HWLxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:53:19 -0400
Received: from d1.icnet.pl ([212.160.220.21]:56584 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1HWLxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:53:15 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Aug 2011 07:53:15 EDT
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3.1-rc3] gpio/omap: fix build error with certain OMAP1 configs
Date: Tue, 23 Aug 2011 13:42:24 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231342.25101.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit f64ad1a0e21a, "gpio/omap: cleanup _set_gpio_wakeup(), remove 
ifdefs", access to build time conditionally omitted 'suspend_wakeup' 
member of the 'gpio_bank' structure has been placed unconditionally in 
function _set_gpio_wakeup(), which is always built. This resulted in the 
driver compilation broken for certain OMAP1, i.e., non-OMAP16xx, 
configurations.

Really required or not in previously excluded cases, define this 
structure member unconditionally as a fix.

Tested with a custom OMAP1510 only configuration.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/gpio/gpio-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- git/drivers/gpio/gpio-omap.c.orig	2011-08-22 08:34:02.000000000 +0200
+++ git/drivers/gpio/gpio-omap.c	2011-08-23 12:47:36.000000000 +0200
@@ -34,8 +34,8 @@ struct gpio_bank {
 	u16 irq;
 	u16 virtual_irq_start;
 	int method;
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
 	u32 suspend_wakeup;
+#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
 	u32 saved_wakeup;
 #endif
 	u32 non_wakeup_gpios;
