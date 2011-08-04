Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1HDAIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:08:48 -0400
Received: from plexity.net ([206.123.115.38]:37812 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab1HDAIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:08:41 -0400
Date: Wed, 3 Aug 2011 17:00:46 -0700
From: Deepak Saxena <dsaxena@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, patches@linaro.org
Subject: [PATCH] Remove CLOCK_TICK_RATE from ACTHZ definition
Message-ID: <20110804000046.GA23503@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per https://lkml.org/lkml/2011/2/21/323, we remove
CLOCK_TICK_RATE from the definition of ACTHZ as the
majority of CLOCK_TICK_RATE values are no longer valid
or needed for proper operation of the time code.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
---
 include/linux/jiffies.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index f97672a..d232f00 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -55,7 +55,7 @@
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
-#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
+#define ACTHZ (HZ << 8)
 
 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
-- 
1.7.4.1

