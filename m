Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2KUMs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:48:28 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:46099
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab2KUMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:48:26 -0500
X-Forefront-Antispam-Report: CIP:157.56.241.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0810HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sachin.kamat@linaro.org>
Subject: [V2 PATCH 3/3] staging: ozwpan: Remove redundant null check before kfree in ozhcd.c
Date: Wed, 21 Nov 2012 12:46:17 +0000
Message-ID: <1353501977-6585-4-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20121120163513.GC4990@kroah.com>
References: <20121120163513.GC4990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call kfree only if required else return from function.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozhcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 33c0009..585aa79 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -274,12 +274,12 @@ static void oz_free_urb_link(struct oz_urb_link *urbl)
 		if (g_link_pool_size < OZ_MAX_LINK_POOL_SIZE) {
 			urbl->link.next = g_link_pool;
 			g_link_pool = &urbl->link;
-			urbl = 0;
 			g_link_pool_size++;
+			spin_unlock_irqrestore(&g_link_lock, irq_state);
+			return;
 		}
 		spin_unlock_irqrestore(&g_link_lock, irq_state);
-		if (urbl)
-			kfree(urbl);
+		kfree(urbl);
 	}
 }
 /*------------------------------------------------------------------------------
-- 
1.7.5.4


