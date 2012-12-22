Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2LVCED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:04:03 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:35287 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2LVB57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:57:59 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 03/25] sja1000: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:53 -0800
Message-Id: <1356141435-17340-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from sja1000.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/net/can/sja1000/peak_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index d84888f..600ac72 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -339,8 +339,7 @@ static void peak_pciec_set_leds(struct peak_pciec_card *card, u8 led_mask, u8 s)
  */
 static void peak_pciec_start_led_work(struct peak_pciec_card *card)
 {
-	if (!delayed_work_pending(&card->led_work))
-		schedule_delayed_work(&card->led_work, HZ);
+	schedule_delayed_work(&card->led_work, HZ);
 }
 
 /*
-- 
1.8.0.2

