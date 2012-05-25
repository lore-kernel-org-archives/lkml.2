Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2EYIHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:07:37 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:43364 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755388Ab2EYIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:05:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIo8v09bdWOb/2dsb2JhbABEtRCBB4IWAQUnUhBRVwYTiBG7SJBHA5UYiR6GUoJi
X-IronPort-AV: E=Sophos;i="4.75,655,1330902000"; 
   d="scan'208";a="995215615"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] Staging: ipack: delete the call to remove() in ipack_driver_register
Date: Fri, 25 May 2012 10:03:02 +0200
Message-Id: <1337932985-10668-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
References: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a bus driver calls ipack_driver_register(), it should manages the returning
NULL value to undo all the operations it did before this call, and print the
corresponding trace.

It is not a task for the ipack driver to call the remove() function here.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index e97be99..a1448e6 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -141,8 +141,6 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
-		pr_err("error registering the device.\n");
-		dev->driver->ops->remove(dev);
 		kfree(dev);
 		return NULL;
 	}
-- 
1.7.10

