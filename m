Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab0FVKAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:00:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53852 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0FVKAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rH/D1hFa/uD4iI2q/DpBuvVximRciG3A0nnm7wgnhOSS0YStdW/mIzrQC8eWHyMxfR
         J60jZid3XZqq9VydCT87CZdSDjRFqTmsPeLl0/5ESeKWr/j6A/xNP82TwdPzUo3I6Fas
         17oNVCIyBEFaBi1OD+OmBD14cK+ZUhWQyDHME=
Message-ID: <4C208865.5090002@gmail.com>
Date: Tue, 22 Jun 2010 17:54:45 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rtc-linux <rtc-linux@googlegroups.com>
Subject: [PATCH] RTC/m48t86: patch for use rtc_valid_tm to check returning
 tm.
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
 drivers/rtc/rtc-m48t86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m48t86.c b/drivers/rtc/rtc-m48t86.c
index 7c045cf..f981287 100644
--- a/drivers/rtc/rtc-m48t86.c
+++ b/drivers/rtc/rtc-m48t86.c
@@ -77,7 +77,7 @@ static int m48t86_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		if (ops->readbyte(M48T86_REG_HOUR) & 0x80)
 			tm->tm_hour += 12;

-	return 0;
+	return rtc_valid_tm(tm);
 }

 static int m48t86_rtc_set_time(struct device *dev, struct rtc_time *tm)
-- 
1.6.3.3
