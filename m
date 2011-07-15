Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1GORjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:39:00 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33346
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754197Ab1GORaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 089/117] Staging: hv: netvsc: Cleanup alloc_net_device()
Date: Fri, 15 Jul 2011 10:47:17 -0700
Message-Id: <1310752065-27895-89-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup alloc_net_device(); we can directly set the refcnt.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 75c6ed7..7722102 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -41,7 +41,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffic */
-	atomic_cmpxchg(&net_device->refcnt, 0, 2);
+	atomic_set(&net_device->refcnt, 2);
 
 	net_device->dev = device;
 	device->ext = net_device;
-- 
1.7.4.1

