Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2K3TA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:00:57 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60797
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759441Ab2K3TAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:00:35 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net-next,1/1] hyperv: Add an error message to rndis_filter_set_device_mac()
Date: Fri, 30 Nov 2012 11:23:41 -0800
Message-Id: <1354303421-26149-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message indicates an error returned from the host when changing MAC address.

Reported-by: Michal Kubecek <mkubecek@suse.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 7fdeb52..2b657d4 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -605,8 +605,11 @@ int rndis_filter_set_device_mac(struct hv_device *hdev, char *mac)
 		return -EBUSY;
 	} else {
 		set_complete = &request->response_msg.msg.set_complete;
-		if (set_complete->status != RNDIS_STATUS_SUCCESS)
+		if (set_complete->status != RNDIS_STATUS_SUCCESS) {
+			netdev_err(ndev, "Fail to set MAC on host side:0x%x\n",
+				   set_complete->status);
 			ret = -EINVAL;
+		}
 	}
 
 cleanup:
-- 
1.7.4.1

