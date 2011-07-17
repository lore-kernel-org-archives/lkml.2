Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1GQPFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:05:55 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:14911 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755722Ab1GQPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:05:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHz5Ik5tg1I8/2dsb2JhbABSp3B4iH7BCQ6FT18Eoz0
Date: Sun, 17 Jul 2011 17:05:50 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Olaf Hering <olaf@aepfle.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.0-rc7 - Fixes
Message-ID: <20110717150550.GA10330@infomag.iguana.be>
References: <20110716060934.GS3834@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716060934.GS3834@infomag.iguana.be>
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

 drivers/watchdog/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

with these Changes:

Author: Randy Dunlap <rdunlap@xenotime.net>
Date:   Sat Jul 16 12:25:49 2011 -0700

    watchdog: hpwdt depends on PCI
    
    hpwdt is a PCI driver so it should depend on PCI.
    Fixes these build errors:
    
    drivers/watchdog/hpwdt.c:762: error: implicit declaration of function 'pci_iomap'
    drivers/watchdog/hpwdt.c:762: warning: assignment makes pointer from integer without a cast
    drivers/watchdog/hpwdt.c:797: error: implicit declaration of function 'pci_iounmap'
    
    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>

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
index 9536d38..21d816e 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -599,8 +599,7 @@ config IT87_WDT
 
 config HP_WATCHDOG
 	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
-	depends on X86
-	default m
+	depends on X86 && PCI
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
 	  will detect lockups and provide a stack trace. This is a driver that
