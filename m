Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1LLR2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:28:36 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42159
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753610Ab1LLR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:28:33 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/4] Drivers: hv: Fix a memory leak
Date: Mon, 12 Dec 2011 09:29:16 -0800
Message-Id: <1323710959-29655-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323710931-29616-1-git-send-email-kys@microsoft.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a memory leak in a failure path in vmbus_process_offer().
Fix it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 12b85ff..b91af50 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -287,6 +287,7 @@ static void vmbus_process_offer(struct work_struct *work)
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&newchannel->listentry);
 		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
+		kfree(newchannel->device_obj);
 
 		free_channel(newchannel);
 	} else {
-- 
1.7.4.1

