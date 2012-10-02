Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2JBPLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:11:21 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:46415
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab2JBPLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:11:19 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net-next,2/6] hyperv: Fix the missing return value in rndis_filter_set_packet_filter()
Date: Tue,  2 Oct 2012 08:30:20 -0700
Message-Id: <1349191824-14001-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1349191824-14001-1-git-send-email-haiyangz@microsoft.com>
References: <1349191824-14001-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return ETIMEDOUT when the reply message is not received in time.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 1337b64..617eb2e 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -647,6 +647,7 @@ int rndis_filter_set_packet_filter(struct rndis_device *dev, u32 new_filter)
 	if (t == 0) {
 		netdev_err(ndev,
 			"timeout before we got a set response...\n");
+		ret = -ETIMEDOUT;
 		/*
 		 * We can't deallocate the request since we may still receive a
 		 * send completion for it.
-- 
1.7.4.1

