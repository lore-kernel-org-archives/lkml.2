Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2KUNDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:03:36 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:37476
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab2KUNDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:03:35 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 08:03:34 EST
X-Forefront-Antispam-Report: CIP:157.56.241.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0810HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sachin.kamat@linaro.org>
Subject: [V2 PATCH 2/3] staging: ozwpan: Remove redundant null check before kfree in ozproto.c
Date: Wed, 21 Nov 2012 12:46:16 +0000
Message-ID: <1353501977-6585-3-git-send-email-rgujare@ozmodevices.com>
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

Free memory if timer pool count > OZ_MAX_TIMER_POOL_SIZE

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozproto.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index cfb5160..832fde1 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -552,8 +552,8 @@ static void oz_protocol_timer(unsigned long arg)
 			t->link.next = g_timer_pool;
 			g_timer_pool = &t->link;
 			g_timer_pool_count++;
-			t = 0;
-		}
+		} else
+			kfree(t);
 		if (!list_empty(&g_timer_list)) {
 			t2 =  container_of(g_timer_list.next,
 				struct oz_timer, link);
@@ -566,8 +566,6 @@ static void oz_protocol_timer(unsigned long arg)
 		}
 		spin_unlock_bh(&g_polling_lock);
 		oz_pd_put(pd);
-		if (t)
-			kfree(t);
 		t = t2;
 	} while (t);
 	g_timer_state = OZ_TIMER_IDLE;
-- 
1.7.5.4


