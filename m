Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1FIGCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:02:06 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:60797 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1FIGCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:02:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IWstdmUbBEN4A0uMN4P8yRiBqroeyXufyXFg2d5c30oSXkwjHF4pbJn7XJi7vau5Mt
         MGeblkgvsCY4/JL8zhD1g/hQJ6gcT9q8dy0HNL+/8Tmirtn1Chmg1MfrIK390kLw2e6Y
         BEmIy1QaI2pcKi9BJKF/S22502Lqh8BeNYqWM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: len.brown@intel.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:base:power:trace.c Add "UTC" Coordinated Universal Time to the printk.
Date: Wed,  8 Jun 2011 23:01:41 -0700
Message-Id: <1307599301-2524-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

sounds stupid, but taking a glance at the time, and seeing the wrong time, or what seemed 
wrong in dmesg, caused me to go into total check the time clock panic mode.. So the patch below adds:
"UTC" Coordinated Universal Time abreviation to the printk so people like me dont flip out over the time!

before:
[    0.114915] Time:  1:47:03  Date: 06/09/11

after:
[    0.114728] Time:  5:46:02 UTC Date: 06/09/11

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/base/power/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index c80e138..009f459 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -112,7 +112,7 @@ static unsigned int read_magic_time(void)
 	unsigned int val;
 
 	get_rtc_time(&time);
-	pr_info("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
+	pr_info("Time: %2d:%02d:%02d UTC Date: %02d/%02d/%02d\n",
 		time.tm_hour, time.tm_min, time.tm_sec,
 		time.tm_mon + 1, time.tm_mday, time.tm_year % 100);
 	val = time.tm_year;				/* 100 years */
-- 
1.7.5.2

