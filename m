Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0ITSjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:39:24 -0400
Received: from [69.28.251.93] ([69.28.251.93]:38629 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab0ITSjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:39:23 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 20 Sep 2010 11:33:32 -0700
Subject: [PATCH] PM: Fix signed/unsigned warning
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Message-Id: <8136c24e8aaf577b86dfdfc40b0d01e6@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen on MIPS32, gcc 4.4.3, 2.6.36-rc4:

drivers/base/power/main.c: In function 'dpm_show_time':
drivers/base/power/main.c:415: warning: comparison of distinct pointer types lacks a cast

do_div() takes unsigned parameters:

uint32_t do_div(uint64_t *n, uint32_t base);

Using an unsigned variable for usecs64 should not cause any problems,
because calltime >= starttime .

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/base/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 276d5a7..db67719 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -407,7 +407,7 @@ static void pm_dev_err(struct device *dev, pm_message_t state, char *info,
 static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
 {
 	ktime_t calltime;
-	s64 usecs64;
+	u64 usecs64;
 	int usecs;
 
 	calltime = ktime_get();
-- 
1.7.0.4

