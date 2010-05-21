Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab0EURE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:04:57 -0400
Received: from kroah.org ([198.145.64.141]:50305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934079Ab0EUQwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/25] serial: bfin_sport_uart: zero sport_uart_port if allocated dynamically
Date: Fri, 21 May 2010 09:51:37 -0700
Message-Id: <1274460714-11277-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Need to initialize the SPORT state rather than using random memory.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 5224db2..6ee73da 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -746,11 +746,11 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 
 	if (bfin_sport_uart_ports[pdev->id] == NULL) {
 		bfin_sport_uart_ports[pdev->id] =
-			kmalloc(sizeof(struct sport_uart_port), GFP_KERNEL);
+			kzalloc(sizeof(struct sport_uart_port), GFP_KERNEL);
 		sport = bfin_sport_uart_ports[pdev->id];
 		if (!sport) {
 			dev_err(&pdev->dev,
-				"Fail to kmalloc sport_uart_port\n");
+				"Fail to malloc sport_uart_port\n");
 			return -ENOMEM;
 		}
 
-- 
1.7.0.3

