Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2EDVmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:42:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:59614 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2EDVmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:42:53 -0400
Date: Fri, 4 May 2012 23:42:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT pull] timers: fixes for 3.4
Message-ID: <alpine.LFD.2.02.1205042341460.6271@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Thanks,

	tglx

------------------>
John Stultz (1):
      rtc: Fix possible null pointer dereference in rtc-mpc5121.c


 drivers/rtc/rtc-mpc5121.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 42f5f82..029e421 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -360,12 +360,11 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
-	rtc->rtc->uie_unsupported = 1;
-
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
 	}
+	rtc->rtc->uie_unsupported = 1;
 
 	return 0;
 
