Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2H2PTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:19:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:58306 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753764Ab2H2PTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:19:11 -0400
Date: Wed, 29 Aug 2012 17:19:09 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [GIT PULL REQUEST] watchdog - v3.6-rc3 Fixes
Message-ID: <20120829151909.GU27604@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It will fix a warning for watchdog-test.c and it will remove a duplicate
inlude of delay.h

This will update the following files:

 Documentation/watchdog/src/watchdog-test.c |    2 +-
 drivers/watchdog/da9052_wdt.c              |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

with these Changes:

commit 3e5531caffcc07b67452c4a8170ffb4c2bd1c9b7
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Tue Aug 7 15:14:12 2012 +0530

    watchdog: da9052: Remove duplicate inclusion of delay.h
    
    delay.h header file was included twice.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4b1c2f41c2dda158bb7a3dded70775a76b581995
Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Mon Jul 23 10:46:11 2012 -0700

    watchdog: fix watchdog-test.c build warning
    
    Fix compiler warning by making the function static:
    
    Documentation/watchdog/src/watchdog-test.c:34:6: warning: no previous prototype for 'term'
    
    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/src/watchdog-test.c b/Documentation/watchdog/src/watchdog-test.c
index 73ff5cc..3da8229 100644
--- a/Documentation/watchdog/src/watchdog-test.c
+++ b/Documentation/watchdog/src/watchdog-test.c
@@ -31,7 +31,7 @@ static void keep_alive(void)
  * or "-e" to enable the card.
  */
 
-void term(int sig)
+static void term(int sig)
 {
     close(fd);
     fprintf(stderr, "Stopping watchdog ticks...\n");
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index 3f75129..f7abbae 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -21,7 +21,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
-#include <linux/delay.h>
 
 #include <linux/mfd/da9052/reg.h>
 #include <linux/mfd/da9052/da9052.h>
