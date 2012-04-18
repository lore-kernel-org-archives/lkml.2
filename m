Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2DRWRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:17:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:38252 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2DRWRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:17:05 -0400
X-Greylist: delayed 1308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 18:17:05 EDT
Message-ID: <4F8F383C.1040002@iogearbox.net>
Date: Wed, 18 Apr 2012 23:55:08 +0200
From: Daniel Borkmann <danborkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Ariane Keller <ariane.keller@tik.ee.ethz.ch>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xilinx_hwicap: add support for virtex6 FPGAs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: danborkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the virtex6 FPGA to the xilinx_hwicap driver.

Tested on a Xilinx ML605 board. The patch is against the latest linus-tree.

Signed-off-by: Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |   30 ++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 31ba11c..2c5d15b 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -167,6 +167,7 @@ static const struct config_registers v4_config_registers = {
 	.BOOTSTS = UNIMPLEMENTED,
 	.CTL_1 = UNIMPLEMENTED,
 };
+
 static const struct config_registers v5_config_registers = {
 	.CRC = 0,
 	.FAR = 1,
@@ -192,6 +193,31 @@ static const struct config_registers v5_config_registers = {
 	.CTL_1 = 19,
 };
 
+static const struct config_registers v6_config_registers = {
+	.CRC = 0,
+	.FAR = 1,
+	.FDRI = 2,
+	.FDRO = 3,
+	.CMD = 4,
+	.CTL = 5,
+	.MASK = 6,
+	.STAT = 7,
+	.LOUT = 8,
+	.COR = 9,
+	.MFWR = 10,
+	.FLR = UNIMPLEMENTED,
+	.KEY = UNIMPLEMENTED,
+	.CBC = 11,
+	.IDCODE = 12,
+	.AXSS = 13,
+	.C0R_1 = 14,
+	.CSOB = 15,
+	.WBSTAR = 16,
+	.TIMER = 17,
+	.BOOTSTS = 22,
+	.CTL_1 = 24,
+};
+
 /**
  * hwicap_command_desync - Send a DESYNC command to the ICAP port.
  * @drvdata: a pointer to the drvdata.
@@ -744,6 +770,8 @@ static int __devinit hwicap_of_probe(struct platform_device *op,
 			regs = &v4_config_registers;
 		} else if (!strcmp(family, "virtex5")) {
 			regs = &v5_config_registers;
+		} else if (!strcmp(family, "virtex6")) {
+			regs = &v6_config_registers;
 		}
 	}
 	return hwicap_setup(&op->dev, id ? *id : -1, &res, config,
@@ -785,6 +813,8 @@ static int __devinit hwicap_drv_probe(struct platform_device *pdev)
 			regs = &v4_config_registers;
 		} else if (!strcmp(family, "virtex5")) {
 			regs = &v5_config_registers;
+		} else if (!strcmp(family, "virtex6")) {
+			regs = &v6_config_registers;
 		}
 	}
 
