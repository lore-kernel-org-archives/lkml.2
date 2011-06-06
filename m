Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab1FFWfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:35:13 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58032
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758176Ab1FFWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 23/49] Staging: hv: vmbus: Directly invoke the channel callback
Date: Mon,  6 Jun 2011 15:49:47 -0700
Message-Id: <1307400613-13234-23-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, directly invoke the channel callback.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/connection.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 37bbf77..fc93bdf 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -262,7 +262,7 @@ static void process_chn_event(u32 relid)
 	channel = relid2channel(relid);
 
 	if (channel) {
-		vmbus_onchannel_event(channel);
+		channel->onchannel_callback(channel->channel_callback_context);
 	} else {
 		pr_err("channel not found for relid - %u\n", relid);
 	}
-- 
1.7.4.1

