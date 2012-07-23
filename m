Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2GWReA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:34:00 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37893 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754141Ab2GWRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:33:58 -0400
Message-ID: <500D8ACA.4020501@xenotime.net>
Date: Mon, 23 Jul 2012 10:32:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] mfd: fix arizona-irq.c build by selecting REGMAP_IRQ
References: <20120723164036.52bc93caafcd165fc16f0284@canb.auug.org.au>
In-Reply-To: <20120723164036.52bc93caafcd165fc16f0284@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

arizona-irq.c uses functions that are only available when
CONFIG_REGMAP_IRQ is enabled, so select that symbol for
arizona builds.

Fixes these build errors:

arizona-irq.c:(.text+0xb2d47): undefined reference to `regmap_irq_get_virq'
(.text+0xb2fe3): undefined reference to `regmap_add_irq_chip'
(.text+0xb3173): undefined reference to `regmap_del_irq_chip'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120723.orig/drivers/mfd/Kconfig
+++ linux-next-20120723/drivers/mfd/Kconfig
@@ -523,6 +523,7 @@ config MFD_SEC_CORE
 
 config MFD_ARIZONA
 	select REGMAP
+	select REGMAP_IRQ
 	bool
 
 config MFD_ARIZONA_I2C
