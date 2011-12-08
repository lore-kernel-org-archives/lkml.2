Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1LHNFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:05:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53056 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1LHNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:05:32 -0500
Message-ID: <1323349526.2823.2.camel@phoenix>
Subject: [PATCH 2/2] jz4740-battery: fix signedness bug
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Thu, 08 Dec 2011 21:05:26 +0800
In-Reply-To: <1323349452.2823.1.camel@phoenix>
References: <1323349452.2823.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_interruptible_timeout() may return negative value.
In this case, checking if (t > 0)  will return true if t is unsigned.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/jz4740-battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 763f894..5bb1ddd 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -67,7 +67,7 @@ static irqreturn_t jz_battery_irq_handler(int irq, void *devid)
 
 static long jz_battery_read_voltage(struct jz_battery *battery)
 {
-	unsigned long t;
+	long t;
 	unsigned long val;
 	long voltage;
 
-- 
1.7.5.4



