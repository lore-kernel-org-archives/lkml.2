Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab0FVJJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:09:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35180 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab0FVJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=U5sTtz9YMqa91MWX0fcOqRTSIT/ZkaWvsqEXtZYI8ThgZcHQsuoyWjjMp32hxspZpu
         B5zvutAR5ksuMz6J++3pXeXLg/LY6IAow/kVyYHH0RzHgZt0a+s0UGEea75/zIybqouo
         VJuV/7ykJ8/Ze30ocqp9i6Zkw5KP37gYJhFyQ=
Message-ID: <4C207DAF.7010200@gmail.com>
Date: Tue, 22 Jun 2010 17:09:03 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       rtc-linux <rtc-linux@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>, dale@farnsworth.org
Subject: [PATCH] RTC/max6900: use rtc_valid_tm to check returning tm for max6900
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rtc_valid_tm to check returning tm for max6900,
it can avoid returning wrong tm value.
---
 drivers/rtc/rtc-max6900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max6900.c b/drivers/rtc/rtc-max6900.c
index a4f6665..486142c 100644
--- a/drivers/rtc/rtc-max6900.c
+++ b/drivers/rtc/rtc-max6900.c
@@ -159,7 +159,7 @@ static int max6900_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
 		      bcd2bin(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
 	tm->tm_wday = bcd2bin(regs[MAX6900_REG_DW]);

-	return 0;
+	return rtc_valid_tm(tm);
 }

 static int max6900_i2c_clear_write_protect(struct i2c_client *client)
-- 
1.6.3.3
