Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab2EIOim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:38:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2EIOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:38:39 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, horms@verge.net.au, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, rjw@sisk.pl, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 09 May 2012 23:39:34 +0900
Message-Id: <20120509143934.27521.46553.sendpatchset@w520>
In-Reply-To: <20120509143926.27521.20342.sendpatchset@w520>
References: <20120509143926.27521.20342.sendpatchset@w520>
Subject: [PATCH 01/03] clockevents: Make clockevents_config() a global symbol
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Make clockevents_config() into a global symbol to allow it
to be used by compiled-in clockevent drivers. This is needed
by drivers that want to update the timer frequency after
registration time.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 include/linux/clockchips.h |    1 +
 kernel/time/clockevents.c  |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

--- 0001/include/linux/clockchips.h
+++ work/include/linux/clockchips.h	2012-05-09 22:43:41.000000000 +0900
@@ -132,6 +132,7 @@ extern u64 clockevent_delta2ns(unsigned
 			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
 
+extern void clockevents_config(struct clock_event_device *dev, u32 freq);
 extern void clockevents_config_and_register(struct clock_event_device *dev,
 					    u32 freq, unsigned long min_delta,
 					    unsigned long max_delta);
--- 0001/kernel/time/clockevents.c
+++ work/kernel/time/clockevents.c	2012-05-09 22:48:39.000000000 +0900
@@ -297,8 +297,7 @@ void clockevents_register_device(struct
 }
 EXPORT_SYMBOL_GPL(clockevents_register_device);
 
-static void clockevents_config(struct clock_event_device *dev,
-			       u32 freq)
+void clockevents_config(struct clock_event_device *dev, u32 freq)
 {
 	u64 sec;
 
