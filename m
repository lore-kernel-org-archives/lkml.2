Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1H0SLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:37 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38046
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751439Ab1H0SLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 11/46] Staging: hv: netvsc: Inline the code for free_net_device()
Date: Sat, 27 Aug 2011 11:31:10 -0700
Message-Id: <1314469905-7058-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline the code for free_net_device().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index b6e1fb9..75c6ed7 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -49,14 +49,6 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	return net_device;
 }
 
-static void free_net_device(struct netvsc_device *device)
-{
-	WARN_ON(atomic_read(&device->refcnt) != 0);
-	device->dev->ext = NULL;
-	kfree(device);
-}
-
-
 /* Get the net device object iff exists and its refcount > 1 */
 static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
@@ -438,7 +430,7 @@ int netvsc_device_remove(struct hv_device *device)
 		kfree(netvsc_packet);
 	}
 
-	free_net_device(net_device);
+	kfree(net_device);
 	return 0;
 }
 
@@ -980,7 +972,7 @@ cleanup:
 		release_outbound_net_device(device);
 		release_inbound_net_device(device);
 
-		free_net_device(net_device);
+		kfree(net_device);
 	}
 
 	return ret;
-- 
1.7.4.1

