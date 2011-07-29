Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1G2FZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 01:25:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55429 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1G2FZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 01:25:36 -0400
Date: Fri, 29 Jul 2011 15:25:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729152533.73329e8bafd4e839e85f0555@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/rc/ir-raw.c: In function 'init_decoders':
drivers/media/rc/ir-raw.c:354:2: error: implicit declaration of function 'request_module'

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 15:21:27 +1000
Subject: [PATCH] ir-raw.c: include modules .h for request_module

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/rc/ir-raw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 56adca8..ba817d2 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -14,7 +14,7 @@
 
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/freezer.h>
 #include "rc-core-priv.h"
-- 
1.7.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
