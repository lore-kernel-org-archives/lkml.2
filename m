Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1C1M41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:56:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34356 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1C1M4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AgxM7ffJG547d5krMm5d4gW3xxcoZ7SJl4pcsdNnwL7iztUsmpOQBS3zQWVXTqrPiU
         uN9pEqOyJF7LWzKi6HpHUEP5UZU0+jb/dszhGNlhFcq+nFNtribBEWfgn2NiiUKfubK2
         5iIEmPyjnYR7SLRt8iL3HMvgCiTKHQfxtDyXs=
From: Igor Plyatov <plyatov@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Igor Plyatov <plyatov@gmail.com>
Subject: [PATCH v4 1/2] ata: pata_at91.c bugfix for initial_timing initialisation
Date: Mon, 28 Mar 2011 16:56:14 +0400
Message-Id: <1301316975-27761-1-git-send-email-plyatov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "struct ata_timing" must contain 10 members, but ".dmack_hold" member was
forgotten for "initial_timing" initialisation. This patch fixes such a problem.

Signed-off-by: Igor Plyatov <plyatov@gmail.com>
---
 drivers/ata/pata_at91.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 0da0dcc..0267d54 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -49,8 +49,18 @@ struct at91_ide_info {
 	void __iomem *alt_addr;
 };
 
-static const struct ata_timing initial_timing =
-	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
+static const struct ata_timing initial_timing = {
+	.mode		= XFER_PIO_0,
+	.setup		= 70,
+	.act8b		= 290,
+	.rec8b		= 240,
+	.cyc8b		= 600,
+	.active		= 165,
+	.recover	= 150,
+	.dmack_hold	= 0,
+	.cycle		= 600,
+	.udma		= 0
+};
 
 static unsigned long calc_mck_cycles(unsigned long ns, unsigned long mck_hz)
 {
-- 
1.7.1

