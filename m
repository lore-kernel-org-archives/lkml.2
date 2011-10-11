Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1JKRje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:39:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1JKRjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:39:03 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] icside: DMA support fix
Date: Tue, 11 Oct 2011 19:33:48 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111933.48430.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] icside: DMA support fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/icside.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -521,8 +521,8 @@ icside_register_v6(struct icside_state *
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
 		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_port_ops;
+	} else
 		d.dma_ops = NULL;
-	}
 
 	ret = ide_host_register(host, &d, hws);
 	if (ret)
