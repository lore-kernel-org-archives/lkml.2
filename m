Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2KLRVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:21:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:34461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2KLRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:21:39 -0500
Message-ID: <50A12FF1.4000800@infradead.org>
Date: Mon, 12 Nov 2012 09:20:49 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] mfd: fix stmpe.c build when OF is not enabled
References: <20121112164431.8bcfe78d2a2ec73271733db4@canb.auug.org.au>
In-Reply-To: <20121112164431.8bcfe78d2a2ec73271733db4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors when CONFIG_OF is not enabled by including
<linux/of.h> (needs to be added in any case).
An alternative fix could be to make the driver depend on OF.

drivers/mfd/stmpe.c:1025:2: error: implicit declaration of function 'of_property_read_u32'
drivers/mfd/stmpe.c:1030:2: error: implicit declaration of function 'for_each_child_of_node'
drivers/mfd/stmpe.c:1030:36: error: expected ';' before '{' token

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/stmpe.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20121112.orig/drivers/mfd/stmpe.c
+++ linux-next-20121112/drivers/mfd/stmpe.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/of.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/mfd/core.h>
