Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0FGP7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:59:12 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:38236 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134Ab0FGP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:59:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC20DExR9cCT/2dsb2JhbACeR3K/LA6FCQSLMw
Date: Mon, 7 Jun 2010 17:58:57 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [WATCHDOG] v2.6.35-rc3 patches
Message-ID: <20100607155857.GB3788@infomag.iguana.be>
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

 drivers/watchdog/wm8350_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Julia Lawall <julia@diku.dk>
Date:   Thu May 27 14:32:24 2010 +0200

    [PATCH 2/11] drivers/watchdog: Eliminate a NULL pointer dereference
    
    At the point of the call to dev_err, wm8350 is NULL.
    
    A simplified version of the semantic match that finds this problem is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r exists@
    expression E,E1;
    identifier f;
    statement S1,S2,S3;
    @@
    
    if ((E == NULL && ...) || ...)
    {
      ... when != if (...) S1 else S2
          when != E = E1
    * E->f
      ... when any
      return ...;
    }
    else S3
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 89dd7b0..b68d928 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -284,7 +284,7 @@ static int __devinit wm8350_wdt_probe(struct platform_device *pdev)
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 
 	if (!wm8350) {
-		dev_err(wm8350->dev, "No driver data supplied\n");
+		pr_err("No driver data supplied\n");
 		return -ENODEV;
 	}
 
