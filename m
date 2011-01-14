Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1ANIeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:34:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53361 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1ANId4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:33:56 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] include/gpio.h: remove remaining __must_check-annotiations
Date: Fri, 14 Jan 2011 09:34:29 +0100
Message-Id: <1294994069-11409-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110114010607.GA27486@kroah.com>
References: <20110114010607.GA27486@kroah.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5f829e405ec4e96f711165a4a7b55c271d4363e2 (gpiolib: add missing functions
to generic fallback) also introduced two.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---

Yes, that was an accident. We agreed to not include these patches. This fixup
makes the __must_check revert complete, but keeps the missing functions.

 include/linux/gpio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 4b47ed9..32720ba 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -35,13 +35,13 @@ static inline int gpio_request(unsigned gpio, const char *label)
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_request_one(unsigned gpio,
+static inline int gpio_request_one(unsigned gpio,
 					unsigned long flags, const char *label)
 {
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_request_array(struct gpio *array, size_t num)
+static inline int gpio_request_array(struct gpio *array, size_t num)
 {
 	return -ENOSYS;
 }
-- 
1.7.2.3

