Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0DPJ66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 05:58:58 -0400
Received: from mail2.donator.se ([217.16.195.8]:2489 "EHLO mail2.donator.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0DPJ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 05:58:56 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 05:58:56 EDT
X-MDAV-Processed: mail2.donator.se, Fri, 16 Apr 2010 11:51:14 +0200
X-Spam-Processed: mail2.donator.se, Fri, 16 Apr 2010 11:51:14 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: jakob.viketoft@bitsim.com
X-MDRemoteIP: 10.99.195.158
X-Return-Path: jakob.viketoft@bitsim.com
X-Envelope-From: jakob.viketoft@bitsim.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <4BC8330E.6000503@bitsim.com>
Date: Fri, 16 Apr 2010 11:51:10 +0200
From: Jakob Viketoft <jakob.viketoft@bitsim.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Daniel Mack <daniel@caiaq.de>, Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] colibri.h: Fix building for colibri 270...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Reply-To: jakob.viketoft@bitsim.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent addition of (Colibri) PXA3xx specific declarations breaks the 
building of the Colibri 270 with similar features.

CC: Daniel Mack <daniel@caiaq.de>
CC: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by <jakob.viketoft@bitsim.com>

--- a/arch/arm/mach-pxa/include/mach/colibri.h	2010-03-15 
17:09:39.000000000 +0100
+++ b/arch/arm/mach-pxa/include/mach/colibri.h	2010-04-16 
11:06:15.000000000 +0200
@@ -7,6 +7,7 @@
   * common settings for all modules
   */

+#if defined(CONFIG_MACH_COLIBRI300) || defined(CONFIG_MACH_COLIBRI320)
  #if defined(CONFIG_MMC_PXA) || defined(CONFIG_MMC_PXA_MODULE)
  extern void colibri_pxa3xx_init_mmc(mfp_cfg_t *pins, int len, int 
detect_pin);
  #else
@@ -28,6 +29,7 @@
  #else
  static inline void colibri_pxa3xx_init_nand(void) {}
  #endif
+#endif

  /* physical memory regions */
  #define COLIBRI_SDRAM_BASE	0xa0000000      /* SDRAM region */

