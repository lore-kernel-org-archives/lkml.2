Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0KDI4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:56:05 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:36936 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0KDI4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:56:03 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] delay.h: add __must_check to msleep_interruptible
Date: Thu,  4 Nov 2010 10:55:41 +0200
Message-Id: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code calling msleep_interruptible() must be aware that sleep time might be
shorter than intended as a result of a signal being caught. Code not checking
the return value of msleep_interruptible() is probably buggy, unless it's doing
the signal_pending() check itself, which is redundant.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 include/linux/delay.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..1be4994 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -44,7 +44,7 @@ static inline void ndelay(unsigned long x)
 extern unsigned long lpj_fine;
 void calibrate_delay(void);
 void msleep(unsigned int msecs);
-unsigned long msleep_interruptible(unsigned int msecs);
+unsigned long __must_check msleep_interruptible(unsigned int msecs);
 void usleep_range(unsigned long min, unsigned long max);
 
 static inline void ssleep(unsigned int seconds)
-- 
1.7.2.3

