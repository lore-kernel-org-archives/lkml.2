Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0EGIZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:25:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0EGIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QomUxuRFyXVUcEVinlwXSK79NwvA10TLro/JullxAZTfpPbHjuKgQT2uAmamQ5oFTi
         j/Kp2u3rcS7gvNYIRd+79rBMRHeEw6EqfbEysygqsQ3tAVNiHIERFml0NVKiWFPRvUZq
         9wQOmQmGoPyrNBG2fcFDqhiSmYvIbxifef8to=
Date: Fri, 7 May 2010 10:25:39 +0200
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch] hrtimer: cleanup: remove unneeded assignment
Message-ID: <20100507082539.GO27064@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to store "base" anymore after cc584b213f25: "hrtimer:
convert kernel/* to the new hrtimer apis".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0086628..e13e514 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1096,11 +1096,10 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
  */
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
-	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	ktime_t rem;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
 	rem = hrtimer_expires_remaining(timer);
 	unlock_hrtimer_base(timer, &flags);
 
