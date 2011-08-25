Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1HYQd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:33:29 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42895
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753553Ab1HYQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 51/59] Staging: hv: netvsc: Cleanup error codes in rndis_filter_receive()
Date: Thu, 25 Aug 2011 09:49:17 -0700
Message-Id: <1314290965-2698-51-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/rndis_filter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index dbb5201..8e1ef00 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -358,14 +358,14 @@ int rndis_filter_receive(struct hv_device *dev,
 	if (!net_dev->extension) {
 		dev_err(&dev->device, "got rndis message but no rndis device - "
 			  "dropping this message!\n");
-		return -1;
+		return -ENODEV;
 	}
 
 	rndis_dev = (struct rndis_device *)net_dev->extension;
 	if (rndis_dev->state == RNDIS_DEV_UNINITIALIZED) {
 		dev_err(&dev->device, "got rndis message but rndis device "
 			   "uninitialized...dropping this message!\n");
-		return -1;
+		return -ENODEV;
 	}
 
 	rndis_hdr = (struct rndis_message *)kmap_atomic(
-- 
1.7.4.1

