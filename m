Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1FMSRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:17:43 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:48572 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1FMSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:17:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: netdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] net/hplance: hplance_init() should be __devinit
Date: Mon, 13 Jun 2011 20:17:36 +0200
Message-Id: <1307989056-21814-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.devinit.text+0x253e): Section mismatch in reference from the function hplance_init_one() to the function .init.text:hplance_init()

The forward declaration had the correct attribute, but the actual function
definition hadn't.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/hplance.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hplance.c b/drivers/net/hplance.c
index b6060f7..a900d5b 100644
--- a/drivers/net/hplance.c
+++ b/drivers/net/hplance.c
@@ -135,7 +135,7 @@ static void __devexit hplance_remove_one(struct dio_dev *d)
 }
 
 /* Initialise a single lance board at the given DIO device */
-static void __init hplance_init(struct net_device *dev, struct dio_dev *d)
+static void __devinit hplance_init(struct net_device *dev, struct dio_dev *d)
 {
         unsigned long va = (d->resource.start + DIO_VIRADDRBASE);
         struct hplance_private *lp;
-- 
1.7.0.4

