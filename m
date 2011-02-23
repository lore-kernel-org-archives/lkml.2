Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1BWJZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:25:32 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36432 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWJZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:25:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O3I/f0BInzZ3/OnB6vUGWdCXn7uQPcx/L60v+6zQ7elA6X0YONQGhxyzs8XqItXfZ1
         BbXJ+NHZK4WI/33YARHVTHiIIHA3EmrItGh9PIfu8GJFaCQcNAGnt1hZSNJbkyzuxORW
         kEHbvi37Py7eoiRfhoh3bKCzsssP+iPFAkjj8=
Subject: [PATCH 2/2] net/fec: fix unterminated platform_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        netdev@vger.kernel.org
In-Reply-To: <1298453244.25444.1.camel@mola>
References: <1298453244.25444.1.camel@mola>
Content-Type: text/plain
Date: Wed, 23 Feb 2011 17:28:46 +0800
Message-Id: <1298453326.25444.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/fec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 74798be..f8a81ec 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -74,7 +74,8 @@ static struct platform_device_id fec_devtype[] = {
 	}, {
 		.name = "imx28-fec",
 		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME,
-	}
+	},
+	{ }
 };
 
 static unsigned char macaddr[ETH_ALEN];
-- 
1.7.2



