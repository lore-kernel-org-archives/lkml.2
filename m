Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2JBPLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:11:18 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:46415
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab2JBPLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:11:17 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net-next,1/6] hyperv: Fix the max_xfer_size in RNDIS initialization
Date: Tue,  2 Oct 2012 08:30:19 -0700
Message-Id: <1349191824-14001-1-git-send-email-haiyangz@microsoft.com>
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
index 06f8601..1337b64 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -684,8 +684,7 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	init = &request->request_msg.msg.init_req;
 	init->major_ver = RNDIS_MAJOR_VERSION;
 	init->minor_ver = RNDIS_MINOR_VERSION;
-	/* FIXME: Use 1536 - rounded ethernet frame size */
-	init->max_xfer_size = 2048;
+	init->max_xfer_size = 0x4000;
 
 	dev->state = RNDIS_DEV_INITIALIZING;
 
-- 
1.7.4.1

