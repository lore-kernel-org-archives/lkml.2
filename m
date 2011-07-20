Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1GTNLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:11:54 -0400
Received: from mail.sysgo.com ([195.145.229.155]:46091 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1GTNLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:11:53 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jul 2011 09:11:52 EDT
Message-ID: <4E26D22B.1040702@sysgo.com>
Date: Wed, 20 Jul 2011 15:03:39 +0200
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] shwdt: fix usage of mod_timer
Content-Type: multipart/mixed;
 boundary="------------020705060108020003000904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020705060108020003000904
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes the usage of mod_timer and makes the driver usable. 
mod_timer must be called with an absolute timeout in jiffies, the old 
implementation used a relative timeout thus the hardware watchdog was 
never triggered.

Signed-off-by: David Engraf <david.engraf@sysgo.com>



--------------020705060108020003000904
Content-Type: text/x-diff;
 name="shwdt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="shwdt.patch"

diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index db84f23..a267dc0 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -64,7 +64,7 @@
  * misses its deadline, the kernel timer will allow the WDT to overflow.
  */
 static int clock_division_ratio = WTCSR_CKS_4096;
-#define next_ping_period(cks)	msecs_to_jiffies(cks - 4)
+#define next_ping_period(cks)	(jiffies + msecs_to_jiffies(cks - 4))
 
 static const struct watchdog_info sh_wdt_info;
 static struct platform_device *sh_wdt_dev;

--------------020705060108020003000904--
