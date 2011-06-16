Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab1FPUKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:10:30 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52232
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758722Ab1FPUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 51/77] Staging: hv: netvsc: Get rid of an unnecessary print statement in netvsc_probe()
Date: Thu, 16 Jun 2011 13:17:24 -0700
Message-Id: <1308255470-3826-51-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of an unnecessary print statement in netvsc_probe(). Furthermore,
this fixes a bug since netdev_err is being invoked after the device has
been freed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index cd66e8d..58115b3 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -357,8 +357,6 @@ static int netvsc_probe(struct hv_device *dev)
 	if (ret != 0) {
 		free_netdev(net);
 		dev_set_drvdata(&dev->device, NULL);
-
-		netdev_err(net, "unable to add netvsc device (ret %d)\n", ret);
 		return ret;
 	}
 
-- 
1.7.4.1

