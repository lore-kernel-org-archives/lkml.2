Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2JAWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:20:08 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48190
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab2JAWUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:20:04 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 18:20:01 EDT
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net,2/3] hyperv: Fix the missing return value in rndis_filter_set_packet_filter()
Date: Mon,  1 Oct 2012 15:30:56 -0700
Message-Id: <1349130657-7987-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
References: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
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
index 3cb7486..2909dd8 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -641,6 +641,7 @@ int rndis_filter_set_packet_filter(struct rndis_device *dev, u32 new_filter)
 	if (t == 0) {
 		netdev_err(ndev,
 			"timeout before we got a set response...\n");
+		ret = -ETIMEDOUT;
 		/*
 		 * We can't deallocate the request since we may still receive a
 		 * send completion for it.
-- 
1.7.4.1

