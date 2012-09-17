Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2IQUHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:07:50 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:33284 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2IQUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:07:49 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5PACiCV1BV5h1yPGdsb2JhbABEhR6FI7FfGQEBAQE3NIIgAQEEATocEwEPBQsIAw4DAwECLxQNGAoMDhOHcQMGCrBuDYlTFIoqY4YIYAOUDYFUhXCFKIdy
X-IronPort-AV: E=Sophos;i="4.80,438,1344204000"; 
   d="scan'208";a="190107426"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 17 Sep 2012 22:14:36 +0200
To: Guenter Roeck <linux@roeck-us.net>
Cc: Parag Warudkar <parag.lkml@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120917201436.GA320@polaris.bitmath.org>
References: <20120915225841.GA3816@roeck-us.net>
 <alpine.DEB.2.02.1209151918210.2271@ubuntu>
 <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
 <20120916223003.GA2160@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161957490.2808@ubuntu>
 <20120917162705.GA2854@polaris.bitmath.org>
 <20120917163722.GA1925@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917163722.GA1925@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any better/other ideas ? Is the problem that we have to increase the wait time,
> or is something else going on ?

No, it makes sense now that I got the right number of zeroes. ;-)

So, to be explicit, this is the patch I would like to go in. It is
completely safe, back-portable, and a no-brainer. Parag, are you ok
with being the author on this one?

Thanks,
Henrik

>From 868fc42edcb3a338ce0a0334e2dc50b01a7f6844 Mon Sep 17 00:00:00 2001
From: Parag Warudkar <parag.lkml@gmail.com>
Date: Mon, 17 Sep 2012 17:49:55 +0200
Subject: [PATCH] applesmc: Bump max wait

A heavy-load test on a MacBookPro6,1 is still showing a substantial
amount of read errors.  Increasing the maximum wait time to 128 ms
resolves the issue.

maybe-Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2827088..8f3f6f2 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -53,10 +53,10 @@
 
 #define APPLESMC_MAX_DATA_LENGTH 32
 
-/* wait up to 32 ms for a status change. */
+/* wait up to 128 ms for a status change. */
 #define APPLESMC_MIN_WAIT	0x0010
 #define APPLESMC_RETRY_WAIT	0x0100
-#define APPLESMC_MAX_WAIT	0x8000
+#define APPLESMC_MAX_WAIT	0x20000
 
 #define APPLESMC_READ_CMD	0x10
 #define APPLESMC_WRITE_CMD	0x11
-- 
1.7.12

