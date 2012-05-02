Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2EBIIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:08:42 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:34554 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2EBIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:08:37 -0400
Date: Wed, 2 May 2012 02:08:36 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: zbr@ioremap.net
cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] W1: OMAP HDQ1W: allow driver to be built on all OMAP2+
Message-ID: <alpine.DEB.2.00.1205020206020.19695@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow the OMAP HDQ1W driver to be built for all OMAP2+ SoCs by
adjusting KConfig dependencies.  The previous dependency required
either SOC_OMAP2430 or ARCH_OMAP3 to be set, but the HDQ IP block is
present on OMAP2420 and OMAP44xx SoCs.  The driver was still
selectable on multi-OMAP kernel configurations, however; so the
previous prohibition was rather pointless.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
Hi Evgeniy,

was wondering if you would be willing to ack this so it can be submitted 
along with the other OMAP HDQ patches here that you've already acked?  
Thanks - Paul

 drivers/w1/masters/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 979d6ee..5ceb1cd 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -60,7 +60,7 @@ config W1_MASTER_GPIO
 
 config HDQ_MASTER_OMAP
 	tristate "OMAP HDQ driver"
-	depends on SOC_OMAP2430 || ARCH_OMAP3
+	depends on ARCH_OMAP2PLUS
 	help
 	  Say Y here if you want support for the 1-wire or HDQ Interface
 	  on an OMAP processor.
-- 
1.7.10

