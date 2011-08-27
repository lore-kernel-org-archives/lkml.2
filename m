Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1H0SMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:54 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37994
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751047Ab1H0SLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 01/46] Staging: hv: storvsc: Inline free_stor_device()
Date: Sat, 27 Aug 2011 11:31:00 -0700
Message-Id: <1314469905-7058-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469874-7017-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline the code for  free_stor_device() and get rid of the function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 827b6a3..8c62829 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -51,10 +51,6 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 	return stor_device;
 }
 
-static inline void free_stor_device(struct storvsc_device *device)
-{
-	kfree(device);
-}
 
 /* Get the stordevice object iff exists and its refcount > 0 */
 static inline struct storvsc_device *must_get_stor_device(
@@ -394,7 +390,7 @@ int storvsc_dev_add(struct hv_device *device,
 	/* Send it back up */
 	ret = storvsc_connect_to_vsp(device, device_info->ring_buffer_size);
 	if (ret) {
-		free_stor_device(stor_device);
+		kfree(stor_device);
 		return ret;
 	}
 	device_info->path_id = stor_device->path_id;
@@ -422,7 +418,7 @@ int storvsc_dev_remove(struct hv_device *device)
 	/* Close the channel */
 	vmbus_close(device->channel);
 
-	free_stor_device(stor_device);
+	kfree(stor_device);
 	return 0;
 }
 
-- 
1.7.4.1

