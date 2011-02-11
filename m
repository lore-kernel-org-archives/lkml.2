Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1BKApX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:45:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43899 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1BKApW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:45:22 -0500
Date: Fri, 11 Feb 2011 11:45:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: build failure after merge of the i2c tree (arm tree
 interaction)
Message-Id: <20110211114514.67f377b9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

After merging the i2c tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/video/cyber2000fb.c:51:26: error: linux/i2c-id.h: No such file or directory

Caused by commit 06bc0fe05c62297e1db2979d591770459439866e ("i2c: Get rid
of <linux/i2c-id.h>") interacting with commit
8749b1ad69f91be1f5735563c7f235f802c7ea7d ("VIDEO: cyberpro: add I2C
support") from the arm tree.

I applied the following fix up patch for today.  Russell, this could be
applied in the arm tree as there is nothing relevant in that header file
even in Linus' tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 11 Feb 2011 11:41:35 +1100
Subject: [PATCH] VIDEO: cyberpro: remove obsolate include

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/cyber2000fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index 44db875..8503807 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -48,7 +48,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/i2c.h>
-#include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
 
 #include <asm/pgtable.h>
-- 
1.7.2.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
