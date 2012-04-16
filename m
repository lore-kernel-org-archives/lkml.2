Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab2DPEp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 00:45:59 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:53641 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2DPEp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 00:45:58 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 00:45:58 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGVgRRNgIFFgsCCwMCAQIBSwEMCAEBtCSKGIEvjhOBGASpJYE4Fg
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174532466"
Message-ID: <4F8BA1C1.4030804@teksavvy.com>
Date: Mon, 16 Apr 2012 00:36:17 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org
Subject: [REGRESSION] rtc/interface.c: kills suspend-to-ram
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something recent has killed suspend-to-ram on a number of machines here.
The symptom is that they suspend, but immediately wake up and panic,
with just a black screen so no visible messages to go by.

The patch below works around the issue -- making things work as they used to work.

--- linux/drivers/rtc/interface.c.orig	2012-04-16 00:08:47.615389718 -0400
+++ linux/drivers/rtc/interface.c	2012-04-16 00:09:14.105387382 -0400
@@ -773,7 +773,7 @@
 	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
 		return;

-	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
+	//rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
 }

 /**


Last known working kernel was 3.2.11.
The line above got added somewhere between it and 3.2.15,
and is also present (no surprise) in newer kernels.

The highest kernel I've tested for this is 3.3.2,
which also fails until I nuke the line shown above.

This is straight x86_64 (Atom) hardware, using rtc-cmos.
I can re-test if anyone has a fix for this.

Meanwhile, whatever patch put this into -stable probably
ought to be reverted upstream and in -stable as well.

Cheers

