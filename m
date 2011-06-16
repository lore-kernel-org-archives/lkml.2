Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab1FPUJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:09:13 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:32966
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932321Ab1FPUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 63/77] Staging: hv: netvsc: Cleanup error return codes in netvsc_destroy_recv_buf()
Date: Thu, 16 Jun 2011 13:17:36 -0700
Message-Id: <1308255470-3826-63-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup error return codes in netvsc_destroy_recv_buf().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 34b62ed..14c2203 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -160,7 +160,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 		if (ret != 0) {
 			dev_err(&net_device->dev->device, "unable to send "
 				"revoke receive buffer to netvsp");
-			return -1;
+			return ret;
 		}
 	}
 
@@ -175,7 +175,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 		if (ret != 0) {
 			dev_err(&net_device->dev->device,
 				   "unable to teardown receive buffer's gpadl");
-			return -1;
+			return -ret;
 		}
 		net_device->recv_buf_gpadl_handle = 0;
 	}
-- 
1.7.4.1

