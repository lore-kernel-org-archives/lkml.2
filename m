Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2KUMsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:48:21 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:42082
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875Ab2KUMsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:48:19 -0500
X-Forefront-Antispam-Report: CIP:157.56.241.101;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0810HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sachin.kamat@linaro.org>
Subject: [V2 PATCH 1/3] staging: ozwpan: Remove redundant null check before kfree in ozpd.c
Date: Wed, 21 Nov 2012 12:46:15 +0000
Message-ID: <1353501977-6585-2-git-send-email-rgujare@ozmodevices.com>
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
 drivers/staging/ozwpan/ozpd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 0b3648c..1dd8980 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -399,11 +399,11 @@ static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 		f->link.next = pd->tx_pool;
 		pd->tx_pool = &f->link;
 		pd->tx_pool_count++;
-		f = 0;
+		spin_unlock_bh(&pd->tx_frame_lock);
+		return;
 	}
 	spin_unlock_bh(&pd->tx_frame_lock);
-	if (f)
-		kfree(f);
+	kfree(f);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
-- 
1.7.5.4


