Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1GPGJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 02:09:39 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:35227 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab1GPGJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 02:09:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACkqIU5tg2Sw/2dsb2JhbABTp3F4iHzCGA6GLASjPQ
Date: Sat, 16 Jul 2011 08:09:34 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Olaf Hering <olaf@aepfle.de>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: [GIT PULL REQUEST] watchdog - v3.0-rc7 - Fixes
Message-ID: <20110716060934.GS3834@infomag.iguana.be>
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

 drivers/watchdog/Kconfig |    1 -
 1 file changed, 1 deletion(-)

with these Changes:

Author: Olaf Hering <olaf@aepfle.de>
Date:   Fri Jul 15 23:23:33 2011 +0200

    watchdog: fix hpwdt Kconfig regression in 3.0-rc
    
    Remove Kconfig regression caused by commit
    a4616153deae053b29a2b7dd9ec4b2a225accfc5 "watchdog: hpwdt: build hpwdt as
    module by default with NMI_DECODING enabled"
    
    With the above change applied, hpwdt will be enabled unconditionally by just
    entering the Watchdog subscreen in menuconfig. Since this driver is not
    essential to boot any box it should remain disabled until it gets manually
    enabled, just like all other drivers.
    
    Signed-off-by: Olaf Hering <olaf@aepfle.de>
    Cc: Tony Camuso <tcamuso@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9536d38..c57419b 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -600,7 +600,6 @@ config IT87_WDT
 config HP_WATCHDOG
 	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
 	depends on X86
-	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
 	  will detect lockups and provide a stack trace. This is a driver that
