Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2HCJKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:10:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:47017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2HCJKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192824348"
Date: Fri, 3 Aug 2012 17:10:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        joe@perches.com, isdn@linux-pingi.de, linux-kernel@vger.kernel.org
Subject: [PATCH v3] isdnloop: fix and simplify isdnloop_init()
Message-ID: <20120803091001.GA15772@localhost>
References: <20120802110543.GA21745@localhost>
 <20120802.162156.1853851468137303302.davem@davemloft.net>
 <20120803073240.GA12723@localhost>
 <20120803.015126.198679260163049459.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803.015126.198679260163049459.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a buffer overflow bug by removing the revision and printk.

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
 drivers/isdn/isdnloop/isdnloop.c |   12 ------------
 1 file changed, 12 deletions(-)

--- linux.orig/drivers/isdn/isdnloop/isdnloop.c	2012-08-03 16:39:08.543650310 +0800
+++ linux/drivers/isdn/isdnloop/isdnloop.c	2012-08-03 17:08:07.515691639 +0800
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
 
-static char *revision = "$Revision: 1.11.6.7 $";
 static char *isdnloop_id = "loop0";
 
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card");
@@ -1494,17 +1493,6 @@ isdnloop_addcard(char *id1)
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
-
 	if (isdnloop_id)
 		return (isdnloop_addcard(isdnloop_id));
 
