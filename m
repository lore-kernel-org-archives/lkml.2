Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2JHNyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:54:03 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60905 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2JHNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:53:58 -0400
Date: Mon, 8 Oct 2012 09:54:42 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v5 7/7] ARM: davinci: da850 evm: register uio_pruss device
Message-ID: <20121008135442.GS11149@beef>
References: <1349456686-22736-1-git-send-email-mporter@ti.com>
 <1349456686-22736-8-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349456686-22736-8-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registers the uio_pruss platform device on the DA850 EVM.

Tested on AM180x-EVM using the PRU_memAccessPRUDataRam and
PRU_memAccessL3andDDR examples from the PRU userspace tools
available from http://www.ti.com/tool/sprc940

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 7359375..9e7f954 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -31,6 +31,7 @@
 #include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
 #include <linux/platform_data/spi-davinci.h>
+#include <linux/platform_data/uio_pruss.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/tps6507x.h>
 #include <linux/spi/spi.h>
@@ -1339,6 +1340,11 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
 				ret);
 
+	ret = da8xx_register_uio_pruss();
+	if (ret)
+		pr_warning("da850_evm_init: pruss initialization failed: %d\n",
+				ret);
+
 	/* Handle board specific muxing for LCD here */
 	ret = davinci_cfg_reg_list(da850_evm_lcdc_pins);
 	if (ret)
-- 
1.7.9.5
