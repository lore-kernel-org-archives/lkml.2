Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1FYVOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:14:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18343 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1FYVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:14:09 -0400
Date: Sat, 25 Jun 2011 23:05:09 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: rtc-linux@googlegroups.com
cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Alexandre Rusev <source@mvista.com>,
        "George G. Davis" <gdavis@mvista.com>, source@mvista.com
Subject: [PATCH] rtc: Check return value of twl_rtc_write_u8() in
 twl_rtc_set_time()
Message-ID: <alpine.LNX.2.00.1106252300490.23991@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/rtc/rtc-twl.c:twl_rtc_set_time() we forget to save the
return value of the call to
twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
in 'ret', making the test of 'ret < 0' dead code since 'ret' then
couldn't possibly have changed since the last test just a few lines
above. It also makes us not detect failures from that specific
twl_rtc_write_u8() call.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/rtc/rtc-twl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index f9a2799..9a81f77 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -275,7 +275,7 @@ static int twl_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		goto out;
 
 	save_control &= ~BIT_RTC_CTRL_REG_STOP_RTC_M;
-	twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out;
 
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

