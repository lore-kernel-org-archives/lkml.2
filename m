Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0ECJFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:05:23 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:28582 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab0ECJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:05:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKot3ktbstD1/2dsb2JhbACdIHK5Og6FBAQ
Date: Mon, 3 May 2010 11:05:17 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: watchdog: ep93xx_wdt.c - fix module-param-desc.
Message-ID: <20100503090517.GA25865@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/ep93xx_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon May 3 08:58:56 2010 +0000

    watchdog: ep93xx_wdt.c fix default timout value in MODULE_PARM_DESC string.
    
    The WATCHDOG_TIMEOUT macro does not exist. The default timeout value is WDT_TIMEOUT.
    Fix the MODULE_PARM_DESC so that the code can compile again.
    
    reported-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 88ed54e..59359c9 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -244,7 +244,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
 	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
-				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+				__MODULE_STRING(WDT_TIMEOUT) ")");
 
 MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
 		"Alessandro Zummo <a.zummo@towertech.it>");
