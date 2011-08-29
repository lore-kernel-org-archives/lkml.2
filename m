Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1H2UzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:55:05 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:34674 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755106Ab1H2UzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:55:01 -0400
Date: Mon, 29 Aug 2011 13:54:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging: fix rtl8192e build errors
Message-Id: <20110829135459.d4090a39.rdunlap@xenotime.net>
In-Reply-To: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
References: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

drivers/staging/rtl8192e/rtllib.h:2329: error: field 'wx_sem' has incomplete type
drivers/staging/rtl8192e/rtllib.h:2330: error: field 'scan_sem' has incomplete type
drivers/staging/rtl8192e/rtllib.h:2331: error: field 'ips_sem' has incomplete type
drivers/staging/rtl8192e/rtllib_wx.c:267: error: implicit declaration of function 'down'
drivers/staging/rtl8192e/rtllib_wx.c:290: error: implicit declaration of function 'up'
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/rtl8192e/rtllib.h |    1 +
 1 file changed, 1 insertion(+)

but the driver probably should be using mutexes instead of semaphores...

--- linux-next-20110829.orig/drivers/staging/rtl8192e/rtllib.h
+++ linux-next-20110829/drivers/staging/rtl8192e/rtllib.h
@@ -31,6 +31,7 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/semaphore.h>
 
 #include <linux/delay.h>
 #include <linux/wireless.h>
