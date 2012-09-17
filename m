Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2IQSmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:42:15 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:53921 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151Ab2IQSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:42:14 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmxRAGtuV1BV5h1yPGdsb2JhbABEhR6FI64ggz8ZAQEBATc0giABAQU6HCMQCAMYLhQlChqIF7pKFIsNhghgA5VhhXCNGg
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="413646195"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 17 Sep 2012 20:49:54 +0200
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120917184954.GA349@polaris.bitmath.org>
References: <20120915225841.GA3816@roeck-us.net>
 <alpine.DEB.2.02.1209151918210.2271@ubuntu>
 <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
 <20120916223003.GA2160@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161957490.2808@ubuntu>
 <20120917162705.GA2854@polaris.bitmath.org>
 <alpine.DEB.2.02.1209171356340.3412@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209171356340.3412@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 02:06:05PM -0400, Parag Warudkar wrote:
> 
> 
> On Mon, 17 Sep 2012, Henrik Rydberg wrote:
> 
> > The current patch does exactly the same sleeps, the only difference is
> > that the test is also done before the first sleep. Thus, the increased
> > delay, if any, comes from the sleep range.
> My understanding is that the original patch resulted in trying a 
> max udelay(16). The new one does usleep_range(16, 32). That's a minimum 16 
> max 32 - so the fact that it stops read failures means the added delay is 
> present and does help.

So the question is, does this patch work equally well for you?

Henrik

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2827088..8bf9011 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -56,7 +56,7 @@
 /* wait up to 32 ms for a status change. */
 #define APPLESMC_MIN_WAIT      0x0010
 #define APPLESMC_RETRY_WAIT    0x0100
-#define APPLESMC_MAX_WAIT      0x8000
+#define APPLESMC_MAX_WAIT      0x10000
 
 #define APPLESMC_READ_CMD      0x10
 #define APPLESMC_WRITE_CMD     0x11
