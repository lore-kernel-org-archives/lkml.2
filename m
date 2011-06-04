Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab1FDPqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:46:08 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48505 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527Ab1FDPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:45:48 -0400
Date: Sat, 4 Jun 2011 17:36:33 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH 5/8] drivers/char/rtc: use printk_ratelimited instead of
 printk_ratelimit
Message-ID: <24591311b0f8cad2cc12013274ff8c0c70014beb.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/char/rtc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index dfa8b30..ccd124a 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -80,6 +80,7 @@
 #include <linux/bcd.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
+#include <linux/ratelimit.h>
 
 #include <asm/current.h>
 #include <asm/system.h>
@@ -1195,10 +1196,8 @@ static void rtc_dropped_irq(unsigned long data)
 
 	spin_unlock_irq(&rtc_lock);
 
-	if (printk_ratelimit()) {
-		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
-			freq);
-	}
+	printk_ratelimited(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n",
+			   freq);
 
 	/* Now we have new data */
 	wake_up_interruptible(&rtc_wait);
-- 
1.7.1

