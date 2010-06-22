Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab0FVJlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:41:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34569 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab0FVJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ajrPXTH+KYwE2L8lZXBAC9n8TCAga39vrDg4GV6DzrXVBoJ9WH3IhxyEntpd+xeNVG
         oiqYE976D+D7KqxCDauQZHY6uiA2jCs2ssVj2VKifsfwD78wQQpR05oBjiySgyc0hNvr
         YgRn/jGVC7gyRa4LY5wuvo3nR91r2fOvr25jU=
Message-ID: <4C208545.7030604@gmail.com>
Date: Tue, 22 Jun 2010 17:41:25 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Andrew Morton <akpm@linux-foundation.org>,
       rtc-linux <rtc-linux@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] RTC/m48t59: use rtc_valid_tm to check returning tm for m48t59
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to use rtc_valid_tm for checking
returning struct rtc_time *tm, it can avoid returning
wrong tm value.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/rtc/rtc-m48t59.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index be8359f..447f90f 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -105,7 +105,7 @@ static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	dev_dbg(dev, "RTC read time %04d-%02d-%02d %02d/%02d/%02d\n",
 		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return 0;
+	return rtc_valid_tm(tm);
 }

 static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -196,7 +196,7 @@ static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	dev_dbg(dev, "RTC read alarm time %04d-%02d-%02d %02d/%02d/%02d\n",
 		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return 0;
+	return rtc_valid_tm(tm);
 }

 /*
-- 
1.6.3.3
