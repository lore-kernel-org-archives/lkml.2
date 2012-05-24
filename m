Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab2EXXx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:53:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab2EXXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:53:54 -0400
Date: Thu, 24 May 2012 16:53:33 -0700
From: tip-bot for Magnus Damm <magnus.damm@gmail.com>
Message-ID: <tip-e5400321a6f15ce0fe77c8455954f213ef7dcc54@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au, hpa@zytor.com,
        mingo@kernel.org, damm@opensource.se, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, horms@verge.net.au,
        linux-kernel@vger.kernel.org, damm@opensource.se, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20120509143934.27521.46553.sendpatchset@w520>
References: <20120509143934.27521.46553.sendpatchset@w520>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Make clockevents_config()
  a global symbol
Git-Commit-ID: e5400321a6f15ce0fe77c8455954f213ef7dcc54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 16:53:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5400321a6f15ce0fe77c8455954f213ef7dcc54
Gitweb:     http://git.kernel.org/tip/e5400321a6f15ce0fe77c8455954f213ef7dcc54
Author:     Magnus Damm <magnus.damm@gmail.com>
AuthorDate: Wed, 9 May 2012 23:39:34 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 May 2012 01:44:51 +0200

clockevents: Make clockevents_config() a global symbol

Make clockevents_config() into a global symbol to allow it to be used
by compiled-in clockevent drivers. This is needed by drivers that want
to update the timer frequency after registration time.

Signed-off-by: Magnus Damm <damm@opensource.se>
Tested-by: Simon Horman <horms@verge.net.au>
Cc: arnd@arndb.de
Cc: johnstul@us.ibm.com
Cc: rjw@sisk.pl
Cc: lethal@linux-sh.org
Cc: gregkh@linuxfoundation.org
Cc: olof@lixom.net
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20120509143934.27521.46553.sendpatchset@w520
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h |    1 +
 kernel/time/clockevents.c  |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 81e803e..acba8943 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -132,6 +132,7 @@ extern u64 clockevent_delta2ns(unsigned long latch,
 			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
+extern void clockevents_config(struct clock_event_device *dev, u32 freq);
 extern void clockevents_config_and_register(struct clock_event_device *dev,
 					    u32 freq, unsigned long min_delta,
 					    unsigned long max_delta);
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 9cd928f..7e1ce01 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -297,8 +297,7 @@ void clockevents_register_device(struct clock_event_device *dev)
 }
 EXPORT_SYMBOL_GPL(clockevents_register_device);
 
-static void clockevents_config(struct clock_event_device *dev,
-			       u32 freq)
+void clockevents_config(struct clock_event_device *dev, u32 freq)
 {
 	u64 sec;
 
