Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822Ab2HBECF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 00:02:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:60355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2HBECD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 00:02:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192300549"
Date: Thu, 2 Aug 2012 12:01:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] isdnloop: fix and simplify isdnloop_init()
Message-ID: <20120802040158.GA11860@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the non-sense isdnloop revision transform code, so as to fix:

[   22.016214] isdnloop-ISDN-driver Rev 1.11.6.7 
[   22.097508] isdnloop: (loop0) virtual card added
[   22.174400] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff83244972
[   22.174400] 
[   22.436157] Pid: 1, comm: swapper Not tainted 3.5.0-bisect-00018-gfa8bbb1-dirty #129
[   22.624071] Call Trace:
[   22.720558]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
[   22.815248]  [<ffffffff8222b623>] panic+0x110/0x329
[   22.914330]  [<ffffffff83244972>] ? isdnloop_init+0xaf/0xb1
[   23.014800]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
[   23.090763]  [<ffffffff8108e24b>] __stack_chk_fail+0x2b/0x30
[   23.185748]  [<ffffffff83244972>] isdnloop_init+0xaf/0xb1

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/isdn/isdnloop/isdnloop.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- linux.orig/drivers/isdn/isdnloop/isdnloop.c	2012-05-24 19:03:06.748430938 +0800
+++ linux/drivers/isdn/isdnloop/isdnloop.c	2012-08-02 11:57:16.806437909 +0800
@@ -16,7 +16,7 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
 
-static char *revision = "$Revision: 1.11.6.7 $";
+static char *revision = "1.11.6.7";
 static char *isdnloop_id = "loop0";
 
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card");
@@ -1494,16 +1494,7 @@ isdnloop_addcard(char *id1)
 static int __init
 isdnloop_init(void)
 {
-	char *p;
-	char rev[10];
-
-	if ((p = strchr(revision, ':'))) {
-		strcpy(rev, p + 1);
-		p = strchr(rev, '$');
-		*p = 0;
-	} else
-		strcpy(rev, " ??? ");
-	printk(KERN_NOTICE "isdnloop-ISDN-driver Rev%s\n", rev);
+	printk(KERN_NOTICE "isdnloop-ISDN-driver Rev %s\n", revision);
 
 	if (isdnloop_id)
 		return (isdnloop_addcard(isdnloop_id));
