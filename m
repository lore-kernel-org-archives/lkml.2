Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2I0Khx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:37:53 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33408 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab2I0KhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:37:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnMCAEQrZFBbdWObgWdsb2JhbABFhUS4SyMBARYmJ4IhAQUnUhBRVwYTiAm3b4shhhQDlWmTFIFY
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447844"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 17/17] Staging: ipack: fix wrong return value.
Date: Thu, 27 Sep 2012 12:37:41 +0200
Message-Id: <1348742261-28145-17-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case it is not possible to remap the memory, it returns 0 and
the driver thinks that everything went fine.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 5bd462b..75bfecf 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -355,7 +355,7 @@ static int ipack_device_read_id(struct ipack_device *dev)
 			dev->region[IPACK_ID_SPACE].size);
 	if (!idmem) {
 		dev_err(&dev->dev, "error mapping memory\n");
-		return ret;
+		return -ENOMEM;
 	}
 
 	/* Determine ID PROM Data Format.  If we find the ids "IPAC" or "IPAH"
-- 
1.7.10.4

