Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1LGRE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:04:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab1LGREY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:04:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:02 2011
Message-Id: <20111207165602.586998940@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:59 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>
Subject: [26/27] tick-broadcast: Stop active broadcast device when replacing it
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c1be84309c58b1e7c6d626e28fba41a22b364c3d upstream.

When a better rated broadcast device is installed, then the current
active device is not disabled, which results in two running broadcast
devices.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-broadcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -72,7 +72,7 @@ int tick_check_broadcast_device(struct c
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
 
-	clockevents_exchange_device(NULL, dev);
+	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);


