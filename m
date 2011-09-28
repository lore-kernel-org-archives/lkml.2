Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1I1IAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:00:10 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:40167 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1I1IAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:00:09 -0400
Date: Wed, 28 Sep 2011 18:00:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilan Elias <ilane@ti.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110928180005.7bf3b73645d7d73e30399e2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/nfc/nfcwilink.c:318:12: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/nfc/nfcwilink.c:340:15: error: expected declaration specifiers or '...' before string constant
drivers/nfc/nfcwilink.c:340:1: warning: data definition has no type or storage class
drivers/nfc/nfcwilink.c:340:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/nfc/nfcwilink.c:340:15: warning: function declaration isn't a prototype
drivers/nfc/nfcwilink.c:341:20: error: expected declaration specifiers or '...' before string constant
drivers/nfc/nfcwilink.c:341:1: warning: data definition has no type or storage class
drivers/nfc/nfcwilink.c:341:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/nfc/nfcwilink.c:341:20: warning: function declaration isn't a prototype
drivers/nfc/nfcwilink.c:342:16: error: expected declaration specifiers or '...' before string constant
drivers/nfc/nfcwilink.c:342:1: warning: data definition has no type or storage class
drivers/nfc/nfcwilink.c:342:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/nfc/nfcwilink.c:342:16: warning: function declaration isn't a prototype

Caused by commit 93aead46428d ("NFC: driver for TI shared transport")
from the wireless tree interacting with the module.h split up.

I applied the patch below for today (which should be applied to the
wireless tree).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 17:56:29 +1000
Subject: [PATCH] NFC: use of module facilities requires the inclusion of
 module.h

Otherwise the module.h split up produces this build failure:

drivers/nfc/nfcwilink.c:318:12: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/nfc/nfcwilink.c:340:15: error: expected declaration specifiers or '...' before string constant
drivers/nfc/nfcwilink.c:340:1: warning: data definition has no type or storage class
drivers/nfc/nfcwilink.c:340:1: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/nfc/nfcwilink.c:340:15: warning: function declaration isn't a prototype
drivers/nfc/nfcwilink.c:341:20: error: expected declaration specifiers or '...' before string constant
drivers/nfc/nfcwilink.c:341:1: warning: data definition has no type or storage class
drivers/nfc/nfcwilink.c:341:1: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/nfc/nfcwilink.c:341:20: warning: function declaration isn't a prototype
drivers/nfc/nfcwilink.c:342:16: error: expected declaration specifiers or '...' before string constant
drivers/nfc/nfcwilink.c:342:1: warning: data definition has no type or storage class
drivers/nfc/nfcwilink.c:342:1: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/nfc/nfcwilink.c:342:16: warning: function declaration isn't a prototype

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/nfc/nfcwilink.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 5b0f1ff..06c3642 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -27,6 +27,7 @@
  *
  */
 #include <linux/platform_device.h>
+#include <linux/module.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
 #include <net/nfc/nci_core.h>
-- 
1.7.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
