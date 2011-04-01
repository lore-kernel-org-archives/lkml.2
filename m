Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1DACAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 22:00:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59890 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab1DACAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 22:00:53 -0400
Date: Fri, 1 Apr 2011 13:00:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20110401130044.c5aed052.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/i2c/busses/i2c-designware-core.c: In function 'i2c_dw_wait_bus_not_busy':
drivers/i2c/busses/i2c-designware-core.c:321: error: implicit declaration of function 'mdelay'

Caused by commit 800c56383dcb ("i2c-designware: split of i2c-designware.c
into core and bus specific parts") from the bjdooks-i2c tree and exposed
by commit ca444564a947 ("x86: Stop including <linux/delay.h> in two asm
header files").

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Apr 2011 12:48:53 +1100
Subject: [PATCH] i2c-designware: mdelay use needs linux/delay.h inclusion

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/i2c/busses/i2c-designware-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 299e717..f87e25a 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -25,6 +25,7 @@
  * ----------------------------------------------------------------------------
  *
  */
+#include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
