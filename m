Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2LAOYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:24:23 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48830
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 21/28] Drivers: hv: Get rid of unnecessary request for offers
Date: Sat,  1 Dec 2012 06:46:52 -0800
Message-Id: <1354373219-31374-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call to seek offers is not necessary and just adds unnecessary delay.
Get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/vmbus_drv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index c583a04..4c92337 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -592,8 +592,6 @@ int __vmbus_driver_register(struct hv_driver *hv_driver, struct module *owner, c
 
 	ret = driver_register(&hv_driver->driver);
 
-	vmbus_request_offers();
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__vmbus_driver_register);
-- 
1.7.4.1

