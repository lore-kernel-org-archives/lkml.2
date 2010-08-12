Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0HLElm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 00:41:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41862 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab0HLElk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 00:41:40 -0400
Date: Thu, 12 Aug 2010 14:41:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory Bean <gbean@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20100812144135.4834268b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/gpio/Kconfig between commit
c34f16b70a52e348a62944fe0d5c7c1eb9ad5b72 ("gpio: sx150x: add Semtech I2C
sx150x gpio expander driver") from Linus' tree and commit
59d11276842199a8ee525f1e88be7eafe8614e4c ("gpio: Add STMPE GPIO driver")
from the mfd tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/Kconfig
index f623953,38d6910..0000000
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@@ -195,17 -195,13 +195,24 @@@ config GPIO_PCF857
  	  This driver provides an in-kernel interface to those GPIOs using
  	  platform-neutral GPIO calls.
  
 +config GPIO_SX150X
 +	bool "Semtech SX150x I2C GPIO expander"
 +	depends on I2C=y
 +	default n
 +	help
 +	  Say yes here to provide support for Semtech SX150-series I2C
 +	  GPIO expanders. Compatible models include:
 +
 +	  8 bits:  sx1508q
 +	  16 bits: sx1509q
 +
+ config GPIO_STMPE
+ 	bool "STMPE GPIOs"
+ 	depends on MFD_STMPE
+ 	help
+ 	  This enables support for the GPIOs found on the STMPE I/O
+ 	  Expanders.
+ 
  config GPIO_TC35892
  	bool "TC35892 GPIOs"
  	depends on MFD_TC35892
