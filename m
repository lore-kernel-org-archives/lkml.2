Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1HYQdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:33:36 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48461
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753542Ab1HYQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 43/59] Staging: hv: storvsc: Cleanup error code returned in storvsc_probe()
Date: Thu, 25 Aug 2011 09:49:09 -0700
Message-Id: <1314290965-2698-43-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error codes.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c245698..956f010 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -693,7 +693,7 @@ static int storvsc_probe(struct hv_device *device)
 	if (ret != 0) {
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
-		return -1;
+		return -ENODEV;
 	}
 
 	host_dev->path = device_info.path_id;
@@ -714,7 +714,7 @@ static int storvsc_probe(struct hv_device *device)
 
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
-		return -1;
+		return -ENODEV;
 	}
 
 	scsi_scan_host(host);
-- 
1.7.4.1

