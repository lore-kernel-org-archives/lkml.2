Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2EWNyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:54:54 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:30306 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756488Ab2EWNyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnUhBRVwYBEogSukuLGIU3A5Ucj3CCbIFU
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630127"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Staging: ipack: return proper value in match() function
Date: Wed, 23 May 2012 15:54:41 +0200
Message-Id: <1337781287-28628-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should return the same value given by the match function of the ipack_driver
that has been called.

Returning 0 here, means that the match has failed and it could be succeed.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 2b4fa51..e6dc21a 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -48,7 +48,7 @@ static int ipack_bus_match(struct device *device, struct device_driver *driver)
 	if (ret)
 		dev->driver = drv;
 
-	return 0;
+	return ret;
 }
 
 static int ipack_bus_probe(struct device *device)
-- 
1.7.10

