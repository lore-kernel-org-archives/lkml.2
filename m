Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1GORpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:45:19 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37266
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754106Ab1GORaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:02 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 058/117] Staging: hv: storvsc: Cleanup error code returned in storvsc_probe()
Date: Fri, 15 Jul 2011 10:46:46 -0700
Message-Id: <1310752065-27895-58-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
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
index f85ebb0..9640630 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -696,7 +696,7 @@ static int storvsc_probe(struct hv_device *device)
 	if (ret != 0) {
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
-		return -1;
+		return -ENODEV;
 	}
 
 	host_dev->path = device_info.path_id;
@@ -717,7 +717,7 @@ static int storvsc_probe(struct hv_device *device)
 
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
-		return -1;
+		return -ENODEV;
 	}
 
 	scsi_scan_host(host);
-- 
1.7.4.1

