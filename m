Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0GINvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:51:04 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50483 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547Ab0GINvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:51:00 -0400
Date: Fri, 9 Jul 2010 15:50:58 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
       Sonic Zhang <sonic.zhang@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 11/11] Removing dead SERIAL_BFIN_SPORT_CONSOLE
Message-ID: <86b706944a84c030fbd88d005e8d6365cb7921da.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SERIAL_BFIN_SPORT_CONSOLE doesn't exist in Kconfig, therefore removing
all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/bfin_sport_uart.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 05cd3a6..01bdd89 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -728,16 +728,11 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 		}
 	}
 
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
-	if (!is_early_platform_device(pdev)) {
-#endif
-		sport = bfin_sport_uart_ports[pdev->id];
-		sport->port.dev = &pdev->dev;
-		dev_set_drvdata(&pdev->dev, sport);
-		ret = uart_add_one_port(&sport_uart_reg, &sport->port);
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
-	}
-#endif
+	sport = bfin_sport_uart_ports[pdev->id];
+	sport->port.dev = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, sport);
+	ret = uart_add_one_port(&sport_uart_reg, &sport->port);
+
 	if (!ret)
 		return 0;
 
-- 
1.7.0.4

