Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab1IATGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:06:21 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54792
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757537Ab1IATGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:06:17 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 06/10] staging: hv: fix counting of #outstanding-sends in failed sends
Date: Thu,  1 Sep 2011 12:19:44 -0700
Message-Id: <1314904788-32746-7-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
References: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the packet failed to be sent, we shouldn't count it as the
number of outstanding sends.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 82b129b..efbc8a0 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -494,8 +494,9 @@ int netvsc_send(struct hv_device *device,
 	if (ret != 0)
 		netdev_err(ndev, "Unable to send packet %p ret %d\n",
 			   packet, ret);
+	else
+		atomic_inc(&net_device->num_outstanding_sends);
 
-	atomic_inc(&net_device->num_outstanding_sends);
 	return ret;
 }
 
-- 
1.6.3.2

