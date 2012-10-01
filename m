Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2JAWUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:20:03 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48190
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab2JAWUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:20:01 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 18:20:01 EDT
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net,1/3] hyperv: Fix the max_xfer_size in RNDIS initialization
Date: Mon,  1 Oct 2012 15:30:55 -0700
Message-Id: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to RNDIS specs, Windows sets this size to
0x4000. I use the same value here.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 1e88a10..3cb7486 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -678,8 +678,7 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	init = &request->request_msg.msg.init_req;
 	init->major_ver = RNDIS_MAJOR_VERSION;
 	init->minor_ver = RNDIS_MINOR_VERSION;
-	/* FIXME: Use 1536 - rounded ethernet frame size */
-	init->max_xfer_size = 2048;
+	init->max_xfer_size = 0x4000;
 
 	dev->state = RNDIS_DEV_INITIALIZING;
 
-- 
1.7.4.1

