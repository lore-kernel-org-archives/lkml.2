Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab2EWN5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:57:06 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50434 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759275Ab2EWNyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnUhBRVwYBEogSukuQTwOVHI9wgmw
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630130"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Staging: ipack/bridges/tpci200: check if the remove function is available
Date: Wed, 23 May 2012 15:54:44 +0200
Message-Id: <1337781287-28628-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid a dereference of a NULL pointer, the availability of the function is
checked before its use.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 0c2a50a..ee26d9a 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -764,6 +764,8 @@ out:
 static void tpci200_slot_remove(struct tpci200_slot *slot)
 {
 	if ((slot->dev == NULL) ||
+	    (slot->dev->driver == NULL) ||
+	    (slot->dev->driver->ops == NULL) ||
 	    (slot->dev->driver->ops->remove == NULL))
 		return;
 
-- 
1.7.10

