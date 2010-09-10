Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0IJHLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:11:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:37680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab0IJHLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:11:40 -0400
Subject: [PATCH] HPET: fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, Clemens Ladisch <clemens@ladisch.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 12:39:31 +0530
Message-ID: <1284102571.5280.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed following style problems:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
ERROR: code indent should use tabs where possible
ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/hpet.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index a0a1829..ebea5c8 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -31,12 +31,12 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 #include <linux/clocksource.h>
+#include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 
@@ -79,13 +79,13 @@ static cycle_t read_hpet(struct clocksource *cs)
 }
 
 static struct clocksource clocksource_hpet = {
-        .name           = "hpet",
-        .rating         = 250,
-        .read           = read_hpet,
-        .mask           = CLOCKSOURCE_MASK(64),
-	.mult		= 0, /* to be calculated */
-        .shift          = 10,
-        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+	.name		= "hpet",
+	.rating		= 250,
+	.read		= read_hpet,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 0,		/* to be calculated */
+	.shift		= 10,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 static struct clocksource *hpet_clocksource;
 #endif
@@ -781,7 +781,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	struct hpets *hpetp;
 	size_t siz;
 	struct hpet __iomem *hpet;
-	static struct hpets *last = NULL;
+	static struct hpets *last;
 	unsigned long period;
 	unsigned long long temp;
 	u32 remainder;
-- 
1.7.2.2



