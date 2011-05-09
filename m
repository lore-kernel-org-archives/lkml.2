Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab1EJIdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:33:03 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53198
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756114Ab1EJIay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 129/206] Staging: hv: Move the sector size check into blkvsc_drv_init
Date: Mon,  9 May 2011 14:56:51 -0700
Message-Id: <1304978288-22999-129-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index f8a3bce..ed1439f 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -822,6 +822,8 @@ static int blkvsc_drv_init(void)
 	struct hv_driver *drv = &blkvsc_drv.base;
 	int ret;
 
+	BUILD_BUG_ON(sizeof(sector_t) != 8);
+
 	storvsc_drv->ring_buffer_size = blkvsc_ringbuffer_size;
 
 	memcpy(&drv->dev_type, &dev_type, sizeof(struct hv_guid));
@@ -1046,8 +1048,6 @@ static int __init blkvsc_init(void)
 {
 	int ret;
 
-	BUILD_BUG_ON(sizeof(sector_t) != 8);
-
 	ret = blkvsc_drv_init();
 
 	return ret;
-- 
1.7.4.1

