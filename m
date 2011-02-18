Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab1BRW5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:57:36 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50704
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758057Ab1BRW5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:57:34 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 2/2] staging: hv: Fix the WARN_ON condition in free_net_device()
Date: Fri, 18 Feb 2011 15:05:53 -0800
Message-Id: <1298070353-23534-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298070353-23534-1-git-send-email-haiyangz@microsoft.com>
References: <1298070353-23534-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous commit, 7a09876d, ASSERT was changed to WARN_ON, but
the condition wasn't updated. This patch fixed this error.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index f21a59d..20b1597 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -95,7 +95,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 
 static void free_net_device(struct netvsc_device *device)
 {
-	WARN_ON(atomic_read(&device->refcnt) == 0);
+	WARN_ON(atomic_read(&device->refcnt) != 0);
 	device->dev->ext = NULL;
 	kfree(device);
 }
-- 
1.6.3.2

