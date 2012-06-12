Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2FLMtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:49:49 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:1669 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840Ab2FLMts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:49:48 -0400
Message-ID: <1339505386.30984.123.camel@x61.thuisdomein>
Subject: [PATCH] ARM: pxa: remove eseries.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Jun 2012 14:49:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Jun 2012 12:49:46.0856 (UTC) FILETIME=[D8D3AE80:01CD4899]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e478fe4cd50b86e95fadc415438b63fa94060b7d ("[ARM] pxa: merge all
eseries board code into eseries.c") removed all six files that included
eseries.h. Everything that this header provides is now either local to
eseries.c or entirely unused. It was apparently just an oversight to
keep this header. This header can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Testing with "git grep" for various things in the (history of the) tree.

 arch/arm/mach-pxa/eseries.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)
 delete mode 100644 arch/arm/mach-pxa/eseries.h

diff --git a/arch/arm/mach-pxa/eseries.h b/arch/arm/mach-pxa/eseries.h
deleted file mode 100644
index b96949d..0000000
--- a/arch/arm/mach-pxa/eseries.h
+++ /dev/null
@@ -1,14 +0,0 @@
-void __init eseries_fixup(struct tag *tags, char **cmdline, struct meminfo *mi);
-
-extern struct pxa2xx_udc_mach_info e7xx_udc_mach_info;
-extern struct pxaficp_platform_data e7xx_ficp_platform_data;
-extern int e7xx_irda_init(void);
-
-extern int eseries_tmio_enable(struct platform_device *dev);
-extern int eseries_tmio_disable(struct platform_device *dev);
-extern int eseries_tmio_suspend(struct platform_device *dev);
-extern int eseries_tmio_resume(struct platform_device *dev);
-extern void eseries_get_tmio_gpios(void);
-extern struct resource eseries_tmio_resources[];
-extern struct platform_device e300_tc6387xb_device;
-
-- 
1.7.7.6

