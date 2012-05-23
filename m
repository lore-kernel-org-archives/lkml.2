Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab2EWNy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:54:58 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50434 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932104Ab2EWNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnUhBRVwYBEogSukuQTwOVHI9wgmw
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630136"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Staging ipack/bridges/tpci200: removed check of tpci200->slots[dev->slot].dev
Date: Wed, 23 May 2012 15:54:47 +0200
Message-Id: <1337781287-28628-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ipack_device_register() is called, the variable
tpci200->slots[dev->slot].dev has not assigned a value and it gives an error
when the mezzanine driver is reading a register from the board for the match()
function, as all the I/O functions call check_slot().

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 96bfe5b..6751625 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -59,13 +59,6 @@ static struct tpci200_board *check_slot(struct ipack_device *dev)
 		return NULL;
 	}
 
-	BUG_ON(tpci200->slots == NULL);
-	if (tpci200->slots[dev->slot].dev == NULL) {
-		pr_info("Slot [%d:%d] is not registered !\n", dev->bus_nr,
-			dev->slot);
-		return NULL;
-	}
-
 	return tpci200;
 }
 
-- 
1.7.10

