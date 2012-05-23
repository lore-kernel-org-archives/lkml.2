Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2EWNy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:54:57 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:30306 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932221Ab2EWNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnQBIQUVcGARKIErpLkE8DlRyJHoZSgmw
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630157"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] Staging: ipack/bridges/tpci200: remove name field from slot_irq
Date: Wed, 23 May 2012 15:54:46 +0200
Message-Id: <1337781287-28628-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field is not needed at all, as the IRQ is registered for the carrier not
for the mezzanine.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    1 -
 drivers/staging/ipack/bridges/tpci200.h |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 24070a3..96bfe5b 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -750,7 +750,6 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	slot_irq->vector = vector;
 	slot_irq->handler = handler;
 	slot_irq->arg = arg;
-	slot_irq->name = dev_name(&dev->dev);
 
 	tpci200->slots[dev->slot].irq = slot_irq;
 	res = __tpci200_request_irq(tpci200, dev);
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 0b547ee..55f6776 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -106,14 +106,12 @@
  * @vector	Vector number
  * @handler	Handler called when IRQ arrives
  * @arg		Handler argument
- * @name	IRQ name
  *
  */
 struct slot_irq {
 	int		vector;
 	int		(*handler)(void *);
 	void		*arg;
-	const char	*name;
 };
 
 /**
-- 
1.7.10

