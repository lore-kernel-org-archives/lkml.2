Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab1DGUXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 16:23:16 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:10124 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756909Ab1DGUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 16:23:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEkcnk1R8tNK/2dsb2JhbACmDXjBSg6FXwQ
Date: Thu, 7 Apr 2011 22:23:11 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [GIT PULL REQUEST] watchdog - v2.6.39-rc3
Message-ID: <20110407202311.GA29717@infomag.iguana.be>
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

 drivers/watchdog/mpc8xxx_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Peter Korsgaard <jacmet@sunsite.dk>
Date:   Wed Mar 30 15:48:22 2011 +0200

    watchdog: mpc8xxx_wdt: fix build
    
    Since 1c48a5c93da6313 (dt: Eliminate of_platform_{,un}register_driver)
    mpc8xxx_wdt no longer builds as it tries to refer to a 'match' variable
    rather than ofdev->dev.of_match that it checks just before.
    
    Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
    Acked-by: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 6709d72..528bceb 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -195,7 +195,7 @@ static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
 
 	if (!ofdev->dev.of_match)
 		return -EINVAL;
-	wdt_type = match->data;
+	wdt_type = ofdev->dev.of_match->data;
 
 	if (!freq || freq == -1)
 		return -EINVAL;
