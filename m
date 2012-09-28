Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033406Ab2I1V7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:59:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031634Ab2I1UWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 005/218] isdnloop: fix and simplify isdnloop_init()
Date: Fri, 28 Sep 2012 13:13:42 -0700
Message-Id: <20120928201501.884195466@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Wu Fengguang <fengguang.wu@intel.com>

[ Upstream commit 77f00f6324cb97cf1df6f9c4aaeea6ada23abdb2 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/isdnloop/isdnloop.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
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
 


