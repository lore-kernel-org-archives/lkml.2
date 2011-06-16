Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab1FPUCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:02:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42375
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758475Ab1FPUB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>, stable <stable@kernel.org>
Subject: [PATCH 02/77] Staging: hv: netvsc: Increase the timeout value in the netvsc driver
Date: Thu, 16 Jun 2011 13:16:35 -0700
Message-Id: <1308255470-3826-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some loaded windows hosts, we have discovered that the host may not
respond to guest requests within the specified time (one second)
as evidenced by the guest timing out. Fix this problem by increasing
the timeout to 5 seconds. 

It may be useful to apply this patch to the 3.0 kernel as well.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Cc: stable <stable@kernel.org>
---
 drivers/staging/hv/netvsc.c       |    4 ++--
 drivers/staging/hv/rndis_filter.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 7b5bf0d..1bd920f 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -270,7 +270,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		goto cleanup;
 	}
 
-	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, 5*HZ);
 	BUG_ON(t == 0);
 
 
@@ -357,7 +357,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, 5*HZ);
 
 	if (t == 0) {
 		ret = -ETIMEDOUT;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 5674a13..dbb5201 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -452,7 +452,7 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	if (ret != 0)
 		goto Cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
@@ -528,7 +528,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	if (ret != 0)
 		goto Cleanup;
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 
 	if (t == 0) {
 		ret = -1;
@@ -585,7 +585,7 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	}
 
 
-	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 
 	if (t == 0) {
 		ret = -ETIMEDOUT;
-- 
1.7.4.1

