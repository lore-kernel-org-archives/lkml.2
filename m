Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2GDOKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:10:43 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:53193 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910Ab2GDOKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:10:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKxN9E9bdWOb/2dsb2JhbABEhV6xUYEHgkIECwFGNQImAl8TiA+oApM2gSCKIoUcgRIDlTeQA4JhgVQ
X-IronPort-AV: E=Sophos;i="4.77,524,1336341600"; 
   d="scan'208";a="926409099"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ipack/devices/ipoctal: save IRQ vector in MEM space
Date: Wed,  4 Jul 2012 16:11:10 +0200
Message-Id: <1341411070-19809-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ vector should be saved in MEM space base address according to the
datasheet.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index ec7b2f9..a5af423 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -435,7 +435,8 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	 */
 	ipoctal->dev->bus->ops->request_irq(ipoctal->dev, vector,
 				       ipoctal_irq_handler, ipoctal);
-	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_ID_SPACE, 0, vector);
+	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_MEM_SPACE, 0,
+				       vector);
 
 	/* Register the TTY device */
 
-- 
1.7.10

