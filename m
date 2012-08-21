Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2HULNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:13:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36838 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2HULNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:13:18 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] staging/vme: Use pr_ printks in vme_pio2_core.c
Date: Tue, 21 Aug 2012 20:13:09 +0900
Message-Id: <1345547590-13464-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120817074644.GL4559@mwanda>
References: <20120817074644.GL4559@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed,

-WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

and added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_pio2_core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index 4bf8e05..dad8281 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -10,6 +10,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -163,15 +165,13 @@ static int __init pio2_init(void)
 	int retval = 0;
 
 	if (bus_num == 0) {
-		printk(KERN_ERR "%s: No cards, skipping registration\n",
-			driver_name);
+		pr_err("No cards, skipping registration\n");
 		goto err_nocard;
 	}
 
 	if (bus_num > PIO2_CARDS_MAX) {
-		printk(KERN_ERR
-			"%s: Driver only able to handle %d PIO2 Cards\n",
-			driver_name, PIO2_CARDS_MAX);
+		pr_err("Driver only able to handle %d PIO2 Cards\n",
+		       PIO2_CARDS_MAX);
 		bus_num = PIO2_CARDS_MAX;
 	}
 
-- 
1.7.9.5

