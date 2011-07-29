Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1G2FKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 01:10:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32834 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab1G2FKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 01:10:49 -0400
Date: Fri, 29 Jul 2011 15:10:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dan Carpenter <error27@gmail.com>, linux-input@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729151044.49f8bfdeeadb8edaf583f90d@canb.auug.org.au>
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

drivers/input/misc/kxtj9.c:644:1: warning: data definition has no type or storage class
drivers/input/misc/kxtj9.c:644:1: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
drivers/input/misc/kxtj9.c:644:1: warning: parameter names (without types) in function declaration
drivers/input/misc/kxtj9.c:649:12: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/input/misc/kxtj9.c:669:20: error: expected declaration specifiers or '...' before string constant
drivers/input/misc/kxtj9.c:669:1: warning: data definition has no type or storage class
drivers/input/misc/kxtj9.c:669:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/input/misc/kxtj9.c:669:20: warning: function declaration isn't a prototype
drivers/input/misc/kxtj9.c:670:15: error: expected declaration specifiers or '...' before string constant
drivers/input/misc/kxtj9.c:670:1: warning: data definition has no type or storage class
drivers/input/misc/kxtj9.c:670:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/input/misc/kxtj9.c:670:15: warning: function declaration isn't a prototype
drivers/input/misc/kxtj9.c:671:16: error: expected declaration specifiers or '...' before string constant
drivers/input/misc/kxtj9.c:671:1: warning: data definition has no type or storage class
drivers/input/misc/kxtj9.c:671:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/input/misc/kxtj9.c:671:16: warning: function declaration isn't a prototype
drivers/input/misc/kxtj9.c: In function 'kxtj9_init':
drivers/input/misc/kxtj9.c:660:1: warning: control reaches end of non-void function

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 15:06:46 +1000
Subject: [PATCH] kxtj9: explictly include module.h

since some of its facilities are used.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/input/misc/kxtj9.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/kxtj9.c b/drivers/input/misc/kxtj9.c
index c456f63..783597a 100644
--- a/drivers/input/misc/kxtj9.c
+++ b/drivers/input/misc/kxtj9.c
@@ -21,6 +21,7 @@
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/input/kxtj9.h>
 #include <linux/input-polldev.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
