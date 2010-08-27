Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0H0Ttv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:49:51 -0400
Received: from void.printf.net ([89.145.121.20]:33150 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0H0Ttr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:49:47 -0400
Date: Fri, 27 Aug 2010 20:49:39 +0100
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-mmc@vger.kernel.org
Subject: [PATCH RESEND] initialise DMA engine before MMC
Message-ID: <20100827194939.GJ23079@void.printf.net>
References: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew, mind taking this one?

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Mon, 7 Jun 2010 13:16:36 +0200 (CEST)

To use DMA engine based DMA with MMC in a non-modular build, the DMA 
engine has to initialise before MMC.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
diff --git a/drivers/Makefile b/drivers/Makefile
index 91874e0..b713e75 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_EISA)		+= eisa/
 obj-y				+= lguest/
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
+obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
@@ -102,7 +103,6 @@ obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
 obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
-obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
--
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
