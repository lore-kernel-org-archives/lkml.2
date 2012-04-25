Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2DYW4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:56:21 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:43190
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352Ab2DYW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:56:20 -0400
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, Rupesh Gujare <rgujare@ozmodevices.com>,
        Chris Kelly <ckelly@ozmodevices.com>
Subject: [PATCH] Fix bug where kfree is called twice.
Date: Wed, 25 Apr 2012 23:54:58 +0100
Message-ID: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [2.126.200.180]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
Signed-off-by: Chris Kelly <ckelly@ozmodevices.com>
---
 drivers/staging/ozwpan/ozpd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 2b45d3d..04cd57f 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -383,8 +383,6 @@ static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 		pd->tx_pool = &f->link;
 		pd->tx_pool_count++;
 		f = 0;
-	} else {
-		kfree(f);
 	}
 	spin_unlock_bh(&pd->tx_frame_lock);
 	if (f)
-- 
1.7.5.4


