Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab1JFRWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:22:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58366
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758413Ab1JFRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, dan.carpenter@oracle.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: netvsc: Fix a dereferencing issue
Date: Thu,  6 Oct 2011 10:10:56 -0700
Message-Id: <1317921056-17141-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net_dev is being de-referenced without proper checking; fix it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/hv/rndis_filter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index ef43f2e..bafccb3 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -368,11 +368,11 @@ int rndis_filter_receive(struct hv_device *dev,
 	struct rndis_message *rndis_hdr;
 	struct net_device *ndev;
 
-	ndev = net_dev->ndev;
-
 	if (!net_dev)
 		return -EINVAL;
 
+	ndev = net_dev->ndev;
+
 	/* Make sure the rndis device state is initialized */
 	if (!net_dev->extension) {
 		netdev_err(ndev, "got rndis message but no rndis device - "
-- 
1.7.4.1

