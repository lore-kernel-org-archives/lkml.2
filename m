Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0FXJGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:06:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35547 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0FXJGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:06:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=E9hgCssWi6kt8zC1ThpWW1Kkq4yqdrav80aoPNpcasbawsLEOb2Wp22nB4oMZt053p
         rVhkz0L0YHDPGLugsAfDIO91KsAt94whZg/5hGYZXlCAyXyLP417AA+sYshgyeOAr1Bh
         kdyv5l/YI+V76sHsjdx7eH6qu8h4G92l9mnHk=
Message-ID: <4C231FF5.9090602@gmail.com>
Date: Thu, 24 Jun 2010 17:05:57 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rtc-linux <rtc-linux@googlegroups.com>
Subject: [PATCH 3/3] RTC/nuc900: fix build warning
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly,I am sorry for this patch, because I omit the warning
when I submit 'nuc900-rtc-change-the-waiting-for-device-ready-implement.patch'.
so I have to send a patch to fix it.

It is reported by Nuvoton test guys, thanks.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/rtc/rtc-nuc900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 0267ea3..62de66a 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -85,7 +85,7 @@ static irqreturn_t nuc900_rtc_interrupt(int irq, void *_rtc)

 static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
 {
-	unsigned int i, timeout = 0x1000;
+	unsigned int timeout = 0x1000;
 	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);

 	mdelay(10);
-- 
1.6.3.3
