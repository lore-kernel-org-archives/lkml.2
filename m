Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2DZMoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:44:09 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40471 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756534Ab2DZMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:44:07 -0400
Date: Thu, 26 Apr 2012 14:44:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: [GIT PULL REQUEST] watchdog - v3.4-rc4 Fixes
Message-ID: <20120426124402.GJ6553@spo001.leaseweb.com>
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

It will fix the size when reading or writing to WD Timer port 0x72 in the
hpwdt driver.

This will update the following files:

 hpwdt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

with these Changes:

commit d08c9a33b4aa6665b0ee3c4d1b57715fa0eae2a2
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Tue Apr 3 05:37:01 2012 +0000

    hpwdt: Only BYTE reads/writes to WD Timer port 0x72
    
    This patch is to correct the use of the iLO port 0x72 usage.
    The port 0x72 is a byte size write/read and hpwdt is currently
    writing a WORD.
    
    Signed-off by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index cbc7cee..9f13b89 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -435,16 +435,16 @@ static void hpwdt_start(void)
 {
 	reload = SECS_TO_TICKS(soft_margin);
 	iowrite16(reload, hpwdt_timer_reg);
-	iowrite16(0x85, hpwdt_timer_con);
+	iowrite8(0x85, hpwdt_timer_con);
 }
 
 static void hpwdt_stop(void)
 {
 	unsigned long data;
 
-	data = ioread16(hpwdt_timer_con);
+	data = ioread8(hpwdt_timer_con);
 	data &= 0xFE;
-	iowrite16(data, hpwdt_timer_con);
+	iowrite8(data, hpwdt_timer_con);
 }
 
 static void hpwdt_ping(void)
